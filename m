Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9888C623A29
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 04:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbiKJDC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 22:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbiKJDC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 22:02:58 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7942712AA1
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 19:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668049377; x=1699585377;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A+2k+UsbhkGCaN/GM9SKvHqIxPJjRxnPhS00WSPVoi8=;
  b=BaRjb2iQFmjz4vo0RR9EH2ukAjBsA29sjRBZHYGvbblOLuDMMqg2qkJ4
   o7VqqdfhsGTmcCjPcbVaDzIfsrgeEg/kQmtO9+PSAjAO5BeCqEIdnJPjS
   jQVnNWyk5Rx+bVCxVV/WMxwvcbcse5eUJr6V5GUzN0SAKak78Hfxzc4hV
   OpQF6dryE40ny4v96Vw4OEul12TMGkaog0ZiSWWYKsqHc7RunUqznCupj
   LOmKkdDopp7daKMHvwdDfBBZdO+c10E8eBJPInPkUFlV9LVmD+klKuP14
   34r9HlNR98DQq19gC1lhZqVXwF5zWmsOPk0ASEpkrQdZ8VyAuKeTLyp69
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="373307344"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="373307344"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 19:02:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="668235459"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="668235459"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 09 Nov 2022 19:02:57 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 19:02:56 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 9 Nov 2022 19:02:56 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 9 Nov 2022 19:02:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X39QfsD+56LGQTqXYlDcfeyz9+Im/4BxglrDEgQU/xZvlVJ9UCD20jnnvnbu8J7774hXMRc4Fod6iJ4HjJsFZHdfJxhiRhB+EUe3mnKft77d2S/C+kZN74ZVnEkqKH8qkm+OiXgtDsxeOJ8I30NGLvx4bQMnnmJuW2SR7IvlFT8BO3yA1tOCg9ndjd1R5wcfAM/70YLoRq7R9F4mOf0D/OA2HyoyaZxHK6GxIh7ieuYhdYsa/SZSjQ2kmRhenJvaI2X4nX4KXPIUl9x59ZWY/JvfM7/E1lqWDA6/wfG4s8g6XN8cqgXCMXcmRvAOHNPdxJc9dC5K3paHivMc2f0vzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W1RsJL7TZ8GaizEakVc13NE6U9vUI27bgnKFwqqGpYU=;
 b=mRdggLv61DqnuPYJbP9ILOvjaeyKbEXZ7L/lv9DyhfImjyfuz6pc0bvdet6QxyCaz6qRxRl6DOk4gq8PVUcx7s1D7GEIdFsvxivwdul/dfOxVeAUnxANpqhqsXGZeD/XtkMryId0dX3pmxkM+Vq5lh+pKjpS6Y8k566zlCmAY4zmHp3YWR/sCl5FRVkEJlO8L0rPzu79QVvGwDgioopufel24jK0WIXiPGHbCgTYWt6e0Dl4Juf9RVuNuvf7jHNyvzEVxGxNNmlS0fLcc86BV8rkmg43oZE+EdTjB2KAH55Tx5W7jx+zTcmzIJjdwq9iBolOI6hjbraZPohjo34DdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB6723.namprd11.prod.outlook.com (2603:10b6:510:1af::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 03:02:54 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ad39:e00a:a7cb:4ada]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ad39:e00a:a7cb:4ada%7]) with mapi id 15.20.5791.026; Thu, 10 Nov 2022
 03:02:54 +0000
Message-ID: <49b64e4b-43b9-ec7b-23d2-2fa1bf921046@intel.com>
Date:   Thu, 10 Nov 2022 11:03:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v6 3/3] vfio/pci: Check the device set open count on reset
Content-Language: en-US
To:     Anthony DeRossi <ajderossi@gmail.com>, <kvm@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <jgg@nvidia.com>, <kevin.tian@intel.com>, <abhsahu@nvidia.com>,
        <yishaih@nvidia.com>
