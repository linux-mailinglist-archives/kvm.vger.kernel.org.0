Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695E730D1D5
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 03:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbhBCCzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 21:55:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:52800 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232062AbhBCCza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 21:55:30 -0500
IronPort-SDR: UPt5uVBWV/pM69YbuLobIOodNtpBTAC3BtFgv+7FJMu30qiusdtX8cWow4ak/5qasIfUSCljT3
 iiNKblZnYmag==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="181121601"
X-IronPort-AV: E=Sophos;i="5.79,397,1602572400"; 
   d="scan'208";a="181121601"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 18:54:49 -0800
IronPort-SDR: OPQWrdyR0bmmX4DwTn33B8eJHM/cIGQGqhiEf9QjxmuNL7xj/JguY0/v0pkZb9uBeeGWK8Cn2l
 JisPELxGuTdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,397,1602572400"; 
   d="scan'208";a="356541679"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 02 Feb 2021 18:54:49 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 2 Feb 2021 18:54:49 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 2 Feb 2021 18:54:49 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 2 Feb 2021 18:54:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQ0WVBM6OchpMYOrkR57/IaBq/LAviuoxQe3rQv7YLfVch8KsthENjYR/L9PROfcCXJTQl9fh4deIxEye5eT6u7qmBP7qTiWJczbEsXATM8gUwZWg1MOQdYRjo0Nb6Nu3vNUXUPbU5t4eA/5ypKPQn31nZleR4bX7jPO7sCSQyHSsXBEdtf1UZ1IpHrOkC5tSjRw6ygDOHKra+ILccixKwILsiooR9x8SkPGJMGNut1ec9FR7yF6SMXzqUPeYk9rZdU1zS47TH0HoKb2iJntqgOJouqo88eVWntbmNtdmu6AoH6s+5l1lAMUMqd4y/hr3303mYYKsAJTaRZ8Gq/r1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztNqMEiks62XPbI4Am20plt0/x7TGsBEGpdvqNa7jY8=;
 b=iNMG/9fYnYDQRFotCaLy78vNvjAiS3eDkhFjm7Gh1vIC58fbVca420alzXGv2GceGIlDzG2fPEHw55aWithD+2yP3b/LsLneebN0PIN6MQPkn60EEsrSya8ZkSgzy4wMphOQTsYtITvSIUjlnWVRAcfy4QHWn61JntPRnHpXcWeZUaH2kjL686jS7zMKegz6lTBf/LJQ4qE6gYBB0FREwCJZ9rq8mgIy5hpS/7kl7zQGvwtbvO4pZYu7seITePi3vvOguhHunM/uem07GjpaEaQLtg/qNvDrlqm7HhRAYPCCKCX3JSoEZVZNdIzPdw32D0/CCH4IROyXgnZpTML3gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztNqMEiks62XPbI4Am20plt0/x7TGsBEGpdvqNa7jY8=;
 b=w6tOKvZz9c4JEhRFcboc9JRiH8hchAH6B5jvjKvBY1EUF05JlMonNY9DHiRDogNJTaGnRJZgtxgJz52EgQ0/FIdWnArNYnqfw86yJdisMHAeTs9IwddJiL+MEH9zaFZ1J23HhYpXrRokGdy5pKYGC2WpsTwpXJxAlmC6Up/SCvw=
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB5207.namprd11.prod.outlook.com (2603:10b6:510:32::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 3 Feb
 2021 02:54:04 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::78e6:b455:ce90:fcb0]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::78e6:b455:ce90:fcb0%6]) with mapi id 15.20.3805.027; Wed, 3 Feb 2021
 02:54:04 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     Borislav Petkov <bp@suse.de>
CC:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 06/21] x86/fpu/xstate: Calculate and remember dynamic
 xstate buffer sizes
Thread-Topic: [PATCH v3 06/21] x86/fpu/xstate: Calculate and remember dynamic
 xstate buffer sizes
Thread-Index: AQHW2UTqFFigv51YEEOlWJDvbevvbqoztVkAgAcuLYCAAIovAIAKj2mA
Date:   Wed, 3 Feb 2021 02:54:03 +0000
Message-ID: <215C3E0E-EFBC-4842-92C8-C715F6A1B3B0@intel.com>
References: <20201223155717.19556-1-chang.seok.bae@intel.com>
 <20201223155717.19556-7-chang.seok.bae@intel.com>
 <20210122114430.GB5123@zn.tnic>
 <6811FA0A-21A6-4519-82B8-C128C30127E0@intel.com>
 <20210127093810.GA8115@zn.tnic>
