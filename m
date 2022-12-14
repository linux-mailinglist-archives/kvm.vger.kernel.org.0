Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C13764C2E8
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 04:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbiLNDxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 22:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237084AbiLNDw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 22:52:58 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CD162EF;
        Tue, 13 Dec 2022 19:52:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Naf5Mcnu8od26ZGy/WVxVjpxfVmtevY098CYVpzMApDb0pShnvbFo461abnbyLocBjbIa5M+hIr/Mnp7NQOX4T8+q6mRdQqDZu5OUhdTdlloeVbnC6es1rbaM2DpNk9siUad8sCLCyic+arP/9/X/Ur3GzapUVZ9XHqMeORmLBMiMBBMtiPyF04JrqfVpIwXXMrDygt0zpknxITgB7NWOn8PPdaaZkMDHx86dGDz2fugfxJo0gfKY7fmIecF/HXqJpBkBIeeXhyULHZRCabuuRyeveZCyf5MdSpbLIZx9Q2jP/pTx+ACJf93Ss+3liF6Iuyk0baxC+2j9Eiz8+d2Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AujeIFrMzuRE6bQDiYSdICvsMZAfTwRuUDZOJRXRsVo=;
 b=Z+WSA7DQwFwg1eMpfiWjscxhW/+hFT60igA2zCc97KK0x2hK9U7rNrSb6h1tC1aL4Aul39EBxuVIR2JlVizl3xNB9S9StEz+60ZFKVX+Hp8jzIPTJrMqZBC+nDL9escfEFho7VmXuU3b5RdNpMG5SZL9tEYoe3ZgnMN9fRsubwDF9TEFfJmn6VST/JKH4wFrKyeMtl27g0m1c7AvsagI4vTMLEBrbwAgw2JAxIctqB2hjJufuAxONO/qchZAwuhqVZM6XOupbv9Cv0XEiwSfwwWt3CdJNrlhNyfjR6+Df4Jw/lKmmDzykeBLbLcWozphv+1OnItMccPGEFZRXf+UTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AujeIFrMzuRE6bQDiYSdICvsMZAfTwRuUDZOJRXRsVo=;
 b=dX+uOgNDydWQmZ65xcvndhDm0NyjYQs/D0O1DODE7AU8KoAxPI4y8ECpoHXieap3pihMutPx4FFNdTb7ynqLrEX9jOb10xOCt2YNKckSU5NOKRLIXf5u+E06/ruHfhb25ul5mkOL7XCrv89BVnurRK6mgQ1MXOoQLpAI4cRbthM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by MN0PR12MB6319.namprd12.prod.outlook.com (2603:10b6:208:3c0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 03:52:49 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::a0e2:652:d7bd:58f]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::a0e2:652:d7bd:58f%3]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 03:52:42 +0000
Message-ID: <4990ef71-734a-10cf-e7dc-51b33b26fd18@amd.com>
Date:   Wed, 14 Dec 2022 09:22:29 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH RFC 1/8] perf/core: Add *group_leader to
 perf_event_create_kernel_counter()
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>, kvmarm@lists.linux.dev,
        linux-perf-users@vger.kernel.org,
        Ravi Bangoria <ravi.bangoria@amd.com>
References: <20221212125844.41157-1-likexu@tencent.com>
 <20221212125844.41157-2-likexu@tencent.com>
