Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1D8624B05
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 20:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiKJTz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 14:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiKJTz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 14:55:28 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EB2B9B;
        Thu, 10 Nov 2022 11:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668110127; x=1699646127;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S09aoKSMapltJQ8Gu2c1nCNLf1C9h248Yw9FiTgrlCk=;
  b=M9HPEyB8EmXwA5CbgsjZvInjPUo4D59ECPb7NJB/UO9nPMTlldp3HYwI
   sdp1UDu+nDLHmVUATj+fzBYpbiiRX1gfBVKxJJ78UeDwlZaygnfsCm4RZ
   fQAWsWcEfHiMgZ02QoK018F6LJPhVLzcfH/cUhIJxoewDtlT/Ia91kqcr
   q2db1HfnJpc1ywxBAAG+HQBAufdIYLmxZDkAV2rulFdExnJ+0lmEDrTmP
   MtB4ZARaKBomEEgknUsj4lCqdfhp9ZDZR+eX45D3YEeOeZtqHcJSQk/S8
   +ve0Dh5lMR/oong1OGi4G5Vr5BWNdDswfDyoJPg1TvQ+Q4hve0HQA9b2k
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="313207002"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="313207002"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 11:55:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="743000121"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="743000121"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 10 Nov 2022 11:55:25 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 11:55:25 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 11:55:25 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 11:55:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mT65X0HQXEJeE8LOpn6Gha+RMYlkqaUbQprnKD+9P5Rlo+YqFcWmkXUohR5IFieoVZd0lDfjuUwS7Nw1boE5/v/Vis4esdK89bvv7nBjvhcJmpTr/WY+iuVhFCv9BnBaBHsLsxZ84IwNnDZoFUcDqqS3kZELk1kV7v4/okIhdWI/OOoJGIMG08KBOEUw/9dHkXNAzbsrStMN4Fp6SgQ4lrd2QrT8StpnH2p+g0X7rXFek4OpJdVWkqYutrgD9sMraNJysYy191bcnNRKMwWcuYouFafVJVr8UCG8Jnp42aI0dRgyB/5yortw6TkosFBZI45GVVeWXJVMIGkRoY2rwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nCesrJ4ZlndBqdt7wtVQ2pNk14GR9YpV/vfTC2/Uq2o=;
 b=Js9JjRmX9hsF9TOmigfX8aCcej+VCdw7ptbNgrUvpa7bdeNcvakChLAYPMBu6RpxWcdPfq4Zyn73jqo0HMLvrESAT3pl8ImHzsBAHO4U7MKQTj2Davq57PijK+yq2j1VFaJTd9arRvbokimGzPhLcg5c2xo/Q13Kji9nVo5GqslTCAj2BET3RVTRj6pUK+pHsQ+cvIyDojgrpvAvHwBSYJoFi3HPSR0/172sdV2VMcGi9iDY6jdzl0EQF/NwuYwtuweT1Abqq/O6kPFuhA1xrTI3n9O5Ucka0CmjExuGW5HJ5ho+YbOMaxQ6BjEWfyYvnwN13bwXlvKR/xbECX9Pag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by MN2PR11MB4599.namprd11.prod.outlook.com
 (2603:10b6:208:26d::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 19:55:22 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c%11]) with mapi id 15.20.5813.013; Thu, 10 Nov
 2022 19:55:22 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RESEND PATCH 2/6] x86/traps: add a system interrupt table for
 system interrupt dispatch
Thread-Topic: [RESEND PATCH 2/6] x86/traps: add a system interrupt table for
 system interrupt dispatch
Thread-Index: AQHY9M85Yu9uY6afW02HaiePlaJ2sq432uWAgAC2DaA=
Date:   Thu, 10 Nov 2022 19:55:22 +0000
Message-ID: <BN6PR1101MB21619E2092AFF048422C6311A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-3-xin3.li@intel.com>
 <Y2y8obdYDXo9vlH/@hirez.programming.kicks-ass.net>
