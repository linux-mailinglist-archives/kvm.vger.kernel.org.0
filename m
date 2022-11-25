Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D360A6385AE
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 09:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiKYI47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 03:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiKYI45 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 03:56:57 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715BE29814
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 00:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669366616; x=1700902616;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=as/8Iog8ODo7n6jeeZpHplWOOOoanIGIPPDdkTx2cv4=;
  b=ZDk8KK458kLP27c5q0eH9DZqYMqKb00x9s/5hvbPSZ1tnZW7j5MM1YH0
   GehA1G+Cj9Oa3lQFaV4IIMVQ3dZYybWEn/uIhuYSVYZMtkrVo6B1GMo4R
   pH6CnHR7YtMS43UD5414PGq8SAi2sDbhmqcpUBQqaPIql04dlP1XJvl3V
   ipTXV6G4eP6IL4d+IB0Sf1B9PVGybg7GVTRXwChcHVcr9F2EzgHqpngxt
   xO1+3olUORGiG4budlPWofmp/g8QMxvbgyQzDfq38Ayk6sU00UFMWNTEV
   L2cyiQ8xcxZzcAhrfr/gkilvgP0u/Ip8/ewPgkNtpWzc/4Rb+x6rTc2hC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="315599301"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="315599301"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 00:56:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="711213906"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="711213906"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 25 Nov 2022 00:56:53 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 00:56:51 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 25 Nov 2022 00:56:51 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 00:56:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mwB6scADeO8rUb5LwgkTyndzvW+8av/MM6l6/VG/77nwQ+qDmSiEDwkwpb//+G0pt7yrZEC+Jx1832xIeDZ/mw1RbHV318O2NAU3ZHww/MVwOVhFacUxZ1Obruj3O2xvO/zSjHsK3qJebxOWpGznOAPDJqsaY2vUTgzaf/jqYnJQPouK7erkg6mnMQF02dq1PZI3kW1qZAKhZdAWWf8gHr7/7ndUR3sOFB4uQFZ26gwW0xKl1z4VD5+uKahqQpcwzcBWnzYE1amiibdfclkxDXGcIY/UkBKKEexXD+d0rOa5Nvz978RndbDPqunYmxUSC7Y3B0cgkO7jWJepFimuFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9Nv+AEmKsNSToXAto1QWNJ0jKs7NnNe7StkNdHzkz4=;
 b=NnojalJTyRfyColuGKmYtOcXullzYHrn1L+raK3nOxfT52Mmw9YEDCnrOQqPIgAMkmJBaPWKaCJIrzvYz96OhqC1OzTWY3Ld9uhHT1038Ufexfr4gf8uyIhXhkEVRlS8Nc6/RQ4oVpDnQG/rpeA8l1QLqJrVYSgHcViZFvlSBefnuP8Fv4c9rxYfZ09pcoc9GL2WVYDOE0QEmpfSTNH68ptOCkVnaTnpwuvLthcJ8QiBwpgp6J/6K0TsNyxi//VI66igOgUfpyRAix6aWB+RQzeyb7+A7qLxRkcrCbvGoTwUAW6/iXt08Q28U9ot6Ndyj4vMsHk6uF2Br+WJ1mPddA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB7686.namprd11.prod.outlook.com (2603:10b6:930:70::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Fri, 25 Nov
 2022 08:56:49 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.020; Fri, 25 Nov 2022
 08:56:49 +0000
Message-ID: <955100c9-970a-71a0-8b80-c24d7dbb35f2@intel.com>
Date:   Fri, 25 Nov 2022 16:57:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC v2 08/11] vfio: Refactor vfio_device_first_open() and
 _last_close()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
        <eric.auger@redhat.com>, <cohuck@redhat.com>,
        <nicolinc@nvidia.com>, <yi.y.sun@linux.intel.com>,
        <chao.p.peng@linux.intel.com>, <mjrosato@linux.ibm.com>,
        <kvm@vger.kernel.org>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-9-yi.l.liu@intel.com> <Y3+GHbf4EkvyqukE@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Y3+GHbf4EkvyqukE@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0006.apcprd06.prod.outlook.com
 (2603:1096:4:186::19) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CY8PR11MB7686:EE_
