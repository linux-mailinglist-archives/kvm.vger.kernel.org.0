Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F59B63E8D6
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 05:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiLAESG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 23:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLAESD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 23:18:03 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA2324F1E;
        Wed, 30 Nov 2022 20:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669868279; x=1701404279;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LiCxzYTkBWeTo2e8n0mC+woHuv8EDtG9rtSUemiRa0s=;
  b=S8Z0FQyBZHiu0f5AnwKvCaCvfupkVChx8VvkODjkkd7+1Rzi/FWc2HzV
   yENCALN2M+rMGb6Ml6MS7/XpwhPevpecukJdk4ubgowN8IL1tK1dhuoHL
   93FcDm3KYpdkHdPh8D3jx8O0B8uDeXTOz76a2aVdAUcKGYy7ttkHqJBKo
   7hg6dMfsIefkzGx8iZoowbX3RseLIo0/xlghKUQSuGiIm+VTh+rwl52xr
   Qt9n66WxyX6KLdYWwWUuoBt3j0beJAVzDtfk8eoo2/P5ZO7pRB0U8cexO
   PkzP1cCs3OHeg8FFt6jnIDvL67SanqgjEigIwyL83yrSDF6mPRtQ6qL0V
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="342507067"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="342507067"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 20:17:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="818892078"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="818892078"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2022 20:17:53 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 20:17:52 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 20:17:52 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 20:17:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnhnD360l7RTxaATpSrD3bBM+ybmLF1hVOLdGaeCzXkQOaCxn5l+Y3PHi0iLMfkNothdxoKmItRacqKneF2ZxZK8eh4PQtBxLAkvtVFJ0YY7WVqAYqH9z/DYjeC/DGmzKGHVj3xq+WQncmgJacs7/lELec4ycvJUHkVb1H4rEq822WRXgRZefs1N3SMEJ9GSzqaEUgUWM0AWoAxep9m8Ov7l4J94djXKCxIW3nSFdzaY709foJvC/21lJzBmbDFkPsBYiMPLIHcNPhiu1qkQES/HR3jK/yg6VVNOar0up/45xwhq8/31S5eC16BVk9yV2RbuZNOb1wolAIHCtJQuGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SQ+2uiFSfuZk3OARgJ8gxxZzDO02boiaKBlkOdI4nEE=;
 b=l9L25qDd1SM1baaO0rogiiCaE+umeBaQ5WvFYeYWI0fM/mqRzFTU3VOdEILhdALPaRDUNEE+wVBrkbeCfNPxQVyuijboc9zLJyU8QqnEO4eCqbqU6mrZQ3ffPxRAhiLtoBINaLYwsKDWINHbyiI/E8x3oRMDgMvioE5sCroFbwOVxZge037FJMARMIvULGUi+GIPdmubgGO9REaLDL13pDfRTIUW+XiaXLSygIXnRsU2Zv/gORTEdzNO+e6+SVXB2SUxYg5MY4hOit4z99r+KA0R+cUIAOVdvIKlDR/5G8Gnjcucatb5p1B32JavxA+aJHbGQDzTKgqfncNgQjgIaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 04:17:50 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 04:17:50 +0000
Message-ID: <47b0f601-5022-c083-44e8-4048031dddd4@intel.com>
Date:   Thu, 1 Dec 2022 12:18:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [[RESEND] iommufd PATCH v2 1/2] i915/gvt: Move gvt mapping cache
 initialization to intel_vgpu_init_dev()
Content-Language: en-US
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     <jgg@nvidia.com>, <alex.williamson@redhat.com>,
        <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
        <mjrosato@linux.ibm.com>, <chao.p.peng@linux.intel.com>,
        <yi.y.sun@linux.intel.com>, <intel-gvt-dev@lists.freedesktop.org>,
        <linux-s390@vger.kernel.org>, Zhi Wang <zhi.a.wang@intel.com>
