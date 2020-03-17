Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E14188960
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 16:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgCQPq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 11:46:28 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:32048 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726476AbgCQPq2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Mar 2020 11:46:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584459986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MtWNiNsyw58TpThIpUmfyoCcBPEXGW1B2ixxWbmGhoo=;
        b=Lqmy2sawb4WhYv48Qk1Cgm7o1FimeddCfixpLmi1RlHrBg77+7jqxh2Aoa1NqmyEgCh8lb
        NmYvZ7mJiBMYa42AFC3KyT7CCRBAD3SIJ1DPRfV424/W9IpZiSLaR2IMame9AoLbTCo7Ma
        4LU1aZyVDslxAzIhs01sb8WiHQsah4U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-Kv_-Y8J-Oo69WmlO969bSg-1; Tue, 17 Mar 2020 11:46:24 -0400
X-MC-Unique: Kv_-Y8J-Oo69WmlO969bSg-1
Received: by mail-wr1-f70.google.com with SMTP id 94so6194976wrr.3
        for <kvm@vger.kernel.org>; Tue, 17 Mar 2020 08:46:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MtWNiNsyw58TpThIpUmfyoCcBPEXGW1B2ixxWbmGhoo=;
        b=kxSg2mrG+pVEXOZXyQDWpM4XkB4967dNAT7sphMqSbLYctE48L5R3JrAAySem9w3w/
         9zO8Fw3lq5cVWxjqdWjGN7PQjxMcrPI1352n4Q5XcXX23VgoTnMFwO0EBOQpIWD9hIKJ
         YUD6C7e1YBNac6Qh52fw3VRoTBal0zjXgBBi2eLuVOmG8DWyLH3o0CuyGNCIjl9LMAKu
         VUsv/3l+1cMiXsOp5Jf6HvmGVvHfx9MwOqso8+VdQMh7wBSh2gweSWSu9+5B1IiqdmqF
         SYiIr5WVHXCuX7xvciG4DfF5/JEcsZ/DKB2QY4m63VEjD7+xNJN/MDDPgsohsaLVS2AJ
         rBXw==
X-Gm-Message-State: ANhLgQ34VxfdPgIlCdoJnZJ9fjhtvPFwgQ3+aA8gEjyeApAB85ZWGsU6
        R0D8uQB8mvyN9WYg0XhDVoIIWFJi9pQUXY3QlL6OhsAxXzk018BvIy3TERYRNfsw0hF+pK1LIfa
        Apm4kjUQ1QOk2
X-Received: by 2002:a05:600c:2252:: with SMTP id a18mr6167602wmm.51.1584459983114;
        Tue, 17 Mar 2020 08:46:23 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvLoGX11kaelfWvQl5y06uUHkGeeRqBlbssVfg3CH2cycHuT0KIFWG4gNMI9yrlEnNI6Ql6Uw==
X-Received: by 2002:a05:600c:2252:: with SMTP id a18mr6167573wmm.51.1584459982845;
        Tue, 17 Mar 2020 08:46:22 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.227])
        by smtp.gmail.com with ESMTPSA id m17sm5332294wrw.3.2020.03.17.08.46.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 08:46:22 -0700 (PDT)
Subject: Re: [PATCH 2/2] kvm-unit-test: nVMX: Test GUEST_BNDCFGS VM-Entry
 control on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com
References: <1584408095-16591-1-git-send-email-krish.sadhukhan@oracle.com>
 <1584408095-16591-3-git-send-email-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dcf37e1f-d6c6-a198-cbe8-86083e72f567@redhat.com>
Date:   Tue, 17 Mar 2020 16:46:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1584408095-16591-3-git-send-email-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/20 02:21, Krish Sadhukhan wrote:
> According to section "Checks on Guest Control Registers, Debug Registers,
> and MSRs" in Intel SDM vol 3C, the following checks are performed on
> vmentry of nested guests:
> 
>     If the "load IA32_BNDCFGS" VM-entry control is 1, the following
>     checks are performed on the field for the IA32_BNDCFGS MSR:
> 
>       —  Bits reserved in the IA32_BNDCFGS MSR must be 0.
>       —  The linear address in bits 63:12 must be canonical.

