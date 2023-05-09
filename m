Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114536FBD86
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 05:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbjEIDLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 23:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbjEIDLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 23:11:44 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107C649FD;
        Mon,  8 May 2023 20:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683601903; x=1715137903;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=MRh2R/8wfKBCO2rCeVelgWSX34JUD8XLK1lKcUo70GE=;
  b=dQJiq2R6of/O1Z8k2QiWiOwct+IDktyxhXssgm3KV6D8OxHLxB9wMrqw
   jVnfJt4cKoCubDOWNsrAy9DlPaZG/6G/dmn8qXyF1pWOr7KHOWEegZlmJ
   +BpYVGFDt3hOfMZ1dBbmKX3LyAZUVrI0tv1hrjyO1SNQcfj4sF/fbEKD5
   PzQqEUtC66XMRJaCJHrJufSk40plACUGqowcR2dX7degtsHBIu0MpqdwV
   XV3vWHVuZG9yV6ywS8T6W8Z7rxhL68oH6ZBlu5oeqm27Jy/P3Hji/+P5N
   v0XUfurmB0m0Ta1F8bbnaa+rkPKIswL1xCj5Kz0fwPAd9lqsGHqUHYIvP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="352861213"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="352861213"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 20:11:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="698732048"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="698732048"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 08 May 2023 20:11:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 20:11:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 20:11:36 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 20:11:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQy7Ycf3FdqB2kuIIYztV52ozbvQFJdWfGqQuuOzEWt7NCWM6A+r99e1PHEZMhYLlaXWhAGE938QCdftFbYEU6gE2qOP97GHFiJKSyj5uHaCOzmaTrGqeNR6/ofoLnP7ADvn7M5nipM4qePC+pHfejAedd3WHXHFPTnOVzokR85WVz1lfRcuR1izUPRBKMbrntt/cF2OWkUwaEEnxYhZD74lYqzTXpfyudLjmIyGUkDxGe5ifqDApHVX477boBqaWSNN3bCCp98nlonxhsGX41ZJN61ugMOrgWhFGVAUbbVB+PLhzfUPB0HYd4llvC8HmmiBijrl3fH0E6dLX6KGvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qay3e/hryxeEbxbrPUBmB0f6NrHy5mlS4dGZxYeY4pM=;
 b=a9eZ+PfF8/LOvwvoBm63L17WxGBhwa6wR78qMFPGn7mgDWZVuga9f42TXeZ0E8Azdq77Tmrlkic8PZJrLFqSNkYzIpUNArHE2N0oopoaSCPm9+SFf3vSaViuKjKWODJNA/ggHeYfzAGWYhMlJk+lEbkIzchpVh4IgZSl+zRcu5I6pJrJopWh0L8BMKQr4XHoqBL21/QiUaSzSqUMQoXr2/aPxtYNRi0R8hoS4wFM1qqPXXxmjMM4LjcEzUhIDWyS2bNau+p5xPEiZjCT10t99FxgRFcPat/e8WkzIUfZRxL2des631A43ngbYtTWylMcoCiOSGqDDoHnH8N6tHH73Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by LV8PR11MB8510.namprd11.prod.outlook.com (2603:10b6:408:1e8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 03:11:27 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6363.031; Tue, 9 May 2023
 03:11:27 +0000
Date:   Tue, 9 May 2023 11:11:17 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>
Subject: Re: [PATCH] KVM: x86: Zap all TDP leaf entries according noncoherent
 DMA count
Message-ID: <ZFm51cHIqCD4uhUh@chao-email>
References: <20230508034700.7686-1-yan.y.zhao@intel.com>
 <ZFiinKOqGDvyVAkT@chao-email>
 <ZFmkleUwgv/38UrI@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZFmkleUwgv/38UrI@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SG2P153CA0031.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::18)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|LV8PR11MB8510:EE_
