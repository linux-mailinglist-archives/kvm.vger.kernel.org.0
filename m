Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C95763A4F7
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 10:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiK1J2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 04:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiK1J15 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 04:27:57 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7856B7E1
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 01:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669627672; x=1701163672;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/DT/8ZbmD/tcC+HYNWS3EYlcSQVAMALB392nELo/k2E=;
  b=FQC27rQqA9s2HnlBLkxfEJ6/ELgISljBuC28oI4ANddquz/YCkQbFObd
   iT8kdbwl/+u3UwwWI8AAyHp+/L/PhPOFVRVAmM/jZGBmzjiJfapQtlZHH
   WdgycyT5B120Runx769DnKyIFeUzhq3F3RxptTKnQAGQaeJHNiWqx2yHC
   HeQI3nkDa7iIbIlydSc1aF9W6u0P2dEmqgCPY3lISIJ5tPuEmVhJl+CiI
   JzNHaJUEneB+Uily8QBwYTNUv3+N0KaJLc9oYHOSQ4BX/J4cXtG9xwrO2
   lSvUGfZRfjt8zqZS7urPOlZwydQcgao+kDng/+U/nBSNt5BjmvFnT2lSW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="315944875"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="315944875"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 01:27:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="645421495"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="645421495"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 28 Nov 2022 01:27:51 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 01:27:51 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 01:27:51 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 01:27:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wclkn6biQ/3lgHctujlU1hKWJ4/9j+mNGwkSg/XCdWiGrcYO/V9sIYfoGU9O+6t1Mk4GwmU3kqI6lelHwggNk1OPeEk5G7k/1yODMHaVjTVPawpZyKkSQnGYOstckboxna77m2wtLaiZJFv9vNNEtG0CsCMk6+oDouqbxshA3/vdJuGjzZ5OgTcS5w5AFpXMFXR7TDAdUm3e3EN8TtQVxzHIS68tqQRPaPuoEkx8xzoFSYtYRYVVXwtlKUsYaJ1LdTvB563hmfYbkCojvrFDnl9qpAzubHQvjhoQRsC07E6QkLo5HMIoKBLWqhJK+figYQiA8D+S0vEvgEMn4fegcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pig5Bj2ZIvPVzMrjoyBH1D+dY6sYe+5y0riAbXx2SCg=;
 b=UZbiCMzEgxA61nxRBouUa+ZJAbw+DcQFY6ydv2ikaXaTja9UDgS2GtgbexQdszmIOaPm9Yp0Gj4Dd3QMA4uPSqcToyDqK/D1yEbHftXW8oWcT8cF8ZA2oHyTFIhQsmP+TSd85DEe42dKxee3BEUD3cir4K9YmiVWktUCwGi5NLxGB8SlV/afvwqzF1WzC3w0UaRClg8R0Y4p7HzA9nvqMbPVWSQHgb7XRoMdsJ+tOWc+hTCq0R+Q1hur1smLsc6BjSrkoDuJYVTVvaHzi/zHmzz4uw4yMiyV5mTfZ427rEjVuUcLLU9X+3aFFVTfLJVrouOHbxMSnPt8I/EkJo8+3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB6788.namprd11.prod.outlook.com (2603:10b6:303:208::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 09:27:43 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.020; Mon, 28 Nov 2022
 09:27:43 +0000
Message-ID: <f983da4e-6986-c379-0672-8d76dc72d8bf@intel.com>
Date:   Mon, 28 Nov 2022 17:28:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC v2 07/11] vfio: Swap order of
 vfio_device_container_register() and open_device()
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-8-yi.l.liu@intel.com>
 <BN9PR11MB527610A799BEDD4FAD79571A8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB527610A799BEDD4FAD79571A8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0035.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::8) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MW4PR11MB6788:EE_
