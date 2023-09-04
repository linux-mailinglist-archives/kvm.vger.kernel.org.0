Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37A27914F6
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344375AbjIDJqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjIDJqg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:46:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FD0A0;
        Mon,  4 Sep 2023 02:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693820793; x=1725356793;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=0JkvKhFTRHSuVwjVx2Q6K+0yYFELLGttHpE6EzyecGQ=;
  b=VFrmz5xOVayQnsCZ6Gbqk4/a6lLgb/w7HglmGlJ5PadKDxbXw35Q3Vvc
   QPJ7zqPqiiADd15wk/9si8Nh/SSq/0aICvZ+xr8iyRi4FCxHGONIxvqfP
   dYozfTPodj36hs9o8sTZD+SNz5Bi+knouWVdH4CkENwx6l6XW/L6SCkhE
   YNIceFUMK0Ylog+Kz6GfzdDNWI+5Yw7xOTKGsdwkLQPt0Iq6IpYNQVXPO
   Aa4y2278Wp0MTnCOtJeHwVIuWMT8TVBOKYhm+lSRN4BzWvuP+7Iz5PWYr
   HI9O/Pgy/P5PoyVOaOCFf/OkvERWU5UKw2rzAKRNGfll+tJsLM44bqKYT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="356879460"
X-IronPort-AV: E=Sophos;i="6.02,226,1688454000"; 
   d="scan'208";a="356879460"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 02:46:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="740697431"
X-IronPort-AV: E=Sophos;i="6.02,226,1688454000"; 
   d="scan'208";a="740697431"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2023 02:46:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 4 Sep 2023 02:46:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 4 Sep 2023 02:46:19 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 4 Sep 2023 02:46:19 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 4 Sep 2023 02:46:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJAzB/Uuhm2HGW2MpWA60d5OX5hgr8n8j27XDiwEEWf7v2DXvBYdDCEyRjcWLTJnRu4rUYW3k8Bg/eoLxz6TWYL0jvz6jUpoXUmBlhh5+1/v2wra9g1BifiSAvnzkoSx13yO8X8lrTy7UB+S9lKtI9mNv1wMfVFY91gYtbVPTxoxSRDX/6dnm0ile0V6LV5YwE60m1uGBl6SEupCn+b+13DBbAARU1PtR+uVrSNwMxnjc6lx1iibm9vq91CqGoTeBPeBV9mHlM1zMIvEvZFv9fPskAJZYbSgPJTQSvGkA3OLlm3VdhhqeivnwWzkLXH0dyJj8axbqc9BgtothH9U6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sa5odbfb+iIHh7YJ6JI+7BCpIN6vCegvZFd3wnZxrRw=;
 b=mCJtBxYIe6UfSjHNUwAlpAydxIpmwT0P8DpCXrdQrBE3ghC/PsQ75IyiiwrfLjhfZ0keXynUMMUH8TL6rNRIoq2+y2K9+RMOu+RmNwhog8RiTknna70Xgr+nf8tw920d4ZBv/24scDzxfDsRyWvluBu0lYMtNAc0tPNAe1LYC0HwvPs2GqurDoZaIA38HfRNWnN1kQmtl/ELxQxOrD4QJnFHuLUs1EEy3LgGjxseWZYNyU6qwK0vmBY5MSZmSenGvDoiZxJ9AF4DBJIjUEpMzzyGiyszjP6X5l1T1wSgoX9OHZAu7cSjariYtYCFr0uyudG1FwmS6t7yddADIRvQ3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ2PR11MB7715.namprd11.prod.outlook.com (2603:10b6:a03:4f4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.30; Mon, 4 Sep
 2023 09:46:17 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602%6]) with mapi id 15.20.6745.030; Mon, 4 Sep 2023
 09:46:17 +0000
Date:   Mon, 4 Sep 2023 17:18:39 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     John Hubbard <jhubbard@nvidia.com>
CC:     David Hildenbrand <david@redhat.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>,
        <mike.kravetz@oracle.com>, <apopple@nvidia.com>, <jgg@nvidia.com>,
        <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <kevin.tian@intel.com>, Mel Gorman <mgorman@techsingularity.net>,
        <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in
 a VM
