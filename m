Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5AE6E80FF
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 20:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbjDSSL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 14:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjDSSL5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 14:11:57 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A9961B9;
        Wed, 19 Apr 2023 11:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681927916; x=1713463916;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CWAaNdByyfZ6931KExbZB4bROvcSJVF+47jq4bdVFi8=;
  b=Tm+IsigY4XMdwzNlUlXQ1Yc0SQwkEW9P4K3+gaCpoJvN9OQ/HzQo/S08
   +i6evWevkh+BWqVCbGBGxH+GbQa5nF71KMlgsP4TXKvbw91O+Jwnmc6gJ
   qNH8QvNB4gcBh70QGvJgzqMGFdx2Xf0UYDfZdDyefu5ElvlqHw4Dar2zp
   ikPxkbs63YvmwA9xnfARhKdIY6jsdnxYjCmT3SiPnLkumdCxRdiXmswfj
   n6FFS8fSSZIuyhH7dP46fhAjd5v/0wSI5DjR61kBPpKrNK9Y5353m1+du
   k9JDlYbc06RdS7gSz9R/k3UbSE43s1q6qI4k7RBgblw/9lQu2zwYc6V48
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="408433576"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="408433576"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 11:11:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="722025594"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="722025594"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 19 Apr 2023 11:11:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 11:11:54 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 19 Apr 2023 11:11:54 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 19 Apr 2023 11:11:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQd/Ts7scOc0eieZr8zGyitm/3+iH1I9vvaAPkXnb2XIiwSXjkITxpGFl5FSpQbFtFEGgLJenlt9IrG+dmFbQhMZ0qHtjJMMB+nblT/wF7ZGT+NKEqkWoRC8PmuvMHydzXXdsh6O5B0g/d15OfY1NZxHRiiTkTIvvIe9Gy1+T78n5Jz702zI5VP9tOmkvTebl8eaHdQXMdKrejrji82FmoThWgyy4wYKOi+5J+FHsBq9Ncr5JDDhgt2lt8SaGe1B5P3uMmyTF2c3BeyvpJCUUNAkwETWiCbvDfYhaBM/JHaePRrkwLWYoJLnxof+zmMuB9GlNOA7XY6X9QeKyOm+2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79Ck+h9D3XLMhaf8cdcCgl0kGwXr5dHGYEHbu7aG924=;
 b=oGMX8XQPk7oZDOoDu1VDY/tw6ssXSkAIKQbkdWlvmvraXAmAupB1saqtEg8toeQBBsQnjtiGu5pokIU+bT96odUAuvtD4tQv3ix/Gy90yl3QbPsTnuIS6MtPV/UmvQIjdutRXScp0Hx5jUKvkBymGN5qYKhyhDOvUAsyyG2I0zsgDbPoF7YKw4+tUwaM9CjMj+PK6KyAOHgKTFBer0NIj24tM6Guotlbm253CumRCMolnHy2BS0+LzpaOa5/sK0egnT26j5jPuy1bR92WMFsNY+lUDyDWDl5kug6Q6wr9KKQCfMjnrsZ+Fblhn5xZZqWob7lrPT87Rw1/coVzUMRDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by SA1PR11MB7109.namprd11.prod.outlook.com (2603:10b6:806:2ba::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 18:11:52 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::4bd:cce2:58ce:cd6b]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::4bd:cce2:58ce:cd6b%3]) with mapi id 15.20.6319.020; Wed, 19 Apr 2023
 18:11:52 +0000
Message-ID: <64b99d1c-073f-cbc3-6c5a-100fa23bcb13@intel.com>
Date:   Wed, 19 Apr 2023 11:11:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH V3 08/10] vfio/pci: Probe and store ability to support
 dynamic MSI-X
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <cover.1681837892.git.reinette.chatre@intel.com>
 <0da4830176e9c4a7877aac0611869f341dda831c.1681837892.git.reinette.chatre@intel.com>
 <20230418163803.46a96fdc.alex.williamson@redhat.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20230418163803.46a96fdc.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0015.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::28) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|SA1PR11MB7109:EE_
