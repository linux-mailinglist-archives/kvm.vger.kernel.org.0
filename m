Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8083173F2D3
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 05:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjF0Dfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 23:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjF0DeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 23:34:19 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D400B44AE;
        Mon, 26 Jun 2023 20:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687836587; x=1719372587;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QpdbXEeS72q5e8t+67fW10xGqHrzrbFSesk26O+BjYc=;
  b=SDn0hS12sLhZBfHitO1JDWdp1Z8F0fJhcoo95T6QkVDrwRjNWXVe9nD6
   2gpKGJDjeTVc/HI34n539VMSUP19yTRqrxchX/iZNYQ028bTg9NbqtsG+
   ivLqexnbF/VXny+z93B11LFZcK0LlFUOFtDoVYYBJxYZvnBMEzE+tiMKG
   hYa+zXfWH7OqPcXq0hiF/havKkZ572XiGwWg8FNy6lPmmN6RqKG3EMlOQ
   Qk45KPGzlgJgDOXFzuU9DX2PBFsO8HFZY6IFBJP3lnzzRikG7KivEzM3x
   dWrBEL5Z961Zy9mIvAntPAo8kd4MwTgzv/WA3Tl7Lsaj9NGaAdPsre+Bx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="427460833"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="427460833"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 20:29:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="890518535"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="890518535"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 26 Jun 2023 20:29:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 20:29:28 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 20:29:28 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 26 Jun 2023 20:29:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIGqhtJP3sd9UKctp/NTsOBYOdBS0tP75iyJUMOa3BxWiEWL+Fdv6qITl6J3XhS+v96K3XmRLWJp4TykUqL52GrUg+M7JDHmLhZm1LI9OPeyxpxJx+tKizhDFbttclc1zk+JQeM5DSMta2u6TgrkeFUb6nN3Yt9Dofx5/beKuQaRZ3DDc2yU5vhvbPwE9iHupQc+RT4eQcNNlDkOxArA9PUBIbjffhhLSWKECXsQ2nP8sLT0XXz3Qlcpi++9C7wK/K9nGOs/0JqHRgRdVQXmiRSOzk0r9tJiLEeWFiV/GY95Bhln/vFseEFnMc9Z3KBGX4MkQiW2S7t8NKr7owzcvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=soypFnwnp3SEGcd4P7xzxG5ZONyQ67Ke4zqHhlt9Vek=;
 b=e3TlcafbixJrbNLCZdSQhKu09JfzhDzkcRe1lJsqglgyTMto4DG+OH0Doisuf6ZyZFVwEPWDmsB4hRZzA0WdlVHcyxC4/NPtGoF4qqCfTSov8V2Nb1PgVvaB/hzVTg3YcAMuC7NRph35ETmz3qlvpU9v+AmM/sZNwdtj+fzBWpOs8MGI+Iuz23XLc30e8MJL0x2lQjXXk2D2lHyGS9Mn8KLxo2WuEuo6dzJ+ds7f69t0wdB5GciCBKaR7Q3QNWq1HUaJuqac1tdSIkyH3dKUWPTfiOjTVFT6IchL4Ev3sqnEeezdE9QOjq3ueK8tBTsETNgRMoaLY8vUzyudR+/N4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5824.namprd11.prod.outlook.com (2603:10b6:303:187::19)
 by PH8PR11MB6657.namprd11.prod.outlook.com (2603:10b6:510:1c0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Tue, 27 Jun
 2023 03:29:22 +0000
Received: from MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c3fd:5b99:a829:ebc6]) by MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c3fd:5b99:a829:ebc6%5]) with mapi id 15.20.6521.024; Tue, 27 Jun 2023
 03:29:21 +0000
From:   "Zhang, Xiong Y" <xiong.y.zhang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Yang, Weijiang" <weijiang.yang@intel.com>
Subject: RE: [PATCH 3/4] KVM: VMX/pmu: Enable inactive vLBR event in guest LBR
 MSR emulation
Thread-Topic: [PATCH 3/4] KVM: VMX/pmu: Enable inactive vLBR event in guest
 LBR MSR emulation
