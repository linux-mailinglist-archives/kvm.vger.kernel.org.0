Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8037282964
	for <lists+kvm@lfdr.de>; Sun,  4 Oct 2020 09:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgJDHTg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Oct 2020 03:19:36 -0400
Received: from mga07.intel.com ([134.134.136.100]:60629 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgJDHTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Oct 2020 03:19:36 -0400
IronPort-SDR: K0Vk8XYNfiLooZY3ikUrFQjpFI0ZatJrxFgI8POl2PO7HJ+3vituMvO/3E9inpmcMSAp2Qom6F
 g3q9quq4TvnQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9763"; a="227409359"
X-IronPort-AV: E=Sophos;i="5.77,334,1596524400"; 
   d="scan'208";a="227409359"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 00:19:28 -0700
IronPort-SDR: GtFOEp4JiTfU9U1Z4rEe8amdt8QDcORDWH6e5OanymbGZOcMqU4NhguSv3XmwSBKG2634fthi9
 diDQTOjwCeyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,334,1596524400"; 
   d="scan'208";a="518517602"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga005.jf.intel.com with ESMTP; 04 Oct 2020 00:19:28 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 4 Oct 2020 00:19:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 4 Oct 2020 00:19:28 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sun, 4 Oct 2020 00:19:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evYcJe+Ny1i0KvAEEZrOleRBQaqopO+LwGdD8+dWA2UWm/3C/Donl1VSILX+UOftuwgkBoAHR8xy5eFXWMcqfxEGxdFxQ+VAwm3JX/wRv+hmh5FDqwezItIZetX4ZLaeok7Ye6RHqVVskaYPPHwwJlhjEvEFqB6JCm5ZnzJC0z8YXuCuQUwep1seRRRn3DNY4AGZlXc6CfrgK88VqyQXvIOWo5lBo/SBDbTO0eAXh56zVZddddoVJ1RQT8073XGba/1jLfi0OXCpflVMQd0zO5zl2Jy5nnBzTg/J3BCUSHpM1lTBbUd/HE+oU7ckqO+SRyFJvlhR9J2Z70304UvBbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7gaNbt+ReTa7jdVWQvZMs8MFHkUzqDjNO3BVKugjmc=;
 b=lKGEbMoh5yGWN8uMae5SFQowPsGjJJozix+SME9TxQDgFvWnUglzGG98SaWEnI3vCZhU4mgTTj1EL4EFM9WsY6KtaVAJ5ngjPHB7x2zY/OnRcuMBuh2QhLRZPC0wIdLJCI592ChgdzG8tXXSI50BZq0bQ5vodu6bxxJo+h+bnngUi2I79X/rSMP+6GnD52hpC1kVGnUk6IBeTCJvUHCqpqyP30RBxC3II2UdTHFlqlJgJB135Mb6RIeLOMQU5CX1bt4EYarM1Lhmr01m1OgHhe8aPstwca3fP1SZ4c5X9OykIMgItoP8NoA+XVzbwUEdlm0Oj0h79jEFp/kxf34jMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7gaNbt+ReTa7jdVWQvZMs8MFHkUzqDjNO3BVKugjmc=;
 b=TY3elE5Jp5zKHJqzQID6hn4L0ggpbY2DyukZee5gUi49d5AvKPLiAldqKlYhV9sZVuWdvn0JxbfAQzJrPqFO2eNpxRQPe836ovdvu2YZRJsZECgNF2VJbN4gk5i2IzZ8ypZMmYPSKO6bZLwNUqsk7JDwz3MT4Rap9QXAqOT6Hio=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16)
 by MW3PR11MB4716.namprd11.prod.outlook.com (2603:10b6:303:53::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Sun, 4 Oct
 2020 07:19:24 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::c507:6aa8:d408:932d]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::c507:6aa8:d408:932d%4]) with mapi id 15.20.3433.043; Sun, 4 Oct 2020
 07:19:23 +0000
From:   "Qi, Yadong" <yadong.qi@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: RE: [kvm-unit-tests PATCH] x86: vmx: Add test for SIPI signal
 processing
Thread-Topic: [kvm-unit-tests PATCH] x86: vmx: Add test for SIPI signal
 processing