Message-ID: <ZPWg70BCEwZiwCfZ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <ZNnvPuRUVsUl5umM@yzhao56-desk.sh.intel.com>
 <4271b91c-90b7-4b48-b761-b4535b2ae9b7@nvidia.com>
 <f523af84-59de-5b57-a3f3-f181107de197@redhat.com>
 <ZNyRnU+KynjCzwRm@yzhao56-desk.sh.intel.com>
 <ded3c4dc-2df9-2ef2-add0-c17f0cdfaf32@redhat.com>
 <37325c27-223d-400d-bd86-34bdbfb92a5f@nvidia.com>
 <ZN2qg4cPC2hEgtmY@yzhao56-desk.sh.intel.com>
 <5c9e52ab-d46a-c939-b48f-744b9875ce95@redhat.com>
 <ZN63m5Dej5MBLTqr@yzhao56-desk.sh.intel.com>
 <4cb536f6-2609-4e3e-b996-4a613c9844ad@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4cb536f6-2609-4e3e-b996-4a613c9844ad@nvidia.com>
X-ClientProxiedBy: SI1PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ2PR11MB7715:EE_
X-MS-Office365-Filtering-Correlation-Id: 44f71cad-133f-4164-4fb8-08dbad2bc902
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rjTNxyGJkFrxwZ+dieEFCNufO0bSSm55A3vep1Q5rFyY8vb7DMF1IV/QHqztPhGcSwb3zUqcDSjq6nPe95LbY/HCnjI2SPZWPRXzyrK2IEEgr0Hdo6Lv+SbE7Uv0y6/gyW5iPl7qsx89Sx/pn0NsGylykypOEJIcMbmY/6Sf0wPT0MEtme71Iaf/ktbmLNlaoBWPP7TPNQuQR8ZZTK66lhOer6dMVFIueLpTyXa5ebIIFZLexcUEd0g2fclGAajYn1MGuTLn23cOAq57lP0G4FSbEbvZ364beypvJVHJlhHm/8i5BQ8zG4ASHQS6eTfWtKoFBu2Wz9eJVuVYrsBli5jvFZPgClwKrAqkSc9+PBrioppfXrUbKP96gT5C1gXdgDrtYG129hgZwiUlYodmJvDtLntgHfmSeJgnXutBdo5Hzic7QYlNmJjz0kkCc95ZOiq/SkjUCS4fnTIkDb9/upkXSjS+aQaVDVxdowts9wlZdLCB1/Y1G6Ik429j2En/GlCBP5QRHUsMujrbHCHpaBM1lGmm/6oa5XBNif9XikVJPF6lMsDNLN67wTzZaqMC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(346002)(136003)(376002)(1800799009)(451199024)(186009)(8676002)(5660300002)(66556008)(6916009)(316002)(2906002)(54906003)(66476007)(66946007)(8936002)(4326008)(7416002)(41300700001)(6506007)(6486002)(53546011)(26005)(6512007)(3450700001)(6666004)(82960400001)(478600001)(83380400001)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DZYZ3IGJWLjaTP3FMsAm2rZ+MtRPgZ6s0FDVYK45XMh8FnCyG9FvknnXutyB?=
 =?us-ascii?Q?FZLML9jDZHGJJSrMrdwq0Mpuq/ZLDJR0IRdm1FedBnVk7j+RKicBgA/3BJKs?=
 =?us-ascii?Q?fpf7rZo6rUaX7GzU99nySCj+LLwPLSObhYoEHlOzJoYWfE3qON/YpJie/FYJ?=
 =?us-ascii?Q?1KflDEscTHd7NRmhC7NJDY595bhrm+tHW5faKXRwjtPJU7/fb2HY+NmE2ThJ?=
 =?us-ascii?Q?9YLwnaDvvV+wIeW5FfcHNW78sL22Hadb/43uFmO48M3+wrPMjqdvGsO0RPNO?=
 =?us-ascii?Q?B+ZnbBHQwXRj7/fWHj8cJrHqqRVfnl1ZNXztcACVdWjb0Vk4i+jHhqbuvMYd?=
 =?us-ascii?Q?W+Jq+5xHViBgQ5U7w3qn5F7owTnRolrn5i9xfx0yv7VtLgepX2NyWkBGgk9a?=
 =?us-ascii?Q?VWtfKc8glJIJZFOwmeCWa2dK1EZMM9U8qjzwAJ3LP9mxBCcBM5ONVaDJa1cU?=
 =?us-ascii?Q?9rNRw1wbhzEgSPTleQ7HQMb5MBGUXKCWmSeQxLP5Su0JZc+sD2lTAfh6ocZY?=
 =?us-ascii?Q?MDxmWIBHMwSjvtM3pv70UJJD76yoL9qqXe6mG9S0C6UNwLalLwO+ds9yx1S8?=
 =?us-ascii?Q?Ydd2Ru4An8uRKsEKgDGGJttRdrwfISA/vEh5zjJ4xi9jbNx61PnGQLhr5hHh?=
 =?us-ascii?Q?RHFvg7vDcgvLpGPFgSYcnqZdFeYMhxGUA/5UOdKmrw+8PS36yrkGE4KxZS51?=
 =?us-ascii?Q?fz2g5J/c/drKjoAMro+IbvdA3cDk9S7jvfg4tUzecD7J8NjdAd1OBaObPxNb?=
 =?us-ascii?Q?9pc/bIHQ1vfJ4FeaI9rFxWW68LShCWFwPXs8ZwRtqRJga6OJDBjTje7451kY?=
 =?us-ascii?Q?fajHeZDV+qP+/hBXbc7E2tN9PG8lpIxUIoJI8oYX3upSLgwzRoN5RXhKM7IP?=
 =?us-ascii?Q?InaU5QJjcNgmteESC1CxlLeE6+mxg60suIvqVtThPDuNBsQ58LyyH/ywwcCc?=
 =?us-ascii?Q?x26K3iZr3RQ+DUx/EUzxLWZqJ6+QdzHkYC/hoG67XqSDjcGFHIJH9VHlyRNk?=
 =?us-ascii?Q?YBbi+mxreSs0mvseaC05NvuWaEUnBsCJKrAYN9xsiP0ivHvigR52uTKcD/YM?=
 =?us-ascii?Q?YD6WGdWF49029IoInQdh8+oBJWL4/1N1D7ZUllW9MCOtaJdefgpZT2gBGxY8?=
 =?us-ascii?Q?atrGksuuxGija3VsMYfRVvqqR0YfNsNBwDs7xcm1CJBCygkrPQbDjFtg3T2f?=
 =?us-ascii?Q?GEufrHAoWdtIG78JzuL09HM0AbiDMDdEQ7HIMQ6KsQgoS1E7HAX5pptyT/gp?=
 =?us-ascii?Q?hmSmnc2ZsSOCxMZ81t14uQwTkBjFbwTr7DJEjYH33Ppovb6GxOGARIfylIiU?=
 =?us-ascii?Q?NTmRGdR8bLPA+zm0T5Oj+IsF7VXIElFup39nfqfaAfUQdZDeXry4bUKnKqxc?=
 =?us-ascii?Q?ifxo1A122xWy6+aCAcTXOB+WWLPImBBu42Pu8y+WdQCw5VbajeB6MtvQMo6q?=
 =?us-ascii?Q?l6Tab/SbksP4jQfOsAKqDGM/0yj2rIkHZo0obsIlqF1P6fASONersWxkvhUz?=
 =?us-ascii?Q?D1PbxH7oxQKRVG1Ml/OCbOuy53KPyV+9aano7lliy15Bsu8/5ytEOGdHJdiz?=
 =?us-ascii?Q?5uKY1/dgTuGS/dlZwFjWLT5qvjW5BVn12jbTfhVlEtQVWSssQkcLPiMIBAon?=
 =?us-ascii?Q?6Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 44f71cad-133f-4164-4fb8-08dbad2bc902
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 09:46:17.2086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XkixYWp6cUazsr6oSqYQn+Fl+0X2WL5ffqJkws62GCya+5A2IWN3PqTcYmIixGfozVqwrfrfABYVOhad2ht8jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7715
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 17, 2023 at 07:29:12PM -0700, John Hubbard wrote:
> On 8/17/23 17:13, Yan Zhao wrote:
> ...
> > But consider for GPUs case as what John mentioned, since the memory is
> > not even pinned, maybe they still need flag VM_NO_NUMA_BALANCING ?
> > For VMs, we hint VM_NO_NUMA_BALANCING for passthrough devices supporting
> > IO page fault (so no need to pin), and VM_MAYLONGTERMDMA to avoid misplace
> > and migration.
> > 
> > Is that good?
> > Or do you think just a per-mm flag like MMF_NO_NUMA is good enough for
> > now?
> > 
> 
> So far, a per-mm setting seems like it would suffice. However, it is
> also true that new hardware is getting really creative and large, to
> the point that it's not inconceivable that a process might actually
> want to let NUMA balancing run in part of its mm, but turn it off
> to allow fault-able device access to another part of the mm.
> 
> We aren't seeing that yet, but on the other hand, that may be
> simply because there is no practical way to set that up and see
> how well it works.
> 
>
Hi guys,
Thanks a lot for your review and suggestions!
I'll firstly try to add a per-mm flag to fix this problem later
(but maybe not very soon)

Thanks
Yan


