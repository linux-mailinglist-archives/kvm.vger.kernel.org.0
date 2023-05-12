Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E65700277
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 10:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240139AbjELI2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 04:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbjELI16 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 04:27:58 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4814D100F9;
        Fri, 12 May 2023 01:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683880077; x=1715416077;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=W3aQDEav+kJQlh11PYxwX4h2/wUz8TVYJerh0Q55wtM=;
  b=YPr2srRGsEEP478QvjhIeuKZgqp8DOoSN8WSz9BDVGQantH6+JmamBtO
   ofyD3zcTtV05xQa7HWE5TS48K6eTjchLZB2Qg0x9plV8gPqI/5TyZDfcp
   tpOF7GSBgwevqLSiOTzLdS3YEH/ZmNS5Ncrzi6yJJLwWMTG849iAwiz8A
   ThvxqczixE6s+2aPAJ6RHdjaoCCstm6FGBkLcuTMURtwLHqIosNvXqOwh
   3qQMH8aJz1PR8nWsXSLL6ntQbx0bvedyseQE2udmicF2XIbQ0ToD0YOEp
   o4L+8OuszqzHJFNqtLSI34qyrYMiVAzyVXp4xD33dQLNqC0bGnHny8zxy
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="348232467"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="348232467"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 01:27:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="874318622"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="874318622"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 12 May 2023 01:27:51 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 01:27:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 01:27:51 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 01:27:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hMuhO8xxtbafNJcCBnnsIVU8SQxcP22qsl3NDE9LD/K8tFW/ppYU+6G/h1NdFm6QXG2JnAK6F8DEnPdVIj2sk1yGxRZgpLJWOXEWo9bXuwMSDS9fGwUDYHq/fv80jrQM0r9d1h316lvMXR/bl5CSCJVK5SvHgJPvnsYHtYRpDAHAKF/ci+dc16wjYwvfbvbCr5WagweOcu+0fHovN1IXieiGG2z8TK+6hy+7J+jrysZF1zbkyE9RdMzqRpqRoYpvRmuncUFoU/ZIWK78QyEIxttf5HKY38AgcSrYxWaGVMg+K+5ZVm22xIwWkbTPrPplbEMYZyJavXmRXh5w6PGepQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m6nk+M2D/RM3iIhDkVoav3PIukB9JqddndE9oxr9DKQ=;
 b=LrBatU4vTGzbkH41yn1CN1RComcW6E6MWDZpAFUg6jedGN35R9ss93F2SnP5tuHl0VDnWzh1ym2MOP8bU4Q85szFX/JP50WS8WoBpT0/hMPRY3mMpOflS47fjG0ddAnS4QUQa1S6pOVXjH3pcDxiST/CGYxjOX9JVkAnTBnJPI7n95ZLtbRBbwr/FOBS3TPCWlM3JesAx3b1iXjstxCYFRb9gMNr6vg/VPxKYp6qoMbzGBsl3tbsdFPlD8gF5hia3Mb9oX70a34foPKm0KX7kMeApURwFxhfUgvgHHgRbjZR5qaHUXAMllYlUrvesFGoopa3c+dz++z8LZuvPrDaFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB7246.namprd11.prod.outlook.com (2603:10b6:208:42e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22; Fri, 12 May
 2023 08:27:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6387.020; Fri, 12 May 2023
 08:27:49 +0000
Date:   Fri, 12 May 2023 16:02:44 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kevin.tian@intel.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH] vfio/pci: take mmap write lock for io_remap_pfn_range
Message-ID: <ZF3ypHwBaFljso+Z@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230508125842.28193-1-yan.y.zhao@intel.com>
 <ZFkn3q45RUJXMS+P@nvidia.com>
 <20230508145715.630fe3ae.alex.williamson@redhat.com>
 <ZFwBYtjL1V0r5WW3@nvidia.com>
 <20230511100706.63d420db.alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230511100706.63d420db.alex.williamson@redhat.com>
