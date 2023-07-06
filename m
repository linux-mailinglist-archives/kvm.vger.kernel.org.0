Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C410749652
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 09:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjGFHZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 03:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbjGFHZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 03:25:11 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395BD1BD9;
        Thu,  6 Jul 2023 00:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688628310; x=1720164310;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a2KS8s1gZbFMriwko2/qhjr1YZr2L048YbePHJtgbVo=;
  b=Vx2wc84zjxfJAKfdQVZsK3A0F/PABTygTBO9DLa03SYJHO09eHP369zt
   c0zWQRulC4He5Ls9mi6orM9+aKTkU7OyY1rGU2u0mAE9qkz8yarFrv3rD
   Id8GCsXQfzwG1k2RsXrt5H9sn4oj2VZ3sIu4IS+7otCsK38rgMJMxjTlo
   RX8O93U23PyMyuhwnL0XxOI4+2f9BUSCHsZ8DXu25OKXFAihd8/bHAdBc
   IRJIsEMDA46zPQaEpa3fciyGfXJTbYQytDETqdKewki7jPeijydALzSX3
   Kqcec9K91gThaArdSsjHTYIYxJ+a56ItoDvdRvh02MCwbzVZHUODOzuPQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="394283669"
X-IronPort-AV: E=Sophos;i="6.01,185,1684825200"; 
   d="scan'208";a="394283669"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2023 00:25:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="749032369"
X-IronPort-AV: E=Sophos;i="6.01,185,1684825200"; 
   d="scan'208";a="749032369"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 06 Jul 2023 00:25:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 6 Jul 2023 00:25:07 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 6 Jul 2023 00:25:07 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 6 Jul 2023 00:25:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mV3p6grbbgU5EZ5xkGq02KqNx06oE80yPP42JJTEBTzgZgqTWYMVvOK163XvcLeaXA2jxIyxbFPGu7kEWOuWe/5AnqziR2RBeB2D1/jZaaInngFykKGtdW2dSgbruBLOvm29qCKII6hxHpeGyW6ocVYZafOwn0RIAwQ5SbTVrfZ9Aqbs2uNWT+qzj1KHYBicWw4z3jSRrkcAoe2FQXkLFtG1mZunLRX5hyMWvfvauq3SyehqLE0OzLWt/8fYOhR1QsT+bl8AkfzjRCdRVu1/rcUuaqqSOfFZaV6C9MV1btFphVyiE9I3XRTyWrvk1fj+Q+empPs+0vjcIDUe1pPEzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XyL0qjvI6QwsQ306WQLUd+t3RBq7r+DrvkkLGPJ05jE=;
 b=TPtHngGi22Ie72Gm45c3f52vC0IPoiqku1nxgx5GjVSTWaMKMHoQUHHp1hoNPfFPeybrPOh0VQoF3LNJYTLMEustfAiCihhFco9jepaVHouo0H1CuSsAFVVTtdZoIx5itAEctbmX4o7Dtqq71BewWPq3nucAf5BrszM/TQO2+7NWjp+rKZi4VGxy3hE9t2t95IT05ZoBiJV9Y6gE5jQ+zMjIcZCuVq2ua0a4RbZ23vYP8ZxBWgZM8w3h+XlYvH9CKEXoSBz31sZwWNIZZxfFiiaHt+ZSOBna92Kx45HQtp2ECpLnWWOpKM/A+3ffNKhLj3FdSzuz5yaE+fPwlkfPug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by BL1PR11MB5415.namprd11.prod.outlook.com (2603:10b6:208:315::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.24; Thu, 6 Jul
 2023 07:25:04 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::c016:653d:c037:44fc]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::c016:653d:c037:44fc%7]) with mapi id 15.20.6544.024; Thu, 6 Jul 2023
 07:25:04 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: RE: [PATCH] x86/trapnr: Add event type macros to <asm/trapnr.h>
Thread-Topic: [PATCH] x86/trapnr: Add event type macros to <asm/trapnr.h>
Thread-Index: AQHZr8ysO2SxX3x+7keRZu3fDfiVha+sS0KAgAAIsxA=
Date:   Thu, 6 Jul 2023 07:25:03 +0000
Message-ID: <SA1PR11MB67344CAD2EF26F37AF06A8B2A82CA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230706051443.2054-1-xin3.li@intel.com>
 <20230706064519.GC2833176@hirez.programming.kicks-ass.net>
