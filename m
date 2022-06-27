Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87E655C7BF
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbiF0Hpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 03:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbiF0Hpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 03:45:33 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A25560D1
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 00:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656315932; x=1687851932;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fRaFf5FFUefQjbvAQ3dsPwaZnUfn0jTxVwoLC5Eyqlw=;
  b=KGx2Y+WjegFrxfI9zeMI2ip2houiAx93uMovet4G59ut5j5QTxamm0qK
   5PFjjMzxFBoXMbpzekz2sq7ENHIC/6wvjmhaVNpHNko9HMK3EzFwg3zwz
   evyyXad58wCyM4UZS5UblEFms/HKZDmk091x52wz6fkeuIhyN1pUjftDk
   ehq1yG3ux+Cy/BW5MPo4IkkjsfBT8bXR8XE0NNcK4TOCVkHddTozC3t+R
   lQHqllNy28fqhrlF5lHJhbs2igogAvPLA0EvwlM0l2begBLujrSIT0H1W
   Ek9CYKoT2UuYT5cg+DnP6uwcFboU+j+HkeksUT4JvCVkVcBWl1pH57zf2
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="261801853"
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="261801853"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 00:45:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="766511455"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 27 Jun 2022 00:45:26 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 27 Jun 2022 00:45:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 27 Jun 2022 00:45:26 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 27 Jun 2022 00:45:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfhClDbwR2fG9lhL0rVry0Qz6YLx+jVN3YReXDz1M0c/0zwZfc9sdb6KektboNRvJ3G+PUaOwevVJct5Z6eFJjy+Br3bz1NST92xxkBwJX2oWfFXEsiSmI4G2pXU3lJgH6if4rsz03a3dbGldc/G196unoa3SKsdk2fhLGH8F6edHpoIPdpBFlvGtJe1UJkcuta6PWhy59zdgIk7uWhFKq5QJCQT5AW0/t2GUBcbzyJduyKKqTaMYqgBWYAE7TvI9gGfW94iEMXtrcPdyPAIZT1rVq+8bzuXpOfSplGRg7r5kub6kzEZxDMSdht5K9iwu3MfyAaltMyhRCx7zulaDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oq2rAWgpIvCYFPOMme0hrghQlIitElkmvYNf+4r5EGM=;
 b=SdteItvmTK5QDVD5RuraDvhb2iWFxQwIaX2PJ7sHLlRwDDDmPa4vj+M22HuMlaZzz9AxEiXYP4JU2i1xZeNIFa1Rj7jvap74+X1ZcfZTaS9g0cZ2rbRG7tzX+2ebhhq7eDuM2uofA7m7yZwwB32PESxbGvywP4tZUTitrTRK381XqmXr+I6KueVj/BG5/3bkgkZO0Yz5GdkdVGo+a/GeOwdot9WlUwPoSpXc/QZ4sBC8Kn9Cs7YALAnpWhHAuwRwqY803n+5ih2yVCoeiplHokyuC3g0DEhWoaKTs5dXbenJFgVMeUDG4dzAmpYyWS1AvPXvjMbIqQYRR8PCkGRW9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by DM6PR11MB3355.namprd11.prod.outlook.com (2603:10b6:5:5d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Mon, 27 Jun
 2022 07:45:23 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::ddfe:6c7a:c13c:cbe3]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::ddfe:6c7a:c13c:cbe3%2]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 07:45:23 +0000
Message-ID: <713d2cb4-caad-66f5-246d-9243972cf969@intel.com>
Date:   Mon, 27 Jun 2022 15:45:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [Patch 1/1] vfio: Move "device->open_count--" out of group_rwsem
 in vfio_device_open()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
        <kvm@vger.kernel.org>, Matthew Rosato <mjrosato@linux.ibm.com>
References: <20220620085459.200015-1-yi.l.liu@intel.com>
 <20220620085459.200015-2-yi.l.liu@intel.com>
 <20220624140556.GP4147@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20220624140556.GP4147@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0142.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::22) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae5f949e-6f1e-4416-c4cc-08da5810fde8
