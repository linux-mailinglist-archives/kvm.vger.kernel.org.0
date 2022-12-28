Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082E96572EB
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 06:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiL1F0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 00:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiL1F0h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 00:26:37 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF60DCC;
        Tue, 27 Dec 2022 21:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672205196; x=1703741196;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=XDy8Il0MTNCGPwjTPCrKL9oYSFXuTTRgA7drsDMKWf4=;
  b=M5OJknT+9EhoadncZCoMHVQt1zb/ak8F37cwlnMLw76x/ZhS2xmldp9+
   51O3g9r/ZANSZOqy1cy7qhWkiyPtCs6iqq/ezQgrQquRcwANB4yi+6a7W
   7xfU5I4KDVCk8upc54n6BNIhSi9pPO1zQKsBhmzCYlsNmUePpwtyaqtTv
   np9JKCk2Q0ANZBoMqGx3eI6xoCsyOi7DVJEgbsOwab4E73QJFF+k6lODw
   wvxDGc/xxgxBo2xtMqWY+kafRbqnUgE3Gx9xTfCUOGuas745nzt2c407c
   O/wOEBveHLjZ+nceex0i9t1Cbgw38Cbwvm6w+4NM29ZE+AKKH0ku8HmmF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10573"; a="322044116"
X-IronPort-AV: E=Sophos;i="5.96,280,1665471600"; 
   d="scan'208";a="322044116"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2022 21:26:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10573"; a="898570638"
X-IronPort-AV: E=Sophos;i="5.96,280,1665471600"; 
   d="scan'208";a="898570638"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 27 Dec 2022 21:26:35 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 27 Dec 2022 21:26:34 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 27 Dec 2022 21:26:34 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 27 Dec 2022 21:26:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mR3fAEqvDYBMzPAMY6nlEX7/1CfwAtQEoOEMsldyHAgsEoYg8xfxWrpSy6ptQeHGUiKUAiMcUkbGDaJBUeS96opH+xEXOCHAnTdp3TgG9U1INrHTgZDyq6SN9Jn8pMfV3FWcrXO6Mf3nWYqHLktezqPKeEz6xj1c+JWk5y4XmjiC5jIi7o1v1pprxayltO1pEzS5lN7FzVbbFae+otbNA1JAbPDMQwct7XVWYDEEEb1YyMw9skYewulmmiZBs2A4xfEwD2B6utQ7HcnGzGnPz4PuxxnPcQW4cdmX9ppO5KcQ4ldG/FW5mTU5d5dKsnZ3rupIy9tMX7Zx6JDHuTZkAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W5uzWJJBzHBLrk49lAED71T0b3AGRym9xG6/bZ13slc=;
 b=TJyABzNG3dsaDGZxPZFuy+CTWqa3YBE9f83M2OeGfSD225wtScRJ8wTO9pPdVSl3BabX7haDDIXSZD+C4uXKCAfyWMWh9ln4D4VjzU+NK/HVsHn7LVmM5IaEYVcqp3Y6rINHc+HdigIU+6u7zl1gH2dmLJlSoUlKB9SC9Yi+0X4ZbYyY3GUaZhUIdT2bqPSkcJUzCqDx3Q7BGx08T+4hEMjMI9JcK2rkSsJsDCyj37TpXsR3NKWQFbMlHxUJmXyQSCPrtlUKNIgW9hs8kfr0gYznHWdufxCsWRIsIWaT841H+LhQmb7D5+E0vvnsj4Vy9Ue4uBEZTG8gwFTdBRBaug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB4894.namprd11.prod.outlook.com (2603:10b6:a03:2d4::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.16; Wed, 28 Dec 2022 05:26:32 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734%9]) with mapi id 15.20.5944.016; Wed, 28 Dec 2022
 05:26:32 +0000
Date:   Wed, 28 Dec 2022 13:03:14 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 09/27] drm/i915/gvt: Protect gfn hash table with
 dedicated mutex
