Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01E45A5B62
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 08:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiH3GCi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 02:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiH3GCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 02:02:36 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D53B14C0;
        Mon, 29 Aug 2022 23:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661839355; x=1693375355;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WHv91p4VBI96S9AKddtViDHFw+K4ByTuIXSX7rPQG/8=;
  b=c/6KJwk1QzTv9bQo47TF4GyDiBcznHDfb3LXtztM8boQu+udCuaFPXhZ
   5M3RMZDbvYI1RIgf6V29J8KXQlNfhdebv0u/nHLruY2+gUDcCTQoZcO4q
   xPl4zB2NSHg/l+sqSt3h7LYTMOROb9METV5zLol7IfpPidwrahh1z/7aW
   RNhHqtjbEKmeV6SjZXiCg8z+36r7s8xbt0FrDr51Y14udAHtVhPO9FsIV
   dzJNaNNlIP1YJDHZQdu4F1rgtaYHQCBseNPd/KuA1vjH7+WQBLMWRSSHV
   n2ysP8CpeOKSdgA+8x198BRf2E3GNTaq4r+t/MhJYXji5bw3cPMwKrPwJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="296368112"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="296368112"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 23:02:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="737618712"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 29 Aug 2022 23:02:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 23:02:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 29 Aug 2022 23:02:34 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 29 Aug 2022 23:02:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mS+3NkBJ/eNErtAPQFMsMmT5p/kkFOBiGBv7SySUiGbNLFHdYEj3jm7v64OY4qTxbCiz17x2ZN6oZz2SB0NPO5hA5CpJwzhJu3DPYFLEECCdWOqtQCG02cAvtXzayGEHqwqxo+2PF1N75bTSL6sZP3t/uEaF0aG927/IqEeGm2oZM5Qe0dIG5lXLjn/yJi3I3U559ofFdqRNYSALT8e2LmpT2iBhZtd0Djvm9qgnsJQXvaJEgoCn78IuScb3pB6t93w8VZ8sywABjmk4Ts6rxYsLBy+1hcCERLAbc09w6DnFXWc3pAQUV8hJbxXqA0YczZ3DOZzNlF7CkvrAXc4Wkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YMvytXqKuRJSH443rGqPnCSu7Ntbowg3mrcvBzGw6Zo=;
 b=NUyNDPwpk43bbACgc42qoP1OXxlRQe6us4HgzyNFuB79bew7+WPc2UlgYdlq8mhNxOjFIe2VG710ITIk+BMWw1TSmA7GIO97ZCfmXTQrXc8HElxoON6JdtQ3zHblngXVn3GOqME35B6A7jXQMgdftVBWQVztMbvd8IxWKs6zK78eSAsEfQGSpsYhJuWszuKpyU7a7y/hDkl+NQY7X7VxJrkC9/H8ZLpI3zz7pvxeugjteoqMnXfFGa/fpdnoPWa3GxHwlV1vBuEfNnnaIqBQg1t+klmcfMdASP32UFqjnYLr2cde99jAvaY8mdi+CIfQitSFSwQci5cJMMx9QYeFxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY5PR11MB6365.namprd11.prod.outlook.com (2603:10b6:930:3b::5)
 by BN6PR11MB1858.namprd11.prod.outlook.com (2603:10b6:404:100::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Tue, 30 Aug
 2022 06:02:32 +0000
Received: from CY5PR11MB6365.namprd11.prod.outlook.com
 ([fe80::4016:8552:5fb1:e59]) by CY5PR11MB6365.namprd11.prod.outlook.com
 ([fe80::4016:8552:5fb1:e59%8]) with mapi id 15.20.5566.015; Tue, 30 Aug 2022
 06:02:31 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "Namhyung Kim" <namhyung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Thread-Topic: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Thread-Index: AQHYuGCfKwYxaXR4306din/WULaC4K3Fff5wgACsNwCAAJww0A==
Date:   Tue, 30 Aug 2022 06:02:31 +0000
Message-ID: <CY5PR11MB6365E7E07AB03F3675543717DC799@CY5PR11MB6365.namprd11.prod.outlook.com>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
 <CY5PR11MB6365897E8E6D0B590A298FA0DC769@CY5PR11MB6365.namprd11.prod.outlook.com>
 <Ywz4diMZBB7DdITb@google.com>
In-Reply-To: <Ywz4diMZBB7DdITb@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a80ec91b-89fa-43af-7212-08da8a4d39f6
x-ms-traffictypediagnostic: BN6PR11MB1858:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hhy4df3tDFrvmiToKXuczlwc/kUNuiPrj1XDNww3upBoFsh/XrdLneXxnetlbPuMTcoDQHEw/as7OxIZQgIh/rxxVD21PKjHN4FtnQhZt57bSc/OllnKHO1vJ8KXCsu+vcuXLz7hOcBlhk0hfesXncB1hlAqX7urFz/18iXcd2/nrccUZ11yOoVTqPP8nDEaWrNkxJkh9HbFTXcmANJcRzEEu/PVivDlkEGOI9r4pTShE7T7dAjt3jV+0CN+W8XsAheWQ40yU/li7AhBGiXkwgBTPOeHA6/5T+QF2KxWHXJmRCRoHbfxe8isZ9cZLV0bFZ0HY3NTThqm8OMSKDOoA4L34zYO7tZy9Au3XhBed3TKMEWx/kV4K8Bcw8kRt7nyooNYr3XwtTWmM7NbvGnuHVWCBjmKDEksDp8076gbINRl2xLkTR/yn1JMYjjtGTFXnNMF/aCjBtDRYotDeDu0NVdr5dzh9SlhBoHGtEu99VbAqR5qxR4KTIXam6srpVtYrOLOSnOteodZj/pmj/Fx9dMA1UTjSqMWluGgqtB3q0UqxXcJBDW6YHe7JNfTgFXY3bcXEWwt9HIcmR3Tp5f9ZOFHV7FD5XElMOmU+i8rUrTKazrjMABcN4JislikRCOZFA50fkmN1HZfkBG3ZUBMqX8d8DOUVcBcHtMg5wIk7fWM7M2Yc65gil4rHYLZJBNR+h0zrlNh1BpGq6j75rEz1V6OlV0lZjrwpGVGRLaRUxL4XSPe9uXN84yX4/MFNVSHVlygsYypFiZ5IN0Yw2H+bk91ZpFMXp0kx4kW88mWm1s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6365.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(366004)(346002)(39860400002)(396003)(8936002)(4326008)(66476007)(76116006)(8676002)(6916009)(54906003)(64756008)(66446008)(316002)(66556008)(38100700002)(7416002)(2906002)(66946007)(5660300002)(52536014)(122000001)(26005)(33656002)(53546011)(86362001)(9686003)(82960400001)(38070700005)(7696005)(6506007)(966005)(71200400001)(41300700001)(478600001)(55016003)(83380400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?b1H9F0PZyU+05hCn8D7JLU2uQwspnBmmfp0YatuWHGV1+KusMXrU29WwXbeo?=
 =?us-ascii?Q?8OXaSdeL+91jeVlamNMawHogwFZIDphR9/CpPuUKYM1E7RQNnPvubQzfwTKy?=
 =?us-ascii?Q?3OVlXU3ljWJW47ZvagCW1cq41L9k7eY2EI1bptYV0KVU4WP5OAVvEqQTKwfH?=
 =?us-ascii?Q?vUrih7LGE10bM1Zb92dN1Vf5Z6n2BN0pB4q22OqUe6NJSDzhxtX483Ueb3Fe?=
 =?us-ascii?Q?wvR9Utb9qxSQ7sV+KQ1toIz5uh1VjfWr7Zy4ZIbWXz4TSV5pwCyUi6pjSkG5?=
 =?us-ascii?Q?nI+zvViWAVE2diX2F1WnCyr3eyw3ig5Oo1xT88xzbfmv9vN+LVv9Sxy3mmGW?=
 =?us-ascii?Q?179C+ngCSxFX9iJ3LqF9Juw8Y9tLKe1GcseFNMufZzUTurVgQF0H+JbdhdoP?=
 =?us-ascii?Q?2maBQNKckQp+bk+Yisp1aXxvuRWbl+9fCP7BeWafyPAt7jmWYQI0iAe2AQH9?=
 =?us-ascii?Q?c2vT05mYQGcOhfEGQ7V0emz1L1J3oMwzOG0A7u0Rb8o6wT3ZpYE+nQprXBsu?=
 =?us-ascii?Q?QRl/jJDp2Dt+t3sXxUQadGtEj+fyubXKQ0V3tWpxKUNEXtetOEuAixPl/qfo?=
 =?us-ascii?Q?oBguyAuXNO2Ks+R5nwmq++HkggL96wKRxXH6lw/2+Yh+YUTYPLUDbq5yO5Qe?=
 =?us-ascii?Q?5l9VTej0T1vw9JHeNpDWCi5T1GHNZDTpuXMrquEMN+nyXK3PuTgtOdDgxRx9?=
 =?us-ascii?Q?dQgucl/H3ZkGfsbIjveqOjOc5dVLySwPWkBrbw+kOv/ggMMNx13eKz+CE5SZ?=
 =?us-ascii?Q?krlXl5tFf4o9cGf8hJYu/429Zu7qt8knnm/LpG0fwoOj2SyveNFnoP0v6eAZ?=
 =?us-ascii?Q?Uyk3zq9mKTnArLEdANzR8IFqNSOy1otdJFHd3ehG0USnkYp99tOJa3fCnHyK?=
 =?us-ascii?Q?7pjUM3EvxDqNZ4TDO99boedXxLs4A1o3iRnId0GLR5pJ0jFrSiPh27wUZANw?=
 =?us-ascii?Q?1Pn1Vd5YUaPaSv35s1VBEkuh3CGk1pyh3Glt1g3V8+xHoquBnzF49t8LtVxF?=
 =?us-ascii?Q?WIGRHL5H0HKY/9LNgvb3xO0lvToJl4lRCVAHnSOQzSiG7A9A1raIPxnxN0BX?=
 =?us-ascii?Q?R0mbu6vrzabi8HgLz2naPmXTiyGuVVjSdncwrMQn7UeG3QZxBKXm0X20Qfdr?=
 =?us-ascii?Q?jIOWIi/LfBmgAsnJeFzrfQgw1bLyU5c8eE9gHXoHQU509pfBlZkj1lnAwQ8h?=
 =?us-ascii?Q?NXsBhcGeF4Eayw4XL2fVJ0TMYYTXmhOnLMYvquoN2jvTAslT+Vk/xKrbIl3r?=
 =?us-ascii?Q?OOlbKziiCYgxiTFHX1TJKbr1UWqg9y4E5HSYs2Aj8wIDcKAydF+vyRkY5mDI?=
 =?us-ascii?Q?zi1XqOD9ah31A2W2/BooDf2++YQAFnYuJGgpTdSDtCekkW9J5bANJm6Hp0ns?=
 =?us-ascii?Q?ALmC1S+gAgEqAgjG+V7an9Yhlvuo1osf8xSRgV1X7f2hOfH1M2MOnGxnvL1D?=
 =?us-ascii?Q?NUS457+EI2gYsm7MdwWL3G871Ir1cA1vjsZEPMfNm3A5mKRE+gvNPhdoEjXj?=
 =?us-ascii?Q?tOA9RDdn3+EL2vu20vVWB6CoeOPUnbksv3l/PKGrasHdMP6xVp+mr5BpoAma?=
 =?us-ascii?Q?B0M70vJ3p3cukSHpfCWH8g/jHlvwlxS939EwmN31?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6365.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a80ec91b-89fa-43af-7212-08da8a4d39f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 06:02:31.5586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uNh263C2XAOY1xvf22YP8bhkmss06FtyoMoyTS19g8SHn9Ovjg1nNLFyJDGpC6pxv4meJRfKznRg43gUAiLe0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1858
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday, August 30, 2022 1:34 AM, Sean Christopherson wrote:
> On Mon, Aug 29, 2022, Wang, Wei W wrote:
> > On Thursday, August 25, 2022 4:56 PM, Xiaoyao Li wrote:
> >  #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
> diff
> > --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index
> > d7f8331d6f7e..195debc1bff1 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1125,37 +1125,29 @@ static inline void pt_save_msr(struct pt_ctx
> > *ctx, u32 addr_range)
> >
> >  static void pt_guest_enter(struct vcpu_vmx *vmx)  {
> > -       if (vmx_pt_mode_is_system())
> > +       struct perf_event *event;
> > +
> > +       if (vmx_pt_mode_is_system() ||
> > +           !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN))
>=20
> I don't think the host should trace the guest in the host/guest mode just
> because the guest isn't tracing itself.  I.e. the host still needs to tur=
n off it's
> own tracing.

Right, need to fix this one.

> This is effectively what I suggested[*], the main difference being that m=
y
> version adds dedicated enter/exit helpers so that perf can skip save/rest=
ore of
> the other MSRs. =20

What "other MSRs" were you referring to?
(I suppose you meant perf_event_disable needs to save more MSRs)

> It's easy to extend if perf needs to hand back an event to
> complete the "exit.
>=20
> 	bool guest_trace_enabled =3D vmx->pt_desc.guest.ctl &
> RTIT_CTL_TRACEEN;
>=20
> 	vmx->pt_desc.host_event =3D intel_pt_guest_enter(guest_trace_enabled);
>=20
>=20
> and then on exit
>=20
> 	bool guest_trace_enabled =3D vmx->pt_desc.guest.ctl &
> RTIT_CTL_TRACEEN;
>=20
> 	intel_pt_guest_exit(vmx->pt_desc.host_event, guest_trace_enabled);
>=20
> [*] https://lore.kernel.org/all/YwecducnM%2FU6tqJT@google.com

Yes, this can function. But I feel it a bit violates the general rule
that I got from previous experiences:
KVM should be a user of the perf subsystem, instead of implementing a secon=
dary
driver beyond perf's management.
Being a user of perf means everything possible should go through "perf even=
t",
which is the interface that perf exposes to users.