References: <20221110014027.28780-1-ajderossi@gmail.com>
 <20221110014027.28780-4-ajderossi@gmail.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20221110014027.28780-4-ajderossi@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0035.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::8) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH7PR11MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: 3adc917c-de43-4825-f830-08dac2c8100b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OmNjhZhgwj1C4y95WoQ23ywLSz8RB9n4Jpp8Sm0ZRJ5gMPMk8lbhupdp3o83vsk2kLcEiZ+fB44+t6xNwTRYKd4UrYkT1e1edL5mjdzJS6hv+8Awb2r9bmLAPaNofnzsafbzeFdm/0Lkko6JlnMFwof9KdLgvEm3balMWKPh8rx4wxLhVLb/EKAqfK/UGLu1ojZLcrbykyMTEUZpWnNLxu/oaieLXOIlp/FKMu3racJv2ENvZ4afHBJgzqOCFlNDJU9JgBoIgTdaqXikh0TR55aIaoBmUEfsFKGR/W6tMM/OviGFgVRjYrr7SyxvHbDHNUsf66ZP+TnYdP8qub+pNnfmCGKGpaGFLrMhpJ8z83RC4WZmUwZuRlYDn5RS8IPC2Nzt7SEjzbKjT5CG1bsoY6EcWpo3uVvnx7tyIwU4N24R5JYsGtGw8wKcs6MA2Eb7aene1sN7pilvMffKxIe8VGCXkqnqNkWuc3FDahfKlhAhVOcYDjEcA48QgyfWuxzmzRKa6fgICX3+vR774SpCScl8mCtWgeEQqpo7smg3/fVsGWPm1vZgJBzzzIeZLKjJ7TIQpOULMsak3kg7aXpPZ7pKpRe/cSuvlmNxnEE7dolbPzEWguBEhPlD5NsfclTS0R3jG2mtBUNi55/Rw6W+5kWe9/YY2MmrfHHMblJ/qzREd6SjzaqMETfbgHZTjgOoM7/XUim8eko8Qsb3QDPUgh/vQZbFcz7dNWt27qnOWJtel2UvXVy39QFv2M6iOSSuvTsQeRSK7DmCPv7ophLIRBtNNWBaKLFHN+3Ine4FRXQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(396003)(346002)(39860400002)(451199015)(36756003)(8676002)(316002)(4326008)(2906002)(41300700001)(66476007)(478600001)(6666004)(66556008)(5660300002)(6486002)(66946007)(83380400001)(53546011)(26005)(31696002)(38100700002)(6512007)(6506007)(86362001)(31686004)(2616005)(186003)(8936002)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0t5WGpaTExSdGRCTVduR0tZTU5pQ1BKRUtaeU9Xc2lFWG50SXJtY0VBanp3?=
 =?utf-8?B?UXNwZ1VWbURzRGYzSUpCNnpkLzBYV21xdFZCODNpU2dRb29UNktkK3RCVE9F?=
 =?utf-8?B?aFBOZTRvTlM3S0IvQUhWVEw1aHU3WVBWWFlIcVZ4WHN1aThlN3Z0YVc0dC8w?=
 =?utf-8?B?UnpVY3hOa25zRVBMTG9IR0k0cENCMFg2Q3BEdlZCM2ZXNlZDVHhUV25FYTYx?=
 =?utf-8?B?YlhHQTZMVW56WHlkbmJaNW10SWJOR3ducHJ5a3J1U0xVOWZ0QTcxZFh1NnlR?=
 =?utf-8?B?U282aGVsVXEvdlN6RVVlRkNibHhQVGJtazE2amN6eTVZTG5UMGh1SXpUSzZD?=
 =?utf-8?B?Tzd2ZjdnRTJ2YjczaDVqOEl5T0JGSVZvWklNU0hQSkFHaVNWVVF0aSsybTB2?=
 =?utf-8?B?Zkpyd0lNZW5DRE90b0J1ZjNkMW5MaStsbUFCamFXKy82anhLK3VGT0ZlOGdD?=
 =?utf-8?B?WTNWTzJybTA1UUwwTmdxanlzZFV5Q2VicXVENXNudDY1WDc0cm0rVTFOM0dP?=
 =?utf-8?B?OHpGd01rWjhpM2ZBOXhCY2kvU2duR3FDdmlPSHF5RHVINWJZbWkzb2VocGV6?=
 =?utf-8?B?c3BJdWh6dFdUdDFqdEx2ZGJ5MnptbjUwWVgyYjBOKzBVNm8rYjBwby9yTkZ0?=
 =?utf-8?B?V2Mya3o2L1VreGVBbUF2QTJEOGZ1MGxVY2ZoaXhuT2hGaHpyWG9RK3l6U21G?=
 =?utf-8?B?SkhIMHdNQVI5SnZyVm4vZU5CemFpYUpNdmNvTGROeDRMaGxBc1hIYk5GRVM0?=
 =?utf-8?B?R0R4eHZ3MnBwQStmYmFSVGNKK3IrMW1Gd004U09FUHovR1QvaFkvVnZ6K2ov?=
 =?utf-8?B?YnBzL3NTdUhBNkRScDlCL2l3dVZvT1YzKzlEbklheHQzMmVuSEt6Z1ZLSWZE?=
 =?utf-8?B?MXZwWGZZcHJiaUIrNlBPczhrUzNoeUUwNFBYSGYvUjVYNnFrNXZ2V2FlQzZF?=
 =?utf-8?B?eWU4VkQyL0QwNGV5c1VBLzJpS3VvUTZyQ0E1NHZzanJ3S3dlK1BISVdpNHg1?=
 =?utf-8?B?eEo5Q2ZtWUpZV1hNTUJWVHRxeENGVitSYkVIQkFvcndxVHZLNGZCaUFlS3Jh?=
 =?utf-8?B?TFZROEprT2pHWVhLTjBwamRESUlBbGkxcUY3ZVFFa3JVVnIrT2dNVUVFRFBB?=
 =?utf-8?B?cjY1SHBSMTVJb3pUaVVqYUxhYzFZN2tSeGlDL0ZUdFVOaUVDeUo2Yjc5L1Ba?=
 =?utf-8?B?VFJpeU4rRU5BWHdvQXBrQWNyZDVJakZUd1pSangvemtTSWpDODBJL1d0enM0?=
 =?utf-8?B?NnFqUyt0SmxNR0xqWWxkRGx6UGN3TnZMeXZNOU43V3JobUZQUFc0bE1PaU9i?=
 =?utf-8?B?T3B3RWkxSHZQMm5pUkg4RUR2Mzh2ay9HZmllY0lBbXVlbWxIQW9Eem1GemNB?=
 =?utf-8?B?NW8rc0dqekZ6K3YySFpHZUJVOUNFV09YNTVTWVZmaFovWm5BUkJVdFlWRjN4?=
 =?utf-8?B?RGFaUDhzRi9KdVRrR24zTWxVSi8yc2hkaFdjZ0NaWDNPZ1FIa1dqNjBmdUpK?=
 =?utf-8?B?WkdEOG1icytmMXBVcnJLV1hCK3B5R25jM2V6N1FxbUY5YWtVWHNHT2hOVmN1?=
 =?utf-8?B?cm5zVmtrUi95OGtNU2Q1UWJ1VXl4T1BVQjFMUUp2Vlc0cGNvMHpTZkg0allI?=
 =?utf-8?B?K3J4SU1BM0tZeHdXcm9IdzRRb3VYK3h2Q1NBckFxOVR6NWpBWXZYR1JoS1Zi?=
 =?utf-8?B?QllTS2ZxcU5lYVlvd21kR05uMUQ3RzVlOFNKTTVNQ2tCdXo5NWNFUmQ3Mnpj?=
 =?utf-8?B?MG5VTWZGU2U4RXo1cnduOFl2dVdvR2hwSGFmU1dwelhLR1JicGREYzJoRXJB?=
 =?utf-8?B?K1dnMXBrQS93aHRpNUJsakVPdlU3OTIycjJqaTNBZzl6VUUzL0xicWpsNXJ5?=
 =?utf-8?B?Q0NTaTYrUEdURW5kdkJRWjJ3WS9zRjUxK1U0bXNpSXZ1bUhaL3A0U3NuNnJR?=
 =?utf-8?B?WHFMV0NkN2RZNVJXdy9SWnZXaEZaSENjSmtqZi9nQngzKzVCM1UxNUNhWGQ1?=
 =?utf-8?B?Q0gvdkxDdHBtSFFwWjgrR3A4Mk40ZENYSkk3dGZ4bE9OaUg5QWp1VnROQ2Y3?=
 =?utf-8?B?TTl2aU9nbXZFczNVbG1aY1BzVnk2aXdZMmJVOEFvaWpPTWdhM0xqeTF1aDNZ?=
 =?utf-8?Q?eixO5MphLqm8Wme/K7XMWdnSc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3adc917c-de43-4825-f830-08dac2c8100b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 03:02:54.8094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fZGA/OzOq/r8cShSjysyC/CWh8SXIVNM1+ws3ma3ehC1Q97mqNEvATyCpglXGTkqmpP1EfpyUD8P2VYKl/feXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6723
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