Message-ID: <Y6vOEjHZhOWulyo1@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-10-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221223005739.1295925-10-seanjc@google.com>
X-ClientProxiedBy: SI2PR06CA0011.apcprd06.prod.outlook.com
 (2603:1096:4:186::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB4894:EE_
X-MS-Office365-Filtering-Correlation-Id: 04468502-4ff0-43ec-f1cb-08dae8941478
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: anzUvF3dkgS2WoGpGNJq9Yd5ydfrGOiV6Sx5tpZP9ZzYHEJY4m6EEQ3ukWjOv0fk0tIwZC2tGQ46y3lJcYY41QZy0Q7SQrYDRQeNTs21fEA2+0HpFPC+h3Q9lUi+GVHTX+tiTQZ0Jh2nyPzx5UXoD1gF3bObNDqRYl1KFnnEoiBPwVM/aYjc6q2NYIv1gye/FbKaP5LsVfLPLmb+G0zpAY7XvNMBz2IWuZEa/m+9dz0gLCOJQsbG+H8/b0606sW8FBBJVS0FOaNkBWxmRzSTdf1th8+5UI5j6ecoc4WBqZ4dy/RXtFlLi7aKXxEVm64fq1mrPqpdB+/wjIUy7W1m85X03wJITHfHHXGE+1M1n007RY08IsyDp0/JiSIo1W+KnP8PYMFGj2oiGBtPmGeRL4lxACVXur/RWtvLYwHB/rnR0+8zKjj9E+n268rV98oUPaqVAFtbpsWEpuho3hb+Uzw6lFMkfPDLy69wOKNjbJysnSQihDgHUaAToHMXFWgAzXELOBfe47VVZlBME5I8iQIlj2W5hbeoPHkEySiev6/09uq0ikcvT5PdhB3H5eoWsMxgA21h/eIMsL7i1vPugY8l/zmqA+UjnKdADfftebrL+tvCXamvyPscDfw607yiZAUbszUDmdhLzWD/8PdyiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199015)(38100700002)(82960400001)(83380400001)(4326008)(8676002)(86362001)(66556008)(316002)(6916009)(66946007)(41300700001)(66476007)(54906003)(2906002)(3450700001)(5660300002)(8936002)(26005)(6512007)(186003)(478600001)(6486002)(6506007)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vzq3ZqIbfYQCB2djoF97QelNbWV8qZw4rHkWBlbK1fLcb9uYczt8b9DK2/0E?=
 =?us-ascii?Q?tS+Q1tXCwP8PnJmRCOVaoLyA59GacqnYlu5Z9NkFvqRknhEaZiKVFvpQ3j16?=
 =?us-ascii?Q?0GSC8UiUWAk2S1wPNl7rJlCQxLJjKLks/6BBoZ1s3PPayQYw5t7Q6EtSse7B?=
 =?us-ascii?Q?P3OFWCB/jQMHSvtSyFuu3b7/pLTpTaxRND8A7bKkfHNRJaN3XYcxr7b6XIxm?=
 =?us-ascii?Q?z3QUTQz+MVZoTCOuUQZYLq336vBYKvYoNOcSmKXJd0qzfdFXPgVNchk3Lc9Z?=
 =?us-ascii?Q?gnqG+mCXks0Dr38fAcB3+p+65wq77jg8BaIv94P6u2u2yrcKvkIc8GvFTJgv?=
 =?us-ascii?Q?4Cf6THMn03LHZsfP3RjX7o3JZmWc3IGH/dZHiZl233LZt8ylCfCHIquh97+e?=
 =?us-ascii?Q?0qr2/Q77d91pfJJEpqzKGxVvy0lJgtBNfdt3YY20+3XGLKggtYS7pYABZKOf?=
 =?us-ascii?Q?al0LjQqrBDrVp/TPTU9AwArm28cHO8X0+z0sO/MtnQFMGxcRqL6K9p+oTo0C?=
 =?us-ascii?Q?q7PzCluXhCMwX0bGVb9jAyYn4ppzC/RqZ3B8ja91mlP7LOiGPpGFt5kt1DU8?=
 =?us-ascii?Q?65ruAJ+ikiQh9rlx2YEzCjCHOPYzEzf8nmcnkOdYrebp3NypfGcTIukiKGha?=
 =?us-ascii?Q?XrRlyUJfMvi0b2CMsRkvjj1AiYgkZKe7mHGuwypXU+Q+joppiswotIKfgjjw?=
 =?us-ascii?Q?znyYPhCXsZmh8unOEvTfQeVzQNBamb6faA5DH3S1HqxWAvxDY3p3cIrmRGpT?=
 =?us-ascii?Q?sVxU0nsukParQNRFfZ2rm42JvHd2aH4dg6+whR5kV/5EkCbGBul6LgvL1LXP?=
 =?us-ascii?Q?QU5RLn9KzSDd+5FDm7EXUDxGy/nypAqRev7Xd2jk2fVOtdUkTI1cnNoUrcC/?=
 =?us-ascii?Q?OKmeS97ztHxcb3dUi9vZk42FMmN/x2gsNS/dbbALK3TXW28LShB3Pgm20WOS?=
 =?us-ascii?Q?DK3vmEZLgKu47hXMYwFvwTim0cuI8dQqts6C88RCpXlHKDms8Vw9BbUSVCDB?=
 =?us-ascii?Q?gQX4MI1PR5H9oUMqoqyj+g+2eKGY8w4/Y1TBO91eYx4JWmKuVP9z+w/0FaTU?=
 =?us-ascii?Q?X1HQxL/+AChCLlCE2OTz+m+Do+MiWvLh9uSpx7cjv0Z//+SRJkoNmMakvLYE?=
 =?us-ascii?Q?GriOKuj7KqJ4XLNnU32xXkMdlTebnnw3OjCiKMnKbW2wYZAZN78pQQ/+wx44?=
 =?us-ascii?Q?DIBTdsmuQl9sJK+xIcTGaWgSbxpyTE0ysM6ZpQUXF6nHppVr3TXfLEP37++G?=
 =?us-ascii?Q?Rsu8Z5AU15Vsgsc+WbXgMdnib9+Z7KdhFVOv+q9TUE7vX+jM6LwLewhCLow9?=
 =?us-ascii?Q?bwxi9tpmi7kpft9K0G6M3U5W7N7wL85XiZKEctYuRJM735885uvcFxehVIEU?=
 =?us-ascii?Q?lnfyV+b8fPFtL+tLNvTqLg9wbABROA1tangnQp1HO/GQli7mbEyBj+0CoVGQ?=
 =?us-ascii?Q?WcvbimRAecHCCcXZTRxAfXJeBfl/MpG+z9fwbB3+q4nE9n9fyVW3nQFgXbHy?=
 =?us-ascii?Q?FEMHfyhZDsT5HFpFrk3Kt3wyBCks50KK06TsTKOWofORNlzCW5ejM83hbztl?=
 =?us-ascii?Q?gXefXLXbsmwPRGuETgaNn858eVwexoE/TeIfua75?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 04468502-4ff0-43ec-f1cb-08dae8941478
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Dec 2022 05:26:32.4652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GUBywnnkdqpCOhnNahDF4ZaF6guLk4J+F6rQROJIBncTXKUw8EGrTdXaEqTbQumFVd2mQd5nRdSPErRI8UWhuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4894
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