In-Reply-To: <20230706064519.GC2833176@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|BL1PR11MB5415:EE_
x-ms-office365-filtering-correlation-id: 5a0b8b9e-b10b-4b07-a5b8-08db7df21da8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oM2lYZuZcLU+r4YE1h0QqUYpX1mmL2AAI8LB5mNI49D7FIi0UTZpBr2PiHdCLDE+ZOtlP7p1Ql80sR0UexUrHhmP6pUd1rjO3EmZg6r/EpPlGrNZM2RT6vvT76BvfxkdATq62R3gLd+PdNWgwk+QylT64+sKeqWP3tyqpAZcT9JqE4W/rU3Fw3s5oJy2zNOUExfcUH0/1gSsnD/RDLnPnoDUNwlW/+4Em0zco1CdryfiMlDMzIoURkiyWd1JmNaCYbvZ2zBdjy+GUa5j9qkKYdTBhjutwO6an1zvjEElv4dKsNjxAX4yKg57VinrSOz+M08ODz6LolWhPP0LClUFODy+g5K3Spz0WEEFmREj22rGfBjU154uA2YNR9Th5pXi6B2HzK8uN2yfuDtKUjL79bIzDTZFY35pqQGkoPz6hN01zoYbx3CspBJrKRSyTIDEMmn5dEzNT90oO9sYF5qhdiIrj8ccHhUfbIOmmU3Cpif0srds4BJcd/8lhcmhxWgdj7HPKno213IUCP+IvfCwNCHV8DuafuPcoqYl4m4aOMi7by5dyh0z7Azfivri5+f9IjwbJQM5I6DI+9TibjppoRmGBQ1VPS0poEx7HQIy7MEn21/C0JH0BmGhMJNL8mb7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199021)(82960400001)(122000001)(33656002)(86362001)(38070700005)(55016003)(38100700002)(54906003)(71200400001)(7696005)(41300700001)(8676002)(5660300002)(8936002)(478600001)(52536014)(7416002)(316002)(6916009)(4326008)(2906002)(64756008)(66446008)(76116006)(66946007)(66556008)(66476007)(4744005)(186003)(9686003)(6506007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yhkbXyrd131gNz4S1uL3I7d2t5fd8bgUpufX2fFzDs4TmHasHbVPj0yu0Qw1?=
 =?us-ascii?Q?p++8cRXG4ww8a1Nv5sP+3VrNl/NUbU3Vk0YDf9rVhtmeOhByCdXCluB/Zb06?=
 =?us-ascii?Q?o3qtPH6c0Fb/t1fEBgQYxCwzHHiEbKU9Eor3alWg4IWMHBuH1Ng8KVyyMiV6?=
 =?us-ascii?Q?Mcz/cIW1Ol76bsqw3I3YmU43IL3m16BDnPz/+27kg32G4PTepYOIaNqxODOz?=
 =?us-ascii?Q?VrT962glssYpKj3eLBN5Y83izDAj0aZ2ltHcTz8ewODoy8ODqXawUJDcTOEW?=
 =?us-ascii?Q?e7/qtCKDMopCocovpeQrqFduMgrc7rCdIB156iLRppbxmWP7HnaT3sDUhiz4?=
 =?us-ascii?Q?2wggrikYS0LbFeUKUG6c6y0O1FYhkTjZoafuFUxjlHo4RCrXEWkVTzB7QOeY?=
 =?us-ascii?Q?rejJyMgRMd82yTRlKSYrT49YbXt+N4rtFE/AQIoHc8dE+m/BU6Xs4bni5yKE?=
 =?us-ascii?Q?VQKa5E/JBia16yqrg4yj2QNdxJdDaLkJEuFs2t2tL2tjxkQCgvMdko9i7sxE?=
 =?us-ascii?Q?BaNFDlCat3oZhHZbZSlMSnYgeuk4FVKfKgX2oC7wU3zsGLTc/DEyb3lnv3NZ?=
 =?us-ascii?Q?tAi9qAPrtBj+gDxAugK60bmeobr2kcHwpHUKcYz8JthBtDRFkR6AuRJpTFSv?=
 =?us-ascii?Q?1aHCoFoqOO83cj1+lj5/SnfuJX/397V6HjWn6BCMkLWA0WsuW8dqXZFYUkGC?=
 =?us-ascii?Q?b+jF5d4ZLdXMA+xjeeKij8WgG5g5my4mMWYmwb30nt7SOey8fKSPGuMm0E2v?=
 =?us-ascii?Q?TPGedm3z8mfXwO4kiKIkp8MlkNk9O11m63+1fuFYq3vhC8WCU0/D5L3elacI?=
 =?us-ascii?Q?sHBcLHZKSFhvX4i/jtcD3SPFSPDlKeJx0NZN15bnIw6OMB9+5C4Q3YovFNTP?=
 =?us-ascii?Q?9uspbuLoJyhfhwMtDHeHG4YOl06yYFrlp+hrtrfgq37nBKrzX3atxoVaS8f8?=
 =?us-ascii?Q?KeNjG+BTfdshDhLlnwaUKf7iS0mSCqSiYnADKFO/6lC6TEu94CHdxerUwOAg?=
 =?us-ascii?Q?RfgzIV8N56zBsXX9IyZpcnPAzL9mwt2qTYrt2X3ah/u+8oiNfKYl9j4Wjsnu?=
 =?us-ascii?Q?mKJ7CcB/ZyD746RkqL3HkRxZrWsWQa39+mswj2/A0AeYefokHCzxUoRTgs7J?=
 =?us-ascii?Q?DDXQ/ZBh4O3moohxtjOgP5+eBn+DblqVXo5buv+ESDwSwoerZO96oN1sAWyA?=
 =?us-ascii?Q?gfCPxZeUkht4RUI/IL6WMcucs6nfjTUkh5hfG+svWLmzJ+tcln8QnnNyU+h6?=
 =?us-ascii?Q?Mk9zv+jxV1xwPiRXg7vhiMHYllXuIemD05o8pW0TEVC/unqagAWQrM7MG3tt?=
 =?us-ascii?Q?RIuKa77WwV0c8Bx04sCH85RW3TGudL0BVv2M8kVT10J5nwc0nU6zgUisy1sz?=
 =?us-ascii?Q?TzlqMRGIJkhyu8fkmok1NDgi9QdLGPK/dgTG0YHrr9p221zgPht+MipA1TWl?=
 =?us-ascii?Q?BOIpcbfCZ9ypVJgiz7l60IFTTzxoFfkZ5tOG6+4H0XfSByaZ7QxXU17LS4NY?=
 =?us-ascii?Q?FRzvmeUrMXwqPN69qdSLnrp9Axwm63VlpZRkxQqLJz3gysKykwhhEWITeBVh?=
 =?us-ascii?Q?Wge8JqFW9UvcqWektlE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a0b8b9e-b10b-4b07-a5b8-08db7df21da8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2023 07:25:03.5977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rs/2n/kPB/CNGhRyLcxIy1BfaB5xR1GfSwZ9E3erum54rq8RSuxv3rkw7OISGCd1X7Voajhw+eReMde8kTGOPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5415
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +/*
> > + * Event type codes used by both Intel VT-x and FRED  */
> > +/* Maskable external interrupt */
> > +#define EVENT_TYPE_HWINT	0
> > +#define EVENT_TYPE_RESERVED	1
> > +#define EVENT_TYPE_NMI		2
> > +/* Hardware exceptions (e.g., page fault) */
> > +#define EVENT_TYPE_HWFAULT	3
> > +/* Software interrupt (INT n) */
> > +#define EVENT_TYPE_SWINT	4
> > +/* INT1 (ICEBP) */
> > +#define EVENT_TYPE_PRIVSW	5
> > +/* Software exception (INT3 or INTO) */
> > +#define EVENT_TYPE_SWFAULT	6
> > +/* VT-x MTF or FRED SYSCALL/SYSENTER */
> > +#define EVENT_TYPE_OTHER	7
>=20
> So I know tglx hates on tail comments, but I find the below *MUCH* more r=
eadable
> than the above horror show.

Agree, sometimes a tail comment looks much better.

Maybe tglx could give more specific directions on when it's okay to use
tail comments.

Thanks!
  Xin
