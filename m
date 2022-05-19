Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0490052CFA1
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 11:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236209AbiESJpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 05:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiESJpb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 05:45:31 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3CB70904
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 02:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652953530; x=1684489530;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3dI2f+rpEXuj7y5h2irpetutm2yBwprvAmBlCymcPpE=;
  b=TD9pI+LFropBmEM18E3o11HWkVm2K8sHrPghRLvTyEa63yYnIBky58HP
   r/Jlnmlqa4bYfDZwO0AtJRGO/yHZ8l7gpQwup9RvgRPne+Z7Zmbut8zcx
   +tJ4PoYimUM4snYwmTWNYjclWCxxJ1wbyavHaestrHS1JzMNVrmHmqJn8
   mM6NbhCbr139ZWVO3xXFREiz6oSj/wb8lddsD7qvhOrGYhd4MfHyGXk9r
   RW5ohhCrQ0hoebszWEyQY2G9x1MG7F3NWgHy6wjY0VfGXJOWIhe46HNaC
   qTL4nqS7jmlGwP4CA8AKj5gIzSlRKNA6pFRTUhHjFYlfFEIg+Oby35l28
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="269706621"
X-IronPort-AV: E=Sophos;i="5.91,237,1647327600"; 
   d="scan'208";a="269706621"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 02:45:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,237,1647327600"; 
   d="scan'208";a="575524259"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 19 May 2022 02:45:29 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 19 May 2022 02:45:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 19 May 2022 02:45:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 19 May 2022 02:45:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iC5Z5XQRmeMI/uZ9bDCMflCg265Ycore3N1f0J3nMPYKu4yq0Mm62vV2VeWYyrnUngwODqvisR2URHE1n0aZoKsOaM8s+JEpkTXASJpmVJuUxhXcuNuxc1VgoPFlf15LFOuZcvZutIXnEY4w8v9dxahu3m5V7UVDV9+OupZ/sifw13tHgK4tgvP69yucyWPa+ZX9dDGtDB/Wd+gFAVn9A3UVOi8+WCO6ky1fDO7pnj5Qbqu/orYNpJTnmxADuqcRE5TAadX/pcZjKf2PnPL/KLPpoy1tmviDhkyklttYLQikuqJttLlqqO2AkVV04AqtTX6n6hb03HTFmTPpAH9x+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XiYiHh7Clu6W4m54Qw/yqQoW/SEMU6iTlS86Fswzokg=;
 b=T7FqnGGkzu8jOfEMrVSP8MctmFNiKP5fVZvBVFyYWEAGLTGsxA8NMIcJsdlb6zf6rO4vEkb5U+FL9q2K+OPo1oKBwKtjXatig9HN39/O3GpJqij9cKp5IqZxHpzzhHovLr3m7ADkBZ2NtxfUJkhAO4qyY466XcCCChoifQOsoixkzpFQLQr57qi0EvWBssrqQ+MQvWiFEMUsMmQTgd30Y1g/MRYJwJiLc58ZVcAmPZNiBd+GpJ1NinYFXoRnIfwjx23Jc6Eq8k+3Dzqq9ArTFEKY2J8/6ost9QckVUD8TnHF7kTQdgJnPN9xe/FFdF3rR48eEwFl0TpknWiIfYnTBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by SN6PR11MB2541.namprd11.prod.outlook.com (2603:10b6:805:57::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Thu, 19 May
 2022 09:45:21 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::21cf:c26f:8d40:6b5f]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::21cf:c26f:8d40:6b5f%4]) with mapi id 15.20.5273.017; Thu, 19 May 2022
 09:45:21 +0000
Message-ID: <5aab6dbf-df12-34f1-4135-857174fbe083@intel.com>
Date:   Thu, 19 May 2022 17:45:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH RFC 10/12] iommufd: Add kAPI toward external drivers
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        <iommu@lists.linux-foundation.org>,
        "Jason Wang" <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Niklas Schnelle" <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <10-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <10-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0151.apcprd02.prod.outlook.com
 (2603:1096:201:1f::11) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 324f36f4-592c-4ae4-d930-08da397c4a68
