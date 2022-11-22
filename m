Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1B4633D07
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 14:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbiKVNBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 08:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbiKVNBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 08:01:11 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC5E62394;
        Tue, 22 Nov 2022 05:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669122064; x=1700658064;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YY8Oqdv0nFRkpyjHtsYCodiN4/mDabpGF8GEpJL2Vo0=;
  b=lXDZBfvdQeKdB9dYyQ7O5dwnB7smNUdP5DjQJcT0ipy+KL6gI1bC+Q5b
   ZdrMbGXF6hlFt85HUXgGs9CnAJ1nXSd2ZbWJp2vM5E4CLphS8d02sDjeS
   j05qbPGxZABCCWi5S8AIDltHanEc1g9J3voKy7J/vba3WKY25+AwRmF99
   Nw1tf0RE6V+/KbJ/G6GK+W8MGsE0EZICn780hYUVwdJQ22Ks5d+/ws0dy
   N970pm1YoBPIQ5guaFt1ElD4ddQ1McQ6lSlddR0YJQSHamPAwrGCEKjo8
   Rv6wwcm1NlNnDXGKX7PccNQMVD4Yn0C8lcRMWNLgLfG+Wm3rUXg0MO9GT
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="294198202"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="294198202"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 05:01:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="619204012"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="619204012"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 22 Nov 2022 05:01:03 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 05:01:02 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 05:01:02 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 05:01:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W9KVlAh2CsqwQPZevSVTkk3Dup453EHGsj+plkskb3sLHRqy7sYAV0udvFZfYLo6KUMcVxzMrnwFd0oYg7FeiRHfsWIdjo/q/OJzXdgFVWolx2Qs6gJHDDlJd2McnrCl7mqgX5NERaYNjlyls5dqffIW3VKhYBLa/LvyiiHPWT0FVwDOocj0rqvs8WNQcsFSS+Rs9o0BPI19NEq7jV7QdvFBufAr+VaB4X5fngA5RoU7VAbzhgCD3B/Y9JUQlA2ea31J/V/hdEjj5J5XS/R9vC+JjFkztPucDtqr3Vk7/Y2V38Gcr1SmJvmlLVccB4uyVIBFrDJ6xxJZu/RUqDQdhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kxAdoEuEuuhA8BJSVEBH6tLsGhKU5dI+n6k1cYaXms8=;
 b=DZboQMsfpvM1DnFlxhRuB830Ic4YXvWglLVvW2nRNINSO+bEGXzwl5djrod6nDOKDOxaWxnngQwzWLkLQ1QWIq689bZLWkCDavhuHDnXN3Ei+oBDSRH5x4NtvodT+65l70iBr78sLxiQivNFpcUv3+TLwcCBq1bC5vUhdsiD2xJjidiX8PEfKPZZlXbr2QB+1GnOlrLnCguJ9LH5gXydzxCOD/zzj8PmbgeJT3MkcmsHNAWTrgVTq4Smg5vwJ75y1wAlyaQG0XCPRIAnMkPxsw6rllq84iBljouE0fnwuAdq0XBawK9QmOEF4yygT2AacnxLcjuVCctJm51WBDOfYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by CH0PR11MB5412.namprd11.prod.outlook.com
 (2603:10b6:610:d3::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 13:00:58 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c%11]) with mapi id 15.20.5834.015; Tue, 22 Nov
 2022 13:00:58 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Li, Xin3" <xin3.li@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Topic: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Index: AQHY9M9YytlyKV7ob0GK/oJbeBhPY6433PwAgACmfxCAAO8aAIAAL0qAgAAENoCAAAgUAIAAGnuAgAA1qHCAACERAIADuBAAgABQYICAAXpoEIAAGnIAgAK/reCAANL/AIAAhVlggAcl+kA=