In-Reply-To: <Y2y8obdYDXo9vlH/@hirez.programming.kicks-ass.net>
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
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|MN2PR11MB4599:EE_
x-ms-office365-filtering-correlation-id: 35660864-6927-4a76-b1a9-08dac35580a6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iwsLYRGoObEFsKVp5ll6/4peXmLaxlhLl0DazVvmqGieuGhZ7XnurINfVQPM+MUMYBOiSMIMkMBEK398zuOypxha2hBhOkd03CoDAHj++TM6HrOfGUCee1fy6w11reoWdpF7D/Xdc1t11pLc0uxiDlI+kcskAhDX/z/248I4+8PzuJo+AGnlPxA5QnRjLMZPScAfqXhkh5gpkCcqKoCWTAXbhyMCQjtxq8xqemIGneZTinRleJj8todpgV8bOGHgPz9POrIMe2CI+P/D/HYrsa3i33+1v0PB6heJPu2nQxwutpXtt5s14akFycE4mdXinMeYuFbrdrSLad8rc5/3PgYOaTAH636vpbAdEi5PJ+RachL2BkE7+C4v2tdmpdz8pGR9VmdUdVrg2fpyJ27StC2C/n7eC6Dx5HbKwqhDIpGII/gGDPqXVekJPfFKwVzbAVEtyB70SF66aOD9upFwHtlgG2bozQFJkIOOWX20oum3lH0tZFs7uvohNb1Dq/vfRiK8ghbC5rGwxF5hjyCl0kaJNhP/hwISFaB+9UH+8thbPSxZb6ZCtxHj5YYLAkQsxUna/j8dq8VjQ1mkdlRdEHkotuUhngSnUfKSsmcwJlHgQOWPB0GIo6Dd/iLho8955kxgcUJwhHlE8BNQBtM+Awd49Eq1cgvK0lOLDKN42xby49qbYFIsJVjuzIKKKZRBU7aIYxYBUlVEOXXdALK0CekwNv84vQ2W1FUHu3v7JmG67Zmnz6nXj1sOr05s8NoyCAAZouzUqhXH13lyctwvHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(346002)(39860400002)(376002)(451199015)(122000001)(38100700002)(4744005)(41300700001)(33656002)(82960400001)(2906002)(86362001)(4326008)(38070700005)(6506007)(7696005)(9686003)(26005)(478600001)(66476007)(316002)(64756008)(8676002)(66446008)(76116006)(66946007)(71200400001)(55016003)(66556008)(7416002)(186003)(8936002)(54906003)(5660300002)(52536014)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?C+6WVSatpfChnMP0kJYVM8lQFjrXzYIHppdISL8dkyTxfTsPt/dveBzbWBzl?=
 =?us-ascii?Q?nIOg3uHNJgRNw358FeesfqlazkSEyGjnTRJIVz542IGQEcmDsj7P+0NVUqDr?=
 =?us-ascii?Q?nK021BGLqW1SMqvycokYVibbKvZMWCsBTccpYekvb/KXNCNlWa6OpbN5Yva3?=
 =?us-ascii?Q?VpJb6VVbY5tG6ERxA1UnbOMPPRu7I35ppdUe9Y0W2wqiC2AQr+t8OzX2J4CL?=
 =?us-ascii?Q?purWK2bCXLgBttjeRY8oMJ22/klcfEYPjyjcNuguUKeslVOweKegT/WJF9NC?=
 =?us-ascii?Q?3TUR+mFZPNhT00GKAxRPS7TwoORH/QYPUGDouCelhtuqbs9NlHNoetU0vjvU?=
 =?us-ascii?Q?E7/LsWz82UFzafOolNLz0STDhqVKm6xp1JfJFnqy60a6ih0XRbW9iyyLUQGK?=
 =?us-ascii?Q?WnOui7dtBzZLsZOeE5oHdtlicsX0KWNj8kHWGR6MvFQccAnJWBq6s+4EvQ31?=
 =?us-ascii?Q?nKZP31/nTRKaOp9p2+PDa8Zk/QQ8v+CLPPGeSJJxU2pZZ2YnOZW9Ye8c0p+C?=
 =?us-ascii?Q?mhxq1RYv/VWHf1VndyUA3DtuZ3AupAKeLdVFa7b6y6Zo2S2PHbmcH6mTT9bk?=
 =?us-ascii?Q?n1V/g1fdlC462JlbKEedRiLPh5lSG2ZUTqp+3BlrcEzke50MC4DT6HW1urHI?=
 =?us-ascii?Q?2Gb7EGjJC+CqKcCgo7Kb7LqGmeRSoYAg2IqDq9GvWNz6jch1VjbZ56I34k5l?=
 =?us-ascii?Q?DZu9ig2xpAg0+zQhelfklatG0f8ifqsPFSP+Dtq3tjid4ucixIlxL3ywdJvQ?=
 =?us-ascii?Q?I73CMFzgXQbVCWXWO52UG1ddSrIgGxQJ384/+9qB+z8aFzQUdrDdrJ6dolv6?=
 =?us-ascii?Q?pNXtM5vWLqvl2tl0PRWREnDOFPzv9yGgQTSVF2DiGHklAhqm5zH58GRSI+o0?=
 =?us-ascii?Q?F1x2ilerLeIpJpOf1UPc8lZL511RiVlG2d1WSBCoMqzqifcRsZ6N2UvG6tzr?=
 =?us-ascii?Q?4laehYST50fXPDGhhFPt/YGEnUyVE1D7g9V08ywNPAlvFkOdU2cTN4l5ebWS?=
 =?us-ascii?Q?rNa8aVDz5euQQzkZ6VJ0/rmMW+ztj1kihgzJd0OWxFwGN2vc1ALsnD6setPG?=
 =?us-ascii?Q?8jJEKvqkQwLGrrqRNIysa+NAQ0IbHY8RiwZhe6fhQRcyvBc7m60CRBuA6Jqu?=
 =?us-ascii?Q?3pEwBG1/amu0JiQzolTX7bs2wsuPojBfNPDGt0IbGK5Vsdm+TydyO8SqoHrd?=
 =?us-ascii?Q?qnlIszgsPp9kgM7xpJbd/EcgILq4J02oMLOzskuIMKUKBSGTiO4VMvibkczl?=
 =?us-ascii?Q?Q2AI/JDA6RRUd2RwC6FktkGrELRvGOY49AfDvQl5SiKxzZ6dsaLZhxwO3+5O?=
 =?us-ascii?Q?kPw1UBAMX9LavWOOI/YBB3y7GNQ1HDwCKq3npjcvSmmjtxQ+PDilIbMigNAc?=
 =?us-ascii?Q?Ag2myoADLChWpJPLoY/zfJckbuDsnaCXGFsdSUBuwSn1yWDk6L9VpGbk6r/1?=
 =?us-ascii?Q?s9K3Qtw4bOBOfcXvc6DAF0VnKcKdkqHIa96dmRqLwimS2r8+LVBzLl3fVw/s?=
 =?us-ascii?Q?FgRwBSzVjdXkszFqJ1TIgRihG4bIsCrxZKd5HdKWMHeSZYShg2kRLKSJcR73?=
 =?us-ascii?Q?V2t5d+fQlWQup/O1xtU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35660864-6927-4a76-b1a9-08dac35580a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 19:55:22.4234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hVjM4OzgFg1C/JiK1pwSfyPI4SRa2p7LxfeN02Dxms85hJkgBelw5oCLQCUacSFV0Nw9HPgsRpB0IpwZp4G9kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4599
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> > Signed-off-by: Xin Li <xin3.li@intel.com>
>=20
> This is not a valid SOB, it would suggest hpa is the author, but he's not=
 in in
> From.

HPA wrote the initial dispatch code for FRED, and I worked with him to
refactor it for KVM/VMX NMI/IRQ dispatch.  So use SOB from both.  No?

> > diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c index
> > 178015a820f0..95dd917ef9ad 100644
> > --- a/arch/x86/kernel/traps.c
> > +++ b/arch/x86/kernel/traps.c
> > @@ -1444,6 +1444,61 @@ DEFINE_IDTENTRY_SW(iret_error)  }  #endif
> >
> > +#define SYSV(x,y) [(x) - FIRST_SYSTEM_VECTOR] =3D
> > +(system_interrupt_handler)y
> > +
> > +#pragma GCC diagnostic push
> > +#pragma GCC diagnostic ignored "-Wcast-function-type"
>=20
> How does this not break CFI ?

I wasn't aware of it, will check.