References: <20221129105831.466954-1-yi.l.liu@intel.com>
 <20221129105831.466954-2-yi.l.liu@intel.com>
 <20221201032531.GY30028@zhen-hp.sh.intel.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20221201032531.GY30028@zhen-hp.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0250.apcprd06.prod.outlook.com
 (2603:1096:4:ac::34) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH7PR11MB6522:EE_
X-MS-Office365-Filtering-Correlation-Id: 29647099-10c4-4a0f-6f22-08dad3530274
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZWzDRJlQradXwtO+aCqtFcY92zkmXsUv1sBtrYwKw+QvgaiG/1Bu7ES8NvKqahtGf3KkmOfFG5yl1EXuhlZFu+Osl84FQ8DRxPSg7FM5vi0t/Y/iHhTmxDSL7ItacHnlZLzE9WISDyeldVe4CkG6rxC0ucUtwYxHVzcY1R3If35mjXINv3lzUtUMx/Z9ykLWQg2x+tTZGW3vYlc5iHjYO2r6cnJXNkE6cE6OJUk4eUhU/BuOWO0wbGJWTKzHSkZM7mX3/3RbgYiwgWU9ha2IIaxBj7wwBfveXtWOc3LkDf0XYG9gaDCUl22vStgei50EgJ5bTLOZ4+C6d/Sh7oNtXj40G+q0+UTxfptk2q9y+huedHFFcGUESJtyGy4xAY/xC1tMrSKDhlK8lWe4+xE0AejfMKuUMDECBEMvf2D3mPX04niK6jcMbHxW18wH/YDur8Dk3OcXwK1pQtJMc6AIqHNFwHmFthACWqYj6xIZL9UfjNpNFCvXQqOiSsccmD2roXsCR10P1jJzRM+WcLzUvNZrlwegVMJSriesPFnNk5YVTGtUZmMxmJYGDTf4YY6qpCi2+Psz9qkDfE0Od632Bb+x0IEOqAyziJH6PJipAR6tTclX5FrWSib10rcpCOsj2bA7y0Otf/6+gm07orQE6LYWNVzEGG/xJgc7XMdHRnV8R86+LNbJC5FQ258NNgdNXc3Rfn7m7MEM7o6V+ud3rubXkTC3QkWSWBo236wkl2s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(6666004)(4326008)(66476007)(478600001)(66556008)(6486002)(316002)(6916009)(8676002)(36756003)(83380400001)(82960400001)(38100700002)(26005)(31696002)(6506007)(53546011)(86362001)(66946007)(2616005)(186003)(8936002)(2906002)(5660300002)(6512007)(41300700001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmVYdGpIZU5lVzMyd2lvVXBCL0tqK2ZPVjR4b1N2U3U1b0owSmdBWFZZOG90?=
 =?utf-8?B?WnpWa1hyMDROdzhCNHZSMDVQSjhWTVJaSTFKdWJxbWhBbzRlUHhJQjNIckox?=
 =?utf-8?B?bWtRTHlGekhBWjJZd01qUG1mRndqYmk0VUx2T0tSZE1iTllyd2t0dDA4STFs?=
 =?utf-8?B?M3NVc2xDQVBQc1VHaFZZZVRKNytIU2taSG5DN0VsOW9EK3pWUEdxNVN6VEV6?=
 =?utf-8?B?eTlsdFF0ZmxZV2pmRkRVNThmWlhiUENyallnWTBrcmRBRkFJK1V6S3ovL29J?=
 =?utf-8?B?cklua3RmSHBQZHZXVEdPZSt0blVtSzRjY00yZmduS1dTeHdvT0lxc1RtZ2p1?=
 =?utf-8?B?dzJ2T0FFdkFMY05IeTRrdWpaU0V5dXQrY00za0RoMGpWL1E1VnV6bGYzYW5w?=
 =?utf-8?B?TkNBWWdzdlNGQXNlZURkaDJYeEQxNHI1Qm9EbllndEZhK2ZJeThORmo1T2dF?=
 =?utf-8?B?THRiK25UblhvcHhZWWhtUEh3VHVvWEVyRy9JeXhpUUVGRWJ1V2RPU2tRSTNJ?=
 =?utf-8?B?SWc0OHRCcGoxbGhpUGxqSFpnQUhoNUZoYi9KdUNJa3ZkdVI2TkpVQld6d2w4?=
 =?utf-8?B?VWsxenJVNHNFeHNVMC9VRDBzaldzREYvRnM1Q01GdGRTZ0haR0VMLzd4K1dq?=
 =?utf-8?B?T2lMbnAvRTlzVi9jeGJnNnlKY3RDWDN6cmN6czNFRXR1MEorM3IvS0h4aEND?=
 =?utf-8?B?VFQ3VEVoaml4UitzdE9CSVhkVENOaXp5WXBhVnhncjVBTEU5V0ZsK3pWMUlC?=
 =?utf-8?B?Z2RZaytZcHlJVmMzRzMxWmkwWUVScmZEZ1V4SUZwR3ZUcHdHb0dGbUs2RlZK?=
 =?utf-8?B?S2FhN3hMWXZVTzBmN2ZJZ240TlNJQk45Y0p3eFg5czBBVVBEbWdGaWFmQkpk?=
 =?utf-8?B?aWpUQXZyOWRqaTVqUjB5cFI5QmE5WXBrNHgvbVl4aXg4aTZYTFJYd3JXb3Zj?=
 =?utf-8?B?Zit6dnBwNGlhNVRkdmtMMklSbStxalJ1enhKSkM5MFdwMUJibHlEQzQvcE03?=
 =?utf-8?B?aXJacHNYajRwY2ZTdC9SdGJhdVRnYm9yZWlQdERLY0pKdjNINzdmdTJ0MWpa?=
 =?utf-8?B?UnFxM2wxcXA2aXZVWjJCSjdPaldydmJ4STViV1RmR2lISWNhRkJGQ0l2SUdw?=
 =?utf-8?B?NDVCQm5SbzllYXd6eXpxZngrNGRJdDBVdXE4aXNCendGcnprZ1JUNDhhbS8z?=
 =?utf-8?B?WndRS2FzT3o4ajFGSkNTQlBHOTN5b0UvZ21NemdkTXlFc1NtNE8yWTRCRGZO?=
 =?utf-8?B?c1A0cFJYSEgyL25SbzBwTDRLRWQzYVBPK2ZxU1B3VW5INzdCSVAzODBTVzAr?=
 =?utf-8?B?NkQ0eDR6K2poUCtlTmJTcTBtWDVBNVl2ankyTWd5VzB4RkRQSk1UMGhLSFVJ?=
 =?utf-8?B?T1NNQm5remNJRTY2ejhrV21wMHdmKzcyQ00wQ3kyNHc0amMvS3RXcFk0RTVP?=
 =?utf-8?B?VXVoOFNxdzJVeHdKTy9nRGRkdkt3R25PbVhleHc5K1orNjNaMXZldWhBaGRX?=
 =?utf-8?B?RExnZTNqTlJPUG1OSmRPemJodnBSanJHM1l1cFVuNFZJaVhnZlVZblQwdzhv?=
 =?utf-8?B?QWhGMUtPT0VtYzBwL3JZUDlYTnFOTkhsaFpRU3NlY0VoRDVZV1JTY2wzb0Fj?=
 =?utf-8?B?aEcrVGpFNXpFNG1STUFzZVFOK3kwMFNlYyt0L0E3VXZXWGtZNHhObXJCdEZH?=
 =?utf-8?B?blZpK0luNEhPeU1ZR1p0a3U2SUtINGp0Zm9OMHJrY2l3aVBFZ1VzK0orRFgr?=
 =?utf-8?B?S0NzcVhZNVIzSXowQWZPQTFpVFQyZ1RjTlZ6NVVlQVkrYUJWcVRpeEdKeE1k?=
 =?utf-8?B?VXdtTVF6RmJCdHc4Wmpzd28rZFJ0TURMZTArdTRSKzlPY0NoQ3VjeHl0cUx2?=
 =?utf-8?B?TWNSZEtyaGh5NXpTTjlpR2l3TzZuQ2o1WUpYbTNlZDJYck1rL1NNV3VEcUtY?=
 =?utf-8?B?NUVLejhMN1BDVmVyWjdZdXdjNHlPWWdyUWhQTi8wdWhGUkxLTTFESGtrUkNp?=
 =?utf-8?B?UklMWTljamRZSXllOXpkdXAyU3RnNkNpSG9waXdKTjJ0eldUQklBTkFsOXE5?=
 =?utf-8?B?bUxLUlZZN1MvaERDTW5OUTVFNkVMUUk2aVdodHZibGxEN1JZZlM5NjJKTkJs?=
 =?utf-8?Q?HxAbUykTxsB3SevvMWbNd24Zs?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 29647099-10c4-4a0f-6f22-08dad3530274
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 04:17:50.6558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ut/ZPCwJZ4YW28RfpZwuTsuw69Mx2iLnz4/C2XI6EO5Ntn+AWcfxRSJvwYa/LZ0ODuMsEqo+LHEbyHyeqEGQAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6522
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/12/1 11:25, Zhenyu Wang wrote:
> On 2022.11.29 02:58:30 -0800, Yi Liu wrote:
>> vfio container registers .dma_unmap() callback after the device is opened.
>> So it's fine for mdev drivers to initialize internal mapping cache in
>> .open_device(). See vfio_device_container_register().
>>
>> Now with iommufd an access ops with an unmap callback is registered
>> when the device is bound to iommufd which is before .open_device()
>> is called. This implies gvt's .dma_unmap() could be called before its
>> internal mapping cache is initialized.
>>
>> The fix is moving gvt mapping cache initialization to vGPU init. While
>> at it also move ptable initialization together.
>>
>> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
>> Cc: Zhi Wang <zhi.a.wang@intel.com>
>> Cc: Kevin Tian <kevin.tian@intel.com>
>> Cc: intel-gvt-dev@lists.freedesktop.org
>> Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   drivers/gpu/drm/i915/gvt/kvmgt.c | 13 +++++++++----
>>   1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
>> index 7a45e5360caf..f563e5dbe66f 100644
>> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
>> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
>> @@ -671,9 +671,6 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
>>   
>>   	vgpu->attached = true;
>>   
>> -	kvmgt_protect_table_init(vgpu);
>> -	gvt_cache_init(vgpu);
>> -
>>   	vgpu->track_node.track_write = kvmgt_page_track_write;
>>   	vgpu->track_node.track_flush_slot = kvmgt_page_track_flush_slot;
>>   	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
>> @@ -1451,9 +1448,17 @@ static int intel_vgpu_init_dev(struct vfio_device *vfio_dev)
>>   	struct intel_vgpu *vgpu = vfio_dev_to_vgpu(vfio_dev);
>>   	struct intel_vgpu_type *type =
>>   		container_of(mdev->type, struct intel_vgpu_type, type);
>> +	int ret;
>>   
>>   	vgpu->gvt = kdev_to_i915(mdev->type->parent->dev)->gvt;
>> -	return intel_gvt_create_vgpu(vgpu, type->conf);
>> +	ret = intel_gvt_create_vgpu(vgpu, type->conf);
>> +	if (ret)
>> +		return ret;
>> +
>> +	kvmgt_protect_table_init(vgpu);
>> +	gvt_cache_init(vgpu);
>> +
>> +	return 0;
> 
> I'm fine with this change, but could we add some sanity check at close
> time to ensure we clean up any internal cache? Btw, do we need to reset
> rbtree root pointer?

I noticed there is gvt_cache_destroy() in intel_vgpu_close_device(). This
cleans up the internal cache. So even the rbtree root is valid, it is an
empty per close_device(). isn't it?

>>   }
>>   
>>   static void intel_vgpu_release_dev(struct vfio_device *vfio_dev)
>> -- 
>> 2.34.1
>>

-- 
Regards,
Yi Liu