Thread-Index: AQHWkw6i3URq225llEmaCd1JoJ27OqmHFl8A
Date:   Sun, 4 Oct 2020 07:19:23 +0000
Message-ID: <MWHPR11MB1968C521D356F1D1FA17EE6EE30F0@MWHPR11MB1968.namprd11.prod.outlook.com>
References: <20200925073624.245578-1-yadong.qi@intel.com>
In-Reply-To: <20200925073624.245578-1-yadong.qi@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fcb19ff9-8eb1-4395-e5dd-08d86835d1f7
x-ms-traffictypediagnostic: MW3PR11MB4716:
x-microsoft-antispam-prvs: <MW3PR11MB47169D9EDEB2CC2B01E56AF0E30F0@MW3PR11MB4716.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D+2zcd0puVDdpcF1RUbMR4LFQ3dlb2YTT5tLODqGII+vyGFW6t4BDcefQypuZkzsPeVWLsD6O0cDr2QLG39oA55p8JeuR0TaoJAf2UND/NUrnQUANVICh1OHcI1nIc/wMv1APzuGKtxyFnI1CDLo6uylkTTghGUggRm/ZGj2B5fjzPTqIGK8+f8InvuZvsxGE8m2WuY8KMZ8XRli1d5C3XEHH+rlcdhLlQCtrGj16cB8XatPRa0cENnhuddC8YjbzUBbD1HCenkv0W2VOFgM8Gh6NTmMTM6WlQeKO4ens7W/eZcOn/qZX1g4dDQdgHdnzuZjh3em1ysnRb5hSaJFUNtihAf6XoL9BW4h54rfMlig7KV2iBNJpIUnJlSX9ODOxAKvx7mMFqrBVds8buezAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1968.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(66476007)(64756008)(66446008)(66556008)(66946007)(83080400001)(8676002)(6506007)(26005)(316002)(33656002)(7696005)(110136005)(5660300002)(52536014)(86362001)(2906002)(55016002)(478600001)(186003)(966005)(8936002)(83380400001)(53546011)(9686003)(76116006)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: NOPktu5y9W02WINl5J4/aiy/FVuxJV50Y6jrsW9ALgMaDe99n7qATlfFt65r8MlcLod14c1ynsTXrNAE9nNGvSsy6p3hVL8nXrhC1v3d8zWu6QxZqanW/v2bGXlljWnrVRT4bqAFWzclu2QC0cd+c6Qft1UVUrKRMfvOAUj0O4uhpOE+szxkEFlxl76vJ8yJTnOEwtJIaCB8TrhEchmfZZoSumJR84RJFlrR6EdRFkGcfVtdXzlPY7431Hy/2dzJ4irT27HHpk6flQfEVNRPBTv6/J1UrkyukXfoHWg28tBwKPdFpiEKVlPWpUaCtSsJiTjFDQARETwRtKTTOxe6A0bVpigtmlo1prlPi61MTXJ5vzYArc6KRun0DoH9HrApVe9Tjiiq1ZGZdZsT2cvlvdRsSF3+O2BjjQfJHJ75KeqcsMSKhbXKspIJfKu5NgoWNAvk989e4p8ZONrHug1OK32A9dLst+O5iTLEP9T5TPzKXQBtQgY6DNkYeimN7BX5qUwxG8TlHPkNbNW8Q+Fyqj6mf8YNrSxkxiGcMbUPzp/GCZ4MMb83o/lLZac+nt+1WF2hzCi+krz61pj53k6TUru5UKedl2pdKlY3Nw6QyFWsWf5B7eiyT6SP6TzP4xnAcJYuRuYAIpuCli4DTT/73g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1968.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb19ff9-8eb1-4395-e5dd-08d86835d1f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2020 07:19:23.5716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bahH2CLWEPKXcSyW0CQ8ACJPJHdEgH+mKi3cl2Pt1aVlpz9pWYq2Ed3FZjZJMQ6xvjxUaDTFgVE/vv3h9QJttA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4716
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: Qi, Yadong <yadong.qi@intel.com>
> Sent: Friday, September 25, 2020 3:36 PM
> To: kvm@vger.kernel.org
> Cc: pbonzini@redhat.com; Qi, Yadong <yadong.qi@intel.com>
> Subject: [kvm-unit-tests PATCH] x86: vmx: Add test for SIPI signal proces=
sing
>=20
> From: Yadong Qi <yadong.qi@intel.com>
>=20
> The test verifies the following functionality:
> A SIPI signal received when CPU is in VMX non-root mode:
>     if ACTIVITY_STATE =3D=3D WAIT_SIPI
>         VMExit with (reason =3D=3D 4)
>     else
>         SIPI signal is ignored
>=20
> The test cases depends on IA32_VMX_MISC:bit(8), if this bit is 1 then the=
 test
