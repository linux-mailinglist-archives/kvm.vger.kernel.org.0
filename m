Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2930D5AA629
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 05:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbiIBDFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 23:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiIBDFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 23:05:12 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C56B19C02;
        Thu,  1 Sep 2022 20:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662087909; x=1693623909;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o0oPXlI+g+AaIWYmGdIpNTfe9tV3mBIAMSiprN8z6Jo=;
  b=MbIfbxCPeDr3WoUtd6AczM1YLqMlucgFKl4kQTZObI5oCtLCJ2eVyVOz
   FxX533uhJu++hFtE8v12y+Fo7sK+V65qF1LCqvi5j1oK+YGu9OgHGKgWu
   jGaTTkEzaj4ASdQrjNFRW4BgvbzTBubWW5S4YP8LYsL964De6cPr7e8zJ
   OkNpbDoh03yl2iuKf0iwkt/k1Eelck0eM5MTaEUWsUgKkifS9n4Vqqo7C
   oqzPJkiXJw51I7w/dKcfRmVr+SM9oahDRZ270jtUmCHHG3wE96M++e8Vb
   PcIZHfxbc6QG7WtcbOy7JxJl+3xZNMJwRJGANEihvsE70qqYAEwxGrPlZ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="275625059"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="275625059"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 20:05:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="738721937"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 01 Sep 2022 20:05:08 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 20:05:08 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 1 Sep 2022 20:05:08 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 1 Sep 2022 20:05:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQ+b8v5qhKoCUOL7S4y/yRfyJtfjuP5KOcABSfww/oM1hbYmL/RXzYyMrSeA0eDtb3HjsSsOPyFGEdYicjS2atLwYIRoJTJmYJJKzFLnAwkqql8tEUwrfkhftkHKvclm5v05DZ1NwUk0B+FW/ZTwUU91Wk8wRyJkrjSYfeFfio0cUS4Yfo3lb8k2Bj0nwzvrE6/wIKJyM1KsqwHEmAyhTB3EoigvRa1slmep9ixL9wmdYvSOOGUJN1Qd5wOc0NNjfGqP8I1wB/X0gPHdkIBx1x/uLTC1yJWYdV57h7RV2keHaMjWe7kxwaqGHIBr2sW5R6sHUEO5MYtoA+aCkWhvNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o0oPXlI+g+AaIWYmGdIpNTfe9tV3mBIAMSiprN8z6Jo=;
 b=kmHlPbJ0v0J90XWcf/zabr0B/8rTePSoq6bIjdlFD7LV8XlvSnylBCY1eOsjS8CFDsfkBL+GtttoGytcwOZn8mEgpgY/GMNKB08Xacu6QX4pR2gKgM1Fn6yI5UgqKH/iir13gYNZEoNQSc7H68eGO7Rn3LxsxDc00F/cOB5uW6HjjfK1MnzhOg0IbfZqSztD/FINbFZukb0POKzmjtl1n+DzQsLocj0f1k3m+nhl1gJ/FIl+Vlf+CgasV0f7eiQuR0+zTYcUPD9ya3IIyicBWGDtZ7LoKuNWIrQFBrP4KDLBwMWCZjcJ2RiJDuk9YcCl3WyD2I6W2kXogrwzTBBLBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SJ0PR11MB6741.namprd11.prod.outlook.com (2603:10b6:a03:47a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 03:05:05 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ddb:2488:14dd:3751]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ddb:2488:14dd:3751%7]) with mapi id 15.20.5588.011; Fri, 2 Sep 2022
 03:05:05 +0000
Message-ID: <49be2601-be60-4022-474a-28fe9ef03fcd@intel.com>
Date:   Fri, 2 Sep 2022 11:04:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 07/15] KVM: VMX: Support passthrough of architectural LBRs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220831223438.413090-1-weijiang.yang@intel.com>
 <20220831223438.413090-8-weijiang.yang@intel.com>
 <YxC/nN7k8gapMhzN@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <YxC/nN7k8gapMhzN@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0025.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::12)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73fc54eb-f5f9-43df-bcd7-08da8c8fef87