X-MS-Office365-Filtering-Correlation-Id: df651e70-550c-4d27-e362-08dacec2fd38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8a2JrR89uArHCMA5AiJt3ltQhWcI2HVN2VT+TUS9o1N3yA4K9Li+Xo/pDGNAbrvN79sK4Sq4IXdwLXdXZspx5Vj+z1JAuouLx3hW+6Lar8Vb+tVFDECmo6K3wyieHRkqd9nlbSKuFFF5/KB1b7uo/yQLC/D+K29W+zGnb3FxpCC5i1umeV3axTdmD1yJUEmTtkRhGHJHbK9QlzvlDWVSSiTLZAcY8JNUnTEk8aXmMEnOfw17l/NLXwAP/HiijawD3Qo8MnWfw0aqLXyc7Mk0cmERsvhNAGl9Z5rB+d1fPGgeHAgpJrfyknCUfE6W0qAW/3/DY7YmoJyNs1OiihUSGy1mp2i0qmdWlYyowKFfZs8CvL/gW66HQLEhjWrxgpmumgucJ3Y7SUsszsXF3fia5gvvmwyAlw0va6jZerieXwhomYdxfGxV5AcnuXrhZYt96t0oRCpQOQE81bJQVxUXLWApMBDT8KFl8m4Zb7sdttP25NFuZw+c7jYL+LWp5i/A/GTPdPxmu9Mb4BX+K5iTULsD2HpTUTjNX+8f60OG+9E0r1bV/JEL5lIzpmSUZTJ+K7QcBK9O4sJFrw6K0l9fK2Zyu6jge5BKLMm0hHDZo5T4667t5lB1DOK6YlZG3kWnhqmTH6XoV71RJzgcti82y0fUHhTK3zPB8CIwh+A4n96f6EPoifkYXmKbYRa+O32Mn7k5akESusE5liP48QywTkt69ZY6fWp289FfK/C/xMI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199015)(83380400001)(66946007)(2616005)(4326008)(66556008)(186003)(66476007)(478600001)(8676002)(6666004)(86362001)(31696002)(6916009)(53546011)(316002)(36756003)(6512007)(6506007)(6486002)(26005)(8936002)(31686004)(41300700001)(38100700002)(82960400001)(5660300002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nk13NWNMMzdHNExSeGZrUnY3UThBV2VxWkdoS3hLZzNHQU1wbmhYT3BXL0w4?=
 =?utf-8?B?Q1VkT1c1UkMvbkFoMk9SNHVnbHF0K3JDSGNpV0lvMkhKYnJtVEtaUlFQblRH?=
 =?utf-8?B?eE1EWlFXbjRlNzliZ041cGJ1U2RIT3hPTG1sRnQwSzBsZTNYTzJJTG5NYmpp?=
 =?utf-8?B?eGNxU0E0QkxIS2VpSkZQY05YMTVZTk1xVXNVbXZ0eVVsZ1hQaTFwV0thS3pr?=
 =?utf-8?B?bHBSRTJyMWtEbm8zT3gwOFVxWXFpaDNNWjNzOGFaTzU4WUZ4S1dNUzcyTUJu?=
 =?utf-8?B?YitpUUxXcGVrWEpDYjlWZCtiZERoaWRQSFdENTNYdFpiQUU3REhVYXY1SzFo?=
 =?utf-8?B?RTA0Y0oxeldIT0xrNGUzazRLUlNjRHdadDkzZ3R5dkJqRFUvcGdZTHJ0S3lj?=
 =?utf-8?B?MFRHbWdDNlR5TXcyNWs4eU1Mbklvb3E0OU53OThkSU03UzcxNFNkTk13OHpS?=
 =?utf-8?B?a20raGhWenNHMkt1SFFodXdTR05OTi9lU2VrcUMwS1JtL1pCMStoTTdRYjVl?=
 =?utf-8?B?NDBQSHQ4Uzl6MFMzWkZmVXhXV2U1OGtnUU9HRER3eTJzY2NvY2R0L1VmK0pG?=
 =?utf-8?B?SDhydEcyclNtQkdDQmlzUi9ocWR6M0xwNmN2bzBZZC9WRVgwdFgvMThMSFpB?=
 =?utf-8?B?RlhRc0lPaVIrcVY2bHQzeGFVNnF0aTlwUXhsNjd1dWNQeG5TcjVtZUhUZjNp?=
 =?utf-8?B?QXlJd0pBdmZOa29DWENIYXBDZ2FtSWpaRzVmbDlPZ0NiZitzT212ZUVVTDcy?=
 =?utf-8?B?SFlORWtrVE5Hem92NXYrVXF1eXFZMWc0eXBzKzFsdVpGVDNBbERGYkQ0THdq?=
 =?utf-8?B?c2RTSlQrQ2kwbml1RXdadGhHMHY4eEVjQ1o4cGFYV1orZHdlcFBzUFRzYVdH?=
 =?utf-8?B?ak9ISmNLb1FYd0lWbFhjYXV4ZUxxMSt5clNqSjRhdWErV01nTmtpNTkyaGF5?=
 =?utf-8?B?ZEtSQmhlUHoyTk9oU2JLUk5YS3huYXcrRTRKQkJtZTM2N3V5ZkM5TUNpQ3ZL?=
 =?utf-8?B?ZEhtWHdMaE42UzhXdEFXZURxelg1a1ZYVERmVnlvVXBZMGF6SEw5aTNhcUVy?=
 =?utf-8?B?WXdFWlE1cnVvdGdHQmkrZlJBYnBFQVhOMjhFV0NYR0U3OXFwUHpjUVNqdHB2?=
 =?utf-8?B?S2xvSmNiNjRFSENUeTFCSDB2TkpDNkQ3bkYxdTFCRXhKM2RWbFZjbmxLSHMr?=
 =?utf-8?B?SStWWjl1ayszTTRhbjhSc2ZsazBEcUlsU2NoNXFxM0hOQ2dBak1pMjFiem5z?=
 =?utf-8?B?OU5ScGJMUHpscE16SUM2VXpKSFlJZDBaWENRcUdrTWRRaTJDSGV6TTMxLzly?=
 =?utf-8?B?KzI2ZzJtMnhkc3JvY0RtYmZremZjTWRwWTRYSlF4dVRadlpSUmhZN1R6NjRt?=
 =?utf-8?B?MVYzTHdMTlMyaEhmbjdVdTUvZTlZbG1WclVPdzk3QlVCZTNGbllDWTNFVjdx?=
 =?utf-8?B?MFg5SXRqY0UySzBJa3pYSlJoOVNuWE9CVjEwblRMbEt6V2VUeGtNZ1llWjUr?=
 =?utf-8?B?QWpyeUJoOTZNUFR5UENIUi83RHk1alZ3cVN2dE8rcDdRcXNwMUNIbFJoSmJj?=
 =?utf-8?B?VDA3UmtMVStmclNjV245UnQ3SU8wekE2N29Pb2VyaFJQTndZcDMrYnNrQnlv?=
 =?utf-8?B?V1padVBSOHc2Z045Vk5HcTVTVFhUa2R2cU5wbzZqVUp2VFBxNzRNVXZYUm1T?=
 =?utf-8?B?YkF0Z01HRThYY0tiN2kzSXQydU1OMGw4NTFzTEVNQVBEN0dPTlNOaGFqVUlF?=
 =?utf-8?B?YytQV0d0dlF3RzlXcTNIRFQxcmNPS1R6Mlk4S1MxM1JzbWtiY0IxWFRXa3Uy?=
 =?utf-8?B?MVJFY2R4ZGszQ0k3amY0cWYxTytpYUFTR2hxZ3hseU9wQ2dvSE5tYlgwS0dh?=
 =?utf-8?B?WFBaRkJ5bGRZc1ZVd3Y1cE80eXRoSHJIVTNTYk9RZ2tUU1ZyUWpYS0JOTmht?=
 =?utf-8?B?bDlsOUdPb1FxZE44RG81ZFNUellPVzVydEluTUFsMjRtUzVsVVFkWFhPbWlw?=
 =?utf-8?B?UU4vdG1VN0hKZTd0QTBVM2dEanBqQWk3SXEzc2p3eFd3eFNtYlEzQVpkRVlw?=
 =?utf-8?B?L1NJZzRSM2xuekJ4MXZNc0dwYUcvaTRMZk5EdHJQRk80MSt3c0RVbmZTV2x0?=
 =?utf-8?Q?+pxHyDHHP7CUVLNiIn60Nj66p?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df651e70-550c-4d27-e362-08dacec2fd38
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 08:56:49.5093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J6usQxr3KEcsYdDBu4qAyevCb56AeQwDKMxrcGhi8rPmmD2PBH5fmYTMk3U3mYqWrMv8ZpPvpivhOWHV4BhM3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7686
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/24 22:56, Jason Gunthorpe wrote:
> On Thu, Nov 24, 2022 at 04:26:59AM -0800, Yi Liu wrote:
>> +	kvm = vfio_device_get_group_kvm(device);
>> +	if (!kvm) {
>> +		ret = -EINVAL;
>> +		goto err_unuse_iommu;
>> +	}
> 
> A null kvm is not an error.

makes sense. vfio not only serves for VM but also userspace drivers.

> And looking at this along with following cdev patch, I think this
> organization is cleaner. Make it so the caller of the vfio_device_open
> does most of the group/device differences. We already have different
> call chains. keep the iommfd code in vfio_main.c's functions.

ok.
>
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 3a69839c65ff75..9b511055150cec 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -609,61 +609,32 @@ void vfio_device_group_unregister(struct vfio_device *device)
>   
>   int vfio_device_group_use_iommu(struct vfio_device *device)
>   {
> +	struct vfio_group *group = device->group;
>   	int ret = 0;
>   
> -	/*
> -	 * Here we pass the KVM pointer with the group under the lock.  If the
> -	 * device driver will use it, it must obtain a reference and release it
> -	 * during close_device.
> -	 */
> -	mutex_lock(&device->group->group_lock);
> -	if (!vfio_group_has_iommu(device->group)) {
> -		ret = -EINVAL;
> -		goto out_unlock;
> -	}
> +	lockdep_assert_held(&group->group_lock);
>   
> -	if (device->group->container) {
> -		ret = vfio_group_use_container(device->group);
> -		if (ret)
> -			goto out_unlock;
> -		vfio_device_container_register(device);
> -	} else if (device->group->iommufd) {
> -		ret = vfio_iommufd_bind(device, device->group->iommufd);
> -	}
> +	if (WARN_ON(!group->container))
> +		return -EINVAL;
>   
> -out_unlock:
> -	mutex_unlock(&device->group->group_lock);
> -	return ret;
> +	ret = vfio_group_use_container(group);
> +	if (ret)
> +		return ret;
> +	vfio_device_container_register(device);
> +	return 0;
>   }
>   
>   void vfio_device_group_unuse_iommu(struct vfio_device *device)
> -{
> -	mutex_lock(&device->group->group_lock);
> -	if (device->group->container) {
> -		vfio_device_container_unregister(device);
> -		vfio_group_unuse_container(device->group);
> -	} else if (device->group->iommufd) {
> -		vfio_iommufd_unbind(device);
> -	}
> -	mutex_unlock(&device->group->group_lock);
> -}
> -
> -struct kvm *vfio_device_get_group_kvm(struct vfio_device *device)
>   {
>   	struct vfio_group *group = device->group;
>   
> -	mutex_lock(&group->group_lock);
> -	if (!group->kvm) {
> -		mutex_unlock(&group->group_lock);
> -		return NULL;
> -	}
> -	/* group_lock is released in the vfio_group_put_kvm() */
> -	return group->kvm;
> -}
> +	lockdep_assert_held(&group->group_lock);
>   
> -void vfio_device_put_group_kvm(struct vfio_device *device)
> -{
> -	mutex_unlock(&device->group->group_lock);
> +	if (WARN_ON(!group->container))
> +		return;
> +
> +	vfio_device_container_unregister(device);
> +	vfio_group_unuse_container(group);
>   }
>   
>   /**
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 3108e92a5cb20b..f9386a34d584e2 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -364,9 +364,9 @@ static bool vfio_assert_device_open(struct vfio_device *device)
>   	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
>   }
>   
> -static int vfio_device_first_open(struct vfio_device *device)
> +static int vfio_device_first_open(struct vfio_device *device,
> +				  struct iommufd_ctx *iommufd, struct kvm *kvm)
>   {
> -	struct kvm *kvm;
>   	int ret;
>   
>   	lockdep_assert_held(&device->dev_set->lock);
> @@ -374,54 +374,56 @@ static int vfio_device_first_open(struct vfio_device *device)
>   	if (!try_module_get(device->dev->driver->owner))
>   		return -ENODEV;
>   
> -	ret = vfio_device_group_use_iommu(device);
> +	if (iommufd)
> +		ret = vfio_iommufd_bind(device, iommufd);
> +	else
> +		ret = vfio_device_group_use_iommu(device);
>   	if (ret)
>   		goto err_module_put;
>   
> -	kvm = vfio_device_get_group_kvm(device);
> -	if (!kvm) {
> -		ret = -EINVAL;
> -		goto err_unuse_iommu;
> -	}
> -
>   	device->kvm = kvm;
>   	if (device->ops->open_device) {
>   		ret = device->ops->open_device(device);
>   		if (ret)
> -			goto err_container;
> +			goto err_unuse_iommu;
>   	}
> -	vfio_device_put_group_kvm(device);
>   	return 0;
>   
> -err_container:
> -	device->kvm = NULL;
> -	vfio_device_put_group_kvm(device);
>   err_unuse_iommu:
> -	vfio_device_group_unuse_iommu(device);
> +	if (iommufd)
> +		vfio_iommufd_unbind(device);
> +	else
> +		vfio_device_group_unuse_iommu(device);
>   err_module_put:
>   	module_put(device->dev->driver->owner);
> +	device->kvm = NULL;
>   	return ret;
>   }
>   
> -static void vfio_device_last_close(struct vfio_device *device)
> +static void vfio_device_last_close(struct vfio_device *device,
> +				   struct iommufd_ctx *iommufd)
>   {
>   	lockdep_assert_held(&device->dev_set->lock);
>   
>   	if (device->ops->close_device)
>   		device->ops->close_device(device);
>   	device->kvm = NULL;
> -	vfio_device_group_unuse_iommu(device);
> +	if (iommufd)
> +		vfio_iommufd_unbind(device);
> +	else
> +		vfio_device_group_unuse_iommu(device);
>   	module_put(device->dev->driver->owner);
>   }
>   
> -static int vfio_device_open(struct vfio_device *device)
> +static int vfio_device_open(struct vfio_device *device,
> +			    struct iommufd_ctx *iommufd, struct kvm *kvm)
>   {
>   	int ret = 0;
>   
>   	mutex_lock(&device->dev_set->lock);
>   	device->open_count++;
>   	if (device->open_count == 1) {
> -		ret = vfio_device_first_open(device);
> +		ret = vfio_device_first_open(device, iommufd, kvm);
>   		if (ret)
>   			device->open_count--;
>   	}
> @@ -430,22 +432,53 @@ static int vfio_device_open(struct vfio_device *device)
>   	return ret;
>   }
>   
> -static void vfio_device_close(struct vfio_device *device)
> +static void vfio_device_close(struct vfio_device *device,
> +			      struct iommufd_ctx *iommufd)
>   {
>   	mutex_lock(&device->dev_set->lock);
>   	vfio_assert_device_open(device);
>   	if (device->open_count == 1)
> -		vfio_device_last_close(device);
> +		vfio_device_last_close(device, iommufd);
>   	device->open_count--;
>   	mutex_unlock(&device->dev_set->lock);
>   }
>   
> +static int vfio_device_group_open(struct vfio_device *device)
> +{
> +	int ret;
> +
> +	mutex_lock(&device->group->group_lock);

now the group path holds group_lock first, and then device_set->lock.
this is different with existing code. is it acceptable? I had a quick
check with this change, basic test is good. no a-b-b-a locking issue.

> +	if (!vfio_group_has_iommu(device->group)) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	/*
> +	 * Here we pass the KVM pointer with the group under the lock.  If the
> +	 * device driver will use it, it must obtain a reference and release it
> +	 * during close_device.
> +	 */
> +	ret = vfio_device_open(device, device->group->iommufd,
> +			       device->group->kvm);
> +
> +out_unlock:
> +	mutex_unlock(&device->group->group_lock);
> +	return ret;
> +}
> +
> +void vfio_device_close_group(struct vfio_device *device)
> +{
> +	mutex_lock(&device->group->group_lock);
> +	vfio_device_close(device, device->group->iommufd);
> +	mutex_unlock(&device->group->group_lock);
> +}
> +

above two functions should be put in group.c.

>   struct file *vfio_device_open_file(struct vfio_device *device)
>   {
>   	struct file *filep;
>   	int ret;
>   
> -	ret = vfio_device_open(device);
> +	ret = vfio_device_group_open(device);
>   	if (ret)
>   		goto err_out;
>   
> @@ -474,7 +507,7 @@ struct file *vfio_device_open_file(struct vfio_device *device)
>   	return filep;
>   
>   err_close_device:
> -	vfio_device_close(device);
> +	vfio_device_group_close(device), device->group->iommufd;
>   err_out:
>   	return ERR_PTR(ret);
>   }
> @@ -519,7 +552,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>   {
>   	struct vfio_device *device = filep->private_data;
>   
> -	vfio_device_close(device);
> +	vfio_device_close_group(device);
> >   	vfio_device_put_registration(device);
>   

-- 
Regards,
Yi Liu
