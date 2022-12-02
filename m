Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5F0640095
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 07:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbiLBGgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 01:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiLBGgn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 01:36:43 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F31D9D822
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 22:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669963002; x=1701499002;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vVgU3b/gAIZD6FeT8/uWD8EGcaRB8W8HKygNofakfYI=;
  b=JYZ6G6ZqAaA36Jq76bFoAiOFPaODkvvr/MPWBUJCOtfRt8nrih8efndo
   01rhtWXjcEqUOEfL0ijiUS4su/wj/YdzH/r6rKHAfoJgCMu/NDyp2Hwgn
   ZNNjcfOCWnhluGmQlBOFdDYWjjuU3cp6IVBusiQX7Tg2q8FCYny55BNfe
   4remS8lonLvU22KT6B0b4gGSgXNXRWQgtg8DBujxNL7JeEHL46M94ui63
   /T+lJXcHSh2fNZZZ6c/+d+VMl4veDxCIRqq8YVrdpp89IflK+qB5MpT6D
   0tvbCr/SjZ5KEh3cK8gf6D8/0KQjuFbfbBe8GJQQ0KnoeNRxtTVjSo7oy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="402164104"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="402164104"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 22:36:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="644924857"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="644924857"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 01 Dec 2022 22:36:41 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 1 Dec 2022 22:36:41 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 1 Dec 2022 22:36:41 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 1 Dec 2022 22:36:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zpa//gXOfL4Zf1G09Lg1UdsGQhXEYY+uIgvl8E9JGNh99lcAJwBit5+NTAdSmzD5q35GgT5DYIaw1tvv2434I4sBam6zU3TEwooOfD9hnsTpZoYX3aBkY+oizUAvtrgZa5N/aTZ7yY1djaZryVQuThst9fhb2wxF6Wo/uKEFj4aByx3mnYjPGY/MUCk49vfmcE5TAiayZy42SxKPIbE69Utzwez9dRPojuTcJmYE1TFptwyWE0NYF+rvh7U1AeYPNGf1873G2fVc5zp9o5YPjQZbbWzxu6XA2ZlFZVFOCF5i71dkaU7xGjKoVkTxrjw99e9YwmOLXxSvVfiiojPhSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lyNgDqDAmWccCplZTZfFQGmu8YAJ01T95pYwDaCvwMQ=;
 b=dURj9Un5wBKfKqW+EsWwutdpBZ0LuvlG8Df1g7rQSZXMApIRAeFZUVMcz00egNDR+Nd709MkaHX7zIRdYUA+lY5LBZxrkanAbxVJQZK9UmOJUWTvS98g4Co3mgtR3zNILvwIDTrvzj+nJO3CWkZqj8sIqxQhzDurXOoWn63tLRzZK5yCM16obKagxe3iaCNgv85RKG7uRxAyJiFSDjy5oGJD2p8+O9e/sWciAJxJkPqx+9ETVcnQksTNnWB09pUaJAUhB3+WYKD2iXfy9SDYEJP8Z2SH9vusBw/16kVK/DA4QSwdKVDt9E0iA/m/mmMN+q8vnb4vnF2UfLouYlXQOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by SN7PR11MB6852.namprd11.prod.outlook.com (2603:10b6:806:2a4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 06:36:39 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::df5b:7a63:f34b:d301]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::df5b:7a63:f34b:d301%9]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 06:36:39 +0000
Message-ID: <23a0105d-b108-056d-7b4a-1235d5bb8049@intel.com>
Date:   Fri, 2 Dec 2022 14:37:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH 07/10] vfio: Refactor vfio_device open and close
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
 <20221201145535.589687-8-yi.l.liu@intel.com>
 <BN9PR11MB5276C2D8E5AD051D0DF0F29A8C179@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276C2D8E5AD051D0DF0F29A8C179@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0129.apcprd03.prod.outlook.com
 (2603:1096:4:91::33) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|SN7PR11MB6852:EE_
