Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9994EEE23
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 15:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345341AbiDANdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 09:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346393AbiDANc6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 09:32:58 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3843426ECA0
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 06:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648819866; x=1680355866;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tcmaNLtCSdCNHZjK9EdT5KACS9Rf6hQLHZ8eZMsZ+vM=;
  b=L6yNBYqjsYf7qHVxVwPDjsz+LPVOUYJTBRZGfSA9PHc719fBmwu9X63w
   l1fPUCK8hAc1pQrfPsGRDE1AadqRTZB34uWT5QAoSN7l2O65ZMXQXJ4Gv
   eiC0GAill4wwRnFym/5I+G1WfaJI9O7pVbEaiBYkO89Jv6glrknvxwoTt
   UorJrS4bK32eShI2aw+pbxtwCyDJQUHVpfg6iE+PJOEjDZXNpSvjXo9we
   TwyZS4k6ekxiq33+/djtwkAve4Z9BfL5+cpunLX+pImLfMcYee6RSsB8N
   u2WWDSPJIhTlmpM1IE4oUy3e9kWtv0OcdrDUgezXBy/Z6GSelXVo+jqeW
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="257716381"
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="257716381"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 06:31:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="522777194"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 01 Apr 2022 06:31:05 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 1 Apr 2022 06:31:05 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 1 Apr 2022 06:31:05 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 1 Apr 2022 06:31:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKPKSH+GcyRQ+JrlNSOWqrarQ4XtRXTuE/+n5lRolgCdmRAw6YioAJVuRNqXkddfGeC4Zz8fMI4QDbc0NWoG7P/LVCzcWuqhltz3vtfU00qkdPTRpI7oCyOjDaEJ1QPAfOUHR0ZGx0hVxGms703RICcC4+XhoRq5WCR7XvGJeQHLh7J789p8Kgljrcv7lHWk54tezQBHbv/hcW+TpVYMqUwWGxQmn6Yv6np8bSvPeXKjX0XUnE9HA6dnuIT6eO6O2VMrqcjrqRBTZWhD8xmFkFPOj5yXci7MRoFG9YxWlb6NptPdMaDOKu7NVpfqpds8l0Dmcq9op0pinRXi0q//qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YK14HpGxiKLNdjbv/QmyFEASvly5YUURH4nnhnFdaFU=;
 b=TVF0ZirbqHTBpi0ShyqFSb4rahtRNZmVdvhiqwDYj7aUApW5tjY3qw8j2UzXmX1NZzvyzITU0KU/NYQ9+Q0S2P3cfM/ZObEvOd8rMWfxyyjrxOMJ9JKT/GW7iqmA98yOHs5Me3My6JegNedKTe1THCmDnjvxvXNqsLmLfqgtAontRSDpO1vv82METPhuizISSACx5xH7ffNY9srTy2KES/zfM808n2yncpJdUnDpkKWzm66hi0d00zp9JfKQ69U21m46hsBNETPN12H/pzBPJnzU0Q2Ui/VDrQyhbkFs8ML16VmEzcBMFZUaEETqo1TsP9gkzW6LiFhOIWyS7twgNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by MN2PR11MB3981.namprd11.prod.outlook.com (2603:10b6:208:13d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Fri, 1 Apr
 2022 13:31:03 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::bc9d:6f72:8bb1:ca36]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::bc9d:6f72:8bb1:ca36%8]) with mapi id 15.20.5123.025; Fri, 1 Apr 2022
 13:31:03 +0000
Message-ID: <b7c25976-fb46-70dc-05c2-846a2a1bf91a@intel.com>
Date:   Fri, 1 Apr 2022 21:30:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
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
References: <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <cf303486-fd80-591c-f9a4-d39591c7d0b8@intel.com>
 <20220331125933.GH2120790@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20220331125933.GH2120790@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK0PR03CA0120.apcprd03.prod.outlook.com
 (2603:1096:203:b0::36) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b1b7eee-264d-42b9-5db0-08da13e3ddbc