On Fri, Dec 23, 2022 at 12:57:21AM +0000, Sean Christopherson wrote:
> Add and use a new mutex, gfn_lock, to protect accesses to the hash table
> used to track which gfns are write-protected when shadowing the guest's
> GTT.  This fixes a bug where kvmgt_page_track_write(), which doesn't hold
> kvm->mmu_lock, could race with intel_gvt_page_track_remove() and trigger
> a use-after-free.
> 
> Fixing kvmgt_page_track_write() by taking kvm->mmu_lock is not an option
> as mmu_lock is a r/w spinlock, and intel_vgpu_page_track_handler() might
> sleep when acquiring vgpu->cache_lock deep down the callstack:
> 
>   intel_vgpu_page_track_handler()
>   |
>   |->  page_track->handler / ppgtt_write_protection_handler()
>        |
>        |-> ppgtt_handle_guest_write_page_table_bytes()
>            |
>            |->  ppgtt_handle_guest_write_page_table()
>                 |
>                 |-> ppgtt_handle_guest_entry_removal()
>                     |
>                     |-> ppgtt_invalidate_pte()
>                         |
>                         |-> intel_gvt_dma_unmap_guest_page()
>                             |
>                             |-> mutex_lock(&vgpu->cache_lock);
> 
This gfn_lock could lead to deadlock in below sequence.

