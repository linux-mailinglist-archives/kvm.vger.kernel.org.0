Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 788736CEC08
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 16:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjC2OpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 10:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjC2Oo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 10:44:59 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BD37D8C;
        Wed, 29 Mar 2023 07:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680100945; x=1711636945;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AdKWwxCz+WoGewNK8nUJPy1KJjr/Ij8Y+hZ3FsbQh/Q=;
  b=J8BUe+DAB5zq7/R8XIR2Oxnb31I3VQQ7f2eypgWlPzSmdvRWGxFmkaSZ
   JK7pnk/IOvs5xbrKHDXOP675evA+7+Yz65sgL1GPdnC1jPixtLyeSH0Cq
   JPghDTpxi0DtdksIJ9NfyxRXUZzsw2onCjvaBi+5Jpa6iuhK/FzANf9wh
   iNyBPILSaBu1y44GD9DHkopq3HO8izWT5n04REAc8Gv5HnvyhwRhH655u
   U2XwR5+xHwxKoTttHSs/owEYAl6PTjYnsPMAwEnIoqrgMIZpUFf5jEBHy
   36iwBs5QjlTOfScgik4XbIKXMMtWPeO6LuKPi7C9LcjjTdVcrZMd1iGbq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="340915185"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="340915185"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 07:42:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="748797584"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="748797584"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 29 Mar 2023 07:42:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 07:42:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 29 Mar 2023 07:42:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 29 Mar 2023 07:42:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBhXKWxm9OZNd+3gqxqqL2hd3MgiWyzyC97bqZZEvzopluh237MwMjzESDPquwJJBbfCBcVeBMIhw/MGWTvXLE7ORASiLMH2azJ0Hbr/AsuVbWgPPmcGmb3mAeS9AKOTol3DuMnKMcURHRHEAWB24N7NcJNa6/vPq+ryE5q0bxj6TFsyPuuCD1VbJ7Zsw8MuIh3wTsSz42See3tY+N0oG7i2CxxE29WlmBe+trR3E3T4bVOhP10uF1/QTo/PqZw1JKiiMZrHNcH4nsuOIBhT8BBydTxtNWxUD2Xf7VxoWFtkTIMUq6TqccOLKug2o6RUK9OIzk9aBuwRUPe5VC2swA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fu7QXB3nYBTd5h9NvMaGFhme3Koh1l+MCSRmiXS6np0=;
 b=ETEWUlEgaupp7w3O5Oo2EbT7V430DcAhm5DTGLmzz3zUVCJsmTUSpIK6qbXRA479nIzZ0DXtKvKbWHVNnnOd4kVJ1cA7CGjwh5yAi4KLaV9bR3GUoog1LAE3GpGsUHkjxX9VH8VBd3qUkoplYs023FUIuTUc+VAVqGf3jTgs/jLXgdV3BSHTTyrzWZYTh1EqU7tcSE2SfcfocyX4O4hgAICSIsK2cOGdPjpg+lJNjSMcC8FRYj2e2yIZKMnGPA02IaU612GdXw0DpukEsu8zO0Upf5IiQW7LC5Yjm7N0LBPnwtlj1rXt5brDsfeVPIVISZhz4CiZTF9ECQhv0u04kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by DS0PR11MB7957.namprd11.prod.outlook.com (2603:10b6:8:f8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.33; Wed, 29 Mar 2023 14:42:18 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f%12]) with mapi id 15.20.6222.035; Wed, 29 Mar
 2023 14:42:11 +0000
Message-ID: <d3eb55ac-02c1-616b-830d-60ad752f42b4@intel.com>
Date:   Wed, 29 Mar 2023 07:42:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
To:     kernel test robot <lkp@intel.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>, <alex.williamson@redhat.com>
CC:     <oe-kbuild-all@lists.linux.dev>, <tglx@linutronix.de>,
        <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <419f3ba2f732154d8ae079b3deb02d0fdbe3e258.1680038771.git.reinette.chatre@intel.com>
 <202303291000.PWFqGCxH-lkp@intel.com>
