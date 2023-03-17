Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D37C6BF565
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 23:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjCQWzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 18:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjCQWy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 18:54:59 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8068583DA;
        Fri, 17 Mar 2023 15:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679093688; x=1710629688;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gncmSRanoi//o/rpTKAVNN/a99BCwuMZ50gluK5ZJ3k=;
  b=Q9Kg/vsf+SmObh1YMI7KE+oTRuALJrry3nOEcU1WINQhnh+V87DvCkyU
   qxS6xKyVMAQv+BPOEWu9wXk5FW8jVRgcA1PAxwQSJs3am1fTxruE9e/Y7
   ZyYbb7RgJkBONFrplWhFOVqfW6MjmYrPYAfRGbdayrmZUeseewTdPQWhc
   TtpBmZugCdShc/vbKgSs5CIMS7SvNf2cUbYvoiOrtqWDBygFB+cfdbmxN
   4f0I1fu5AARR1WgE8LR8XjeXvoSnOzY/KeL1mCvFkDCS9XWe7kGZfQK6z
   ysuYQ4XFCEnz4l5e7BuPJebtJU8ArY18bNKKcLUZQ8OhdMTCFVuYsKfKn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="403249479"
X-IronPort-AV: E=Sophos;i="5.98,270,1673942400"; 
   d="scan'208";a="403249479"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 15:54:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="926306573"
X-IronPort-AV: E=Sophos;i="5.98,270,1673942400"; 
   d="scan'208";a="926306573"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 17 Mar 2023 15:54:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 15:54:46 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 15:54:46 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 15:54:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cb0Vq40XX6qhM1tz/YIwfzjOeyy+67hB0KQcb20qhymZ+acs8x3a8n1t3Thij7Kn2vu/0LICH62TTFjGM3Vr2V6pXxMGlQbOlVlu1ARf8jZInW67a29Ez8H6lksYI2GI3IlHYhvCx3Y6druZruSH0gOn1MKXw5QCwl/K+QuSxYS2VBuaNTuc3kbKop3+4Hew4kIuOA2PnppqnbvPiNtqg9xJ1S9oSZVbNIRdAkRICTuQOc2QK1nz9jBRbq19bJKxBiFjQ+644rA7EjsYGTvrpmOIPO9Cui4R0pGyUMn4lv4+VEwiBq6Jqp52mgfw5zGxK9Sr/vMmnw3XqXZKsyfksw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rM8Wn6HwDI5zilVA6jrpx13LZ9NwWXc4BzWLVK+aitY=;
 b=QCCBfxSw5T02ZXwDthAGRKlZZj/xniQi6fM0gShn8RqpNW21LPdasCkhsCcwO8FQl/xcUY0TDbbMhPF3QooQfho5OZABC1tjIiAUtyuVGC6Tomq1Ia4NrA3G4P7Fdr+KL+aJQF3oeM/SRTSzXoAqtov0BT0wxYcxYFrF6H0+6J88klHE1jhhpiVWAzdP/mZQtgeYvw0AfrDPlirsbtTcuvWkjbKVlWMbON9hXbAJhNXayBtWyy/lksTLDuYCw5CzVph4rmw7Om94crD8E3g/TJKfl+E83udEy7AToteVfDM9eBdXctnJwTJokGUfEV24u6yI7EH8aWnhS0w/JY/JFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by SN7PR11MB7418.namprd11.prod.outlook.com (2603:10b6:806:344::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Fri, 17 Mar
 2023 22:54:44 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f%12]) with mapi id 15.20.6178.035; Fri, 17 Mar
 2023 22:54:44 +0000
Message-ID: <e2d3f5a6-0a36-f19d-8f19-748197c3308d@intel.com>
Date:   Fri, 17 Mar 2023 15:54:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [RFC PATCH 7/8] vfio/pci: Support dynamic MSI-x
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <cover.1678911529.git.reinette.chatre@intel.com>
 <591ce11f4a33e022fc9242324ebdc077202bedaf.1678911529.git.reinette.chatre@intel.com>
 <20230317155835.79165907.alex.williamson@redhat.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20230317155835.79165907.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0069.namprd11.prod.outlook.com
 (2603:10b6:a03:80::46) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|SN7PR11MB7418:EE_
