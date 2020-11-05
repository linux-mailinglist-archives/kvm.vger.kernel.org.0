Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BC72A8315
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 17:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730504AbgKEQJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 11:09:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30083 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727275AbgKEQI6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 11:08:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604592537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y12kMlZjOb07g/dL052H0KGI2c3PGFmd+2DNZzzrRIA=;
        b=F6cGJvNUQTZxLszm6EmCCEcmJwNnxSKFy79T1MD/2y8X73W2lzRp+5ktQFTgxEwTRkyS2n
        cqTAR6cxQIbU/Qe32SsVDhizektoPcMoFt2cd5zWrPvy19r9al3VvVwznwp5K9BrU6Cfb+
        vtwUaQ/Fm23gB42TKjPLNfsUGOevhX8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-EndIdcbRPUSVWzZKUk9LKQ-1; Thu, 05 Nov 2020 11:08:55 -0500
X-MC-Unique: EndIdcbRPUSVWzZKUk9LKQ-1
Received: by mail-wm1-f70.google.com with SMTP id t21so546999wmt.8
        for <kvm@vger.kernel.org>; Thu, 05 Nov 2020 08:08:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y12kMlZjOb07g/dL052H0KGI2c3PGFmd+2DNZzzrRIA=;
        b=qPetWzmwTja0+lFtrcCbUvn5CfbyhwFHsEybFuLTBNaj8Sv2tfM0S4HwZGF2ZY1qsX
         GvjNwytTl32kZVhFb2VtH28cOReQWpod8bp3DQssGRvpBwikmV8OerrlfBE9PrhBtFsH
         w5k08I1MTFRNK64hj1FJ+UrjMALi3cbjnkwXGIMgfQK6XDxZf+t/7aFn9p+ayWmA3SsK
         Wiq9dkm4kWWxl3bXljgYpXoW/vs1OPILTenZE/kEbNzGtHjVdUI1zgCThDWpShCg/7OF
         nMe4Pp1HIKFbJR2XNIDO7UayQiZigFNLrRSyXxRKQwIBiPePOKPl7GvG6INZwj+PZ0h4
         waCg==
X-Gm-Message-State: AOAM531VXEG/flY1kip6uaGS+wxgMk8v2xgKEBDVVXSMBAw3G9oHzhZG
        QgbZzgVmig2ITEEHiTFkBP+yy4nAAVt0MuDdkSobRejx7PpbSYefeozjoaj/KoGrp4vSPFdUxyX
        kjHx+9Kv4L6R5
X-Received: by 2002:adf:f08a:: with SMTP id n10mr537756wro.260.1604592532868;
        Thu, 05 Nov 2020 08:08:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzzGHz+vIryark98hbwn+RCxwtJul3pPXwpSuOna53NzNqfiXtft+hRmggnOQQxguTCns8DBQ==
X-Received: by 2002:adf:f08a:: with SMTP id n10mr537727wro.260.1604592532644;
        Thu, 05 Nov 2020 08:08:52 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id w1sm3486314wro.44.2020.11.05.08.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 08:08:51 -0800 (PST)
To:     yadong.qi@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        liran.alon@oracle.com, nikita.leshchenko@oracle.com,
        chao.gao@intel.com, kevin.tian@intel.com, luhai.chen@intel.com,
        bing.zhu@intel.com, kai.z.wang@intel.com
References: <20200922052343.84388-1-yadong.qi@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
Message-ID: <187635d0-7786-5d8f-a41a-45a6abd9d001@redhat.com>
Date:   Thu, 5 Nov 2020 17:08:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200922052343.84388-1-yadong.qi@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/20 07:23, yadong.qi@intel.com wrote:
> From: Yadong Qi <yadong.qi@intel.com>
> 
> Background: We have a lightweight HV, it needs INIT-VMExit and
> SIPI-VMExit to wake-up APs for guests since it do not monitor
> the Local APIC. But currently virtual wait-for-SIPI(WFS) state
> is not supported in nVMX, so when running on top of KVM, the L1
> HV cannot receive the INIT-VMExit and SIPI-VMExit which cause
> the L2 guest cannot wake up the APs.
> 
> According to Intel SDM Chapter 25.2 Other Causes of VM Exits,
> SIPIs cause VM exits when a logical processor is in
> wait-for-SIPI state.
> 
> In this patch:
>      1. introduce SIPI exit reason,
>      2. introduce wait-for-SIPI state for nVMX,
>      3. advertise wait-for-SIPI support to guest.
> 
> When L1 hypervisor is not monitoring Local APIC, L0 need to emulate
> INIT-VMExit and SIPI-VMExit to L1 to emulate INIT-SIPI-SIPI for
> L2. L2 LAPIC write would be traped by L0 Hypervisor(KVM), L0 should
> emulate the INIT/SIPI vmexit to L1 hypervisor to set proper state
> for L2's vcpu state.

There is a problem in this patch, in that this change is incorrect:

> 
> @@ -2847,7 +2847,8 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
>  	 */
>  	if (kvm_vcpu_latch_init(vcpu)) {
>  		WARN_ON_ONCE(vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED);
> -		if (test_bit(KVM_APIC_SIPI, &apic->pending_events))
> +		if (test_bit(KVM_APIC_SIPI, &apic->pending_events) &&
> +		    !is_guest_mode(vcpu))
>  			clear_bit(KVM_APIC_SIPI, &apic->pending_events);
>  		return;
>  	}

Here you're not trying to process a latched INIT; you just want to delay 
the processing of the SIPI until check_nested_events.

The change does have a correct part in it.  In particular, 
vmx_apic_init_signal_blocked should have been

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 47b8357b9751..64339121a4f0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7558,7 +7558,7 @@ static void enable_smi_window(struct kvm_vcpu *vcpu)

  static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
  {
-	return to_vmx(vcpu)->nested.vmxon;
+	return to_vmx(vcpu)->nested.vmxon && !is_guest_mode(vcpu);
  }

  static void vmx_migrate_timers(struct kvm_vcpu *vcpu)

to only latch INIT signals in root mode.  However, SIPI must be cleared 
unconditionally on SVM; the "!is_guest_mode" test in that case is incorrect.

The right way to do it is to call check_nested_events from 
kvm_apic_accept_events.  This will cause an INIT or SIPI vmexit, as 
required.  There is some extra complication to read pending_events 
*before* kvm_apic_accept_events and not steal from the guest any INIT or 
SIPI that is sent after kvm_apic_accept_events returns.

Thanks to your test case, I will test a patch and send it.

Paolo

