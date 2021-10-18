Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CBC43258C
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 19:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhJRRxw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 13:53:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21603 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234253AbhJRRxr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 13:53:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634579496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4KlEWOaodMGxd0bVM96vQnIBKXe+NXBnU/Da+TbR1xQ=;
        b=WpaBHJ6iFRZ/RjaO+lldMhIIsZ7MTTDnTUk2yhpADXfHIIW5QWd3qqKMGKH0IcImPNevfG
        0YsAUdzPcoL/0alEjfwVC2bqJxNXO/W/fZ6aaOyGhYBIzxZhwlpil6h0yF6D6edPhcEv1o
        hl5bAQdDNgEmmljAenj9vJ5lEwCMkug=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-M81IeRQTPwCA446keSidaA-1; Mon, 18 Oct 2021 13:51:35 -0400
X-MC-Unique: M81IeRQTPwCA446keSidaA-1
Received: by mail-wm1-f72.google.com with SMTP id o196-20020a1ca5cd000000b0030dc197412aso16685wme.0
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 10:51:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4KlEWOaodMGxd0bVM96vQnIBKXe+NXBnU/Da+TbR1xQ=;
        b=sdzqDLs2W75QOQJHi3R70cKL7EUD3V95K4jSbcGVdsyT9L1cRJfawSsikD7nxVOr2+
         urtR1pbiuQ8E6ATOtIfZQWntTxrrVywC0op60xCiCFpiJDTimwfO9v9lJk4Gsw/pNhja
         qQzaKprW9g8SbqwEQY7LbeGPCcEN8Y54wbIaHLHbSd1XTknT3vGk7/L/zk7k/1AY31nf
         X38HtbfYiNx6dTafaA7P61uLb0jY+nanJY01BERSQRhSaZvHbgYRrb1CFXS7/8s6Oz4c
         JoH2lTp4sbElnj2CiZNZLdgNPAsUVmdRNmlo0iFfodh/hsXrXa5azBwbVnNifTwUNN0L
         jKlQ==
X-Gm-Message-State: AOAM533U5ExdPBv0wGtMlKoPO+u3Rz/sIVZrmg5g5N+zohcx+xrsjKld
        1xMXjuWYTpLIRBGOVGVDXhcIOuQ34HEvELy2TTKCzgWoBpIUdsu2KC4/sX58F0AQJdCmXK8Z4AL
        MyxULIXgTV24J
X-Received: by 2002:a05:600c:190a:: with SMTP id j10mr321899wmq.149.1634579493237;
        Mon, 18 Oct 2021 10:51:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJze+RhfCtXmvsWpRnAqg0T/wQ2AkegvQjJeDmvtPRwEsIO47UPMAp5GeUc3vtkWQ3pqtOvdZA==
X-Received: by 2002:a05:600c:190a:: with SMTP id j10mr321870wmq.149.1634579492960;
        Mon, 18 Oct 2021 10:51:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c3sm11793266wrw.66.2021.10.18.10.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 10:51:32 -0700 (PDT)
Message-ID: <083776a1-cec7-7a67-265b-a69e2a784cca@redhat.com>
Date:   Mon, 18 Oct 2021 19:51:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: x86/mmu: Set "shadow_root_alloced" accordingly when
 TDP is disabled
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211018174746.890616-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211018174746.890616-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/21 19:47, Sean Christopherson wrote:
> Explicitly check kvm_shadow_root_alloced() when short-circuiting shadow
> paging metadata allocations and skip setting "shadow_root_alloced" if and
> only if its already true, i.e. set it when short-circuiting because TDP is
> disabled.  This fixes a benign bug where KVM would always take
> slots_arch_lock when allocating a shadow root due to "shadow_root_alloced"
> never being set.
> 
> Opportunistically add comments to call out that not freeing successful
> allocations on failure is intentional, and that freeing on failure isn't
> straightforward so as to discourage incorrect cleanups in the future.
> 
> Fixes: 73f122c4f06f ("KVM: cleanup allocation of rmaps and page tracking data")
> Signed-off-by: Sean Christopherson<seanjc@google.com>
> ---
> 
> Essentially code review for "KVM: cleanup allocation of rmaps and page
> tracking data", which AFAICT didn't get posted (because it came in via a
> a merge?).

It didn't get posted because it is not merged yet - it's basically David 
Steven's v3 merged into kvm/queue for him to take a look at all the 
kvm/master and kvm/next juggling.  Thanks for looking at it already, 
I've squashed the fix in and will post it shortly.

Paolo