Content-Language: en-US
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <202303291000.PWFqGCxH-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0095.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::10) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|DS0PR11MB7957:EE_
X-MS-Office365-Filtering-Correlation-Id: a0c2ca82-a170-4e5d-1bb4-08db3063c75c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XAHrp8TfGkINDQ0q8cnatvRiWN9MdWndQui5aNEDlw/3f5/5f0Hhm+vM9UJ7JrpHvQWS+ZWPx7YKaz6s0g2kltXN4AvzzWUBCm9bvVU1YQMV+h0JXkw44ctZ6dMpvBeCWvL8FY1H2B/DY+pgSl9pGloHIQOn6x3gvD3kcEwvoq7axBwL/Q66sReepJz/WRDx4UPFHoEn1Cx5Z4A7TzvXrznjxiiNQGyi2EjPAz5ufUF4CQYpW6ZyBZDzOJskUiBvW2RYz9YVlcoQmomUKIpz2+GsFzSLyZBQvvmSRfrBcpzN2VVYj60ebookVNUC8eAp3uMbGRp/tkENQQlarzFLtfpXWy7F3yHBXSzxZZEhSnkuAQ/26bXjNGMqgu4GLZJ35Ca4Rp0beysDeIPYc633QUJXAFlFfuMiQaU+bhux2DAodjEG0j68agBaHO8j3fNFHzk9hfYzhwd+KxRd7T8m1V3ufI3EJEp8myn/RCq0IawwyCGChB7CFEDqrnqIcRPr74w9KwDqz5zCWk7hpdLARhGTVomIYVox8DJK4lvSMiRJKD9lNH+GeH8w2Oezjnu90D5OovmNDs40Q67ExDcoPDRlISmtcKhRKk+/wl7WC1zjtMCJPi/nXTfsj9lCQdqFlPhyopXSGtO0/HJxgHJvBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(366004)(39860400002)(136003)(396003)(451199021)(6666004)(6512007)(26005)(6506007)(53546011)(478600001)(8936002)(5660300002)(7416002)(36756003)(4744005)(6486002)(66556008)(66476007)(41300700001)(66946007)(82960400001)(86362001)(4326008)(31696002)(38100700002)(316002)(8676002)(44832011)(83380400001)(2906002)(31686004)(2616005)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHRRc05IMWxoNnFaREFQbGhNWi80TlViaXBYWk5UYjNESFA4Z1ZFZWRVQm84?=
 =?utf-8?B?NXp1anppaERST1ltd28vR1liSXM0V1hHSElDY1FsOWJUZlgzY2c1RitiV0x0?=
 =?utf-8?B?S3Vvb3Rqd3FMdGpZdXQrNUk3UHFTRXd4TnVESWFzY3JtRlJ2VGxRYUpyRkRz?=
 =?utf-8?B?Q01SeUJRcVVrRFZvanhDL25VbGVMWU5OK0JOUEFXZ0hCQjJGcHloalhnL2RK?=
 =?utf-8?B?aEtEVXhyMFpJZ2FxV3FTQ2JqTmtZT1JKQzQzVlArd0Z4Y1prNS9OWTB3RUFv?=
 =?utf-8?B?ZzJzeEFaam9KTnBIQUJMU2ZjN2I5NHlMdTJsNUp5T21aQjcxOGh5ZXZhWklC?=
 =?utf-8?B?UVRVblI2SmZHOC9TdnZ5RXZ6OE1KL0l1SGZ6R1lNQU1QWjY4a0toK3VTUG5m?=
 =?utf-8?B?NkJLZWx0a3hYODFsVlNvN3kvZE5rZ0dzejdTMi9kaWoyQmU5K2s0SkxBYmEv?=
 =?utf-8?B?L3NSd0tnV2t2czhvdUlmcE1VdmJ2dVlILzkwQ2N3NnpXajFNbE9yMzV6T1Ux?=
 =?utf-8?B?dGNiLy9GaW01OHVOd2ZWK3hXM1JOM0pxTWd5dmFRcUM2czYwcnRLUUhNYUFI?=
 =?utf-8?B?eHVKNHhBUm5UTk5TeHRLVzA2Qzh4Zk1QdFhzaFMrODhaeHVqSlVOUnVFWmlt?=
 =?utf-8?B?QTdtL2VtM3ptVHZ0c0JFNjhIeW51UGhmMURTUHZXdmlWUFErSzRqdk54M0RY?=
 =?utf-8?B?Qkh1bThtVWtDL2t3UmxJNFkxdG5SZVFHNmdSdUxpYXlvbUhXWWhYNEtpNFdV?=
 =?utf-8?B?TDJzVDFGYkFHL08xL2NZZGhBK2lkZmgvVmdONWFhMTgxNnYyK1RzRzNtK0pu?=
 =?utf-8?B?SUtBZ3Zic1p4QWJoYTJMMVVnOFFhNFZKZmdRVmpEd1ZFNTFaNTcyTVdyY29h?=
 =?utf-8?B?L2ZBMEFpRVM3UnJ3MFA2Y0pNdFA5TEdFeUxNRjFuWjRMdGQvVkg2TFhQbXN3?=
 =?utf-8?B?b0Y3NjNmMUNVUHNIbUZ5bEVHajFzQWl3Mmx2ZkhxUUpCZ1U3RHVxd0JZQ29q?=
 =?utf-8?B?WmVTbnA1dTBmZFdXQ0htVURtZnFuM3BGY3FDcW40cXRvN1V1VDU0L0R4Smlz?=
 =?utf-8?B?WjJjcFFuTWMrRTBmVzBGUVlrMjkxdnVVMzRudmtNYlRTMXVQRkVQNkhCNmMy?=
 =?utf-8?B?OVRZK1kveU1MWXZoUm5SRUQ5UlEyUEVuUG5uWlpWejU0ZURLelpNMDMvSlpm?=
 =?utf-8?B?ZEZTaUdWd2JUT3ZocWh6ME10ZGpWTm1JTDBWZzFBNDJtNFJVZ3JickJUTVYw?=
 =?utf-8?B?V3RycUo0Rk00VDJ4YnFkK1pWN1lnVkFmNjJaVE5EanU1QWZZMTNCSWNCa1pk?=
 =?utf-8?B?TWRsTldqZzNpRDIrTUpQbTZhT3p3ajhjRVoxRnNrUGZPb2pGaEVxRFMrNHBu?=
 =?utf-8?B?S3ZnbTNNMEJNN1JsMmI3eEhVOXVwVUlZQ3U1bW1XNTA2SUEyVXBWUG82SXQw?=
 =?utf-8?B?bHpGR3QxTUpLazRBY2NocmxnMzJBZjhpakh5dDJ3ZWJmQlpLL3ZLN0hwWUhK?=
 =?utf-8?B?dXZoVEc3VjNlcGp0b1E1cVhtbTRLWXdMZjNtbmRyb1p3cDFwQXFvN25mVjQ4?=
 =?utf-8?B?V3YzdnBiMjZ1eUxocVQrOXVHL2NaVVVlem1kS1lTVDJ1SE9Kck9mcG5kVWZC?=
 =?utf-8?B?MVFPVFN5NW02SXZsRFBubWtJbHcydXlmeUJwNWVaTTdkOXRNSlJ3NlJnbTJM?=
 =?utf-8?B?Q1VvSmowZ3FaMGV0U2NLNGh5b0g3am4wWTBidXBuT1dZMS9aS2tUb2JBNHls?=
 =?utf-8?B?dHJwREVLZGlNYURvaFFMbWVWK3F0bFRNbWhkSkllTUxUSG4wK3FaWUhIb2dt?=
 =?utf-8?B?V3hkem1tTWM1UmwxT1NFV1FUZktlUnplVFU4Mkt5NzF6cjdIQ2pMQmpraHk3?=
 =?utf-8?B?U09FWmJTak5LSDdHTExEaUN4SVZoRUd2YnBEa1RYcVdXMnZIOXRmcXZ2cjgy?=
 =?utf-8?B?azZFbENhbVFWZkpOVmlMMnduKzVGaElLM3NZcnhvc05ELzZkYzd3NkJVSnVQ?=
 =?utf-8?B?Q1BFazV6VWlIWFdOTmNsSWNLanRyVnp1M3NZVXZ1VmlvM3lUeEZFU0wrSUp3?=
 =?utf-8?B?SUlNRlZXa3R1NEJWeUkyYldrdjVIRUljdmxDbmVMejhBNHlnczI5TFQwTlRZ?=
 =?utf-8?B?dTh2TEdrNmF6aVNaVnNCQkFZRkFiWmFwa2tVaEZjMGdVb0ovd3VvL3pOeHl4?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c2ca82-a170-4e5d-1bb4-08db3063c75c
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 14:42:11.0802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +sHbDWLPILeqLU/VRok0WM6yF94fMRYvZ9gd37GzWN+5tcew05NE1v02OchXiOA2uYuMe9zcyCkHDSnbhUGmmiCyZZYYaAs28EEcyDIsik4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7957
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Thank you very much for the report.

On 3/28/2023 7:48 PM, kernel test robot wrote:
> config: i386-randconfig-a001-20230327 (https://download.01.org/0day-ci/archive/20230329/202303291000.PWFqGCxH-lkp@intel.com/config)

This config (and all the other configs in the reports about
implicit declaration of function 'pci_msix_can_alloc_dyn')
has:
# CONFIG_PCI_MSI is not set

Resulting in:
 
>    drivers/vfio/pci/vfio_pci_intrs.c: In function 'vfio_msi_set_vector_signal':
>>> drivers/vfio/pci/vfio_pci_intrs.c:427:21: error: implicit declaration of function 'pci_msix_can_alloc_dyn' [-Werror=implicit-function-declaration]
>      427 |         if (msix && pci_msix_can_alloc_dyn(vdev->pdev))
>          |                     ^~~~~~~~~~~~~~~~~~~~~~
>    cc1: some warnings being treated as errors
> 


because include/linux/pci.h is missing a stub for
pci_msix_can_alloc_dyn() when CONFIG_PCI_MSI is not set.
I'll send a separate fix for that.

Reinette
