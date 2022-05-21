Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD5152F8B1
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 06:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238991AbiEUEbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 00:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiEUEbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 00:31:40 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0FF1611E2;
        Fri, 20 May 2022 21:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653107498; x=1684643498;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1WJOuwiHrCA/b/+Dde4gspXx0NB61eGYDhfl6aLCri0=;
  b=Ae7GoQO/bRhBQb3344fJ84aDRxxDQRC0pjoT/kIqv02APIGv981btq30
   P1JpHNRvCG/Dfla1HOE39tXq57QvxSQ2QDIt4V/LjCF0esePDGpzunsaR
   85XiLUJSpT3eWx1XPC/zUumZgHm2y3IiTbZYpthly+twB+KpKkKMydxXY
   YwO3ar8vpgBvKGeAMG+kb2h1+vtpPQv7KdqnAe8NeReNb/fhWbFnLASjU
   mozd5cKPOR5PRI1MBrEobxxuzjQNjiLb7RTinz5Ht9LYjHq6cNPYEVeyu
   HMMyOSB/cWCSwdjOoFDkXwFZcx3x51VZz72el61UKUsEp3dl5Ge8hMmxc
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="272933703"
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="272933703"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 21:31:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="640610754"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 20 May 2022 21:31:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 20 May 2022 21:31:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 20 May 2022 21:31:36 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 20 May 2022 21:31:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d3UR4mjUUizZvDVLCQzBvC03gp0QKbxRn7HBR6OT8eNpbog1NCDDgO1H5AGmyB2pAPPt16GLOBDH1KMaDzqRQDfczEnxIZl+W4Ee6pb3kjQKtwseqkcSvZawcLD0DU8r8XpSXSJbQLXki7J5jCU2erjfDjRTguuiAf4Zz7XeMTfvDAmqGd//CGmm/9Qg+iS6Alk7tMRB75fuVLDBax/ud7wDABGTWR2fdfbSyeYtQoGfONKkl5zlUfJzw5kM1uhVivZ2myV4YKkIsbVRH/jNvXdHklV0hREIsvVRwZoHZiWr42zmDqKyob7NBn8b58JcYFKAG1CxZ+e1Zh9n7dXSeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mfUTlJefAbWTlJTPyRvAvwNzVji91GKw10M0tLwxBMo=;
 b=ZGQDnw6xRFu5yI9tlcYJYCBzNkKGSsd2ZBWfakT7N4g0h3YWVQnta556StCn7tOc4hgwCEggtBKUMGkrPWvBYyJ9GfolRjw7ElmNCmTO3uQ4+ICT4KxhFKffQrmuoTZhA94QA7fT4t4b0ZtwOKXA46rnvfLjj7l7n0dZA+Yx3WLQ6nQSjRIsMEv0NRBYBIXxeqoA9zu2oVsAjEid1g3fmqZVIz4W3h9Iyp3rzO9jkfQAzDDpbW/o0iTZtb27r549g0eDBs8+4LU36SkzpCGEFWNq98fBWeRTUS9DQTlL+fRbfXa8L+CslJsJmOEPe4EKGJ86biFLFxcruVayuVGATw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4138.namprd11.prod.outlook.com (2603:10b6:5:19a::31)
 by DM6PR11MB4476.namprd11.prod.outlook.com (2603:10b6:5:201::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Sat, 21 May
 2022 04:31:34 +0000
Received: from DM6PR11MB4138.namprd11.prod.outlook.com
 ([fe80::e9d2:8b69:bb48:b305]) by DM6PR11MB4138.namprd11.prod.outlook.com
 ([fe80::e9d2:8b69:bb48:b305%7]) with mapi id 15.20.5273.017; Sat, 21 May 2022
 04:31:34 +0000
From:   "Xu, Yanfei" <yanfei.xu@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "Liang, Kan" <kan.liang@intel.com>
Subject: RE: [PATCH] KVM: x86: Fix the intel_pt PMI handling wrongly
 considered from guest
Thread-Topic: [PATCH] KVM: x86: Fix the intel_pt PMI handling wrongly
 considered from guest
Thread-Index: AQHYaH+s6PwCFUVqKUabQKcfsjJv5a0hiOoAgAX7yBCAAHiMAIAAwFlA
Date:   Sat, 21 May 2022 04:31:34 +0000
Message-ID: <DM6PR11MB4138BE4A5AC7BF9AFA8CD369F0D29@DM6PR11MB4138.namprd11.prod.outlook.com>
References: <20220515171633.902901-1-yanfei.xu@intel.com>
 <YoJYah+Ct90aj1I5@google.com>
 <DM6PR11MB41380A9DD32D6542CBC3A90BF0D39@DM6PR11MB4138.namprd11.prod.outlook.com>
 <YofCfNsl6O45hYr0@google.com>
In-Reply-To: <YofCfNsl6O45hYr0@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5df273a3-cfde-4a8b-3396-08da3ae2c983
x-ms-traffictypediagnostic: DM6PR11MB4476:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB44760A33C4D943CFAA77E869F0D29@DM6PR11MB4476.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oNWqrcYd3QtcEAQr6ScyfA+JA278W51xGJkjyRclXqR5114ulaHEum5+E30Mx4zTWZHbeTUAS5Bn3d1rDc/B2yEVH7bPNPEQ2ZIf6ajn5tIxZWq9uk52QSufvuZR2+if7YccYQLnlLr9D4p6gqPrCloODeWvd87STol1aNJ8Fg4LCywjqd1ED2uVP5pRD1+vprrMWIFfrBz7lFlyVg3etEa4BndFQGj4gLJsbn0T5KOaT8BEDLs5qu4avR0OfmAGmb/LqH6dQnuZRTSe8ASivmAuCzGtuzruQ9pSHoqmH0MpUOH1bVYdbAe5C/Urg5+Sn9PntB78qLNIZIEb4SWnSbY3nM0FnDhm4OoEI0rAcOQtVDD9NFLyMCymzp+glhlkMzzQQx1uPt+JzgEyQeISBuPAWoUaoNRCB44EDbzZl6B/ULS4SEB+YRSyqpXFacC9LAlRw721iYOeU8KhzgMxPpAy6XZMnS3dIM5P4R/Afz6s6Uh3+eKbacinAYD9dzYvJPg9qCqBFRmp+JiACVWBcVJ/ebfZx16am8JIcvcIhG9HtIyz/a2JOwLCAIn1Ut7Hbu2cGVt4A0KoZAdJbZHBOXCNnQevOu9iemxEVVURqfhnb3+t31fICbv/RGRS94n+xaDIWdxJEklDwR33TSC9xitWOLldS6DKnV3tWyaXr+D/vh8JhhFHi2B3YCoogY8d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4138.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(508600001)(9686003)(4326008)(6506007)(7696005)(26005)(52536014)(53546011)(33656002)(8676002)(5660300002)(86362001)(8936002)(7416002)(6916009)(2906002)(82960400001)(122000001)(71200400001)(66946007)(66556008)(38100700002)(38070700005)(54906003)(66446008)(186003)(64756008)(76116006)(316002)(55016003)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oC9sU87P0sj2+jcG7+qR32H1RiKdtXFtVQm9tvhF/5SLZUXAfGrQn2oc9BtD?=
 =?us-ascii?Q?3Iw0X/CR5hvg5/XzFXaY8ICTZzVMGRbNg37O2CqSl2JgFZJdy0FU2TRidFJd?=
 =?us-ascii?Q?4+RVX5t2acM1ETkaixoPNMnyYBU+Yug1OiWZwdt5lyjzEiUEubb8c6ByhCvm?=
 =?us-ascii?Q?3SSdCrVi3vIC30bGJZXLkUj2Yla0lToGUd5nuRZb5tIIQSReZ6DZb2Sk2pIp?=
 =?us-ascii?Q?yT1L3ZdPqoDDl8xP/vxRhfKFhKqky50zUkR3i7NbR72FHWBq9YYm2374Ger6?=
 =?us-ascii?Q?n5Xgy7nz0NlEBW6AEuyE/yacq8s6plJdTZE3bU7xcVI+q3gpaW6tXWTtHf40?=
 =?us-ascii?Q?zFfQGB6UI+7SL4Vj02AnEli70+5VlZic+xlDOR9TcjC3G0JX1umY+GFEB5Ij?=
 =?us-ascii?Q?/Mh9QJqRkYETwFELTaAFIVf6tEEM+ZmywRdiae0lYXoEiW9fp1Y2VU7b+ZeN?=
 =?us-ascii?Q?kV7QcFtBiU6PH8cuJ/lMQtvu2G3WCsvvVxWocOX7Fu81JjsETauTtn/enyoF?=
 =?us-ascii?Q?ZKfeUtBMwftEOR3ldGtvJ8DigN4EOqYgKPOm+HGUZqUYRkyAYc4xrKWgQor8?=
 =?us-ascii?Q?KC/GpNsjEJX5oBVn+4gnDJSTS9p2ZpS/f0b6JcKp3hZu1u6ckpr2EATfoDBh?=
 =?us-ascii?Q?PJ9f+zk4FmRLLKQyZGfBzM2Hg9pqNHj95e//P0herpge4mEiZeSOgInR17lu?=
 =?us-ascii?Q?gTeWnlSTmiYrMK1oN/BE4WSmwky4ezajsqJnzhHUms1yIUlKeWVPqn8TkpSU?=
 =?us-ascii?Q?hEfB2YhXf3vhWqrGcwkZ+fDfH/rMYdnWy0hKPobWdNn13izoFib1GXhVVm4V?=
 =?us-ascii?Q?JKTB9gy3bWeleVCS/lveWplSVDn0rlBhHh/QIhMqjqOX+gWrjViwWnRkiZZL?=
 =?us-ascii?Q?C7XwsYf4SO6h97BKvid4ExUAtfyeK0joY8ta78QFc4q9pDIB56Twwe6mvLLn?=
 =?us-ascii?Q?Q6b5AesS5FeM3Me4fTuXweDJCekLQLss/a9SW/b0yfjUeb3ErpdvsRe6sG4G?=
 =?us-ascii?Q?0EgMvk5a02aF+TV6P+WESAA3X3JmfOFoqkrkXWTNxK+l/HaoUbqfvHfsT4DN?=
 =?us-ascii?Q?coTjYE+pcW6ovVfyLh1mMhaNeDa74ZpJVA/kecjKxv/aD9nt5Y9GlbLkSELb?=
 =?us-ascii?Q?WP4t5hvQsdry15ys8pDavQFd0sOq1u8ldqb+bj9p4YcHk+TnwdI3v4WVONxt?=
 =?us-ascii?Q?JhVcZgvJ8HLWwoSIcq3U0U/ojYGRGYoWzYuBVHhdU07G/8Ct+t+DD7QlTJE4?=
 =?us-ascii?Q?tNq46vct9euA0Qw6DyqbwJRpQNe96h8IaNoS6fYM36lO2JnqWsygbuRCAz8q?=
 =?us-ascii?Q?CDS8z/IndVjCCsCWHfZUGQhnPxo/soB49XFTj/VRIGGPBmZfCiwF1Y114bbp?=
 =?us-ascii?Q?eilKeh38HLNc6I6kdS0dWBM4uSg8Sdn0BsWP8wiU8wfHQd0VBmLnT6ZPvVwO?=
 =?us-ascii?Q?BGpnPy5S6QVT880QZhBLsQfSE3X8dRWRKMKSlNN6MaY7MyEOre18vQ8tDMiJ?=
 =?us-ascii?Q?KFrURPxpFZoC2uI45a+nn7D45YKGXCG4FBfjDwGMdwIVY/8NLQekdaRhu8QH?=
 =?us-ascii?Q?KKgAWuXmhrhLAxdYEYJD1Jz+oEVA64vvWnRU4ztRd6vgHnvLz7KUBnFMo/YT?=
 =?us-ascii?Q?jtreOwaKlHHvfH/WMoxdxv+GqZ1bXoSAgkQjoYfXlZ686ty6LHotgbFCEobw?=
 =?us-ascii?Q?4p+7pNgRGdUKpc+YNjai3M/RuPfzgSNl9IN5y9/imu5j55WcyjPzP2U5BamT?=
 =?us-ascii?Q?OJIg39MxYg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4138.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df273a3-cfde-4a8b-3396-08da3ae2c983
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2022 04:31:34.3872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fSeL6RTt5/H+RYnqqcl7TTdJWqRVkEY+JRs2qjG3esO3CQyeBCwBYtuMYVVugTHPR43cnE5Y+/yzFJ4eMFmX9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4476
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Saturday, May 21, 2022 12:32 AM
> To: Xu, Yanfei <yanfei.xu@intel.com>
> Cc: pbonzini@redhat.com; vkuznets@redhat.com; wanpengli@tencent.com;
> jmattson@google.com; joro@8bytes.org; tglx@linutronix.de;
> mingo@redhat.com; bp@alien8.de; dave.hansen@linux.intel.com;
> x86@kernel.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org; Wang,
> Wei W <wei.w.wang@intel.com>; Liang, Kan <kan.liang@intel.com>
> Subject: Re: [PATCH] KVM: x86: Fix the intel_pt PMI handling wrongly cons=
idered
> from guest
>=20
> Please don't top-post.
Got it, just correctly configured my mailbox with prefix each line of origi=
nal message.

>=20
> On Fri, May 20, 2022, Xu, Yanfei wrote:
> > From: Sean Christopherson <seanjc@google.com> On Mon, May 16, 2022,
> > Yanfei Xu wrote:
> > > diff --git a/arch/x86/include/asm/kvm_host.h
> > > b/arch/x86/include/asm/kvm_host.h index 4ff36610af6a..308cf19f123d
> > > 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1582,8 +1582,14 @@ static inline int
> kvm_arch_flush_remote_tlb(struct kvm *kvm)
> > >  		return -ENOTSUPP;
> > >  }
> > >
> > > +enum kvm_intr_type {
> > > +	/* Values are arbitrary, but must be non-zero. */
> > > +	KVM_HANDLING_IRQ =3D 1,
> > > +	KVM_HANDLING_NMI,
> > > +};
> > > +
> > >  #define kvm_arch_pmi_in_guest(vcpu) \
> > > -	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
> > > +	((vcpu) && (vcpu)->arch.handling_intr_from_guest =3D=3D
> > > +KVM_HANDLING_NMI)
> >
> > My understanding is that this isn't correct as a general change, as
> > perf events can use regular IRQs in some cases.  See commit dd60d217062=
f4
> ("KVM:
> > x86: Fix perf timer mode IP reporting").
> >
> > I assume there's got to be a way to know which mode perf is using,
> > e.g. we should be able to make this look something like:
> >
> > 	((vcpu) && (vcpu)->arch.handling_intr_from_guest =3D=3D kvm_pmi_vector=
)
>=20
> > Hi Sean,
> > You are right, the change of kvm_arch_pmi_in_guest is incorrect, becaus=
e it
> should cover two cases of PMI.
> > For the PMI of intel pt, it certainly is the NMI PMI. So how about fixi=
ng it like
> below?
>=20
> Yep, that works.  I did enough spelunking to figure out how we can fix th=
e
> generic issue, but it's per-event and requires a decent amount of plumbin=
g in
> perf.

Agree, it's per-event for the generic issue...
>=20
> perf_guest_handle_intel_pt_intr() doesn't bother with perf_guest_state() =
since
> it's such a specialized event, so fixing this in vmx_handle_intel_pt_intr=
() would
> likely be the long-term solution even if/when the generic case is fixed.

Will send the v2.

Thanks,
Yanfei