X-MS-Office365-Filtering-Correlation-Id: 76103fbe-c385-49e5-c479-08db503b13a8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: spgO8iusuKp3zunUbX1RR/vRXdLlsUTgUMamvvkAg8La2JARB3iIyXIqIEEoD56/ojY5UFpN9GdMecHO+9lyYFZF0FZvt0v6e5NsnFIP2JUIh5F72QJBK7JFAygORhAvI0fHylUpl8GXDTb++R/6fDNAtcGR4+JdqUsxRbsQEy/42nc3YKg0gjcI4ncD11Z1pxbXzUlOwOXHcdRqY67Kz6YRgcr4upyIu0Td+HlHMzScrMv1oprqk+h9J4oG9r3dzGr5bR2EmEe4MlAoK9gm/79BMokO+eBwUMKOJOBJlaq0bNJqY1jyprQ8cy/+4hk168W7kd3+MFafm+VO+G7YtYEsStttTEMWR6q5H1cguEJRg5SzSpupOpjLYGlWeaU6ceDN3rOG82zKthjvHRZEWdREOisu/NUKOeOzks01eHbHjoYRMO7nYr1FvFUGRLhS9uUjBcg6HwkuY5c8UbH+W+49qdzSYLJS8iWfoTqecIkJ5BOQFp4xBSkAuCUT7yfXJPIxuNiKGcSZQpc7rd0a5ZxvQWzmL+ySNdTcCaq3eVo5SCTLajOAxwNcVD/GRAOZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(366004)(346002)(396003)(376002)(136003)(451199021)(86362001)(66476007)(66946007)(316002)(478600001)(6636002)(66556008)(4326008)(6486002)(33716001)(5660300002)(2906002)(41300700001)(8676002)(6862004)(8936002)(44832011)(38100700002)(82960400001)(186003)(26005)(9686003)(6512007)(6506007)(83380400001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BpTpfSK0y7IJl9oh0lnWOtmk7KNtuYMNhY/Ap+L9Pauo+5k+HLK52I+4ufbn?=
 =?us-ascii?Q?iB3uDt/19Zd7zHQyjAm0wCXmVyKxGpg8uKhS8qt9Ema2BTmvC63aRX3abCGu?=
 =?us-ascii?Q?tvUuHm3hbaEIA3tjk34qAB66HRPznjhPRV5qz3ReHGTcgUDrRT6XFPJfZi6K?=
 =?us-ascii?Q?BLAOhhcsxXglMQFTWHqq2T/BMJ8VqCovQzmorghYAJQMfqsTbeFjkx827R1/?=
 =?us-ascii?Q?FWG3AbuyZ41oRgTa+DGSdTPJUpyuLxMbaPFZkkP1IgDmC9Fm9/WZJ2w+UJpl?=
 =?us-ascii?Q?V+mFjnSNRFugzmQ8ZP0n3uYqVPjZ0rPGC3pVoMbf/Lo+Cdf+vJ9AcJ1yO0fw?=
 =?us-ascii?Q?OOlaCvMa/s+hf+KvYkf1d8fjTFucksyraM5rrOlfJaSZtGnd+g0OBNN4+A1i?=
 =?us-ascii?Q?HJMTJ7/kJyZdLNn2zRtl5Kjq4PZp9ym7CMPBRK+gMNnwCZ3C1xuFm92m7REM?=
 =?us-ascii?Q?gnbkhJnzpBieXPlV9Ik6SPMwUwDXVNJN33TEDcD2tn3s0RKCWSK9VE7jBUnw?=
 =?us-ascii?Q?VLjEC0CosVaB0ayR9APNkFOfUb55JQVkfn/i6+b3RXfengmWYBim0+ajS+Dj?=
 =?us-ascii?Q?CIwAmJoHwyfiw5TgzBmHEKd5Gy8fmj8s0xspgt3/wYY8P4cQW22+eXgpe/5X?=
 =?us-ascii?Q?4hy1Ep1cKdV3iqjlrO4qu9+H/lj8jq6erPYqwmCyVRima3vEbPouGNea3vcS?=
 =?us-ascii?Q?XeMb+KxY1ic+AM9CpwYqAp5me9f+gKivTadRSMoZkdyylnI6IGkZetfBf04H?=
 =?us-ascii?Q?DgbL79W5AtoF5SgVRE0592P5dRXDfzJ17zhvBD+BMS2TxchPAMAtG4cJ3j/4?=
 =?us-ascii?Q?ASLbYazcG9RjpmGL8sfRcdvaaEicKTshLdKd9wWJAypv8gxZb4RBqYh0bqDc?=
 =?us-ascii?Q?Ls9tO3gZek0fqKPf/LSmWOc8cmesORUaaHmPK9a/lWKOgZ5lV2h+1F87EgXc?=
 =?us-ascii?Q?SSOmCs2EUfg93S5wRi4r6KdzF0EPkhfRS0Sg5+OiIjpmBV2ZbpoNS3Ruet5x?=
 =?us-ascii?Q?xRldPvaqSyevawGmbe6ub+TOUkz0oPgo8NaDVJvdnNUJrdS+dEA9xgkvWtlq?=
 =?us-ascii?Q?uMK/dZBbhsd+kzZJX8VWb0zb59ySqxdpRXWbSy/HAmuVC/ndkIQVIdbL+NCs?=
 =?us-ascii?Q?AaDc9ZZX0VWP9zI8mtrP3BVpw9v0ZqlQEucb8ciKdRDZ76h6H9Ghr1n9xqeH?=
 =?us-ascii?Q?RxveXEX63CwwwA+kybYb/lKVfGzQAGRr31pXAzNpIGuzklH2FYd9Mg4P9QaG?=
 =?us-ascii?Q?nxiAAmzS9nhx6PhWBtMd4R8g+AGS6zkuCkBfsuiG4xtjdDBUcvjm3GAVvAx7?=
 =?us-ascii?Q?KqIpQplNdDOvHkfKzoh5EZqVyMxV2H3kOvSTJmsrPzgjIkXBt1JRUNppKSEl?=
 =?us-ascii?Q?M1DooK9dCrGYhqJpH+ox7NefEKCdomoLqMlVR7q8145rikg8HhfD06wq76Ns?=
 =?us-ascii?Q?Vqd/rINsvVY5zoqjif0qijTkAj3xTn9FUT5JcGAkc2+/8RDov2IClElzdbTQ?=
 =?us-ascii?Q?6aSwp2m6caqG483QfGCaF5zg3AS0p9gOUiReBWF3tWTN3hp7Fz1cCngRalCo?=
 =?us-ascii?Q?ChWiKY6uN++FTDi3w6/DPUVQQfNDxt5DHemswV52?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 76103fbe-c385-49e5-c479-08db503b13a8
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 03:11:26.8272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wjQf6rcI13t0UruO55wV8AvDR9MxMiOvcdVYtQ2yo5P9ifyhdzYhaer0wFiK8TNpo+c/xCi9bLYNaBS/Fy+AGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8510
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

On Tue, May 09, 2023 at 09:40:37AM +0800, Yan Zhao wrote:
>On Mon, May 08, 2023 at 03:19:56PM +0800, Chao Gao wrote:
>> >However, this issue may appear when kvm_mmu_zap_all_fast() is not called
>> >before KVM slot removal, e.g. as for TDX, only leaf entries for the
>> >memslot to be removed is zapped.
>> >
>> >static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
>> >                        struct kvm_memory_slot *slot,
>> >                        struct kvm_page_track_notifier_node *node)
>> >{
>> >        if (kvm_gfn_shared_mask(kvm))
>> >                /*
>> >                 * Secure-EPT requires to release PTs from the leaf.  The
>> >                 * optimization to zap root PT first with child PT doesn't
>> >                 * work.
>> >                 */
>> >                kvm_mmu_zap_memslot(kvm, slot);
>> >        else
>> >                kvm_mmu_zap_all_fast(kvm);
>> >}
>> 
>> TDX code isn't merged. So, I think you'd better not use TDX as an argument.
>> 
>Ok. But I just want to explain that kvm_mmu_zap_all_fast() is not
>desired in some cases during slot DELETE. TDX is a good example here.

