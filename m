Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A73676F03A
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 18:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbjHCQ7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 12:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbjHCQ7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 12:59:45 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59207DA;
        Thu,  3 Aug 2023 09:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691081983; x=1722617983;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2bR+bfeo29GmoggxVSBxVV8jt+ti59iiN8Dhuk5gklw=;
  b=F0cu/9aaE61Uo1epyZJxGKJIxxdlY6h11mKsOjkxUVp3l9CFRuZbH0t9
   3DUc1MewBaRbJ23qqmjqHuIymaPPGsHXThGq3u/zldcELR4pe8oNJ53UE
   B2nAJ+norMLLKGLvridjeOocLtDVh+EqT1XKW10XNlPCWNzWAgy88wOPF
   Bp8yUtv4ZKaCh9WFmF9BYiJ/5YLKKyBxsEIyatc8X7QKUaryg66BEdVgF
   bHzNVK+bacmgYwNa/cCeGkuIJwOKx3kRcRRSoQ0rYZ+RWd7rx+Jr1ALOB
   TmI1ntx/4IZAbFUhkedzjBzEHfAr8o0xpCpFTPaVeL4PVGfovQ9h2QwZV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="367397336"
X-IronPort-AV: E=Sophos;i="6.01,252,1684825200"; 
   d="scan'208";a="367397336"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 09:58:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="679541479"
X-IronPort-AV: E=Sophos;i="6.01,252,1684825200"; 
   d="scan'208";a="679541479"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 03 Aug 2023 09:58:35 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 09:58:34 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 09:58:34 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 09:58:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7enksE22yIgC9mbwkTFdOdlR4eKjKs8QD9VU/KjpybvNsOHd7LcC2nNgMv3jhBzYkPA6GLuNTCLJOLh3fHA8JWqBHAnybaJJCaGrj0R6lpsKl+/F2ehYPcgySdjPlUlA29Af3nikGzcKXc9v7/3RyTvsW5hpxqavjngniVcPxc0Z3O5mtWvTw0ub3OfUBI5dK7QHmtA+U1D677rlpRLA3Kz/1VbUTQGVmC7uktbrK6LB9ffDFdWIyg/tF3/pD8qFHbIj+OIh8cvsXrgj8TcqrrQc+vJ4V32FQtG/CtROyZ2gPXP36vq3rVOeJ7OSDKatb24omqYy4C0yY7WFO0KEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8Z0arXM7cn5WNXFdep3jTI0WR66B1rgi1eh6OtTn6w=;
 b=IvPkjYFYcY874+PsjpshnI3xfCaNg9rmKy2GN2MeRKcvOLzPsyCsKZXrvCGRZGtjKusCXcd1VjGN5z4r+6jucrG/FRtBbKfrHWCr6s+25DMVoLmvcNJRKBpOXGb9NiETdPip4uREa3O6l9kPUktMj9MmSM9zjhrivJBIC33pWx6Xs5+LI/7uHVlS3rLNoBArh7JQe1Q04C0QTmDioLpTq25LOa1dR+T+AOmoGyZ6E1hQDk3WUORERuKTcHNLB9BLsBJLwAZqb2RVnRoFYOFX0UMNG2BQFy1NdJJYCFbk0UlZY7r5bx2Xuw229NSMR1gDLg2DVS9+n3BFuZnWEbtjcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CH3PR11MB7913.namprd11.prod.outlook.com (2603:10b6:610:12e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.20; Thu, 3 Aug
 2023 16:58:31 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::50e4:2cb8:4529:af04]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::50e4:2cb8:4529:af04%7]) with mapi id 15.20.6631.046; Thu, 3 Aug 2023
 16:58:31 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Li, Xin3" <xin3.li@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "Cui, Dexuan" <decui@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Stefano Stabellini" <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Breno Leitao <leitao@debian.org>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Brian Gerst <brgerst@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        "Alexander Potapenko" <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ze Gao <zegao2021@gmail.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Ostrovsky, Boris" <boris.ostrovsky@oracle.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Yantengsi <siyanteng@loongson.cn>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sathvika Vasireddy <sv@linux.ibm.com>
Subject: RE: [PATCH RESEND v9 33/36] KVM: VMX: Add VMX_DO_FRED_EVENT_IRQOFF
 for IRQ/NMI handling
Thread-Topic: [PATCH RESEND v9 33/36] KVM: VMX: Add VMX_DO_FRED_EVENT_IRQOFF
 for IRQ/NMI handling