X-MS-Office365-Filtering-Correlation-Id: fda95faf-8653-4560-a981-08db41018ca3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pTJLGA2bdTN153AAWstQzdeKNUWZTSDbALQuq3l9LeRiWOR2sAgmT2sa5Y/xk9JTwanfjetqiBPOsbpHv8TK2YcPA/MvXnLG1OtgSS3ZEmE7pmxj/LRJH1iRwu3jIsgr86R1c90y/x/RDCtsKW5nDVgJJYAklHQ4inSGnqaW0GafQQ6sE4HNtHHzr8jb1Upw7NA66/H7YgC6G2JVW+f5g2GyR5dXf896hQOf1RLDYU322DHkNeIAw/yHA3pp350Nwry/E7s/x0NLtyj53SJvouhQmZfVr7dRCpDsgiRAv3qw7IlzYeRM86SsGb7qdAIIAyzjLkhGP/A3CqzhlonJRcpS8TCiCpEGdbv+kBH9rnmI7fXwlqt/q3lPtJSEeg6tn13p7UCuHMmHo6qiWomIcQ1mShdaJQjiabHKwQ2ZldTC52OQb+b7oUEmlwm0Tbt5OGBTpo5XahvHsDAAopcQ2SG4B3Ty4S12QG+gIsRG66Yq3PKpibqKyPAoGQiRUSgEcIT8n76nPxjJOv6u+EJfdIAtLq6WrhPWjwqfJwUSKExeHQlURVWvu6a/UJ5ZJsKYjbj1UgdoTXQ+8w11R4kV9pR0631d3N6uoPh2krIhO0QcB43M0U75anpKb/V3AKT+I//iPZ3jCzzP0Vs1Bdu90Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(376002)(396003)(136003)(346002)(451199021)(31686004)(316002)(6916009)(66946007)(66556008)(66476007)(4326008)(36756003)(53546011)(26005)(6506007)(38100700002)(2616005)(186003)(6512007)(83380400001)(82960400001)(5660300002)(8676002)(6666004)(478600001)(6486002)(41300700001)(8936002)(31696002)(86362001)(2906002)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWRiUDJjQVNWRE0yZjNIUkxzSmRlamhTSG9STk9WeGtINGZxMnhJWUxLS0lK?=
 =?utf-8?B?MWl4cjR4SnNTMkZXNGc1cFcxcTRLZStTUkZ3QWlGRHJsem9lQ2JBT1ZNSHhr?=
 =?utf-8?B?YjYwMHlUNVg0UzBxTk9hc3pUenV1aXhOaTFwYkJLTGpleWkzelZYRlhNZ09D?=
 =?utf-8?B?S0RBenB5UnhJVjQzMXFTR0dqSG1xS0hBYUgyMmRZWnJiQWxuY2Z6WlNyT1hU?=
 =?utf-8?B?WDBpaTZoSTJxQ2VKSWpnZkpMTUhqdU9udUxIWjhQS2ozdXozNHFhWm5HZy9U?=
 =?utf-8?B?MGkzR0FTWWFDZnZGWmZXY1ZoV2RNd1haVUVMdkZuZ3pRYXBueDdWaXZCdFAr?=
 =?utf-8?B?YTVyZ1R1SlNFeXZoTHJOK1pGb1R0MjFNUXAzL0hyNUtsTVVwdVZidENoaFJ5?=
 =?utf-8?B?TTZuWkFpaVk5dUhwWTdhYU9DZm5iSU1lN0I1VE5XU2VReHpQbXRwY0dUSDl4?=
 =?utf-8?B?VnExRjhGVlVwUWN5V3BWdGpta2JRMlZqVTdxMkVTKzh1Y2MvN2J4a0g5UEZw?=
 =?utf-8?B?RzVVQ3pFNHBlOFRRTzBBcDhIamhya0s2cTR1Z0lGc2lnNnRiWFdHNWlaZ3Jy?=
 =?utf-8?B?OGNoTVI1bStINkRUMS9uclNYZ0Vub2dFYkhweFF2L3luYzFaQXlRV1czTkY5?=
 =?utf-8?B?OHExN1djUkFhZUpMdnNrNzczRkZiY3V4a2dKNVhkeHVEdlJnenk2QnM5NFN2?=
 =?utf-8?B?RGpKU2lOQVBpMFl3bHpWVVNST3pTRG5rYm1ZSFBYZm9xbXJiTHFULzNSeStQ?=
 =?utf-8?B?c2JtR3I0ZVcrT2JUOFFDeUNXOEVKT3R4NURtR3grd2ZzSHlBTmFwdklCR0s0?=
 =?utf-8?B?SVhwMEpiOTV6YndBV3B6YVpab2laVWt5dzJ3cUZPN21zaFlsVU0wRXZ2cnd2?=
 =?utf-8?B?SlVCZGt6emRGOStsV3pkQTBRcW84ZkFCb25JZUoyaGF6WkVoRXllRXlyOHo1?=
 =?utf-8?B?Qi9aUDFWUy9GSEVCOThacFVhb0xycmxMVjVlU2Y1OUdkOXlvWTQ2VXU1VmI0?=
 =?utf-8?B?dG5sOHd1OUk0ck15bFJsU1pBcWRWOWx3Q0xzb1FLZW9yUGxzVHdoeDJBNFUx?=
 =?utf-8?B?T3ZWNlExazlPdm9lMFliVFE3Q0NWTWdlenpqQWFHQ281a1dud05LbDBwR2lB?=
 =?utf-8?B?c2VwUk5rbEsxNVVIWktBVVVsYTJPREJOdGRpMTBTcXhIV2lISHl2dW1DL3VT?=
 =?utf-8?B?RlkvQWFpaTZCS3hXSGZEV3cvbUJLVnh1VkRTbWVaL1pVTGh5OWR1Tnljd1Iw?=
 =?utf-8?B?TmZTTXJLRkFUTVlmdEpVQjlyNS85K2tpek50VjhpQmVuZVlPUUFuZlFDMTBL?=
 =?utf-8?B?SWpKNFIvc2FDZHVZWTJibDdhL3pxbU9qWjJXdGYvczdGcGQ0c2xqdXpMU0xF?=
 =?utf-8?B?b25hc1RsdlJiME5wNEZ2VUJIZFBPSkdCYnZPMUt6OXprMmNNZ04wZFY3RENu?=
 =?utf-8?B?dll3dzlOLzkxK1l4b3E0SVVPUjBzSG5YMUFGY3NvWlhzWUkxWmtHbHN3aXBW?=
 =?utf-8?B?c08xNHl4UmtENEdKV3hkV2lrcUd2dXQ4Q21JNU9RN2c3US96V2t1bkdGdzdW?=
 =?utf-8?B?U3JoUWV3aEZFN3NFbXhkK21YQzFxRHc3SWdXUThpQkkzRnNzRlZBVWZCUG5o?=
 =?utf-8?B?NGQxTzRpRDJGc1ZrVDZ5TVVRTVV5NFBKbkIvOFJxY3kraGQzNWxldlVJNzZD?=
 =?utf-8?B?aDFweE8rL2J3MXNYSzVQMlFYeUN4UGoyZUxrQlkyNVZaSWNDVFZqcUY2KzZ6?=
 =?utf-8?B?VzIySU9SbkJ3b1FJQkNFdzg1ekZWU3BwWm9YT3hqWEd4Ris2Zm1scVJJeVVP?=
 =?utf-8?B?eWVFbVFuamhwWUlUQjVzL3B3aG53VVJLUXNUVjRydGYwMytzdTNCelNqZHl3?=
 =?utf-8?B?Z1l6MkRudTA2WStHOGp3VXprKzhHeXBPK3hJNE5MWTIxYlNlWENkQ2N4L3Av?=
 =?utf-8?B?QnNZL0RUbjZ1bWl2aXhGaDRyTzZjS0thYnNSNGwyd2RsNVI1bER1bnIwMFVP?=
 =?utf-8?B?M0pQRFUxcUF3a21MU2lub0gvVlVycnc0OTBpSGs1aExSZEd3czFhemFnMmJR?=
 =?utf-8?B?ZnU4eDVTOUphU21OeDBaOEFFU2JWSUxPWmdObWttV2xwUmVMYisyOGpYd2lv?=
 =?utf-8?B?TnRhQXVJa2pNM3VXVlBtRnc1MDd4S3NCNzAzcUFDblZUanBKa0czMS9GSnFE?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fda95faf-8653-4560-a981-08db41018ca3
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 18:11:51.6627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZIADQ8na3ulHjE/AZj9QjCcdqm/Fo/cqhArn+JdDRiXMHxbD/Q1uk0AG857UNYzUq4wZ7jnkjiXM9RkMsVhoi/T11h6DSaFEFRfMUAvgt6A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7109
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 4/18/2023 3:38 PM, Alex Williamson wrote:
> On Tue, 18 Apr 2023 10:29:19 -0700
> Reinette Chatre <reinette.chatre@intel.com> wrote:
> 

