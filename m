Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610E2735D8E
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 20:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbjFSSrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 14:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjFSSrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 14:47:18 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661D9FC;
        Mon, 19 Jun 2023 11:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687200437; x=1718736437;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eMxq7B7jI0QTL32Vm4Mx16WshgMX0muGrObIGaqqzcE=;
  b=LEdVFCX8n9GM4bXL82QM1WTVMn/DotW/pSSWlpRWNyBr5pJaXSJdufeq
   cYt+r787D+M/7tJpMk8O6hPZNrs576YgfsuCcwpDZ0jt37+wUqZGuvspC
   i/q4tWUvgKAvEh9R0WZ9xAUQnGqddzx9iik/HQh+ztrorbmsfiiDQFi+W
   JKcpxTlL+tfu11HdVXLKQ8kYgXo2YktvI3tfzsmZrXy1ldOHaCDrRGx2a
   voge3O9pfxK+FooFbOli2sJNYPor3gcur/QNhkpPCVY1w5OEmVq2Xljl7
   At1PXKEXL9VPKvx9+RbdABGB3TT6p7BYS+L1v+eWhr28+5H3zFsKXJ59Q
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="344442377"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="344442377"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 11:47:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="707981209"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="707981209"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 19 Jun 2023 11:47:16 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 11:47:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 11:47:16 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 11:47:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MaNwK+gTgkL9wt7eZ1VuAGObQ41NZItDt4jIQHNW65NftOxlp6FPyH68J5sCWfIabkoQNUoBmdcMFBcbiryb3kMeqJlqy62tsCn2n6I4Rh10MRz+oqHLE3W9GRTqXoK4SL+flPrMJ8kUZBYboYRZO9O/s3CM89pErIilBCdQL4Lqy17pogLpUmzv1rx9ebBov7DCoEHwHltRGbZvtRoYDtJFH5coA3TeRmkCnD5GgDbJ/kJSL+jUemMMNGPEJZX6f6X6uTV0QwyKcZhdzc2Tdo74pGsJIezZbo66ssUDx0zdsZrm9m3w3Lj9TSjWHCyj5mlHzzfcSICGsBeU5qxAww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eMxq7B7jI0QTL32Vm4Mx16WshgMX0muGrObIGaqqzcE=;
 b=W7CTMg1V5peMhic05fSBUulq4//wbluBJuUDfzB1eBVD2UNXm7ni7nbWAkdiXBxXzsYeoADfHGnnBcdbtKCILJvln8HKpuCcChzhDV4GogsLafXriRQy8fOBVn0tkO0EyArIori7Bnl2mv4KLgW9gCQgczh0YKdHaYMiaDgvluIe+1FqGAShzKjfZUtU4bTqEOhKIkHqxyFhMglMu+9SbUOihuIkO4301p05MFMComk2pvgx9DNtIxpAnM7M7AFsbWs69bmWyMB0xVIyuDCvp1qNItiVPnCTOsxBX1555p6AV+cQUyogUCBlY7EjPA1JiQuFc+6c3zJexqZBjRo08A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by BL1PR11MB5541.namprd11.prod.outlook.com (2603:10b6:208:31f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Mon, 19 Jun
 2023 18:47:08 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::c016:653d:c037:44fc]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::c016:653d:c037:44fc%7]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 18:47:08 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v8 01/33] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
Thread-Topic: [PATCH v8 01/33] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
Thread-Index: AQHZa4g62amPAW2/oE6/VfNOqnc7za9542QAgALl3wCAAACfgIABxIeAgBOgaQCAAG0NgIAASD3Q
Date:   Mon, 19 Jun 2023 18:47:08 +0000
Message-ID: <SA1PR11MB673465675DA199C2C7EB1ADFA85FA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-2-xin3.li@intel.com> <87leh08e1h.ffs@tglx>
 <87edmp6doh.ffs@tglx> <70ef07f1-e3b7-7c4e-01ac-11f159a87a6b@zytor.com>
 <877csgl5eo.ffs@tglx>
 <SA1PR11MB67344FE6C8A83810D0CAF175A85FA@SA1PR11MB6734.namprd11.prod.outlook.com>
 <877crzr0pq.ffs@tglx>
