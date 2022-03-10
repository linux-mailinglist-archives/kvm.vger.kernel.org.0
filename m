Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B934D51AB
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 20:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243497AbiCJSmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 13:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236522AbiCJSmR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 13:42:17 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36A318CC6E
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 10:41:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X0Yx4J3CkNx7/xF7PQZD+wqr9JT/LDp99Mo+3Dn2K1f2s2WseZvk3gDRPg7BmXfD7facnhjWwVKzrqO+P0vfm2D7gJyq0QL+KTj+jntIXpEuVELTsuY4MeLnet4yMlAOTC9+edDQ/0DWLCkYC+cb974/SuWf6h7l4k/BPBwYlzZf2VvpAbHTloiW44+gSDaWB8WOFQJ4HbfwsFA69KQ1Z0CkK5+mJVc2YAIFn7emRE2df286YwO6r18D8ULYNO9BesE7PchGtBASm7Y1ljT/Nz3y4eDBJCHK6LThniNOkL/9xN78muX8u1oPPUCLcEKHanoqqRkwbFCu3pthpcd22w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZCav6tq0UCBCwkacB+17vRxgMrvYWKsjeLMmBORBGo=;
 b=cPwoWqoS7AdXEhWmudVh54njvNUhChDL6y7fEEtr919mr15lAZQ+2XFc4HpTCmm+hpBUBto7/keTItgMoXYiQLDhs7Cp9ScJt+aKTvEs8sJxBT90ZIpLotkM7pUzmCE0aif8wTmaDdBvB/SvgshaycilZ5jAjDAuPvcPjjECaneSxWSH66TKaOAp3IKweKwx9bra8F5n4OSI+o443dN5+/xI5rgsYY1xIlQmTkerClB0DAzLATAH0lyK4r0UgMMxLe1+1B05uOYtbgePzkpPzq0yA/KsQjfazxKC9PpkBQPvrqxROXuyLfr9lGqZ0iWkkBwxlxmGRrkdPOJI9siEQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZCav6tq0UCBCwkacB+17vRxgMrvYWKsjeLMmBORBGo=;
 b=j3zyxz6TkW5e0LqAGd8c02/fjA63XLpP1U0vnen4ahJYJsIHDQR2C6VOuXamcHvjJu1D0CJbkkuu3J9RGGrbg66ZBI/qlAC17kkq8rOQEXfMBAkrQhy8U6k9h/XBQGEZcbTkjogVzgqdOWSzHtJGLmzoC45xvOZRrbMHW/NMUtI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5179.namprd12.prod.outlook.com (2603:10b6:408:11c::18)
 by CY4PR1201MB0053.namprd12.prod.outlook.com (2603:10b6:910:23::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Thu, 10 Mar
 2022 18:41:13 +0000
Received: from BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::e9be:e1be:5abe:f94c]) by BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::e9be:e1be:5abe:f94c%4]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 18:41:13 +0000
Message-ID: <78ea846a-d349-cf5d-4f3d-fb5312c3c7f4@amd.com>
Date:   Fri, 11 Mar 2022 00:11:03 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [kvm-unit-tests PATCH 0/3] Move nNPT test cases to a seperate
 file
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        "Shukla, Manali" <manali.shukla@amd.com>
Cc:     kvm@vger.kernel.org, aaronlewis@google.com
References: <20220228061737.22233-1-manali.shukla@amd.com>
 <cc543e9d-6891-b53d-b34c-7cd7406e5dc7@redhat.com>
