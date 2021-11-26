Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C28F45F500
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 20:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhKZTIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 14:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbhKZTGo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 14:06:44 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84383C07E5EC
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 10:28:37 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x6so42149273edr.5
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 10:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4RUQP4t0BtYG+jy1ickT9Gu8uvaKpjLZuDhJCX818B4=;
        b=CoAzoe6rXDHL8tV4h/8JtaN4W0YQlGCnFNemhzo8kSo2HlXiunZQoCgvLb7SYzjvJ6
         qJCh3BE7Q2VAOgG5USqSMi68jHnk99ylNS3HfipFSEmayuv2HAhAJkhEAlJDgI9Tb0hB
         /ZjUVrPjTYyqvoP6LB5aPVp4E2px4njpIWhmqsJjj+Cq6efP+h5L1ObTqAnBOqzMP1GV
         mVVXRK8QYQRdkqNAmcrJPLEt5fKl9Wmkf23Mi5IpoxiEuzA6ERxJz98uxbrQ/5gCoba3
         VkLe0AlIMNNG4Kq1+q8loYs31BB25r/PxY/Iw7MZqUdMAl4+q1Pol4Mh3vEvPfo0Sind
         ATLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4RUQP4t0BtYG+jy1ickT9Gu8uvaKpjLZuDhJCX818B4=;
        b=UkqPTjPsOJlZpG8KJMm02tjP9KqgiHt0R7M1Kg1NfQ79wq/N8AT+KpMNhv/yA5igqS
         JtVSgHGo6vl7VacHu6egPZnlV9yhwaLhhk+8kD0KW33IgYr+VP2qgBLmQOYobDpy8MyV
         GYmGak429q5BOFWYoprUUrXQznkyJgHhh856Av26Wgcjt9xqa2ZPEg+SwQu7kTrJJKck
         yQVx6MBKSvLk2YhcioVHf2OvnbhvIsQ66TFRseuhbpQ4V4tPAd8clOju6I5h7VZ6ZVuz
         tGfYrFNUVBTomq9lPAfkd/9jgn+2SR7CnijawM7Y+5ndC2lqJKjlMN4QubX+XV6RaOBA
         slKA==
X-Gm-Message-State: AOAM530BxBe1gfou2ScoKzF7eHqwOyfMPkvEUVqoePk2GXz87sfCgVRq
        2bVWIvSl0sNyAVh6UAUKC6Y=
X-Google-Smtp-Source: ABdhPJzBsWJP0NIx3laFBDTQ3BqIYGRuVnm0ol9UUKRiDaFUagm42rkLvmaEGl+weORh8HgD5FHkDw==
X-Received: by 2002:a05:6402:35cc:: with SMTP id z12mr49759293edc.393.1637951316023;
        Fri, 26 Nov 2021 10:28:36 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id h7sm5053357ede.40.2021.11.26.10.28.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 10:28:35 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <b3307d95-a36f-51f1-7ee7-37c32131a4af@redhat.com>
Date:   Fri, 26 Nov 2021 19:28:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 28/39] nVMX: Remove "v1" version of INVVPID
 test
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20211125012857.508243-1-seanjc@google.com>
 <20211125012857.508243-29-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211125012857.508243-29-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/25/21 02:28, Sean Christopherson wrote:
> Yank out the old INVVPID and drop the version info from the new test,
> which is a complete superset.  That, and the old test was apparently
> trying to win an obfuscated C contest.

All of the "version 1" tests are...

