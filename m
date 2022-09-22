Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24345E660C
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 16:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbiIVOnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 10:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiIVOnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 10:43:05 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480ED12746;
        Thu, 22 Sep 2022 07:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663857784; x=1695393784;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YKsvm0LRelM0isX75PAVux3PKFxa70t/lWZV+/kdnCY=;
  b=lqhWwgDaJv0tvg0ogTNQq9D9rF8KihHB0FsaLQzGMUXjyxVfUS5k7pV7
   bCRRY623VAa9mxRRfF5dDTqxvPEz/OFBX4iScc2u/InB13LQB2j3us9ar
   L8CjHsw/T8sJ++AzFz15/o+LUwtaw2MLZnvtQvYwVlXD0DeIZreBvdq9x
   kqSCgWozjEdPs6tQ30lcqOIx7vK+TlR11zwpPJ7EgoI3ptdR7eYd9r//x
   0/CjcBXak5hFxkwDEzAB1ynJ9aIu4Yp/e2TWjnKyhNNO2R5JS5MJpX4BA
   Gc3QIsB0re4FsHg54wc9N7BebJGhLSsp/JIjzy+Xe6w5Be9DWf1LMOmuQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="301162022"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="301162022"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 07:43:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="864879200"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 22 Sep 2022 07:43:03 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 07:43:03 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 07:43:02 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 22 Sep 2022 07:43:02 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 22 Sep 2022 07:43:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=beV1/oZLgyEXu9qU+oXo6zdfY6LhTpywXIqPtoMbCzaQbRrpXu7Cu906hRpIMsRLv/Vk+xZ+caAr3+7bXTsIFX+idl4CXt4shQK1XATrdmFlRGLU0k6cOC0E9CpHaCmrp0tWsBhMoX7OyMHs3SjZPQpiwCk7+27M4PHmcL44VsinFhgVgO7l99D8rgZkPm+5NQpnHjM2bNVh6LlcwjqOPpUxRlrw74JTvNy3OfihuhS1W4Vco6DuzDBt6GC9Vqq3rEyzsA/Lv+qUZ83KwKxsBztcwN+q3Gu1MmkG43o5uqWuvM+I+W73esmyiDZi6sydEFBSz1R12oAsIOi7bxbg1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ouKe7Mlkpkb1J1l2pq94MjT+blxs6lL2T96ARp+1SU=;
 b=fvKr1kEFvWKkY3EKnwsHCLPbH1pM+BJpSSpRqzEfQU4dGhaEZqP2eYSH1ghQslKsflOIPZ9ekJ2yF0Vkb3eBtLotZENrNaNhw0tU/9TuZj22OGetSnX9nudD6z+otWnve96sBLjbsGDiql0HIdWPe96MWvbagfmxauRssMsLc22tvHDym1SUvLpKZnCfauFZIKIFL2PP1/HibST0nhxZSqeOiz+z5URf56v0IsViS+N+zyo28yr7x77jJs0DidThRDxWF3BVlNDlQZBsqAHb7PT2FpMBAxh8Fm4tWO6CRTWDgKU4lf6FGs1NH/ASOiPwZMTTFD/x/wNyvLrTTEaIwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 CO6PR11MB5588.namprd11.prod.outlook.com (2603:10b6:303:13c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 14:42:55 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::817a:fd68:f270:1ea0]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::817a:fd68:f270:1ea0%7]) with mapi id 15.20.5654.016; Thu, 22 Sep 2022
 14:42:54 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     "Liang, Kan" <kan.liang@linux.intel.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "Alexander Shishkin" <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH v2 2/3] perf/x86/intel/pt: Introduce and export
 pt_get_curr_event()
Thread-Topic: [RFC PATCH v2 2/3] perf/x86/intel/pt: Introduce and export
 pt_get_curr_event()
Thread-Index: AQHYzdmZiDfxfKVenUORyjhoUz2tZ63rY3WAgAAA7VCAABAZgIAAAWLQgAAITwCAAAOJIA==
Date:   Thu, 22 Sep 2022 14:42:54 +0000
Message-ID: <DS0PR11MB63730A85E00683AB7F6F3E26DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20220921164521.2858932-1-xiaoyao.li@intel.com>
 <20220921164521.2858932-3-xiaoyao.li@intel.com>
 <175b518c-d202-644e-a3a7-67e877852548@linux.intel.com>
 <DS0PR11MB6373C84139621DC447D3F466DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Yyxke/IO+AP4EWwT@hirez.programming.kicks-ass.net>
 <DS0PR11MB637346E9F224C5330CDEF3BFDC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
 <YyxsnAFYMLn2U9BT@hirez.programming.kicks-ass.net>