Thread-Index: AQHZxFc6Fm9A65hsiUKYksIzWWSQ5K/VzGiAgABBoTCAArbF0A==
Date:   Thu, 3 Aug 2023 16:58:31 +0000
Message-ID: <SA1PR11MB6734A497DC7A0243A2F401EEA808A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230801083553.8468-1-xin3.li@intel.com>
 <20230801083553.8468-7-xin3.li@intel.com> <ZMlWe5TgS6HM98Mg@google.com>
 <SA1PR11MB673440DE4294DDE87D93AE54A80AA@SA1PR11MB6734.namprd11.prod.outlook.com>
In-Reply-To: <SA1PR11MB673440DE4294DDE87D93AE54A80AA@SA1PR11MB6734.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CH3PR11MB7913:EE_
x-ms-office365-filtering-correlation-id: 1340e906-affa-4bcd-abbb-08db9442dde2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZM3l2evIVK4S4X2wwWEz9wOpONWmR1I7RGBz23BuvnVFa3lp4Xq0r3P0iu9nAheAfbjd8MXQ39VbuRzo/CXTp10uEP3eavR/J72iYqucerJ6zt6iIC8PJ1+XhzvGNVyK7u6MavVrU9TEgSqjbbZQNezJ8OGwJG7neikGSU7+mlSxi9hoR5i8RxW/GWTcyYl328UQC8z7m9oGtfEVXaoerRJFktRRmqHpA1Du28JwNrG1vzMhgToR3aXs31g2fw5pkgfIGdIj34IrOhwOxf/5D6H/vK7+kxVCt9SrT6lciPmkYEJmgP/DIPLyE7amCUS5iWyr1Msra6yE6G/Rx/wcCjd/OHB/54t3kNkA++LM10TlRvZVQTb0fFoCoIFPCPSA5Sf53eZ25OhWuy9vkUaLvhmfoq+A/zQktJbzAdmDbUnVKOdh88SqRvDGg0LgfCU/vE5uIe1CCLjqMyWhB+vLh4UBa57mJluve9CtB76BV9fRO1TLHhq70xquwRkSVh7s4QktdeldifQ/RFdKIviCO3akc9McrG65iBkw4WPwpqPn/5cEDrUF5XxjkcPOiQIz+3YW6oMRjBCwwZVbiCohQ3uP+IC1/Mmqlb8/L6B2l+Atn+3yyUfe12pxX+UQqp95
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199021)(41300700001)(8936002)(8676002)(83380400001)(186003)(6506007)(26005)(82960400001)(86362001)(38100700002)(122000001)(38070700005)(316002)(71200400001)(478600001)(54906003)(9686003)(7696005)(66556008)(33656002)(110136005)(55016003)(64756008)(66446008)(4326008)(66476007)(66946007)(76116006)(2906002)(7366002)(7406005)(7416002)(52536014)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fO8D8G6PJfDfa2DVRt831A/mgOTPQYjjZkj10MRsn72LULvaVp7cyN8JtSzv?=
 =?us-ascii?Q?45v0/JYCj2iW6Ddx2bW2BX9UG/QWaVW/FPd3OvkqhtV+EP7xndAWGtHrqD1H?=
 =?us-ascii?Q?50MzbLH1/r4QXBcTkjORa6yb8AQSOOYib1j+uprWFtFO7Cj649UMeGfogj5b?=
 =?us-ascii?Q?k6ME0dVjxMZzHJnS0N3Axj88e9MXmwBYKxXvf3CzLWRH/XOziRs89+Vq3pMW?=
 =?us-ascii?Q?XVVX2LY18V9W0RevyRJHWTqE6BtsyPptf1MqDEbSFI3GNKJSvWCu3FvXDl9b?=
 =?us-ascii?Q?Ws5NUFWQtkO7LzkZF68iraPhj2CvgeZ0MMxCUb7c0tb7KEReJb//0QpiK1fJ?=
 =?us-ascii?Q?2/ViytgsQH+jU/BFcrJ0CV5/XDQ+T6ap5tqxpHFzm62I/pys6bn8VF92lEMf?=
 =?us-ascii?Q?ekdc/hm1BDDdHIv6OJJhLjRvLEqepSbPskigHwuFABfrDaApbZmg+EpIMyly?=
 =?us-ascii?Q?jS2pVBJE/DYjCc4zclA07T6Z+x8XANmkAm9hDfnwVesyolWmplUTvxjlCEgk?=
 =?us-ascii?Q?lAhadzhG2ZBOd7Yzio452XRSexjZ/bLzqPzsttGSvnRKnyM5iqELTonrqGc2?=
 =?us-ascii?Q?XHRzubs7IvQYhgG6C9+VEFhFm4yqYiTfDYTdo+zK9d7wwQ1bGt5ADl72pArY?=
 =?us-ascii?Q?IzcrBJtmp7XDSdtbaPxG5s2d8Y/JL91ywBG+CLJ/ToVtS+Jo7BzhsQy3GVbZ?=
 =?us-ascii?Q?yoU3UL6wWfsBBR+xr2sb/nf5mbW6PeL7/7qR0I9XhA4pgnrW5ezphW1fxRwg?=
 =?us-ascii?Q?HVV8s6T/h5pvjQ8E9UJuq48VKAr+Yceh6Ggz3ET2Pf72RHi1cwaDr3Aw96ln?=
 =?us-ascii?Q?X0T/NgpsroVatD5aMgygyAE5rZFkuYDAspzGBGqL3B9zalpnW6Grflw/ybKy?=
 =?us-ascii?Q?OgUSEaNEggPQbWd30xm9BMDJax5M7gp50Uev1D1QYCGbs16/lFh8wMIxEhW1?=
 =?us-ascii?Q?a5XqDH2lzZCy2cQ3+co4SCvsPkdIMg3Wnr8j0OHqx7FlyIRHPJSE2mE+WKzj?=
 =?us-ascii?Q?iQNWNKGyEjxo1ib+NZOLprWZQTfiQ+uWQVMlzx55DPyjkdk0T16DiaBhyQEn?=
 =?us-ascii?Q?l3qoFlbewzl+2d3Mc1sCLCtGxMgtkJS33hgs1SD28V0fOkuboey4bPPfqecY?=
 =?us-ascii?Q?mzXI8C8IVwDrGK7HyZhIs7ETXpyS4XqcWNRWWWSryfPAE22fMtUbklTvTWKV?=
 =?us-ascii?Q?JVPIw42QG4O4XXdji9RBpS1wZalvanTvsuKIEVp64hSz1qPpD3m7HmNIEGxx?=
 =?us-ascii?Q?Chn0HEm+r5y6amPM+grXXdq/o1y1CV1mQhhUBnkdgO6XqBQjgwQ1S+e2yRm4?=
 =?us-ascii?Q?7y1jt8yAOttqF00wNscPhWyzpborfU2mo5MN/l+bDU0VybCKjVXQB60qxG8i?=
 =?us-ascii?Q?TWVBYeosZVNe3euNplABbxRX1Z6wXuRjTMDl1aGsV+BrgdfPwYLncIQ+oM5l?=
 =?us-ascii?Q?wwmXYZyu147doDVRuoWTuIszer2AX/OdYlq80G9z0X3s9LBDwRtYbj1V+SdA?=
 =?us-ascii?Q?05eqxpVmFinJcJT2bmhM823hjAqNBIAkLus7eLXckQkDVqRSj5n95zEIT+ol?=
 =?us-ascii?Q?KfQYuzUPgpIw3flH8uc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1340e906-affa-4bcd-abbb-08db9442dde2
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2023 16:58:31.4173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rvadL9VkWw6g5APvNrm1GN3Yrg5AxRdKs5O+sh9uC6LPCEMPy69e7Su8lkjXx/63pkMSS/SlNtfxIPg82G4Etw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7913
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Jumping way back to providing a wrapper for FRED, if we do that, then
> > there's no need to include calling.h, and the weird wrinkle about the
> > ERET target kinda goes away too.  E.g. provide this in
> > arch/x86/entry/entry_64_fred.S
> >
> > 	.section .text, "ax"
> >
> > /* Note, this is instrumentation safe, and returns via RET, not ERETS!
> > */ #if IS_ENABLED(CONFIG_KVM_INTEL)
> > SYM_CODE_START(fred_irq_entry_from_kvm)
> > 	FRED_ENTER
> > 	call external_interrupt
> > 	FRED_EXIT
> > 	RET
> > SYM_CODE_END(fred_irq_entry_from_kvm)
> > EXPORT_SYMBOL_GPL(fred_irq_entry_from_kvm);
> > #endif
> >
> > and then the KVM side for this particular chunk is more simply:
> >
> > 	lea 1f(%rip), %rax
> > 	push %rax
> > 	push $0		/* FRED error code, 0 for NMI and external
> > interrupts */
> >
> > 	\branch_insn \branch_target

