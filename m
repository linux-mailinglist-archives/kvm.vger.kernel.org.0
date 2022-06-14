Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4731B54A8E1
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 07:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237655AbiFNFsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 01:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237556AbiFNFsI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 01:48:08 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3793A702;
        Mon, 13 Jun 2022 22:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655185685; x=1686721685;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bFEz1tUkT3GqxJboY2RW9pnRx6qhOaiGELvRbGigAMw=;
  b=dKTAw3g6xvp8gA9fl7gCawKKCYoW4/we5pGRKtZ7ZVcII4xYTE0mwhnY
   cyF8zW+SnUatL5Br1pB+u5vkUyJEheW7JdkOm8aQfyIYGwv4snE8aghPq
   +AbexHWb3dcZ77pKhnJaosFHE1RoPkGx868T2yuRFiVTt0gHF33A8Y03H
   4t0e4d71AGOUWAuHPHF9Vd45tNHdRqr8YK5mfQ+a0FGnhvB99hthN0Ynw
   2kENoZNyx0uh8jjKayyOetzZGBkR+Zlalutq9WwbHWJ/bZH+/8Zon3fBa
   WtUGKllCGcVB4lKavT2xMwgRLrenWsmqWDmmEQr26azBFyq6QfiwacCYx
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="258345233"
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="258345233"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 22:48:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="673683640"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jun 2022 22:48:05 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 13 Jun 2022 22:48:04 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 13 Jun 2022 22:48:04 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 13 Jun 2022 22:48:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3J3k3OEDi7oJQsBeyRWhHLrVz1W7ig8f0FScrh12zgJnruepqku5wxr/Y+YOEiZvnkWTXsfJ4OysB9rghej82ewn/LFCulg6ZWs28tkhnikzp5Ro3Zocfk0aK9DfPgohjg+vsNQc8OWzCNFAvWUs0VUXeNjmVZPmQkb0M+1WYBQbjTIoiQpGo+Y2Hwd1HZAmYEdZQSPG5Jc7go6oHdKSDAcCtIYStfgmEJJS8qxtQlJE0hCN26o532Mi4sK3IaLcjmZnjTGkj1iLdhwZjk/bD0IPq3m9nIFhbQEEWZr/JGQeuRKyVeSaVUbRGyvtytzuXiPpeJJzYrwXlXHkjcX/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZ8nppjtY0UMkv2l+cOczHxfM4TDDbWed6Z4LuT0Ogw=;
 b=SEh7kaKZLc6jx3VoYo5mlu1oBfMG6ns+r//qTHDdfptJ12eTZpwVnT4JP64W30GZD5DzU+9No0egm9BZvxWWjYrP02XoZFFx2TXIovthVo6WiPTAadOhmyJRsn0nXhsvvZ3VuaoaBJ3qSQfRTz0ojbhPjcxJ2sSe8UlgHo99KyuLWDlNgvnwldfFXaVAM9ffC5hSrfzYqtKmqlAdp6mCti6vTqJ3T+nT8ZsOgv0Dkjbq6nUzBiDVt4oavc1bpGebMufEMTsnGzoARf1qfZzncz8lykZmqY+KvvHgTe8i1YFA1iHBfORQhUoPBqeWsxMNf4X2ShZO9AXk+aluRAM94A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by BN6PR11MB1297.namprd11.prod.outlook.com (2603:10b6:404:4a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.19; Tue, 14 Jun
 2022 05:48:02 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d518:17a2:11e6:bd6]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d518:17a2:11e6:bd6%7]) with mapi id 15.20.5314.019; Tue, 14 Jun 2022
 05:48:02 +0000
Message-ID: <406b5461-07e8-362d-b7e9-814d85836daa@intel.com>
Date:   Tue, 14 Jun 2022 13:47:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: simplify the mdev interface v2
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
CC:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>
References: <20220614045428.278494-1-hch@lst.de>
 <0e517684-8b10-5410-8ad0-df7caed860b7@intel.com>
 <20220614051723.GA30556@lst.de>
 <168474bd-579e-a895-31e2-00d855d718de@intel.com>
 <20220614054431.GA30824@lst.de>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20220614054431.GA30824@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0252.apcprd06.prod.outlook.com
 (2603:1096:4:ac::36) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c91b01f4-fc83-48a2-f1a2-08da4dc97210