> cases would be executed, otherwise the test cases would be skiped.
>=20
> Signed-off-by: Yadong Qi <yadong.qi@intel.com>
> ---
>  lib/x86/msr.h     |   1 +
>  x86/unittests.cfg |   8 +++
>  x86/vmx.c         |   2 +-
>  x86/vmx.h         |   3 ++
>  x86/vmx_tests.c   | 134
> ++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 147 insertions(+), 1 deletion(-)
>=20
> diff --git a/lib/x86/msr.h b/lib/x86/msr.h index 6ef5502..29e3947 100644
> --- a/lib/x86/msr.h
> +++ b/lib/x86/msr.h
> @@ -421,6 +421,7 @@
>  #define MSR_IA32_VMX_TRUE_ENTRY		0x00000490
>=20
>  /* MSR_IA32_VMX_MISC bits */
> +#define MSR_IA32_VMX_MISC_ACTIVITY_WAIT_SIPI		(1ULL << 8)
>  #define MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS	(1ULL << 29)
>=20
>  #define MSR_IA32_TSCDEADLINE		0x000006e0
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg index 3a79151..3e14a65
> 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -293,6 +293,14 @@ arch =3D x86_64
>  groups =3D vmx
>  timeout =3D 10
>=20
> +[vmx_sipi_signal_test]
> +file =3D vmx.flat
> +smp =3D 2
> +extra_params =3D -cpu host,+vmx -m 2048 -append vmx_sipi_signal_test arc=
h
> +=3D x86_64 groups =3D vmx timeout =3D 10
> +
>  [vmx_apic_passthrough_tpr_threshold_test]
>  file =3D vmx.flat
>  extra_params =3D -cpu host,+vmx -m 2048 -append
> vmx_apic_passthrough_tpr_threshold_test
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 07415b4..e3a3fbf 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -1369,7 +1369,7 @@ static void init_vmcs_guest(void)
>  	vmcs_write(GUEST_INTR_STATE, 0);
>  }
>=20
> -static int init_vmcs(struct vmcs **vmcs)
> +int init_vmcs(struct vmcs **vmcs)
>  {
>  	*vmcs =3D alloc_page();
>  	(*vmcs)->hdr.revision_id =3D basic.revision; diff --git a/x86/vmx.h
> b/x86/vmx.h index d1c2436..9b17074 100644
> --- a/x86/vmx.h
> +++ b/x86/vmx.h
> @@ -697,6 +697,8 @@ enum vm_entry_failure_code {
>=20
>  #define ACTV_ACTIVE		0
>  #define ACTV_HLT		1
> +#define ACTV_SHUTDOWN		2
> +#define ACTV_WAIT_SIPI		3
>=20
>  /*
>   * VMCS field encoding:
> @@ -856,6 +858,7 @@ static inline bool invvpid(unsigned long type, u64 vp=
id,
> u64 gla)
>=20
>  void enable_vmx(void);
>  void init_vmx(u64 *vmxon_region);
> +int init_vmcs(struct vmcs **vmcs);
>=20
>  const char *exit_reason_description(u64 reason);  void print_vmexit_info=
(union
> exit_reason exit_reason); diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c =
index
> 22f0c7b..45b0f80 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -9608,6 +9608,139 @@ static void vmx_init_signal_test(void)
>  	 */
>  }
>=20
> +#define SIPI_SIGNAL_TEST_DELAY	100000000ULL
> +
> +static void vmx_sipi_test_guest(void)
> +{
> +	if (apic_id() =3D=3D 0) {
> +		/* wait AP enter guest with activity=3DWAIT_SIPI */
> +		while (vmx_get_test_stage() !=3D 1)
> +			;
> +		delay(SIPI_SIGNAL_TEST_DELAY);
> +
> +		/* First SIPI signal */
> +		apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP |
> APIC_INT_ASSERT, id_map[1]);
> +		report(1, "BSP(L2): Send first SIPI to cpu[%d]", id_map[1]);
> +
> +		/* wait AP enter guest */
> +		while (vmx_get_test_stage() !=3D 2)
> +			;
> +		delay(SIPI_SIGNAL_TEST_DELAY);
> +
> +		/* Second SIPI signal should be ignored since AP is not in
> WAIT_SIPI state */
> +		apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP |
> APIC_INT_ASSERT, id_map[1]);
> +		report(1, "BSP(L2): Send second SIPI to cpu[%d]", id_map[1]);
> +
> +		/* Delay a while to check whether second SIPI would cause
> VMExit */
> +		delay(SIPI_SIGNAL_TEST_DELAY);
> +
> +		/* Test is done, notify AP to exit test */
> +		vmx_set_test_stage(3);
> +
> +		/* wait AP exit non-root mode */
> +		while (vmx_get_test_stage() !=3D 5)
> +			;
> +	} else {
> +		/* wait BSP notify test is done */
> +		while (vmx_get_test_stage() !=3D 3)
> +			;
> +
> +		/* AP exit guest */
> +		vmx_set_test_stage(4);
> +	}
> +}
> +
> +static void sipi_test_ap_thread(void *data) {
> +	struct vmcs *ap_vmcs;
> +	u64 *ap_vmxon_region;
> +	void *ap_stack, *ap_syscall_stack;
> +	u64 cpu_ctrl_0 =3D CPU_SECONDARY;
> +	u64 cpu_ctrl_1 =3D 0;
> +
> +	/* Enter VMX operation (i.e. exec VMXON) */
> +	ap_vmxon_region =3D alloc_page();
> +	enable_vmx();
> +	init_vmx(ap_vmxon_region);
> +	_vmx_on(ap_vmxon_region);
> +	init_vmcs(&ap_vmcs);
> +	make_vmcs_current(ap_vmcs);
> +
> +	/* Set stack for AP */
> +	ap_stack =3D alloc_page();
> +	ap_syscall_stack =3D alloc_page();
> +	vmcs_write(GUEST_RSP, (u64)(ap_stack + PAGE_SIZE - 1));
> +	vmcs_write(GUEST_SYSENTER_ESP, (u64)(ap_syscall_stack + PAGE_SIZE
> -
> +1));
> +
> +	/* passthrough lapic to L2 */
> +	disable_intercept_for_x2apic_msrs();
> +	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0) |
> cpu_ctrl_0);
> +	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) |
> cpu_ctrl_1);
> +
> +	/* Set guest activity state to wait-for-SIPI state */
> +	vmcs_write(GUEST_ACTV_STATE, ACTV_WAIT_SIPI);
> +
> +	vmx_set_test_stage(1);
> +
> +	/* AP enter guest */
> +	enter_guest();
> +
> +	if (vmcs_read(EXI_REASON) =3D=3D VMX_SIPI) {
> +		report(1, "AP: Handle SIPI VMExit");
> +		vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
> +		vmx_set_test_stage(2);
> +	} else {
> +		report(0, "AP: Unexpected VMExit, reason=3D%ld",
> vmcs_read(EXI_REASON));
> +		vmx_off();
> +		return;
> +	}
> +
> +	/* AP enter guest */
> +	enter_guest();
> +
> +	report(vmcs_read(EXI_REASON) !=3D VMX_SIPI,
> +		"AP: should no SIPI VMExit since activity is not in WAIT_SIPI
> +state");
> +
> +	/* notify BSP that AP is already exit from non-root mode */
> +	vmx_set_test_stage(5);
> +
> +	/* Leave VMX operation */
> +	vmx_off();
> +}
> +
> +static void vmx_sipi_signal_test(void)
> +{
> +	if (!(rdmsr(MSR_IA32_VMX_MISC) &
> MSR_IA32_VMX_MISC_ACTIVITY_WAIT_SIPI)) {
> +		printf("\tACTIVITY_WAIT_SIPI state is not supported.\n");
> +		return;
> +	}
> +
> +	if (cpu_count() < 2) {
> +		report_skip(__func__);
> +		return;
> +	}
> +
> +	u64 cpu_ctrl_0 =3D CPU_SECONDARY;
> +	u64 cpu_ctrl_1 =3D 0;
> +
> +	/* passthrough lapic */
> +	disable_intercept_for_x2apic_msrs();
> +	vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) &
> ~PIN_EXTINT);
> +	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0) |
> cpu_ctrl_0);
> +	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) |
> cpu_ctrl_1);
> +
> +	test_set_guest(vmx_sipi_test_guest);
> +
> +	/* start AP */
> +	on_cpu_async(1, sipi_test_ap_thread, NULL);
> +
> +	vmx_set_test_stage(0);
> +
> +	/* BSP enter guest */
> +	enter_guest();
> +}
> +
> +
>  enum vmcs_access {
>  	ACCESS_VMREAD,
>  	ACCESS_VMWRITE,
> @@ -10244,6 +10377,7 @@ struct vmx_test vmx_tests[] =3D {
>  	TEST(vmx_apic_passthrough_thread_test),
>  	TEST(vmx_apic_passthrough_tpr_threshold_test),
>  	TEST(vmx_init_signal_test),
> +	TEST(vmx_sipi_signal_test),
>  	/* VMCS Shadowing tests */
>  	TEST(vmx_vmcs_shadow_test),
>  	/* Regression tests */
> --
> 2.25.1

Hi, Paolo

Any comments of this patch?
It is test case for https://patchwork.kernel.org/patch/11791499/

Best Regard
Yadong

