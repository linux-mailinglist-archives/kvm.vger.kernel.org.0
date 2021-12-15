Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49283475241
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 06:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239896AbhLOFq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 00:46:58 -0500
Received: from mga04.intel.com ([192.55.52.120]:40849 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235611AbhLOFq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 00:46:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639547217; x=1671083217;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ePnOg3GkuHNq/j/yuHdp11ACAm6ZteWPKGTMXvlqMYY=;
  b=AUpR/p3XFo3ckoBRJBuK4gsRMekDUd9Eg8m7WOPPOm/39UgtjzBVUJA+
   tk9vU09n110gaZpBX3RDooy0u/E7ROmFu9EG/E6hQIW0sP6cUXI8/UBTz
   BAXpB6IirIP/WqAhXGzZRxm30ATArEq1Uc1XXmrzo7T6Lji5fgHRAjXm7
   XkhnT7UEs48ujOFh2n4oqHhahC8+mTILIznkOX938zwa2fdPssPc07s52
   Uq4SQ3vkZCQqk2xV91IQe0S3QlTp6RSvhjgZGo+unvtHAXA3NQZCNinw+
   tVpFwLjeVtnrqBx3s+ZT1Vizi21+1JhvQ1FTv6kGWGWWPoBW/OVOgEMzS
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10198"; a="237890931"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="237890931"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 21:46:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="464133504"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga003.jf.intel.com with ESMTP; 14 Dec 2021 21:46:57 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 21:46:56 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 21:46:56 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 14 Dec 2021 21:46:56 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 14 Dec 2021 21:46:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CgeLORX7Chz8vrcyS50wVTkDwoP/lreN+zkZ+6p5AKDWZAV+JfJlJnPUlRfW4WOTPXNtGqi9/272gJsCkyx5J19HR/yj3V8BZP9VHudRDjJufbAfRYNZnr1FA6rzdeT7fne4X+fnbXuInK+JhHM7gPM9yc30ciEr+gzncXKgsi/Ent9JS4zbrHeyLICWCLUnwU5Q/00XWMBRwtUB9ZF6bfjBdWoHqswfJ3SAAR3RXcVQl+UdAUDCh3nJLMwYzmtRfzxwSFViYLfwDmI/u7rH5WqfW7CPKabgO4kMNoIrtmWjGy4TY6hJSpJwbPxc0goibNJVQ9FIxN4ycmWK0rYpBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sqN9oiV1U/7nlMTEgB8i7ELvUE+hYHla6pCVOY4aDGk=;
 b=Arjn1fGCDBdN67ZstTadRfXY0MIZemxrE8yLNrOo7sgU8Wf2vQDn2mpthrF1DHkxNGtswvPGxhpwcu21bvyL4RT8/UM+XLZfrk1kbLuFVWJskPluntcZBxiK6uhCXSdA6dJHZ0VugqoLxuTw4SAdURQ1yjBMIrtolESLTrC33tHzONdDtvFZ2inURJA+tn+S0z2WzlrlnhIFiVyyApWsk6Cj2PDSbE4tHWD9fM7DECeCmCEAOHIGo8aR9AOd+HVj712Mzr8KC4Cl/ArK2Lmrunbo7Ow14EpfL8Kqk6stJqFL9KU+lJM1VPF2DzWl9K+LIK12QPINSBiX05Cp23WHxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sqN9oiV1U/7nlMTEgB8i7ELvUE+hYHla6pCVOY4aDGk=;
 b=lyMx9W8X0r3gH4ihsZ7YBh2O907tlSUOTTRCe5ixt1Cya6AjiRkXAL3UH3jGVKPNWdPG6I+pOy84lSbdPAyKyGk8lV7NnvoKvIu+OYC1VBTuLTcRRMkVB+X2M5+pjIu6CFO25lBpTKjezvOLqHIus5KuxubA5A76S7q5AT9R294=
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB3857.namprd11.prod.outlook.com (2603:10b6:405:79::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Wed, 15 Dec
 2021 05:46:53 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%3]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 05:46:53 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
CC:     Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: RE: [patch 4/6] x86/fpu: Add guest support to xfd_enable_feature()
Thread-Topic: [patch 4/6] x86/fpu: Add guest support to xfd_enable_feature()
Thread-Index: AQHX8JVfa24MaOKR6ES6APNYc0mH4qwxeZawgABOEICAADCUgIABC9hQ
Date:   Wed, 15 Dec 2021 05:46:53 +0000
Message-ID: <BN9PR11MB52760A4BC211148D875D3F358C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024947.991506193@linutronix.de>
 <BN9PR11MB5276D76F3F0729865FCE02938C759@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f49f9358-a903-3ee1-46f8-1662911390ef@redhat.com> <87a6h3tji8.ffs@tglx>
In-Reply-To: <87a6h3tji8.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c59f6164-70eb-4eb9-2771-08d9bf8e4c15
x-ms-traffictypediagnostic: BN6PR11MB3857:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB3857CB139D316EF5105081508C769@BN6PR11MB3857.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6W1J+vB60xyvTd86DtHUbhZTr20N6+LwvU8bun3GQ9nZoM54pJB1Fnxe/d1UtzRV499DZL9pJEyl+uZg/B6TEfVVV1ayEyb4rW0ceeTeVnTGl0GnBTul6T5KHWs1r6MxJhbIh3dVtpThvi+FJIkj3OHjYJOjkI9mB8stvhG8BLzVh8g0rQ0lwih3n+9Vloe2LhKkYrwwtAk06PN7YfEH5ETCkfk336uv9FRhWJuNlzwUnLwovrY2GYFEdcxzIF9mQCNj41fUb8dfC5bC7FHHs9ad9T/zqkcO5AJXv6Tw6bJsP/y8JdsqpCoHzhZn9lkf6DXA0rYi1H+xXFmNj+WqkKBkUCGajoduTA4IKBSbcrD2IZtE/9c2rmH1W/3yqwziTlXZ9GgOgxbdorffk/FpnSRpurr2+POfdUI19GuzUx+bdkSl1RCF8kjVOdJDtudjPgc91pP8Y36kjP8AcOjKTljB2nDhIjL38D4gkgKALG03iPNN6p8T6Z8QqJyFnKXfqCq/3SJFCW3WjmWMbDopNexJhG/EZRDQI+z+iWP+1D7ctMYx45G0cXNa5z+OGZIIYMlIf/YHVOIM8UUPQFh9Zjr/aZukaOICFhMF3Cg93340zkli60susyhNMWTxIpTpsxQZMsrrFxKwaqln4QzGP1uw6CB5v2gNfT5LWgwt0QkSM1oNnTvZLmoAXGSF/cb9o7tWrPAqGWgyS7rGORHlFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38070700005)(76116006)(26005)(7696005)(55016003)(71200400001)(6506007)(186003)(9686003)(110136005)(316002)(83380400001)(86362001)(38100700002)(5660300002)(54906003)(66476007)(508600001)(66446008)(122000001)(2906002)(53546011)(52536014)(8936002)(66946007)(82960400001)(8676002)(66556008)(64756008)(33656002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BL4RUaOfzCe28canBGverMaKkOW0i50gvoW6UXPAZj3E+yGmc+7NvjTQ0VgR?=
 =?us-ascii?Q?1t9qkWgs7vVceVa7kT1jRjItFOoCW6/0Tr8gZh46LRIhe2tbKYY9/Db77HqL?=
 =?us-ascii?Q?92N7ha/Qu1DQiZ1a4L3uw/11I15VoDAVjNoHHDR4Or7moCe3OKSBHhevfgZI?=
 =?us-ascii?Q?qRLRmvfb1rdP2Yafe+Ou3hYodA3GwiTSrwQ2i3eHbcJT96/FoiJ3P2hy7MpR?=
 =?us-ascii?Q?5TzL3dWgVqx87dIyblfmI+6pYRuYU8TACp/nHfaGJU878NbSzZ4Bg5Zcu5Rf?=
 =?us-ascii?Q?PoezzD458FlwllqFhYG0J3wNBLcQnlCq34C2qBK36RIwxKGqdgmI/9S0SeYV?=
 =?us-ascii?Q?qLtdIeWbHbfrOulVeR21SLAVHAq1/e+Z3+foQkwuucGs6RsXBZCLWiqAomkY?=
 =?us-ascii?Q?qU0d4+DVyz9mgGlq2QSwzojbuNkTSahDHoZhCIPi3w66kk6pjk9HPGfwj+RB?=
 =?us-ascii?Q?YHlp76jMHboh1lIWQU/x5ke/3aEeABDLQ//CVQ956ShS2QyEpdQF5P5r9EEQ?=
 =?us-ascii?Q?7px/XvSMGD9mwG66jIhHxaRnlZHXaVqT3oUi6GvCnLKfGiKL4EynGwJh88mJ?=
 =?us-ascii?Q?QpVPhGuWydh1nJJ+RbkVYgwyfBzKM4eIQVLUaA5dZVNJxb4eBCDo/WlFj708?=
 =?us-ascii?Q?Nh/I7vVlZK4izyxkuLArKaqsFMrjkf1ahPpapghNxWTyZMpOOQ/ph5In8h/A?=
 =?us-ascii?Q?Dx/mYuHrD2GuN6w+o+VNSjCT+naae9wbts6c0LdGva6n+wITczjXDh4fvsBc?=
 =?us-ascii?Q?vlP3ANU/Df39sOl/YA3EIHiQCsiKjk5qh3hxeb7aNLPw9ac3qr5hBX8XVUyZ?=
 =?us-ascii?Q?NMufVwInTEoj9qJ7zFTBm3tTQWZn51CjC4A4XNYEEFh2aZZKrZvQmbTKY7Vm?=
 =?us-ascii?Q?pkJ2FP628F7HxVYZW4i+YOwPcPlSHDp82dhiG0XVir5Fs3x+/giJBPj4PWex?=
 =?us-ascii?Q?W1s6iHyvbMuoc3NPm4ujG5yL63b5u7sNsbuzZ0uqUtz1nUHMM4uvppl5wb40?=
 =?us-ascii?Q?zs1XkX4wURnG2OXLm6g3xM3iGZ681WU4LsnWLX80KG+pMSAEqH2b76t3qCI9?=
 =?us-ascii?Q?DZSVtAZfZKAxBTBkn9ZQGAUYKHI9v2bKRUc9Z1WjSjblo1v1RHbyPnMY/DB7?=
 =?us-ascii?Q?dJJPeeUf7WfQfJBPjzUxCar1L9s4sq/3/jCIUzUKKz0R5hkisu6NzzKtNkBC?=
 =?us-ascii?Q?aTqGQxlpOyK/mhqTnUgszBnJc0GQv8xamqRxh+9cmdmLLG5rk0D44qop1wv3?=
 =?us-ascii?Q?cnYElZMXnB5tKaZ6S/HaYtlOrl38FJoz4yxN705DPHCPfOw7aZaT9cDBsSjW?=
 =?us-ascii?Q?Xn0plRTPXC6ZzUguHqZ4V95Gc9m1K5+lpInH2ogmv7QX9OaHimFCxy/kpUvv?=
 =?us-ascii?Q?nrL8YF/G/DKZH7m16K4yvemhHuvNM9J6M/Swszkn02pesseqoaDAN0mySBPq?=
 =?us-ascii?Q?2LPD/htlhgPz1jyMv7Zd2JENTmMO13TUMHTUuZ4W3WWdnHQjLzHiuHlEYo9X?=
 =?us-ascii?Q?0ngkaSpJOF5NytrrOMIIwNWvWwpngB5kDgiqTeBS/gErIfo4kP2pz4LZThOp?=
 =?us-ascii?Q?tnsx96BPZPeTGXDdAnZjsbc6dNeI1VoeV+QmSgPqAQjLLPmDAVNy1uOcURzv?=
 =?us-ascii?Q?E6RJqSTXx/AZ9eGtWse68UI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c59f6164-70eb-4eb9-2771-08d9bf8e4c15
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 05:46:53.1485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W4Ka18T2YcHpgPGEVJ6DjhcD28GUXHbCWgehACfaJ0FLdwbzD9Gelcce1U7pbYWRg58kqgfee32Z/vXWWEMduQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3857
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Thomas Gleixner <tglx@linutronix.de>
> Sent: Tuesday, December 14, 2021 9:16 PM
>=20
> On Tue, Dec 14 2021 at 11:21, Paolo Bonzini wrote:
> > On 12/14/21 07:05, Tian, Kevin wrote:
> >>> +	if (guest_fpu) {
> >>> +		newfps->is_guest =3D true;
> >>> +		newfps->is_confidential =3D curfps->is_confidential;
> >>> +		newfps->in_use =3D curfps->in_use;
> >>> +		guest_fpu->xfeatures |=3D xfeatures;
> >>> +	}
> >>> +
> >> As you explained guest fpstate is not current active in the restoring
> >> path, thus it's not correct to always inherit attributes from the
> >> active one.
>=20
> Good catch!
>=20
> > Indeed, guest_fpu->fpstate should be used instead of curfps.
>=20
> Something like the below.

Looks good. Just two nits.

> +	/*
> +	 * When a guest FPU is supplied, use @guest_fpu->fpstate
> +	 * as reference independent whether it is in use or not.
> +	 */
> +	curfps =3D guest_fpu ? guest_fpu->fpstate : fpu->fpstate;
> +
> +	/* Determine whether @curfps is the active fpstate */
> +	in_use =3D fpu->fpstate =3D=3D curfps;
> +
> +	if (guest_fpu) {
> +		newfps->is_guest =3D true;
> +		newfps->is_confidential =3D curfps->is_confidential;
> +		newfps->in_use =3D curfps->in_use;

What is the purpose of this 'in_use' field? Currently it's only
touched in three places:

  - set when entering guest;
  - cleared when exiting to userspace;
  - checked when freeing a guest FPU;

The last one can be easily checked by comparing to current fps.

Any other intended usage which is currently missed for guest FPU?

>=20
> +	if (guest_fpu) {
> +		curfps =3D xchg(&guest_fpu->fpstate, newfps);

This can be a direct value update to guest_fpu->fpstate since=20
curfps has already been acquired in the start.

> +		/* If curfps is active, update the FPU fpstate pointer */
> +		if (in_use)
> +			fpu->fpstate =3D newfps;
> +	} else {
> +		curfps =3D xchg(&fpu->fpstate, newfps);

ditto.

Thanks
Kevin
