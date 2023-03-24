Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0886C838A
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 18:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbjCXRpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 13:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbjCXRpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 13:45:45 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F5F144B0;
        Fri, 24 Mar 2023 10:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679679941; x=1711215941;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wAyL2ERrkjUsXndZ+9aTf5YT0YwjrqX94YVfunup+iQ=;
  b=K3uOZxWbS6F+VPt0Ex+Yj+c4LhJNdHJm6wIZijnLsF7Gs88WT7oj6zqf
   rC0E0oUh8Zn3xo9eR9PkwegV9mNUK2M0JfQ6BH4u32NUTgkzySkH3aBn9
   GGxiR5gBuFFtiq38H/HBcn1V9FaaqBsy//F7i8TYMJwlV3OHg1gsiSmIc
   D3jwXPVx5DPPrJJUOGBCZ8EReHHXdUf22uk6Zyly0f9CT4Ees4zADFaxw
   aLJOPuyVyKmSoWmohrTJmLZbu3W+OwfFOokGQrkMHCAfhVALr0HHyenLr
   v3PBD9JynWFZBHhn7sW5jJMdeXGFzEDj8DSy0i586KBi64QMOQpC3FBzt
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="337345227"
X-IronPort-AV: E=Sophos;i="5.98,288,1673942400"; 
   d="scan'208";a="337345227"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 10:45:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="856952526"