In-Reply-To: <20210127093810.GA8115@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.189.248.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61967fa1-acdc-470b-557a-08d8c7eef785
x-ms-traffictypediagnostic: PH0PR11MB5207:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB520752F3B89DE46B5CC5D9CDD8B49@PH0PR11MB5207.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ugf6WFj1LDUx8ourvajnNIsn02MyOEbPgBa9ilmZwn2ohG4yVKMIpX4yX45VtzIosObvRpGsS3CeHUqm8NiJ6VTmyx6k9jm4Gi6sYk8+OP39OPjpUivWSYAWzVOd2mZpMwYyQdADVo+NdzErO8b4BlkyaM0SIvhU0sQYZOmVJqUDBiTG+pvL7cRAwgcCZFrqmlGGxNxFuLURPD7Axn87wKtNUfWO2ATBLNjryGNflnj2Q3P1C87fxSgo6EUFRtzLMkuo9NXXWGqryHHzphELb8sMqNTbGvYzGGD8OPAEMEhj70iBI3CH6rxoLkn/Jz86dJtzAOdEQ5wz0kFbWty03sWLzrD+6tJeqTSl1zmPr3CBPWrPP+QUVnEOUiORzZapXcsI/WZf7BqMCT4PUamoHuQmIjc5HRAjeToCFIMn/1uUlxC6Gq/YiIUlSDxG9BzJoY5CuVCw9tWG+ppgpqrxadS4TVoDVzh7wIgIIUnQknwc9P+LfWkgeVT7tN4KICwWHexQijEsyADg5+l7m65IX7f/KTvuStcsgwYuduxegr3kzC78r9Zc3DS18RPCGTozcMBDYhnMRGSLCWSMVOAzGJ6HbmFTNAIpbKDlikQgfqdKKpWuZRGbqdpdg6PxfWUJQUYjp/ZVUM57zS9gatzvi4p69yXIwQErT1SE+m2xzlU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(366004)(39860400002)(376002)(5660300002)(86362001)(76116006)(91956017)(478600001)(2616005)(66946007)(71200400001)(36756003)(316002)(966005)(66556008)(4326008)(54906003)(6916009)(64756008)(66476007)(8936002)(6512007)(66446008)(26005)(53546011)(6506007)(33656002)(6486002)(83380400001)(186003)(2906002)(8676002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?XKoxUNCPNXSUk8681cXbVwh6OaZ6CML7DFau4hsbyoYJPhdQb+EFOqGBb2Ga?=
 =?us-ascii?Q?uHY38xOh1fvRpPcfKwZn8KifC5JQ0mtrPy4NAoSXLtiB/ifKI8Wemjxc4Kfc?=
 =?us-ascii?Q?oT1EDLn57f9aP/pDD+AQdplNGBHblAoaKU14J/rKelzmlLpigTGNJr2/Xy8W?=
 =?us-ascii?Q?3c3AWOSwL/balp3oinQeY6dJFgWi9LbaIeHkyo2vpdhypISrDI8Vkn3Vmhjn?=
 =?us-ascii?Q?lhGVOqYO4dmFXIvZTlSYos5A/G3vE8C5PQduDB3VjPRYeAJ8fs8W3CLyeFW1?=
 =?us-ascii?Q?OL1a/6UUjkys0yCLXNoUZP1H6hCGKgrrKh26P0Nvr1gRA6TgvmP+t5roldC8?=
 =?us-ascii?Q?bFd/MCDeU+kxzDiX0g0YySjXNxehY2TUElulXhc2hbs81Nf58yVz+0zGFmmJ?=
 =?us-ascii?Q?mjslqZVKwbxMSwe17aTZEGrLQ9TujG+Iz6ZIU/qXzG0pETc/wqqO18t1aEGZ?=
 =?us-ascii?Q?nT8txX57oDhpMw7S1D/cy/NMEmjVO8LSKdFWtM/7Pqsgycp1dXqip1G1CVsw?=
 =?us-ascii?Q?p2fgsSLB9FFdIh2z6EFY2DPKQFZ4WAT1ufJZE04PtMffJBJpC3FV5iTGeCcD?=
 =?us-ascii?Q?Wcdjo5WQ7bVBThwTTdpCngbmg2K5VD1hi6hJJkqlJoJ7cM+oE+f8eVXHOLqq?=
 =?us-ascii?Q?90zt/dKsAVo7+bwMXHZiFvt/2x2v4QzTVbFGwfehwpuXP/WexeejLh7KiiiB?=
 =?us-ascii?Q?8jhzFGAiIpNVqnpfpalMdF7jsol8gSliglb5wSIFov4m89tL6HXUcTGOPDnG?=
 =?us-ascii?Q?YzDzicBh4eqCCXohapToBq6TXRx4WZswpzbeX2sH4MoKT38Uod50YdQsbcdk?=
 =?us-ascii?Q?jISxTLszcpOl3ZvS+3IonK8luJJn9AC1FSAGIcwpse73R31qd2+YlmMoxik3?=
 =?us-ascii?Q?FLQ4Xul8wVN2p2QocSdL54jeteLDcc2DABuPB/1OkiJ1zJiFELsiPw0YSAgS?=
 =?us-ascii?Q?Lvf6oDakEiWSDiZeSCrbibzkjUuOvRbFESb6TbAq3CKIA6KD5kLbARnYReDM?=
 =?us-ascii?Q?Wgm7tSfuurfJWf8dsrmIV4Eo5hFD+JP45a3JLGiHveee4Ut8MWHqdNb5QFJX?=
 =?us-ascii?Q?/3QZ4Qhrj0LZrP05FQUz7ffSuNHrhA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <298C14591624A54B8360DBC777254795@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61967fa1-acdc-470b-557a-08d8c7eef785
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 02:54:03.9798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A/Sh8D/2ornA8SkGDKe1tD1PU3pdSUBK/K0Z9/KxO0P+OpsCPN0GJmfqzyfvUHK7/pgFzXAmPb6ayXjXAWxfnmUfPMtg+Ib7K1Eh530+xIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5207
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Jan 27, 2021, at 01:38, Borislav Petkov <bp@suse.de> wrote:
> On Wed, Jan 27, 2021 at 01:23:35AM +0000, Bae, Chang Seok wrote:
>> Okay. I will prepare a separate cleanup patch that can be applied at the=
 end
>> of the series. Will post the change in this thread at first.
>=20
> No, this is not how this works. Imagine you pile up a patch at the end
> for each review feedback you've gotten. No, this will be an insane churn
> and an unreviewable mess.
>=20
> What you do is you rework your patches like everyone else.

Yeah, it makes sense. I will post v4.

> Also, thinking about this more, I'm wondering if all those
> xstate-related attributes shouldn't be part of struct fpu instead of
> being scattered around like that.
>=20
> That thing - struct fpu * - gets passed in everywhere anyway so all that
> min_size, max_size, ->xstate_ptr and whatever, looks like it wants to be
> part of struct fpu. Then maybe you won't need the accessors...

Well, min_size and max_size are not task-specific. So, it will be wasteful =
to
include in struct fpu.

I will follow your suggestion to add new helpers to access the size values,
instead of exporting them.

>>>> @@ -627,13 +627,18 @@ static void check_xstate_against_struct(int nr)
>>>> */
>>>=20
>>> <-- There's a comment over this function that might need adjustment.
>>=20
>> Do you mean an empty line? (Just want to clarify.)
>=20
> No, I mean this comment:
>=20
> * Dynamic XSAVE features allocate their own buffers and are not
> * covered by these checks. Only the size of the buffer for task->fpu
> * is checked here.
>=20
> That probably needs adjusting as you do set min and max size here now
> for the dynamic buffer.

Oh, I see. Thank you.

>> Agreed. I will prepare a patch. At least will post the diff here.
>=20
> You can send it separately from this patchset, ontop of current
> tip/master, so that I can take it now.

Posted, [1]. After all, the proposal is to remove the helper.

Thanks,
Chang

[1] https://lore.kernel.org/lkml/20210203024052.15789-1-chang.seok.bae@inte=
l.com/=