X-MS-TrafficTypeDiagnostic: BN6PR11MB1297:EE_
X-Microsoft-Antispam-PRVS: <BN6PR11MB1297E8A522C9C5E858587209C3AA9@BN6PR11MB1297.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OyPL1OSH82LhCnx9Wd+9WNu4aGuiITg3Q5aj8hsv9RDbHinyiv+gkf5+IP5et+bojfJoOHTDZcQPrm2ucEBmxqSWHw7LjkrCB7MZiGV2VjHbebu/+7VGpJ2avp2+QV6ZsRzUEGNm8fcc1rU9RtVjRsHC5t39cJoAY+e3KRWb0FLsE5kvF1txI2xHYwyVHFYXarVCRHhuFd3xeTH8z7pduqk7wxWcNRuar1PXLo3e5OW2SVWxhZtQCt5c2W+2unOmhydHnWR5kjn47nIwyCFly1DHP5A3qp3BBb2IEeY14HOAbtU8k5CVYHFqvnR4PzkGjz18beCKHmBjZDeZxXSzw/P8ct0XMRQaYStTTGwQ9aaemgtCcKXWNpze9Yo9A+IC7ttz1IgftLS9hWcpbnAe4lgk7vm/dWeN7ZGC89kMFfBF8jpcV90yrw9fXXRNFDmcqTh7fuF9KGeCohHAJU4sJrlkPrwsMisbeJyW4reKe1dQIwR2F6fRdA1kHp69TgXtAhrnQ+nBhqoNYo3d3mqdG7CqFCJFZYJoJ1KRN3LXKqyVieU+9by6GpffVcKumFoAymrxKtU40H+6FxE5s6hCiXeH/hIrb1iKcKD1LwzMlN1xwFX2N3nDq5PAGLeSDLqZJ8UPfzbf2PQ87u39c9JngpGv8vdxehrg1Nsw/qNnNKNKi6StitxBbOqTmYxQPNugjpKH2XqD/xaoAmEDn6NxG0my7b1hdisW7F8dMmNhcJAj7TQvaQBpDo3fLn5oO9k5HckJAaT2HwwH9NPrZqJF+S6Mpwyqoq3e9wcoMT1PTGzd2DdhPD2rCKiDYW3vLnX4GdkzH4IVBltxE8zRyln9dA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(5660300002)(8676002)(66556008)(66476007)(66946007)(4326008)(186003)(82960400001)(36756003)(6506007)(53546011)(2616005)(6666004)(6916009)(54906003)(6512007)(31686004)(86362001)(26005)(38100700002)(4744005)(966005)(2906002)(6486002)(7416002)(316002)(8936002)(31696002)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TkRjeXZQcnE0TFY0ZUozZ296OVB6NDl5Wk1uYnk3dVhDZklWTlBncnZvN3hI?=
 =?utf-8?B?U0sxUjAwcDRYU2NKdzNESFVJbHYzVjRtZHNlQmJwM0c0VHVsYkJjVVN6c0Q0?=
 =?utf-8?B?STFIQUY0NDJFMVJsT1VmNTIyc0xoalpIS0M5eSs4SklEdmcxT05vc0R5ai9k?=
 =?utf-8?B?T2U3bGp3bWNWUTVmd3pBS1hnQlo4d2dDdzVTaTVxRTkyY2c5RXM0dFE5aUMy?=
 =?utf-8?B?S2xtZ0J2YktyWUw2bjNPOTFCR0c4bVl3UFI0T3l3SWpZZjIySHFGYkp2blJh?=
 =?utf-8?B?KzJZZUxtRTF1dkhtUFJnS1FaQ1FlRTFxcE9Db3RiVDZNc1BBbUs0TVA4OVhP?=
 =?utf-8?B?UjVvOWkyK3ZUMXAzM0E3TVdZSFh4eHJqQ2lsanVDN3NvRW9KdWlQeEdQV3NQ?=
 =?utf-8?B?cXR0KzkraUlRTzIrM0gyblRwVWRxREhQbnhlaUdDZ2J3QnArYXdQU2tTQzN3?=
 =?utf-8?B?aFB1em1SSjVjVkZpTWN3K2ZMMGhvWENnRnBzY3ZYZ3dUN1NUWDdlaS9UU1ds?=
 =?utf-8?B?L0QvK1l0LzJvUG5ETUk2eloyNUY0bFhnTE1ocjh4OGkrcnhoVjI0d2pqMEts?=
 =?utf-8?B?a08xZ1EvUlFublhrUXNjOWFwTUt3UTg1dU9Eak1pcU9kM25iNkZtV0Zxenoz?=
 =?utf-8?B?SmErdVZYenAzS1o2U2pSZitnVDJHdDcwQTd2UkJLbHlpaHdQQVBic01TaDlS?=
 =?utf-8?B?czBvUnkwc0JSZnpNVW56MXE2QUxYdHUzOEdKc1ZvcXVkR1NHbEhIR2t0VEov?=
 =?utf-8?B?dE05NXpoaUV0ayswcWxUTmtHeGc4bmI1NjB2ZVloUkxpR1NHUVNOSytnVlRE?=
 =?utf-8?B?eUJYd1ZRM090SkJFa0VSaWtQdnZNclRaR2xJN3ErSnFwalA1bVRNZ3dxNnl1?=
 =?utf-8?B?cTlSbW50ZWhPWVJzN0xEMEQ1Qm8xaGdaMzUvQzJEZnFITHFLZXJMZEttRS9x?=
 =?utf-8?B?WWl3c1Y5QzFIci9oTjhiZGlUL0RocytRQno2STRiUWNUV2Uza1BQcEZ4YUI3?=
 =?utf-8?B?S1lDV1FHa25xTnc5Tmtvbm9LRmxMWklid3VNdm5iQ05uOUlOOVRPS1phN3Ri?=
 =?utf-8?B?b1loc21NeWg1dHhvOWhCOFRDQkt5dlc4MmNYbXB1SmF3TG1ZQ2NHaUM5YkRw?=
 =?utf-8?B?Yi9Ybk93TXNueFNmWFhVWW5RM3JUeUdIR2dKTDEwTUpIZ1lwcm5JNThiNklz?=
 =?utf-8?B?Lzl6NjdVNnhCNVJJblhlb05yMDBrTGlNM2N4SytBdURhdjlpN1hwTXlBL1pE?=
 =?utf-8?B?SUNnSnBtaTQ1aWc2RkRkY3VGOGR2RHhSb0hOR0ZsS3oxY0ZVQ0RicGRsWGdl?=
 =?utf-8?B?SFBieHp3SHd2VjhTOXlWSVdnUldtT29XR044QytRazNlMGlIektFT1RoRXFE?=
 =?utf-8?B?K0plUGIxKytXZHF5b3lBWGZuT0w5ekZDc0dDdU5uT25LSE1DbGp6NFBvazF5?=
 =?utf-8?B?cFZCZElKME9mc3BObFlmNlcrdUpSMHNGdzBhUWtZV1ZEZG5JS1JzY1pGUGdt?=
 =?utf-8?B?NnZQMDVkMlNrV28wVW8yenlBdlcvMnpiWDlBYkxaUzNTa0ZpNXZtanU5ZEZS?=
 =?utf-8?B?eHE2a2M1eHd1Z3VKU2pEbXkvVnFSMFlUQlMxS1NySzVJOXpLV2swclVDTW0y?=
 =?utf-8?B?ZzZXdjZVa2RkYm9WYm9DRWxLenBsMzlPdHhGclBWY2lxWmNUaVFWWkpKQXNS?=
 =?utf-8?B?L0J3RURqaDlIc2ZDazRGYitEems2OEcvNEdYaXV6TlVpVkFnWFFZK3lhNklZ?=
 =?utf-8?B?TDF2OE9yUHdQRzZsQmM2L3ZlZkV5Uy9GdnZISitDVHVmWlhBM2w5UEhUNWFH?=
 =?utf-8?B?dVVwOXAwN1J5UVB6bzVvMTlLRkY0Y1NHeWhUMThGN0w2RGNlNlFOdHdzb3Fi?=
 =?utf-8?B?L3ZCNm1uQXU3eDVXdkQ3RTlKb3FmdlVSQ3cxS0N2cG1qS3l0ZjBnaVAxV3NU?=
 =?utf-8?B?d0FYNkp4S05Ca1JlMnlQQ0M1NTE0cXc2Sk1QK2RranRzKytZWFFnY2lkSUh3?=
 =?utf-8?B?amRicW91dkxhNE5TTjNWcDdBckxhQmhqUmFTVzdIWVIwQXI0NFg3ZUY0cTZH?=
 =?utf-8?B?RG1tb3dud0pYYzNzZnhvUEhoRFowVHdWQ0RJYUxtdHZWMGdOdDhFN3FZTU4x?=
 =?utf-8?B?b3NLdTJrcW9MVlpNdVQvQnZxd3RkLy9Zd2ZOTlBJZzNES3lhdXJ5UjFaMWd6?=
 =?utf-8?B?ejZWbjdabjZiN0M3RTVNQUpZR0hmNk42Z2VmNS9VQ3VrMDNwZjF2azJOVVl0?=
 =?utf-8?B?QUczbU9NUHFlVS9Mc1grSTFJdWxPU3JSczRKYXIzbzhsQnZPWlExMjdEYXps?=
 =?utf-8?B?M05KVmhpbzJzdTdOeDZCaDZnaHAyK3lFNG5SOFh1SG9RTzBpN3NwU2REODZU?=
 =?utf-8?Q?Ws5xXVGBbkjo0yuU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c91b01f4-fc83-48a2-f1a2-08da4dc97210
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 05:48:02.6480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fdntug7yBCgfC5l+qgkJ86awohVdU/rWA4qJ8EMPWZc53AyVxxFm6g62uNM+5jqUX6cSumFzS7s4lMA0oXkpZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1297
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/6/14 13:44, Christoph Hellwig wrote:
> On Tue, Jun 14, 2022 at 01:30:06PM +0800, Yi Liu wrote:
>> On 2022/6/14 13:17, Christoph Hellwig wrote:
>>> On Tue, Jun 14, 2022 at 01:03:55PM +0800, Yi Liu wrote:
>>>> Is this series available on any github repo? I'd like to apply your series
>>>> and apply my vfio_device cdev series on top of it.
>>>
>>> I have a git repository available, but nothing on crappy platforms like
>>> github.
>>
>> haha, could you share me your git repo? :-)
> 
> git://git.infradead.org/users/hch/misc.git mdev-lifetime
> 
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/mdev-lifetime

thanks.

Regards,
Yi Liu