X-IronPort-AV: E=Sophos;i="5.98,288,1673942400"; 
   d="scan'208";a="856952526"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 24 Mar 2023 10:45:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 24 Mar 2023 10:45:21 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 24 Mar 2023 10:45:21 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 24 Mar 2023 10:45:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQXzIpHei76M5JB5UDW3A1Z//m3hR80x+HmZRz+KPRdCY3+qS8I2LeZ4t0IE0Jx1RKYVfgcPUtudWEx1ITzYxQjyeTsShBvwEQflEQNIo41zJKQA5+/7GprMSdk/HWyF9TygEVKFKu0TVLmdL9WsFheKI9IxHfTHYtPndJ/PRryIdBGoRDCiRqsvtRS4QKEFNp4fGk99Ryk0LalEkeTzDOWmegHV99cLrYyax/A5RHw7+bVoB8EKoixZTMaPtSDq/oqkPFqnRzUBTxm5viDq10iZQwe4pDn4fgcS12hMuMHS31M9AVBe6R2OIYxuInh9OqyGis63KvlacKMjpoLsiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nsYSbkhjebH53UN6n72fXXYkynkDaiy5Zy10PCZx648=;
 b=nbV3kQLYuCEiRGmaosNPXDpFodrO/1X8c5Xfn1o0luHqHXkopVP43Eyj4jNVtPgpjPUe7zF+c9jwxKgZ97D6/T/6K6y4mPyMYpxjYwy6THyMeC4oT+peEk3ZR8qocgkGquBOzr3ov8YAc2ExnwPqvuxbcVd5s1DTDtDP4Zc/q3M2wJzFpMtwagApQsl+yKYl0qr32QPuLAaRWR6pKJ9pNAb0Piqa6ft6u/4G5O2RSYWBL6fFqn3bbXo5EbxOgkGchjMcanQUQXDZqM436ZFCqReysH1L+VNlcjoFH+YU7kdIqT+wTsv21XqIqLX5IKDx2tCgWDeG4K3vGTADhGwdIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SA3PR11MB7611.namprd11.prod.outlook.com (2603:10b6:806:304::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 17:45:18 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6178.037; Fri, 24 Mar 2023
 17:45:18 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Li, Xin3" <xin3.li@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v5 34/34] KVM: x86/vmx: execute "int $2" to handle NMI in
 NMI caused VM exits when FRED is enabled
Thread-Topic: [PATCH v5 34/34] KVM: x86/vmx: execute "int $2" to handle NMI in
 NMI caused VM exits when FRED is enabled
Thread-Index: AQHZUKI3WfAyEb/jCU66DZKXu8CGnq8HLBKAgABX0ICAAArqgIAACW+wgAK0sJA=
Date:   Fri, 24 Mar 2023 17:45:18 +0000
Message-ID: <SA1PR11MB67346FF35C184F818BB4B8C0A8849@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-35-xin3.li@intel.com> <ZBs/sSJwr7zdOUsE@google.com>
 <c9abb017-0088-b96f-d19a-b25e54ad150d@citrix.com>
 <ZBuSg+3jJpjA5S5P@google.com>
 <SA1PR11MB6734AE9646C3018A31872D88A8879@SA1PR11MB6734.namprd11.prod.outlook.com>
In-Reply-To: <SA1PR11MB6734AE9646C3018A31872D88A8879@SA1PR11MB6734.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SA3PR11MB7611:EE_
x-ms-office365-filtering-correlation-id: c1fb4b9a-ac95-4a36-6cd9-08db2c8f8876
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sDuOefRC9lVwp3SP4dGvCzabUrB4GulMewOlkVGK2m42e0ZE8V2iGebVCd0fwLxTZ8h4+TH4OaYbFWSzLm/tUewkudpKCYbRLX/HU+5z96PbQaFxxqxA9UeRmyFsFVsG5xupqCstByAPZ8/G8NhQg7yKe/jLYy0ewLNThtipsQHgFAvH5s2+T98ZqvOVFtRhK17rCRqDOK3PgK0iMktWNDw0BpA93BOdvhrwesx6Y4ykEMdQZ+6zA/N1AkiXH2Fk0PF3oVAGm55RfCAgokVP2GbVnR2Pm6m/AF4MWcDHFqlyLDI2eCQeYisQKyBBDJFRg17aVugS0C3bqsRGLJdhJ7O1Z7Jwsuro5D4MxCFEpSA+wqllb03xbm+4xQg37/CG/3VkLomOKnlfYkwlJa6T1otHAutNZTEVE0H9Yod+fiCkKBv5DF+0DaC378CDaNOATlSNB5Ps+3MAsPzCwFW9GhwPSVB0vcMYLdVMRZa6Qwlhu6zznKdzxQqvaAXtYIzFucwur4lwzSDP6G1LN+u4kFIuIvGXYnUMBdcuG47edZbD6xe8LWg2D6qnQd8yI/JC4BgJpNBy9mNEXjGwjBnUUQI5pDONXiVKmNdKx/ZNL23+aExssgDAKEyea0Sm8BBu0ojfgjnm60wOxcgxgA05h7EBmGRVYmy401P1pJPtPhQzMoAw3hc0VCtDIAyEK+JjYvuO3mex3NxfSOjX86iKmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(366004)(376002)(346002)(451199021)(2906002)(38100700002)(55016003)(38070700005)(64756008)(4326008)(66946007)(66446008)(54906003)(66556008)(76116006)(41300700001)(5660300002)(316002)(7416002)(82960400001)(122000001)(110136005)(26005)(52536014)(6506007)(8936002)(8676002)(83380400001)(33656002)(86362001)(7696005)(66476007)(186003)(71200400001)(9686003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tSDTy0mK/fJM7b30BqNANR5DDa3Bqub6OvmPM5BYFBnfWeFrJTl0fI4wg4fg?=
 =?us-ascii?Q?k8ZPQx5IUBiV1GqoyM11kRUbEBOw2uYhHh5iPglp/bS/LIUHQXHzXP6XQE7S?=
 =?us-ascii?Q?LtL5bMKeURl5Vl8aVw28pWJ2IJaNb1pKzYENXBgM8PMqwHCxjF6WgTik/yyV?=
 =?us-ascii?Q?4TyeASRZvLKPeOyX2MnjcfnTzTwu0uX8trDBCDPE5pJUgI2QPf8sKFl4AuD+?=
 =?us-ascii?Q?NtKvIBrMQgm3/BG9twX/5lsiB600yOsD+6gidQaJUqESTmSISGPxOZ6DLOx1?=
 =?us-ascii?Q?QYFqueDAmBr7BVv662wTJUeveG0z40du3liUiNPKSFV23ALA245XGGM7wfsk?=
 =?us-ascii?Q?cWDmtXb206H21IJ/DccZUQf1/ESOoKaRY6I34xc/GT5h7rcQXt2O9aMdwpGq?=
 =?us-ascii?Q?7Xb+PXLwhsYuOxw/YeGCoUOJOCccuP5RppdBvEMStCPRqUSTdW8x8QN5cq/P?=
 =?us-ascii?Q?71lD5LxV4YQpHl6NDrbrZ9he5Oou0pqxHSL57BcRiL/SDyjugw6PLKg99RqQ?=
 =?us-ascii?Q?4rjULq79P2ECPs5odWaBDBXrkJRbErlFJrEmyY0QzsxCF+bD/MfHeglVAmNj?=
 =?us-ascii?Q?cLD0tZW5sL9fIWSKamYPLrXGJQgerfhsHvfpa47OnKB6HZAwW65+RLvLTGQO?=
 =?us-ascii?Q?p/YBXnjimYGmt0JC9h/hY+So+UGvdUw+50+vWbsSn2PiSS4XAzhUgXr9IR2U?=
 =?us-ascii?Q?DfUMkeBU0CjTMLFLWJ11dFMnPuPORkoUdy4g0X3RF+gTJyeMfY5sSgpUUdp8?=
 =?us-ascii?Q?0as6t7c/5ttypghJ5icw/lnIq9bu00572/zPpuzwXrybLQmNm5XPTXY/gcdi?=
 =?us-ascii?Q?73iylhdIthAfe2efg5ESJ7k/8bUJWP5UuONjjzhHpVWMaZ+vDDg8/CtZKqfA?=
 =?us-ascii?Q?5xf2QgxRvcUhc5rYRaGW0BJB1RrheIpMem/aKum6W+D4Q5+HyvjoNN+nhgK1?=
 =?us-ascii?Q?Gx1Yqx0SKADXaiOKLNryRxzd/cGW3FTR+lcKHPaNpBeQJf0+UB6ZDlIMNq+Q?=
 =?us-ascii?Q?WnDEf6QMQsbDP9PAodb1IQKuq5LYDDs9o9gQVoJQPKg53+ftIF01r+RaEnUr?=
 =?us-ascii?Q?0R8V7gwZt9s17f78cG8vZfbBauLBZbIH9MVFXcVMQqFW6Y2jEkNXKVt7OSa4?=
 =?us-ascii?Q?ipQRNdpDsq8mwNLknJIGyhKY1auBtowP8MSlqulUzjzUqM8qvZAGTL6zcfqV?=
 =?us-ascii?Q?Be9eRQMhvcOsZygfPCyQ+5ustWrChHPcMCSDY/bIs0T2gYcR/haHo99X1Rut?=
 =?us-ascii?Q?xCfLGp3ubJa7CKQRGdDuYPhyYcEQ+LmCHQQOhPPpmq8L5fl5GIstxPCVCyXK?=
 =?us-ascii?Q?MHy3dIV2SmqApyjnkAkEkGenOaZ6BqUbZBG5laaguRM374czi9AD5Air6gUx?=
 =?us-ascii?Q?ZDZb131JWfP7k2pHPhZ4XcTob07fT8y9D74lNA/q8QE2uEi21AymHcPN0rKk?=
 =?us-ascii?Q?Df0+rOJHuCETeqpWSZ6gLCSbFqCewMCcssTRheoVBlMQVaZcvju0yeRgCKq9?=
 =?us-ascii?Q?xGBMjOb9zE+O80sZcgHNJQZchJlMrjk5KTmmSu6uFFBnGVOPW59dCjh8C6u8?=
 =?us-ascii?Q?seWVplCAmmy2y7d0SHA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1fb4b9a-ac95-4a36-6cd9-08db2c8f8876
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2023 17:45:18.3996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zNfrJ7PoE4W9NLdB1c8RYoYlFsmEOXXNFFSV/iwF36tlFoUdODzdjAjHGrttxZzQFSlQ5bxeD4uCvHs0+bCVsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7611
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > I'm not dead set against the proposed approach, but IMO it's not
> > obviously better than a bit of assembly to have a more direct call into=
 the NMI
> handler.
>=20
> I will give it a shot.

Hi Sean,

I got a working patch, before I resend the whole FRED patch set again, can
you please check if this is what you're expecting?

When FRED is enabled, the x86 CPU always pushes an error code on the stack
immediately after the return instruction address is pushed. To generate suc=
h
a stack frame, call a trampoline function first to push the return instruct=
ion
address on the stack, and the trampoline function then pushes an error code
(0 for IRQ/NMI) and jump to fred_entrypoint_kernel.

I could have vmx_do_interrupt_trampoline jump to fred_entrypoint_kernel
Instead of calling external_interrupt(), but that would reenter the noinstr
text again (not a big problem but seems not preferred by Peter Z).

Thanks!
  Xin

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 631fd7da2bc3..6682b5bd202b 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -31,7 +31,7 @@
 #define VCPU_R15       __VCPU_REGS_R15 * WORD_SIZE
 #endif

-.macro VMX_DO_EVENT_IRQOFF call_insn call_target
+.macro VMX_DO_EVENT_IRQOFF call_insn call_target fred=3D1 nmi=3D0
        /*
         * Unconditionally create a stack frame, getting the correct RSP on=
 the
         * stack (for x86-64) would take two instructions anyways, and RBP =
can
@@ -46,11 +46,34 @@
         * creating the synthetic interrupt stack frame for the IRQ/NMI.
         */
        and  $-16, %rsp
+
+       .if \fred
+       push $0         /* Reserved by FRED, must be 0 */
+       push $0         /* FRED event data, 0 for NMI and external interrup=
ts */
+
+       .if \nmi
+       mov $(2 << 32 | 2 << 48), %_ASM_AX      /* NMI event type and vecto=
r */
+       .else
+       mov %_ASM_ARG1, %_ASM_AX
+       shl $32, %_ASM_AX                       /* external interrupt vecto=
r */
+       .endif
+       add $__KERNEL_DS, %_ASM_AX
+       bts $57, %_ASM_AX                       /* bit 57: 64-bit mode */
+       push %_ASM_AX
+       .else
        push $__KERNEL_DS
+       .endif
+
        push %rbp
 #endif
        pushf
+       .if \nmi
+       mov $__KERNEL_CS, %_ASM_AX
+       bts $28, %_ASM_AX                       /* set the NMI bit */
+       push %_ASM_AX
+       .else
        push $__KERNEL_CS
+       .endif
        \call_insn \call_target

        /*
@@ -299,8 +322,19 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)

 SYM_FUNC_END(__vmx_vcpu_run)

+SYM_FUNC_START(vmx_do_nmi_trampoline)
+#ifdef CONFIG_X86_FRED
+       ALTERNATIVE "jmp .Lno_errorcode_push", "", X86_FEATURE_FRED
+       push $0         /* FRED error code, 0 for NMI */
+       jmp fred_entrypoint_kernel
+#endif
+
+.Lno_errorcode_push:
+       jmp asm_exc_nmi_kvm_vmx
+SYM_FUNC_END(vmx_do_nmi_trampoline)
+
 SYM_FUNC_START(vmx_do_nmi_irqoff)
-       VMX_DO_EVENT_IRQOFF call asm_exc_nmi_kvm_vmx
+       VMX_DO_EVENT_IRQOFF call vmx_do_nmi_trampoline nmi=3D1
 SYM_FUNC_END(vmx_do_nmi_irqoff)


@@ -358,5 +392,51 @@ SYM_FUNC_END(vmread_error_trampoline)
 #endif

 SYM_FUNC_START(vmx_do_interrupt_irqoff)
-       VMX_DO_EVENT_IRQOFF CALL_NOSPEC _ASM_ARG1
+       VMX_DO_EVENT_IRQOFF CALL_NOSPEC _ASM_ARG1 fred=3D0
 SYM_FUNC_END(vmx_do_interrupt_irqoff)
+
+#ifdef CONFIG_X86_64
+SYM_FUNC_START(vmx_do_interrupt_trampoline)
+       push $0 /* FRED error code, 0 for NMI and external interrupts */
+       push %rdi
+       push %rsi
+       push %rdx
+       push %rcx
+       push %rax
+       push %r8
+       push %r9
+       push %r10
+       push %r11
+       push %rbx
+       push %rbp
+       push %r12
+       push %r13
+       push %r14
+       push %r15
+
+       movq    %rsp, %rdi      /* %rdi -> pt_regs */
+       call external_interrupt
+
+       pop %r15
+       pop %r14
+       pop %r13
+       pop %r12
+       pop %rbp
+       pop %rbx
+       pop %r11
+       pop %r10
+       pop %r9
+       pop %r8
+       pop %rax
+       pop %rcx
+       pop %rdx
+       pop %rsi
+       pop %rdi
+       addq $8,%rsp            /* Drop FRED error code */
+       RET
+SYM_FUNC_END(vmx_do_interrupt_trampoline)
+
+SYM_FUNC_START(vmx_do_fred_interrupt_irqoff)
+       VMX_DO_EVENT_IRQOFF call vmx_do_interrupt_trampoline
+SYM_FUNC_END(vmx_do_fred_interrupt_irqoff)
+#endif
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d2d6e1b6c788..5addfee5cc6d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6875,6 +6875,7 @@ static void vmx_apicv_post_state_restore(struct kvm_v=
cpu *vcpu)
 }

 void vmx_do_interrupt_irqoff(unsigned long entry);
+void vmx_do_fred_interrupt_irqoff(unsigned int vector);
 void vmx_do_nmi_irqoff(void);

 static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
@@ -6923,7 +6924,12 @@ static void handle_external_interrupt_irqoff(struct =
kvm_vcpu *vcpu)
                return;

        kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
-       vmx_do_interrupt_irqoff(gate_offset(desc));
+#ifdef CONFIG_X86_64
+       if (cpu_feature_enabled(X86_FEATURE_FRED))
+               vmx_do_fred_interrupt_irqoff(vector);
+       else
+#endif
+               vmx_do_interrupt_irqoff(gate_offset(desc));
        kvm_after_interrupt(vcpu);

        vcpu->arch.at_instruction_boundary =3D true;