X-MS-TrafficTypeDiagnostic: SN6PR11MB2541:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <SN6PR11MB25416A67D390856F03AE7F82C3D09@SN6PR11MB2541.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DcZbouiD6ScUdZrpjFJm93mHqnseZ2KavstOZ2bIwRkb5Mk0bmh6v8S5j7YR68TW5UJbooiO8JY+UZA8Yv2Nb0XGLJwRAW6xFNUeWDvmDUJP83fH+OitLtWm4CqtCRiOU0lkHHgfp0hU55IWvYzWL6KGFWrFiAOrX4R86PcKC+f/V5R8Z5nt1qVBmhpTcBG9r45C7QG6YOavVngnOOhFiRtBveQeWLVcy+v/jMY3vcdZd+x3LupbOcmjQCuc+sWeVjQRaeXmto1jOh3zUblxAcmu1/5X5js8CmUKJURuWqfLhggHmATJZFOpA9zPeHNnhbiq8fEBiqImt+KW+boB2j9o1JLr7CpQPP+GncIUG6eRUtvrKmVIq3KkwV3V/H6N1+UAqhNs+cUxV57ZAhQujEneAT5xM/BAEqbAoKHkwwtVgpV5LGMliNkZl6ZQSbE7iJY28xJGfmD1uLd3TPpbIQorpzv0dgsibNSOxPf3LSv0KSdMQaInoVCve+MYSqBEgsfcP+k/mLObcwYmLZ4yPc+E5z10PpzWlXoHMnRk3OzQQertwnVA9riMc/fNULJby3QtT1ZCd+nuYKfZkPJ5Hd8/wtwsGvtGpxd7Z0wE1m5e2hpRtOQhRiUhMhtiAX4EK2hQm6r9TuJN2HPz+kwa1cMRWAl1LmLMkD8SRYlRv85EL+nr2G1Oudlnir/kQgXYXUVyiCaLA3Q9QZGrHf7PbU2kp2MZsF/WGyn/lT/xupM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(2906002)(6666004)(508600001)(8676002)(4326008)(31696002)(54906003)(6916009)(316002)(86362001)(66946007)(6506007)(82960400001)(2616005)(31686004)(83380400001)(7416002)(5660300002)(8936002)(66556008)(36756003)(53546011)(66476007)(186003)(26005)(38100700002)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1FURnpScTV4aFZUZmhlaTdFZytOSnU5YnpXTEk4MktXUjJWTWlPa0dIMFlS?=
 =?utf-8?B?TlNuL201a3hwK1lFVzRiOTVESC9HZDd2V2ZHeUtpMUs1dFZLcEJGSGVqeU1C?=
 =?utf-8?B?OU9LemREMlpIQ2dBdkl5a21yb3g0QS81RFVwblhIVTJMZGNPUDc3Y2VkZ0F5?=
 =?utf-8?B?VXJ4djUxbW11cTlCL2h0UThHUlNmbzNIZVUwVno3enJ2SXMySHR5bDh4L2ww?=
 =?utf-8?B?M3hJTTROY2xEeGllcVM4Mldid083dlVXZG5uWEl2dTRjUjRPdksxNXdybU5x?=
 =?utf-8?B?dGlPY3Q3RlF5Znpad09OYU1obzRjN1U3QTlDa3gyZVRMbDUyVzBMcWtsZkJG?=
 =?utf-8?B?YVJoQmZuTGhnVGhWVkhCT2VZVkJRcVJmM2lNdjNDaHNLeW1OWnRKK1d3eURX?=
 =?utf-8?B?bzltQjdLS0crYkY1R1VXQlFXZXNUOVl1aWFVdWNsMWtXZzdsR3ZlSEpmd0Zo?=
 =?utf-8?B?M2ptRmZNQjNOWjlOL3JmZmVBZ0xNNGF6dmwvSjZ6Q2llNnBwcU50Ymh2ZXQw?=
 =?utf-8?B?ZVYwQkJicWMxbFE2dzFGL3M2R2ptWHFaWFNzcVN4NytXNkJkK0tIa3FUa1Zk?=
 =?utf-8?B?NE1LQnlQbThPdE9UUXBTWExuS0tuUkRrVlJvbXVhYTRjck9tdGl2SU1WSjVT?=
 =?utf-8?B?amlqTlhKY2lLanByb3oxNFhmQ2Zrd3RqU1NqcGh3MUI1T1Y1QnNUYmE4RFFX?=
 =?utf-8?B?ZklIc08yYzF6NGRTYjBNQVJQN0s3Z1puYjJEYVE2bG1vWW9aM1dBR2t4ZjJ0?=
 =?utf-8?B?eVFJQ1RjL3JUUXpTeXp0R294cG9IeW1vMVdOdVhMOFNIWUVPVVJ0WXIvOExG?=
 =?utf-8?B?S1JTaDRESGtycXNCUjBYbHJhY3dZbzUwU2ZibFZlbE45YVhDWStTd0FnK2po?=
 =?utf-8?B?RDdRWjlWS1kwdjFHelp5SDNrTFhYbG1hbC9TK095WUJTN3M0RHBzeGh3dXB5?=
 =?utf-8?B?b2gwVVhrOUVqc0xaMjhjNFQvU3o4QTAwVmQ0dTRZTHpnWjE4dENITUJpSDVj?=
 =?utf-8?B?Y0VTKzk5N1A0T0x4NzZGWWg0RkpLNVEwc1lVR3M0VHdQL1FHNGljVUw1Rmo2?=
 =?utf-8?B?SUtmRXBpY2U4MFhaWkQ1aWZuSlkzTmhWTlJtck8rbDM0ajNtVHlZTFZ2dkJv?=
 =?utf-8?B?R2ZJMkwybVc5NTZ6R25kc1F6R0hTRklhR2t4Smhid1V2dzBOSDAzVlhIakRw?=
 =?utf-8?B?L0Q4WFVOZ1RNSlo1VHhETEFqQ1NDQ3RVTFRNK1UzbWcveHgyc0xNcmtMTjcw?=
 =?utf-8?B?bWR2MDdIZ05xdnpINmp1ZStHZytJMy83b21tOUpJUkRmeVNSNFRlVmRvZWR6?=
 =?utf-8?B?cTVYT1h3akdQdFd6dDBWdFZ3QTg3YjJ6M3FVYkpnQXloeC9tOVkzTzhDc21i?=
 =?utf-8?B?OHJLU0NkZmptT3JLVmY3b2QvakJmNE9KQkNVbXJOcUV0OHVxVzZMQXl0ZUZW?=
 =?utf-8?B?Q3FVenRQMUJ2MVdOOVBiMmZPZzQ0dDJFcFl4Zk9ZM0tMMlM4VFRxQ0Rnd0or?=
 =?utf-8?B?RklvVXVLMFhTLzJNYzNvTUhpNTNXbkszZ3VHUEZYVW5SdzF0dzIrMHREOE9s?=
 =?utf-8?B?bkMxRWJBVm1mVFJRK1FGS2FXMHc5M1g1SjZ5SThLUTUrNUJWODhiQ0g5Z3Fy?=
 =?utf-8?B?aG40NzZPYnppd3N2UGVSUUltVENhZitwZ1c0NExMU1pENlcxaTlrOUxpZUNK?=
 =?utf-8?B?c1FtRE9YSkFZYlFVUGxPQnlwS2Zpb2VDcFpLQklJK1E0MGNiaHMxN2wvbHhP?=
 =?utf-8?B?SzhZakpYMU5jWWdJaFpPSmlwWVVtZzBqeEw4WFhIeEdTRExKS3pYUU5adWZn?=
 =?utf-8?B?RERadG9HWFU4SkZIRGx5aUF2eTV3UGZsSnZvUEN3eExJc2F2QjBGWFB4N3ZU?=
 =?utf-8?B?Q25uYUU4N1U0OElDOFJQLzdVQVZ0VHY3T3o0UDc3TzZ0T083amNseThZZ1dU?=
 =?utf-8?B?REw1anlGRjMySlhMOXFhcnU1Vm1tK3MxbWRlQWpmQllxckZOaHR0SUpuT3Z4?=
 =?utf-8?B?bkZrUXl6Si9qWWo5eGJpWkcrVHRzZ0FjeVZpYTQ1YjcxWUJPU1F6dkMyOG9C?=
 =?utf-8?B?THZvTlY3N1BidDJzdWI4QTRVYlk1UUcvODJLMnh3QWJJOVFiZnlOMnZpbkFW?=
 =?utf-8?B?UlZJcEU2cmFTb1BFQXB2ZThMcHd0TzdCWXhTT2lMeFBWZk1oRWM1VnJTV0RN?=
 =?utf-8?B?eXlkSUl1eDkrRWJlZExXa0lkejVuNGRDV0dBelI2N21HRWcrdWZ4ai9OVVpR?=
 =?utf-8?B?Vy9mSDBsd3pXNG9HRXBFMmtsSUJUNy94YnE1OEd2czdNMktROGNldkdvUDZ5?=
 =?utf-8?B?ektlRTR6cjNVQnVMQnZ4VE9FZzgraU45enVrVW1zSVo4OUdpbTdRQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 324f36f4-592c-4ae4-d930-08da397c4a68
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 09:45:21.5022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NoXctuJJVvJ4p1NTxiYGDeU96siu1ZPK+RMyJVPB1COrL0t2uTtRBzjjL5zKKnMxrcl9xV0eWnnV46qN3MsNaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2541
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 2022/3/19 01:27, Jason Gunthorpe wrote:

> +/**
> + * iommufd_device_attach - Connect a device to an iommu_domain
> + * @idev: device to attach
> + * @pt_id: Input a IOMMUFD_OBJ_IOAS, or IOMMUFD_OBJ_HW_PAGETABLE
> + *         Output the IOMMUFD_OBJ_HW_PAGETABLE ID
> + * @flags: Optional flags
> + *
> + * This connects the device to an iommu_domain, either automatically or manually
> + * selected. Once this completes the device could do DMA.
> + *
> + * The caller should return the resulting pt_id back to userspace.
> + * This function is undone by calling iommufd_device_detach().
> + */
> +int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id,
> +			  unsigned int flags)
> +{
> +	struct iommufd_hw_pagetable *hwpt;
> +	int rc;
> +
> +	refcount_inc(&idev->obj.users);
> +
> +	hwpt = iommufd_hw_pagetable_from_id(idev->ictx, *pt_id, idev->dev);
> +	if (IS_ERR(hwpt)) {
> +		rc = PTR_ERR(hwpt);
> +		goto out_users;
> +	}
> +
> +	mutex_lock(&hwpt->devices_lock);
> +	/* FIXME: Use a device-centric iommu api. For now check if the
> +	 * hw_pagetable already has a device of the same group joined to tell if
> +	 * we are the first and need to attach the group. */
> +	if (!iommufd_hw_pagetable_has_group(hwpt, idev->group)) {
> +		phys_addr_t sw_msi_start = 0;
> +
> +		rc = iommu_attach_group(hwpt->domain, idev->group);
> +		if (rc)
> +			goto out_unlock;
> +
> +		/*
> +		 * hwpt is now the exclusive owner of the group so this is the
> +		 * first time enforce is called for this group.
> +		 */
> +		rc = iopt_table_enforce_group_resv_regions(
> +			&hwpt->ioas->iopt, idev->group, &sw_msi_start);
> +		if (rc)
> +			goto out_detach;
> +		rc = iommufd_device_setup_msi(idev, hwpt, sw_msi_start, flags);
> +		if (rc)
> +			goto out_iova;
> +	}
> +
> +	idev->hwpt = hwpt;
> +	if (list_empty(&hwpt->devices)) {
> +		rc = iopt_table_add_domain(&hwpt->ioas->iopt, hwpt->domain);
> +		if (rc)
> +			goto out_iova;
> +	}
> +	list_add(&idev->devices_item, &hwpt->devices);

Just double check here.
This API doesn't prevent caller from calling this API multiple times with
the same @idev and @pt_id. right? Note that idev has only one device_item
list head. If caller does do multiple callings, then there should be
problem. right? If so, this API assumes caller should take care of it and
not do such bad function call. Is this the design here?

> +	mutex_unlock(&hwpt->devices_lock);
> +
> +	*pt_id = idev->hwpt->obj.id;
> +	return 0;
> +
> +out_iova:
> +	iopt_remove_reserved_iova(&hwpt->ioas->iopt, idev->group);
> +out_detach:
> +	iommu_detach_group(hwpt->domain, idev->group);
> +out_unlock:
> +	mutex_unlock(&hwpt->devices_lock);
> +	iommufd_hw_pagetable_put(idev->ictx, hwpt);
> +out_users:
> +	refcount_dec(&idev->obj.users);
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(iommufd_device_attach);
> +
> +void iommufd_device_detach(struct iommufd_device *idev)
> +{
> +	struct iommufd_hw_pagetable *hwpt = idev->hwpt;
> +
> +	mutex_lock(&hwpt->devices_lock);
> +	list_del(&idev->devices_item);
> +	if (!iommufd_hw_pagetable_has_group(hwpt, idev->group)) {
> +		iopt_remove_reserved_iova(&hwpt->ioas->iopt, idev->group);
> +		iommu_detach_group(hwpt->domain, idev->group);
> +	}
> +	if (list_empty(&hwpt->devices))
> +		iopt_table_remove_domain(&hwpt->ioas->iopt, hwpt->domain);
> +	mutex_unlock(&hwpt->devices_lock);
> +
> +	iommufd_hw_pagetable_put(idev->ictx, hwpt);
> +	idev->hwpt = NULL;
> +
> +	refcount_dec(&idev->obj.users);
> +}
> +EXPORT_SYMBOL_GPL(iommufd_device_detach);
> diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
> index c5c9650cc86818..e5c717231f851e 100644
> --- a/drivers/iommu/iommufd/iommufd_private.h
> +++ b/drivers/iommu/iommufd/iommufd_private.h
> @@ -96,6 +96,7 @@ static inline int iommufd_ucmd_respond(struct iommufd_ucmd *ucmd,
>   enum iommufd_object_type {
>   	IOMMUFD_OBJ_NONE,
>   	IOMMUFD_OBJ_ANY = IOMMUFD_OBJ_NONE,
> +	IOMMUFD_OBJ_DEVICE,
>   	IOMMUFD_OBJ_HW_PAGETABLE,
>   	IOMMUFD_OBJ_IOAS,
>   	IOMMUFD_OBJ_MAX,
> @@ -196,6 +197,7 @@ struct iommufd_hw_pagetable {
>   	struct iommufd_object obj;
>   	struct iommufd_ioas *ioas;
>   	struct iommu_domain *domain;
> +	bool msi_cookie;
>   	/* Head at iommufd_ioas::auto_domains */
>   	struct list_head auto_domains_item;
>   	struct mutex devices_lock;
> @@ -209,4 +211,6 @@ void iommufd_hw_pagetable_put(struct iommufd_ctx *ictx,
>   			      struct iommufd_hw_pagetable *hwpt);
>   void iommufd_hw_pagetable_destroy(struct iommufd_object *obj);
>   
> +void iommufd_device_destroy(struct iommufd_object *obj);
> +
>   #endif
> diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
> index 954cde173c86fc..6a895489fb5b82 100644
> --- a/drivers/iommu/iommufd/main.c
> +++ b/drivers/iommu/iommufd/main.c
> @@ -284,6 +284,9 @@ struct iommufd_ctx *iommufd_fget(int fd)
>   }
>   
>   static struct iommufd_object_ops iommufd_object_ops[] = {
> +	[IOMMUFD_OBJ_DEVICE] = {
> +		.destroy = iommufd_device_destroy,
> +	},
>   	[IOMMUFD_OBJ_IOAS] = {
>   		.destroy = iommufd_ioas_destroy,
>   	},
> diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> new file mode 100644
> index 00000000000000..6caac05475e39f
> --- /dev/null
> +++ b/include/linux/iommufd.h
> @@ -0,0 +1,50 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2021 Intel Corporation
> + * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
> + */
> +#ifndef __LINUX_IOMMUFD_H
> +#define __LINUX_IOMMUFD_H
> +
> +#include <linux/types.h>
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/device.h>
> +
> +struct pci_dev;
> +struct iommufd_device;
> +
> +#if IS_ENABLED(CONFIG_IOMMUFD)
> +struct iommufd_device *iommufd_bind_pci_device(int fd, struct pci_dev *pdev,
> +					       u32 *id);
> +void iommufd_unbind_device(struct iommufd_device *idev);
> +
> +enum {
> +	IOMMUFD_ATTACH_FLAGS_ALLOW_UNSAFE_INTERRUPT = 1 << 0,
> +};
> +int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id,
> +			  unsigned int flags);
> +void iommufd_device_detach(struct iommufd_device *idev);
> +
> +#else /* !CONFIG_IOMMUFD */
> +static inline struct iommufd_device *
> +iommufd_bind_pci_device(int fd, struct pci_dev *pdev, u32 *id)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> +static inline void iommufd_unbind_device(struct iommufd_device *idev)
> +{
> +}
> +
> +static inline int iommufd_device_attach(struct iommufd_device *idev,
> +					u32 ioas_id)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline void iommufd_device_detach(struct iommufd_device *idev)
> +{
> +}
> +#endif /* CONFIG_IOMMUFD */
> +#endif

-- 
Regards,
Yi Liu
