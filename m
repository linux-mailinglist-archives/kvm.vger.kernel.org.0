Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E90142D59B
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 11:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhJNJDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 05:03:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230018AbhJNJDk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 05:03:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634202095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CodgdchH6jCzV7Xh4eUIWCnAZ5H+/ONb08evZGYFxDo=;
        b=fyt1acTHIjEAIN+/StRW8sOCuyKPlUgPJl26NaZWCIrbmKmorue37QmToOcrcVptJn+0DR
        MT5z65GTpLx1pYrR5cvMvg0Kr9Fn/qWV6uaWkCvmqeKWnsKf79gBq75UeNQVgAb+UMRSwm
        QECG0m3i9Y/d2BrO26tbJHLKWU9TlXI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-yCxwhollMvSPA0Z4U9RIDw-1; Thu, 14 Oct 2021 05:01:33 -0400
X-MC-Unique: yCxwhollMvSPA0Z4U9RIDw-1
Received: by mail-wr1-f70.google.com with SMTP id f1-20020a5d64c1000000b001611832aefeso4019913wri.17
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 02:01:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CodgdchH6jCzV7Xh4eUIWCnAZ5H+/ONb08evZGYFxDo=;
        b=fIRxQIYQL5bjLjyktyq0dzEzL/ACOG6tl8Lpkx3xfS6pjeI573iD7qiNy7QUxWs1HI
         3RtlW3vRawwEwyl6IsisTGOrne+euZNCrFGwo+a7fZxSzp29NvN4IE79kkSxet9C7xU1
         bLsJX/j3xyKvp1g6LoI47D63kBmHevjF2Huo2sKL1e70TtyYjxgZxOIo3yHjjBRHpDWI
         0f+1qscdMDYWWxKOSjTb2oSb+WYh3Rm1vtW6Ikj+d7vT0clbvsiWa0BPvXinz6jEgFiN
         CatLWTnS/434LQwWiA9tME9TIMvcwYeCxU/e8qcDnD1UKmFx030UCm3HYAK3c+cRU4sF
         zonw==
X-Gm-Message-State: AOAM531IUs1ZmuX4pZuxBdaPas/MqNWdYzjHK6XGTpymgUZGMhEyYxp/
        ftDL0lpaqagsynEYA/nlZ9ExAO2HIFdpwZnw61521jrgbLtHrAPt2uyU53LGzN2WRcc6ZtE/mZE
        6Ajqy9/GFOh84
X-Received: by 2002:a5d:6d81:: with SMTP id l1mr5186138wrs.110.1634202092582;
        Thu, 14 Oct 2021 02:01:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwm4mnKXmfpkUwNgvbwdjAarrLFRYIjyZcB0VxUDAECzZ5uqGAQuUi40Tao/ndBhbR3+6SAcw==
X-Received: by 2002:a5d:6d81:: with SMTP id l1mr5186104wrs.110.1634202092288;
        Thu, 14 Oct 2021 02:01:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id f3sm7325221wmb.12.2021.10.14.02.01.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 02:01:31 -0700 (PDT)
Message-ID: <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com>
Date:   Thu, 14 Oct 2021 11:01:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Content-Language: en-US
To:     "Liu, Jing2" <jing2.liu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
 <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/21 10:02, Liu, Jing2 wrote:
>> In principle I don't like it very much; it would be nicer to say "you
>> enable it for QEMU itself via arch_prctl(ARCH_SET_STATE_ENABLE), and for
>> the guests via ioctl(KVM_SET_CPUID2)".  But I can see why you want to
>> keep things simple, so it's not a strong objection at all.
> 
> Does this mean that KVM allocate 3 buffers via
> 1) Qemu's request, instead of via 2) guest XCR0 trap?

Based on the input from Andy and Thomas, the new way would be like this:

1) host_fpu must always be checked for reallocation in 
kvm_load_guest_fpu (or in the FPU functions that it calls, that depends 
on the rest of Thomas's patches).  That's because arch_prctl can enable 
AMX for QEMU at any point after KVM_CREATE_VCPU.

2) every use of vcpu->arch.guest_supported_xcr0 is changed to only 
include those dynamic-feature bits that were enabled via arch_prctl.
That is, something like:

static u64 kvm_guest_supported_cr0(struct kvm_vcpu *vcpu)
{
	return vcpu->arch.guest_supported_xcr0 &
		(~xfeatures_mask_user_dynamic | \
		 current->thread.fpu.dynamic_state_perm);
}

3) Even with passthrough disabled, the guest can run with XFD set to 
vcpu->arch.guest_xfd (and likewise for XFD_ERR) which is much simpler 
than trapping #NM.  The traps for writing XCR0 and XFD are used to 
allocate dynamic state for guest_fpu, and start the passthrough of XFD 
and XFD_ERR.  What we need is:

- if a dynamic state has XCR0[n]=0, bit n will never be set in XFD_ERR 
and the state will never be dirtied by the guest.

- if a dynamic state has XCR0[n]=1, but all enabled dynamic states have 
XFD[n]=1, the guest is not able to dirty any dynamic XSAVE state, 
because they all have either XCR0[n]=0 or XFD[n]=1.  An attempt to do so 
will cause an #NM trap and set the bit in XFD_ERR.

- if a dynamic state has XCR0[n]=1 and XFD[n]=0, the state for bit n is 
allocated in guest_fpu, and it can also disable the vmexits for XFD and 
XFD_ERR.

Therefore:

- if passthrough is disabled, the XCR0 and XFD write traps can check 
guest_xcr0 & ~guest_xfd.  If it includes a dynamic state bit, dynamic 
state is allocated for all bits enabled in guest_xcr0 and passthrough is 
started; this should happen shortly after the guest gets its first #NM 
trap for AMX.

- if passthrough is enabled, the XCR0 write trap must still ensure that 
dynamic state is allocated for all bits enabled in guest_xcr0.

So something like this pseudocode is called by both XCR0 and XFD writes:

int kvm_alloc_fpu_dynamic_features(struct kvm_vcpu *vcpu)
{
	u64 allowed_dynamic = current->thread.fpu.dynamic_state_perm;
	u64 enabled_dynamic =
		vcpu->arch.xcr0 & xfeatures_mask_user_dynamic;

	/* All dynamic features have to be arch_prctl'd first.  */
	WARN_ON_ONCE(enabled_dynamic & ~allowed_dynamic);

	if (!vcpu->arch.xfd_passthrough) {
		/* All dynamic states will #NM?  Wait and see.  */
		if ((enabled_dynamic & ~vcpu->arch.xfd) == 0)
			return 0;

		kvm_x86_ops.enable_xfd_passthrough(vcpu);
	}

	/* current->thread.fpu was already handled by arch_prctl.  */
	return fpu_alloc_features(vcpu->guest_fpu,
		vcpu->guest_fpu.dynamic_state_perm | enabled_dynamic);
}

Paolo