The call instruction here inserts a return address between the FRED
stack frame just created and the GP regs pushed in the FRED wrapper,
thus it doesn't work.  I only realize it after looking at the stack layout
in the Intel Simics emulator.

> > 1:
> > 	VMX_DO_EVENT_FRAME_END
> > 	RET
>
> > Alternatively, the whole thing could be shoved into
> > arch/x86/entry/entry_64_fred.S, but at a glance I don't think that
> > would be a net positive due to the need to handle IRQs vs. NMIs.

But following your idea of "the whole thing could be shoved into ...",
plus the patch you posted, I get a patch as the following, which works
and gets rid of the 2 warnings of "with modified stack frame".

After calling external_interrupt() and POP_REGS, we can also use ERETS,
thus to unify the stack adjustment.

diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.=
S
index de9e2dc70e40..2b638914c6ed 100644
--- a/arch/x86/entry/entry_64_fred.S
+++ b/arch/x86/entry/entry_64_fred.S
@@ -4,12 +4,87 @@
  */
=20
 #include <asm/asm.h>
+#include <asm/export.h>
 #include <asm/fred.h>
+#include <asm/segment.h>
=20
 #include "calling.h"
=20
 	.code64
=20
+#if IS_ENABLED(CONFIG_KVM_INTEL)
+.macro FRED_ENTRY_FROM_KVM event_func nmi=3D0
+	ENDBR
+#ifdef CONFIG_X86_FRED
+	push %rbp
+	mov %rsp, %rbp
+
+	/*
+	 * Don't check the FRED stack level, the call stack leading to this
+	 * helper is effectively constant and shallow (relatively speaking).
+	 *
+	 * Emulate the FRED-defined redzone and stack alignment.
+	 */
+	sub $(FRED_CONFIG_REDZONE_AMOUNT << 6), %rsp
+	and $FRED_STACK_FRAME_RSP_MASK, %rsp
+
+	/*
+	 * Start to push a FRED stack frame, which is always 64 bytes:
+	 *
+	 * +--------+-----------------+
+	 * | Bytes  | Usage           |
+	 * +--------+-----------------+
+	 * | 63:56  | Reserved        |
+	 * | 55:48  | Event Data      |
+	 * | 47:40  | SS + Event Info |
+	 * | 39:32  | RSP             |
+	 * | 31:24  | RFLAGS          |
+	 * | 23:16  | CS + Aux Info   |
+	 * |  15:8  | RIP             |
+	 * |   7:0  | Error Code      |
+	 * +--------+-----------------+
+	 */
+	push $0					/* Reserved, must be 0 */
+	push $0					/* Event data, 0 for IRQ/NMI */
+
+	shl $32, %rdi				/* Event type and vector */
+	.if \nmi
+	bts $FRED_SSX_NMI_BIT, %rdi
+	.endif
+	bts $FRED_SSX_64_BIT_MODE_BIT, %rdi
+	or $__KERNEL_DS, %rdi
+	push %rdi
+	push %rbp
+	pushf
+	mov $__KERNEL_CS, %rax
+	push %rax
+
+	/*
+	 * Unlike the IDT event delivery, FRED _always_ pushes an error code
+	 * after pushing the return RIP, thus the CALL instruction CANNOT be
+	 * used here to push the return RIP, otherwise there is no chance to
+	 * push an error code before invoking the IRQ/NMI handler.
+	 *
+	 * Use LEA to get the return RIP and push it, then push an error code.
+	 */
+	lea 1f(%rip), %rax
+	push %rax				/* Return RIP */
+	push $0					/* Error code, 0 for IRQ/NMI */
+
+	PUSH_AND_CLEAR_REGS
+	movq %rsp, %rdi				/* %rdi -> pt_regs */
+	call \event_func
+	POP_REGS
+	ERETS
+1:
+	pop %rbp
+	RET
+#else /* CONFIG_X86_FRED */
+	ud2
+#endif /* CONFIG_X86_FRED */
+.endm
+#endif /* CONFIG_KVM_INTEL */
+
 .macro FRED_ENTER
 	UNWIND_HINT_END_OF_STACK
 	ENDBR