In-Reply-To: <YyxsnAFYMLn2U9BT@hirez.programming.kicks-ass.net>
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
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|CO6PR11MB5588:EE_
x-ms-office365-filtering-correlation-id: 3eaecb68-13c4-493d-b525-08da9ca8bba3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pMW18vyWt5TppvONtxwqGK6LMgEE6PefeN1lmV78AnnYfHVPuCQHCjltpqvycSLUDpMmjB8y4r0isEeW6X5TbBteybdMEcdB1W6acDfuLnY7JYKescDq1zxiG0W+aKfA4jgFGfEFYmuPPdi7+RWLgzGIsRQs4UUYv0HWcfWk8ILjvbLC7pZ4McxTZjqRRuEVhNCFGdarjrVbaiY2vSGs5cHuXzcXNpsHbu5azsAl4V8A9seKaHCDGjL/MlUBXGVCswm6MDUaQhnech/anu/pe5joMs0rvG6oJDOdYsTt+sejwhkvzHrjuUSi56K4F19IJLsblW0ru25uiSL75pJujYpzeSnqa0ih+pJYJ4PSCIKIckRzQOAC+OiMQ1xRt3pgyN0LjdGRNYqydBKA7DCBIOGJfS2nIUPzXjFt9gLudqm4T6vFnCJzGTS1AwTZquarNrmtkAeY6hzFPkaEn5+YQQAW+BrXpWj48vFNrt1g9lrvNSIl4BsCgpYCLOyzwGoD/epsY8xK4eYdYUn7pLS5e7DOivXDOxYvLHCsmL/TxnJa1oYXR4bGWy9hNupJLIinoXJIb+a4BFfYY0azcAlf2qdhZVA4yfu8fnQRC+/X0G69tbu47Nlhu8fYGhbR97ZZz1b8hOnbpur/u6NgHq7AZggyJzueza2NViewbckULvoute+ncadSL+0Qkuw/GwtAYFAHdEMrGZl08OPMXfzEJ3e/g3Mi40Q6jWfp6Nz28vJclhXawrOeDknCSV2ealCzqU360ihqrDGKIjs8t3e7ew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199015)(53546011)(52536014)(6506007)(7696005)(6916009)(54906003)(9686003)(8936002)(66476007)(64756008)(2906002)(76116006)(316002)(66446008)(4326008)(26005)(8676002)(66946007)(66556008)(478600001)(122000001)(71200400001)(82960400001)(86362001)(38070700005)(55016003)(33656002)(38100700002)(41300700001)(186003)(5660300002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YAXrStvP2qdkPn+wH6qV30t0BqQ7HRxmQxfxjxUCPPn7b9Ltv9UnNhR1yU5r?=
 =?us-ascii?Q?x7KXVggescfD4Ah4r1GOg5KjfOJzkk+VMINgzxmB3mn7B3d/XNZ1qhbXoMUb?=
 =?us-ascii?Q?1iW6V+moQ4R/bTIRlMvvZaq9A6muCe3E/exmo7K716XBSSUNiMDSjv0w+0iC?=
 =?us-ascii?Q?yyqIXNXJ8qp4M7ENk61TMsNpLDM9Tyqzgo+Rw61Rrx8YLM9jMpOx1MfolCAv?=
 =?us-ascii?Q?ETzfRhcIufv0alaoQwR3S6l1Z1/dq8r4NqdBIiwdSegibf7G9EIu5dHzQBUp?=
 =?us-ascii?Q?YtGPAebDTq02xj17ZkyqZiSD2OxY3U0vZIt+ATTOjq+TWTWtFVApF/qUVFEq?=
 =?us-ascii?Q?vdsaErFaYo+zdewiBsgnivsAYx55zEJRUpmaAjk9MVhk/b+8fGsHjnRGjuvE?=
 =?us-ascii?Q?tUgECX1F3x5aALKp1Wb8s6tUCOfBoQCCrfVxK5aeMIcWBfwJoijuuaWjihQo?=
 =?us-ascii?Q?Jc8APGU7ztR57b93HLsxdjeoG2nq5Hi2HyDHZETfq3979mdXifzwl2Y3jYbV?=
 =?us-ascii?Q?+OZM1kbJMTbvsFfqjbmPF6TjkNWcf4Sf/S/vPU2O6gDUra9hxL6SY24a1rc5?=
 =?us-ascii?Q?kiL+8SYhLb8XyKDzhO7mSlQ+H2bssV0OO9sYICN/t/3peBRL1kXoN3KTIV1U?=
 =?us-ascii?Q?KbzujQ5LnrqYPW6+NPoaS0rgsjqw2Wlx0JigL5XCG2v3QN4U3XakJyXYlWuR?=
 =?us-ascii?Q?njSV2yS9VfLQzYKtLqhnRdFouiLo96sMprMiLuqOMnJNUmuGOgKP2Y50Ivdv?=
 =?us-ascii?Q?cfFEEtFshlKaiNYvXM72ekt0bv/NblIpUYEfsAzwQ55556gHJpJpYTXV83r+?=
 =?us-ascii?Q?jRsoG+OC17hfOBymOwRUqIfNnDqRCKm9C0/gPzyPCf7cBu6lmHKCecOz/wre?=
 =?us-ascii?Q?zAtXuqn17YI/C+zOGnFKHK3eL3N/HGyWyFW6mejj8LJi4QB6IQTWMBqV0kKK?=
 =?us-ascii?Q?j2pizOBYS7n4V9kAVHuvaAiGKSNS+Zcb6q2BZh2sbiMZeYzCfI29k4nbKoVt?=
 =?us-ascii?Q?UnIvEMxCo3dANjKSrb5xXey1W6f+hyMV6pWSgkgOT7UzUtQYj/ghwuexO4ow?=
 =?us-ascii?Q?kIVM5m7xCv28fBzb6ApHPeIxWYxD9QXLDLlMhgVW5eY5WZbNh4SaBOhaf8BE?=
 =?us-ascii?Q?v64C4Crzo9NzE6q8UxXYifzOYZYY5FKw120IrkUkJ98EjAgjSzH6oQOguj01?=
 =?us-ascii?Q?tYgQJ7ZfSatOysAPoV/XK0q51x34nRU3tpz0jHF3YCpIuLhe6FP3TjlfOA7F?=
 =?us-ascii?Q?Y/CAUPU9kZAwzM/yaa6UkYSo8eNoQldzfMw1q1oIWdZ4E9Ci5Xpm1FXU3FzL?=
 =?us-ascii?Q?1bJkwZ5o1auz+lJLsW/NDFRo6sDHgoxObzGFbra/h1dsEBD4CZVuUTRDk7+7?=
 =?us-ascii?Q?BcV7c/erWGjMW+kFhYYoHpf+fMgGF6IQdj6F1MYc2UyP66n7XwZUngn0tdIx?=
 =?us-ascii?Q?b22b5PitR0VVBXr85suvgzOD1ZDzj7LiIcBqjYSN+v217eEx2nvXrgL2YEpC?=
 =?us-ascii?Q?MWDSmEjbD71QTfGl2cmwL+wZYcyAOVy9lcg+t81MCjrgHsaTPcG5NRFmSsoD?=
 =?us-ascii?Q?kBuPQ2oj5xHzsHiJ8Zx9RK73ijV/VBG8dPWufZk+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eaecb68-13c4-493d-b525-08da9ca8bba3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 14:42:54.2228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JAEJhFdmIEJErC5NpvLn3djizmU0Dm3q9zrHtRctQggV85HQO9qRaJRyMoOqj7fI2pcOyQ08fDUFixx5BtJ6ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5588
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, September 22, 2022 10:10 PM, Peter Zijlstra wrote:
> On Thu, Sep 22, 2022 at 01:59:53PM +0000, Wang, Wei W wrote:
> > On Thursday, September 22, 2022 9:35 PM, Peter Zijlstra
> > > On Thu, Sep 22, 2022 at 12:58:49PM +0000, Wang, Wei W wrote:
> > >
> > > > Add a function to expose the current running PT event to users.
> > > > One usage is in KVM, it needs to get and disable the running host
> > > > PT event before VMEnter to the guest and resumes the event after
> VMexit to host.
> > >
> > > You cannot just kill a host event like that. If there is a host
> > > event, the guest looses out.
> >
> > OK. The intention was to pause the event (that only profiles host
> > info) when switching to guest, and resume when switching back to host.
>=20
> If the even doesn't profile guest context, then yes. If it does profile g=
uest
> context, you can't.

Seems better to add this one:

+int perf_event_disable_local_exclude_guest(struct perf_event *event)
+{
+       struct perf_event_attr *attr =3D &event->attr;
+
+       if (!attr->exclude_guest)
+               return -EPERM;
+
+       event_function_local(event, __perf_event_disable, NULL);
+
+       return 0;
+}
+EXPORT_SYMBOL_GPL(perf_event_disable_local_exclude_guest);