Thread-Index: AQHZoEacn/ONl4ZlqEiTKxW2MUPT76+Y5LQAgAImU6CAAlO6gIAAl+9w
Date:   Tue, 27 Jun 2023 03:29:21 +0000
Message-ID: <MW4PR11MB5824B76276020C1A33A26A72BB27A@MW4PR11MB5824.namprd11.prod.outlook.com>
References: <20230616113353.45202-1-xiong.y.zhang@intel.com>
 <20230616113353.45202-4-xiong.y.zhang@intel.com>
 <ZJYCtDN+ITmrgCUs@google.com>
 <MW4PR11MB5824653862500CB4F9EE4519BB21A@MW4PR11MB5824.namprd11.prod.outlook.com>
 <ZJnEFTXMpQkXdHRj@google.com>
In-Reply-To: <ZJnEFTXMpQkXdHRj@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5824:EE_|PH8PR11MB6657:EE_
x-ms-office365-filtering-correlation-id: 3964143b-a07e-453b-3656-08db76beb2d2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EDleZkA6KZaRkKy2a/FS9ndKjdfJ5l3ffMnZ1eMozJyy7Cfqy+BAI1RbUtOW9O54LSkJiIrQexK+MvrOdAIV2ec+pV0nu5iW8G2bF9hkf2ugu/itkW4bZEf5H0PDPn47p1YqciRt4Q+AmVMo4Y0L8Ln+1JnUQGebJcCG3iuJ4FDpLzFM7//fVMDwKb2OjrMynoN0+7mD6iewKHoiIcJd2w6a0cExGWRV7a0e0fG8CVclnsomXmenRvhZ4Zfmtm8JZWZACjK9yOaj50TgAATPaON0UlrE7xYYffMK2xTIHl5Jpx3/Ye1PHP+7McuBnKLyk5uxtBG7IPQdIsEWU+QURxZU5u5iPHDNuakogijRYoqKmC7V+Jr32PLAFpYXH6UtzDZ9gYfScUIroZPmqdKCJiFH7p+BSSmZ5uuXGiHpOpsVABI7QfQPrxkqppezp4cuJvMoeoAs69HZ8rryeQrmFYo+7zPvc1bv+13n4wNBu5uIXQiUc1uLVzHtYIArAukePwAEUM7o8xEOYgis1MXcoxxKfyC6LGcAljU38T0eHnR/9/Y4ZCqvxMWEPz1B9LuhPWtCR2gzp8ei36n+U6pI6fyEE1Sn2FEF0oMCPU/J0NjCa56GdKC9vI3OOEsTPj/aI6/NhiG/N8xBBFF5mIMoFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(39860400002)(376002)(366004)(136003)(451199021)(122000001)(82960400001)(38100700002)(38070700005)(83380400001)(33656002)(86362001)(54906003)(478600001)(45080400002)(7696005)(76116006)(71200400001)(966005)(66476007)(55016003)(66446008)(64756008)(316002)(66556008)(66946007)(4326008)(8676002)(8936002)(41300700001)(26005)(6506007)(186003)(9686003)(6916009)(2906002)(5660300002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gwS6puNcW5TBqO7sXOlLGQNFkbv8hrw7MI5n/67Xp+JzMg1pioh5A7I5K0yG?=
 =?us-ascii?Q?p1Gb9gsbPzZcVLAWspQ05SLIEuVMirwKcjvYkyYQmlVdp4xAzf2dD+aAVwK9?=
 =?us-ascii?Q?hxmVUH53GQ8i2Hg9Yc+U3CuWC6wLhLW+T6Enq0pWa1SShwXczIrF03GgpOtg?=
 =?us-ascii?Q?KsXs7WLkoaFiWBPb8ft+xxpLBvCh1k5gWZkKc/bzBebCZF63sOFtyN48VwkR?=
 =?us-ascii?Q?74tLEaza5fawKJhJTmzhW/S0jW2CAB/QEd0KCsLkf+tb/K3++/0xpAvMTHMD?=
 =?us-ascii?Q?Hzhj+4ok8t/HAzKRQeGR/wMKHQM2HkaZ/3msSnTx4wn+U92aBIe33X3NCvIa?=
 =?us-ascii?Q?AxwHsQN1/tL350mXwoOztQpulHxcozZnChi/GtLnhgX2R9mzwaRNXAMxMcf9?=
 =?us-ascii?Q?81FYoc0108A0V3n5bClj1yvx5cqCYf87mbwAo8g5GnUnUOgOaaMtBgpOwxIR?=
 =?us-ascii?Q?vvs0FHBRVXBmDRd1Lxl26sEbRTcljya4Sw/4vB3omT5jxt+RlDU+tCuESFR4?=
 =?us-ascii?Q?yshavGjG7ZlWMQ7CrWbuHOMerMSERBUq3ju2UKD18IvDEZOgZruu33DUjUQ8?=
 =?us-ascii?Q?/5RCHSvOmCywf3D85II/exi1NtEl+0HCymfcz96a+UQs6lPuTnWKHHywsgo3?=
 =?us-ascii?Q?G3P11GYbxoMc0t1XSJFuOW4rc1723p9ByUOq5ECEIuNf+/AynAYZ4XeFS5UF?=
 =?us-ascii?Q?q5FeQxDrRsMKoukliH/+k2MqhOXbsFwaRl64d80FRiEi+qxtjOuqFFwkRdkA?=
 =?us-ascii?Q?tk79DQoqb4vxrEQgY14dUXN62R1am748hsa/D5rv4ibgMqOeyBrmbY7eR8Mo?=
 =?us-ascii?Q?Ls83TzjAXvsZ1CAe0aE2Aw0xMjafdKaj3hTJ0mT1YNQ94HBrTYnJdd5jpAwY?=
 =?us-ascii?Q?i3b3jioAZ+MCmCoHaezKGk1mjrwf9crgRivr8rkLHl2vIfpek/zBjIHACLHc?=
 =?us-ascii?Q?ETrFchrhDujmsZY9zU08hKywd+t/vaCb/hSzHSVoIY1z7urjSN7Afx7zrPY7?=
 =?us-ascii?Q?8C9ZIklvvYxRcJQoxB7plXX7SG2V271J6Bbs9+Y2P0EXRZgoUueX9tdIX4MF?=
 =?us-ascii?Q?4nKlBFgCGtGrja0NeTlKKNQ9ys4M1Wdr3or5SOqeZm4jwcCrqc5RAU31WqC9?=
 =?us-ascii?Q?5z4v7ulmCSBZ7dqh2KQYE0mfCWhdyYQcZA9n4tXX6+2KWAhA56fzYtpX3wSy?=
 =?us-ascii?Q?7fGsTzXsz/XbaaCoBShdYvM7qo1TMd5ZMh/bj4s6WZGebE8nW/jI26cr6zl9?=
 =?us-ascii?Q?W9nfXfDUgbpH9cvZ9n72c4uosmiGaSkU+BOGsXWp09W0hmuPyPvOlNvuk97f?=
 =?us-ascii?Q?IcJFbUdEpw4WVn7htjIqpzqSzsWUQgjtvuOAuSxVl1Z08oM52P2MHdgApqhX?=
 =?us-ascii?Q?UykzDsZEXaPaU0yLPEtBdtXk8avJ3YE5KV2gmDGxXOOJ1BMMrWSMEh3Pd0Cu?=
 =?us-ascii?Q?QRMJgLpKjmKHJpzXfoFKiL1rWxi/rDLDXnHe/jAVnRSSaq1sOmMATNy/06rW?=
 =?us-ascii?Q?WiYCeSl3rYaLf7KD0yV0nO5fj7GFgjNq2nsDrnoz5xPxxfLQsSPYXDFoCaQu?=
 =?us-ascii?Q?hInt+H0vQE/8FY8JC257u3Ipj0fQDYIQYFHj8RiR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3964143b-a07e-453b-3656-08db76beb2d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2023 03:29:21.8423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VqQ0tGGzue1q0Jj5TW5nNOCRiRoJfJGeAH9X/XTI58gu6kOv4B7y/KRc41pIMlKbpDHtK9e/AYpwu0temLYDsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6657
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