...

>> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
>> index 148fd1ae6c1c..4f070f2d6fde 100644
>> --- a/include/linux/vfio_pci_core.h
>> +++ b/include/linux/vfio_pci_core.h
>> @@ -67,6 +67,7 @@ struct vfio_pci_core_device {
>>  	u8			msix_bar;
>>  	u16			msix_size;
>>  	u32			msix_offset;
>> +	bool			has_dyn_msix;
>>  	u32			rbar[7];
>>  	bool			pci_2_3;
>>  	bool			virq_disabled;
> 
> Nit, the whole data structure probably needs to be sorted with pahole,
> but creating a hole here for locality to other msix fields should
> probably be secondary to keeping the structure well packed, which
> suggests including this new field among the bools below.  Thanks,

Thanks for catching this. Moving it one field lower as shown in the
delta patch below seems to improve the layout:

diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 4f070f2d6fde..d730d78754a2 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -67,8 +67,8 @@ struct vfio_pci_core_device {
 	u8			msix_bar;
 	u16			msix_size;
 	u32			msix_offset;
-	bool			has_dyn_msix;
 	u32			rbar[7];
+	bool			has_dyn_msix;
 	bool			pci_2_3;
 	bool			virq_disabled;
 	bool			reset_works;


Combined with the other changes to this struct (new struct xarray
for the context, and removing int num_ctx) the bools are no longer
together on a single cache line. Placing has_dyn_msix as shown above
keeps it on the same cache line as the other msix_* fields.

After this change the layout of this struct appears to be improved.
Before this patch series (v6.3-rc7):
        /* size: 2496, cachelines: 39, members: 46 */
        /* sum members: 2485, holes: 4, sum holes: 11 */
        /* paddings: 2, sum paddings: 11 */
        /* forced alignments: 1 */

After this patch series (v6.3-rc7 + V3 + delta patch):
        /* size: 2568, cachelines: 41, members: 46 */
        /* sum members: 2562, holes: 2, sum holes: 6 */
        /* paddings: 2, sum paddings: 11 */
        /* forced alignments: 1 */
        /* last cacheline: 8 bytes */

Reinette

