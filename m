Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3EDC6A4518
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 15:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjB0OsO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 09:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjB0OsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 09:48:11 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0B37284;
        Mon, 27 Feb 2023 06:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677509290; x=1709045290;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=icoUvm4HLbQs+ZnPWO3vMGdHRMQw3tl5Nu9MACzBjqE=;
  b=VXwM/LuZhhgDC3737cbdOc1egYLLnNwbJOlqYekBzz58TWaqlw948dQr
   5WHZT9v+gbLDDQGuIu0oFZEvID+bNN7MoSmQe5Lza3Q1tBMKHm+g8SCPJ
   jCZg6Hce6NvITX55rk2Qd1b220/EmrJlqAte6H8bJAjXkKYu0PuV32hda
   Alkv77Y+RNGQ+hgly21Tsmf3XjeEb9vUrYIs19aYgej0jtAtZLyqGzNfN
   ztTQhPHU9elzA3nFMGjs1dmZXj8t/E16m/ZIQfgEvlOlumzHnRU2c0aao
   pnIsvBc65UhNZXGCLGHkKu3ZQAAQgetU9h1KLV71+hP+k1RNJOpwenpnV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="332594205"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="332594205"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 06:47:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="651253674"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="651253674"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 27 Feb 2023 06:47:56 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 06:47:55 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 27 Feb 2023 06:47:55 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 27 Feb 2023 06:47:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWuYtdgIZBkFezhuq6NFhSauSV17LvHu1+GZt7glIlks6Pr/DZ7xQFg0C4Mr4GTXnf+RkUyw4AXtdATokGgzdn2gmWTAZmvgS+ghpIhK15Uqvg+H0HC1jqaQqGgTDubd+MCNhqKfv7YG7txCXvPbOtAIJO3mMlRIzvWXxM+bmaNlHi3BXcrnNouDjSmDr0+lGynSx2NuB/DzvnwYabMeIpJVmWkpoYVpcZBhgyDh7y1leJxm3B5n/L3uVZ4OIo74R96HyAnt0E9dCEYulp/QubpTStMUluRxr5izjG2LlT/uIsZltKsdTYKdTG2l1GzOn1pGfxmdRWr0obzBqgnKkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pVoQIVB/DzldRPaGZHdNRwYcIbs0nTlHrE3TdlZ0iPo=;
 b=F2GKqpTVZ0RxPSYDAvilJ84oAQYFMBtFulHi4gJ/eO0HO+/pmVuD7ZxNTPEpkn2H7BPz4/Et19KFUN/H/4lqeRaimsaA/TwnLInxJQ4Q/E1+6oY/tJSsC4CBueUjZ6ap1328iVK9kEKsBgf377uQbU2AU3UXxilzXoY0wSnaDMUcIcsf6hiJLs3dK539OU/JwYeQWyo3+Qdyq7pp1YO2e/eSPLoT78pk+JcyhBKIpDZisKnJSl5d0gP4VXb0x1vUdh1yOdNUgj+z6PeHBqXe0rgQ/DlKFkM5uZhR961IJHj/t7fEIog8xtCnAvPBQ8V/BR9cQa/q0gXt5SIbWOSBbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH8PR11MB6831.namprd11.prod.outlook.com (2603:10b6:510:22d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 14:47:53 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 14:47:53 +0000
Message-ID: <95377047-6b26-b434-fc90-2289fccc2a0b@intel.com>
Date:   Mon, 27 Feb 2023 15:46:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 3/5] lib/bitmap: add test for bitmap_{from,to}_arr64
Content-Language: en-US
To:     Yury Norov <yury.norov@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
CC:     <linux-kernel@vger.kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "David Hildenbrand" <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "Janosch Frank" <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        <linux-s390@vger.kernel.org>, <kvm@vger.kernel.org>
References: <20220428205116.861003-1-yury.norov@gmail.com>
 <20220428205116.861003-4-yury.norov@gmail.com>
 <20230225184702.GA3587246@roeck-us.net> <Y/qhL8kSzzhMm+tO@yury-laptop>
 <Y/qilU0cW6ebmrnM@yury-laptop>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <Y/qilU0cW6ebmrnM@yury-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0016.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::28) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH8PR11MB6831:EE_
