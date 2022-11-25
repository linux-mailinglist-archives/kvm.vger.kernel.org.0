Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622C46385DA
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 10:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiKYJGn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 04:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiKYJGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 04:06:41 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210D7326D9
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 01:06:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669367200; x=1700903200;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3FBZ4O+WBCyi5gYgSguRplNUiHaw3s1OHt8BqIv+G0g=;
  b=NaztOyzyEXUSRvNCgkCemoVfi2IxMLwjyg7IctkVmizls9ZVA8FgqQCB
   Us5OFPbigDX0k3DhK35LsKRoSXzBVFkWKrHX8UtK9ANvcpYpaP/Bh5wI1
   0NwVUL9Hyq2BSCAIdhorARS7lH3liBJXou8UjH5yngihfgbixTGMAoolK
   Jxj3qZBP+tguSxOboejNXO3oEyXv9eQLvKMm11sronpRw4Um/YC3ysl64
   gPl+ocYYsREBnwmfQCp2s8Jpqy5zECxexEo0MNGLwUm4i1qQQQOm3WRn3
   wHs92CjA5i7fF2bTYBEtM6+Ds+7D8URJtuKMm2Fm9qfWMgfWPRvFcUroQ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="376587794"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="376587794"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 01:06:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="887629224"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="887629224"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 25 Nov 2022 01:06:06 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 01:06:01 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 25 Nov 2022 01:06:01 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 01:06:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R1jaBBsMnBSNQBfe4Wlb+bPvxKAq9Iu0No8hBzDj18oPyMwhG2NL6+Z/FqluItHBEl++TiFO6dHTicckRzLj1oAdIW3QpExCflvesjW7uRDkItBrRCD422tNgw6HTE8Ld7US7fQtFhQaRONWS25JI7yLtgiv5SpzKm33mae8wPRhm6JQcpCHQje9UZmzwfeZgnOaoWNzkpaD2ViV5CBGpY6yU6TG/OEZCpL/PFWzi3yCT55JAO7Ci6dZ4kUYTdRZ+EHZBxuKfaqVHIGIVmdk/XZBewjEL7G46o+8E1CZCcg6ceL9y0vAuDPn0amWEX0mUCMjjpj06n1ikP7PULaJjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9F6xUDNFe8QzGva/aTw+P1WSMRC55fgm/Kx29qg+BzM=;
 b=MSV0NfYSPLf+/yDtWUZoxyQmEdziWTPYvXEE6kICbtXQTd5LNqhDClU5sqM+HUiE4hmKdSM1oas6WeF3i2lkrr3URdh8NNuSG+5uOJdW6DuHzDRAu4+0Sg2DdatctCkAa5wwsuzBhw2Gb1QNewMvB/arjVipdYUEm6GuXkI+4DhP4TA7ibSa4yMJUg6DA7yytMUK+k+/zZYwIAXNy2cPKFwbaBngvdApKgFlYhrK/rrovBItY7DDHII6SMgzH4cwKB0p84pzByqe//XeKzc0grvcqVMg8Q4UJ52V4UvPI3aBGejK1pqtA411WnmYq7z1cY2G8MEXTeEuruBzc1Jdrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB7448.namprd11.prod.outlook.com (2603:10b6:510:26c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Fri, 25 Nov
 2022 09:05:58 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.020; Fri, 25 Nov 2022
 09:05:58 +0000
Message-ID: <9319ead4-e67f-a566-df12-10b146901c98@intel.com>
Date:   Fri, 25 Nov 2022 17:06:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [iommufd 1/2] i915/gvt: Move kvmgt_protect_table_init() and
 gvt_cache_init() into init
Content-Language: en-US
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
 <20221123134832.429589-2-yi.l.liu@intel.com>
 <BN9PR11MB5276413337536E76B2B0DA0E8C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <39bcd0d8-17c1-79d0-ed9e-123dacbd4b63@intel.com>
 <20221125060442.GV30028@zhen-hp.sh.intel.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20221125060442.GV30028@zhen-hp.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0015.apcprd06.prod.outlook.com
 (2603:1096:4:186::7) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH0PR11MB7448:EE_
