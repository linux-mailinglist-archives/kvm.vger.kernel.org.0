Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EECDB7C7FCD
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 10:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjJMIRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 04:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjJMIRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 04:17:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FDD83;
        Fri, 13 Oct 2023 01:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697185055; x=1728721055;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=rp85he2yYOgdOUk/LqvdG0g8kIj3V4NqZpLb6dFvbrI=;
  b=bF98QDt92lighxHq/FpqWKaLQr+ReXUG3ylZkxHs+zwuFYoqx7PzKOpT
   uYqPmu2pVGPK27/GiMxYEU+xpkU3/LY4amB7HE3c9FQVdAXg2NhZWpDry
   9T0dYy6TiLa+nepWAL+ZRbGbrrOfEohd7oJo3W74Bzu5YRQ4CnHEor+x6
   QpJcrdCVRhAt4JghsnGcweXkTCYKReHzASqIcFFZaQpznIuNaBF6jAiQ5
   oIK2p92TFfWDqA6qtontYyoiDKjRen49CfFbL1ykVrBIvbQ2VagF9Yggl
   bmYUFbaReAtYDRD+eRnsPq49ZJCu4RBoHXNeXhniiD0IJFFHLhUNZGahw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="471365507"
X-IronPort-AV: E=Sophos;i="6.03,221,1694761200"; 
   d="scan'208";a="471365507"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 01:17:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="731276887"
X-IronPort-AV: E=Sophos;i="6.03,221,1694761200"; 
   d="scan'208";a="731276887"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Oct 2023 01:17:14 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 13 Oct 2023 01:17:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 13 Oct 2023 01:17:13 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 13 Oct 2023 01:17:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0kifJBvhVYKpnw6bU/jWLcqvObhENZYTGlu5HY7sYU8wGa41ONddSC+/Hb5u/2JXe6oK67R1SKtrVAa4pcwKMJtlmUmIl5ml2Rtx8ly6z1F48hHFd4MfthN9fGinIISEEi5VNyy7n83R5l1PvFmKzinAmoYI6ROKoqMCuP8x83OYrI1hVsbbHdixClOR3Prt4i9Iz3D18ApzhmBTiA3CbFarE8NsbsoaqTXdzh3HFN9fvOaNv19vs7UrPTM/ThQ10CT9Ut2MXH0XNhbEudZgvozGKcbFfcCQLbj4NHYBJjGRWZ6Inmd+P92UIoQSLINK6by1helh83rhZ9EVhbQNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ffqutne4y+bTAbYVuUxmcMl9Zp2u59hJiEHvdt6yRIs=;
 b=c6zdN2nj61cW6CIIRlQ+8Rl0otPmAsRqelqcHa39jVpNSoJxTHavkUwBCReIkuMbcudQy6Cu1twgC0xiAIus/SU4I8CoPlaBFjqKceK97X9IcbqsJqwcMHGaYVh5vFo/Y9ToRMRZMp9KUFPzryDD1tvjMbRo9muDu9dgY1AUKeGu9e04P9CIQiTPY5kwyPuiVVkfzt/jznjgwliiCVAjuTZs0mceGPUt6n2XuuEzOWQxZtZ+p3sA2eWq93EqvTAjK0kurPwmocEuWIBEdcpNh3xUmrL9J3OB4T8sjFlSk34XRuZhkdVZY9ett7m1lD+wUODZRe43hnS5c9Aknzm/7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY5PR11MB6114.namprd11.prod.outlook.com (2603:10b6:930:2d::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6863.45; Fri, 13 Oct 2023 08:17:11 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602%6]) with mapi id 15.20.6863.043; Fri, 13 Oct 2023
 08:17:11 +0000
Date:   Fri, 13 Oct 2023 15:49:00 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
CC:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 00/12] iommu: Prepare to deliver page faults to user
 space
Message-ID: <ZSj2bIVtqNrLa9ct@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230928042734.16134-1-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230928042734.16134-1-baolu.lu@linux.intel.com>
X-ClientProxiedBy: SG2PR02CA0068.apcprd02.prod.outlook.com
 (2603:1096:4:54::32) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY5PR11MB6114:EE_