(1) kvm_write_track_add_gfn() to GFN 1
(2) kvmgt_page_track_write() for GFN 1
kvmgt_page_track_write()
|
|->mutex_lock(&info->vgpu_lock)
|->intel_vgpu_page_track_handler (as is kvmgt_gfn_is_write_protected)
   |
   |->page_track->handler() (ppgtt_write_protection_handler())
      |	
      |->ppgtt_handle_guest_write_page_table_bytes()
         |
         |->ppgtt_handle_guest_write_page_table()
	    |
	    |->ppgtt_handle_guest_entry_add() --> new_present
	       |
	       |->ppgtt_populate_spt_by_guest_entry()
	          |
		  |->intel_vgpu_enable_page_track() --> for GFN 2
		     |
		     |->intel_gvt_page_track_add()
		        |
			|->mutex_lock(&info->gfn_lock) ===>deadlock


Below fix based on this patch is to reuse vgpu_lock to protect the hash table
info->ptable.
Please check if it's good.


diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index b924ed079ad4..526bd973e784 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -364,7 +364,7 @@ __kvmgt_protect_table_find(struct intel_vgpu *info, gfn_t gfn)
 {
        struct kvmgt_pgfn *p, *res = NULL;

-       lockdep_assert_held(&info->gfn_lock);
+       lockdep_assert_held(&info->vgpu_lock);

        hash_for_each_possible(info->ptable, p, hnode, gfn) {
                if (gfn == p->gfn) {
@@ -388,7 +388,7 @@ static void kvmgt_protect_table_add(struct intel_vgpu *info, gfn_t gfn)
 {
        struct kvmgt_pgfn *p;

-       lockdep_assert_held(&info->gfn_lock);
+       lockdep_assert_held(&info->vgpu_lock);

        if (kvmgt_gfn_is_write_protected(info, gfn))
                return;
@@ -1572,7 +1572,7 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
        if (!info->attached)
                return -ESRCH;

-       mutex_lock(&info->gfn_lock);
+       lockdep_assert_held(&info->vgpu_lock);

        if (kvmgt_gfn_is_write_protected(info, gfn))
                goto out;
@@ -1581,7 +1581,6 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
        if (!ret)
                kvmgt_protect_table_add(info, gfn);
 out:
-       mutex_unlock(&info->gfn_lock);
        return ret;
 }

@@ -1592,7 +1591,7 @@ int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
        if (!info->attached)
                return 0;

-       mutex_lock(&info->gfn_lock);
+       lockdep_assert_held(&info->vgpu_lock);

        if (!kvmgt_gfn_is_write_protected(info, gfn))
                goto out;
@@ -1601,7 +1600,6 @@ int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
        if (!ret)
                kvmgt_protect_table_del(info, gfn);
 out:
-       mutex_unlock(&info->gfn_lock);
        return ret;
 }

@@ -1612,13 +1610,15 @@ static void kvmgt_page_track_write(gpa_t gpa, const u8 *val, int len,
                container_of(node, struct intel_vgpu, track_node);

        mutex_lock(&info->vgpu_lock);
-       mutex_lock(&info->gfn_lock);

        if (kvmgt_gfn_is_write_protected(info, gpa >> PAGE_SHIFT))
                intel_vgpu_page_track_handler(info, gpa,
                                                     (void *)val, len);
        }

-       mutex_unlock(&info->gfn_lock);
        mutex_unlock(&info->vgpu_lock);
 }
@@ -1629,12 +1629,11 @@ static void kvmgt_page_track_remove_region(gfn_t gfn, unsigned long nr_pages,
        struct intel_vgpu *info =
                container_of(node, struct intel_vgpu, track_node);
 
-       mutex_lock(&info->gfn_lock);
+       lockdep_assert_held(&info->vgpu_lock);
        for (i = 0; i < nr_pages; i++) {
                if (kvmgt_gfn_is_write_protected(info, gfn + i))
                        kvmgt_protect_table_del(info, gfn + i);
        }
-       mutex_unlock(&info->gfn_lock);
 }


Thanks
Yan