From:   Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <20221212125844.41157-2-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0204.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::14) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|MN0PR12MB6319:EE_
X-MS-Office365-Filtering-Correlation-Id: f4a4710a-8ba8-4ec7-dd3f-08dadd86a701
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +1i9XxmfQX5+6egcz9hlpQR7Ko6RId6OtaP25JE5h3qAnIJlPKsrILNwRkLGPvCjbZSdQk+PKXoBKBATsV+Amtz6cw7cILKUIH84wXQ0xvmxT1wwwJGjBBBWJzFcbFboihGsSkmzsiwalgggzbLGuUijZ1pyuWG26pVIMrW+lapM5QMGzGYQTNXr3ehOOQxWZVHQY5WecgCyxkqLSSNxSg5nnl4YUG8HZ61JvhhDZSrLaA5gv0xSBrnChRfcQrZdFRP+Hy+Hp9ZIMalmGqEev1W5C32OdzZzn47Cgn/1WoZkvu94x1/eedBgDmggCegbUw4Szqe34i09y/yV5k/izCXLPKEUhs0wYRctpTdDLXdF4ndGizTFYNme786Xf6k1Wl2BOKxbGKdSuUJjFJMEp9HqXfOty7iStqibsS/qx5h06nKX0yGhEKlg7S0jxCvuB55lk2PYekAzAQOzRiaZ6iuX6ekL2GqOdZbz0mM1nuUZMJrSwFTxKqeoCmGRdjrjes3pYrmj8w9I8/dWzMY4hzTZ8yyNZEd8HS70kc3l4e7wOcdAwbIiLi6WAqGSi0ZTkfK9Yq2CxKeFVfrnm59vi+/NN8Nxf1lGiZUNSsUZjkxz4tIU/DSBWIJlZpwV7Bi/sKGodbZd+csSTif66qaFKzr3hViN9p7TXHkus384ZkvpMT3TXBIFevwE6Gq/bcI2o7Nvj+JWT4qF/ENRqQ6YyAmSCWf5Oclc0d5WbD6QtaEbXCG7HE8j7HPbOuuvw6v55za9YjAoodAYfYclmAVG5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199015)(6916009)(54906003)(316002)(5660300002)(41300700001)(66946007)(36756003)(186003)(8676002)(66556008)(66476007)(4326008)(8936002)(478600001)(6486002)(6506007)(31696002)(6666004)(26005)(86362001)(6512007)(2616005)(2906002)(38100700002)(31686004)(7416002)(44832011)(71600200004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDJUM3krWUtRQWljN0RSUGVYamdOZG55S2lINEZYMmpWWHAraDhGNzN2Wnp4?=
 =?utf-8?B?SzlWNDh6aFgvQ3JGZlpLQnlES2daWkNSVUI0c0pYUlVQSGdMNTlFMEI4dENC?=
 =?utf-8?B?dEl3V0pBWDJJR3RyNzJWOHpKbmk3Z283em1McWE5ZDNaSzgzTXpSeU5QdHRN?=
 =?utf-8?B?ZFJybGNuditFMk1iNW9HRFRWYzVpck9QTGdYWnp1L3Buc1dHMldvY0M2Ujlh?=
 =?utf-8?B?RG1SNzFzVUd4RzNraFdmcUxlcGk4ZGVZM2RQK1BJZ2lZSkFabjNJQWdhbDU2?=
 =?utf-8?B?V1VxNDBPOHJPM2Q0ejdMWXpla1l6cVBuZ2k3L0pkYU0xVlFOdWxUTHFwRVpp?=
 =?utf-8?B?ZTg4Tm45Vjlpb1lKZXhDalZvb29KYUVmYlBVck4rTVJ2Qi9idUZvbEIwaDVa?=
 =?utf-8?B?TjRPRk54cFFISHJubHQ5anZPWWFybGMwZ3BRQ2EwNVN0ci93ODVnSm0wNi9t?=
 =?utf-8?B?aktRMUJackdBZ01WU05CTmJyK2VTNk5DVFpvSW9Vb21lZlA4eXN1c3B0cTha?=
 =?utf-8?B?SmhLQVpHSHFPMExGb2poRmV4WExsSE11b0FHSkYvM3VXMHRLc3A1TlM0YlNN?=
 =?utf-8?B?OXFTa3BPYUpDRTBTRy9MQVkyUXdCK1IvZ083SFF6dVlHOXdDcHZybk1wN3h0?=
 =?utf-8?B?MkNKcU82T3phWUFIYVoxS1hVdVFMMURrSlNqeU9EeThkckwwTFlQTmlaLzJT?=
 =?utf-8?B?NXdFWk9UWXVyRndBZ2MzQUovUWFvcWhIWlVZSjFpbWNLOFBKT2VwTWZTNlVw?=
 =?utf-8?B?U1N0akcxVVc4ODFEeWlQUnYvNDVCTUozUXM3UXN0TUJJbm0zZi83bUl0UWY1?=
 =?utf-8?B?SFliRFJZSmlDWUlrL3ZSeTFWR0hlSnAzNW0vanp0SFFtLzlLMnRXZ3dXR2M3?=
 =?utf-8?B?a0xNMWRrVVJUQzlMbUVUSS9yMUU1UzNaYVNuYXNLNjVmUCtVWkZ0NDVsdVlD?=
 =?utf-8?B?T3cvc1gvMW92bWxXV0l5a3pPblh5b3JWOTVUMjlHaXEvQlByTjMrcXRqekp2?=
 =?utf-8?B?ZHFKQmNrWVowSCtlYWhHNXlFdE9VajA4OU0yaGpiYVg4TzR0TEdnSFFRS2hh?=
 =?utf-8?B?SWZ4bXJtK3dicndjRTJ1cncwSDRLbEY0c2VIWTdGRzQxYUZaM1AzaU1qWTRZ?=
 =?utf-8?B?MTJEczlCZWllNGxEbzFQbEROUU9EUHdicWM3M001M1ZCekN2bG5qOGVJc09X?=
 =?utf-8?B?NEpySFBSYjlxbHBrUVpMNDk4RU9yYkxSTlBwNW0wdXdnRGZDOGQvRUF2a1Rn?=
 =?utf-8?B?bzBHdW4rcjYzbll0NEx0WnBTaEhaNHEwMWhCLzI3QmEweEJVV3JaVVlwa0Rh?=
 =?utf-8?B?cy9iTU83c0Z3YTdOVmhpMSt2aHppNmZmdWg0d3orak41WC9QUHowRkk1WTVI?=
 =?utf-8?B?N2lwUmJ1R2M5MWtXMVh6MnBkczdDbmtsN2oxVGY1czRWendZeU5jeCtha1Ra?=
 =?utf-8?B?aWMvQVFBdk5JNnR1c3hxMzZkeFNuaFh4VmVoS3dxM3R1N0hvYW1uSEl0QSt5?=
 =?utf-8?B?S0JxS2ZvT0tvWjVZWHZPUTVZLytNZUJoRjR6WGFqemVxc3ZxY0hXVXRQWWxG?=
 =?utf-8?B?M2dwbnprTDQwa1ZZeVNVTGtHeWpWK2o2VFlPVXlkQVFJV09nU3hTUnR5SS93?=
 =?utf-8?B?MkZYdUtmWkRXZk5VY3J2Z0FRYkwwNkpIY3JSczFJdGpMelRNbGpmR2RSRm1u?=
 =?utf-8?B?ZU41eVJxTGlyOTF3cWNETTcwS3JGQXlCWHpCQXVUQ2hIWExhRU5FV1JCV3Q0?=
 =?utf-8?B?aVN0aWoySkNQYXMzL2EyOHVLTHEyNGY0bC8wWGprSU5qRnZ5Z2J4TjJERE1z?=
 =?utf-8?B?R2hWZlE4Z2tCS09DcWFmRXpkd2hRNzJrYVc5cGRoSGVtWWdweGxxeFB6dmtF?=
 =?utf-8?B?VnhGL2N0VXFRZGl0akxCUXVkbGhRYWxwTVl4WHdWUURQWjIwdTRueVBRMXE3?=
 =?utf-8?B?QnV0R01DRXpPclRLNTd6RFZJMFZVenB1ZzlxdTRISnFsZ1lXeXFZM3hMY1d1?=
 =?utf-8?B?ZHRxSVVVbHppOUc0VXZ6VWpZRHZ0QWhCV1dMUW9MMFArT1Frb0pFZ09STkg5?=
 =?utf-8?B?SEVIY0FEMS84R2docVNCODljZGNKcjRUWkEveU55QmxrN3BEUEVTNk1oNjBu?=
 =?utf-8?Q?9k/mjqRKWhCr/y7AgLC3b0YBw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4a4710a-8ba8-4ec7-dd3f-08dadd86a701
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 03:52:42.6900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a/zLWjyU6IHpInq7EZTY+BI0NGZDd2SMKumuY8DdmhiAwynbJCwZZ8mbLsQynyyIOr5mUntpSZmVhCs5/5j45A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6319
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 7f04f995c975..f671b1a9a691 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -12674,12 +12674,14 @@ SYSCALL_DEFINE5(perf_event_open,
>   * @attr: attributes of the counter to create
>   * @cpu: cpu in which the counter is bound
>   * @task: task to profile (NULL for percpu)
> + * @group_leader: event group leader
>   * @overflow_handler: callback to trigger when we hit the event
>   * @context: context data could be used in overflow_handler callback
>   */
>  struct perf_event *
>  perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
>  				 struct task_struct *task,
> +				 struct perf_event *group_leader,
>  				 perf_overflow_handler_t overflow_handler,
>  				 void *context)
>  {
> @@ -12694,7 +12696,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
>  	if (attr->aux_output)
>  		return ERR_PTR(-EINVAL);
>  
> -	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
> +	event = perf_event_alloc(attr, cpu, task, group_leader, NULL,
>  				 overflow_handler, context, -1);

Grouping involves lot of complexities. Setting group_leader won't be sufficient.
Please see perf_event_open() syscall code for more detail.

Thanks,
Ravi
