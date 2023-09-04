Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B8B7912D5
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 09:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352490AbjIDH7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 03:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242528AbjIDH7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 03:59:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5643D128;
        Mon,  4 Sep 2023 00:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693814367; x=1725350367;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=BBLdD6G6wE5J2Tm3mDXYdeEWct4JvVFYZZJB3y/iiig=;
  b=mv9T3A1qnhAMamy5stWCb0mHeLcVVnx7ignbLu61k3azsFYybNnF+WT3
   dWukdSoOApRWlQVEFMkLQMaTmqSagrK2v6OpGzDjabSOxwvwbNuZLQRbr
   4LxrbaW/7Jmsgdq1Be7CscD+zSo4f8l6gBiD05SyCYNX+2hNwWbMow9mY
   nj21tcdeL0UxtqaDz04kt8nxZHVjAVEs3GeE6du82ttYXL4OnhHlkBq85
   imYSxxYSuYhmWpAn6rMOCwb9X5XgxbgU1uJ24ddZUdzTYA+npByukuE9Q
   U5nYBRUG4sHU4wkMYyq48Pyo6as/br2bemP+CwLSn8nHSSyfCij4WZ1YT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="380339627"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="380339627"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 00:58:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="806158537"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="806158537"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2023 00:58:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 4 Sep 2023 00:58:41 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 4 Sep 2023 00:58:41 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 4 Sep 2023 00:58:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MTEhQlz0PwVPA+jsQQx4+B0Hmie/hHM+uKb1of5gyuNQeVQXbqYOI/gzxuoCzTuZzR8kCfnY1WAaY1YZb02gfA92VKh6uBFWK+XN0qCKlWBLpzqvfyhAQkw8x8COg+6dGkQeywccgwjgCccO3O+FZH7tYTfK/lv85DRA45/t+h6xokeLkcvxL/Egwqd9hB70yNy7Ku1JSWHgzBXqotghJ1e/9yMpXiBldNBhwtZU7+pPV4wvkkETC+XwG3K/MEBxy1quEo+vAM1yeOvLxCA8vNJ5bf1Aki257UqBCcvMF242Ri73OYLDXj2DBEY4+BcC3Hw4YQj9mrDNF7o6jlkhpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZQpIiqEa1wNh1nFqfiJF1+lhIHzl/g/0mPYPtEx2EI=;
 b=G3ds+polePEqAqxSpmNacuAnLAkfiThQdBIUfKNliG1AuthLjvuAmnWhsxNGA4xFNRikEZeYnvNDqIXbD6eH/2eXLflrJCs9/VWept2t9BTNUduARuq/D+Xki/9Z0CNFMwFQmkeeNjiVD59h5bMoL9ogrhx+qu5YFdYYwM0p12ZQc3oeIp+DZCElKCILDgfApYn1DUM7T3/BM6mWWcpqpeWd0uQL7WCacQiRZGpFFGIgs/mxHtQwD/Z3sr9NfkBfYe/Q1mrmXthA0OIcv/3NT/PkLkkJtqsji7YiE1PES8cUYjJeKOISixUTJEbSnu3E5x5TD0gnJL30VN98Vri3Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY5PR11MB6138.namprd11.prod.outlook.com (2603:10b6:930:2a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6745.32; Mon, 4 Sep 2023 07:58:38 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602%6]) with mapi id 15.20.6745.030; Mon, 4 Sep 2023
 07:58:37 +0000
Date:   Mon, 4 Sep 2023 15:31:01 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <chao.gao@intel.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>, <yuan.yao@linux.intel.com>
Subject: Re: [PATCH v4 12/12] KVM: x86/mmu: convert kvm_zap_gfn_range() to
 use shared mmu_lock in TDP MMU
Message-ID: <ZPWHtUh9SZDc4EoN@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
 <20230714065631.20869-1-yan.y.zhao@intel.com>
 <ZOkeZi/Xx+1inver@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZOkeZi/Xx+1inver@google.com>