Can you please rebase? test_guest_state has replaced
enter_guest_with_invalid_guest_state and report_guest_state_test.

Thanks,

Paolo

> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  x86/vmx_tests.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index a7abd63..5ea15d0 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -7681,6 +7681,58 @@ static void test_load_guest_pat(void)
>  	test_pat(GUEST_PAT, "GUEST_PAT", ENT_CONTROLS, ENT_LOAD_PAT);
>  }
>  
> +#define MSR_IA32_BNDCFGS_RSVD_MASK	0x00000ffc
> +
> +/*
> + * If the “load IA32_BNDCFGS” VM-entry control is 1, the following
> + * checks are performed on the field for the IA32_BNDCFGS MSR:
> + *
> + *   —  Bits reserved in the IA32_BNDCFGS MSR must be 0.
> + *   —  The linear address in bits 63:12 must be canonical.
> + *
> + *  [Intel SDM]
> + */
> +static void test_load_guest_bndcfgs(void)
> +{
> +	u64 bndcfgs_saved = vmcs_read(GUEST_BNDCFGS);
> +	u64 bndcfgs;
> +
> +	if (!(ctrl_enter_rev.clr & ENT_LOAD_BNDCFGS)) {
> +		printf("\"Load-IA32-BNDCFGS\" entry control not supported\n");
> +		return;
> +	}
> +
> +	vmcs_clear_bits(ENT_CONTROLS, ENT_LOAD_BNDCFGS);
> +
> +	vmcs_write(GUEST_BNDCFGS, NONCANONICAL);
> +	enter_guest();
> +	report_guest_state_test("ENT_LOAD_BNDCFGS disabled",
> +				VMX_VMCALL, NONCANONICAL, "GUEST_BNDCFGS");
> +
> +	bndcfgs = bndcfgs_saved | MSR_IA32_BNDCFGS_RSVD_MASK;
> +	vmcs_write(GUEST_BNDCFGS, bndcfgs);
> +	enter_guest();
> +	report_guest_state_test("ENT_LOAD_BNDCFGS disabled",
> +				VMX_VMCALL, bndcfgs, "GUEST_BNDCFGS");
> +
> +	vmcs_set_bits(ENT_CONTROLS, ENT_LOAD_BNDCFGS);
> +
> +	vmcs_write(GUEST_BNDCFGS, NONCANONICAL);
> +	enter_guest_with_invalid_guest_state();
> +	report_guest_state_test("ENT_LOAD_BNDCFGS enabled",
> +				VMX_FAIL_STATE | VMX_ENTRY_FAILURE,
> +				NONCANONICAL, "GUEST_BNDCFGS");
> +
> +	bndcfgs = bndcfgs_saved | MSR_IA32_BNDCFGS_RSVD_MASK;
> +	vmcs_write(GUEST_BNDCFGS, bndcfgs);
> +	enter_guest_with_invalid_guest_state();
> +	report_guest_state_test("ENT_LOAD_BNDCFGS enabled",
> +				VMX_FAIL_STATE | VMX_ENTRY_FAILURE, bndcfgs,
> +				"GUEST_BNDCFGS");
> +
> +	vmcs_write(GUEST_BNDCFGS, bndcfgs_saved);
> +}
> +
>  /*
>   * Check that the virtual CPU checks the VMX Guest State Area as
>   * documented in the Intel SDM.
> @@ -7701,6 +7753,7 @@ static void vmx_guest_state_area_test(void)
>  	test_load_guest_pat();
>  	test_guest_efer();
>  	test_load_guest_perf_global_ctrl();
> +	test_load_guest_bndcfgs();
>  
>  	/*
>  	 * Let the guest finish execution
> 