In-Reply-To: <877crzr0pq.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|BL1PR11MB5541:EE_
x-ms-office365-filtering-correlation-id: 18df199c-3feb-40b3-9d9d-08db70f5958d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jEnaRGWwEoNYz59iBKqDCLbIPJCKExpJbDV/Nc7nwSg+AqrfL/GjXegqVXI0AGxGK4plFqa7sVXZWpVZl5P4Tz82bbdsDXrClw5HPeW5rViSoGtXZX9R8ZDulhdew43OhQu6yBGV7Zbm1Ixjb7R8Pcw3VbmU6GI+qMaDbxiu0huo3Mu7DKpCFwf6W9UT3NzX1EMllnJi/9a+L92BVFVz6wUWcu/TjL7xDl5etiEmt+1iwBsmS7gRmPP3V17bkkIDI5VfKPFXj/c6eElqzbdEV0qmd5hsZ8lM7FWKRB3YnZfCD3h4/Bi79VXtFS9PMFQ/vSwKJHARpPTflHev7h2ESoiqshTiGLB61e55TU+oTMMw+aGiOz2N4e0rlgZrHhBSJu8FfpXLTp9pZY6JEXa0My//o+GR7mG6Ms7VJpavcb2EBOyk9IEx4+n9zYVMx3sUkfoOi5mRmb1kjWTOqfC8+NwA+3CalUhX9nd76EympFwSUW8sjJjT0nv++V89K7JSdCkER5uAA94WCSbE3bmtibzDVRWtGEoYm9+p5u1kwBHndpY/35+CbA3hfHp8JzuUGt5CBmktt9hFK+koJTUGDv2bzIpD0zNaSiPheHNGI27olxXDvxQfBTRV+Kc2Qwsf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(396003)(376002)(39860400002)(451199021)(186003)(38070700005)(9686003)(26005)(6506007)(82960400001)(55016003)(83380400001)(38100700002)(122000001)(33656002)(478600001)(4326008)(41300700001)(76116006)(66446008)(64756008)(66556008)(66476007)(66946007)(8676002)(52536014)(316002)(110136005)(54906003)(8936002)(4744005)(7416002)(7696005)(86362001)(71200400001)(2906002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3bNMZnovdLGuoq7dWT4G+VvYf6uFW3+tlq663hZqdWMA1blxNEbiXE5Bse6N?=
 =?us-ascii?Q?HpJgA4HxLhbiQEiItbFgF7dsV6EDZi9TXWaM8aPJW1oeY4ikBZnqOyIi1Zl7?=
 =?us-ascii?Q?wzaemRoqStN8CKCawNMT6UoqhQZcBGkAhT60OHI5qU/cQAoZ4CVsIgjjfNWZ?=
 =?us-ascii?Q?0Hz0WItXwjHZMhqJIoJ10ioNgVI5mFvBm4CwYZ+4+JYMdenIDtMh5/+qP30X?=
 =?us-ascii?Q?Rdlz3PQbNwMu2k8/lgHF1zo74H/cVQdUQeE8eOXpsnm8YxJN4AkhWc/Fxrm6?=
 =?us-ascii?Q?+KGYUQPOjIWtSRHmLGMtdbT/tNhsJiaAiYrB8lXgauTahggN74f4Y9gGEk0y?=
 =?us-ascii?Q?ei1Kja4rpVcjVgG8QnNbfvzLKxSCV3zvcg4rt4QOcKclzuAmMmp3g1WOSAI6?=
 =?us-ascii?Q?iePzcgeUdyya/6q0EF625UqBkyG5hx6a1A65rKrlEQRz71kQvQVTIzqFhGrv?=
 =?us-ascii?Q?r3JfgVHA6835XeD8+QD1xklbwLC4QBLSi0G4QzNnWjOanLjRMfdoAqBTTKWE?=
 =?us-ascii?Q?yKBgVQJomNoCPyd+f0LDOx/wfVgXC/tTpICbHEzBe4T+queJDYZjHkNNYptR?=
 =?us-ascii?Q?KzVIH0XGrEhpgp93nKANPvHSnrEEHrWNu5Wv8XFMKVpo2uv78lScvVV1VwuN?=
 =?us-ascii?Q?/MGqL5SZf9qUb4sYK9L7lr6NX6F3pGc9OslGfLW4jTJ9yorvNpiISJeHv2gQ?=
 =?us-ascii?Q?SoI94cx8VIsXt5aoCNl5dieUY0ISbLtuCE/Rdd4w2cpp51j2RbsGYBTHPlmz?=
 =?us-ascii?Q?/Iy5il/lEmXO74M/Xr6Nj0v1gniL3JBy73yRPIT6bo8FjZAGDMj9N0St8RVz?=
 =?us-ascii?Q?X/qk2Ebv3VfoiMgbGwiLFAl0n4Q8MfGI9T05ZwBIQnJv1mv4l6z2KF48ACG7?=
 =?us-ascii?Q?2Y6XOBB97gilnFiRIvh1o38l9UUjoD6V/ZvdR40/UO46v4saduXcDnnUz2gC?=
 =?us-ascii?Q?ujUtnb+d9bjIQRzWP/JrNpLGtHVcsHf/hNnwR53JnxnzlzYF4LTVVJ4PwiCQ?=
 =?us-ascii?Q?CWfUV1zjTkwBRqzv3wsvP5FLsrGbRrDM4tNOthw+s6Pr8SBrd9egStWBpXJ0?=
 =?us-ascii?Q?KqZk+fVDM0bBM2zKqauzd2gZ3K5YlEbak5FfYdJ8Zf2wb3UXAldJfJATNBYm?=
 =?us-ascii?Q?JuBvblqcAvCAqRdIV+OeOea6oWzIqiM5y96244n7SVWY0UbKSTnxCxORiENb?=
 =?us-ascii?Q?zISsdsMRzRzjvtoZv9TFooC8Jy1F50FznrzTg1NoJ5irWRQW4gPmRcT1NY6c?=
 =?us-ascii?Q?j9rEQK78iPhhnv7F6WYX1I6cQtjZkD8cdsnbbDG8tflz4qzUcE5VY0YfwcH+?=
 =?us-ascii?Q?LUjiwWtSGtBRzktJG2xwDv5rQwy6tNDN59BhOdKbDw2DbIHyWzmpe3enJ7VL?=
 =?us-ascii?Q?NLo/oKG8OKq7mmRFuXm0NC0cW3cv0rQoilKg63CAYeuAJibsvPjnd5YMgd1o?=
 =?us-ascii?Q?QIwfIOvFW8JNc80gQF81bTVv33Vt9NXctR2pnq/uQbYEs3f6344TYtQY1Rp3?=
 =?us-ascii?Q?u5XPTUrvk8b/NLpmcvdajitlEdalYOduX1C4xhSj46PNdqlfVyFKLDpMt+wb?=
 =?us-ascii?Q?uxziGodZvpVyHQDP4Vw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18df199c-3feb-40b3-9d9d-08db70f5958d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 18:47:08.0715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t1eIYVnWBZb/N8izZC1dJw9cu0Z7fcInOgRpUXLVptt28utvcZ5oioAFq6XiFXsRHeDYbS6vi08LUNUJ88XE7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5541
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > To me it's better to keep the changes in one patch, thus the
> > differences are more obvious.
>=20
> The rename to vector_schedule_cleanup() can be obviously done first.

Okay, it's a bit wired to me to rename before any actual code logic change.

>=20
> > We need a second patch to do vector cleanup in lapic_offline() in case
> > the vector cleanup timer has not expired.
>=20
> Right. I was lazy and just put a WARN_ON() there under the assumption tha=
t you
> will figure it out.

I see that, as your changes to lapic_offline() are completely new.

> But a second patch?
>=20
> We don't switch things over into a broken state first and then fix it up =
afterwards.

Make sense!