X-MS-Office365-Filtering-Correlation-Id: 15c6e445-9a11-453a-04d2-08db18d19afc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YJnQ/eMfbDp2KLVM4UpwMx2AiEWZtUksf5pwCeWhHoZi8eo6k/JHCi2AaQPRDYrO8YWVirG4hy7KKJGnMT02NTOX5XS49EJV2kKkjBvgV48CkB1vbrhOol1TktWMxgo0ZccuWKqkjoY0esnvKfLGRGunPDqlj1tfujBxeMRuCePqXaYffOvgnl62SHFbhSDMPQoKrVBYJnBhEePKujyOOBt6jGtuJh0/qcROq19LKYbKNdApVw7Q/IIU2AoxCT19z3fEHlcR0JfrQKDQd8sUItD+ZPvkVSwR+6JSskFiB7YokA9JVXIjPhZr/vbXiAJYkaPWjCf8t6Po0d4K7N+ni2O2j7fBTPSuT3wt3xr79vjub/DQuwTxQzAEjo8o+27ekfskOkgASmJDobprFnnjPGMYLAiGELTS8sFb0I52Q5hLbTdHI7ax3w68XCoe+phRKR29OydPhsSWXLL4JVEFnC282O+gnDJ2rFxsAp4h8/e2pOIwZTQCV6AJaE0dEyvSUCPySe04qS7IKq6A8pjj4hb9P9Y3MfW4RbiF+NbxiHiLqsjzV3PJrjEMRzKZSrvvf8T2NPW891XNPYPihbM4VSaZxGVSqXoKTOzcGYzN6/TU+7Mo3w+fQ+AScGGQ4f6i9XJ5r2EZ3lxeiSaLroCXb4U5pQE2zZt1SDPTpKaCKIifX1njzWm3ZmME16HekLyXjzy1vyYAPPs1FfYJ3AdvTJatqZsXxzFGelEvLCDdFRo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(396003)(366004)(136003)(346002)(451199018)(36756003)(54906003)(110136005)(316002)(83380400001)(6486002)(66556008)(478600001)(2616005)(6506007)(6512007)(26005)(186003)(5660300002)(8936002)(2906002)(41300700001)(86362001)(31696002)(7416002)(66946007)(66476007)(38100700002)(4326008)(8676002)(82960400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFU3Mi9KYUpGQjRWN280dWZIRlFJVzF2MldLZDdGUm95ajQ5cTZOZnNxYWda?=
 =?utf-8?B?M0ZhQUMwQ1ViZ0JSR3drVEhtRGJRN2VKTUFmZ1VheUIxTU0wcXBaQ1dxSG9K?=
 =?utf-8?B?QStselVhd2xvUVZQY2xncnd3NWlETGkycHAwMm9lZTlYNGFIYzV2TEFTRjZj?=
 =?utf-8?B?OXRLOUcwSTJlaFZsMTFZT1c5Z1pQL1NMZmhyL0sxYVVCQ284TExxWkc1OXVx?=
 =?utf-8?B?U2ZsZmxKN0NEV25qak5zK2kwdmtGVE5ZVzh6OVAreWFRUStsbUFoMTFyVHhv?=
 =?utf-8?B?M3FVUWxWZ0x0Zzc3K0tvVXpqejFicWJ6eU90K2w4THFpODF6SEZIb2pEbkhw?=
 =?utf-8?B?bTgweFp0My9KY2oxNjEyeDllYVJsbTR2cHl6WUhSb1o3b0Q3OU5pcmgvOWNt?=
 =?utf-8?B?eVdtb0ZtNm9YM2I0Y1RKWjJabDBPSHU5Wlh0YXBrMHRCV2FETWxzU1B3ZGhp?=
 =?utf-8?B?dHNkNmFZSG5Hb1RuY2xpQ3JVTnR2bFpDRzY4dTk0SXdrUldQRU9WLzZWbEwr?=
 =?utf-8?B?eTBHU1BmUGE5dlhEa0U0bnljNTJudTVoVzE2blllMm5HemEwQyswSHQrQlBR?=
 =?utf-8?B?L3Uva0tFSTd1b0ozQktjYit1dFREWXd1WUh6cWxUbXZlbXpRb2dZMHFWaFkw?=
 =?utf-8?B?T3k3QXhtSFBFNXJOTnAyMzcwMk5UTVlhNzIyam9Db0hienFuNjZVZVc2aEN1?=
 =?utf-8?B?SGw5YTdlNlRpeUpTdUJ4TXYzOHJmTHRJaWF2SHNiUjVGWThTNGtLOGxHTDdK?=
 =?utf-8?B?SkszZkpvd1N4Nm0reHhHRlZlYmZOd0JCeHVJalVYV0psdm9Nd3UwY3FweDYw?=
 =?utf-8?B?MmUxUWtqTS9NNTl3Qkh5VHVDbmREV25rV05JTmVGZ1lYSjlUamdpVmsxSFM4?=
 =?utf-8?B?cHNRMTVzYnBYaEFEQjVpblRvcU1GZDllZit3eDI5UE0xRVBRL3lGektxeUYx?=
 =?utf-8?B?bWtXQ0VteEhFbVhTZ2hHeTgvRmY5MDN1TUZ0OGJaU01NakRoTHZGWDIycnlZ?=
 =?utf-8?B?TFdBYVIxQlpRSVN6aFVNYkhaNzJDYUVsRWNSWjJZR3pydU1PenArZWFvTml5?=
 =?utf-8?B?eFlJWTAvQVAzcWlxQ2lVZ2Z0ZkE2OWdaYjVmMml5NWF2YkNBUzBnam1hUXM1?=
 =?utf-8?B?eG1JSFJSaUR1dWhvbXRvQmdpS0EyVG1lK21uUmxiN3FLM2FjYUVmM2Y5YVpn?=
 =?utf-8?B?Q09tRXBXTWZRMW4rNTAvWHVXd3NPY2NxTW9nZ2xTVmhqU0pGNmZ3TTZORE1i?=
 =?utf-8?B?NFZnbU9YYS90RDdrcmF3NUREL0ZsWDh5dkZFVithbmlyUHFBVy9NTUJBL3dr?=
 =?utf-8?B?WEdFeTl6ajJXVklxR1hsY2pEOFVobGd5d2luSGxCUVovc1NLd3RUWXVsbFdF?=
 =?utf-8?B?aW5DUjVKYlNjTlV3V29mV0xvSHltanZDNndVNGNHRU9LeVRmRG5lWFlyc1Zj?=
 =?utf-8?B?MWI5aUVQcXg1YmptSlljNXVEM29ITVd6Z0dQcVA5RCtkV2RDMXFWMkVxRVRE?=
 =?utf-8?B?Q2xkQ0ROWVl6MWRoN1hWRm9Od1k0R1RMMlkvZWRON0pVMzBEVGMwWGtDQ1Jr?=
 =?utf-8?B?VzIyY1oydlo3ZE9DTHBvalVGcU9rdkhHQVZDaFV5S2twQnZJbGF3MkNWMWxJ?=
 =?utf-8?B?dURzOGFabjZPUEYxUWRDcmkxUGRyT3ZaR0VuVHh1Yld4ZVlXSTBDczNWd2R5?=
 =?utf-8?B?ZGxqWFVmb3dHaWlNT0F2YnlnSi92NlE0azJUeEtZWUtSNlNSaGVLV1RuS0J0?=
 =?utf-8?B?b3A0ZkpJWEZUMW56RUsreGVLRGRQUHFhWnhJMjY3ZzZXV05wUFVOb01hNDVX?=
 =?utf-8?B?dWVjSUJmekRvVkdtNFdQc0FudzEvc1lOdUdCbnF6cDZDSjVMTWY4T2d3WXVl?=
 =?utf-8?B?RlkzSzhoOVIrQTNaZzNSbUhOZ2JsVWRubzVrS09mbnF2aXhRTkNXcmZXWlVr?=
 =?utf-8?B?NHFITmR1RmZmcVp0ZEVDUEhZaHd4NTNad01BNnhvWFFYa1pvMWYxb3pkUWsx?=
 =?utf-8?B?emluR1VMbFBIeGhtdHRHb3JVNEkvemhqdHRmbEFjTC93MkNUR2pWUWJpVHVF?=
 =?utf-8?B?NWNtQUo4b2o3KzFEaFBmdjZqQ0FLV1dIWDRqUEx4K1pvZlRFa3BkbHBkWXBr?=
 =?utf-8?B?amtrZWFyKy9wNnJHd29IK2UyZTZLTzlqem9LM05qbkkwbG9scnBKTTFHSmxt?=
 =?utf-8?Q?E4KSaUTTmjs4z4TRVIgmOUk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c6e445-9a11-453a-04d2-08db18d19afc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 14:47:53.2996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d7jfRlRkU3ZlKvSV0M45Tzmdz1Dmpip82nlcWOQ1pJFDZY/6nri6Sy7YdYVo/gs/T+5o3sAYsKeRWJP0K/FXJ9a71G53EsI8Dx7+Yx9t9Tg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6831
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>
Date: Sat, 25 Feb 2023 16:06:45 -0800

> On Sat, Feb 25, 2023 at 04:05:02PM -0800, Yury Norov wrote:
>> On Sat, Feb 25, 2023 at 10:47:02AM -0800, Guenter Roeck wrote:
>>> Hi,
>>>
>>> On Thu, Apr 28, 2022 at 01:51:14PM -0700, Yury Norov wrote:
>>>> Test newly added bitmap_{from,to}_arr64() functions similarly to
>>>> already existing bitmap_{from,to}_arr32() tests.
>>>>
>>>> Signed-off-by: Yury Norov <yury.norov@gmail.com>
>>>
>>> Ever since this test is in the tree, several of my boot tests show
>>> lots of messages such as
>>>
>>> test_bitmap: bitmap_to_arr64(nbits == 1): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000001)

