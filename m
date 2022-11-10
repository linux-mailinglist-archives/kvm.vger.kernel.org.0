Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75CB624E28
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 00:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiKJXA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 18:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiKJXAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 18:00:55 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2498413DEE;
        Thu, 10 Nov 2022 15:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668121255; x=1699657255;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7a4VDKNcae9mrLmqIfsPzGTwizZmLDkqqjo6cztkUE8=;
  b=ai5YHMRtWtmCUMDg7qkpZIuRk+/G+S1FS7yjHPBViAcm1YXgS2ecfAh8
   cVOlfx/660Wp+9paksM6YuyejZMh19ZJGYGrlsWnUq4G/JGjDH0gjAiN+
   WGVa370bkR6g69UPeBDIIrU8hUqYO5/ijKbEKjaAA7r87tm63okSGNaBA
   66hVLbca4W4m4KXyMjZ9VvAmqZcfRwlVfnRMOlyMz+Pn9VpGlkiE274X3
   PQOgIy1BghUYkHkSwdNKq61EmYZ+50Xb1ytuPwDG2XraKz4z4sRbubcyM
   JewcvYjnApivpnAUfFQ+BviEqbnI4/l1O9X+E4beDjEBUTwNmMgAOCIzu
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="309089543"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="309089543"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 15:00:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="639800529"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="639800529"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 10 Nov 2022 15:00:54 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 15:00:54 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 15:00:54 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 15:00:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BdY67i93b87esjIM9dxMKOyEN97Q54HhSaqmadynOs+3Bka0ZnrBTtzILwpsnBHkp/XhWr9o2ZADPQMBKnNhhiPaSqJa79TRXIxU6Kf8ciZwRLdpQAwX+6xC22ohUoLi44iLnLAREPTfoYknlp9b5ph1eose7zcFFJk42vX9VyXPxkd2rv6k7JWC4LQbj2Y+Tdh+rkxTGG6asPU2smczqVKMadc/SgdC/SdE5wYpRj/GE8KJ9XLwyRD2zFN1uUJAOu0S659/t4Llpe4ZyDV8Ruo7o/HlrE2pHA+qaHgfB0DkgGZSCEAZPJL2HoNogU3sPAH0VLno+atxe+7eWQ4TCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jviMiJ9dY1qq3rukUMho9PU1Puwl585IppVmoAlwzJg=;
 b=ZSLfzPJooaBQmDuM9rsceg7j5RpYMb+r76RqMvBTvLP850qQo5oz7r+P/RyV8vsOjCAUUm5pS2CpV4qGTZJLLVvplwewX5tLxSDsroh9rzXMAwWSFoMFKL1HQBNOztGKU2mh+H1PqbFYctB9qiIJH98QHlgd7wtghknCfh9GX/JRcaCosMYaIVK769jw8uyV5VVhpWBtl54WcYl/8JIE0KkE3ExMLbAKbwGvHGaGBOhU3UKi01NT+uZyUlVOVmEMOLTmkRD01lHL2u9gN9r3IQGrgVQmHZEbN2qH5yJVhpCIRESeSbuxowkGKXKVqwDSmO7FFEP+BH/uyky/+7hmZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by BL1PR11MB5416.namprd11.prod.outlook.com
 (2603:10b6:208:319::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 23:00:51 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c%11]) with mapi id 15.20.5813.013; Thu, 10 Nov
 2022 23:00:51 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Nathan Chancellor <nathan@kernel.org>
CC:     Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: RE: [RESEND PATCH 2/6] x86/traps: add a system interrupt table for
 system interrupt dispatch
Thread-Topic: [RESEND PATCH 2/6] x86/traps: add a system interrupt table for
 system interrupt dispatch
Thread-Index: AQHY9M85Yu9uY6afW02HaiePlaJ2sq432uWAgAC2DaCAAAq8AIAADReAgAAaLxA=
Date:   Thu, 10 Nov 2022 23:00:51 +0000
Message-ID: <BN6PR1101MB216109C51162ABB27C8AA735A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-3-xin3.li@intel.com>
 <Y2y8obdYDXo9vlH/@hirez.programming.kicks-ass.net>
 <BN6PR1101MB21619E2092AFF048422C6311A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <BN6PR1101MB2161DDABE8095ADC95B8BC73A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y21pVXipq4lRiDMf@dev-arch.thelio-3990X>
