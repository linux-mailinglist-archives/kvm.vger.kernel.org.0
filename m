Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C44642A51
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 15:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbiLEOYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 09:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbiLEOXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 09:23:51 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123C5E2D;
        Mon,  5 Dec 2022 06:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670250230; x=1701786230;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8Z406gBvc7sZkz8gujIO4/ZBX3AuF5mBNjUh8jKXsxA=;
  b=O/BhD/DdVN4vOoRgRQvLiKRzH7UKec5yC80w09htQYuAlP7+4JPmPuBI
   CBvVQo0TdVpXaUxPojdr/ZoHMwHCCOiyrs/1VGmf260Ant6Zq30CetHaQ
   1IcPdywV399gHURWAVSvQIr/YUpvD6tWL52n0FHI3/5ug6Q1KFY2t23Om
   f+qky+3Yt4hHZU+LIU64/iUF7TO4NEUGFD8VYOjQ3RMJlkXihC2gYrdgT
   twfBQPZHov33LCR/v83WjgGtzOxezx5r6C8rA62Zq2K+acDIfxIp3iZ8J
   ZGEe0vcFHOEy/9pWSTzqQt/OeC2BapM1a7Mnkn1XR6SIvqTkbsRVPGyK6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="317502434"
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="317502434"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 06:23:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="645831281"
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="645831281"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 05 Dec 2022 06:23:41 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 5 Dec 2022 06:23:41 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 5 Dec 2022 06:23:41 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 5 Dec 2022 06:23:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEVspl6sIkuAT0+RXSkGSKzQhbUs3auFD/baWPrKkbkTSgsVCVOzH3L06cV6suRxS9YilPW5f5f3NODWiyqrLbrxJG53KGZhS1oFvicCcNA4330PQQHWFBOuZmd7d/F1ev4G9agqiNy64c+YrCJPgbjtyFddOV6WU017TApCrj9dKuteBD22TI1/NCb+DEbkgGgoJEhkQDX3FI4jI2Bh7/Gst1C9J5P8iXvVwd6FYeeMlXcH8005fTxz8yhcdT+NxTXx45nqsxJKrWKDA1tiC/G05KP79ejp5oypD76wUmYuZ4OvRUVGfzoEqw8CEFAg3z3tHqgPpNlzN7axuCRgOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yBuiaPlYgYXY2aeKy7IJCxvxwLSzTCzkfr/FwCFRduw=;
 b=AKJ8s1PtHDDFzXRh8v6T7Z6x/rC2tkLExH7oqISrN582W0RSLiZeaFb22ZNXMK5LTrEcC7Z2Ys6ttu2FNsDjl7I3DVmZuBeHCxm9I+FrDYQZsEZrBc63aKNbr4ZWtnonPdD5yNKT/Zns0HZGliUj+MeVtTMXgIkzvGutHWKAX5RsCrEvOSlebqWs8hPu57TX32nX1zpemaI+V5BE96IKGsF2ACaXGbEgSqcYTYIwnZS4G7UPLRXZaM7F1BRbVKE0zwxcwO29SuAv+j6OqJNTtbA8f6obR1/3O3PI4dxc13CZKqLwYbbkhk37hh3Ceh9D2vmu1b9T0srjVELjqz/3tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 PH0PR11MB5904.namprd11.prod.outlook.com (2603:10b6:510:14e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Mon, 5 Dec
 2022 14:23:36 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::964f:ee6c:6541:ff37]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::964f:ee6c:6541:ff37%8]) with mapi id 15.20.5880.010; Mon, 5 Dec 2022
 14:23:35 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: RE: [PATCH v10 052/108] KVM: x86/tdp_mmu: Ignore unsupported mmu
 operation on private GFNs
Thread-Topic: [PATCH v10 052/108] KVM: x86/tdp_mmu: Ignore unsupported mmu
 operation on private GFNs
