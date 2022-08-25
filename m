Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B6C5A0F19
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 13:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241621AbiHYLcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 07:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240285AbiHYLcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 07:32:04 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB042760F8;
        Thu, 25 Aug 2022 04:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661427123; x=1692963123;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RTJtAapSFgsrGAesCc8SkBC1g3CTKIh8Ji38VWBjeKM=;
  b=PpEnO/+Wj/r/nqY2awajnEc0XfvUS/5Yh2AOVVSLRUHBJDrAHYOHyMcO
   GUpqeV3Sp296Tcw7VIGSCKDayo8cvdLegYmVwmCSgGp+GVItlH5Eu/nvv
   gOK/E0O+dnqgIac3YqYPaeocXDRRft4sjbc+q97Kmg4ZPc1YMs5CRN0aU
   aWJ9s/iafz6GV3ud3s+FQ0mdbw++FzIQ42Rzi7DKMXvD5qJRdbQe7lnoO
   QPbmFMJSfThXlVCUZoftYFHGcE58UjUwo+sDnFO/Bz3AVwCa+YuLHU/Dp
   zkZ0wpfcTLIwx25PtrMbj9SeDxmBlHnpxmmmdKOYIEZxFKTovee+MlwDz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="295495496"
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="295495496"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 04:32:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="713456906"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 25 Aug 2022 04:32:02 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 04:32:01 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 04:32:01 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 25 Aug 2022 04:32:01 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 25 Aug 2022 04:32:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b9GVaERGz4LsvoZpe3CPsIqPQSAU1EQE7C76h+3TgcqEcsCPTtcLURqnnYE+HQnTzXfJu+Kh0rgAMJ8MQU79O6eJXx5FMxFW/KpMs3LDAbLDw5WMzwWhGHpe/MuCTEJAbcEagAFT7kdluu0ha4AuY/LUtqSBH4MBtOP3kU6M4uPHyiCPAjGgriq8ddfCxNFFqP0Cl7hbn74EC95D+xlk6JsuLMt0t7apzGZ6w8TRd/Ewv1QlYIsLYG44G3v8Q6cpNTLU3DjCWpw2wok00+rNJ5k/1THM/gZ4qgPUmp0+qiWCq6cDM7yNgmc6PXohUQ0WBsYQTQjeyLAPNjyeUBsqdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A6fBUTid34DHDBfrypqW9p+k4ce561Ibep3oMD/SJso=;
 b=Me8tIq4kY+oX44kaP1Sk4c15tuZhnPxy7BDwSM9gI98H1vN+CDQlRlmV/y8Gv+t7mNQt69u5uTyZmcan/SvE4dmxBocmMGjPYzrJCLpPpQxhyfUeQf+2dvDGhqfhK2bxaTEosfDlfdObwXcN51Hvu/hlBYwcuEuTXeLHwjpQeyjW+ffqOvkFoZ5XZBrX/+hNdSwvapKMPQ0E/rSGv7ydTM6/NB+Gusz5FYIU/zqNQph6PIXuqZWQRNBZvKzKZSe3MV0CdwqNBphaO7WKiKll/NyT0Q9wJeH5MxtHqHx29tjnCGZ1wr1MkRwccQKat53UQjMOURW8MfWOoku4fS2reQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB4824.namprd11.prod.outlook.com (2603:10b6:510:38::13)
 by PH7PR11MB6356.namprd11.prod.outlook.com (2603:10b6:510:1fc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 11:31:53 +0000
Received: from PH0PR11MB4824.namprd11.prod.outlook.com
 ([fe80::adb4:9c0e:5140:9596]) by PH0PR11MB4824.namprd11.prod.outlook.com
 ([fe80::adb4:9c0e:5140:9596%4]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 11:31:53 +0000
From:   "Mi, Dapeng1" <dapeng1.mi@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "rafael@kernel.org" <rafael@kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>
Subject: RE: [PATCH] KVM: x86: use TPAUSE to replace PAUSE in halt polling
Thread-Topic: [PATCH] KVM: x86: use TPAUSE to replace PAUSE in halt polling
Thread-Index: AQHYt5jfiwON7Q5LUE+jIx7HUxEKwK2+LJ2AgAFKPtA=
Date:   Thu, 25 Aug 2022 11:31:53 +0000
Message-ID: <PH0PR11MB4824201DABEFF588B4E0FE34CD729@PH0PR11MB4824.namprd11.prod.outlook.com>
References: <20220824091117.767363-1-dapeng1.mi@intel.com>
 <YwZDL4yv7F2Y4JBP@google.com>
In-Reply-To: <YwZDL4yv7F2Y4JBP@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69e8e0aa-a3f9-423b-54a7-08da868d6919
x-ms-traffictypediagnostic: PH7PR11MB6356:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bngi1cZzez3ZSZRYQGXPYPzS5HzX64DyGxtXnAY0UMp2IG+XTYHD5JWsZXOpzoUz2+nKS7idBLJD+Hv5lB3PJRgg25HS+i6kTxKaPTRkUkIC2of41YKWv5IYnKBlTmBYyjCSuS9RWWTKdYXqhxbXoNWJZtAgiOnSGf22UMVNfieJa6SKj6ZOIjTb4jvZ0XBq8AtBJRTqL64xWZ7z8rFkuLzM63XisXRvTVHB4+eFyKB30+Mjy/I/G1HmLcv6zl7nMZ6PL+SSwUiVqGMdzHV2zxH1mJVl5jW19lHZb8cHq/9zxEZTZUPJNSQw/O0PBPmgTEgEbI3WtFzqUSoD3Dl/XaDYnGh9NopUyvA8yCa81MuWTuWXuyLAYco4V/rR5Q5IV97FjPlAmSpSFtvN9X5ui0xNTrQeNfCOVVY2Nq9bEOQ/rzHH2ekiwN+hGnvOQxg4xC8loGZC1utXmZnyZQ7dv+uU5WP+s9fqldhwB75D5kWQ4UG65lpt3Y3lWutlSVwBRs5sw0zEIwlawM0MrmjH1TNQcEkQCN1jmbdU9A++oA4aYL3GA4/iamKcl1FemtkYssFAdQlc3Frq5sSScSOjt1lrzPZyrluAwDgRamtHzlAjqZg5aAtdh7j7/cTrOK7cztkgARJLx9VCSNBp8CC6dZwUm/gTACOA76ECEw/sefmbx8gi9OV9vC9kiKBaYz5dpmK/Vs5MzxJy5DgEtIQQVj7Blh08xCTy+KyRM4QmaNF8ZFUtUE/kl3IOOwkFt1ywCEfiljCU2VlQBsSzy0/+8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(346002)(396003)(136003)(39860400002)(38100700002)(122000001)(71200400001)(316002)(8676002)(6916009)(54906003)(82960400001)(66556008)(38070700005)(4326008)(66446008)(64756008)(76116006)(66946007)(66476007)(5660300002)(52536014)(186003)(55016003)(8936002)(33656002)(478600001)(41300700001)(2906002)(83380400001)(7696005)(9686003)(53546011)(26005)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Jd9KSLqkNeWnTWyaHaIUByCNOzsd2ifDrvNPyOf2XqptP7Mdm7ywKctW6ZcR?=
 =?us-ascii?Q?X0lZv87jLx7kJ6ZkclsJNDmpotjMaHRgtyr0Q2r4dFkbmug43Uf5k59cJeLH?=
 =?us-ascii?Q?AbBAu7Z9NrbIS+Uee/io8bPMpDIoUejO/j+sn8dey2qDVkxBQes5o07pEOwo?=
 =?us-ascii?Q?aP9rj65lz3Lu2hydDj3PBl2TWQyBiFGIyUBJyaWoWROBpD3GowrSSiO8MTeQ?=
 =?us-ascii?Q?sYOCgZqv0HQmQeK9j2tz7fUac1/3ZSIAi8/x6hvcRt7dKpZH1Lp/w0FJaw/r?=
 =?us-ascii?Q?t2m8CPWcNE6Wh5eQdXy77sMh6qqX4GqGTe2gbeZr41HnxQImFimgTB1TdAxH?=
 =?us-ascii?Q?eHZqA6bE8ZUMpjxFjtHVLvy53GnJo/iwbdcWgehLRQTsRJHlrwPqESf5Fk+e?=
 =?us-ascii?Q?JZ6YUL7uXkijU/obiv08yaD9Ds7oMyZRG33YsuIX2PyDr6TX9IQ29Z5mX4Ot?=
 =?us-ascii?Q?4V82KBNsIXIMyus4o3LYWNmEuzXcXVdQ8zdslTFhkAk136XLyUuok7ugV5uj?=
 =?us-ascii?Q?J/+/5WrpI96C94MkYcXyyI6g4bc1A+nqZllY89tBF3tYBVHPTSOpMJLQwPnn?=
 =?us-ascii?Q?/GnMdlwUGp7ZU1aeJyklI80Chv5ANCirq+LUrrXUpqweYbda7dNbQBEW1YFy?=
 =?us-ascii?Q?tVlndwb6Li1jsq1uJ9QAtOSl/WTXNCVFF+1T/1r/OxhyFm1ifx6owDsJ3UCm?=
 =?us-ascii?Q?GFJjqYf5pGvvNeZ0kO80Qtof2ZTMmvpqlR3M6DiIciYMgxe85hZLSUDHB7fy?=
 =?us-ascii?Q?+9IFDSUeHWt7jdIhOfMB1EmMBNClM+OMgh8In8D31ifiHRyXMv+FlR4GbJ6w?=
 =?us-ascii?Q?YO+k1bL8nkE3lHm/cFsqXUOVQ+xqpgOKuAS4l6c97+pietdYGvHGMzQe1WPT?=
 =?us-ascii?Q?0bhC6rFNkyPiBuUdlHM7H/ozkxC70d+qpANBg4kXvLSN4BEsxMHVGAQUSrpN?=
 =?us-ascii?Q?a683lTRnaS/Auw9snuodVf6WobGcA3SPPfUPf9NAcSygjgcDqzn1tnViSBY0?=
 =?us-ascii?Q?OOVvt0T4t6RebsJjxPtLLMgOoyZt7tcGtCSDRu6hQgvdpMSbUV15OKQikJMx?=
 =?us-ascii?Q?gnZJEOjttEX5CG8Upou3KKobei2roxchcwuwGoBJAFIDMuheFze1nvKjdxF6?=
 =?us-ascii?Q?27P59pw+iTL2SCtaESxSE8F8jlIkAJgu78oDedw3wGmK1XEOL9E9dst5Bgv0?=
 =?us-ascii?Q?PwOveBggdr/E7HSEUJ6ckmRokhOX+yu/A9ml3UQpdIowFOH7NZgLuShuBUos?=
 =?us-ascii?Q?qqzsimsraPciLz4HUXgmg5zUWDD41bDX9ZS02K2HD+UJD4kJL4OHSJp2mvGd?=
 =?us-ascii?Q?3k2zUGQejhqNX99fYmjONLYstqCEqudOykKXQEzPmsp3+fyUoZg6w3I9JGYC?=
 =?us-ascii?Q?CyoKuFE26LTOIFYxDz+S7nxMgaeQY9KyxqUIKPNZ6SUQYLfzFQBWfLLg6abc?=
 =?us-ascii?Q?sfeUY/Hqjj5dxTNs29x+A0phW2wTScyrMO5dwFCIKGAiAAc/gB7Hjj1fMlOH?=
 =?us-ascii?Q?QDOxNq847DEyfaMQ/8Mg6VwnQYq9WgvrQpm6URAbO3Vd/PS2w3qVZHMYLybk?=
 =?us-ascii?Q?yUmX6xaZ1cAeR7iKbm4x3f4AKkoOo0V3oPwsN/5n?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69e8e0aa-a3f9-423b-54a7-08da868d6919
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2022 11:31:53.7656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LNk/x1WWUk/wErQp6jYUt5tPszZH8zsnzPcoSi+LTBs+7yUXzK7B1myowoBqhun2kqQGrc0IUa8SVGODw2VsmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6356
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Sean Christopherson <seanjc@google.com>
> Sent: Wednesday, August 24, 2022 11:27 PM
> To: Mi, Dapeng1 <dapeng1.mi@intel.com>
> Cc: rafael@kernel.org; daniel.lezcano@linaro.org; pbonzini@redhat.com; li=
nux-
> pm@vger.kernel.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
> zhenyuw@linux.intel.com
> Subject: Re: [PATCH] KVM: x86: use TPAUSE to replace PAUSE in halt pollin=
g
>=20
> On Wed, Aug 24, 2022, Dapeng Mi wrote:
> > TPAUSE is a new instruction on Intel processors which can instruct
> > processor enters a power/performance optimized state. Halt polling
> > uses PAUSE instruction to wait vCPU is waked up. The polling time
> > could be long and cause extra power consumption in some cases.
> >
> > Use TPAUSE to replace the PAUSE instruction in halt polling to get a
> > better power saving and performance.
>=20
> Better power savings, yes.  Better performance?  Not necessarily.  Using =
TPAUSE
> for  a "successful" halt poll is likely to yield _worse_ performance from=
 the
> vCPU's perspective due to the increased latency.

The Intel SDM says the C0.2 state which TPAUSE instruction currently enters=
 in kernel would "Improves performance of the other SMT thread(s) on the sa=
me core." For some multi-thread workload, it could improve the performance.=
 But considering the increased latency, I'm not sure how large the performa=
nce can improve. But we don't see obvious performance downgrade at least in=
 our tests.

>=20
> > Signed-off-by: Dapeng Mi <dapeng1.mi@intel.com>
> > ---
> >  drivers/cpuidle/poll_state.c |  3 ++-
> >  include/linux/kvm_host.h     | 20 ++++++++++++++++++++
> >  virt/kvm/kvm_main.c          |  2 +-
> >  3 files changed, 23 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/cpuidle/poll_state.c
> > b/drivers/cpuidle/poll_state.c index f7e83613ae94..51ec333cbf80 100644
> > --- a/drivers/cpuidle/poll_state.c
> > +++ b/drivers/cpuidle/poll_state.c
> > @@ -7,6 +7,7 @@
> >  #include <linux/sched.h>
> >  #include <linux/sched/clock.h>
> >  #include <linux/sched/idle.h>
> > +#include <linux/kvm_host.h>
> >
> >  #define POLL_IDLE_RELAX_COUNT	200
> >
> > @@ -25,7 +26,7 @@ static int __cpuidle poll_idle(struct cpuidle_device =
*dev,
> >  		limit =3D cpuidle_poll_time(drv, dev);
> >
> >  		while (!need_resched()) {
> > -			cpu_relax();
> > +			kvm_cpu_poll_pause(limit);
>=20
> poll_idle() absolutely should not be calling into KVM code.

Ok, so how should we handle this case? Duplicate a piece of code?

>=20
> >  			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
> >  				continue;
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h index
> > f4519d3689e1..810e749949b7 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -35,6 +35,7 @@
> >  #include <linux/interval_tree.h>
> >  #include <linux/rbtree.h>
> >  #include <linux/xarray.h>
> > +#include <linux/delay.h>
> >  #include <asm/signal.h>
> >
> >  #include <linux/kvm.h>
> > @@ -2247,6 +2248,25 @@ static inline void
> > kvm_handle_signal_exit(struct kvm_vcpu *vcpu)  }  #endif /*
> > CONFIG_KVM_XFER_TO_GUEST_WORK */
> >
> > +/*
> > + * This function is intended to replace the cpu_relax function in
> > + * halt polling. If TPAUSE instruction is supported, use TPAUSE
> > + * instead fo PAUSE to get better power saving and performance.
> > + * Selecting 1 us is a compromise between scheduling latency and
> > + * power saving time.
> > + */
> > +static inline void kvm_cpu_poll_pause(u64 timeout_ns) { #ifdef
> > +CONFIG_X86
>=20
> This is not preferred the way to insert arch-specific behavior into commo=
n KVM
> code.
> Assuming the goal is to avoid a function call, use an #ifndef here and th=
en
> #define the flag in x86's kvm_host.h, e.g.
>=20
> #ifndef CONFIG_HAVE_KVM_ARCH_HALT_POLL_PAUSE
> static inline kvm_cpu_halt_poll_pause(u64 timeout_ns) {
> 	cpu_relax();
> }
> #endif
>=20
> It's not obvious that we need to avoid a call here though, in which case =
a
>=20
>   __weak void kvm_arch_cpu_halt_poll_pause(struct kvm *kvm)
>   {
>=20
>   }
>=20
> with an x86 implementation will suffice.

Sure. Thanks.

>=20
>=20
> > +	if (static_cpu_has(X86_FEATURE_WAITPKG) && timeout_ns > 1000)
> > +		udelay(1);
>=20
> This is far too arbitrary.  Wake events from other vCPU are not necessari=
ly
> accompanied by an IRQ, which means that delaying for 1us may really truly
> delay for 1us before detecting a pending wake event.
>=20
> If this is something we want to utilize in KVM, it should be controllable=
 by
> userspace, probably via module param, and likely off by default.
>=20
> E.g.
>=20
>   unsigned int halt_poll_tpause_ns;
>=20
> and then
>=20
>   if (timeout_ns >=3D halt_poll_tpause_ns)
>   	udelay(halt_poll_tpause_ns);
>=20
> with halt_poll_tpause_ns zeroed out during setup if TPAUSE isn't supporte=
d.

I see. Thanks.

>=20
> I say "if", because I think this needs to come with performance numbers t=
o show
> the impact on guest latency so that KVM and its users can make an informe=
d
> decision.
> And if it's unlikely that anyone will ever want to enable TPAUSE for halt=
 polling,
> then it's not worth the extra complexity in KVM.

I ever run two scheduling related benchmarks, hackbench and schbench, I did=
n't see  there are obvious performance impact.

Here are the hackbench and schbench data on Intel ADL platform.

Hackbench 		base		TPAUSE		%delta
Group-1		0.056		0.052		7.14%
Group-4		0.165		0.164		0.61%
Group-8		0.313		0.309		1.28%
Group-16		0.834		0.842		-0.96%

Schbench - Latency percentiles (usec)		base 		TPAUSE=09
./schbench -m 1
	50.0th					15		13	=09
	99.0th					221		203
./schbench -m 2
	50.0th					26		23
	99.0th					16368		16544
./schbench -m 4
	50.0th					56		60
	99.0th					33984		34112

Anyway, I would run more performance tests and see whether there are obviou=
s performance impact.

>=20
> > +	else
> > +		cpu_relax();
> > +#else
> > +	cpu_relax();
> > +#endif
> > +}
> > +
> >  /*
> >   * This defines how many reserved entries we want to keep before we
> >   * kick the vcpu to the userspace to avoid dirty ring full.  This
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c index
> > 584a5bab3af3..4afa776d21bd 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3510,7 +3510,7 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
> >  			 */
> >  			if (kvm_vcpu_check_block(vcpu) < 0)
> >  				goto out;
> > -			cpu_relax();
> > +			kvm_cpu_poll_pause(vcpu->halt_poll_ns);
>=20
> This is wrong, vcpu->halt_poll_ns is the total poll time, not the time re=
maining.
> E.g. if the max poll time is 1001 ns, and KVM has already waited for 1000=
 ns,
> then
> udelay(1) will cause KVM to wait for ~2000ns total.  There's always going=
 to be
> some amount of overrun, but overrun by a few ns is quite different than o=
verrun
> by a few thousand ns.

Yes, actually I calculate the remaining time and pass it to TPAUSE in earli=
er change. But this would make the code become complex comparing "cpu_relax=
". I'm concerning the complex code may impact the performance, so just simp=
ly it.

>=20
> >  			poll_end =3D cur =3D ktime_get();
> >  		} while (kvm_vcpu_can_poll(cur, stop));
> >  	}
> > --
> > 2.34.1
> >
