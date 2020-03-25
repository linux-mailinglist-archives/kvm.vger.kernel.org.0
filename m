Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A910A192DD5
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 17:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgCYQIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 12:08:44 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:31363 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727995AbgCYQIn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 12:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585152521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vfphBf+vjkSzhJhvCde/l7chxSmQk2uReg/TXiFfWng=;
        b=S9DKeJph2aWJv46KUi9gLK75p/wsvFSqg88VHaJ/eIm/2xkU5Hz3GDk5Ar8QOSnNmxEoto
        hdmgjwgUUIzuNdQNfG4LRuggWLKcKkyD71JeQ1BnwO6M4L2MYn4XjkESWhTdT+FVYaXbUe
        KQWhQGdjOAhQ+TwLB8YiXAn0uC3lri0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-t9MStvxiNc63wWVx3oMaLg-1; Wed, 25 Mar 2020 12:08:40 -0400
X-MC-Unique: t9MStvxiNc63wWVx3oMaLg-1
Received: by mail-wr1-f72.google.com with SMTP id i18so1349414wrx.17
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 09:08:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=vfphBf+vjkSzhJhvCde/l7chxSmQk2uReg/TXiFfWng=;
        b=iWNM3KWf150iMRwdqFW3/bX/j8kusBRlED8UeKJIAPcUe0E9QfNE8fpEDSCZzCN1AL
         cK5ddgr20NkEBc84bBtyRLAxWqUETP+WKMKNBCw4Zw485/8QrpQP75HzLvsbBbGYxFaS
         BYbqX6lLwidXR9GurQ87GLEKrOtKhvZekSF8m0vk6TpyZ1DG5EYtIWLh6YxyiGy1dw55
         W64AE1ccaE6Z9L6Ep6+r/ro6wL9MCigjWee77l2stneJT/MLcyLipF4PsI0DyMdJF36w
         +8MqRDjBoXbIG8s87ChnJKg2RqGlLGh6eCxwSrydjnJr6oKyNFgfGfc/8fzDbndD9DkZ
         XTkw==
X-Gm-Message-State: ANhLgQ18iDwbr6qAg1iGuNNRSLHzYG9IEqaRtAthaJ1TSFi+97IwEINe
        cacaVZXPRjP2fyvuil9HvpXk+0X4imxFUyHJWO6Igr3KYZh22dcBbx+2ysRwHWlhtuFyD4PcybQ
        fODl1/EnwA7Tc
X-Received: by 2002:a1c:2056:: with SMTP id g83mr4077001wmg.179.1585152518724;
        Wed, 25 Mar 2020 09:08:38 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vt1vQmYyxdMOvanIwshFspzKycfdmmorvdPIdzq83cEa+Mz+iF4pPrlksTXYIFEqrFsyU8N6Q==
X-Received: by 2002:a1c:2056:: with SMTP id g83mr4076966wmg.179.1585152518385;
        Wed, 25 Mar 2020 09:08:38 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u13sm18261628wru.88.2020.03.25.09.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 09:08:37 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 14/37] KVM: x86: Move "flush guest's TLB" logic to separate kvm_x86_ops hook
In-Reply-To: <9d1ef88c-2b68-58c5-c62e-8b123187e573@redhat.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com> <20200320212833.3507-15-sean.j.christopherson@intel.com> <87369w7mxe.fsf@vitty.brq.redhat.com> <9d1ef88c-2b68-58c5-c62e-8b123187e573@redhat.com>
Date:   Wed, 25 Mar 2020 17:08:35 +0100
Message-ID: <87ftdw5se4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 25/03/20 11:23, Vitaly Kuznetsov wrote:
>> What do you think about the following (very lightly
>> tested)?
>> 
>> commit 485b4a579605597b9897b3d9ec118e0f7f1138ad
>> Author: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Date:   Wed Mar 25 11:14:25 2020 +0100
>> 
>>     KVM: x86: make Hyper-V PV TLB flush use tlb_flush_guest()
>>     
>>     Hyper-V PV TLB flush mechanism does TLB flush on behalf of the guest
>>     so doing tlb_flush_all() is an overkill, switch to using tlb_flush_guest()
>>     (just like KVM PV TLB flush mechanism) instead. Introduce
>>     KVM_REQ_HV_TLB_FLUSH to support the change.
>>     
>>     Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> 
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 167729624149..8c5659ed211b 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -84,6 +84,7 @@
>>  #define KVM_REQ_APICV_UPDATE \
>>  	KVM_ARCH_REQ_FLAGS(25, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>  #define KVM_REQ_TLB_FLUSH_CURRENT	KVM_ARCH_REQ(26)
>> +#define KVM_REQ_HV_TLB_FLUSH		KVM_ARCH_REQ(27)
>>  
>>  #define CR0_RESERVED_BITS                                               \
>>  	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index a86fda7a1d03..0d051ed11f38 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -1425,8 +1425,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *current_vcpu, u64 ingpa,
>>  	 * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
>>  	 * analyze it here, flush TLB regardless of the specified address space.
>>  	 */
>> -	kvm_make_vcpus_request_mask(kvm,
>> -				    KVM_REQ_TLB_FLUSH | KVM_REQUEST_NO_WAKEUP,
>> +	kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH,
>>  				    vcpu_mask, &hv_vcpu->tlb_flush);
>>  
>
> Looks good, but why are you dropping KVM_REQUEST_NO_WAKEUP?

My bad, KVM_REQUEST_NO_WAKEUP needs to stay.

-- 
Vitaly