X-MS-Office365-Filtering-Correlation-Id: d6eb8ad1-44ce-4066-9fc0-08dacec44489
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qaY5rxVCW2GG6FJL9XGRFi2Z8nVIMd05loBs5YnqWKO6xTUrx7TVfDQrg/kOiqO/SNGGFVAEXkLiMp2Yx9CcZlifOvr9pB5afdcuewquZVILUqT8rCoJHXt6jD29t86ppvEWniPDnReXEJSj206pZvgxkfiflbcS8JpTh0GWulI8PDqzl5FbBPRapNc4GvqtmdX3w9xzn/kwgE7NmacZRQDAjEkn4+bIiJo5SKQZqBY+3+4Q/+VMQ6NdBjFS00PdADguotXnlY7+oVvc+XES5AHkNjJ/4HPUcVACaKkCn1b68FilNnpXY2tUOnalQ6QRiaSWY2zPNPETOX9FYTtIdggxdUzjt1St5JFY6VRvVbgrBPAvMe9kTtTWSl3AhvzMHJbyfGX9Iuo/Q0xZzV7Kju+2PcPwKT1YEgXQRJtjqMFM9dLkW1MZQX1ohLE/Xsv1g8yRqYvJo24tGi8eaghNbohHhU5kRlTJg9mM5d6fY+DGcpJzYpJ3RkypmaekaQ91T3NMTmpYU2wZ7iSYgnK77PvU6U4XPpCgV4Sr6t25FDje4bzvAdIUcJPocQL0Kcf3chc8JgSaQsRVMJPHl21yVhrc0TQI+pk2ogjsY2UQGWnaqrHA0/UzcebFjBSssno1L22yeNP7KkJhVdMNXfTF8414vo5XNt0gFEPywIqMR/MfZSNtH01+mlJ2q0qWBSCvUVqoJc0MLSsxNZn1XSk/eZu4yQwXXCffB12WkTsqPh0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199015)(5660300002)(41300700001)(8936002)(4326008)(31686004)(478600001)(36756003)(8676002)(54906003)(2906002)(6916009)(66556008)(66476007)(66946007)(316002)(6486002)(6506007)(86362001)(53546011)(31696002)(6512007)(26005)(2616005)(186003)(83380400001)(6666004)(38100700002)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWVoTGQzUldhUktrVVpaTlpWN0Z4Q2t0dk55eTZRWG5DUjBXMC9qRSs3NUl2?=
 =?utf-8?B?RGM0WGNvNEVLc2Z6SVM4eDVvYWtreHoyQXE5cGxiaTh3WGRIak5hOXprU0FL?=
 =?utf-8?B?c1ZpNWl1VlpXb2JWMUxQQnNXbStOQ3NOdFl1bUxnTm9XMVNydmFsMU1QVSt3?=
 =?utf-8?B?KzAvL1R3ZkVwMUI5RmoxRkNqQnJYTXk4RkozVkNmUGV4cHhGdnJibVhwL21h?=
 =?utf-8?B?Qm93TWJ3eWhUeC9TaTFuSHNTSVRWTmVuM0NkSnRWa3pxSUFsNSttR1lVcXZ0?=
 =?utf-8?B?a3JBVVBLYlRwTGNBWGt5aGQ0YmZOQVloaWNOajVtcVo0eUl1VVJGRkNqWDNF?=
 =?utf-8?B?UXR3Tlo3LzlhcW9Fa3N1TitFRWdsYWxQZXFKcVVNOWEyTTFjUXpVSlB0eXNu?=
 =?utf-8?B?ZXhtSlQ3Vjhta0RMUXNnWFlybUc4TERtNmJFR3VVNm9vNlZaWnFLUm4vOFNs?=
 =?utf-8?B?ODBST2o1ZXQ4VFNTTkZNMGJtSVhJd0FGbkNlT0l3UTB3YkNyZUdPVlhFVWUx?=
 =?utf-8?B?NXhQZ3N2NzNIV3FRZ2JXd1poS2Rhb1RrUllxNjhjaEtHWFNYYis1TGN0UlBN?=
 =?utf-8?B?SGI1cDVCMys3NEordHRtaFNHQytWVkRSOGNFaHB1YWg5WEpjb2dHcXBjUzNp?=
 =?utf-8?B?d2Z0MVNiUnhLMlB5MmtBbXlmMGxlQmNJVDhUVktWOGtMOXQ3enRNT2NZek9o?=
 =?utf-8?B?SDU5YzVqdG5vVGlPRkdHZWRWNDRNZ2dkcEtINHkvTC9kRDhIQ3hwUkpjMFBS?=
 =?utf-8?B?aWVhZ0FCQWpYS2UvSE9vYUN1Mlh6WC9KMWxiKzBUcHdmbEVpRE9uVzBtT1BJ?=
 =?utf-8?B?dmNXUkltdXRWVnArSHNlTjBFemltb0VwYnJzMVRqZFMvQ0owcEdwSWhTK3ln?=
 =?utf-8?B?SjMwYVpESHluQTlEQXBqRkw2aHBXcFE1WXY3Z0tTLy93VFFvZDNGeDUrZEdG?=
 =?utf-8?B?UmQ1MHBJdzN2d3hoTjlGV2I0VlF2RFNOOHZ5NWZJUHgvb2xXb2dWL21od0dR?=
 =?utf-8?B?NE5tdk9vclVROGZSdzhmdmQrZHJNcVo1ajZ3UVFDOFN1QWpFbmVsenVJczhr?=
 =?utf-8?B?V3RGeXNoNE91YTVhV0UyWTZaU1hnblhLOU5OMzgwOHlzZDI5WWZ4QlhUY2t1?=
 =?utf-8?B?Zk1NYUJ5WllaOHp0VEZSUVY0cnZRUlY2WUdtT3B1ZnFETjNubXkxQk5BR0dO?=
 =?utf-8?B?NWorRFp5UGtqL1hBMjNXTTlSQVlkUnM4aTVDN3hjU2hlaXEvRlVmQUNqdHFv?=
 =?utf-8?B?RWh4L2NxY2w0cEt5UlJybjlVSDhhSW5pWnhTWlhTUFlsVE9pNVBJczAwaFhp?=
 =?utf-8?B?SVd1MExlV01MUU5sK2JleGlDMGRxTGRDYmt5eFZWL09ZUEJhTGVsR3ZpUDdl?=
 =?utf-8?B?VXZuSldaZDR0czZCajB0ZExaWTZmb0tjUDgxZ0wzcm9USmQyNnpJSnB4WTdm?=
 =?utf-8?B?YVFsNUlhcW1pUUdtVWF4RXZ0WFhMU2lTUGxMaFJQYXpJWWQvMjRZZWRneXlY?=
 =?utf-8?B?VzNKUm9Fc3ZLWDBzM0ZwWlBxQTlLR0h3bko5Yld4RTFnTVdEaUNWMklXc21s?=
 =?utf-8?B?WHdlL1ZScURaazZnajZwdHREYy9rajhVVHpNaGV2RHBWUXY5dEh5d2pZVmdX?=
 =?utf-8?B?OXU2YkVsYm5PQnMwcUMwcytFMXB4VWVjVDBSMkxUM2tsWWw0Qkt6T2lQU3dl?=
 =?utf-8?B?emhtYmU2N2JGeDVhalBHZmlYZVFJQ0Uza3JFd1Bsd0Rkdk56dk9ZdWl5QTkr?=
 =?utf-8?B?alU0eXJUZkVBUGcwK0RJa0Rlci9ZbXhCMWZybjV3K0Q0NHEzVklhUkUzdDlo?=
 =?utf-8?B?T29MbUhjTFNlWEZLZFJoZWZZK2ZhWGJEUDhxRml3VHJtMWJDQUNtYWE1bWJh?=
 =?utf-8?B?VzcxMGg2Q2lVbFp5S3pQU09oQUU4R1lMM2dQamp3UUs1K1J0QWhUR09yU1Bu?=
 =?utf-8?B?OE1vN2N5cU1ObHlHaU5pQUoydjJhSmRjMVg0UkM3bmN3L1ZZQUE2N2RGK1pl?=
 =?utf-8?B?eUxxTTBkaHM4VmVLcThycjVGUlFHODJCWHk0bVc2bm9ja29pd0FzbmVXa21V?=
 =?utf-8?B?ckpTTTc1czJOL2l5MlU0WWRSY3dCTnFUNStUa1RFQ3BON21rSk9UMXBHU1dh?=
 =?utf-8?Q?CBbbgGp2EZm/yffbvE5eNV3iG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d6eb8ad1-44ce-4066-9fc0-08dacec44489
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 09:05:58.8565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ky2cVA7Mn38D3zMKIZx6TCs9sKur17tfqF4czSrsUAVaQZwq8u9L1FllD4aQ6UwhlPeSw3SBUziYcYSCSiF8uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7448
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/25 14:04, Zhenyu Wang wrote:
> On 2022.11.24 17:15:12 +0800, Yi Liu wrote:
>> On 2022/11/24 15:07, Tian, Kevin wrote:
>>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>>> Sent: Wednesday, November 23, 2022 9:49 PM
>>>>
>>>> vfio_iommufd_bind() creates an access which has an unmap callback, which
>>>> can be called immediately. So dma_unmap() callback should tolerate the
>>>> unmaps that come before the emulated device is opened.
>>>
>>> this should first talk about how it works today and then why iommufd changes
>>> it.
>>>
>>>>
>>>> To achieve above, move the protect_table_init and gvt_cache_init into the
>>>> init op which is supposed to be triggered prior to the open_device() op.
>>>
>>> what about below?
>>> --
>>> vfio container registers .dma_unmap() callback after the device is opened.
>>> So it's fine for mdev drivers to initialize internal mapping cache in
>>> .open_device(). See vfio_device_container_register().
>>>
>>> Now with iommufd an access ops with an unmap callback is registered
>>> when the device is bound to iommufd which is before .open_device()
>>> is called. This implies gvt's .dma_unmap() could be called before its
>>> internal mapping cache is initialized.
>>>
>>> The fix is moving gvt mapping cache initialization to vGPU creation.
>>> While at it also move ptable initialization together.
>>
>> much clearer :-)
>>
> 
> Current gvt internal cache is handled with .open_device() and .close_device() pair,
> so those internal cache is now re-initialized for each device session, how is that
> handled for iommufd? Looks that's missed in this patch..