X-MS-Office365-Filtering-Correlation-Id: 122a4d9b-b7f7-4fec-878f-08db273a9990
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pHSa2H3ruAodA3TKmgFn3AM2BMjLXwbbIc9z2nRdan40N3HEhuLVfEwvuHm+QsyEDgdvrUCOl5DdbOVQT2OYdnTGxWObPWhe+2Pva7DuEe2UzUK9GR1j6IDsvuxH5Nk9EalI8yngwP4gsuHUw0L1YyHR0Yb/XcP8OduB++iwaAe8EbIPFS8n/jpg1R8aLw6IMR21RoI5xw7WvOruOKWNZrv80O47vnZkw9+azye5fGyuQjq8nv2+6yM1F6tPJZC42rd/62sBaTFQWGwCJ1ztlJ+lvGahhaw5OefMahOULAMJnjS+CVxiU3kkMW43ITQj9C9WKNrOmM7kR620apce05rz28ynzWjM6o3eVoucZ7zgbgo0MN4oaMU4yRqG3hZ6sqgg+SYuaB7SFrViCYOJtUe3iX/oi0nzov+BFS38ltcapVTHj3xr+4wc8PD6olgJ7cQGSsPBwdSm7qA/1skPDoucM2ZzwY46k6UWZTgsU1lyqz0oRL5hWFtMSgXzzNyy/oLg2PNb7Jopon33uCrN8Ad4ZTUNp21qhZIK/0GgGlv8hIpgEi35RdAJ1GZnN3h77Cut6tr2kRS5va6t+VP0mYEx6+TShc6LOzf5W/KUPqTB0AyxrlYsJIiTdT7+W/AbSrkMtR9vPw22nxRQ0ujpCqNhabufw5c0UAe9qSlV01ZSyY3KsZHrCLxXjUasbsL30hrkD40pecYfu6MmTJu/NeeZC16Di9mB3wqAYr3jFOM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(396003)(376002)(39860400002)(136003)(451199018)(31686004)(82960400001)(966005)(41300700001)(478600001)(66556008)(8936002)(8676002)(66476007)(86362001)(31696002)(66946007)(36756003)(38100700002)(53546011)(26005)(186003)(6916009)(6666004)(6486002)(5660300002)(4326008)(44832011)(6512007)(6506007)(316002)(2906002)(83380400001)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzUrUzh5SHBWb3RqTHhYcnYvOGhQdjNJdVRDdHNaN1MrQ3pUZXhPQUV3WWt5?=
 =?utf-8?B?dGJEaUM3a25zMkNmN2kwMmJ2ajdhYldTUUdicTUxRVdNd1NpMjk2UnlidjI1?=
 =?utf-8?B?K2hUR2sxR3Q5QmpIdFpIWXE3eUd3UnJ0eEtGdFNFR05JS0FLWVFmbDN4Umxl?=
 =?utf-8?B?TVRRT1dYZFA3c3Y4ZVJiY0RxSkZVWVBXalhzZ0RDQ2pVejFOSHJsNGdSbDh6?=
 =?utf-8?B?ajlsenlLaFhFaTduYzNTV1B6TTFLQ3NPUkgreDRUS1hEQTdGdm9qZ3RYVmNo?=
 =?utf-8?B?UUdXMWtKN051Mi81ckhReE1ybXZQYXM2c0RPM3lod3p4ajhyNkV6Y3k3K0Ni?=
 =?utf-8?B?SFJoNlVLZ2dKbWd6NXY1MEM1K0hWZXhhWG1BQnNjZldSdHpGeFRCb3VCb3dn?=
 =?utf-8?B?dXlYTUI2akQvZVJramZGWVg0ckQzcGswNmZnb1JpTTZXLzU3Vy83MkFEZ3Ri?=
 =?utf-8?B?Rjc1ODB1bW5KaHNnZC9DUXA5eGFtSkZ2UDJHRXFYa2dHdTNtZzFaYnAwc1hU?=
 =?utf-8?B?NWo0T3p2VGtNUERhYWZmSSs0bVkrMXRWWGxOVm91eXo5REw1L2hBeVlQaFYy?=
 =?utf-8?B?WWZWL3R4alRIcDJLUTVBZVIrRDdiOXVYTStrU1JXWVlwWDIwd3ZTdTdweG9Y?=
 =?utf-8?B?SlFpRjhWMStwVS9ReDNCNGFKVDNmT2NRRkJOMkRwdTNrQ1lCai9PUkYwQTFV?=
 =?utf-8?B?dkg1R3BpTENMdThrRHlsSUYvQkIya0YzdDIzT2x3UGlGYlFwMUI0RDBKeWw3?=
 =?utf-8?B?c2tJM2pPcXFObGV1RXpVdG5lQVBGZTFMZzZjNEtKb2RUZXhIS1VwQ2JkTGx6?=
 =?utf-8?B?QkpiUy8rQlZaUVdjVytRa3gwL2lEWHU3clFzQm45VDNtWTcwNUZlUkMzUDBl?=
 =?utf-8?B?TzFpSHFtWW5uYUg5WGFvNkhLWlRhU1cxNUxkNHY5OStFL0pBZVZQS0pkcWkz?=
 =?utf-8?B?WHQ4bTdMWWg0OERwbmN3RFZSQUNXOGljSGhVS0d4Kzg4WTU0QkdFMFJOdU5I?=
 =?utf-8?B?K3hmOGdiOXdidjcyMDAzOHFhUGNaeW1PVU9QZVhMWmlBYlJCelZwNU5wVXJa?=
 =?utf-8?B?cUhlaXhPdElhYkp3OE92eXhoN3lQMTVXYnRSWlZCaXhRd00rdFV0eEYzOFNW?=
 =?utf-8?B?N0JHZnZ2OUhYbVJUWGV5ZkRKN3F3aGtRVFFzRkViRmtxaHIrWWlQRWUwV1RS?=
 =?utf-8?B?aFBZOWUyYWltUTAxc2pCZmZnZ21QUFpsZlFBUG95MzJPVVRROHNZTUkvOVZk?=
 =?utf-8?B?V09CQ28zWDV6Uzc3WExWMjN2aUVSQVBzeWZVcno2V3JwV04vaEpVa00xNXVm?=
 =?utf-8?B?dWpFaFh4UzFZTnpxa0R0NU82S2t5V1lSS2VJTEJXWVlmbG93Z0UrZFdKdlR1?=
 =?utf-8?B?TFlKbHlnRHBVTmtoTDJYckYzYUtwSTVSN3Y2RmNuTy9pMjN4bStzM2l6MThH?=
 =?utf-8?B?ZG5VRTNsZE41UUUxWUJHckh1OFg5akxTWmlwVkd4L01pVGtOUTBzNzJqZHZY?=
 =?utf-8?B?YjJGQW5Scm5EZ1lNSHN0d2pHMmlwbktQcU9sdUl2amNEZHpHczQ0MUFsWjdi?=
 =?utf-8?B?d25NN254ZTZCV0pPdzN1RFY4enA2NVF2a0VzSVZaT2h3d0EyWjJQR2NlNG5m?=
 =?utf-8?B?eDZsLzBDeGQ1WllPeWtOdklMRm5ORmhtSXQydlVldWlNbmpUb3Ruclo5eTJz?=
 =?utf-8?B?dVJ1aGxWTERlU2w2T3JLdHREVVErUWlNaHRSRVA5bklhbi9mMUQ2VVE4UXVI?=
 =?utf-8?B?QTd3RDZwZXUwZjROWGdQejNiV2xJSjZwOEIwMXdGVk01V1ZRM1Z3MlNxZlZS?=
 =?utf-8?B?WVpnQnpTOEozUUJEVHZFWmlsZkdPc0NYbTZIOXVxektnaXpvdHNaNFpRSktB?=
 =?utf-8?B?UkRHSUNnQU9hRkR2cFlodzRORFBWL0xUYm96aGpyYlpVd0VRbVlTNGpNMUlT?=
 =?utf-8?B?UlgxRSt3aUZuMHZBZnpBKzZWR282TXI4YXZKV292aU43aExWK3FaVU1lYnFw?=
 =?utf-8?B?SnJuWWw3eXJEeG13M3A3aExyR2NiczlZR1NJdkFKSkFSVERES0l5NGxaUGJn?=
 =?utf-8?B?N0VnMWVGTDRiblh3enVIeFBlTkYxc3NNVlpFSGdSRU0rQmJmTkxBVFNiR2pp?=
 =?utf-8?B?OHJidzdESjNHR05SdlU2WTZEOXJxOFc3VVV5aHNhSFN5dktXUUk0bjdBWTRB?=
 =?utf-8?B?cXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 122a4d9b-b7f7-4fec-878f-08db273a9990
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 22:54:44.3373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t15pceTo/ReqpN9wOKriA5s2u/rtH+nY5Svt0fIsv2CKyhjo39qAX46IzHawqVVw/DUCZDOYAlZa5flu60leB9gTc74ZPx0POK5KLRfQ+Qo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7418
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 3/17/2023 2:58 PM, Alex Williamson wrote:
> On Wed, 15 Mar 2023 13:59:27 -0700
> Reinette Chatre <reinette.chatre@intel.com> wrote:
> 