X-MS-TrafficTypeDiagnostic: SJ0PR11MB6741:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hCMo+Ff2IW1l3PE3UZbCPZpZUG09nZAbVsCsTXKQ4+7wcIP92b8nGMauom2tuPZsr2JATZ2H7rpzxNK8mfkkCwaQDbi8Gq/ZYEO3T4phroMHJBbfO8d0+RvcgFf2X6pxRNCS2M81JnjwjKi7W0gQW6w57M+kZi2owsKd1Pgs9ijNv0GlZ0BAeqXNwaCULm7HWJ6YUcx3V0xZ5BT7On+IoGVVW72aqvqm2MXQlqUtiTjmLb+UqrDbcseieNqg6OtLEvVwrJ3NHhL324WSSOYcAczLi3uFh9xNtGUj7rY2mxCjjd+kgiFadsvxpUZAYlhICe3pCgGsy9qRUryAK20pObfJBmTn/jzmbcymQS3zBbEew39TKlaE0SjkXK+SEywvLzerjYgqMuhg8driMR9V++wSUCsalsoy9WmcInNQU/rkpzAOynyhIan5XMY5gjMojDDyRSdM+RKKK23y8SDGdOKxyrck9QUN7rBEhTpQvoiEAKy6rILD6ap+9EaU9aEQsH4XGSv2wTc1HZybgohnk9DnncRvzMuenlOrESBIbdSgLdKeoUaaal8zgJn1xG4Kd89umnHgv0c25j5LhyFBvNIhEHQmlZwi424oi2PNYaP3mpj4LLzHkGHcXShqN/ySL5Caib5KyVwpKPNDNcajkXlIRM8JrWer2sTW//80loELB+qfizxJuu5kA5bDBBUglebaAEPhsKxbqghot/LKozUM1KIqy4pU/8LDCkz8OkDsr/cD4ZzZsXsMw2JFdR/kt/RSRzNEF3yPD4bQbfI+7Fce4VP+eWRUJlxIENtHk+Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39860400002)(396003)(376002)(136003)(4326008)(6486002)(31696002)(82960400001)(66556008)(66476007)(186003)(53546011)(86362001)(2616005)(31686004)(8676002)(5660300002)(66946007)(478600001)(26005)(8936002)(36756003)(6666004)(38100700002)(2906002)(6512007)(6916009)(6506007)(316002)(4744005)(41300700001)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y05uQkVyM0h3Q09VRUhSVnlkQVdCRUtlVUVOaUdXUlIvSy9rV2ZXclBIQ1BC?=
 =?utf-8?B?b0R2Zk1SMGhjSHBvN09pRjQrWnU2ekRQVyswa1ZjckNtdWJicTdUTDJFUEwz?=
 =?utf-8?B?MlQ2QnNGZ1dkeFhLM2I2eFcrb3AxSTd2SUo0RElZeHlRL29LbXZiQUprRld6?=
 =?utf-8?B?THFzMEtEVWg4dUZtQVJjZndXbmhINWkra3BSUUZoV1R3MXMycGhYVDMvazlP?=
 =?utf-8?B?bm1EZkVsTkJ4Y2xNNHFtOGVidEFodWZ1dXF5UnB1aHRISTFkRHVKVFVyTHBk?=
 =?utf-8?B?bHF4RWFXbytrUElWbUZjQ0wybDd5a01xYW1ROHJOTU9ZRjJpcExXdk1FM2xK?=
 =?utf-8?B?ZGtldnhndkhnYk9mTGpHUHVRRnFoSklnNzdadzlJMyswaWRvUGFHRUMwSXdi?=
 =?utf-8?B?cGxUczJKL2EwWDBJZTRnNStFY21rZFF1MkhFc3VBbnNBcU1wMzNyZ1FCdlQv?=
 =?utf-8?B?VnN2OXhCdUVSRW9pa3VwOTRqR1VqZzVvNE93RzRPRGpheTRiMW1tamU0d3A4?=
 =?utf-8?B?emliOWM5OFZrRjQ1STVpTTI2dFc0cjI2azZ3aWh6bGJHRlhOdVFEb1JjYUR1?=
 =?utf-8?B?RG5tR2tMQXVDdFY4NFVKdEI1eVJmdm01YVdZZzJCcFQ2MVlYQzdZS3BCNEk2?=
 =?utf-8?B?K253Vm1OQ1NsZkFSUzJrNW9BcG92bUpBYUNEKzIyQ0pPemtyNW5KMTFVVGZY?=
 =?utf-8?B?cmRwMUJ4QWlTTENWTmM5WTZOR2t2UzN4NmdLamZsZTI0bmdTeHlWVFdoWGcz?=
 =?utf-8?B?ZXZHNUpqbmJ1QW4xS0hSOWtJUnY4NVlzaUxDL281NXV5ZDRCWVpkWUV2M1lB?=
 =?utf-8?B?RGNtcGlQL2FvNVVNZ3p1L1I1U01GWThHMVRzTnFZYUhZREVSbkhYa1d0cTgr?=
 =?utf-8?B?c3c3cGgxY2JYTTIzYUw2RUpMMURjRmRnNFpnZmhNajVCOGN2Mnd3dVFibnBG?=
 =?utf-8?B?TjlMZm9tdHhXY1JWKzVBb0NEdjlIaVFMM2VLbFRBWGFOdDN6UmZielRydlJX?=
 =?utf-8?B?Q0U4WEk3c0Q2d0EyZVVpbkl0VjVycHhVbUtBUTY5ZEFJVzZFa0JYTDR5UlFR?=
 =?utf-8?B?RHBDVmpFL21WODM0Y1BGd2VNVHl0UzlUZlAxbnNKckdpcHVKL2RmYmNxUCtQ?=
 =?utf-8?B?K3Y0K0ZEMlVadm5xbG1XeGlFcTV3L1RPT256QkdUOVhCYTFKQXIzMU1NQXB0?=
 =?utf-8?B?bDhSUE5QeEthWW9lL0lXUE9rYTFYcmx3a1FPbnRQWm1QOGpvTHIvRUlkdVFV?=
 =?utf-8?B?RUtKNTdsTFRkYWRraHg0Wm42NHFjb1hEcmNEblR2bXN0UW0zSVkxK0dST0do?=
 =?utf-8?B?WXN2cGR5bEhIN2RrRmJFTStkRFNhTlp6NWh0cUwxS05US3FnWXJpUmlnKzBw?=
 =?utf-8?B?RjJoV2YySGF6UHZlRUU0clpBN0lIeVFHb1l1bGJIZTRLdzluRmJqTEI4OGVG?=
 =?utf-8?B?eVQ1Ujh2d0Q5RHlBZGI2cm5rNzl3ZVhsZWJqb0JhWGF4c2orK2dnQTI4WFRT?=
 =?utf-8?B?ZXlWa09GM1Jpa2xyTHRlT041eW5kWW9CMjBHaHJUalhPSmwxWGx4T05PNHgv?=
 =?utf-8?B?L3JmOXNzK2d2MkVtWmpsUzBWSjFIOVFLVGxPTGVHdDJJeGJnczZRc1lzQ1FR?=
 =?utf-8?B?aEQ0NXlPencxaFpBYlI0VzI0ZWFET09jbkkxRENBZVF0T3VnZ0xqaDJaYVBj?=
 =?utf-8?B?ZXFodityT2Q1SWpLMm1mY2IxWWVjUHZHSTgybFlRT2ozOGtWY2MrdExVVlVh?=
 =?utf-8?B?VGg1a0xMMFlqUjlsbDJTaGtyZjB6Skg5cy9TUXJSTG9XVkNDOFYvd3pRTnpL?=
 =?utf-8?B?RFRaQjR2QXpCR2MvdEN5SUdVcmtxdzd4Z3l2MmE0YWxzZnQyUGhGdEkyZjBv?=
 =?utf-8?B?RG1xMkY2ckJVYm0vZkRqWFJkaUNWUnRKZWJiOVZSQUNma3cweGVNU1RVTEVL?=
 =?utf-8?B?UVJGRnZxQ29IaHp1TGZua2xzTWcyS1NvTitzUnUyQTFiM1BKL09wdDM1N2FQ?=
 =?utf-8?B?YW9Rbys3aFlGSkJIak03dHI5NDFhaE5jb0hkMkdUeHVDK1FlVEpYK1l2cmV2?=
 =?utf-8?B?Z3NSbEhBa0Zrb1V1VDlWQ3lzdkJoNlczUmZ0UWNtOWx3dW9qNVNUazZVc1Fh?=
 =?utf-8?B?S1UxU0VxVnh4TXExOVl0RnBJUHV6UmZ3TU1mQ2x1OXhNRnYwTnhGeHdKUWxU?=
 =?utf-8?B?T1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 73fc54eb-f5f9-43df-bcd7-08da8c8fef87
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 03:05:05.4470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ucEQBZkBrNQcylmWreXqV/Z+ofKXBABUW9+iKRUVtvgZ1s6Z+yqmUlwvnN1ZbsjisGzyt9D/IL6ad3QPhmv+LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6741
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/1/2022 10:20 PM, Sean Christopherson wrote:
> On Wed, Aug 31, 2022, Yang Weijiang wrote:
>> From: Paolo Bonzini <pbonzini@redhat.com>
>>
>> MSR_ARCH_LBR_* can be pointed to by records->from, records->to and
>> records->info, so list them in is_valid_passthrough_msr.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> As the person sending the patches, these need your SOB.
Oops,  will add.
