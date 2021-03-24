Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE026348444
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 23:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238679AbhCXV7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 17:59:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21801 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238687AbhCXV7f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Mar 2021 17:59:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616623175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sFzpylW/Ivr5aQk5H1g6AKbksqO6a0byFVS5ZXBUDgI=;
        b=EeDseClgFOLiBsFO884sYYDYpVsVrftSLPfI6g98me5YgAF2TFDXpjgv7H8OfCt1JOlpEd
        zy5xiik7trHmiJkLQOZvauUAt17E0KGBsgxWP7Xdsd8jA0QK23USjUetiHB6W2UXI1ZQQV
        gZX3WQcItrNBt3lcNhQGdV1aqB0Hcf4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-SMVpJprcNwWZsIHZSTX_Ng-1; Wed, 24 Mar 2021 17:59:33 -0400
X-MC-Unique: SMVpJprcNwWZsIHZSTX_Ng-1
Received: by mail-wr1-f70.google.com with SMTP id z17so1629417wrv.23
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 14:59:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sFzpylW/Ivr5aQk5H1g6AKbksqO6a0byFVS5ZXBUDgI=;
        b=kkisfVHDGo0tGbwxcbmqgo+hR7GsU6l2+YsbgKkKbkmBIc/BTT3AcEsG6haOvhWmPV
         CUDIJEDjJY+m9qpbqmSbTqfxi4+8iP9d/cdUgcuf2ooizCXmXvuCbFv2l6pGt1bJI+oF
         4aTWI8nx4ynNnVCyu4iL00DTzUn3OjyC/Q9/por5fsAjcopw74WnTYm93BddL0oGwBrL
         ymQdxjmNnIznYXveXmKK1AvA7YCRiiLIsgLZh//cyfQ6n4XdfjdXgQzVN/nzi+3ySt+z
         +d00rPTTJqdGiAkluYfGKNN3LUq5yonQRm/F83gLJuG6VHXe3D+Scuf4SS7fNORmqiN8
         XqPw==
X-Gm-Message-State: AOAM5327px1lOO6z6b+M/8qYmnONRyywI3d7xrnkUMtC2IAjzergR03y
        aEXbn5Zs6x+ZffE5cqZnFMvMFVvj+iFFiIrcJ4OU/v7sRIn86WsPssQFO6HTney+0ViV79iOdM2
        VoZVTJ/6yC4eY
X-Received: by 2002:a5d:554b:: with SMTP id g11mr5433794wrw.411.1616623172162;
        Wed, 24 Mar 2021 14:59:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDhLDhqcEk8qPr6PRDCmGSFYoDEToCC8z/2B0+32YuAGUBVFwbT+VHVtEM+Wwt5nFZgpHW4A==
X-Received: by 2002:a5d:554b:: with SMTP id g11mr5433774wrw.411.1616623172001;
        Wed, 24 Mar 2021 14:59:32 -0700 (PDT)
Received: from [192.168.1.124] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id c2sm3649441wme.15.2021.03.24.14.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 14:59:31 -0700 (PDT)
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
To:     Borislav Petkov <bp@alien8.de>, Babu Moger <babu.moger@amd.com>,
        Hugh Dickins <hughd@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <78cc2dc7-a2ee-35ac-dd47-8f3f8b62f261@redhat.com>
 <d7c6211b-05d3-ec3f-111a-f69f09201681@amd.com>
 <20210311200755.GE5829@zn.tnic> <20210311203206.GF5829@zn.tnic>
 <2ca37e61-08db-3e47-f2b9-8a7de60757e6@amd.com>
 <20210311214013.GH5829@zn.tnic>
 <d3e9e091-0fc8-1e11-ab99-9c8be086f1dc@amd.com>
 <4a72f780-3797-229e-a938-6dc5b14bec8d@amd.com>
 <20210311235215.GI5829@zn.tnic>
 <ed590709-65c8-ca2f-013f-d2c63d5ee0b7@amd.com>
 <20210324212139.GN5010@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <feabccbb-8e0f-83b0-64a7-b5e1988c4559@redhat.com>
Date:   Wed, 24 Mar 2021 22:59:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210324212139.GN5010@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/03/21 22:21, Borislav Petkov wrote:
>  	if (kaiser_enabled)
>   		invpcid_flush_one(X86_CR3_PCID_ASID_USER, addr);
> +	else
> +		asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
> +
>   	invpcid_flush_one(X86_CR3_PCID_ASID_KERN, addr);
>   }

I think the kernel ASID flush can also be moved under the "if"?

> and the reason why it does, IMHO, is because on AMD, kaiser_enabled is
> false because AMD is not affected by Meltdown, which means, there's no
> user/kernel pagetables split.
> 
> And that also means, you have global TLB entries which means that if you
> look at that __native_flush_tlb_single() function, it needs to flush
> global TLB entries on CPUs with X86_FEATURE_INVPCID_SINGLE by doing an
> INVLPG in the kaiser_enabled=0 case. Errgo, the above hunk.

Makes sense.

Paolo