Hmmm, the whole 4 bytes weren't touched.

>>> test_bitmap: bitmap_to_arr64(nbits == 2): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000003)
>>> test_bitmap: bitmap_to_arr64(nbits == 3): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000007)

This is where it gets worse...

>>> ...
>>> test_bitmap: bitmap_to_arr64(nbits == 927): tail is not safely cleared: 0xa5a5a5a500000000 (must be 0x000000007fffffff)
>>> test_bitmap: bitmap_to_arr64(nbits == 928): tail is not safely cleared: 0xa5a5a5a580000000 (must be 0x00000000ffffffff)

I don't see the pattern how the actual result gets generated. But the
problem is in the bitmap code rather than in the subtest -- "must be"s
are fully correct.

Given that the 0xa5s are present in the upper 32 bits, it is Big Endian
I guess? Maybe even 32-bit Big Endian? Otherwise I'd start concerning
how comes it doesn't reproduce on x86_64s :D

>>
>> This may be a real problem. Can you share what's the system is? What's
>> endianness and register length?
>>
>> + Alexander Lobakin, the author of the exact subtest.
> 
> Forgot to add

Oh, thanks for letting me know!

>   
>>> but then:
>>>
>>> test_bitmap: all 6550 tests passed
>>
>> It's because corresponding error path doesn't increment failed_tests
>> counter. I'll send a fix shortly.

[...]

Thanks,
Olek