Thread-Index: AQHY7CiJasKThqRaDEOPq0Yx+uNQTK5exgOw
Date:   Mon, 5 Dec 2022 14:23:35 +0000
Message-ID: <DS0PR11MB6373E6562F6F0CCC92CF8A22DC189@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <32e2f5f567e1af3858e2896d705b66f90a908ff0.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <32e2f5f567e1af3858e2896d705b66f90a908ff0.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|PH0PR11MB5904:EE_
x-ms-office365-filtering-correlation-id: 42bae555-0074-485d-8597-08dad6cc4b70
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GwwNfvYbXvJmSqMqsz+JIpDC7x3kVol6HskbEF3sq+7DopzCJgnY2AZ3o+f4lr1opV4g4FRvCHpYM0aYFhsaXyBImynI7vXKjfGOnRV+58qxXOt/Mb57RgWwuD1NgYxC/ytcNAnu0rRJUsAouORcHx6UFt25D+oa6Xzvt5sM+AhEbCQIdqrCR4CaqWNBSXX4pxbFCo3DEDEXvbmKrrKetxy5FbRyxwRt7PMy8L3RFnFRvobXdjwPQTfduAeWMHaLZXLOB5hmYoJuk2RSv4RI6pl3nxL9suK6sAnzSzvUOLDaQmdm+kl7ELxH6mqTfKCpQjvfUZy+GhfEJsIag7dzrHp3/yjnpck4wYt4LAEjnn0k/VZsclBN6Aiy2O8YXdjt/6CFHbBqRp7iJuoe20ZJ6cKhIQidVt8SWLY6jH+A1c5VQx+9f/dgVStLErKKQAScr6XW19UTAhsfS387ZC3mOD96/gfO018rFVl6OSrLJnDrHcy89iHwgFeib6FVyg/qPwA16GsuKWwQjf5WG7xy59zk7M36uRGjng6dO0ATyTB7JzJ1GY9yYYGcENzySpYffawy9JkGaba2fZTK3HaM+hXBAtYNPr7VpyhLOz9ruALsqaC2z0VmOVndB8vlsZ7q76JL+9ETXiA8Rjg3j0DOSPy6ms+8RA+53MdQ351dLpH/Dhd+bOeAgXg+X6186BpzaB/3Qpo6910KxEcZFRwaQQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199015)(71200400001)(316002)(83380400001)(186003)(26005)(54906003)(9686003)(53546011)(110136005)(6506007)(7696005)(86362001)(2906002)(55016003)(33656002)(66556008)(122000001)(8676002)(66476007)(64756008)(38100700002)(4326008)(66946007)(76116006)(66446008)(82960400001)(478600001)(38070700005)(52536014)(5660300002)(8936002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o8rvTcC2SA8ERJTUlGs7/WdWcLJ33zqPmogYE+ONaa1jgVYGtQNo9azxrlV3?=
 =?us-ascii?Q?9qXbMCJdEVA4XlvKQ9Nz8IdxUzUMuMcgbe6Oy05laaAzxTSZCGfy+CtvcgU6?=
 =?us-ascii?Q?gEi5n8Efn6it/V1X6Vss6Lkxp/0GYxgx0/kukUmA1y17fDdbdjaak991140G?=
 =?us-ascii?Q?MN5NerIrdYzataCFQZVSRJgMPqs0L4YlIr1Szs/od4Fa1VmcBJnkik/T76sH?=
 =?us-ascii?Q?J0VB35aJf4XNxkg/n6qVOMmuubXwj4UOwe7LK1OYPeNphq5XwdfnT/SjTtV7?=
 =?us-ascii?Q?5O7VqQCm4KT+53q+XrBqnmi4zS5k6tOR+PRysqRCHUvrDIexxhdnS7xII5lc?=
 =?us-ascii?Q?hG8iu5D5ccRV+sZ0p/l3MDPdK+RUhZVpKhO5dRUvuKql28EnP7APMOYywgXH?=
 =?us-ascii?Q?zdcvjP0mlNZezvjjur4eHd55lcG/I/fgotTs2tf39URja2vbRj1yFCgb13Ry?=
 =?us-ascii?Q?JkyPi/GKGhtkNL/XPiKmeynM6/TSTtBgRjHIGuhrZbskmIAyJKSe0oFXQvt5?=
 =?us-ascii?Q?TtkzCK+DHMJ5hA7VSjgpBb7c91A/2903MD42RXF+QdIHbyA2Lv5aVMv7KAma?=
 =?us-ascii?Q?S8uOlOsMxq7tS0l7EPbJ9PyjcfuOB1t8cIOMmgJ60iyrLL7VALej9kyhb45F?=
 =?us-ascii?Q?ovnBwoVhwHBQC9kCFXIzCwKu3jVHsrQwU+8TtI7FJHjNLhFUKtLcZ6YcKF88?=
 =?us-ascii?Q?5TRLChJdeCcs6DhUgGEKxifW23QNlgk6DdBESTrW84O7cLPizMSwiUTxtk3G?=
 =?us-ascii?Q?9ZlUTL3K912WucbZ5Upe6OUaUIWaXzMouUNJHdFmoh2mWep8yWV0ou2zJ87X?=
 =?us-ascii?Q?HLHqNHk9AXaNAoRJG6ElPWHQ0knowD5IxhBOZ+/hLtn6iXERNCMIAUIA9I1J?=
 =?us-ascii?Q?I1j1m9Ucp1ajj44qfZg/HZjJ6uptznL8bj/1ulXDqimRWwPXfEe0ywCRdhIC?=
 =?us-ascii?Q?Mxcd6GUdpUAMKj91OvcmgeyVo07mP/wwlRBIYDK0lhCnbyYwWYeLtQVqiq9+?=
 =?us-ascii?Q?CceT8VFiktFMUqRMDuBWKCRh3NSuVH/xRiLG3RZ9U9E1KIXf0uLyiUAyXl/C?=
 =?us-ascii?Q?iGbyVJ0nxk0akJJbbeOBBKfrEVQdhNixDtBZapThRUjXTnUblnizkQjtM+tk?=
 =?us-ascii?Q?Qkc1USxT4Zqi8WTnhtT0ZtMUxX9uDLcg/v6Z+ZRwaxpTJYIoT6lcRrwOol1O?=
 =?us-ascii?Q?Br3qKEyZ8d8MWdKKCl9451OO+2LPv3El4yuOT6WbkPO7b8NjDxvW6Vz/S5wP?=
 =?us-ascii?Q?GaEGwQCpt8uJg8y/iceIq1hLVb9cl/qMUJ+LmGlp3fgui1lzExac7rODl8H8?=
 =?us-ascii?Q?Kb1TyI/zu7ttYvGdqUKM8fkM0pzQkz80KQxj2hhWeZ5A4TMJ/rX7rbARf4xe?=
 =?us-ascii?Q?+HVfoxMExIGAWZNnzO0s4PVBdeZlq9KzVi70Oc7SzST4OBURCxIqsfkaxByz?=
 =?us-ascii?Q?iPHo/7mXgn36I219wc8qS1BHBFID/XXWHFapom08KHf3xravdU60y9dhJrHV?=
 =?us-ascii?Q?zRoFKPyR+psZ5woMwH0ZhPNq8IKlZmph3d8GM0C8HxZF7/JtoLJtK5eSisoP?=
 =?us-ascii?Q?tEiB+ADKgzIA0z9TLxKjrVz05KpOq0YZ2Pk2/OLx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42bae555-0074-485d-8597-08dad6cc4b70
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2022 14:23:35.3371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: koUY+/asPDSWMjj888zMdT4ePOzadVS7ldlv+ep5oToaWnLJbv5XCJiANOmB7jIodubntonaPCRnMIGKHt68lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5904
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

On Sunday, October 30, 2022 2:23 PM, Yamahata, Isaku wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>=20
> Some KVM MMU operations (dirty page logging, page migration, aging page)
> aren't supported for private GFNs (yet) with the first generation of TDX.
> Silently return on unsupported TDX KVM MMU operations.
>=20
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     |  3 ++
>  arch/x86/kvm/mmu/tdp_mmu.c | 73
> +++++++++++++++++++++++++++++++++++---
>  arch/x86/kvm/x86.c         |  3 ++
>  3 files changed, 74 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c index
> 02e7b5cf3231..efc3b3f2dd12 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6588,6 +6588,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct
> kvm *kvm,
>  	for_each_rmap_spte(rmap_head, &iter, sptep) {
>  		sp =3D sptep_to_sp(sptep);
>=20
> +		/* Private page dirty logging is not supported yet. */
> +		KVM_BUG_ON(is_private_sptep(sptep), kvm);
> +
>  		/*
>  		 * We cannot do huge page mapping for indirect shadow pages,
>  		 * which are found on the last rmap (level =3D 1) when not using diff =
--git
> a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c index
> 0e053b96444a..4b207ce83ffe 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1469,7 +1469,8 @@ typedef bool (*tdp_handler_t)(struct kvm *kvm,
> struct tdp_iter *iter,
>=20
>  static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
>  						   struct kvm_gfn_range *range,
> -						   tdp_handler_t handler)
> +						   tdp_handler_t handler,
> +						   bool only_shared)
>  {
>  	struct kvm_mmu_page *root;
>  	struct tdp_iter iter;
> @@ -1480,9 +1481,23 @@ static __always_inline bool
> kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
>  	 * into this helper allow blocking; it'd be dead, wasteful code.
>  	 */
>  	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
> +		gfn_t start;
> +		gfn_t end;
> +
> +		if (only_shared && is_private_sp(root))
> +			continue;
> +
>  		rcu_read_lock();
>=20
> -		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
> +		/*
> +		 * For TDX shared mapping, set GFN shared bit to the range,
> +		 * so the handler() doesn't need to set it, to avoid duplicated
> +		 * code in multiple handler()s.
> +		 */
> +		start =3D kvm_gfn_for_root(kvm, root, range->start);
> +		end =3D kvm_gfn_for_root(kvm, root, range->end);
> +
> +		tdp_root_for_each_leaf_pte(iter, root, start, end)
>  			ret |=3D handler(kvm, &iter, range);
>=20
>  		rcu_read_unlock();
> @@ -1526,7 +1541,12 @@ static bool age_gfn_range(struct kvm *kvm, struct
> tdp_iter *iter,
>=20
>  bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range
> *range)  {
> -	return kvm_tdp_mmu_handle_gfn(kvm, range, age_gfn_range);
> +	/*
> +	 * First TDX generation doesn't support clearing A bit for private
> +	 * mapping, since there's no secure EPT API to support it.  However
> +	 * it's a legitimate request for TDX guest.
> +	 */
> +	return kvm_tdp_mmu_handle_gfn(kvm, range, age_gfn_range, true);
>  }
>=20
>  static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter, @@ -153=
7,7
> +1557,8 @@ static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *ite=
r,
>=20
>  bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range
> *range)  {
> -	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn);
> +	/* The first TDX generation doesn't support A bit. */
> +	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn, true);
>  }
>=20
>  static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter, @@ -158=
2,8
> +1603,11 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct
> kvm_gfn_range *range)
>  	 * No need to handle the remote TLB flush under RCU protection, the
>  	 * target SPTE _must_ be a leaf SPTE, i.e. cannot result in freeing a
>  	 * shadow page.  See the WARN on pfn_changed in
> __handle_changed_spte().
> +	 *
> +	 * .change_pte() callback should not happen for private page, because
> +	 * for now TDX private pages are pinned during VM's life time.
>  	 */
> -	return kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
> +	return kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn, true);
>  }
>=20
>  /*
> @@ -1637,6 +1661,14 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
>=20
>  	lockdep_assert_held_read(&kvm->mmu_lock);
>=20
> +	/*
> +	 * Because first TDX generation doesn't support write protecting privat=
e
> +	 * mappings and kvm_arch_dirty_log_supported(kvm) =3D false, it's a bug
> +	 * to reach here for guest TD.
> +	 */
> +	if (WARN_ON_ONCE(!kvm_arch_dirty_log_supported(kvm)))
> +		return false;
> +
>  	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
>  		spte_set |=3D wrprot_gfn_range(kvm, root, slot->base_gfn,
>  			     slot->base_gfn + slot->npages, min_level); @@ -1902,6
> +1934,14 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
>=20
>  	lockdep_assert_held_read(&kvm->mmu_lock);
>=20
> +	/*
> +	 * First TDX generation doesn't support clearing dirty bit,
> +	 * since there's no secure EPT API to support it.  It is a
> +	 * bug to reach here for TDX guest.
> +	 */
> +	if (WARN_ON_ONCE(!kvm_arch_dirty_log_supported(kvm)))
> +		return false;
> +

It might not be a good choice to intercept everywhere in kvm_mmu just as td=
x
doesn't support it. I'm thinking maybe we could do the check in tdx.c, whic=
h is
much simpler. For example:

@@ -2592,6 +2605,12 @@ static void tdx_handle_changed_private_spte(struct k=
vm *kvm,
        lockdep_assert_held(&kvm->mmu_lock);

        if (change->new.is_present) {
+               /* Only flags change. This isn't supported currently. */
+               KVM_BUG_ON(change->old.is_present, kvm);

Then we can have kvm_arch_dirty_log_supported completely removed.