Ok. Maybe just remove the above code snippet. The code snippet is confusing
because people may think it is what current KVM has, but actually it turns out
to be a modified version in pending TDX patches, which are subject to change.

>
>> >
>> >And even without TDX's case, in some extreme conditions if MMIO regions
>> >are not disabled during device attaching, e.g. if guest does not cause
>> >the MMIO region disabling in QEMU.
>> >Then TDP zap will not be called and wrong EPT memory type might be
>> >retained.
>> >
>> >So, do the TDP zapping of all leaf entries when present/non-present state
>> >of noncoherent DMA devices changes to ensure stale entries cleaned away.
>> >And as this is not a frequent operation, the extra zap should be fine.
>> >
>> >Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>> >---
>> > arch/x86/kvm/x86.c | 6 ++++--
>> > 1 file changed, 4 insertions(+), 2 deletions(-)
>> >
>> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> >index e7f78fe79b32..99a825722d95 100644
>> >--- a/arch/x86/kvm/x86.c
>> >+++ b/arch/x86/kvm/x86.c
>> >@@ -13145,13 +13145,15 @@ EXPORT_SYMBOL_GPL(kvm_arch_has_assigned_device);
>> > 
>> > void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
>> > {
>> >-	atomic_inc(&kvm->arch.noncoherent_dma_count);
>> >+	if (atomic_inc_return(&kvm->arch.noncoherent_dma_count) == 1)
>> 
>> >+		kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
>> 
>> The issue is specific to EPT. shouldn't this be conditional on tdp_enabled, like
>> update_mtrr()?
>> 
>Yes. good point.
>Maybe also include checking of shadow_memtype_mask.

looks good.