Paolo

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   x86/vmx_tests.c | 91 ++-----------------------------------------------
>   1 file changed, 2 insertions(+), 89 deletions(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 78a53e1..507e485 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -1545,92 +1545,6 @@ static int eptad_exit_handler(union exit_reason exit_reason)
>   	return ept_exit_handler_common(exit_reason, true);
>   }
>   
> -static bool invvpid_test(int type, u16 vpid)
> -{
> -	bool ret, supported;
> -
> -	supported = ept_vpid.val &
> -		(VPID_CAP_INVVPID_ADDR >> INVVPID_ADDR << type);
> -	ret = __invvpid(type, vpid, 0);
> -
> -	if (ret == !supported)
> -		return false;
> -
> -	if (!supported)
> -		printf("WARNING: unsupported invvpid passed!\n");
> -	else
> -		printf("WARNING: invvpid failed!\n");
> -
> -	return true;
> -}
> -
> -static int vpid_init(struct vmcs *vmcs)
> -{
> -	u32 ctrl_cpu1;
> -
> -	if (!(ctrl_cpu_rev[0].clr & CPU_SECONDARY) ||
> -		!(ctrl_cpu_rev[1].clr & CPU_VPID)) {
> -		printf("\tVPID is not supported");
> -		return VMX_TEST_EXIT;
> -	}
> -
> -	ctrl_cpu1 = vmcs_read(CPU_EXEC_CTRL1);
> -	ctrl_cpu1 |= CPU_VPID;
> -	vmcs_write(CPU_EXEC_CTRL1, ctrl_cpu1);
> -	return VMX_TEST_START;
> -}
> -
> -static void vpid_main(void)
> -{
> -	vmx_set_test_stage(0);
> -	vmcall();
> -	report(vmx_get_test_stage() == 1, "INVVPID SINGLE ADDRESS");
> -	vmx_set_test_stage(2);
> -	vmcall();
> -	report(vmx_get_test_stage() == 3, "INVVPID SINGLE");
> -	vmx_set_test_stage(4);
> -	vmcall();
> -	report(vmx_get_test_stage() == 5, "INVVPID ALL");
> -}
> -
> -static int vpid_exit_handler(union exit_reason exit_reason)
> -{
> -	u64 guest_rip;
> -	u32 insn_len;
> -
> -	guest_rip = vmcs_read(GUEST_RIP);
> -	insn_len = vmcs_read(EXI_INST_LEN);
> -
> -	switch (exit_reason.basic) {
> -	case VMX_VMCALL:
> -		switch(vmx_get_test_stage()) {
> -		case 0:
> -			if (!invvpid_test(INVVPID_ADDR, 1))
> -				vmx_inc_test_stage();
> -			break;
> -		case 2:
> -			if (!invvpid_test(INVVPID_CONTEXT_GLOBAL, 1))
> -				vmx_inc_test_stage();
> -			break;
> -		case 4:
> -			if (!invvpid_test(INVVPID_ALL, 1))
> -				vmx_inc_test_stage();
> -			break;
> -		default:
> -			report_fail("ERROR: unexpected stage, %d",
> -					vmx_get_test_stage());
> -			print_vmexit_info(exit_reason);
> -			return VMX_TEST_VMEXIT;
> -		}
> -		vmcs_write(GUEST_RIP, guest_rip + insn_len);
> -		return VMX_TEST_RESUME;
> -	default:
> -		report_fail("Unknown exit reason, 0x%x", exit_reason.full);
> -		print_vmexit_info(exit_reason);
> -	}
> -	return VMX_TEST_VMEXIT;
> -}
> -
>   #define TIMER_VECTOR	222
>   
>   static volatile bool timer_fired;
> @@ -3391,7 +3305,7 @@ static void invvpid_test_not_in_vmx_operation(void)
>    * This does not test real-address mode, virtual-8086 mode, protected mode,
>    * or CPL > 0.
>    */
> -static void invvpid_test_v2(void)
> +static void invvpid_test(void)
>   {
>   	u64 msr;
>   	int i;
> @@ -10770,7 +10684,6 @@ struct vmx_test vmx_tests[] = {
>   	{ "EPT A/D disabled", ept_init, ept_main, ept_exit_handler, NULL, {0} },
>   	{ "EPT A/D enabled", eptad_init, eptad_main, eptad_exit_handler, NULL, {0} },
>   	{ "PML", pml_init, pml_main, pml_exit_handler, NULL, {0} },
> -	{ "VPID", vpid_init, vpid_main, vpid_exit_handler, NULL, {0} },
>   	{ "interrupt", interrupt_init, interrupt_main,
>   		interrupt_exit_handler, NULL, {0} },
>   	{ "nmi_hlt", nmi_hlt_init, nmi_hlt_main,
> @@ -10794,7 +10707,7 @@ struct vmx_test vmx_tests[] = {
>   	TEST(fixture_test_case1),
>   	TEST(fixture_test_case2),
>   	/* Opcode tests. */
> -	TEST(invvpid_test_v2),
> +	TEST(invvpid_test),
>   	/* VM-entry tests */
>   	TEST(vmx_controls_test),
>   	TEST(vmx_host_state_area_test),
> 

