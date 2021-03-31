Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB59F34FAD5
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 09:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234107AbhCaHww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 03:52:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40072 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234095AbhCaHwi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 03:52:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617177158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pQ5Qm7wzrETleGdIZygb6hZggBdQLM72Jyc7tGd4rCA=;
        b=Pb3MkZ12nIe29/GyrQ+y0lVTcOrMgo2tE3vlLkV3c/ihfKSnePv8774ZAXxRdPr+7GnsGf
        XXadNkkv7SvdOV27vfK5ejdf/j7kaA8JH+L3uvlDRhCIbMxUVrsifa3/b/U8i6x4G0WdGe
        YbljWw7v2BsVSyCfU5+LH/r2sHrkPs8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-dsW5IM3_NFu7lf5Qph7xwA-1; Wed, 31 Mar 2021 03:52:36 -0400
X-MC-Unique: dsW5IM3_NFu7lf5Qph7xwA-1
Received: by mail-wr1-f70.google.com with SMTP id s10so569134wre.0
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 00:52:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pQ5Qm7wzrETleGdIZygb6hZggBdQLM72Jyc7tGd4rCA=;
        b=Uj/q6Oy/c7Wu3ls3N6wrACvNXcjXawTk1+tujMQJZTHhG4nxErXPF73s2B3ZTVKIbP
         SydE1/AMSY19CESjmOt48gwy3AKzjGkg2KBi95KiSTZCmBDr2l8Hg0euUNuWhUO4kxTC
         zYNSP/4Heq4eZA0TtbWaH/b7uRE0pTzEWVXlr+/Hd8OetW97v56qA/GVaCKWN5WAyQ+E
         bAi6NZ2ixLUGK72+oxur+Qd+c79WgwGsUjaV6HBrfRgiMfPlvZM/x2krTlSMt71p2vlz
         46JW40LALQy2DU7NSD8aDXhcnxKNa5hYvT0mX8fZcumznSHLi9LTMxbIQiCXR1ir4u3Y
         JwCQ==
X-Gm-Message-State: AOAM531OW5w2pqiwesGQqpWFMIiI8UvBsyzcRxAGJQ5+ubjWpHap2Xu/
        j9EbrRMNwTqBkqEX/EMGX6f3nGBQa+CmZDeTvOLdMz/4+SNuip4s/SCouv/OZBtT076Pg0s26qR
        8PknVPjCcDl0k
X-Received: by 2002:a1c:dfc1:: with SMTP id w184mr1947743wmg.21.1617177155317;
        Wed, 31 Mar 2021 00:52:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrEJ16pEEpfSd4UOjbnqA+7pbiSAPPFNpTAPEwcpv0H2fU5p4zyKOS02szcKvl3Y4jdrVOKQ==
X-Received: by 2002:a1c:dfc1:: with SMTP id w184mr1947732wmg.21.1617177155168;
        Wed, 31 Mar 2021 00:52:35 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id b17sm2793386wrt.17.2021.03.31.00.52.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 00:52:33 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-11-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 10/18] KVM: Move x86's MMU notifier memslot walkers to
 generic code
Message-ID: <ba3f7a9c-0b59-cbeb-5d46-4236cde2c51f@redhat.com>
Date:   Wed, 31 Mar 2021 09:52:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210326021957.1424875-11-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/03/21 03:19, Sean Christopherson wrote:
> +#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
> +	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
> +#else
>   	struct kvm *kvm = mmu_notifier_to_kvm(mn);
>   	int idx;
>  	trace_kvm_set_spte_hva(address);
>  
> 	idx = srcu_read_lock(&kvm->srcu);
> 
> 	KVM_MMU_LOCK(kvm);
> 
> 	kvm->mmu_notifier_seq++;
> 
> 	if (kvm_set_spte_hva(kvm, address, pte))
> 		kvm_flush_remote_tlbs(kvm);
> 
>   	KVM_MMU_UNLOCK(kvm);
>   	srcu_read_unlock(&kvm->srcu, idx);
> +#endif

The kvm->mmu_notifier_seq is missing in the new API side.  I guess you 
can add an argument to __kvm_handle_hva_range and handle it also in 
patch 15 ("KVM: Take mmu_lock when handling MMU notifier iff the hva 
hits a memslot").

Paolo

