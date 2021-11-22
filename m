Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683F0458F83
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 14:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239117AbhKVNjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 08:39:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30855 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239411AbhKVNjB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 08:39:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637588154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=602lNvVOZar2m+HSFbxBYiyDNXrGO+dVi/Ze/KZAj6g=;
        b=ZNDVdueQ4xrwWe5pXhJgvmseao91pgGi4k943MKsjUnPjFhJBevrarVBZ/Y/Ght0GUGvXk
        FmHMfDzufOBWB+sPHo6bKBVpkZ+lMUvw/XAK8svFtTb9U9RdnRxN1+r6M/Y5LPG17FVzoR
        9xfdcuB2bWSuUu1Z0DjXDXXh6biDfrs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-y_Nr2w3hNLSqyP6M-gDk0Q-1; Mon, 22 Nov 2021 08:35:53 -0500
X-MC-Unique: y_Nr2w3hNLSqyP6M-gDk0Q-1
Received: by mail-wm1-f72.google.com with SMTP id g11-20020a1c200b000000b003320d092d08so6810749wmg.9
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 05:35:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=602lNvVOZar2m+HSFbxBYiyDNXrGO+dVi/Ze/KZAj6g=;
        b=JqR/jFD9kcMN0ESRd9aWBwebjUXYLcCI+6hd4KgCGVDU1OQPfnUKDBR8dQXofo4iah
         cB2O9TLK2vrLHvAPDYhbX0WXdb5epkf3oaWtA1ETP34DkYH750RiiR/fAu3Wle+h6lIk
         YCKTyCVZ2wzeFF7sxebhWw484SBBO1noYWgk6MzWsdY9yYp0pA8Y5UxmwUO0GjOijrPR
         tG7kQPPC8PG2eoV/IbXJy03hWv3Ncn10fxCBm66JPHZ8Npkf33NCIZ2eMrRJyfszuAIv
         6DjXGUcEUgtVlH1vfPuwKnru5ITn8wm2LdQaqkE/mpApnfsklqzmxcTaEDqvKKM06KBv
         HGPA==
X-Gm-Message-State: AOAM531kTsT2lS2MzEpMKQaXYioA79xpwK/lKNH7rxyHmOglWti8Z0Hd
        kxBXLLE7n0Zo95shqhaToBNnqTOKipZrcw8iScsn3ZSfi5hWMCKMuHSomRDokKnMFaUccMQTHS4
        wijxTDUOmRKH+
X-Received: by 2002:adf:f042:: with SMTP id t2mr39515195wro.180.1637588151973;
        Mon, 22 Nov 2021 05:35:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw1uMKJXFglAoRaU5wdp0h6HMWbMcVgb35JuanaPUNLoA7JZ4ctjynARZIlt7KcqMq8Cl1Yqg==
X-Received: by 2002:adf:f042:: with SMTP id t2mr39515155wro.180.1637588151703;
        Mon, 22 Nov 2021 05:35:51 -0800 (PST)
Received: from [192.168.3.132] (p5b0c667b.dip0.t-ipconnect.de. [91.12.102.123])
        by smtp.gmail.com with ESMTPSA id m34sm24540329wms.25.2021.11.22.05.35.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 05:35:51 -0800 (PST)
Message-ID: <56c0dffc-5fc4-c337-3e85-a5c9ce619140@redhat.com>
Date:   Mon, 22 Nov 2021 14:35:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC v2 PATCH 01/13] mm/shmem: Introduce F_SEAL_GUEST
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        luto@kernel.org, john.ji@intel.com, susie.li@intel.com,
        jun.nakajima@intel.com, dave.hansen@intel.com, ak@linux.intel.com
References: <20211119134739.20218-1-chao.p.peng@linux.intel.com>
 <20211119134739.20218-2-chao.p.peng@linux.intel.com>
 <20211119151943.GH876299@ziepe.ca>
 <df11d753-6242-8f7c-cb04-c095f68b41fa@redhat.com>
 <20211119160023.GI876299@ziepe.ca>
 <4efdccac-245f-eb1f-5b7f-c1044ff0103d@redhat.com>
 <20211122133145.GQ876299@ziepe.ca>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20211122133145.GQ876299@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.11.21 14:31, Jason Gunthorpe wrote:
> On Mon, Nov 22, 2021 at 10:26:12AM +0100, David Hildenbrand wrote:
> 
>> I do wonder if we want to support sharing such memfds between processes
>> in all cases ... we most certainly don't want to be able to share
>> encrypted memory between VMs (I heard that the kernel has to forbid
>> that). It would make sense in the use case you describe, though.
> 
> If there is a F_SEAL_XX that blocks every kind of new access, who
> cares if userspace passes the FD around or not?
I was imagining that you actually would want to do some kind of "change
ownership". But yeah, the intended semantics and all use cases we have
in mind are not fully clear to me yet. If it's really "no new access"
(side note: is "access" the right word?) then sure, we can pass the fd
around.

-- 
Thanks,

David / dhildenb