X-MS-Office365-Filtering-Correlation-Id: 206535af-fb93-40d0-3103-08dbcbc4cc7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: soUPpV7Pwq076nvciUwVgA1EnFULskSK0jwO52QK4E7zUooi5M9eE6eEVD4nDEp1Dtpnc9TPVzCLeANizEuS+wSFizTNBGrv1/KrIIbRHJsw2txNRFLRXbmkuOdz1WqsHwG+13b2XXkSok5B8nkZGoQBqExHbtNQ/aKJMbkWlKVzCWqyV5YzA9PbHTQL+ZIxcmeLG9GkOUyc5Upu+t1Knml1eCt2MCifH7B8GHQfej/36/4n8Ec/PQ0gdiMAWufHe517gbYK9eeMVi8hdQGPQ3jLJsbgJMK5u6GzYwHTKOWe4kQB3LPy8tdNS7NllXxxXqBwXfUQAYbKvwXfFbOB+zC7e7MG1cmrcp5x+Ni+PuUtDTPol512wLi+JO1TZTAAuvSw71cZuhohf8GCItnsLA/CNX5GtP/ABlywOpkcIIfNyPPATefVZOrPldvXlPWtjDadEDgnsdYGgCWTwrH2v8nY8MTcejP9g+X1jH+RefCeObLt9s1IR9/Aya3td7wKxEoR0+o6/QJfFVY92pQtFD3HkZ0pS5XDtAxeoyntP/h13CnaOi9hlc8J+q/XGetm8ynSu7pB6NkcoJIXP6tCbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(136003)(346002)(366004)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(26005)(6506007)(6666004)(6512007)(83380400001)(4326008)(7416002)(5660300002)(3450700001)(2906002)(8676002)(478600001)(6486002)(41300700001)(966005)(66476007)(6916009)(66556008)(316002)(54906003)(66946007)(8936002)(82960400001)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H+mP4oJ7m2z8TUqRsLU9CJBbu1JC/mpjDBmLTLeKoXSnnqJ2WB9UqGrzpdmN?=
 =?us-ascii?Q?YZHNVWumNkRTGa3U38irvn9YUR00d7+uvxAaEIVlvaiKW9cMsi9hqsrhtQju?=
 =?us-ascii?Q?Plf0HMktFFJi3RmYA/kNgOsrbv85jpxzxV8fsQhJV4nuWZEGV77lgrIdLgNv?=
 =?us-ascii?Q?N8gnM5YBwji/r01nqwpd1SSYL12HgmIpRTsetVDrGwfJSlVSz3XNDNVwzzoy?=
 =?us-ascii?Q?pfhS8oiVz0IumobN8U4aI/nIfo5s9xtdnRj2SFfaoAKUEEVaiiX080vS1eI/?=
 =?us-ascii?Q?gPB68oBcMAe/IfkaUDVsmoDlTnr/TDEBPXs1UG7pm+v+F6eIiTyJR0STzg/4?=
 =?us-ascii?Q?n1e0iSgI79AhJOpk0zrAYpZXi7ADXIe3rlUs5SjxoIFXD/kPdmOm2t+QEzkg?=
 =?us-ascii?Q?5/QoMaKI53n2L3y0khuEt7TXZoZU/QnQHY7+13Y+C+Gkcq0yzfuTX/G+OjmL?=
 =?us-ascii?Q?7wmeX7Dc+0pe0Sd7t8EDnJ+fHZiN+5LAGtLUdftpU+5pwWE50RZcOALChLIp?=
 =?us-ascii?Q?dB+879SA8uO9RKKOHNxp+HmgnLdprdXNR8aCPRokbwtnCiR1QCxb3IuNPrWA?=
 =?us-ascii?Q?frB5bUv9dy4hIVZp6A3nYSHx9KGIORxF4cSuwIA8zOHRm2JTepwwegwtuW8G?=
 =?us-ascii?Q?3my2XimDHy3L1BhsVTHD9uCfpA2TVHW3MKzmmiNBDP/+WZPacuaeDCRwU/Ls?=
 =?us-ascii?Q?KdOh8oMvPvF7wPieOuv3j/1MQZj5ZPZdVnOHA/I3gezyGr8q07Ismw3r8Htn?=
 =?us-ascii?Q?LRpovsIcj0qByudzIeUQhT5SF4bhE8JL12pTstUfAHlEpfkCxlAjtyGozaPy?=
 =?us-ascii?Q?VpcFbflWATQzCwTb/wpGA93OenPZiQJPtUcXFGssP6WHqoe3EQxkPCHv1av7?=
 =?us-ascii?Q?NR5jhv9s7vNesgIBQc43GHQIhoAd3dUcmnJm6yrVcews3Mjr3WzDcvZMJ/vG?=
 =?us-ascii?Q?4+Y6ecrPeShKkfo0w5FNc92DqPx8UO/zNo4IDq72i1yuBASzUvhQ2yejtak4?=
 =?us-ascii?Q?FUC0KN78+7dPMn+N1ejSibK2ptxeiiRqRMlAx7zwEnEqeVAFsYXRgRjmZ9o7?=
 =?us-ascii?Q?xybADK4f/gNV3z+/C/VlKdL3WetiNUVn6x1qGpABwXeA5Qm7yeqdotdaI9/O?=
 =?us-ascii?Q?788LDw638n3QmdUjIJEEja+gD4UgJ0UQbUMuiP8bQONj2RSYhfkDNhV6QAQP?=
 =?us-ascii?Q?ZknC8A5QHrWCvvkY4uD0v/7hm2AYVs6IvcdK09/ZGHAJjUQ2nfbxSk/BNhTG?=
 =?us-ascii?Q?Qce4y6nQVDFKhPLEdGYb+qteduloBh/sDK6NjzV/tB8XLsJkRk7FM+GTcLeq?=
 =?us-ascii?Q?5kLC4gmxzKMu/uRqVO3zIDpqFKKAxbWEohOPQaPV7Cu9wQZLKm6rEhWlAnGe?=
 =?us-ascii?Q?w5ef0P3N+Tjtve8juCBHaHwx/Yv09mKuRqmELVx52Z0U9cnIQKEy+ewVMHcY?=
 =?us-ascii?Q?Z1iAmFbjuXGjFPA/QqKrledrtpHkVi2QG+m3ReY/fgiv9ocKV7VeAtE9BBpT?=
 =?us-ascii?Q?c6kyNFEmgnnq9B8fSQljdu0i6f3OT+Vdvs/fcorxU0ZRX3uPsJZeVH9ZqxrN?=
 =?us-ascii?Q?O+v/saU7O6GS0RJKctgcsasEDnEa2dbFyXm/OiqM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 206535af-fb93-40d0-3103-08dbcbc4cc7d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 08:17:11.3781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PTm9j5ZFfZMtRDsMzPKrjiX/n+WFqoiYwDGn2JjgOGFgLwpr0EePYdiZL35ANQdK1ghJj+Gm8fYM4wEvPXUy1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6114
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