X-MS-Office365-Filtering-Correlation-Id: e83c94a9-3afb-43a1-e604-08dad42f9112
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nmVDLZrLiJAeku/z1YdMnVrd0EEPGXqy0uoZbaDlFxz5FStdVVpT9EzEYIADCS0D9Y32xktKpwb8zA9hzEW37xGrANPKerQ29WQCGLFpAKWlY4fhC72eRIUxzIlR3Uijgjm6KycXH7jN9/OlnybQaO2LflHOG8p5LjkalbIot0n/mdSadNVO9nFFxqwPIx41Yv+Vb5HSV6NinKS01LGff+fZsVWlfuHWZI/uy/q6S7uUNPFLqAJ46RZHBQpnB8jAyaLzN2UVxbWsYXWGCxzk0/76lV6nqYlIG/2sRs/DTCIwW5RwsNcLSne+ltNODwhZkDURbgN6TESg1hZw+Em419of3Cki7U6xga9D1RRFOhko3EkhlcHlsn6kJPMyXy5y6wfPmkJk8zbh8Vfoy9fs/tjor6AIxQufZyriWoLvaDxTEscrC5AzQSSF3M0jWdpF3QclL4a466hrDeJctKeMFMdsJ7iTDglRL3YvPchTaHhSy7nv0aSNokEFaN5xLX5dbWqDsPu3Emy2Q6xOQ274z74LvzDcPsDMQLyaHULIsVcKY0wQfJRR+oPfqU9g/8pFExa/vj5savq1JxfECurAxXxa/XoHFWNJexJYOG1sqRqlvXJKYkM0JZYw4zs+/LqGVWJMzaeZMIBHpzz0z/HQdDGUmb1NRJPX0zKNph6ICvAboRSWVVXxZ2UQmD1LmCjJLgOausgrXALtCLWIIbWJdl11k01CLm4qM8NuDARZ8a73G6x15lvuLSvZFOhRwEQl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199015)(966005)(478600001)(6666004)(186003)(6486002)(6506007)(26005)(6512007)(53546011)(31696002)(54906003)(2616005)(110136005)(5660300002)(8936002)(36756003)(66556008)(83380400001)(316002)(8676002)(86362001)(66946007)(66476007)(4326008)(38100700002)(82960400001)(31686004)(2906002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGhJeGxsa1VEbDkzNmpVZG1Ob05MTm5pL0NKUmRqa0xiOWVDOVJwLzRzZmVT?=
 =?utf-8?B?Zm9jVDhkb0gvVjYwbXQxTDViWmpDWDJZYzR4YnRaQnFaVVZnYm1EWm5sdzVR?=
 =?utf-8?B?UXVGQzVoQmFRNlY5dmRIM2JKV1cwVElDbWFnL0d0TWZHZkRaQy9IYVlyU3VW?=
 =?utf-8?B?WEw2V2FRTldBaitKOERsSlB1RkNZTE5vTE1RazlYdDg5NW1XL1I3cldyazlT?=
 =?utf-8?B?akF0Uk13WUFHVzZEUk9LQ0kwUlRiWGJnOHFOaCtGV2VMa3VZaFNHQ0JjY0pP?=
 =?utf-8?B?Z3NvMiszbVpqSXFzOWtEckEwUlJjQXZjTVArOHRURkNYN3NGWUNOalFJZVhM?=
 =?utf-8?B?VFFVNEZmTmhQUEJ5MWJWOGx6bTcvSTlEeDlwRmpRZTgyckNsSnJSMC9NL0JN?=
 =?utf-8?B?RXVGV1I0Mllsa1Flb1lCSjI5Ry9WTWFoeGN2cWphUWtqeUtTQWhKbGpzV083?=
 =?utf-8?B?NjcyK3NudXA3ZVFoc01XbTVqbUlKd2hDQ2xRY1dCK1VTRHozRjd3TU1YcnhD?=
 =?utf-8?B?SEt4eVQrSzNaOTRDb29TSncvcGZyMmZxQVNFenFVZEZJT3h2MnVsY3k5YmlR?=
 =?utf-8?B?Z3dhUzB5Y2xZc0JLOUxqamVsakU1ZDVVeVNlMHE2MDI0ZGRSK3FrSjZLSVFw?=
 =?utf-8?B?TmxUVVhadllnd041d0JLNWhKQVY3TjZZZCt0RUlSbTJUV0xRME5Oa3hGR3V3?=
 =?utf-8?B?aWlyb1c4RDA5eEhoQkI3UlV1Qkcyc2p6bXJuS2VDR3dsb0dlMmhqc1VmcFdN?=
 =?utf-8?B?VDQvNkdYcHF1NHRmQnhzbFM0Si9FV01lb2hMSWlPcG16cFBMVVRlTWVqVkNI?=
 =?utf-8?B?TkxkcXZWVHRVbTE3WjZLZi9xc0crREFuZmtxQStYN1JCNlBKRXQvVnloeCsr?=
 =?utf-8?B?MFQ0L0psK0daUGNmejk5cTdDSGdFRGh5R1FaL1dvOWxGUlB5dVdDK0ppMnVD?=
 =?utf-8?B?SkhZMlZIYTBpWXBXelNBTlZFVndnZkg0U0JGdnJyMXA2YW5QcGZrTUVvZGZZ?=
 =?utf-8?B?a2JNOU5xTFRiWVFYeC9TUCt0Qm10S25VTUJITGs2VnBZTm9SVlcrVTRqc1BU?=
 =?utf-8?B?MGV6ZWYvZk9VblpDTGlzblA2cWdGbFB3TGs3MjkybXk4R05Oa2FzUGVORzk1?=
 =?utf-8?B?di82MGFSZ3BHWnUwZ2xHY1JmdElNZlgyY3dyVk90SXFTdHpUdXRWL3dHU3Zw?=
 =?utf-8?B?MDgvczBnak5wN0hOUU9DQmNMY0YrbEJFMWM0aHVsRWZra0gyVXdnRjBXOUM2?=
 =?utf-8?B?akxvQzdQMWhHRXZRRWhhN29Yd1VEY3VNdkRuRWFXdjhXZ3ZsLzZyQ1VSVGE2?=
 =?utf-8?B?TmxQL3FPK3NZT0MzanJVaUZyQzh6MDFXZnQxTGVYcDNUSDBNRnZNTHdLdFN0?=
 =?utf-8?B?Z2NRNTZzRGJnTXB2ODhWR0FvMlFCamYxa2I2dnlPTDJUZmpXMXhSMm9xUmI1?=
 =?utf-8?B?RStvblVQRUYraXVhRmV1djNUSEdjRUVTNktoV252OGMrcW82aTZjYmxyT3Q3?=
 =?utf-8?B?ZG5yd0t4QlEvQWpUV0sxT1QvV3BGNzJ0QUlld21TL09nQmFGZ1VkblhMcG5X?=
 =?utf-8?B?aThrMEUrL0c2b0NwbUx1M1BTNmI5eXJzeTVDZHVRelBDN3pCWVViRlZrNC9D?=
 =?utf-8?B?aEF5RUN0a0hDRnBEbW11T1ltMnJyeDJ5MHpCTWdVcmtYeGJsdGdNL3NHTW1T?=
 =?utf-8?B?d1VBU2ROWWxEZkVpb09kRHZqano2YjhnNFAzSXJZaUhDdDFzb3BXNXFjdDlV?=
 =?utf-8?B?RHgvUUZxSTh5QXpsYXJGZE1YMVpJZWhpeXE5UmpuOXlsY2J4ZHNBbkQxOGYy?=
 =?utf-8?B?c3lPMldMekJSdkQ5Q0xSRitoejZjcE5mWFJEcTNuUTdzVEtPcEFsUW5ITTlw?=
 =?utf-8?B?c2tCTGJvRzVieEJQdWlCVnZROS9QR2k0L1BwdVljbUMzbHNOWjBOWFQ4blk0?=
 =?utf-8?B?QWgybGVoVW5pUWkvWU9wTlFzNmdPTzZQa3VLSWk2aGx2a1BFMmdoaWZjbGhN?=
 =?utf-8?B?aFpMYnJoWisxVHA2Wlp3YmI2cGVSRGloMERwbHdia2FuYWtrdVFZRGVuMkp5?=
 =?utf-8?B?SnQrUnYwVFNRbHBKdzZ6REV5T21qSTZ2RnpGZ0hnNWhnUnBLYnloSUVXc2FT?=
 =?utf-8?Q?l64+abC4j+jwdqdZIAL4fe/s+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e83c94a9-3afb-43a1-e604-08dad42f9112
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 06:36:38.9614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XiwefFm4WYgWJRl67GVF2yYjJu3c/AuCSLSAl60dImMXr+eW9JM+Mbg4PK9gRyb7YVP3BLhW3ZKAVXoMFQStRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6852
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/12/2 14:15, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Thursday, December 1, 2022 10:56 PM
>>
>> This refactor makes the vfio_device_open() to accept device, iommufd_ctx
>> pointer and kvm pointer. These parameters are generic items in today's
>> group path and furute device cdev path. Caller of vfio_device_open() should
>> take care the necessary protections. e.g. the current group path need to
>> hold the group_lock to ensure the iommufd_ctx and kvm pointer are valid.
>>
>> This refactor also wraps the group spefcific codes in the device open and
>> close paths to be paired helpers like:
>>
>> - vfio_device_group_open/close(): call vfio_device_open/close()
>> - vfio_device_group_use/unuse_iommu(): call iommufd or container
>> use/unuse
> 
> this pair is container specific. iommufd vs. container is selected
> in vfio_device_first_open().

got it.

>> @@ -765,77 +796,56 @@ static int vfio_device_first_open(struct vfio_device
>> *device)
>>   	if (!try_module_get(device->dev->driver->owner))
>>   		return -ENODEV;
>>
>> -	/*
>> -	 * Here we pass the KVM pointer with the group under the lock.  If
>> the
>> -	 * device driver will use it, it must obtain a reference and release it
>> -	 * during close_device.
>> -	 */
>> -	mutex_lock(&device->group->group_lock);
>> -	if (!vfio_group_has_iommu(device->group)) {
>> -		ret = -EINVAL;
>> +	if (iommufd)
>> +		ret = vfio_iommufd_bind(device, iommufd);
> 
> This probably should be renamed to vfio_device_iommufd_bind().

I'd like to see if Jason wants to modify it or not as it is
introduced in vfio compat series.

https://lore.kernel.org/kvm/6-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com/

> 
>> +	else
>> +		ret = vfio_device_group_use_iommu(device);
> 
> what about vfio_device_container_bind()?

maybe use_iommu seems suit more. bind is more likely a kind of
associating something with something. but this helper is more kind
of using the container. so I chose use_iommu. But I see the value
of using bind, it would make the two branches aligned.

> Apart from those nits:
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

thanks.

-- 
Regards,
Yi Liu