In-Reply-To: <Y21pVXipq4lRiDMf@dev-arch.thelio-3990X>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|BL1PR11MB5416:EE_
x-ms-office365-filtering-correlation-id: 66e60cb8-e5ca-483f-8aab-08dac36f6a30
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Po+C1j3y4JGTcFX9JxMQKoxUIxMKarQCnzI5gsB20csuUf+n7AfUiU33JL8seWtYQs4d5Us6M9Pv18hswT1qzbxn+rAJD5eKKVnMz2INXVZqqa/Q5VSwbJHzsjRhmQmpgGEiwXh3vMx3FKJ4ir9tBcgMcOYza3Oy7C1Dkidh7S5CT9Qt2PA/ebi13I+TpJBL4MJd/NnbYZAHmN6LL5PKSmuXQdj8G4qHGdpF568fYvRQtcKDT4r6mJ7RWD48XVbvHm/zmX8bmcYlhsaxJJuPmUFkyHFCxFBd31syEEejCX9wNKH4IG2Ci/1R3sk9IDK8xyoDr7Ev/fwqNMmIDwStPRfegJeE0pf2loHyHG0uZoo+rGolowjxKOHRAvQefvyMFjzMwHUvB14P+7qig2W8nfxFnOhIpFgR2pk2EXURVMF4KOSyiDWb+Ll4QbP4RUy4XAipemLwp39VbP2KfAKaOuBYD1ALP5Tv872BrlT2dzcQElCCI4hCubGj2YGVPkFTfG8FLpKfiCArW7GEEmRePqph5XsGpmrtLkfYxP/uSKRjaUKVMaeNif+CSnItVY9SMwlAILzppz+eb6jjUXopUHtNr55+atfZ6E0Z+59HuT8vL14oBPMhe5WG25js+D44Gj4eGAhfNF2VTvOtLoutGDhLYkIr3wFwcAftJ2CD/YLx8YZ1KKiTB26CsytvBrhH70MhiGTPpsDqczl1Yvt0UB+/GZIlsG3aGnHnKhdrXchagdypuaPAHOQw6NdQsiRGXa4WfvdsRdZ94N3mfDwEmgciVI8ZKG8eLZ41Tp2eYV7RfVKxFExtb+mdlVeDMrS9b4J2J1l7s/5ssINbEMaCdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(136003)(39860400002)(366004)(451199015)(186003)(55016003)(86362001)(7416002)(4744005)(41300700001)(8936002)(4326008)(8676002)(52536014)(26005)(76116006)(66446008)(66476007)(66946007)(66556008)(64756008)(83380400001)(54906003)(6916009)(2906002)(7696005)(9686003)(316002)(5660300002)(6506007)(966005)(478600001)(38070700005)(122000001)(71200400001)(33656002)(38100700002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TTCkWuHDpkspO5/CKiALKvUNGj8zY3U5a6F6AdygxxYRRuazanJPjoHu71G2?=
 =?us-ascii?Q?hEcfsDkq8cHesLrAEty98HxN+HHjaKytSpgibmLs5BtbRo8WCwG2pPO/awTh?=
 =?us-ascii?Q?ZEqGxItoY1phnW4nvnqzVkopXJnew4/XmX6Hg0OSgJvmr5oN3sMxCZKEcoDp?=
 =?us-ascii?Q?yoomZKZTzQQXolmD+TJ3iKx/a7hUv5fi6PP1AGdi0Of+GFulpoSNSYuy7UOb?=
 =?us-ascii?Q?nqthYzq85CP7S1kYARmLPVvvLL9yjYs3zkgkGB0qh0gbTbUSKb/TIa0U4JxX?=
 =?us-ascii?Q?6B37565aDyC39sKRp3JNw6vcB0uNcgHPHDrlIGVV051KC2wJd5J6DtlqA8Fk?=
 =?us-ascii?Q?XqLcCPYVlhIei9WHrkciCl5gndrs0ctDRJSK0+V94oWMqA4GzQLhlQyulTAG?=
 =?us-ascii?Q?4WOjtvxzr7BmSMRxvWvmQOp7KxBHd5pa8D76tgRlM3q+da6h8hFQW02n5SH8?=
 =?us-ascii?Q?kZnOn/HnjivEO4FipaDkE3ldJ8HjTaweK5bHZQ5K9Hxi/FvYS43NQAm+xezl?=
 =?us-ascii?Q?G5bffAfGm8y+VVQ+wj//de42AtD0elZw5iMeSZ96T5yWM0jE/5Vekmd2nAVx?=
 =?us-ascii?Q?8dcoIRnhAoRbihozr1gvmLHe5rE1aP1nnd2604MMF1w7wKENvxHxkWFTxC7P?=
 =?us-ascii?Q?BjvwwpzL3O1Y5r8pLdFMZsmFzGBsZmRFNrhHvo5aK1U38Yo5yh6ERRkAs0PH?=
 =?us-ascii?Q?aZNLSQtrkVMpMhxzBbK6lqeuqimn8tnYEJWopjKyB9Aqeh0XCSNcxSH7HAPh?=
 =?us-ascii?Q?HT55Xw7+rgPMLvzbpSL+7GkjHoFziY1miVpxBCrMdH0DLQqZB7iJ9Uj3BwGL?=
 =?us-ascii?Q?uwE5C7h+mgAA8kVnMFu8bt6MmFtuRBPbhZ/aPogPGuwzycyvImGa1VEp4xIR?=
 =?us-ascii?Q?8kxtPiXyULkBnp/rz2Ar+8vmQXblj7CJRI4D9wPDldV0kvmhjrJ8AitikSxa?=
 =?us-ascii?Q?qwkAJ1c5A3qY1jMMDAYhXYuT1JOS3vSfPcm2KuJ88p6j1PwQKQ2yf2VbMdMA?=
 =?us-ascii?Q?MQALyPMD5zCLK40jUVwcSClVlBLff7NEb7c2BDrWF/83cU7m8+SLwJjfITAz?=
 =?us-ascii?Q?3unhiIU59tdNz+bjVG6gFPhFRoOKF/Atif5wtbcv0QHFhBqlmTN2i+6YY9gi?=
 =?us-ascii?Q?lQXTMXeo6w4Y5ueAxYRd4tuGUa1sxX065t5F+6AWsB9Q7jeJco1Gd3krVwnQ?=
 =?us-ascii?Q?+EGaERAfa7YGxnBIeEwrbChj7roNubsF99X13ulRO98W0rjll7On0qcSeDDl?=
 =?us-ascii?Q?s1AkjzHYWniYnoq4gBkqchqszMpLw4g368ZNww1mG7rDacmhaHeg0aql/+H2?=
 =?us-ascii?Q?6bZ6pjndM0sFAPP5ljjrFLXR15Dqv5RZ/qG4l9fo2l8PPK9/xIXca6lzE6It?=
 =?us-ascii?Q?c04f6XGWI21Kwy7LiLRIgCKJMk1eGGk3MBllruidU7shUL1rKwKV3p4p9sWQ?=
 =?us-ascii?Q?4XoCF7NYYPNq27MGzvDco4CcvcU5E3zP4o/Sbm+Jmr3fAKfLwi8c3lYP4fXZ?=
 =?us-ascii?Q?5V0ZLbnecbyhzI1Bv3P9qenzp8au2mK1CzKcvqj1UGxYQDgXuAcGNJG6ZU0O?=
 =?us-ascii?Q?7dYN3db6S5rUJn//5nI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66e60cb8-e5ca-483f-8aab-08dac36f6a30
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 23:00:51.6073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R4akIrxPmWKYCEe5igJdaWBjMhZOxfP1CjgjLC0Ttl70rCwOkDwKNnut1NIDxM5YqqRqNWTpjEzIqiTSuKTyNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5416
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > > > +#pragma GCC diagnostic push
> > > > > +#pragma GCC diagnostic ignored "-Wcast-function-type"
> > > >
> > > > How does this not break CFI ?
> > >
> > > I wasn't aware of it, will check.
> >
> > CFI needs $(cc-option,-fsanitize=3Dkcfi), which, reported on LWN on Jun=
,
> > 2002, had not yet landed in the LLVM mainline (I'm using GCC).  So
> > looks we are replying on people keeping an eye on it to make sure it's =
not
> broken?
>=20
> Well, the entire point of the warning that you are disabling here is to c=
atch
> potential CFI failures at compile time, rather than run time :)

Oh, of course I didn't intend to be opposed to CFI.

>=20
> Clang also has -Wcast-function-type-strict, which Gustavo and Kees are wo=
rking
> on getting enabled, so that even more CFI failures can be caught at compi=
le
> time.
>=20
> https://github.com/ClangBuiltLinux/linux/issues/1724
> https://lore.kernel.org/all/?q=3D-Wcast-function-type-strict
>=20
> Cheers,
> Nathan
