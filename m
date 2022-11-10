Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15E26239EE
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 03:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbiKJCp6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 21:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiKJCp4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 21:45:56 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA37E20F5F
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 18:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668048355; x=1699584355;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J7ak3gncEcG6UPgs/3wwF9JjT+EPd5puq0JMva7fSQY=;
  b=fRqf6Q16gEvm8NolOXAvM56ZbivlthH+Hb9cLZ2b4Xs3GuFFsCgeSai4
   lvCduXnSPNXrQxRuIokDa1zsWYtY5chTv6AAR+aZJwwRYOhuemC+eJBm9
   ++BIkd4wXjl1J6jkaz0owj6faGa7gQA71z6L3W5FlF0YyF90kMHY+Ojfb
   /4s+qyICs/m4iPRtjaYGEYKSAYY45+U9JQdiA7I+dgkhJGzajIz3tUCK3
   NW281l5LBAnBY3dW7ZTo9HZpXDgZGlMjRdHjzrh1fE5ZdRjiUeEpvcaaB
   hz5eo+gjUVshcDuKV3GCCYj567GZaaxFhUs39q8Xd8mEGfv01RnjUIrYz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="337940804"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="337940804"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 18:45:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="742672413"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="742672413"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 09 Nov 2022 18:45:55 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 18:45:55 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 9 Nov 2022 18:45:55 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 9 Nov 2022 18:45:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+2OUxcTj6LQLLVSS/cHSFOnNGJuq+UEnmQr7nBvRZ4Pea5BuQ0fr2HfzzjeL1XqKKQhEelzaeU/oYoqJGSdnL3DKB0ZxUpZvJKHoAaa//tH2hOV4LP31NenfwFmhgofQP3M4BGVUzpvP4fDmyoXefY+AxWeDx47H+5Mq04npQpuaxULLJKt0XvOSvQ5dluG4iDnEIbhnnSkbS0/z6f/4qAsh+A2DNt1884+aOW3OKPLeiVmLMbF7/lq5zOEOhbFmxf77Up9nva0TFDBziVCa+8vxyS57VO4xeG7TPRnb2NoT3cAZlAQXb9cDEbRK+v/enLk8c7EFs1+b5aTj5oy7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NV7vTNjluBiHpbscpD8A2c6SVEtmUi4iLALABDeq+4s=;
 b=gMwlKIHUTJamIUYZzFd7ui9GMhOUpj6XjyBs2QdPENT4IGAxWM3DQGDQV5qPbw78GY9sIxWrDIzOYcWzNc1S7LIMPycoxVMGQhH8goBeQi3/fPAGMdHXZKR/+OXYQloRRZoGrNlp52D+a2sx1Le08+kU1dg9/bDzB4Q3NfsBfyF0T6ydYvtM9suLEkrDXulKHzqsRvIOR9xckqQCkkHJZzQKzLBvwZZAEtlOtKq61U1XMMCoMrEVlZ0XQ/dN5q1iGQ87Fh1jEtn0bJEw4PUalxKE9mUm3lkO4f1vx1XEUSyVsldCF1EcivDVR5zuWq1yc9NIqXBhuFLQC49GUvdC+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL3PR11MB6340.namprd11.prod.outlook.com (2603:10b6:208:3b4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 10 Nov
 2022 02:45:52 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ad39:e00a:a7cb:4ada]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ad39:e00a:a7cb:4ada%7]) with mapi id 15.20.5791.026; Thu, 10 Nov 2022
 02:45:52 +0000
Message-ID: <6eadad92-69de-1477-a564-90b90c046438@intel.com>
Date:   Thu, 10 Nov 2022 10:46:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v6 2/3] vfio: Export the device set open count
Content-Language: en-US
To:     Anthony DeRossi <ajderossi@gmail.com>, <kvm@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <jgg@nvidia.com>, <kevin.tian@intel.com>, <abhsahu@nvidia.com>,
        <yishaih@nvidia.com>
References: <20221110014027.28780-1-ajderossi@gmail.com>
 <20221110014027.28780-3-ajderossi@gmail.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20221110014027.28780-3-ajderossi@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::8) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|BL3PR11MB6340:EE_