Hi DeRossi,

On 2022/11/10 09:40, Anthony DeRossi wrote:
> vfio_pci_dev_set_needs_reset() inspects the open_count of every device
> in the set to determine whether a reset is allowed. The current device
> always has open_count == 1 within vfio_pci_core_disable(), effectively
> disabling the reset logic. This field is also documented as private in
> vfio_device, so it should not be used to determine whether other devices
> in the set are open.

haven't went through the prior version. maybe may question has been already
answered. My question is:

the major reason is the order problem in vfio_main.c. close_device() is
always called before decreasing open_count to be 0. So even other device
has no open fd, the current vfio_device still have one open count. So why
can't we just switch the order of open_count-- and close_device()?

> Checking for vfio_device_set_open_count() > 1 on the device set fixes
> both issues
tbh. it's weird to me that a driver needs to know the internal logic of
vfio core before knowing it needs to check the vfio_device_set_open_count()
in this way. Is vfio-pci the only driver that needs to do this check or
there are other drivers? If there are other drivers, maybe fixing the order
in core is better.

> After commit 2cd8b14aaa66 ("vfio/pci: Move to the device set
> infrastructure"), failure to create a new file for a device would cause
> the reset to be skipped due to open_count being decremented after
> calling close_device() in the error path.
> 
> After commit eadd86f835c6 ("vfio: Remove calls to
> vfio_group_add_container_user()"), releasing a device would always skip
> the reset due to an ordering change in vfio_device_fops_release().
> 
> Failing to reset the device leaves it in an unknown state, potentially
> causing errors when it is accessed later or bound to a different driver.
> 
> This issue was observed with a Radeon RX Vega 56 [1002:687f] (rev c3)
> assigned to a Windows guest. After shutting down the guest, unbinding
> the device from vfio-pci, and binding the device to amdgpu:
> 
> [  548.007102] [drm:psp_hw_start [amdgpu]] *ERROR* PSP create ring failed!
> [  548.027174] [drm:psp_hw_init [amdgpu]] *ERROR* PSP firmware loading failed
> [  548.027242] [drm:amdgpu_device_fw_loading [amdgpu]] *ERROR* hw_init of IP block <psp> failed -22
> [  548.027306] amdgpu 0000:0a:00.0: amdgpu: amdgpu_device_ip_init failed
> [  548.027308] amdgpu 0000:0a:00.0: amdgpu: Fatal error during GPU init
> 
> Fixes: 2cd8b14aaa66 ("vfio/pci: Move to the device set infrastructure")
> Fixes: eadd86f835c6 ("vfio: Remove calls to vfio_group_add_container_user()")
> Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>   drivers/vfio/pci/vfio_pci_core.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index badc9d828cac..e030c2120183 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -2488,12 +2488,12 @@ static bool vfio_pci_dev_set_needs_reset(struct vfio_device_set *dev_set)
>   	struct vfio_pci_core_device *cur;
>   	bool needs_reset = false;
>   
> -	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
> -		/* No VFIO device in the set can have an open device FD */
> -		if (cur->vdev.open_count)
> -			return false;
> +	/* No other VFIO device in the set can be open. */
> +	if (vfio_device_set_open_count(dev_set) > 1)
> +		return false;
> +
> +	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
>   		needs_reset |= cur->needs_reset;
> -	}
>   	return needs_reset;
>   }
>   

-- 
Regards,
Yi Liu