Date:   Tue, 22 Nov 2022 13:00:57 +0000
Message-ID: <BN6PR1101MB2161FCA1989E3C6499192028A80D9@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net>
 <6fd26a70-3774-6ae7-73ea-4653aee106f0@redhat.com>
 <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net>
 <BN6PR1101MB216141A21353AB84CEA541DFA8009@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y26jkHfK9INwU7Yy@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161E8217F50D18C56E5864EA8059@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3IFo9NrAcYalBzM@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161299749E12D484DE9302BA8049@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3NZQBJugRt07udw@hirez.programming.kicks-ass.net>
 <DM5PR1101MB2172D7D7BC49255DB3752802A8069@DM5PR1101MB2172.namprd11.prod.outlook.com>
 <Y3ZYiKbJacmejY3K@google.com>
 <BN6PR1101MB21611347D37CF40403B974EDA8099@BN6PR1101MB2161.namprd11.prod.outlook.com>
In-Reply-To: <BN6PR1101MB21611347D37CF40403B974EDA8099@BN6PR1101MB2161.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|CH0PR11MB5412:EE_
x-ms-office365-filtering-correlation-id: 31182a29-8e78-4d0e-5bac-08dacc89994d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kxxy58Zlr2tisl+23/kCZvdFTbipPoOVy+Xv0nxKjGqHCceZhCCyOMp67KMjX24GQjkh2PLHLCykEVUnLz8gGQkoj6fMb3cpiObOdGiNBd6PzEzNCvAabf2qn18HjIUpVd/G6OAXRCitrN/jtDbnmk5rwI0H5Vs19jqGGRmoUMr0bfAKmFYr4CpGkx1ZiMpHniQIjsGiXzOb6Wc6kgwZTmdQaZ4Sz8uSpCRxhx5xgfCtkYHcaHJizmMQks/NnOVPDJiX6zWiM52+0Mlwg+X2L7TX4XbZzmgWDeIH+kF4CZ5Ghnjlc7/MAlZPnjc8HvbaebfCi7EQQzr5EyZQ66kMaYnaWuVC4C0A25IU1DfiAORRPTwPBOPsa40Hz4/fbLo+pCejAqiEXDoydRNWaqYLJNE9qNfHYp98bOZ5IEd+OM84jQo4aFl306FnEO2yiYf/luKfImMwlJE6lRaXhHcFzvHDmdmJwXLcXn8KCHHdfYuoIgl1Q2BmsDXJ/ZKM1gcMoMMj5QCQCOo1W2SOeCICgog5UBuL5Lpr3CK8ZIaWHS8hg/iVaZj5haeuUCZ5kg41D+bMOWUkosZDrnUIYOpMbP5AslwzsHwspkz4WWQsDT/MaaqdScWhGQ0vu9rs3EP4xBv8a/2/bCqhJe3SckZJvlD2V8yjb98Ixp2qS/Csgwl6aLH2tPqXxp8DsuWNMrLsSlBrZNaxe6PAfvh5FQIrcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199015)(5660300002)(7416002)(54906003)(7696005)(83380400001)(6506007)(82960400001)(316002)(66476007)(33656002)(76116006)(8676002)(64756008)(9686003)(110136005)(41300700001)(4326008)(26005)(66446008)(66946007)(66556008)(52536014)(8936002)(186003)(122000001)(38070700005)(38100700002)(2906002)(55016003)(86362001)(71200400001)(66899015)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oaWuIiY9AaOhyYtyLzgKls9oa/z9wo/3N3ZPsSazodDLX5GWEO9kTK7/3JHy?=
 =?us-ascii?Q?qrpXDcL9HbynDnlk7bTDHz7w1EIIXTUEl/ZS8EbZpp7ZmUCjOxxisCaaSjuQ?=
 =?us-ascii?Q?Elv8B0HsPgRLhr1PYJMPQGA1HM4RDfOuAyUPwAy5jMXD0x0Bo387vsgaM2jT?=
 =?us-ascii?Q?Fbrx6JUY7A6cZjBacgEW6BdDLAkuzfyk+7kuwkpLELsqX/w3Vgl9dIG6XapO?=
 =?us-ascii?Q?DsoDJSOFT8IYjmxt0GtBYOUJNU3fB+vgPdpGXwOBQChWcRXEayA+JWreasRE?=
 =?us-ascii?Q?TIXgaek4ECqzAezqh0UhBEhufh9LlATyxYSgtSQ/6PKjEbS536u8ljNv+kFA?=
 =?us-ascii?Q?PTbgRwAYdZiRdC+Jgejzb3uF69FB47gJ3VuwLzjsyl3HzbIXek+p2m35zAvs?=
 =?us-ascii?Q?8jJYEEKeTHiDt7xrdVgYYeStLFDO8vCWKhMBc9UT7fJ+sMxJnJe5qE+T8VFH?=
 =?us-ascii?Q?OTEnkdzDxG/nzPPuqCexkNu1ojyTaGcP3goDhwTvmry8G4/o3LGfRjPtFxyh?=
 =?us-ascii?Q?VoKKto/znUNhYDC5t34Cu8HOxqs3thUsMC19s5ti9M9vctjyMDQuoR8YRBfv?=
 =?us-ascii?Q?1HIqdaSNXiqgIh7Iw5T30nKVqFz5GV9z7Omzx4ZnrXXMILgQbMDo6X1I9lEX?=
 =?us-ascii?Q?jkQ/vVYZJ2D9MByzZemHGqphXtZjN9paRrGi2Ue4o7v/HU8yuifq4SmmjbnQ?=
 =?us-ascii?Q?qq5MirI07iNRnItZgZ1tTaWqXB4Q74E+HcHR9aJKJLgAybuI/Jgpknzf3L2P?=
 =?us-ascii?Q?Dpa0qa/PMZzqNgFCboMO73c8qqzasn4sx8p7uTKxjfz/nJd3xI8ngfXImUYh?=
 =?us-ascii?Q?7FizNvYsb8gs0aeE+rOMewrjOVZunP6G0Zdh+GOWdcYHTPWvccI4lqIaWQuK?=
 =?us-ascii?Q?Az+snhYhE/iz7oSjEImrmP/yR1W46ZRuMXCEYpGH4IbnawyvfIH2M5WwQnek?=
 =?us-ascii?Q?0g4rlJEHJiXbUO7taLM6K1KqRk/MNF/WtO82NwuVFq5oNFdnw7ColTfP/jq0?=
 =?us-ascii?Q?KZ7RFQopRiKSMbepgVToOqA2Vi1s6FxrSmwPBWTZNAAY3ual1zOEZtYEz0nL?=
 =?us-ascii?Q?UW5yZZIX/yfRXQ55kPU22P1Y30qbp9jGzx23JdEwKiyTWX4YuKdRrozsymmt?=
 =?us-ascii?Q?bIcuPKT732BygLZBaTfCkGNlre6wlCoJ/NBp6XOrSEkyl8LUHIhv246eVqNX?=
 =?us-ascii?Q?dq278ZQbudM8sTzJ+WhaN+wrZq1GpU3/MbcEiV0D4vCSC0yarTUpC4D7rmHR?=
 =?us-ascii?Q?s/oFcWEVD86LYyQ1jCK2hXMOvzWbIPQ54G/tDRhe2Nz1LQbHJujjrT9YGIAr?=
 =?us-ascii?Q?gMJwfLB0KIUQ2ZRET1BTJIinLVRGPp/vQI3XZCwzyG9dq5QH3rny4lzX17xe?=
 =?us-ascii?Q?NRA5x/j5d0oryyJbciltEQSIXS2NSWZeB79xAlrQJ434cI+24XZWjEZFB522?=
 =?us-ascii?Q?jD/blqCGYqHbR96qKKhj/vrjj7XnhyHYLbqTxMm0HQwGDBkKx0KaQ7vZ0ZcQ?=
 =?us-ascii?Q?LwenOpxRJ7mXq2hK5neSt6hxV2kgtg9wD2xi7olEav2BsskJ2K2NMXAZ6WFG?=
 =?us-ascii?Q?qFavl/ja5EmoxJWa7UM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31182a29-8e78-4d0e-5bac-08dacc89994d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2022 13:00:58.0291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cMD774aVm1/FhcSH/qV6tkIlwdFGzqOEaqSGxCz6lOVD3Xzjj4D/unpCg//9Ja0vLlLa4shrSqzc8GrqzmenuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5412
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > > > > And yes, the current code appears to suffer the same defect.
> >
> > That defect isn't going to be fixed simply by changing how KVM
> > forwards NMIs though.  IIUC, _everything_ between VM-Exit and the
> > invocation of the NMI handler needs to be noinstr.  On VM-Exit due to
> > NMI, NMIs are blocked.  If a #BP/#DB/#PF occurs before KVM gets to
> > kvm_x86_handle_exit_irqoff(), the subsequent IRET will unblock NMIs
> > before the original NMI is serviced, i.e. a second NMI could come in
> > at anytime regardless of how KVM forwards the NMI to the kernel.
> >
> > Is there any way to solve this without tagging everything noinstr?
> > There is a metric shit ton of code between VM-Exit and the handling of
> > NMIs, and much of that code is common helpers.  It might be possible
> > to hoist NMI handler much earlier, though we'd need to do a super
> > thorough audit to ensure all necessary host state is restored.
>=20
> As NMI is the only vector with this potential issue, it sounds a good ide=
a to only
> promote its handling.
>=20