X-MS-TrafficTypeDiagnostic: DM6PR11MB3355:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WE8i7O3sRdLJMYjmqeUV0X/neUsz9TYeuBIE3uI/+6eHMCzLDANmEiO/Ot/y8IawWjCJEskwkuzZKcqLqofh8i9vLO4kMDQZYuR9p1th8pWEk1Tm0aCnEZO2JB0DDTW5qUyo+XyC+W0BYbG8E0z46/gBbIEYHnmS6M5izCVANJgAx3iTM2WRbXby5Odq5tgyFIBzjlBidms2pIvBeC5/U+ef6m46/N7iAdGJ5JtfW4VsskmmS/Y+Kz70zb+G1BUbSSOMxchlKHFsjmrZwRCB/O6NdxHk9evGMb3FHjxF1Y8qUivbs2eHXYY3xZ7aIqeS86yNipkS0+5rlZE45dvftMRCJ5MsHACZPZO0qSum+S5cQiWqBxA/E/g/hp35tiDQtYWN4AP8dJE/tI57ISLWvtm8Z7Wx7SOc8jlD0Ctoy0c+PHnxutWg6Nk9gh2sLl6ODksE1JSUWrXz4dW9EUyB9uPT/FuVuldWvN6PX4UAOfh35cuxO1yGZLnvDXXJliRMm4P7gyvNvMy2JgwzoogniXYg0FpxZq3Xtbjk3dT5qnYPuzQy1T0FEVVwKuXkF8q6PXsir0x4pkD6Hds2TF727sbUtZFdB+wwe2xx8JzuaTX1b7k5jJc2aCNYb2TsPYNwMNvymLTvPGsNiFYod7Z03zO8VPTrj+Cxoqkydy7hruF+OXagnrDjorIi91RivoUuwom5kb6ZbirJpgMU0tLZ7pemmf6U7VaTVl4aOVL+RzRCuFw2baSv9dNN9axwKelThKt9jxFJOa+ck/if/dNMfImbB9ZGGYCGhDwlY5OqoCRmYuaK7DU8zIXZZYtQLsN5sBAK1Ja3vxLlL5ogOYEeow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(39860400002)(346002)(366004)(396003)(4744005)(38100700002)(31696002)(5660300002)(2906002)(82960400001)(83380400001)(316002)(8676002)(8936002)(4326008)(66476007)(36756003)(478600001)(6486002)(53546011)(2616005)(86362001)(6506007)(186003)(6666004)(66556008)(41300700001)(6916009)(66946007)(6512007)(31686004)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akNnNXVFSlhsMnlJMmF1WnJndTBWY0psZTJEWTdMbEtOc1JPaStoZ1kxRnBU?=
 =?utf-8?B?NjhqVnZkRlFzMWtyclBKUDdvUE1WR1E2aTEvTVpjMFcyc1U5OTdSVjhXaG5z?=
 =?utf-8?B?Ris5VURWZkxhZktKUTF2YmdidDJLZFlGSWNUSzRHNFF6Z2o1M1pjeE1XWjN0?=
 =?utf-8?B?b3BGWXp0UWgwVWEwenpCclBEaGg0OXFyMzBzU2FlZUFRdy82dGZsTzJKN0ps?=
 =?utf-8?B?LzB2YUtidHRoUVBYYmVPK0hRcTRBcWlSRXRGeTcrd05TS0dhUll6YlZSbGFP?=
 =?utf-8?B?UzMvdm80YnBjc014U3lJZHJROG5jNEtlWFVYMXE0NTBJc21HQW1TM2wwU0pD?=
 =?utf-8?B?Y3NUNEYyOWRUZ1B5RHdxUXdPMDgzL0UvMmJsK3oyd09rWTNNUXBaelpQaUxH?=
 =?utf-8?B?enpwd0RwR1JzNEp3eTBGQlVMVTlSOW9mTHJobjZSYVF3UjNQUFhsVWNubFpI?=
 =?utf-8?B?WUw4VzZLZ2hQVUpsR05tK0hLKzhMWHYzUFl2OVdkd0RWVHRicTZ6VzhuVzhv?=
 =?utf-8?B?YTBZZFIvZ05GM2pZQm9Dakcrb2FyTnF3WFBhdDhJVWwvYkRSdVpOTjBWeGhn?=
 =?utf-8?B?eDNhV0dYbE5UUStFczFCTUNYUWxNTHZhRFAwODQ4U2VuNlUyYm13bG1qckM0?=
 =?utf-8?B?Zi9QYzR1NEdyRHVxVzdmdkQyL2hhZE02SkF5VkxIT3ljSDJXMjhTZHZ0ZEFN?=
 =?utf-8?B?cnR2QXZFdWRxWXg4MG12OU1oSmw3dEE1bFFtODBXVUZPZEJaNjh4KzFNbGNp?=
 =?utf-8?B?MGhCMGZUbGRyQU9jenc0a081OVNaWlVzVXhzc0cwWlNVeHdoY1M3ZENEQ1Fw?=
 =?utf-8?B?NHdLUlo3Z1Y4aWF0YWpRc2MxTnYxbHRiOEwvc3MyUm5QSEs0Vll2TWNTWjV4?=
 =?utf-8?B?ZFZicmVDS0VFLzdQcW9XYVp1M0FBWi9xR0FUelFPTGlaNUx4YmlrZ2Z5VENi?=
 =?utf-8?B?RVllK0JHTWdIdUtwYlJYMFFtNjllYjEvNEszVSt4OENoK3pOV0RHYmRJRlNz?=
 =?utf-8?B?aWlFZlRMeVpkdmEvTHkzUmEzdU52emh5UnhRa2tDMSsxRnVDZ2RSbU1pSFBD?=
 =?utf-8?B?STJ6TnFFaFBMM2VFd0ZqR3JEMll3NFU1Z09HaVZPRXU2dTNjRjdGcXFYMSts?=
 =?utf-8?B?aFBxMkszN0F0WXVFZGtUdVZlcDFDQlQ2blMvOVVGNmh2ZFVQS2JCUEF1MFhB?=
 =?utf-8?B?SkdJS1VYSE1STE1Eek5XK2NYeHVDenBSTDdLMXU1RUNoZGZyTE1uS1pkcTJI?=
 =?utf-8?B?dzNCYm43TUpheWNhZmNzU3l6YTBHSUVrTk5PY1dMYnFpSk5rbStCWEkvVk1J?=
 =?utf-8?B?RTJhVVVhZTI1ZzkrR243cEhmT3dLY0ZjYzZUcFMvaitCVDNWTnZiaHlYZnhF?=
 =?utf-8?B?ZFVWMXA5Rm9ERXltVXhldnZqWDJaTjZ1ZVBZV25kSkZiOVhwZ1JPbFVmeExG?=
 =?utf-8?B?THRtaG9rYUZ3QTVZR2xzdHF5YVpPbDA0bzc3NnFhblprcFNqcFk0WE1wNmdE?=
 =?utf-8?B?YXg5bEtkZC9hRG9KeDV5RHFLb1g5alAzcU1VRnZuWVJPTDFCelBoRFR6dEhH?=
 =?utf-8?B?NGYzWUlrSzJLSXVDcmhTUFpFK1lBbmVlMkk2QTRkQXYxRGxEMGNaaDRnYVc3?=
 =?utf-8?B?OE52bnp6dWhHSDJLMklXRnJsd3BMVUdIN3dSZWdaRi9oOXJaRTZCZmxLVkF1?=
 =?utf-8?B?dmRzVnlpUjgzSThEU2JldzFoeHg3cEhCQWI4Y2xCcUZIUkt6T3VNUkRLWjZD?=
 =?utf-8?B?endUa2JUYWdBZHYvbkRMWWZYYkthc1pXb3lxTmJ2VGVmTHJtWkE2aExrU0FU?=
 =?utf-8?B?aXU4dkxMNjhxUEJ0clJ5V0IwOVlncWhnVG9KN2NVNFd5djNFZldOQWdKVFk1?=
 =?utf-8?B?VmZ6U3U5YkJrcHpDdXVBYVhmMUltYll4TW93OGZrVVBZL29WY25FSTZMSnVr?=
 =?utf-8?B?L0tCeUVFcEplSDZ6enE1b1pSYlNBVFYvbnZpOUhrZVB2K1dFMkxLYlhiaWE5?=
 =?utf-8?B?R2UrZWRvNC9VcDJQNzJxTE5BVU5xVlJEV0tuVFJ0d05WY1duMDU4RnkzK1Ar?=
 =?utf-8?B?WW9jYmNoVUJRNUFhWjBLT05mZGlwb2k2aExWYWFBMEg5Mk9GMjN3T1RmTVoz?=
 =?utf-8?Q?+OL1INxVQBpuzJFJ37hiSr4WZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ae5f949e-6f1e-4416-c4cc-08da5810fde8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 07:45:23.1785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nk0t+EadbmvJVP0vPKNSGN2o6wNRcDlZcbAleqOdOS8T7dqz/RrBWW2qWyklHsGDMaiuh0Y1lWJ3kNDBcaDJXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3355
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/6/24 22:05, Jason Gunthorpe wrote:
> On Mon, Jun 20, 2022 at 01:54:59AM -0700, Yi Liu wrote:
>> No need to protect open_count with group_rwsem
> 
> You should explain why this is a good change as you did in the emails
> here, and no cover letter required for single patches
>   
>> Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
>>
> 
> Extra space after fixes line.
> No Fixes line for things that are not bugs.
> 
>> cc: Matthew Rosato <mjrosato@linux.ibm.com>
>> cc: Jason Gunthorpe <jgg@nvidia.com>
> 
> Cc:
> 
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   drivers/vfio/vfio.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> It seems OK but a bit unnecessary.
> 

thanks, Jason. all good suggestions.I'd just want to see the
device->dev_set->lock and the group_rwsem hold/release is
symmetric in the case of err_undo_count is hit in the vfio_device_open().
Just like the order in vfio_device_fops_release().

-- 
Regards,
Yi Liu