X-ClientProxiedBy: SG2PR03CA0119.apcprd03.prod.outlook.com
 (2603:1096:4:91::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB7246:EE_
X-MS-Office365-Filtering-Correlation-Id: bc0f659f-2e38-41df-583e-08db52c2c519
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BzwSL1Foc6JzWG9YnyX04ccXbXqexGG0ce1wEXyFhRJxhWWnkw3U+me896/122FsfO5lE7P4hiRvbd2jpW2h2G6odcZjUyrbHvl0l0fceL9IMH5kn6B54hntWNqrEblnXZVIFJ9ndda0ZxJFBRa6gKR1ofwqq/vvJkrlmB8mjFzSa9yp07g2TCECZ6aKEpAMIIR9VJMPVHKls6NqVi2cUPAzJHKUT4iVcpDlrHXXKJwauG3hRE6Nv0ypuOzx28bFYrRGkgs8UZanO2bTxkH558V8domo7UqABcfruP9oceGrzQh4k5O7KKcP3bPA3UQi6bSPJFBd1n6rbngIpTbpt2R72vDuLUyO3253iZgLTx+QSbkFxNXSpyJvYFBhvB29iBdXtb6ETlF/+ekVTgJZJopXX4bOfZXV5njh5x43RwefpAd6br0SkNfVXMNa3PBfuEnzJw2ezcJ0iWr+Yni1uZ48s2RzzWVilEbPTqY1V3kiJM1N+pIUOCuXyB9ou9NlmDpdD21p7f6sqmL43/BQ8GJv4u1O2drK5pS/UXgxANJwSU3xK4XgySO0vZgVt2XKDJMLEU1UzLrbrO3FZBR574JAqTMYZ/H/+4xoLrXcUUw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(396003)(346002)(39860400002)(366004)(451199021)(316002)(82960400001)(8676002)(2906002)(3450700001)(66946007)(41300700001)(8936002)(4326008)(6916009)(66476007)(66556008)(38100700002)(54906003)(5660300002)(478600001)(966005)(6666004)(6486002)(6512007)(86362001)(83380400001)(186003)(6506007)(26005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ai3abgDecYwaehupD+tV48mgxWk2RlOEnp+wAqQbtYMVqnNVpQix04jbr8rO?=
 =?us-ascii?Q?VUS9re+LpsgL7crZfduXAjjvZwrfULR5jUIiTQL8sdkUER4/RFK1mZL0jmXI?=
 =?us-ascii?Q?SIJDbB8vVVsGcPy/F1CWQl4kyMNAEI1hMXG0b0j/XjImbQfy4hgjtEvLQmW8?=
 =?us-ascii?Q?FLZ21o7enASG65nhvHyzYWYra4fj7c1xDWnjSvrD7t+GY6uhllgsgLrDUZXH?=
 =?us-ascii?Q?RjaiCbPRQrMBRrCvd2/RAO3kljaJyme3u5OgKXujqtN+hsPD7zoCf7ob2PpW?=
 =?us-ascii?Q?h5tJ30S54vl6Fwx9hNqh5qfz5WEUyU/lxwDqS7kbW5aLE/4VVFyWVtncnQuM?=
 =?us-ascii?Q?rZ7hXezmoouV0guKO1zcnEi0zRp9zkS3FGilBuDNs7XoZ6QevXe/P+U82anZ?=
 =?us-ascii?Q?xOUlCMRsAw0+i7qUydDdOCrPh9lL7P4Hx5TvnwdoITjk0K97pUYSiUDDTEro?=
 =?us-ascii?Q?NHot0z5K/8phIKCRqs+kU57x3b5brVdmyh35hOaAlJs8RN2+at1kkLIGwMFc?=
 =?us-ascii?Q?EV6AhuFkC0aQj6HsKTSrwsgsSr/LaOM1ht3TAF1KFVhxqLvb7dbWGGiB3kYx?=
 =?us-ascii?Q?efZQKhkI0wNGbJitzMTQlGKorW6w9bySFEH99FMbx5/TRFm3yxt8d/mqoaUw?=
 =?us-ascii?Q?H24+RppvB5pMVC1659M05Gs6pg1M7uVN2PyJ11sy+w/um5Kvu7TsnWngl7M6?=
 =?us-ascii?Q?BAyXoATqBvLqmFOW8qC04YDtdv6r2bNSpryM6e22bbZXltdJJDtMYBgRH+ui?=
 =?us-ascii?Q?a8kBrrxqTX4BKsb69uAsQ7XS5H3sbnLzys8xEa35rPABtEmaIySZWnt+suul?=
 =?us-ascii?Q?P16TXBkkpfuBgmQfXc+aFQbosxMQeMeJ5ylndXA35owEW0Oo1GbET6p2JqYX?=
 =?us-ascii?Q?HYv8kJl8GW7G5JGyz7LbKWg3KhG9E/+kYC2Mkb5sFpvO5+eDOmetLcE/bMxu?=
 =?us-ascii?Q?DBsDD4KZckI40iyuDpP+Wut5PDzSDVex2eyQfDb8n3o/NBV2Bqplk9gURrnh?=
 =?us-ascii?Q?is3tmXBQ2YAUix2on5+6w8W0/vNbI4k0GLYCUfmL1fLY42yc1BseoxwJ8s5f?=
 =?us-ascii?Q?FR2xZOMWYifS0aecsWbkqq9j0rEU9D/C1GgR8OdvtDAGK0V1Mop5sTZBWNqU?=
 =?us-ascii?Q?QL8NuJQOQIxn956es+YLGjNWhP+ldOfACXvJ7LpnvrcFACJbZE7VPeXlgmPF?=
 =?us-ascii?Q?aXtam2ZvtY/P1YDbTd+qNzJ4ZD0/PrbjW/rRbn7plZ1s0RK+8Dt4Cb/fb1+4?=
 =?us-ascii?Q?ZVcQ0OTjmMvLSqq91wsEjrdIO/C8eK/wtbXeYFoibqE1B0bvdDXDjKDoQ9B/?=
 =?us-ascii?Q?Q8pryZBjszMPiu9RvgSwyK6fl+gONyunrdU8Bq2Xk3J/ZiaOI9zcohM5cHhK?=
 =?us-ascii?Q?MGIlXLMq0d2EA8FosXwK6h7UazZW0oWcvKoxwc/J229hom8RyjxlU1/ie7uJ?=
 =?us-ascii?Q?FgMn0wCIVl6Uo78rV6r1K8bJe63VB8O6iTWxN0N4GRVhB9fhkfUCuxij4SPo?=
 =?us-ascii?Q?6VY/p3qlKfhXWUJGWfrQsaR9BKvKzztR+1ZBy/mNoZoeCke5ZAqDoRoX78q8?=
 =?us-ascii?Q?1TOCRDohahWaSc8xI728/jXmJZZ4gePUIxFDrQfB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0f659f-2e38-41df-583e-08db52c2c519
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 08:27:48.8681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Idygrtz89Z8shCHicOZdDSjpoJQK4WXF6uN8IcgJ0TD1ZRyXUuLvXnVkxLSflDkjLDTXscLUZ4h1CO4Dqxw9kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7246
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

On Thu, May 11, 2023 at 10:07:06AM -0600, Alex Williamson wrote:
> On Wed, 10 May 2023 17:41:06 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, May 08, 2023 at 02:57:15PM -0600, Alex Williamson wrote:
> > 
> > > We already try to set the flags in advance, but there are some
> > > architectural flags like VM_PAT that make that tricky.  Cedric has been
> > > looking at inserting individual pages with vmf_insert_pfn(), but that
> > > incurs a lot more faults and therefore latency vs remapping the entire
> > > vma on fault.  I'm not convinced that we shouldn't just attempt to
> > > remove the fault handler entirely, but I haven't tried it yet to know
> > > what gotchas are down that path.  Thanks,  
> > 
> > I thought we did it like this because there were races otherwise with
> > PTE insertion and zapping? I don't remember well anymore.
> 
> TBH, I don't recall if we tried a synchronous approach previously.  The
> benefit of the faulting approach was that we could track the minimum
> set of vmas which are actually making use of the mapping and throw that
> tracking list away when zapping.  Without that, we need to add vmas
> both on mmap and in vm_ops.open, removing only in vm_ops.close, and
> acquire all the proper mm locking for each vma to re-insert the
> mappings.
> 
> > I vaugely remember the address_space conversion might help remove the
> > fault handler?
> 
> Yes, this did remove the fault handler entirely, it's (obviously)
> dropped off my radar, but perhaps in the interim we could switch to
> vmf_insert_pfn() and revive the address space series to eventually
> remove the fault handling and vma list altogether.
> 
> For reference, I think this was the last posting of the address space
> series:
> 
> https://lore.kernel.org/all/162818167535.1511194.6614962507750594786.stgit@omen/

Just took a quick look at this series.
A question is that looks it still needs to call io_remap_pfn_range() in
places like vfio_basic_config_write() for PCI_COMMAND, and device reset,
so mmap write lock is still required around vdev->memory_lock.

