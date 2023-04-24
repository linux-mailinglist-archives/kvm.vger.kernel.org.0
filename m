Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4C36ED8FF
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 01:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbjDXXwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 19:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjDXXwa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 19:52:30 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0824C24;
        Mon, 24 Apr 2023 16:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682380346; x=1713916346;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hG5eZGHod8Pw8hnMQ1I9QBIg65YDw4jImP8e+fXl+OI=;
  b=B2AWI1jLTB8B/7+vF7zGX1wyaHv+PQzDRnHGw6hNiXTB+Dt1EXRNmbau
   X6PNX1ZQ5tlKsaH6/EW0j4OQflt02OCBfimtqMXtySPXOtGUM0k2sQMMG
   phPyji1HGLIceFc9OUm8oTlEj9KmyRTv+8WNDHJObWF/mAu8LZP7cVDUF
   rElbXirzEo9U1x0Cw/Qsetf8jHSC3tkuG5RLdSy/x7TRjJ+LtDDExNNCV
   nmSNdnnfDJ09dyiOecumy7LVJbaCNofIh7ZPecf/wcXJG2LX1LG+Gth41
   OB0Iaev8q+QipTc87LgMkkdYqf/8DRx8CGM+DRidqUp7sHlJbNfzUarXI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="411889526"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="411889526"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 16:52:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="757896915"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="757896915"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 24 Apr 2023 16:52:15 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 24 Apr 2023 16:52:14 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 24 Apr 2023 16:52:14 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 24 Apr 2023 16:52:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dz3Oau5bBq7IB7c7LXKpzpjEpS95nX75JjnFDcW3j2Fa7PmW1OUXaChZz1EgyYhd9SCZ1eJ+8Tp2QcmIbPxnahGLZpqiFXEkhte1sCg0dJYCnA+3x5IiWleT5mNJZQfGdsQt38LJ4Q91N2Aj++qsH79pRFJKqn4b6+ZUQjKtXGE/jbBmNWrmtyxfs9CvRi9VqhOFDvBZt/1ePhTZPuVqi0jrb8aT5Ftt36l60qNWOwP5QmqWXOF2OIkFPrxar8pB/M7cCPMpyK3/4MPQ51Hyj/p6RvkN7vKoXpkcgdzc5CYH5OAElCPDp1hHS/27yZWFe5zPcxE4DT5oM3uTCOhCJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bgoPhitnoThfwFAC8869vbU5xzgvBe39G7efB5uZI8I=;
 b=S8x3XZpZBZLvAGnSNreDwNpTHsqxkh7+HU21NOoTDqzh6ncCyj3EjXX3ZMBHsDK6V5DrkJHwLQi6iweT+FlPRN7eq2E8p95TcmHtlcJbDj7UTXtKTK4V/ECSH9BOmgYUiJB/av0El38rZmRh7QQ47QxipFtW9cmcq5MLKzahSiQuZwJSI0ITru77+Xgyj4W9WHq4VtdHm2ZzFYSPSRb4hi3MNjPrkUJ1UxAfWQpet+OtUYlVKfFrpxnsu400mqcd4g0zOLI4Kej4pq5foDRdxoYday/qvJFIbGRSq6BKYtfRXG5U8lhfxNJ+lRrtXqFsgTWAV7IHWNHI5T54Sqz7aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by BL3PR11MB6434.namprd11.prod.outlook.com (2603:10b6:208:3ba::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 23:52:12 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::2854:770d:2a43:dbc6]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::2854:770d:2a43:dbc6%4]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 23:52:12 +0000