X-MS-Office365-Filtering-Correlation-Id: 39909eb1-6d66-42d9-8827-08dad122cd54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xeUEgCVws4agWmf1TPEo1AvjDZM0XfstPL+GV/OpSCe0ERk4EG0smoNLa28oAOE75i3maTL9pi1SsAZtARKdBQ227e74/uE8jzS80irz/mYHrZVZLnR9siJ0pl8Pw1nFqJTHguwFw7G30Xx28Jp65NQ6oDNMPOd6uwtmL2JhfcfrWSeRnuzpd6E0pEF17UYEOAIKzy6NGJul0NyBXvYZ8XR9d3ntJNo1h5vjIbcktjiyinmoApDGtASxEtrtUuprCzhWNjK4+/kJuyEguRN8GT6MO+e+rxbcPwWv4+8vBM4GFcwrFyyYVinEqBczqSrJoguTvNqJHTkkFehflOCzddXvAUjyZvSJ+MACeCEvsgCvYax6Nm71DoIVwPSJVCGOZq/ECglJ7s2K4u7GhNrANnGt81XZDZDTPMXBjGEYxZtVw2sx0ILqAZRM1hH9YV+mdnWOCuGPVKvT12tV11leThj0z3MzYJD9NWRrj6binbL5c+uf+UK4b6TWhPzuPNdkHkwp+WPtSVMXSIsKvKuMnKUVDHkya2xtjbKcc1+Y0g1jXnowLGSm5SzvyUHMEG+Svf0Cx/ZjZ3CNifBd/ehHjh4Y1465wQzCp/+mbfyj4QJi+ak4WhR4IPMOCcCxlk3ygN9ZcFdqIsqAwowD5yBWVlf1piYRExub5N/00DFssFJvGunLp01S9CxqW3Tb3uRMD1Ux0ntjqLS1Jvqt9NZ9vub1xawr8OEH4vuC+XxrhaA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(366004)(136003)(346002)(396003)(451199015)(53546011)(82960400001)(36756003)(38100700002)(478600001)(6666004)(26005)(6512007)(6506007)(6486002)(66556008)(41300700001)(8676002)(66946007)(66476007)(2616005)(86362001)(4326008)(31696002)(316002)(54906003)(110136005)(8936002)(5660300002)(186003)(31686004)(83380400001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXRycGdCK2NHSnFQaUpmKzdWWnhiblQ1RjZLVkVicWxRcGgzeGkyM0JFZFE5?=
 =?utf-8?B?VHE1R25RalBUNWRyaHVERGxpL2VPNHFibHlURUxvS0tyemJNYTNnS08wdkp3?=
 =?utf-8?B?Vm96NUpqNmUzY3JpcTNldklHSU4yZEtKSFV4bm1YWW1rbmpVa1BsM1V1WlVF?=
 =?utf-8?B?ZGhrSFJFUWJCNDROR1dmQlJDeTlDUnNKaWRZR2lIOGFtZG0wNTVnR1hIeUh5?=
 =?utf-8?B?d1JXTDI0OFdHWGxJaDc1MGM3SHc5WFRBL0t3cGlGQy9yQmsybWRTMVRiZ20y?=
 =?utf-8?B?YUxWRzB4Q0Vmbk9zRDE2N2tpTUZGZ1VLSzRPdExoOW9VS0FXZTRvNG1lK1hG?=
 =?utf-8?B?NjAvdTlXWG9lMnByYjI5aUNNa2RlK2FCWnBaend0Y2JYSmpoMDhSVVl0NjBn?=
 =?utf-8?B?SmhKcEpBSlRLWE5SRzJRWUtQZHJtc0dWcjJtemJXVThXNDBIS05xNUhlRnZE?=
 =?utf-8?B?enZ5eU1tdmoxL1NTVHByZ0lWUnJQbEpjYTR3anNrNy8rWTVnZEMvV2kwaFQ0?=
 =?utf-8?B?aTRQM0xmck01QS9sU3g1U1dVNmIzQVczMnQyU1BvV2lUNHZ3YTRUK1Y0TGls?=
 =?utf-8?B?TWVjbUQyUHRvTHpCZ0Y3QlRFSmVjYzRjajNvS0pNSnRyL1l5Y3BpUk12RCtM?=
 =?utf-8?B?Y2JWVHAxeDdPdnlXRU8yNkRscFZUelJkc3VkOG41UG8yOXNlZFBxcXBic2Q5?=
 =?utf-8?B?Q09HYS9BS2oyMTVtL0YrWUFzRXVmNU80M1JVaGw1N3d2ZDB6VElVR0cvMExj?=
 =?utf-8?B?S1Z1ZnkrTHRrdXFWVmpWd0wwS1BpSktsY285Yjd6eE9TQXRGbnFJMTRxMlMz?=
 =?utf-8?B?QnIrUmFyNkF6UW1pZVRGQVJGLy9VZjdpb3ovTllGNDhIZHRpditNUnJydUZS?=
 =?utf-8?B?aEdiMHdyZDZGZGZSMHhiWGdVODVpMDRBUVN4bWRlOUFGMkd0S2Z0OUFFT2ZF?=
 =?utf-8?B?Nm5iaS8ydXZCU1NJTFk4T3ozbG1yeXhrdEpNTlMySlNXK2oxdTFaUXFaWnZE?=
 =?utf-8?B?a1d0Y2VGUDJhZGVLMFdZaUtkS2hqckJ6UFNpMStVSkVQOVhnZmd3akdtTzEw?=
 =?utf-8?B?T3NnTGlUS3BqSDVYL055WlQ1R1pZNU9JWERoOTBidWNFbklXVXcrRzh4Um5K?=
 =?utf-8?B?VEw1SzVRUmg1WkJ4dStvSWdrLzJoMmpOelNqR2NPcVVPWDBzOGdReUJ3VDJj?=
 =?utf-8?B?MU5rYXlYRWREVkxJU2phQTRDYmxzZ1JJeXRvWXVoaklpODUzVmFLVXhXSkk0?=
 =?utf-8?B?M3JWTXVJU3ZaMDdYNi9wNEpxOGtzcTM2UXFVd01lSEp2WVdZQU0rWXMyREI2?=
 =?utf-8?B?NmJ5eStzVXdaQVdjb08zZDZYUlhMeW5kU2Z0dnEzSXRLajdkWXhPSTNjdUlK?=
 =?utf-8?B?VzVRNmdmSDdXTjNwYlZzeStrZmR2ejdJaTg4VnR5WWNoVWlrNENCVU9MU05H?=
 =?utf-8?B?RE5qVjlXUGppRkhwZUVMcXU4V0lnTzZEU0VxMkNQZXNKR0tUbzlnemphMGx3?=
 =?utf-8?B?S0NYcUlZaWc4UTYxKy9RaUVKVkJvaDFmSzJ1U05WdlllUU4yRGgyeGFlQUp0?=
 =?utf-8?B?bnhheE8wRHF0L29RalRqR2ZabUN5OXZ3Z0sxNjZWaFN4ZVN5bWlhY2RrbDlC?=
 =?utf-8?B?emJLaU42NlN1M3lLR2ZoeW1hVEtSOGVXdXd3L0toUUhCM2lLMkJNNjhEY1Fm?=
 =?utf-8?B?TVY1Tnhlakxtbjg1T2FqTDFTU3dWb1FrY1F1WnA4NEhOWHVSTyt3bnZWV0M1?=
 =?utf-8?B?Q2dxVGJtT2NjZDJnZk9WRmtCa3BjOTg2bEd1TlIvYlhTZzBoZnFIaS9Wd1U4?=
 =?utf-8?B?eU16UUNGWEtPZ2UwTjVoRzNqakRGbE9LTVhaY0wvWDdWNk4zakJZU3loTjBJ?=
 =?utf-8?B?QVUxbTduanVRcDVNdk9FZTQrSGZZZlR3Y01ScGI3RHl2U0F4MHdKVjg1THlN?=
 =?utf-8?B?Zyt6d2NNeVliYUtUSFdvaGk0VWhrRlVPV1RoL05ZN1NGNWRGUkRXczNxU2th?=
 =?utf-8?B?M1I3VVpSTVVxMEt3aE1lL054ZGh3NmVRTHZKMTB5OWxIZmsvcjVTcmx4M250?=
 =?utf-8?B?Sm1reUc1NWhjYVRJeW5HOHVsdVdjWVR2aC81RVhZbDlzVXNZL0c4QlRzMEh6?=
 =?utf-8?Q?rFKveCcF3IuZj3dsQU/raNQQD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 39909eb1-6d66-42d9-8827-08dad122cd54
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 09:27:43.3433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AtZmHj2d9K1/kTGKz2gwFmhi8DrH7J5UL2AQwDDtpZBHfhr/YuH/gKHAh42oFrDvQ44lKrYhzAZPeC9y4EGv4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6788
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/28 16:27, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Thursday, November 24, 2022 8:27 PM
>>
>> This makes the DMA unmap callback registration to container be consistent
>> across the vfio iommufd compat mode and the legacy container mode.
>>
>> In the vfio iommufd compat mode, this registration is done in the
>> vfio_iommufd_bind() when creating access which has an unmap callback.
>> This
>> is prior to calling the open_device() op provided by mdev driver. While,
>> in the vfio legacy mode, the registration is done by
>> vfio_device_container_register() and it is after open_device(). By swapping
>> the order of vfio_device_container_register() and open_device(), the two
>> modes have the consistent order for the DMA unmap callback registration.
> 
> let's mark out that existing drivers have been converted to be OK with
> this order swap in Jason's series.

sure.

>>
>> This also prepares for further splitting group specific code.
>>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

-- 
Regards,
Yi Liu
