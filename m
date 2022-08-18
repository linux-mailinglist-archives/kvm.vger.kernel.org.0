Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE251597FF0
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 10:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbiHRIMt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 04:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbiHRIMs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 04:12:48 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C981861DD
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 01:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660810366; x=1692346366;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=IkhB05ybyCBgxB1ifyxBoDOkNUTp1Px+dJudX/0mjZY=;
  b=ESKSxx9IL19793QS1WRJOmgvrKREGQiyoz5aCAHSGh//owXxJ4U1mKDN
   9J7Nj3HOFmWdTJqFtVWhxoklcSv+Nxvsiw+1/evadLttJ4/tiXL9rXngz
   DQKB3dKDOsKY49HVl1eAGhTDDLOyNA3WT2i/kggn/ioJcgX260V8Ge4v2
   5xP5jpRFgiOB5Dc1DzthpwwkYwT2xZWi6g8rm1BYtSTwTHwVC2+MEysBa
   SszE1an2Smk1d/dbHu7CHLx02wFIreVMX5LN6+x3ISbabF3vNsoS1wllx
   yabinHau0WtNvRzY1NbBltlJhGPO3/4spCQVraooRu4zBsHYj3rSZltOD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="272465674"
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="272465674"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 01:12:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="710871186"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2022 01:12:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 01:12:45 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 18 Aug 2022 01:12:45 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 18 Aug 2022 01:12:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cw1JQPFJ5HsPzSrK1wVwpgSXcssgDinTs7taCADKVOO5jn0sE3u55IFZwtBLgCzqMAle+y119qoxPZrYUIjdf34E1hJX/oXqu6orivd4seR8vgOYxerYuOZGwl+sDxoNTPSOTO3BlCon+oQci0k2zk9n9LuHeKnmic71E+5LZBKQwMaKwzt2JdD5X8PrLtM/ANhegBcsHxah8eY04dDwFEoyoDrCI3osdadZyMDJXQVCif5HRSREOYgzLLxV9BOisIFIc6xyS2Anf5+39Y6KqbERFApsJ4JMfAB8M5mtjoYodqpLRXrAnlCW+NiD4uePCulAvFFvEuOJtQjMhDhawQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iQ5xOrqwJUNtxeCipPtIG63U0FuRyY7M0MaVV7R1XxI=;
 b=h7rW9M8VuJxinE0Ss2WJzQqoV/ib4maV9w0aa/Osn+KV9xj4Joo9c17SgHCoUJGgzXZvB56WEpJPdnfsVwKuTPk8wIX0W28rNY+SBr6vSgyEv1u5M2/vQKw9oK5MmzboP2NKYAuflC7ZSng6DS09nUYB9iIZmvpBFiR9b9d9MjQzPcRYuCz/B11rU8uoSdK2Y9cHbvZ7DFXX8wjqfDU3NxU2QaUEl3aHQBoiTQRWK63svlfIRuZFQaLlPNsv9g2QG1A0g74BL+EvNlbZpc3KEN7W3+42m9NLYEjGEr8CCMS/3PYaLH8AqdsO0ekDDnmxP60Sgyb9nJW5urTes9NgUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by MW4PR11MB5870.namprd11.prod.outlook.com (2603:10b6:303:187::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 18 Aug
 2022 08:12:43 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d17a:b363:bea8:d12f]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d17a:b363:bea8:d12f%7]) with mapi id 15.20.5525.019; Thu, 18 Aug 2022
 08:12:43 +0000
Message-ID: <23498829-6ebc-09cd-f9ce-635a17f1b709@intel.com>
Date:   Thu, 18 Aug 2022 16:12:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH] vfio: Remove vfio_group dev_counter
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <0-v1-efa4029ed93d+22-vfio_dev_counter_jgg@nvidia.com>
 <BN9PR11MB5276F9EB0295CBD485A58D308C6D9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276F9EB0295CBD485A58D308C6D9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0138.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::18) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fe387f9-6962-4658-3556-08da80f16d10