Message-ID: <5167f01d-fcfd-d821-40fd-c53f4fc135ff@intel.com>
Date:   Mon, 24 Apr 2023 16:52:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH V3 08/10] vfio/pci: Probe and store ability to support
 dynamic MSI-X
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <cover.1681837892.git.reinette.chatre@intel.com>
 <0da4830176e9c4a7877aac0611869f341dda831c.1681837892.git.reinette.chatre@intel.com>
 <20230418163803.46a96fdc.alex.williamson@redhat.com>
 <64b99d1c-073f-cbc3-6c5a-100fa23bcb13@intel.com>
 <ZEa/rTKja3Xpy/j5@nvidia.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ZEa/rTKja3Xpy/j5@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0065.namprd11.prod.outlook.com
 (2603:10b6:a03:80::42) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|BL3PR11MB6434:EE_
X-MS-Office365-Filtering-Correlation-Id: e4027323-5c96-40c3-713c-08db451eebe3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J8V1A7lG0ptweW5kFPSW2xI6FyBDUgKhOHW55pJ0xy9bNnHYzMqgom5HwWm3rjhBxIpDcKICmCOgnnPeLE8TwMAhdb8Jlq9pI2/a5ZSrSKlAfEg0/DB83XJeKt4go8Fwc2SoJXM3v8sWIYPVshjkg/pnXgtNP96xcEnxjo4w0mTrZklpegxC5PF5vvOH4h0/SuQd3/Pp20ZUYxytxsA3DKAQbEPmnUrtWmO3ZQyQcznp8v6kkxPVF3DUC5P4WTcrBB8dHWak/PMwfig35R0Mi9tDkqsdjqKEu0cIaNCDjQQJ1qOfJvY4ZBodTt+bhxOKOKOnsKcjeHZOnByKxKEuI+9wLcnk3vSmyKqVAPz3VfgiX7xMHnoGNRcyFIw2EYOGnppptoY33G/AgOR8688h2bwjZeebr6qPXtt1Xopz7LWunELD79H4jT7a+5p/IyKKRPqrsO3W2BqDJyndjTWaNJ3dNrkA6u59gNfYYtPVgL3649DRAWZcQMtGw6UzQeOK2MVz8VBFVhdCJKUnAg0fnJxHT62qSt1J9YM5cS+NBLBcJcz8a08KzyGh3aRdjsUpa/WiUIjM2c6FsIv7Z02ApUN6yuV1A3C01E7QE81q2kv2kOqgXjfmUJAraiEoA2glE6M+4bqvNaS9fGehhAABOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(136003)(346002)(396003)(366004)(451199021)(2906002)(6486002)(966005)(6512007)(6506007)(2616005)(6666004)(186003)(53546011)(66556008)(66476007)(66946007)(8676002)(8936002)(41300700001)(6916009)(4326008)(316002)(26005)(478600001)(44832011)(5660300002)(82960400001)(38100700002)(36756003)(86362001)(31696002)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGNmYVcrRUVoUjhXWVhhT3pjZXI2eE5Ub2MwWmg4OUF3UUVhYi8xdEFSY1lx?=
 =?utf-8?B?L2VQU1cvYkdvRS82bU5CRmJUMmszZVpzSFdteFdGM000cE4zTHdrN1UrYjhn?=
 =?utf-8?B?TXFaVHNPTHg1RkNrd3J2S0g4OEdZSTBMWm04L3doOGVqei9iVk5kM0ltN21V?=
 =?utf-8?B?RE1FekQ5RlpoekJJVGFDeUZ5ZVU5K2xCWGZJM1pTb3pTZkVyRVZDU1pXay9k?=
 =?utf-8?B?NUJ1b2FZVHZqL2YyOWg1bmVmYmVSNVpZckMweDhnTXdFMWNmYSt6UmtBaUYv?=
 =?utf-8?B?M0pyNnZENU9tVVpORXdRQnFMYnNPcFFFMTQ3cSs5QXcrVEdXQkVmbkdVY3Vv?=
 =?utf-8?B?c1kzZjBHNGNHcVRiSVhsRjVQWVZFeUtBZ3pjUlJ2M05SaGEwRnowVjhiUWZF?=
 =?utf-8?B?QWsyVEtZRGV2WG91WEhmVkptaGNYeUFxM0E3TjVDQWhWakRUZ01XaDF6WVQv?=
 =?utf-8?B?c3F1SDNIM0tMNmpXK2kxWERTTzdJQ3NUTnpEaHdYSWpxS2d5UXRjRDVzSnFM?=
 =?utf-8?B?blpPLzROSHNDZHhOaUVBc2g4bWlKbnRXZTBicEJBaStNdlE3d1hiaCtTenJo?=
 =?utf-8?B?ektadGtpNXJUUmVvR21kVGZMc0lpem1PWFUvTndnYUVtL0sxN0NMa01RYTVJ?=
 =?utf-8?B?RUlHZ0U2T2lDakNaRnYraGt0Z2EyRG9GdWVsL0RrWUkyQ0pRdGNoRzB5dllj?=
 =?utf-8?B?MzVUM01LbjVFejhOeWNqc05sdHdsM0g4V1pyaEF1K050eXpNVXNXSHp5ZHRB?=
 =?utf-8?B?RldMZzhoSStvWDdBUGlVYmFuczRmYTRCZDZvbHhCWXhqOFFaNkRIT0hqUGVs?=
 =?utf-8?B?THZrdzRTS3FKZ3VCOWRMMzMvRFREWFJpVFJPOGg5aGlWeUxjNkxkR2VwQVhC?=
 =?utf-8?B?OW0yNmg5ZUR2T2Y2Sm1xa200SDRGaVMwMGpHV2xxSmRuMFlPeVVuSEZxMXZK?=
 =?utf-8?B?Z1JRSXhSZVZ1T012UXpkSGdQbUdtK3hDcFR3QmsxOVRvaUplaklPSzRsVTQr?=
 =?utf-8?B?T1IyUzFsTnN6R3MrcjlOemVOUnp0S1VtbmxMWFNiQ3V0Y00vTkxsZnk1OUVZ?=
 =?utf-8?B?cVd2SEorcWtJd0g3am1zQk9pelpGVlFvWjE2d1VyYnQyUC9Mdi9YR2tVZVVN?=
 =?utf-8?B?Tm5YUytUVEVHYXBhMHJQMjBBazZDQmJNVzBCb3RZYmM0akJLNnd0aWE3dlVz?=
 =?utf-8?B?cnRoa0d4QlNnVVd3T3p4Z1hWZk1uQnVzY0s4cEgvcldlejUwMUROWHhZNUky?=
 =?utf-8?B?RGdHUTNoTndjeW9GZHJaUEI4d1dsUWdUZ1QvVlRmZHNubDV3OEZQbEJVTEV0?=
 =?utf-8?B?QkVsdVZNWGNJaDNpR0FGNlNvRjVGanU5Tzg0R1pETXoxQU5aTURlRVZ6UFpG?=
 =?utf-8?B?NWZwakdISFNxdDlKeWdqM3J4RXhvazZQWjl0MUpkMEhLOGlFZnliUzVGWXhB?=
 =?utf-8?B?MWhuWVp0Z2NXak5TbmFDVlk4aFlCaHFjMU5PdTc1NnkrWlkwTCtYQlFEc3NE?=
 =?utf-8?B?cCtPRzdTTGZRSVNhR1BEdmZKS2lyUUNNR2cvdXpIMmJCektwdW8ySG1qWlhk?=
 =?utf-8?B?LzNyUUhaMWV3SUFTZUVvbm14U2dqWFVwV1Y2M0gxeFp3VHQrTTNwaldHMGo1?=
 =?utf-8?B?VXlaakFEUTVOZ1VCeGtnWDhPN1o3N1NySnNGeFgyWHIrcEgzdmIyT3pZUXo0?=
 =?utf-8?B?TTU5ck5OWEpIanRGbjAyQzVPUXlTd1VIMWMxZVkyOFBIZjlhbG9uR1RPeHhi?=
 =?utf-8?B?VTFhdTZCZy9CYUJ3NkpROElwRXdNeWxjcHJXS054K1pJWExtNFpkcytNR1V5?=
 =?utf-8?B?S2lWOTYzMzlxWkhoYUhoNFBtQlhRRklOREMzSm9mMHN6YVVBTis3aWs0OFgw?=
 =?utf-8?B?WHJwUVdKeUM3Q0RGYzFEcUhQTlV5QVNZNjNvZXJ1emxVeWUvOVdza1NqaHVP?=
 =?utf-8?B?bkhxM3NYeCszaFlkU3BSanpoR0xmUkM2Smt6VGh4QW9IUXVRQ0Y2bDFUeVJX?=
 =?utf-8?B?TEJISkFJMWhUNzZrMzJsVkxNZTl1Zk5WZzNNS0pFMml3L2szcWpKUXlvUkpM?=
 =?utf-8?B?U0JXRWVlTi9HSUVzOWFnUWtzMFR2TEVJVHVNd1Z4S2lVYTZZOTdXZHRrZFUw?=
 =?utf-8?B?Vm5wWDhzRUpPd3hDRkpaV0x3QXZvOXQvMkNjRFR0bjN1MUR2VXhlbGIzWUxs?=
 =?utf-8?B?Rmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e4027323-5c96-40c3-713c-08db451eebe3
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 23:52:11.5211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UN67IqHGYqdMMMM00RzljcjQnAQ75lZ/dbtzEqS9/GxDPE6c0UZkYyKy6gTC0QvJGGETEliG8hlzTh5LGK36FB7PATFVDvjK4/Y1Zab1RXU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6434
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 4/24/2023 10:43 AM, Jason Gunthorpe wrote:
> On Wed, Apr 19, 2023 at 11:11:48AM -0700, Reinette Chatre wrote:
>> On 4/18/2023 3:38 PM, Alex Williamson wrote:
>>> On Tue, 18 Apr 2023 10:29:19 -0700
>>> Reinette Chatre <reinette.chatre@intel.com> wrote:

...

>> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
>> index 4f070f2d6fde..d730d78754a2 100644
>> --- a/include/linux/vfio_pci_core.h
>> +++ b/include/linux/vfio_pci_core.h
>> @@ -67,8 +67,8 @@ struct vfio_pci_core_device {
>>  	u8			msix_bar;
>>  	u16			msix_size;
>>  	u32			msix_offset;
>> -	bool			has_dyn_msix;
>>  	u32			rbar[7];
>> +	bool			has_dyn_msix;
>>  	bool			pci_2_3;
>>  	bool			virq_disabled;
>>  	bool			reset_works;
> 
> Also, Linus on record as strongly disliking these lists of bools

This looks like an example:
https://lkml.org/lkml/2017/11/21/384

> 
> If they don't need read_once/etc stuff then use a list of bitfields

I do not see any direct usage of read_once in the driver, but it is not
clear to me what falls under the "etc" umbrella. Do you consider all
the bools in struct vfio_pci_core_device to be candidates for 
transition?

> 
> bool abc:1;
> bool xyz:1;
> 

I think a base type of unsigned int since it appears to be the custom
and (if I understand correctly) was preferred at the time Linus wrote
the message I found.

Looking ahead there seems be be a bigger task here. A quick search
revealed a few other instances of vfio using "bool" in a struct. It
does not all qualify for your "lists of bools" comment, but they
may need a closer look because of the "please don't use "bool" in
structures at all" comment made by Linus in the email I found.

vfio_device::iommufd_attached
vfio_container::noiommu
vfio_platform_irq::masked
vfio_platform_device::reset_required
vfio_iommu::v2
vfio_iommu::nesting
vfio_iommu::dirty_page_tracking
vfio_dma::iommu_mapped
vfio_dma::lock_cap
vfio_dma::vaddr_invalid
vfio_iommu_group::pinned_page_dirty_scope
tce_container::enabled
tce_container::v2
tce_container::def_window_pending

Reinette
