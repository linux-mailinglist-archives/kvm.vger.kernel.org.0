Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66EC35FBFD7
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 06:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiJLERP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 00:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJLERN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 00:17:13 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E451F9C8
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 21:17:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AT6mArpERWq5rUWgtDvTW1IAvhyunuL/RVhuo+NW5cmIaa5pFotixJOZqVqIiFgwyr+ew//O6hu8x8HzJt63yYiRwxqKGmH8Vm02qmED4ulmVoUiBBUM1bkaoh79MyrGzoG4AISOyfONm1uznDryQMx0FtrHZZFwbd8XOGSqrkWorsrpWQAHIH1gfBJLvqPtRrPtahGgtT78I8vq5pyx39ehmtSI2bWUJH26nMlzzIs6KoI2RjR/41p3KBig41/nco8HSK9bTyXi6pBF7eHW33KtQiAlmNanZgfGrODVDpCn07DxOLkEz0nWjCrXHGYZ1/82x2HNCrQdOA0AyCY0Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qj+kVhNZbCaCOFPIQgVZHLSoRYvkMteJsN6OgxQlNIw=;
 b=L+0a8k/nziNu/Q9BczW3fXzDzz+Ftjz+MhRnpdZgC54szojscOBWglGvGToyizx1QknOngABNvA+IiiQqEvSx+0GeD83jvTE9SEyQY5QE05ge/i1ZvyBV1hCiFSsU57ql+hLjro2gyPR4q9xx50M6vVe7S+AtkJOrMctXp7/Hf2VGEzD9mwnUDyouC/j+cysGwVO306fsbHqsNVFdolPJT3gNGEEAvo3plP4FG80hYJHWHReV5sACDtmAEYU11fXMzKwPfw9gAdOyKu65t61LlocWeUyVJODxuepg8sSVhGjV2bgdyPoAZtDBICeX91qq9qACq34kT9TOnJbBQS9dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qj+kVhNZbCaCOFPIQgVZHLSoRYvkMteJsN6OgxQlNIw=;
 b=yKKrB7EWsM/Gha7BlFm+5RJYmN97dICNafZGav+xsw36s56VHALNCHUVMWAcd3oTh+tOVjU44pguxkuvmiHCd9R+r29CHYhCCBDw5+tR6j7t5a66Euf7ouT6+gb6Dq+X0BYbtP3N8dko4Q9XHkNKWZtbAeRWyWpaD+GDBpilmME=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 MW3PR12MB4458.namprd12.prod.outlook.com (2603:10b6:303:5d::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5709.21; Wed, 12 Oct 2022 04:17:10 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::1d66:4174:a038:a9d2]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::1d66:4174:a038:a9d2%8]) with mapi id 15.20.5709.015; Wed, 12 Oct 2022
 04:17:10 +0000