X-MS-TrafficTypeDiagnostic: MW4PR11MB5870:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wgmadt5QMPFmgYyN+9l/yzNw7XKXPoKpYUN7iO6ODjZ8Wc1DtWep3ackWlchUcWv8ZkxzAUYtQOpi1ffrQLAJnubpETjXZFNX8WPFCplbfoYd6iCWLZK3d8xhkNinVPdeQ1HqSvVX5JdgGqWT75Uwy9HPQ//tpk92e/V8RN/b3kwDxoEeuGvSdOI2hM7ka5f+96w6l2VZwmDo02SWgN0yH6KtTJJATc3Zn9iliiHHdPlEUaYOED/lH46syP7NZ8Td18fomxLX8y/NgTASA9OpUlLuFM7l9pLpeP5aAZaSXn4VXroy9ogkGt+iQLYHNTBiP+dgME736NR8NIeRqaj0Ixz4G1JaGKXEknC71YrKDyLDliEsslDTqsrMrtnCfF6sYZLs7n1pI/V5hWAzepPz+4fQltomedzPOp20E8y1VWBwh7xMvmFwo0UbZw180XaUmbNa4Be3axJuTeVmjykHm1jLzmEE0qdUMch+aplB8NCg0pVZY0GJIjyvazMAbP72SVAcv+6UlZQLyaMkOLCspL4sm80+kYG+S//9vrv8iIvV76sH6sB3V1LUSFEsyEUabFHgl95/ZAgpNKlHAv4z4ySxy887HoLMdL88w5sQzjXoopYQW/t1dlsLwtteaWrgvkDSkO2NfKqK3WIiqRlgxg8Xdc+AmOdhFdJ3uQB/wvArjK7b7kxH5b6ijuIzMAXRNpPgw0ruGnSPCJux3H6+ixSHbv2rigzA7s/u/fFmD1/E9LVtQR/UG59YcnlgvzQces1B8mPZfyqWBDyqG6r4RlCfUwGeORw81uBpnRf1kQ3uEhmKrvt+Edi9H5ry9vRPN6n7KCNFAEEA+pNSNCi2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(136003)(346002)(39860400002)(366004)(2906002)(41300700001)(31696002)(8936002)(6512007)(5660300002)(26005)(82960400001)(86362001)(186003)(66476007)(6666004)(6506007)(66556008)(478600001)(38100700002)(2616005)(53546011)(966005)(8676002)(45080400002)(36756003)(316002)(31686004)(110136005)(6486002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlRUT1BMOENMQWJjeUdNRTV6QzcyQlRWQlVjeEc2TGZuT0JQcy9KZGxCMis1?=
 =?utf-8?B?MFdRb21NWWdpeUdQZEFFaGdDVnNiYmZjS1JMSWZVcUlRci9NZERxeUE4cTVs?=
 =?utf-8?B?c25QbmlBZGJaQjBMSEtTOVFST05VR0h1ZmJ0Q25Za2RTZy9CcHBsSVA5SmF0?=
 =?utf-8?B?bEcraXpCS3g0ZUJoVExkc0craUZvUURrKzgvMTQ5dnp0YUFBZmdYUndFaFNv?=
 =?utf-8?B?U0hHbmNEeTNpbU9rYWFxdmRWTHoyVWY3M3dyNTl3eS9Tc213aDI1enM0S2tK?=
 =?utf-8?B?bjNUMTVWRDFNYjBKZjFKdkhQV1ZtbG55U3FyVEpGcHBPY1l3NUpVcStTQ3VV?=
 =?utf-8?B?RGNxS1BaM0RZSUgvU0Y0T1AwbmY5d0RGVmd6Rm5GR3pCRTFmNUJXOTFPMUpw?=
 =?utf-8?B?RWVwaUJ6L3dzQmxuSTNPSWZYU002TjBaNmJwQ0ovTWZyWlRIeUw0WFFoenRW?=
 =?utf-8?B?Nm44b002azE5NUE0MmF0RlA0STRDcUd1VVc3bCtwZmYxcFRta010SmVtdmFQ?=
 =?utf-8?B?K1ZBL3l2MnRxRnhmNDhNZ0JhS2pxNUJaYXBzY3B1RHBJTXB0OXdleGhmb1M1?=
 =?utf-8?B?WWFEcWNJWjJGRXlEZGN2MGd6ZDgvaUpLejg0Q0hrWmRFOEMvWUdSMDZGNWRT?=
 =?utf-8?B?OER2Qy9YcU5QdVBhMjRiaDM3ck5mYi9zbmpESG16T0sxRkpLS2Q3L0VlRWhu?=
 =?utf-8?B?MkR6djAwNmVoWUdnMU93U0dSWUlHV0h3Uzc4bUZaVzY5M01xZ2xURHA3eEZp?=
 =?utf-8?B?a2pjZmRiRWtOc1FtZkZSZ2MzemtkSUdxd2pCTVRrQnd2dStwZzljckhpOGdj?=
 =?utf-8?B?ZjVLTUp5Y3dqdE4yR0ZuZCtmVGQ5eTcvRjA3YVEvQXJYK2FCVnlIWHJYZjVD?=
 =?utf-8?B?eElHd21vNlBtbXBnZWRHdjBQN0RCUVhFTWQ2dStxNDhqWUhZSldKcjdSaytI?=
 =?utf-8?B?LzN3Z0hDUEtwdEpIQUtwcndrUms3ODVIdGJkUEtVcTkxRUh6TTcrNUhtSEhy?=
 =?utf-8?B?WE9wNFI3NnRmbzJnL3R5cndBa0hpNlRUamlGbWorbXI5SzVDdEZ3ZE9MZUVa?=
 =?utf-8?B?QkowZ2JpRUV1QXZVU0NKVVZNQlJkVnB2T3U3Zk1uNytHTjk3MFBwd1FIVDZk?=
 =?utf-8?B?aFBOc09OTTQ3alE5Z1dlcll5Q1loNHRDU2tKWTNXWVhWWTVBaVkxRmJjU1pa?=
 =?utf-8?B?aGQ1eTZKM1lvMGVBZ2VMZHFWbHEvcHMvS1NVY25tNHhPQXJzQ2J2Y3N3OWFE?=
 =?utf-8?B?b3RIeXdKTTVkN21NNzN2ZG56Y2p4RmVURXhBWmdJQUhyNVM3QVRhMzNBVHpH?=
 =?utf-8?B?K2gzN3pIT1hPVzhFMmtnYSsrQjkwQUsvRjY2Yjg2aG12M2dyN2NTRk9WcUpl?=
 =?utf-8?B?dGpZazhWcHU5QTFqaUNiRjdqb21KOE1LdTRZNGpyQWVGYnpKZytQaHFKL0dN?=
 =?utf-8?B?bGkrUDFpc24vU3Ezd3hHZWVHZ1BvblNOeXRaVk9uVm5JREFQYTZ4bTdtelVE?=
 =?utf-8?B?aFlzYlRwQS9KOEhFM0FiMlVEZVZhcmNUdlJHQlNEVkRHL3RkcndsK1Qza2tW?=
 =?utf-8?B?VUtISXE5SlVnc0lxek1yQmtVa2xEYm9WczFZQ2hsQ3I2SmIybEJZWFFIdGNi?=
 =?utf-8?B?WE9LeUFnOW5CUEZ0VFFTMk9waVoyeHBIZUxVT2N1VUU5NzM0Wlo4MlJlc2dt?=
 =?utf-8?B?d3V1anZubEJ5ZzFHV0ZYUFkrSHFYdGl5eXJucmtYY1FtaXBUcTVWVVEweTFh?=
 =?utf-8?B?T1ZWVk5rRnprYjlWaHBjU1pvRXF5aytxV01QZW9oTWxPdGlOYVFnNzZjN0NF?=
 =?utf-8?B?Zmt1Y3pGTjdMZEV2cmdmUUFTS2lsbVptM3FjYzU2OXNZbVZ5TzJUVHR4cUxH?=
 =?utf-8?B?ay96T2VMRE5WNXJ4K0RtOTJjcWpLUXI4emtRTGhrdU00c2VGWkxsNGVqYmcv?=
 =?utf-8?B?WkdDWGhvM3Y3YnA3VE8rRXZxS1NNK3JqcFY1aHBrSUFxdk9xc2FWWnprTlpG?=
 =?utf-8?B?Q2t0TFdHVUgyb0FmSTFvMVZQTGhienNpRjVOSjIwbzlFTzRMNUhPTTRZMUVP?=
 =?utf-8?B?YmhIazhTeGREbjNRaHRxOGdwTHJ1dUpnKzVzeWlhc01jZSsxdnhmeUF4bUFM?=
 =?utf-8?Q?rqFolz94oAceqrtfW2ZlSP+br?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fe387f9-6962-4658-3556-08da80f16d10
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 08:12:43.2535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LxQFMmVsRgnvVYifmobbmj8vBxE4KdABWTC3L4VNtK0pcZVjMBBa9h93yBCLW5nbmnFTCcMwhu+vyPxfG3QJlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5870
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On 2022/8/18 15:46, Tian, Kevin wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> Sent: Tuesday, August 16, 2022 12:50 AM
>>
>> This counts the number of devices attached to a vfio_group, ie the number
>> of items in the group->device_list.
>>
>> It is only read in vfio_pin_pages(), however that function already does
>> vfio_assert_device_open(). Given an opened device has to already be
>> properly setup with a group, this test and variable are redundant. Remove
>> it.
> 
> I didn't get the rationale behind. The original check was for whether
> the group is singleton. Why is it equivalent to the condition of an
> opened device?
> 
> Though I do think this check is unnecessary. All the devices in the group
> share the container and iommu domain which is what the pinning
> operation applies to. I'm not sure why the singleton restriction was
> added in the first place.

see if your confusion is addressed in below link?

https://lore.kernel.org/kvm/BN9PR11MB5276F9EB0295CBD485A58D308C6D9@BN9PR11MB5276.namprd11.prod.outlook.com/T/#m42eaf1548235810820d7e2ad1491092c4b0bbcba

-- 
Regards,
Yi Liu
