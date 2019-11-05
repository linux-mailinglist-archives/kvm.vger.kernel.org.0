Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 237E9EF2FF
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 02:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729987AbfKEBr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 20:47:56 -0500
Received: from mail-eopbgr790050.outbound.protection.outlook.com ([40.107.79.50]:60373
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728987AbfKEBrz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 20:47:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VS8GdFyTMmdN1uoEBid9ZfFnA3D6X4qu8ICBMrDBVEeOf+i5BBA1RhU84lxRi3YusZoK0St2hBYWG12n53V1cfHjumoG2O4GHBWlS/K0DrkBrdbf/sGwJf33kePW9DP6BrOQQuutnVuEvFhQaFM5CBrknFQ99YSF4eZAxMaIBL2V513aPGMnjO6tWAkT/tcbsiYC0JW5XU081PB2FVE82OkRgI4LBYRkbdLVMz7knQb5p77cPXyC7aRj8MekFKvEOPhwrdnvB0OpxKBeGKJCthcwACK42jAKEEnRiMGptikap1CbrRmrfQ2XqgGYEMmFzQtf11iyiL9yBy/ydKxSZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5qmlbrJB5LhBxfZttqmf9adn0itvRN+X8QjliwTl5A=;
 b=DescLQCRv919EZl0Q96VC5GThf8sjV+EuX52dh5sZOm9ZFKepEYzLRqrEfvps5t5knKUzjLjHWCyFq+ZGnf5boxTf8gKy/Y6Xk30ViO3/QUradIB8lTw+6Gh4Jk1UMPQcr0lzL6OTl4Erx5qvTFyhN7oBsQaDdVPo92MqzW+cpTClHDgUCpVnWI6l5ytygxo7Q0FxH1A44RBSCQe1+2iP7xTWGaU5ep2dCg5RNs152WmhE/bESmRXcIM0yKxLvs86yvptskOIoTA8+/pODtfolJTjqSn7M9LImkLPkFWkeH2yvTSALSR9viVqFjo6eaE1g/fcsHWSt/2o1Vka2gDrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5qmlbrJB5LhBxfZttqmf9adn0itvRN+X8QjliwTl5A=;
 b=Ax/1K9LtOZxBSTnBm2JXROPcnuEPct0BvzfHpBixKJaf445kWDJPGDtnMgUJ+ZAnf/wYHi9voE7EVQ39up6MFGKveJYFD0eUXC9i+yZNhCRApQ+7f6LIqbT7dly4+tjgGeO6F08Tig45R0uMB5uEmY/hsPbN851UR5dsktu8zpA=
Received: from DM5PR12MB2471.namprd12.prod.outlook.com (52.132.141.138) by
 DM5PR12MB1484.namprd12.prod.outlook.com (10.172.40.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 01:47:52 +0000
Received: from DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::c5a3:6a2e:8699:1999]) by DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::c5a3:6a2e:8699:1999%6]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 01:47:52 +0000
From:   "Moger, Babu" <Babu.Moger@amd.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v2] x86/Kconfig: Rename UMIP config parameter
Thread-Topic: [PATCH v2] x86/Kconfig: Rename UMIP config parameter
Thread-Index: AQHVk1GLQf345nN80kenPnepADNDDqd7jKeAgABB91A=
Date:   Tue, 5 Nov 2019 01:47:52 +0000
Message-ID: <DM5PR12MB2471206F9EC8E443B00E6B36957E0@DM5PR12MB2471.namprd12.prod.outlook.com>
References: <157290058655.2477.5193340480187879024.stgit@naples-babu.amd.com>
 <20191104214851.GD5960@linux.intel.com>