@@ -22,6 +97,16 @@
 	POP_REGS
 .endm
=20
+	.section .text, "ax"
+
+/* Note, this is instrumentation safe, and returns via RET */
+#if IS_ENABLED(CONFIG_KVM_INTEL)
+SYM_CODE_START(fred_irq_entry_from_kvm)
+	FRED_ENTRY_FROM_KVM external_interrupt
+SYM_CODE_END(fred_irq_entry_from_kvm)
+EXPORT_SYMBOL_GPL(fred_irq_entry_from_kvm);
+#endif
+
 	.section .noinstr.text, "ax"
=20
 /*
@@ -55,3 +140,10 @@ SYM_CODE_START_NOALIGN(fred_entrypoint_kernel)
 	FRED_EXIT
 	ERETS
 SYM_CODE_END(fred_entrypoint_kernel)
+
+#if IS_ENABLED(CONFIG_KVM_INTEL)
+SYM_CODE_START(fred_nmi_entry_from_kvm)
+	FRED_ENTRY_FROM_KVM fred_exc_nmi nmi=3D1
+SYM_CODE_END(fred_nmi_entry_from_kvm)
+EXPORT_SYMBOL_GPL(fred_nmi_entry_from_kvm);
+#endif
diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 3c91f0eae62e..c7288213de14 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -122,6 +122,10 @@ DECLARE_FRED_HANDLER(fred_exc_double_fault);
 extern asmlinkage __visible void fred_entrypoint_user(void);
 extern asmlinkage __visible void fred_entrypoint_kernel(void);
=20
+/* For KVM VMX to handle IRQs in IRQ induced VM exits */
+extern asmlinkage __visible void fred_irq_entry_from_kvm(unsigned int even=
t_info);
+extern asmlinkage __visible void fred_nmi_entry_from_kvm(unsigned int even=
t_info);
+
 #endif /* __ASSEMBLY__ */