...
 
>> +static void vfio_irq_ctx_free(struct vfio_pci_core_device *vdev,
>> +			      unsigned long index)
>> +{
>> +	struct vfio_pci_irq_ctx *ctx;
>> +
>> +	ctx = xa_load(&vdev->ctx, index);
>> +	if (ctx) {
>> +		xa_erase(&vdev->ctx, index);
>> +		kfree(ctx);
>> +	}
>> +}
> 
> The only places calling this have a known valid ctx, so it seems
> redundant that we xa_load it again.  Should ctx be a function arg to
> reduce this to simply xa_erase() + kfree()?

Good point. Will do.

...

>> +	if (!ctx) {
>> +		ret = vfio_irq_ctx_alloc_single(vdev, vector);
>> +		if (ret)
>> +			return ret;
>> +		ctx = vfio_irq_ctx_get(vdev, vector);
> 
> This suggests vfio_irq_ctx_alloc_single() should return ctx.
> 

Thank you. Yes, will do.

>> @@ -464,25 +506,38 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>>  		goto out_free_name;
>>  	}
>>  
>> -	/*
>> -	 * The MSIx vector table resides in device memory which may be cleared
>> -	 * via backdoor resets. We don't allow direct access to the vector
>> -	 * table so even if a userspace driver attempts to save/restore around
>> -	 * such a reset it would be unsuccessful. To avoid this, restore the
>> -	 * cached value of the message prior to enabling.
>> -	 */
>>  	cmd = vfio_pci_memory_lock_and_enable(vdev);
>>  	if (msix) {
>> -		struct msi_msg msg;
>> -
>> -		get_cached_msi_msg(irq, &msg);
>> -		pci_write_msi_msg(irq, &msg);
>> +		if (irq == -EINVAL) {
>> +			msix_map = pci_msix_alloc_irq_at(pdev, vector, NULL);
> 
> It looks to me like we need to support MSI-X with both NORESIZE
> behavior and dynamic allocation based on pci_msix_can_alloc_dyn().
> It's not entirely clear to me where this is and isn't supported, but
> the existence of the test helper suggests we can't assume support.

As I mentioned in my other response ([1]) I cannot see how pci_msix_can_alloc_dyn()
can return false. Even so, yes, I can rework this series to support both the
original and dynamic MSI-x allocation mechanisms.

>> +			if (msix_map.index < 0) {
>> +				vfio_pci_memory_unlock_and_restore(vdev, cmd);
>> +				ret = msix_map.index;
>> +				goto out_put_eventfd_ctx;
>> +			}
>> +			irq = msix_map.virq;
>> +		} else {
>> +			/*
>> +			 * The MSIx vector table resides in device memory which
>> +			 * may be cleared via backdoor resets. We don't allow
>> +			 * direct access to the vector table so even if a
>> +			 * userspace driver attempts to save/restore around
>> +			 * such a reset it would be unsuccessful. To avoid
>> +			 * this, restore the cached value of the message prior
>> +			 * to enabling.
>> +			 */
>> +			struct msi_msg msg;
>> +
>> +			get_cached_msi_msg(irq, &msg);
>> +			pci_write_msi_msg(irq, &msg);
>> +		}
> 
> I don't follow when this latter branch is ever taken in the new flow.
> It's stated earlier that ctx and irq are coupled, and I believe so is
> trigger.  So if we had a previous ctx and irq (and trigger), we removed
> it and irq is now always -EINVAL here.  Thanks,

From what I understand MSI-X can be enabled without providing any triggers.
That will result in the ctx and irq existing, but not trigger. When a trigger
is assigned later, it will run the latter branch.

Thank you very much

Reinette


[1] https://lore.kernel.org/lkml/61296e93-6268-05cd-e876-680e07645a16@intel.com/