> On Sun, Jun 25, 2023, Xiong Y Zhang wrote:
> > > > On Fri, Jun 16, 2023, Xiong Zhang wrote:
> > > > vLBR event could be inactive in two case:
> > > > a. host per cpu pinned LBR event occupy LBR when vLBR event is
> > > > created b. vLBR event is preempted by host per cpu pinned LBR
> > > > event during vm exit handler.
> > > > When vLBR event is inactive, guest couldn't access LBR msr, and it
> > > > is forced into error state and is excluded from schedule by perf sc=
heduler.
> > > > So vLBR event couldn't be active through perf scheduler even if
> > > > host per cpu pinned LBR event has released LBR, kvm could enable
> > > > vLBR event proactively, then vLBR event may be active and LBR msr
> > > > could be passthrough into guest.
> > > >
> > > > Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> > > > ---
> > > >  arch/x86/kvm/vmx/pmu_intel.c | 11 ++++++++++-
> > > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/x86/kvm/vmx/pmu_intel.c
> > > > b/arch/x86/kvm/vmx/pmu_intel.c index 741efe2c497b..5a3ab8c8711b
> > > > 100644
> > > > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > > > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > > > @@ -314,7 +314,16 @@ static bool
> > > > intel_pmu_handle_lbr_msrs_access(struct
> > > kvm_vcpu *vcpu,
> > > >  	if (!intel_pmu_is_valid_lbr_msr(vcpu, index))
> > > >  		return false;
> > > >
> > > > -	if (!lbr_desc->event && intel_pmu_create_guest_lbr_event(vcpu) < =
0)
> > > > +	/* vLBR event may be inactive, but physical LBR may be free now.
> > >
> > > 	/*
> > > 	 * This is the preferred block comment style.
> > > 	 */
> > >
> > > > +	 * but vLBR event is pinned event, once it is inactive state, per=
f
> > > > +	 * will force it to error state in merge_sched_in() and exclude i=
t from
> > > > +	 * perf schedule, so even if LBR is free now, vLBR event
> > > > +couldn't be
> > > active
> > > > +	 * through perf scheduler and vLBR event could be active through
> > > > +	 * perf_event_enable().
> > > > +	 */
> > >
> > > Trimming that down, is this what you mean?
> > Yes, thanks a lot.
> > >
> > > 	/*
> > > 	 * Attempt to re-enable the vLBR event if it was disabled due to
> > > 	 * contention with host LBR usage, i.e. was put into an error state.
> > > 	 * Perf doesn't notify KVM if the host stops using LBRs, i.e. KVM ne=
eds
> > > 	 * to manually re-enable the event.
> > > 	 */
> > >
> > > Which begs the question, why can't there be a notification of some
> > > form that the LBRs are once again available?
> > This is perf scheduler rule. If pinned event couldn't get resource as
> > resource limitation, perf will put it into error state and exclude it
> > from perf scheduler, even if resource available later, perf won't
> > schedule it again as it is in error state, the only way to reschedule
> > it is to enable it again.  If non-pinned event couldn't get resource
> > as resource limitation, perf will put it into inactive state, perf
> > will reschedule it automatically once resource is available.  vLBR even=
t is per
> process pinned event.
>=20
> That doesn't answer my question.  I get that all of this is subject to pe=
rf
> scheduling, I'm asking why perf doesn't communicate directly with KVM to
> coordinate access to LBRs instead of pulling the rug out from under KVM.
Perf doesn't need such notification interface currently, as non-pinned even=
t will be active automatically once resource available, only pinned event i=
s still in inactive even if resource available, perf may refuse to add such=
 interface for KVM usage only. Perf may suggest us to modify vLBR event fro=
m pinned to nonpinned.
>=20
> > > Assuming that's too difficult for whatever reason, why wait until
> > > the guest tries to read LBRs?  E.g. why not be more aggressive and
> > > try to re-enable vLBRs on every VM-Exit.
> > Yes, it is a good suggestion. Actually vmx_passthrough_lbr_msrs() is
> > called on every VM-exit, it also check vLBR event state, so I could re-=
enable
> vLBR in this function.
> > >
> > > And if we do wait until the guest touches relevant MSRs, shouldn't
> > > writes to DEBUG_CTL that set DEBUGCTLMSR_LBR also try to re-enable th=
e
> event?
> > Only perf know whether vLBR event could be active or not at this
> > moment, if vLBR is active, KVM could read/write DEBUG_CTL[0] with irq
> > disable/enable pair in theory, but it is better that kvm don't touch
> > perf hw resource directly, as vLBR event is one host LBR event, host
> > may have other LBR event, perf will schedule them according to perf
> > scheduler rule.  If vLBR is inactive, KVM shouldn't touch DEBUG_CTL MSR
> totally.
>=20
> Again, this doesn't answer my question.  I didn't suggest KVM write anyth=
ing
> directly, I asked why KVM doesn't try to re-enable the perf LBR event whe=
n
> emulating a guest write to DEBUG_CTL.
Yes, kvm should re-enable vLBR event when emulating a guest write to DEBUG_=
CTL. Since inactive vLBR event will be re-enabled in every VM-Exit accordin=
g to the above suggestion, no extra code is needed here.
>=20
> > > Lastly, what guarantees that the MSRs hold guest data?  I assume
> > > perf purges the MSRs at some point, but it would be helpful to call t=
hat out in
> the changelog.
> > For DEBUG_CTL msr, VMCS has two fields for this:
> > 1. "Save debug controls" in VM-Exit controls 2. "Load debug controls"
> > in VM-Entry controls For LBR records MSRs, perf will save them at
> > process schedule out and load them at process schedule in.
>=20
> Once again, this doesn't answer my question.  I want to know *exactly* wh=
en
> perf can take control of the LBRs.  The fact that
> intel_pmu_handle_lbr_msrs_access()
> disables IRQs when checking lbr_desc->event->state strongly suggests that=
 the
> answer isn't "when a task is scheduled in".
>=20
> Your other response[1] mostly answered that question, but I want explicit
> documentation on the contract between perf and KVM with respect to LBRs. =
 In
> short, please work with Weijiang to fulfill my request/demand[*] that som=
eone
> document KVM's LBR support, and justify the "design".  I am simply not wi=
lling to
> take KVM LBR patches until that documentation is provided.
Sure, I will work with Weijiang to supply such documentation. Will this doc=
ument be put in Documentation/virt/kvm/x86/ ?
>=20
> Copy+pasting my request/demand for convenience:
>=20
>   : First and foremost, the existing LBR support needs to be documented.
> Someone,
>   : I don't care who, needs to provide a detailed writeup of the contract=
 between
> KVM
>   : and perf.  Specifically, I want to know:
>   :
>   :   1. When exactly is perf allowed to take control of LBR MRS.  Task s=
witch?
> IRQ?
>   :      NMI?
>   :
>   :   2. What is the expected behavior when perf is using LBRs?  Is the g=
uest
> supposed
>   :      to be traced?
>   :
>   :   3. Why does KVM snapshot DEBUGCTL with IRQs enabled, but disables I=
RQs
> when
>   :      accessing LBR MSRs?
>   :
>   : It doesn't have to be polished, e.g. I'll happily wordsmith things in=
to proper
>   : documentation, but I want to have a very clear understanding of how L=
BR
> support
>   : is _intended_ to function and how it all _actually_ functions without=
 having to
>   : make guesses.
>   :
>   : And depending on the answers, I want to revisit KVM's LBR implementat=
ion
> before
>   : tackling arch LBRs.  Letting perf usurp LBRs while KVM has the vCPU l=
oaded is
>   : frankly ridiculous.  Just have perf set a flag telling KVM that it ne=
eds to take
>   : control of LBRs and have KVM service the flag as a request or somethi=
ng.
> Stealing
>   : the LBRs back in IRQ context adds a stupid amount of complexity witho=
ut
> much value,
>   : e.g. waiting a few branches for KVM to get to a safe place isn't goin=
g to
> meaningfully
>   : change the traces.  If that can't actually happen, then why on earth =
does KVM
> need
>   : to disable IRQs to read MSRs?
>   :
>   : And AFAICT, since KVM unconditionally loads the guest's DEBUGCTL, whe=
ther
> or not
>   : guest branches show up in the LBRs when the host is tracing is comple=
tely up
> to
>   : the whims of the guest.  If that's correct, then again, what's the po=
int of the
>   : dance between KVM and perf?
>=20
> [1]
> https://lkml.kernel.org/r/MW4PR11MB5824480492ED55C63769FF11BB21A%40
> MW4PR11MB5824.namprd11.prod.outlook.com
> [2] https://lore.kernel.org/all/Y9RUOvJ5dkCU9J8C@google.com