=20
 #endif /* CONFIG_X86_FRED */
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index be275a0410a8..f6f557c6329e 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -40,6 +40,20 @@
 	push %_ASM_BP
 	mov %_ASM_SP, %_ASM_BP
=20
+	/*
+	 * Start to push an IDT IRQ/NMI stack frame, which is 40 bytes on
+	 * x86_64 and 24 bytes on x86_32:
+	 *
+	 * +-------+-------------------+
+	 * | Bytes | Usage             |
+	 * +-------+-------------------+
+	 * | 39:32 | SS (x86_64 only)  |
+	 * | 31:24 | RSP (x86_64 only) |
+	 * | 23:16 | RFLAGS            |
+	 * |  15:8 | CS                |
+	 * |   7:0 | RIP               |
+	 * +-------+-------------------+
+	 */
 #ifdef CONFIG_X86_64
 	/*
 	 * Align RSP to a 16-byte boundary (to emulate CPU behavior) before
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index df461f387e20..83c89239fcff 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6961,14 +6961,16 @@ static void handle_external_interrupt_irqoff(struct=
 kvm_vcpu *vcpu)
 {
 	u32 intr_info =3D vmx_get_intr_info(vcpu);
 	unsigned int vector =3D intr_info & INTR_INFO_VECTOR_MASK;
-	gate_desc *desc =3D (gate_desc *)host_idt_base + vector;
=20
 	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
 	    "unexpected VM-Exit interrupt info: 0x%x", intr_info))
 		return;
=20
 	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
-	vmx_do_interrupt_irqoff(gate_offset(desc));
+	if (cpu_feature_enabled(X86_FEATURE_FRED))
+		fred_irq_entry_from_kvm((EVENT_TYPE_HWINT << 16) | vector);
+	else
+		vmx_do_interrupt_irqoff(gate_offset((gate_desc *)host_idt_base + vector)=
);
 	kvm_after_interrupt(vcpu);
=20
 	vcpu->arch.at_instruction_boundary =3D true;
@@ -7254,7 +7256,10 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_v=
cpu *vcpu,
 	if ((u16)vmx->exit_reason.basic =3D=3D EXIT_REASON_EXCEPTION_NMI &&
 	    is_nmi(vmx_get_intr_info(vcpu))) {
 		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
-		vmx_do_nmi_irqoff();
+		if (cpu_feature_enabled(X86_FEATURE_FRED))
+			fred_nmi_entry_from_kvm((EVENT_TYPE_NMI << 16) | NMI_VECTOR);
+		else
+			vmx_do_nmi_irqoff();
 		kvm_after_interrupt(vcpu);
 	}