Tested and verified that IOPF requests and responses are triggered and
handled successfully with SVM enabled on DSA on SPR platform. 

Tested-by: Yan Zhao <yan.y.zhao@intel.com>

On Thu, Sep 28, 2023 at 12:27:22PM +0800, Lu Baolu wrote:
> When a user-managed page table is attached to an IOMMU, it is necessary
> to deliver IO page faults to user space so that they can be handled
> appropriately. One use case for this is nested translation, which is
> currently being discussed in the mailing list.
> 
> I have posted a RFC series [1] that describes the implementation of
> delivering page faults to user space through IOMMUFD. This series has
> received several comments on the IOMMU refactoring, which I am trying to
> address in this series.
> 
> The major refactoring includes:
> 
> - [PATCH 01 ~ 04] Move include/uapi/linux/iommu.h to
>   include/linux/iommu.h. Remove the unrecoverable fault data definition.
> - [PATCH 05 ~ 06] Remove iommu_[un]register_device_fault_handler().
> - [PATCH 07 ~ 10] Separate SVA and IOPF. Make IOPF a generic page fault
>   handling framework.
> - [PATCH 11 ~ 12] Improve iopf framework for iommufd use.
> 
> This is also available at github [2].
> 
> [1] https://lore.kernel.org/linux-iommu/20230530053724.232765-1-baolu.lu@linux.intel.com/
> [2] https://github.com/LuBaolu/intel-iommu/commits/preparatory-io-pgfault-delivery-v6
> 
> Change log:
> v6:
>  - [PATCH 09/12] Check IS_ERR() against the iommu domain. [Jingqi/Jason]
>  - [PATCH 12/12] Rename the comments and name of iopf_queue_flush_dev(),
>    no functionality changes. [Kevin]
>  - All patches rebased on the latest iommu/core branch.
> 
> v5: https://lore.kernel.org/linux-iommu/20230914085638.17307-1-baolu.lu@linux.intel.com/
>  - Consolidate per-device fault data management. (New patch 11)
>  - Improve iopf_queue_flush_dev(). (New patch 12)
> 
> v4: https://lore.kernel.org/linux-iommu/20230825023026.132919-1-baolu.lu@linux.intel.com/
>  - Merge iommu_fault_event and iopf_fault. They are duplicate.
>  - Move iommu_report_device_fault() and iommu_page_response() to
>    io-pgfault.c.
>  - Move iommu_sva_domain_alloc() to iommu-sva.c.
>  - Add group->domain and use it directly in sva fault handler.
>  - Misc code refactoring and refining.
> 
> v3: https://lore.kernel.org/linux-iommu/20230817234047.195194-1-baolu.lu@linux.intel.com/
>  - Convert the fault data structures from uAPI to kAPI.
>  - Merge iopf_device_param into iommu_fault_param.
>  - Add debugging on domain lifetime for iopf.
>  - Remove patch "iommu: Change the return value of dev_iommu_get()".
>  - Remove patch "iommu: Add helper to set iopf handler for domain".
>  - Misc code refactoring and refining.
> 
> v2: https://lore.kernel.org/linux-iommu/20230727054837.147050-1-baolu.lu@linux.intel.com/
>  - Remove unrecoverable fault data definition as suggested by Kevin.
>  - Drop the per-device fault cookie code considering that doesn't make
>    much sense for SVA.
>  - Make the IOMMU page fault handling framework generic. So that it can
>    available for use cases other than SVA.
> 
> v1: https://lore.kernel.org/linux-iommu/20230711010642.19707-1-baolu.lu@linux.intel.com/
> 
> Lu Baolu (12):
>   iommu: Move iommu fault data to linux/iommu.h
>   iommu/arm-smmu-v3: Remove unrecoverable faults reporting
>   iommu: Remove unrecoverable fault data
>   iommu: Cleanup iopf data structure definitions
>   iommu: Merge iopf_device_param into iommu_fault_param
>   iommu: Remove iommu_[un]register_device_fault_handler()
>   iommu: Merge iommu_fault_event and iopf_fault
>   iommu: Prepare for separating SVA and IOPF
>   iommu: Make iommu_queue_iopf() more generic
>   iommu: Separate SVA and IOPF
>   iommu: Consolidate per-device fault data management
>   iommu: Improve iopf_queue_flush_dev()
> 
>  include/linux/iommu.h                         | 258 ++++++++---
>  drivers/iommu/intel/iommu.h                   |   2 +-
>  drivers/iommu/iommu-sva.h                     |  71 ---
>  include/uapi/linux/iommu.h                    | 161 -------
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  14 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  51 +-
>  drivers/iommu/intel/iommu.c                   |  25 +-
>  drivers/iommu/intel/svm.c                     |   8 +-
>  drivers/iommu/io-pgfault.c                    | 438 +++++++++++-------
>  drivers/iommu/iommu-sva.c                     |  82 +++-
>  drivers/iommu/iommu.c                         | 232 ----------
>  MAINTAINERS                                   |   1 -
>  drivers/iommu/Kconfig                         |   4 +
>  drivers/iommu/Makefile                        |   3 +-
>  drivers/iommu/intel/Kconfig                   |   1 +
>  15 files changed, 578 insertions(+), 773 deletions(-)
>  delete mode 100644 drivers/iommu/iommu-sva.h
>  delete mode 100644 include/uapi/linux/iommu.h
> 
> -- 
> 2.34.1
> 