X-ClientProxiedBy: SI2PR01CA0051.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY5PR11MB6138:EE_
X-MS-Office365-Filtering-Correlation-Id: 00628368-e48f-4d40-efcd-08dbad1cbea1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BYWUxi03HECTSRv6WK6g9trMLhBYzYX6hd4njCQmfSa+Kh4CDL4jF6e9SiMvoNt6MJpubbDsA9k5sVYznjdQyiAGRmwNhfQt/0+t28Ox7X+kC1R4d3rU4ZVzgA7XxcYxJ9GBoHNvmSZaelHhYsjKWOCxiaKBDXP7SCvbxH5Cx2iFn7sDvx772w4yj5fBEjmGgpeDNzVFMv0XZNbx9L39/bUyUubmOVvwspglZ4JLhQHQ8SFuFJXTDeIw/CWxCThNLqI1fPAL1LS1+WGE0T0yUvWc+AOm56VmxkVJdxcxGCGeu362+bnaHovciw4zz2za10rarPrs0pbFlez4EOn8BVtrlHn6HcM0BrpRYHLh/5uT1+/50NBRC9dwGyOujxpCiAfJvC4R1LYZ6bE4WUxEa+Yc42YhqSCJ3aBVn8SiFcd0VHVp30oL503QkwUytShX2mT3RNJGHmR6WyQlG7IRadsFyrhYothJFA04ap/heq5jAQBy8OMDv6NcF4EL0vrlIDE61tUit6ebkduLPhXi/qPQc46/Vrs/GUkTaOtz+2c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(39860400002)(376002)(396003)(346002)(186009)(1800799009)(451199024)(478600001)(966005)(6666004)(66556008)(66476007)(66946007)(26005)(6486002)(6512007)(6506007)(3450700001)(2906002)(8936002)(4326008)(8676002)(6916009)(316002)(41300700001)(5660300002)(86362001)(82960400001)(38100700002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5/U67X+kto3U6VeN2kfnHv7NaUgXmmURFYFQ1FoZ4WkaKN/iv7RmMZCkN6bL?=
 =?us-ascii?Q?Qi6GLothLCABoiQhSACxCwATKgzmF5/J8If5piAGoLlpKv8F42fv40bHDqHa?=
 =?us-ascii?Q?2ZVXlW4rDXzGn7D21nKGEB2dt20RE1JxhGmi4nCd2LuRDNXaJYu6KqiGjkOK?=
 =?us-ascii?Q?I1eJ61oSLM5QDso516IrJkcTBlAtEmM9uG0NXVimUYLoXg0+HP/D7TdXVp+W?=
 =?us-ascii?Q?sZ/yS5Q9flvHnDBrHjoDOsDjbh4S0NSy83b+Y4ZWcWd595x8mjuQb4D9tmt3?=
 =?us-ascii?Q?7z8vXrXEhwxsa11UhxKZzmoU2fcGU+mgAI4lvh98vDWe0Wzr5llyk6xumxJ5?=
 =?us-ascii?Q?yoGrqa+wPU1wmx3h1vqP279r08VW47ZCJMAA+E12h3wQCr2GWqaK8jOscWMI?=
 =?us-ascii?Q?JqKUhfnYPkV+++OmQYcMJftiSx93QknfqsnadjwMZOdqvYzYN6LhjzkGeIrH?=
 =?us-ascii?Q?MFDokWw8u47p9oQNTcCPEJlrLIGVHMAsofNB3QstfXNSsWPkyIb6OMzABQpJ?=
 =?us-ascii?Q?Ih14U5MRieGkEiXQMIEa5PiqcGdATqyF3m8KaW5dj4FTvNYyYIDM4yjjWdoo?=
 =?us-ascii?Q?duyYM/d9PAQXWJn36ZNA4eXUcNsLOUAqUVMxx5Q3r8uoaFv+IXR0hJfWJbyr?=
 =?us-ascii?Q?NmkGYbdye6/EDDaz3aeSg7vgQp3Ib1JvXofwFWML9XjVpKxIHlO9M7rT07XJ?=
 =?us-ascii?Q?eMiDT4q+9tUW3iqVy0GjS1Lga6ikl6e910YWkJNbrdU4sDoH0GJ4b9Er/m/L?=
 =?us-ascii?Q?gLZ5r9BJC7fISAVK0hf5Nubg4fpDKUlLMon/0YCX5rw/76cFFPvDlYr879AW?=
 =?us-ascii?Q?sEzuaTZe1IPTvgDcxWsqdBGFJDq3qLeE4bFRdXOaay/45BpKKyOUqpgJgM/B?=
 =?us-ascii?Q?1QhlxsGJIy4ljfpdOpEqs5mxcOR3PMbzc6LQqYKwSfW37QBPDAokyipgNXU2?=
 =?us-ascii?Q?cr4BiBfDsNIHeq2dM/oyLix6rLLsoFmFQFWaglNZgzP+UtpMRSd6bAC+cdYZ?=
 =?us-ascii?Q?x5yDM2/WyIR46gJoIDrz4ZTVCN3ctMe595ifpzgGJjejyBbr3jge1PGK5V7a?=
 =?us-ascii?Q?pECtpySEPrGD9nt/C73unx/MEiDP4GMwGcgumR85l0lYeIGYLWugPPxX/DYQ?=
 =?us-ascii?Q?NRQUz69FpM80dvns93Q+vMHgtTTIIQmJu7p0C0SlBdyH2apx/HOl/4vy4uMy?=
 =?us-ascii?Q?ZyM2BZph14YMeHK2+EoX15/iGPYmVvB02EERGHTAMpD/6+VQj4nnqL0YERWZ?=
 =?us-ascii?Q?XgMBrxKKHTtRcXW5iTfbIUYhaq+i8eG6m1vEFElzzIjlpaLL7JyKRB3HlQZg?=
 =?us-ascii?Q?oqkgho6yDWpvFHtVLoFmu8OhKgv+hiHagHFOhneJ4r3sd8eQ1vh/ADnB8hQh?=
 =?us-ascii?Q?ZKY19kfXehVXdOPpUBLFy2kihi1IYggRUrhD6kuMUzEuOMHgfjJ7FA9LBRwT?=
 =?us-ascii?Q?Ich6GAVr+72TqqB81AzN/wqIhanLcdkKllYRFzQG99O8sOR/TNIDvE4sd/0C?=
 =?us-ascii?Q?2ncYxWbPeH0tf5zpAAPlZhA5LH+1zAuzACU1w0UWVWi9zfq74Ltscwn0wkSC?=
 =?us-ascii?Q?d5RjyDr6XcEK2Is8ClO3vz+ikDjgocam60r+rA26?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 00628368-e48f-4d40-efcd-08dbad1cbea1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 07:58:37.9210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jful5pXLIX21OT65wvoVIL95BQMJdoTnc1wP8l8TQ7yq4JD5dZO/N9Zs0aaVbDQAMvOtDAgcwk9RAZ9Rm7cSFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6138
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 25, 2023 at 02:34:30PM -0700, Sean Christopherson wrote:
> On Fri, Jul 14, 2023, Yan Zhao wrote:
> > Convert kvm_zap_gfn_range() from holding mmu_lock for write to holding for
> > read in TDP MMU and allow zapping of non-leaf SPTEs of level <= 1G.
> > TLB flushes are executed/requested within tdp_mmu_zap_spte_atomic() guarded
> > by RCU lock.
> > 
> > GFN zap can be super slow if mmu_lock is held for write when there are
> > contentions. In worst cases, huge cpu cycles are spent on yielding GFN by
> > GFN, i.e. the loop of "check and flush tlb -> drop rcu lock ->
> > drop mmu_lock -> cpu_relax() -> take mmu_lock -> take rcu lock" are entered
> > for every GFN.
> > Contentions can either from concurrent zaps holding mmu_lock for write or
> > from tdp_mmu_map() holding mmu_lock for read.
> 
> The lock contention should go away with a pre-check[*], correct?  That's a more
Yes, I think so, though I don't have time to verify it yet.

> complete solution too, in that it also avoids lock contention for the shadow MMU,
> which presumably suffers the same problem (I don't see anything that would prevent
> it from yielding).
> 
> If we do want to zap with mmu_lock held for read, I think we should convert
> kvm_tdp_mmu_zap_leafs() and all its callers to run under read, because unless I'm
> missing something, the rules are the same regardless of _why_ KVM is zapping, e.g.
> the zap needs to be protected by mmu_invalidate_in_progress, which ensures no other
> tasks will race to install SPTEs that are supposed to be zapped.
Yes. I did't do that to the unmap path was only because I don't want to make a
big code change.
The write lock in kvm_unmap_gfn_range() path is taken in arch-agnostic code,
which is not easy to change, right?

> 
> If you post a version of this patch that converts kvm_tdp_mmu_zap_leafs(), please
> post it as a standalone patch.  At a glance it doesn't have any dependencies on the
> MTRR changes, and I don't want this type of changed buried at the end of a series
> that is for a fairly niche setup.  This needs a lot of scrutiny to make sure zapping
> under read really is safe
Given the pre-check patch should work, do you think it's still worthwhile to do
this convertion?

> 
> [*] https://lore.kernel.org/all/20230825020733.2849862-1-seanjc@google.com
> 
> > After converting to hold mmu_lock for read, there will be less contentions
> > detected and retaking mmu_lock for read is also faster. There's no need to
> > flush TLB before dropping mmu_lock when there're contentions as SPTEs have
> > been zapped atomically and TLBs are flushed/flush requested immediately
> > within RCU lock.
> > In order to reduce TLB flush count, non-leaf SPTEs not greater than 1G
> > level are allowed to be zapped if their ranges are fully covered in the
> > gfn zap range.
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