you are right. I noticed below two helpers are used to destroy. However, 
the code seems to be more clear the internal cache. So seems no need to
re-initialize. I'm no expert here. :)

gvt_cache_destroy()
kvmgt_protect_table_destroy()

>>>>
>>>> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
>>>> Cc: Zhi Wang <zhi.a.wang@intel.com>
>>>> Cc: Kevin Tian <kevin.tian@intel.com>
>>>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>>>> ---
>>>>    drivers/gpu/drm/i915/gvt/gvt.h   | 2 ++
>>>>    drivers/gpu/drm/i915/gvt/kvmgt.c | 7 ++-----
>>>>    drivers/gpu/drm/i915/gvt/vgpu.c  | 2 ++
>>>>    3 files changed, 6 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
>>>> index dbf8d7470b2c..a3a7e16078ba 100644
>>>> --- a/drivers/gpu/drm/i915/gvt/gvt.h
>>>> +++ b/drivers/gpu/drm/i915/gvt/gvt.h
>>>> @@ -754,6 +754,8 @@ void intel_gvt_debugfs_remove_vgpu(struct
>>>> intel_vgpu *vgpu);
>>>>    void intel_gvt_debugfs_init(struct intel_gvt *gvt);
>>>>    void intel_gvt_debugfs_clean(struct intel_gvt *gvt);
>>>>
>>>> +void gvt_cache_init(struct intel_vgpu *vgpu);
>>>> +void kvmgt_protect_table_init(struct intel_vgpu *info);
>>>>    int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn);
>>>>    int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn);
>>>>    int intel_gvt_dma_pin_guest_page(struct intel_vgpu *vgpu, dma_addr_t
>>>> dma_addr);
>>>> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
>>>> b/drivers/gpu/drm/i915/gvt/kvmgt.c
>>>> index 579b230a0f58..cb21b1ba4162 100644
>>>> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
>>>> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
>>>> @@ -322,7 +322,7 @@ static void gvt_cache_destroy(struct intel_vgpu *vgpu)
>>>>    	}
>>>>    }
>>>>
>>>> -static void gvt_cache_init(struct intel_vgpu *vgpu)
>>>> +void gvt_cache_init(struct intel_vgpu *vgpu)
>>>
>>> those are local functions. Just move to vgpu.c.
>>>
>>> or you can remove the function wrap and directly put the internal lines
>>> in intel_gvt_create_vgpu()
>>
>> yes. maybe see Zhenyu and Zhi's input. which way is preferred by them.
>>
>>>>    {
>>>>    	vgpu->gfn_cache = RB_ROOT;
>>>>    	vgpu->dma_addr_cache = RB_ROOT;
>>>> @@ -330,7 +330,7 @@ static void gvt_cache_init(struct intel_vgpu *vgpu)
>>>>    	mutex_init(&vgpu->cache_lock);
>>>>    }
>>>>
>>>> -static void kvmgt_protect_table_init(struct intel_vgpu *info)
>>>> +void kvmgt_protect_table_init(struct intel_vgpu *info)
>>>>    {
>>>>    	hash_init(info->ptable);
>>>>    }
>>>> @@ -671,9 +671,6 @@ static int intel_vgpu_open_device(struct vfio_device
>>>> *vfio_dev)
>>>>
>>>>    	vgpu->attached = true;
>>>>
>>>> -	kvmgt_protect_table_init(vgpu);
>>>> -	gvt_cache_init(vgpu);
>>>> -
>>>>    	vgpu->track_node.track_write = kvmgt_page_track_write;
>>>>    	vgpu->track_node.track_flush_slot = kvmgt_page_track_flush_slot;
>>>>    	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
>>>> diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c
>>>> b/drivers/gpu/drm/i915/gvt/vgpu.c
>>>> index 56c71474008a..036e1a72a26b 100644
>>>> --- a/drivers/gpu/drm/i915/gvt/vgpu.c
>>>> +++ b/drivers/gpu/drm/i915/gvt/vgpu.c
>>>> @@ -382,6 +382,8 @@ int intel_gvt_create_vgpu(struct intel_vgpu *vgpu,
>>>>
>>>>    	intel_gvt_update_reg_whitelist(vgpu);
>>>>    	mutex_unlock(&gvt->lock);
>>>> +	kvmgt_protect_table_init(vgpu);
>>>> +	gvt_cache_init(vgpu);
>>>>    	return 0;
>>>>
>>>>    out_clean_sched_policy:
>>>> --
>>>> 2.34.1
>>>
>>
>> -- 
>> Regards,
>> Yi Liu

-- 
Regards,
Yi Liu