Hi Peter/Sean,

I prefer to move _everything_ between VM-Exit and the invocation of the NMI
handler into the noinstr section in the next patch set, how do you think?

Xin

>=20
> > > > > With FRED, ERETS/ERETU replace IRET, and use bit 28 of the
> > > > > popped CS field to control whether to unblock NMI. If bit 28 of
> > > > > the field (above the selector) is 1, ERETS/ERETU unblocks NMIs.
> >
> > Side topic, there's a bug in the ISE docs.  Section "9.4.2 NMI
> > Blocking" states that bit 16 holds the "unblock NMI" magic, which I'm
> > guessing is a holdover from an earlier revision of FRED.
>=20
> Good catch, the latest 3.0 draft spec changed it to bit 28, but section 9=
.4.2
> didn't get a proper update.
>=20
> >
> >   As specified in Section 6.1.3 and Section 6.2.3, ERETS and ERETU
> > each unblocks NMIs
> >   if bit 16 of the popped CS field is 1. The following items detail
> > how this behavior may be
> >   changed in VMX non-root operation, depending on the settings of
> > certain VM- execution
> >   controls:
> >
> > > > Yes, I know that. It is one of the many improvements FRED brings.
> > > > Ideally the IBT WAIT-FOR-ENDBR state also gets squirreled away in
> > > > the hardware exception frame, but that's still up in the air I
> > > > believe :/
> > > >
> > > > Anyway.. given there is interrupt priority and NMI is pretty much
> > > > on top of everything else the reinject crap *should* run NMI first.
> > > > That way NMI runs with the latch disabled and whatever other
> > > > pending
> > interrupts will run later.
> > > >
> > > > But that all is still broken because afaict the current code also
> > > > leaves noinstr -- and once you leave noinstr (or use a static_key,
> > > > static_call or anything else that
> > > > *can* change at runtime) you can't guarantee nothing.
> > >
> > > For NMI, HPA asked me to use "int $2", as it switches to the NMI IST
> > > stack to execute the NMI handler, essentially like how HW deals with
> > > a NMI in host. and I tested it with NMI watchdog, it looks working fi=
ne.
> >
> > Heh, well yeah, because that's how KVM used to handle NMIs back before
> > I reworked NMI handling to use the direct call method.  Ironically,
> > that original change was done in part to try and make it _easier_ to
> > deal with FRED (back before FRED was publicly disclosed).
> >
> > If KVM reverts to INTn, the fix to route KVM=3D>NMI through the non-IST
> > entry can be reverted too.
> >
> >   a217a6593cec ("KVM/VMX: Invoke NMI non-IST entry instead of IST entry=
")
> >   1a5488ef0dcf ("KVM: VMX: Invoke NMI handler via indirect call
> > instead of
> > INTn")
>=20
> Sure, I'm just thinking to put asm("int $2") in a new function exc_raise_=
nmi()
> defined in arch/x86/kernel/traps.c. Thus we will need to change it only
> whenever we have any better facility, and no KVM VMX change required.