Message-ID: <89e66c8d-7f41-3151-75b2-2670fc3493cf@amd.com>
Date:   Wed, 12 Oct 2022 09:47:00 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [kvm-unit-tests PATCH v3 0/9] x86: n{VMX,SVM} exception tests
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20221005235212.57836-1-seanjc@google.com>
From:   Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20221005235212.57836-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0064.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::9) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|MW3PR12MB4458:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ccb5a72-d166-4141-ad4b-08daac08a1d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d5sjPjLKwy9GHPbk0CVL24tECmwG5NCvlijQlFPwKzoWpC5YmG18baTWePrAWlFlz0fXcY98oDzUC5ZbacFbgUUmLu2BxxP8I0QfRzDMpPUM0WwsuqkmfGDwFT7rn1JyvGRd2JDSGIsk0mSBETcUoa9o0Hhr0xIZ5QTo6xQzWze5qUP2NiqpKg/MtmYVMu+ERlMl857OV/zqQ0q5i5cu+ER0w/y9yJ6u/6zZgcZTqTYpUPr/Cnqar1rDX5wG9rr7/PE1DufiuyS4X2RrqQkeO5yDJn/FtTEJKaKw+vV9eg0QjfMZGXY+pCl5zRkAxyI8pbd0+8510AuzR6xSGnJfn4e3tWeHvXEVHtWalC6YihbLy6OChGCcSBiCs6HhV5V/DU2fyOIwIoLwWBjMbo3Id75fxz/kMDJGUx6PwG12q8zRA+EaKvlxlu9fCPNwH1M+hLyWIb+venwim4VGe8jAuIlycFYheE4T4MAaZpR/Vvsk5nE0RmukhTj8EL1/WjvP+J6W5VnHGaRnvbk5plcNL9wuCZ9XAK01oMovoz9DQhzNQsmXIdAX1YmbSb1UR3ibd+gdIeq3cuyTNQBd/Iv4qqZbmIbi54/6QB5cW8vT49hP0OB4tbJW1crpupKrZ1hYy8VWGM92nv4rsfpt3+C7Nw6WB4/037V3iwsifMvAMtvS9nKp38XVwpMjTSils7wC0TVwm6xxI1XA6+bVF8dl3Ruwn2t6DHB07Vdous/xuPCthnhn7UbSNX2+lgJ8vD2WJZ8C2h1wMZCIViUP1tgPqNwvi7KKncvn5p8l1IAdprgVCahyZNutcNn9R7wpeQ6X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199015)(36756003)(6486002)(316002)(38100700002)(110136005)(86362001)(8676002)(2906002)(8936002)(66476007)(44832011)(66556008)(66946007)(4326008)(41300700001)(2616005)(83380400001)(5660300002)(478600001)(31696002)(186003)(6666004)(53546011)(966005)(6506007)(31686004)(26005)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmU1R0Iyb2M4RDhsV21XdWIyd2h1TzRLZVEvWGRpSWJkSUVsSitibkZHUkNE?=
 =?utf-8?B?bG9jeWFJemowaUtmZ3NKVFdIcmV2amRWNjkxbG8zdzIwdXhVeFpkdDFGTWtJ?=
 =?utf-8?B?RklsYnJZdU9zQ1puOUVuTjZZWnJkc0VvMGpQN2xHdHBhSVhxM2RGK2RUK3RG?=
 =?utf-8?B?dVptNkFncTM2NzN3Yi83RjJFU2VKUFRkaWYrNWJWaHQvTnN6aVVvcEFKcDBp?=
 =?utf-8?B?TjdvSkovQ2dQZmJSNktuU3Mya3pBTG12WFEwTXdneGc3Sjk2SEVOUlVjeitj?=
 =?utf-8?B?LzhCOU94T2w2ZVdxb0pMWWhQOWZyQmxuaWU2VmFPSUhyOTgweUt3K0xrRE0x?=
 =?utf-8?B?WE5NUzJzOEhmWW5sSnMwNnUyUWx6VXFxUTJteWg0TW84TisrMUY2MHhGQW5t?=
 =?utf-8?B?dUt1UmRNMGtSQStqek43bElCS0x0TFlJYXF0aHYrcFZQc0trV1JXcXl2c21F?=
 =?utf-8?B?WE1qRXRsYmZTelIxdlJNdGJ0YzdrL0lSQitTUHdkOXpkL0dFZmlvRldlM1VX?=
 =?utf-8?B?bmMzYkFHODJPNnp3Z01VaittbmFaM1liVThVSC9rUVJZTS9scVA2M0J0VS9T?=
 =?utf-8?B?UjJ1UG1FRGt3S0NjaGdIY0VET3FkY05PWFdzbmpiS0pZWEdabHNvd2VmUzRq?=
 =?utf-8?B?UWxkYXk0dXBOWnVodWFNcndWWmQwSGRNN2x3dXN4UkVxQnBIVFNQR1U3L2dQ?=
 =?utf-8?B?eGlYQ1RwcVczV1k2RW5DNXNidTNGbTgvZ2w1clRzZXhYWHYzTzRaQXBXM3FG?=
 =?utf-8?B?K0JIKzBSWmZSaWoxNWo5VkFSQitQZTFydGwvM1YyYTFRZTQ2ZXczU1cycWlZ?=
 =?utf-8?B?YklQQzBIQk5CR3BCZ0k2aDh2bk9EUHBWWFFUaWR3ZnFHQ2tBN2poYUdKRTMr?=
 =?utf-8?B?a0tTTk0weTdlSVVqTDIzRS9UQ2tiekRkZ3A2UzJIZEI2c3JyRWpjV2xVSGN4?=
 =?utf-8?B?dndJS0RidGhmRkx1ZkJKZVViY2lvYzE0REE1Vm5PODJRZVIwekxMN1ZmV05O?=
 =?utf-8?B?Zm1lamlTQVFBczhoN2h6b3A0eWYrNUo5d1hteVU3NEErbjRKWE5CbWNPYkZ3?=
 =?utf-8?B?dzErSDZYWTVhNHREa0cySnVhMUpGeFQ5and0VVNwblRKQXFrcDBIUGJCaG5m?=
 =?utf-8?B?cjN0S2RVcjdWc2JIZ1JhdlJ6dE5HZkdxOHhWcm4xRUdLdnBsWWovWk1uMklu?=
 =?utf-8?B?ZlE3d21DejFDQXNPdlpJMUcyTGVNVWZwdjRTR1pjWXkwNXpobnkzZ2JTR1Mw?=
 =?utf-8?B?YmpUMVZlMzdORkRkWUVEYzhqT3hPTlQ0VUo4Nm5EQ29IanZESFYrcHo1a3BV?=
 =?utf-8?B?UzRRQU5hVDV3Mm9CaVowVWRjTlZMWGR0dmF5QTlXSVlnTGhHSUE1MTVZZ1hj?=
 =?utf-8?B?bFdCOTFGemVNL050bDFNdkFxc0VCR0xINjhLS3dHK2pDRGo2TzZTL0pSYlpL?=
 =?utf-8?B?MDdyQm1rY1VQQThRRm1BVkRhVU84QVdGcU5MSDV1UUFtaWx3RFpCOE02VXZO?=
 =?utf-8?B?VWM4MzRRbjVKb0RGY0dyMXJ0RnlRQkhKVTN2WTRCdHlrVGJVZDNiWGVLQjVr?=
 =?utf-8?B?U0lMbjNrL2pxaGhmQ0Z5R2hDTlVpcjgzc1pleDIyZHg3bjYrQXA1UnVLS2hG?=
 =?utf-8?B?cEpFNlNtRVk3Y2lpWnBpd1ZjWFZHcFViL01uNWo5QmxyM0ZHc0grSktMZlRa?=
 =?utf-8?B?VEVnaG44VkZRZGkvOUVNOU5lVk9PU3RxQ3M1d2ttZjEwNGpaWXIrdU5MT1lu?=
 =?utf-8?B?MWtzYyt5eUk5S1dVR29GcEU2bkhkVWNzZHBNZ3Q3dHpYbWRPcUJHZFo0di9F?=
 =?utf-8?B?TlVQb2lDdzRnd1BLT3N6cmRpREk1SE9WNmN0YzFMRnoxVTl5MHNHRjgzUnpE?=
 =?utf-8?B?WVlFQnErMGVhSElXcXZ0RkxBRysxU3NQbXpMZnFwS2Q2SWhKWnJualFYYjNv?=
 =?utf-8?B?MkY5ZWo5eTVNRmh0cmpyeFUxUndSSHBxYzFHSkVGSjQyUTNySWhEYzFHTzdh?=
 =?utf-8?B?L0JmUjZvTmdieFFFTldNcUJGNlR0eTZkT1cxMFBGSTFVVjdUYTlPVnhQVDg0?=
 =?utf-8?B?Q0Raajk3V3FzejduM3FPWHpSZWtVTTQ5R1BNNC9ZSS9icXhldktrWDROZVJn?=
 =?utf-8?Q?qNnJ/QkXSlm4I7cMEKiRBUUAY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ccb5a72-d166-4141-ad4b-08daac08a1d7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 04:17:10.4921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J8I6U9AItWGZBqElonq9B9DAN7ix2opVo5t7ZVWGpsb94DGqyWkBiUqndGv9qREYV9HySll3UakaTpgKNZ5akw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4458
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/6/2022 5:22 AM, Sean Christopherson wrote:
> This is a continuation of Manali's series[*] to add nSVM exception routing
> tests.  The functionality is largely the same, but instead of copy+pasting
> nVMX tests (and vice versa), move the helpers that generate exceptions to
> processor.h so that at least the gory details can be shared.
> 
> An added bonus is that by consolidating code, nVMX can do some of the same
> cleanups that Manali's patches do for nSVM, e.g. move more testcases to
> the generic framework and drop fully redundant tests.
> 
> https://lore.kernel.org/all/20220810050738.7442-1-manali.shukla@amd.com
> 
> Manali Shukla (4):
>   x86: nSVM: Add an exception test framework and tests
>   x86: nSVM: Move #BP test to exception test framework
>   x86: nSVM: Move #OF test to exception test framework
>   x86: nSVM: Move part of #NM test to exception test framework
> 
> Sean Christopherson (5):
>   nVMX: Add "nop" after setting EFLAGS.TF to guarantee single-step #DB
>   x86: Move helpers to generate misc exceptions to processor.h
>   nVMX: Move #OF test to generic exceptions test
>   nVMX: Drop one-off INT3=>#BP test
>   nVMX: Move #NM test to generic exception test framework
> 
>  lib/x86/processor.h |  97 ++++++++++++++++++++
>  x86/svm_tests.c     | 195 ++++++++++++++++++----------------------
>  x86/vmx_tests.c     | 214 ++++++--------------------------------------
>  3 files changed, 210 insertions(+), 296 deletions(-)
> 
> 
> base-commit: d8a4f9e5e8d69d4ef257b40d6cd666bd2f63494e

Hi Sean,

Thank you for reviewing my changes.
I have tested the changes on AMD Milan/Napples and it works as expected.

-Manali