X-MS-Office365-Filtering-Correlation-Id: 378ea5c8-0c82-4dae-77e9-08dac2c5aed4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9zg8f33iIAWp+fuq73Ftj3hpMdLRBBYgx4sM4OoJMI+JPcGClBODoNPhSAFQVXTJp6Q2WwJjfSZ48tWPrIG16jxScv8w8BJCayPSSoronU0bSjl+EQIalKXgcz3ZKOUHgU/EeFGYlyYeKEba6stN5J0cDHvrnvz7DqGyHQkUO5kt+BduCU+uf0SDn+FsW2xwFI5KpQNhHgOuZ4Q6y4+PvbR4scdpXQtSnzGmPo/T3lOManVAPrTu+9ZXHV5Fl3NixcNpcsPvwvq6sao76i1VsuZk/sbgRibn8onRBeky40I8pM4+8ZO3CTQdaGAUU/NYksE9/hbUUGccCPtP23X5Z1xJvtOiFy7rs0vtj47gL4JQIhTiXVgqf6Ce/vGlNzdc+jgVr488fhVEuo4r+wgi4Y8MtgBMYENU3WZXVXpdWhtkAgiDOIOeRggQg9Ow0VzgzL8LMVEojLFFJLTaOtX19P0z5fS5Qm6RMvnQFuQZD1/1wQISW1ibgp0PqeHwjWa5DcO9SmW/hYC8nnAWgoI6SKOQI+5k5FzPKECw9MS2UT3fsK0ZoA2Hy8+QpbCQh6UFC3TmrNf7Kp5otp1NsRPDIHEbrrcWf23v2XUXlFpIMpbUwVZfEETsgJtJZSANtPJmXB4ub7oYSKkOz6Wd9AYlK7U263cV4mDdwyNePC2Lu4ctnM6AR/5KJvc3zndviE2sJWysM08xg/Bjig0kk6YZzoQb4ax2DAGCnJ25IevVxcHw2skUk2KOkk55YF549crqChwLMuACwFRvxF8Th4GjHlosqabKjbjVIojveCw6YYI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(136003)(346002)(396003)(451199015)(6486002)(38100700002)(2906002)(36756003)(83380400001)(6666004)(478600001)(82960400001)(31696002)(86362001)(5660300002)(41300700001)(186003)(316002)(4326008)(8936002)(31686004)(53546011)(6506007)(26005)(2616005)(8676002)(6512007)(66946007)(66476007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEhBUkFubVdMTmE4SmlqQ1FjdGtDdUJXeHRvV3VuSmFZN0xYWmdMMTl1RHRE?=
 =?utf-8?B?cFM1OVh3NnpJeHVmSmVRcndoNk9JMTNGbzQybTVTbzZLV1h6UWdqc2N5UStn?=
 =?utf-8?B?NTJ5OXdUNytRUksrVDVCMGl1MXQwaXEvT3hidUpTalFTcFZ6TE5paWo0NTln?=
 =?utf-8?B?VXkxTXgvRTdRQzNWRTAyb1R2OEZielNkR0twcEZQcUNIRGZ1Rk4rQk9sUEZU?=
 =?utf-8?B?WW4zNTRIREh6MExEQ1lnUnI0dGgxVFNEMmtBR29FY1lvRmNrT0NhNVV1eFhy?=
 =?utf-8?B?K2Y0YnRHc0l4QWFWYjA2SGFzY3FFOTcxejY0MGw5RzB0clB4TzZZbUR2YTZ6?=
 =?utf-8?B?d1c1cUo2SUw4Z2NvSXA1bS9tQ0JDZEc1TTZKazFRYzZlVGtEL0wzVFZVTEJ4?=
 =?utf-8?B?R2hKQ3BlMnp0S2wvOU1Ud0lweUJoajF1N1RMOVErT29YUFlLLzFNem9sdFlx?=
 =?utf-8?B?K3EyK3BpNzBkRHRLVjhvQ253bjYwclNsdFBvQXcxbTBFdnJDVkIwOElMVjhT?=
 =?utf-8?B?cHBydTJDZGgzdDJTY1BBMkNRRW85b0p3MzcrL3ZSTzlNTGRUMHB3eWJvaEIw?=
 =?utf-8?B?QndzUmdwVW4yL01jV0VmWEhHWmdvL1pwdzB0Tkx0Vk9FRE9zRHJFSGliTXMz?=
 =?utf-8?B?N0FXN1ozRnBhQlBPcTBMM0Q1RFF5Q0tlRmpEM2p5VHo5Ni9mVXFEMHBZeTBr?=
 =?utf-8?B?NkVmTldIcGc3dHBON0d4TWd0K3Z6L1Btb1RwdUVtdWowbHh2UXdvV2thbTND?=
 =?utf-8?B?R0ZBdkZvb0ZGazZxeFZHeXVNUi93RE9INGF4TGY3VitLQnFmY1dTTGpZOTN1?=
 =?utf-8?B?Wjd3UWJMcE5DNi83MkJMNzdsb1RyOVpRL1JTK1ViYzJ5Q3ZqSm1KTVVJSkRX?=
 =?utf-8?B?cEwzU3VUeVFyQ3dWQ21yZ0lCVzZKeDNmVmIrOU5BVHdRM3lMVlE0eDFkMWVK?=
 =?utf-8?B?TFRwd0oybkloWm9Yeml4VjA5dEIwUkYzWnprNjZCd0tGVWRncXhwZitMcGNv?=
 =?utf-8?B?cWxtbU1kSnNRY0tFeVBZNEpCaC9ZSnEvNjh3QjNqNFZxU1F2K1p6S2J2YWdQ?=
 =?utf-8?B?eTBCM2VYMHNwdkVuaEtkTkJ6T2dUMkJNWUNMWFRtWXdqMXg2VitMcXozdVk3?=
 =?utf-8?B?YW41czlvR2VVMTVURGExdVlhYkRwVFJuRWRaaThkMXhSb1R0R3BvQ3ozWkx1?=
 =?utf-8?B?WHZXMGdlRnI5d0Zwbk1yR1NCVVlhNUh6a2VsU1hQOER0N0NZMDZaY2YyMjRu?=
 =?utf-8?B?TkZQSlhaNGVkN3VBV0szSHo1VWU1eVRFUmNLYzVpSzNJY2lzQTdHSmY1Sm5P?=
 =?utf-8?B?TXZXVjZKbndWckJ5U1poSFI5empJTHBIWWx1MHNjOW4rTE9ENVJ4eUxrWXR1?=
 =?utf-8?B?OHU2Z0JiWEFOQTc3OEIvS1RwRkZjeFNiWjF2NGcrdnJiRTU2THFHek5MNEVw?=
 =?utf-8?B?aXVwVmFCRVRQUHpqcmFNNGUxRFdvNFZadGJ6d2V3cXYzUzRucTVGb3JLN1ZW?=
 =?utf-8?B?Nm5IZlJBQ3VaVjZXRUc5bmdvVFRuNnh1eUhGcXBFcmRONWdmTllJYzlhTncv?=
 =?utf-8?B?YTNHZytIekhhb2Zsdkk5S2lEVll2eEprQmhPMi9HcVF5YnV4dHVFVk1CajlH?=
 =?utf-8?B?eEhsbDJSSWRNMFlMNmpWWEVEZ1RqNGc1RUpRK253OFFjU3d1TjJsZDBiTHhB?=
 =?utf-8?B?Vi9tMXd3eE1laGlwVzJGNFJ5UVZ4L1grZUVoMzRpajQ2bWlLYytJUEhCaTJs?=
 =?utf-8?B?NUpMRTZscGVvVkphbStCc1hCYkF3RW9idnFyZkIvdzhJMEc5Z253K1NNR1Er?=
 =?utf-8?B?S0NKMDl4WGY2MmtKS0xhQ1dMNjIxblFWdURrSDd5SHhQSkdCMzNJRzgxV004?=
 =?utf-8?B?ME03SVdUQnp3U28wTUx2UFN3MnlRYkpBb1RUUDl3Znd0NG91V1ludWdvdDZp?=
 =?utf-8?B?cWl4cFBTRHRURXF5OUNpM2hxdnhma2VSK2xzd0FaY0ZOZzN3YjY0VmViaUxD?=
 =?utf-8?B?akZDRXovRVU4dE9qOGl2Vm1FcVFVMjFGUHFuU0lVMnp4aU9MdHNXVUlVYlBP?=
 =?utf-8?B?WjA0OEJ3dUJNam9nY2g3eTZCUDFYbDJQa25rWWg2Nm1xQlFPM2lPelpxb3BH?=
 =?utf-8?Q?hzyhcxvjZVIiecH57CSddAmAu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 378ea5c8-0c82-4dae-77e9-08dac2c5aed4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 02:45:52.6976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Bw1HS3y14ge5ouUEunWpfyZ3pT7iqyXps3WE+YrrTJVp+2zzbGCJcAk9HShv33EyD+FhRPg8a9TU2b8FQutFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6340
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/10 09:40, Anthony DeRossi wrote:
> The open count of a device set is the sum of the open counts of all
> devices in the set. Drivers can use this value to determine whether
> shared resources are in use without tracking them manually or accessing
> the private open_count in vfio_device.
> 
> Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>   drivers/vfio/vfio_main.c | 13 +++++++++++++
>   include/linux/vfio.h     |  1 +
>   2 files changed, 14 insertions(+)

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 9a4af880e941..6e8804fe0095 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -125,6 +125,19 @@ static void vfio_release_device_set(struct vfio_device *device)
>   	xa_unlock(&vfio_device_set_xa);
>   }
>   
> +unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set)
> +{
> +	struct vfio_device *cur;
> +	unsigned int open_count = 0;
> +
> +	lockdep_assert_held(&dev_set->lock);
> +
> +	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
> +		open_count += cur->open_count;
> +	return open_count;
> +}
> +EXPORT_SYMBOL_GPL(vfio_device_set_open_count);
> +
>   /*
>    * Group objects - create, release, get, put, search
>    */
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index e7cebeb875dd..fdd393f70b19 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -189,6 +189,7 @@ int vfio_register_emulated_iommu_dev(struct vfio_device *device);
>   void vfio_unregister_group_dev(struct vfio_device *device);
>   
>   int vfio_assign_device_set(struct vfio_device *device, void *set_id);
> +unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set);
>   
>   int vfio_mig_get_next_state(struct vfio_device *device,
>   			    enum vfio_device_mig_state cur_fsm,

-- 
Regards,
Yi Liu