From:   "Shukla, Manali" <mashukla@amd.com>
In-Reply-To: <cc543e9d-6891-b53d-b34c-7cd7406e5dc7@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0047.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::18) To BN9PR12MB5179.namprd12.prod.outlook.com
 (2603:10b6:408:11c::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad68b071-6a57-4ffb-889c-08da02c58d34
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0053:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB00539525E2C64410D2E2555CFD0B9@CY4PR1201MB0053.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /MKU+39sT1PilW3eSUH56Qhn80uUjzXPwh/WmJ6l4E1bgqoXTlqZBuDGF+fdyPen8KvJMDoJlokclqkVv65rEnIKmcXOzf6QiKsBbwzdLAhEWUguLh5dvq4PZs0MYuv3soJxK0B/glpnrAPkArgfakICVB2eSWJsZ+L56vUglysxjSuCbNemF4KYMiG55nKTMOuYsnn3GVvEEIVMzqhv5YUPQwCeQFN39o05+hcxI3iyplkdieDzyWX4ZbMH8G0lG3NbnGq5IsEezUAN4i+IoiZhMGtsoZYkaRnWqZT+J1i1zk/X03PzjwFIXU5x0E/1Tu+Ixn5OE+2b1dX+7MPnJCv/xXGNFXDoUBICRpb9O9F9C+Y7LSiHFTkQY2groXioFGEu+2EStG5iAsG9jsu5QQp+xoy5SqvAsSmZ6E8VKblbwsdeus6siUo0tXdW0mKJgyiC94RE4ZjX1Yqj2YBqmIEUPMQ98LK/71hwKAa7YuLZOD6+GLfkgiYkBIu3SybGG02iv681hlA0ctqYsrbArHQuRvW4nd0WFy8NUQdh8BDIzm5Q+LbPEJSjBKQNo8+Muoue4ePmZfsgjGhw82G4715JeykVPZJAT4KfYAkhfTagHTVbgtWI7WwB++JT0fqJP+L91jplxRGqyYL+UfiVZqk94hTNspGvFuy9LyaSGMXjeHdAiztUs3vjsgot0l9E9fw+U6XcldKA5nYOTMR3vyKm5fNqluyUGWzuCOSJOTc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6636002)(508600001)(316002)(6486002)(31696002)(2616005)(186003)(6666004)(53546011)(110136005)(6506007)(83380400001)(6512007)(66946007)(66476007)(31686004)(66556008)(8936002)(2906002)(8676002)(5660300002)(4326008)(36756003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cU5kb1BDTHNKa1prTnFaQStEaUw5Z2loQkM3U05tdlBHUDZCNXhtTW03emJC?=
 =?utf-8?B?WXpyRDZPdTRRTmNNU0RQYklXOHRYV29WUytndU1wZllNaUxBcU5CYU1mcCt2?=
 =?utf-8?B?ZkMzQ0UyY1JFbCtiQXBVK1BXN3lzYkI2SmpPOVlGOU1oOTBRVW52WFBpT2xs?=
 =?utf-8?B?RkJuZ3UyaU02Q0kwL01YMkRPS3FvaXljOGxzcWFycXRPbDJrWUdrbG5iTGhm?=
 =?utf-8?B?S2hReEROQkowaGlOeUc2SHZ2UWRRaER2Z3RZQ29PMklhdEoyOGtxcDNhdnBR?=
 =?utf-8?B?QSs5Tk9FYUt5bzFpYWFiV1l3Y3h5TWJSZG9PNXhKajNGTjMvelRhcGsramZt?=
 =?utf-8?B?S1d2VERTVlhwY0E0bS9yQ2pOOTdvZ3RXai91Snp6elEzU3lCSWEzWVhmSzJK?=
 =?utf-8?B?b09Kbk9RTEFXVUF1ZlRndlpERi9aRkcrMFZMZ3MvdXFoakJZV2hvd3QvcVFF?=
 =?utf-8?B?OGxpMUVPaGxmbTBxUkJzZjJzWU01ZFRYQnMwK1VuMEh4ZndGTFA1TkdIRkVh?=
 =?utf-8?B?am5valNhVzNEYVZSU3ZiNWdmTWh5VW42eVJ4YnV4dDNWSFBtbFRRR1pHUXk3?=
 =?utf-8?B?WGFjTE51bVVyOEY2YkVSbFU5OStHSUYrZHI2VU5HcEZmZlRLTTFrRXhNODla?=
 =?utf-8?B?YmNNQUo0Z3lJamtvbVNyalYxUWp3NWc2MktqYVJYb0ZxMENUL21vRG9hZGwv?=
 =?utf-8?B?d09mY1FQMlFiU0gzdTQxY2NmcXdib0tiUG1SZkViZVRQSFBwejBXTTdXY2hL?=
 =?utf-8?B?VUhQK1ZNeDh5bWQzUG1YeTVaeEhKRGZQWHd6TkFyWVJLdVVEZXN4bkU0aUhk?=
 =?utf-8?B?Q1JHRVJSbWtqYk03VGZxOFliejg3NS9ETnp3SWFrVFpkeGxDSnZVWFlqOEd5?=
 =?utf-8?B?U1pyaEpnQ3hFL3FpNXhVYWQvRm5rTDk0cXgxOWpFck1UbDVRTUtyOFJVVDBj?=
 =?utf-8?B?N2ZDUE5weGt5ejFBU1NucThZTzh5VmV6UHN0VmNDRnh2OGxINnp0U3VwOGl3?=
 =?utf-8?B?YUxKZHBNWFFtUzVHV3ppeWlRN245WkdSYzdrb2VIMHB4ajlNVWc2Y2tyd0gw?=
 =?utf-8?B?R0pucFJZckwrWElkcjRKd0kvQlIyS1lFa0YrWU9rbzRsRkJVZUFRcGRydUVi?=
 =?utf-8?B?Z0hobzFtZlYwU3lUV3huYTJtVmRPOUxGR2pZalhUMCtEN1VlVkVVU3QzMGg2?=
 =?utf-8?B?YnFZNGJFWnlvMHJZb0ZJdGtLblo4VkVxbkRIbm9RV0FsTWJaQ0M0Y1JQUTlD?=
 =?utf-8?B?QitNVG1YUzRRN094SHNHa205ckNTdUZnTU1nMmV1OW5Vd2hoQXlmSVpGYUox?=
 =?utf-8?B?cEZXdkZEV3M5T3dLUWlBY3BuVVhRUW80YUdtbkcxUm5DM243aEtON0xzU1gy?=
 =?utf-8?B?TU12cXZPMUJsb0ZEK0ZJTWlBWHh6UG5PVTZVVk96RTZxVVdYMENUR3hJdWJE?=
 =?utf-8?B?ZmZpMC9VU3ZyWXRjU056WGR1cEVQSnhLSWo2TlVJWnErbWl4Q1ppVFMwZG9J?=
 =?utf-8?B?dmh3RytDYzJ1LzAyUThLbXpnUERQOVA1eHZ0NFd4d2E3UGxEbXQ4U1dzaFB1?=
 =?utf-8?B?cHlpOVF6NHQ3Z0RkcmtBazZKTGh2WFJQRHNNYUhvQmNtYjROK3h6dHFlZFFV?=
 =?utf-8?B?SDV4bW43YjZnRHJ6elk5bWFrOWhMNG5FYTk0aU00bS9ZakVDOUx5aXZ0VS9w?=
 =?utf-8?B?Tk5tMlRvWEkrL2xlS0VUVTVaRTEwaHJYZ1V2ZE5tOWlPVzgyZFNJOWFZV0pt?=
 =?utf-8?B?eWJIeVJvNHYrcEV2anlRZk92UVcrUUZNMnpLOU40dHA3THQzbk5YNmNuMndu?=
 =?utf-8?B?Z0luZkF3aHJSelozMU1Ubzdab2Jwc29kYkJYWEVvd0N0Zk9uUUIzQlVQV3M4?=
 =?utf-8?B?ajVCSGxIbkJERjlTR1BYN1FCUGZvQm5MMTQzdVlnZ0kzRFlTVGNHUUhSWVpG?=
 =?utf-8?B?c053SDBQdHM5bGtBQy91MXFUN2JXZVlkd1ZnSCttNHorbjhEb2lEK21WemJz?=
 =?utf-8?B?OFpmVkovbEdBMEhTbUgwZUR3WDMrRFRsNTU4U1RMQTJ4aVBPSzJNK29jQXFL?=
 =?utf-8?B?Slo1NVZjRWY1QjRINDZSVCt3aWV3dzZCT29XYnBkMzJ4MmhhenU1blJTNG5I?=
 =?utf-8?B?RVMxUTUyWG1EeWF2VDIzZi9vYzdNTDVlWlpmampmdkZWQjhtbzNpME14Vkwy?=
 =?utf-8?B?d0IxaERDM3pvK0FxTXFzL0RTd3dpOXVrNjBuN0l5QVIvekU4L1RzdXpZQ0FJ?=
 =?utf-8?Q?UnIfllI5zSulZYCHg1r3Ilb6b6rE2XQSCepnNkcu3Q=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad68b071-6a57-4ffb-889c-08da02c58d34
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 18:41:13.0001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ISb6kBKq23ZYoxMVpFmowQlinW2FHsNm8IRCNS+ZNiPmuY0Ye97SM7eXY4hO9t/usIJHb1Dt26xYeLc6oArClw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0053
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/8/2022 9:05 PM, Paolo Bonzini wrote:
> On 2/28/22 07:17, Manali Shukla wrote:
>> Commit 916635a813e975600335c6c47250881b7a328971
>> (nSVM: Add test for NPT reserved bit and #NPF error code behavior)
>> clears PT_USER_MASK for all svm testcases. Any tests that requires
>> usermode access will fail after this commit.
>>
>> If __setup_vm() is changed to setup_vm(), KUT will build tests with
>> PT_USER_MASK set on all PTEs. It is a better idea to move nNPT tests
>> to  their own file so that tests don't need to fiddle with page tables
>> midway.
>>
>> The quick approach to do this would be to turn the current main into a small
>> helper, without calling __setup_vm() from helper.
>>
>> There are three patches in this patch series
>> 1) Turned current main into helper function minus setup_vm()
>> 2) Moved all nNPT test cases from svm_tests.c to svm_npt.c
>> 3) Change __setup_vm to setup_vm() on svm_tests.c
> 
> What ideas do you have for SVM tests that require usermode access in the test (not in the guest)?
> 
> Paolo
> 

I have tried running the user mode function from L1 guest, with setup_vm(), this 
seems to be working fine. 

But I am not very clear about your ask for svm tests which require usermode access 
in the test (not in the guest).
Can you please elaborate on it if possible?
Are there any sample tests you are referring to which I can check out.

Thank you 
Manali