In-Reply-To: <20191104214851.GD5960@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-originating-ip: [2600:1700:270:e9d0:3c89:875f:4410:7d2c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 95422326-c629-485b-cd48-08d761922c18
x-ms-traffictypediagnostic: DM5PR12MB1484:
x-microsoft-antispam-prvs: <DM5PR12MB14843D99F8116AEA2D480EDD957E0@DM5PR12MB1484.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(189003)(199004)(13464003)(55016002)(76176011)(7416002)(71200400001)(53546011)(476003)(76116006)(99286004)(66476007)(6436002)(46003)(102836004)(5660300002)(6246003)(9686003)(229853002)(54906003)(316002)(6506007)(7696005)(52536014)(8676002)(66946007)(81156014)(81166006)(186003)(8936002)(478600001)(305945005)(66446008)(6116002)(6916009)(64756008)(66556008)(486006)(14454004)(7736002)(74316002)(446003)(86362001)(11346002)(25786009)(256004)(33656002)(4326008)(14444005)(71190400001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1484;H:DM5PR12MB2471.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dlf8Cc6AtY6kby5J8sVmoGfSfIX4nVLNCe78FvVdi8l3KHc5C9P9opdq9eoUbIi/m1BFKkTF/UoCFmHMQeSjn8oqy5HTDYycKhrcw1LL9b3lGW/KaoDzWhhGd3eyv/ZotkqNuGwu+2WNUeilMiMskj7lX9i63w5+uqaUrxL9eT+2tbNIWlLhCmNynpcyqNDqgOhZuSAqmvAe6iVSvzLZ66K3zYBt53ST0VzOHoN1V0igOgWrazkaEvQTAdYOg87RcRk+KJOkCZtzTy0Hne7mncop9gQ3T1YA5auBfA9sdbcUSxhBq02lyJWHBZ39k06LFW6SiiJU20OVWQYIgTSbVHLuionFXT8oOnVIf5fPEChcxdQ1TCkOC9XTF7dCv8+UCU4lnN3PXxi0tuwb6MkizZPlVfQNgdD74Sk6ip9UfP0zyHJwbo+QAp0RU3FA0Diu
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95422326-c629-485b-cd48-08d761922c18
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 01:47:52.6598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CsUhnfUpBzxnqoTgWy2SW58agXkOkCCTYrQq+bW1vhMsrZDEwHH+2UAMVjf2BDVC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1484
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> Sent: Monday, November 4, 2019 3:49 PM
> To: Moger, Babu <Babu.Moger@amd.com>
> Cc: tglx@linutronix.de; mingo@redhat.com; bp@alien8.de; hpa@zytor.com;
> pbonzini@redhat.com; rkrcmar@redhat.com; vkuznets@redhat.com;
> wanpengli@tencent.com; jmattson@google.com; x86@kernel.org;
> joro@8bytes.org; luto@kernel.org; zohar@linux.ibm.com;
> yamada.masahiro@socionext.com; nayna@linux.ibm.com; linux-
> kernel@vger.kernel.org; kvm@vger.kernel.org
> Subject: Re: [PATCH v2] x86/Kconfig: Rename UMIP config parameter
>=20
> On Mon, Nov 04, 2019 at 08:50:51PM +0000, Moger, Babu wrote:
> > AMD 2nd generation EPYC processors support the UMIP (User-Mode
> > Instruction Prevention) feature. So, rename X86_INTEL_UMIP to
> > generic X86_UMIP and modify the text to cover both Intel and AMD.
>=20
> There's a similar comment in the umip.c documentation that needs to be
> updated, and a grammatical error that can be opportunistically fixed, i.e=
.
>=20
>  * The feature User-Mode Instruction Prevention present in recent Intel
>  * processor
>=20
> to
>=20
>  * The feature User-Mode Instruction Prevention present in recent x86
>  * processors
>=20
Sure.
>=20
> IMO, the whole opening paragraph of the umip.c docs is weirdly worded and
> could be rewritten to something similar to the Kconfig help text, e.g.
>=20
>  * User-Mode Instruction Prevention is a security feature present in rece=
nt x86
>  * processors that, when enabled, prevents a group of instructions (SGDT,=
 SIDT,
>  * SLDT, SMSW and STR) from being run in user mode by issuing a general
>  * protection fault if the instruction is executed with CPL > 0.

Sure. Will update it. Will add as patch #2 as this is separate from config =
file.

>=20
> >
> > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > ---
> > v2:
> >   Learned that for the hardware that support UMIP, we dont need to
> >   emulate. Removed the emulation related code and just submitting
> >   the config changes.
> >
> >  arch/x86/Kconfig                         |    8 ++++----
> >  arch/x86/include/asm/disabled-features.h |    2 +-
> >  arch/x86/include/asm/umip.h              |    4 ++--
> >  arch/x86/kernel/Makefile                 |    2 +-
> >  4 files changed, 8 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index d6e1faa28c58..821b7cebff31 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1880,13 +1880,13 @@ config X86_SMAP
> >
> >  	  If unsure, say Y.
> >
> > -config X86_INTEL_UMIP
> > +config X86_UMIP
> >  	def_bool y
> > -	depends on CPU_SUP_INTEL
> > -	prompt "Intel User Mode Instruction Prevention" if EXPERT
> > +	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
> > +	prompt "User Mode Instruction Prevention" if EXPERT
> >  	---help---
> >  	  The User Mode Instruction Prevention (UMIP) is a security
>=20
> Maybe opportunistically drop "The"?
Sure.
>=20
> > -	  feature in newer Intel processors. If enabled, a general
> > +	  feature in newer x86 processors. If enabled, a general
> >  	  protection fault is issued if the SGDT, SLDT, SIDT, SMSW
> >  	  or STR instructions are executed in user mode. These instructions
> >  	  unnecessarily expose information about the hardware state.
> > diff --git a/arch/x86/include/asm/disabled-features.h
> b/arch/x86/include/asm/disabled-features.h
> > index a5ea841cc6d2..8e1d0bb46361 100644
> > --- a/arch/x86/include/asm/disabled-features.h
> > +++ b/arch/x86/include/asm/disabled-features.h
> > @@ -22,7 +22,7 @@
> >  # define DISABLE_SMAP	(1<<(X86_FEATURE_SMAP & 31))
> >  #endif
> >
> > -#ifdef CONFIG_X86_INTEL_UMIP
> > +#ifdef CONFIG_X86_UMIP
> >  # define DISABLE_UMIP	0
> >  #else
> >  # define DISABLE_UMIP	(1<<(X86_FEATURE_UMIP & 31))
> > diff --git a/arch/x86/include/asm/umip.h b/arch/x86/include/asm/umip.h
> > index db43f2a0d92c..aeed98c3c9e1 100644
> > --- a/arch/x86/include/asm/umip.h
> > +++ b/arch/x86/include/asm/umip.h
> > @@ -4,9 +4,9 @@
> >  #include <linux/types.h>
> >  #include <asm/ptrace.h>
> >
> > -#ifdef CONFIG_X86_INTEL_UMIP
> > +#ifdef CONFIG_X86_UMIP
> >  bool fixup_umip_exception(struct pt_regs *regs);
> >  #else
> >  static inline bool fixup_umip_exception(struct pt_regs *regs) { return=
 false; }
> > -#endif  /* CONFIG_X86_INTEL_UMIP */
> > +#endif  /* CONFIG_X86_UMIP */
> >  #endif  /* _ASM_X86_UMIP_H */
> > diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> > index 3578ad248bc9..52ce1e239525 100644
> > --- a/arch/x86/kernel/Makefile
> > +++ b/arch/x86/kernel/Makefile
> > @@ -134,7 +134,7 @@ obj-$(CONFIG_EFI)			+=3D sysfb_efi.o
> >  obj-$(CONFIG_PERF_EVENTS)		+=3D perf_regs.o
> >  obj-$(CONFIG_TRACING)			+=3D tracepoint.o
> >  obj-$(CONFIG_SCHED_MC_PRIO)		+=3D itmt.o
> > -obj-$(CONFIG_X86_INTEL_UMIP)		+=3D umip.o
> > +obj-$(CONFIG_X86_UMIP)			+=3D umip.o
> >
> >  obj-$(CONFIG_UNWINDER_ORC)		+=3D unwind_orc.o
> >  obj-$(CONFIG_UNWINDER_FRAME_POINTER)	+=3D unwind_frame.o
> >