X-MS-TrafficTypeDiagnostic: MN2PR11MB3981:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <MN2PR11MB39813383ED4B82572AE97FE0C3E09@MN2PR11MB3981.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1xyQvMEqgEYAL7IMSV21Vro8WIHyzuNfjYnEnhuaDIeJO1NCqzaAoooa0Z8Yw8wDbY3ZFUkJBQc1oUV1NAQAeIF0yD39gO+vjqswMkhhD1Tze5+n/Th7sRtJC7RNAYMDP+fMihgd7LomwwTWINxMKszMvuPQ9Ao5gA2oAcJCtVNIJuE+ZLR8AUmF9xgfEYjXy/Y/w9a0IlcWqcxGANqxDHKPaBEPbWFsROnp3B9yHMZCUv425yforB48MV1FpjuUbQL1edvfDkduV0dF9+VKNhORJOtzyLyN0kmMrr4nbf3QQLPaPSoU4Q7YUSkrZIf5NoGgD32kqha12hJpcWJ75fmR9aUlKOzCyDrKAA1xXCOpweWADNlUNrBt6R0G0ds+a2FmpRXLatYDFlE7pXK6XfKfJWtzBlaKbWKh5aJOr8hkqlHsLvQVA/Km1EmV52LHiRsMiwBlQ4asBeeLHRSw8sv1QQj1itP/6q7fvSNUxtxkFSgfw7d556opsyoQjEAGDamTHNXMib7wY1eW2Fz25UCcIFE2R2VC0Er3SgTNARmHnLRcIm2OrhwUPliovPzV6hOxANUjLmupCB29qlYvn3fLyxAZo8L8sNCiM6dwxfV+KTsinVCpSiJjMBanQ+eIm+qUAe38aPxo5sDLKBJobIPybYpI6C8dDPfS1KfVktHrDuL6qjtumc3t2AHMZNfjPQ3VubntxlHPPIcG/9mE+eNUtiaz5B6/VLzrX+cx/bR+mUzxwhF1aahvWezynJkY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(86362001)(26005)(31696002)(186003)(2906002)(6512007)(6486002)(6666004)(2616005)(31686004)(83380400001)(508600001)(6506007)(36756003)(66946007)(66476007)(66556008)(38100700002)(4744005)(4326008)(5660300002)(8676002)(6916009)(54906003)(82960400001)(8936002)(316002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHpjaDFXaFZXSDRpV2tWT2VObGUyMit4WWFDbkRXYkhjL3lVaUczSnV1bStV?=
 =?utf-8?B?T2FIWklCZWRuZVRJNzR0c3NqN2VIeWg4VVU3b3lJUVoxcDhlczFycXpJQ0JS?=
 =?utf-8?B?allwcDhFa2g5UDR0T0poeTRjV3RQbnd4MnVEQjNEUU5CUkMzbS9JSjcrKzZL?=
 =?utf-8?B?alRoVlJ6Ymg3T3BlVzQ0U1pUVG9hNVk2bzdGaExnUW0zdENWcFdDMitTL0VE?=
 =?utf-8?B?K2RUWVc1ZGh0UlNnK2dteFVUbGJBaUplNEZibzgyL08yblVvcExtSmVuSVBt?=
 =?utf-8?B?alJtSnFVZ2RtODNUbkJzVDZia2VYZlRtYklCc05XMWRxL0R2ZUR0b3I5Z2sz?=
 =?utf-8?B?a3Y4bFVPTnRjekJyMU9CVm9MeWl6RklSaGt6K1B0eGd3ckIxQ1hlR21waDVS?=
 =?utf-8?B?ckhYaU9SaU1leThZUkNBWHpFZmpiWU5XM3dGNEtadGdaQytPWEZ2V3BROTNa?=
 =?utf-8?B?UmpmMFhLWDlOemJlVE45NHVxV0lpZnRuOWx5Y1hMWS9wblZWQWlPZkVPSk5B?=
 =?utf-8?B?UnFtMzM4SjhRZ3ptVEtjSDdwd3Z6SlBHcXJleGRHZFhxNlAvQW5iL2hILzFp?=
 =?utf-8?B?L2FJeUhUYVlCQTVqS0d5akM3V3NDcjRJUmkyYko3RWYxYStZZUR1dFhBUXFL?=
 =?utf-8?B?dE1IQzFxL1U2M3lDWlVPQU1TVzhTTjVxdUZJME43RE1WMnhPbEcwSUphcUlN?=
 =?utf-8?B?K1QycGIyc2RGV0dGaHl0TmdiRExBL2lXVTJLaEhYTFlWYmtrZVRoem5vZ3BD?=
 =?utf-8?B?UXhva2c4RTk1TlV5eTJubmRtc00xYk54dzUwbW5jd2x0bnU1RHFVaTg4U3l0?=
 =?utf-8?B?RFBtTnFTVy9maG1qbWdkTWxRUXVBb3l1Wnc5Qmo4SDRGSmFpQXU2L2pqNW42?=
 =?utf-8?B?bGtrK2x6Mzh2M2w4dExJMnJ6V2NoMUo2WTBwb1VBWnkzVTdIczBsYlFMbzRH?=
 =?utf-8?B?Y1NoWXN1Tk0rWmdpYjhkaUxGNFY1eEFPSW9icDZMVkNRdVMzRTlZNDQ1WVU0?=
 =?utf-8?B?QkVLNEorWm45dnd0bnQ3b295TnlzSWRXWXNrNElTdVdLdk5idE9ENGRDNGsy?=
 =?utf-8?B?WDZ3YjE1UEZsV1VXSVRjajlvZXc0OEE5YzRpQWgzMUJVUFFTcWJsN0xGYnEz?=
 =?utf-8?B?YnJsT0pGTEZIVUZ3R0NTbzUrTVI0cnZBeEo0dWlCdTZKK0NxWTVBcHEwajJ6?=
 =?utf-8?B?RkpvUXBMa0dQUjBFR2psSzREOWFhZHRHVDRvYit6MDhPY01Fd3hJNVBVRzll?=
 =?utf-8?B?SXBYdEovYnRWSmFKT1ZTWGllZDY4U1VGa1BWaWQwdlN4UGJPanRkc3NEY0RK?=
 =?utf-8?B?bmsxanRyYkE3d2h3OGhzTlJHUlNNMi9xN1B1SEJsSWUyallHTmVBendPMVRX?=
 =?utf-8?B?SFB6ZkNid0JaMXYrb3UyWC8xRnFwU2FPVGRRd1NsZ0xLUHZoelIrekFXM0RY?=
 =?utf-8?B?TGZhclVxZjNmNzZ3Z3hNNFhodm91TXFISTNFOXNmaXgvQnROb3RzRGFsZkdm?=
 =?utf-8?B?SnlxbllsT1dxMFhJWUpRTWNXRktWR1RrNy9oTDdObC9CdDNhSEdZNExleUVl?=
 =?utf-8?B?ZUZnenNkTnQ1VHh1KzJoRHRSUVI0cU9YdWNXMWE2eURKZ0RkRVJHeUhqWnhB?=
 =?utf-8?B?Q0pOUy9veFJyZURXQ3lkbjlFeG9vUi9UZTVoSjc1YnNiZVIvZkRtQ0h1cHZE?=
 =?utf-8?B?QWhvd1BETUJydVU3OHNlRlQ4YVlpeUVhWEZQQ28wakJZQWs1ZVpHbDVVdVJv?=
 =?utf-8?B?eUVLOFNCOGVxT2NjVzk2TG1LdnhicTRSSDA4RWNWUm01Q1BocjdnVXY5Q1A1?=
 =?utf-8?B?aVFrRFVGZnZydnQwZ0hMaXpYV1c4ZmVKNDY2MElvTnZzZVlDeStxdkpDQWNn?=
 =?utf-8?B?Wjh4QkhVT0RHcDg0ZWxYWVVYY2VOeEQxS094ZWlsY0g0eko3L0F6T3M1R2xu?=
 =?utf-8?B?OEdobkFNQWMxZEV0czdiNllaYTZZV1hQV09zeDM5WWtnNDFpODdXMHVKNmhB?=
 =?utf-8?B?YXpFclpNa2lmZkRSQzRaWUVPSE4rTTQzbjAyc1ZoejJBWWtkblZvZnR1OWJh?=
 =?utf-8?B?TWd3VXIyTUo5ZVFUOHEwMDQ2eTBnK2hDTkgyQXJIN0h2RzRVMVZ4bUZKLzNC?=
 =?utf-8?B?RUJ3disvbWw3dkwybjlaaHd4Sk91ZGx2c2xtVkVYOHJCTi81RkZzVlAva2Qw?=
 =?utf-8?B?blVLUG5kRWxrYWlmY3h5TlVlNVpSeVlnUzB4QkpQc1VMa1FwSW1jdnMzdnRj?=
 =?utf-8?B?cTBxWUp4RnZLMUZBcmFhT0dIcGQvVE5lYjNXVXR4TlY5TjRGaW4remJQVjB1?=
 =?utf-8?B?N3E0M2hGQWMzSnFWWnRYYzdrelNvVFB5bmx3N3BqVWk3MHpnTGtPQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b1b7eee-264d-42b9-5db0-08da13e3ddbc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 13:31:03.0439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9qGydTI1Z3QyfMZQEIqFRJibpoJVvSISxkculmdSKo3D2/8mm0kVIuwVpKtfi3Y+1fh+THKz3Rb1X4ht9WA2dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3981
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022/3/31 20:59, Jason Gunthorpe wrote:
> On Wed, Mar 30, 2022 at 09:35:52PM +0800, Yi Liu wrote:
> 
>>> +/**
>>> + * struct iommu_ioas_copy - ioctl(IOMMU_IOAS_COPY)
>>> + * @size: sizeof(struct iommu_ioas_copy)
>>> + * @flags: Combination of enum iommufd_ioas_map_flags
>>> + * @dst_ioas_id: IOAS ID to change the mapping of
>>> + * @src_ioas_id: IOAS ID to copy from
>>
>> so the dst and src ioas_id are allocated via the same iommufd.
>> right? just out of curious, do you think it is possible that
>> the srs/dst ioas_ids are from different iommufds? In that case
>> may need to add src/dst iommufd. It's not needed today, just to
>> see if any blocker in kernel to support such copy. :-)
> 
> Yes, all IDs in all ioctls are within the scope of a single iommufd.
> 
> There should be no reason for a single application to open multiple
> iommufds.

then should this be documented?

-- 
Regards,
Yi Liu
