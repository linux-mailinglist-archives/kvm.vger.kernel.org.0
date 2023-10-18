Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0923B7CDA4D
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 13:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjJRL1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 07:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbjJRL1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 07:27:33 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480C0113;
        Wed, 18 Oct 2023 04:27:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFV3UJLwcWgKAaFa3txU3mxrU4bgBg/G5Tr0FmHa0/wY9O0KoRYDgzPgg8uI5qsfLGOUS0xCxRHweiVRMciv1HGAcVIT2WUFSGiDAdN9vqtUUlSHiGUie2Uq/1X25euZTLa/+Em0tmJBxnTBQFsGCW5cZyguOPQd8YUlemWELvPytRVrePHnclFB4L2vMayAUo819/YeirEsGgIlVxAvH2uRHucyfK7wPpBu59LTtpuQORvd+UfwiTA7nOpFnwzGDflqTbggQUb2kY/NiMtPSf9dc6gDwvb6tR1E9wAl4U24LFQIauOcOAAbmd/SNYP8/s3YCgqhspFPso6gs4vnqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gwfMlBWwk6EXo+C2eWhcVNlwk1aAlgLkuGvO9Z0529M=;
 b=mk672thDF9j1ar6I89WuO0ZrIGnknhgu+mPx4NKc0betjVvTxW+i/6N2JH6m5tUvyoMKCedDGFAE2EY8ZEPgsxt9m6aJ4GIiUEo0wp/aKXUwf6MaSM3ybafL5s9IWo83Cp7oT6bCg04D4fw1HAoe6jAhwlN2FaAFNQWtGl0D5Y54fWk6Oglgyb2ns/E8Lp1XXYUvjbSx36pNuPFyUDYFwo/D/9bliXcrzuh9c8cDls3B53Rrqlg6HoniiZRpjJArw3MBlfgNlbr9hVKkdkn+APKGzeWfy9E5PhupMhC561eos9XqOxT577lsqzziYOxDEmwLr6F1E22+xI1iGpFkzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwfMlBWwk6EXo+C2eWhcVNlwk1aAlgLkuGvO9Z0529M=;
 b=dZi3jdY16MUncpBNQXB9xDblt/c8sxIIl9JzW9IbotIYBdcaRijIxU0DUg0GbaC4cZJCvwZbjtRWPpoArxdaKZdtlYAwFfk2MCuNyZhIcXmNuotnuLcR3Nr5H3OR4Dnqr2PzmpFjaw6K1PvyNeWI72AoqdSfREH9A4lcOaDZ7eA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 BN9PR12MB5322.namprd12.prod.outlook.com (2603:10b6:408:103::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Wed, 18 Oct
 2023 11:27:29 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c%2]) with mapi id 15.20.6863.047; Wed, 18 Oct 2023
 11:27:29 +0000
Message-ID: <c65817b0-7fa6-7c0b-6423-5f33062c9665@amd.com>
Date:   Wed, 18 Oct 2023 16:57:15 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Reply-To: nikunj@amd.com
Subject: Re: [PATCH 3/9] KVM: x86: SVM: Pass through shadow stack MSRs
To:     John Allen <john.allen@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, seanjc@google.com, x86@kernel.org,
        thomas.lendacky@amd.com, bp@alien8.de
References: <20231010200220.897953-1-john.allen@amd.com>
 <20231010200220.897953-4-john.allen@amd.com>
 <8484053f-2777-eb55-a30c-64125fbfc3ec@amd.com>
 <ZS7PubpX4k/LXGNq@johallen-workstation>
Content-Language: en-US
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <ZS7PubpX4k/LXGNq@johallen-workstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0233.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::12) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|BN9PR12MB5322:EE_
X-MS-Office365-Filtering-Correlation-Id: d2c34b3e-f70b-4c38-84b9-08dbcfcd3618
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qX6TUzVVeGcLCaPhAW+5QNk3DsiDO0suGyjpuMFFtYomumwLRtTAjO5T7CyQ4z4Y0dMYUZo63cFbnblkWZ+vrbVW8IyTSXibU17jyBvSiU6eJjyV1pZSWEGkxVf9yGahQgrpt3yD/LXJjgZRT0yD4Z9FBZ4rapZgc2IKZsYXGJTFnqper1WqtJEryXEmBhPuFphubFGrx7Aj8HPobCBINowQyjYY5kokBxjLpQhClSQe5dyfDOaH7OOQsxHMZdvHf+AN2xFE9G+1nr249XObL0yRc+nUaf8kBMiCB0aRkiq9Zn9IBV3QIdVmQ95PM2zZwlqTqxARlv7Hl6w56mEjrgNGXu8PANGXbtH+fLIUnn7KCuUvEFAtvpegjFGppiiqu6XoSDGqNQQYrfFu6o3ka7xN/yxvBCwWw56MkpTW8U3pC/dHwukwfS7v6ckiGrSB+mFQyJnmuue+qiT8uON380VNei8WcK+p31J853QXul+ylzoO4OP0L9b76LJS9BBjFMHIXPDO+i5BUZDFRoRftqyb1yv+pZ3wLoWl10M5zn6Lnf52ICdCySwWxJiA6U94pWO68ePqv46P/a8K66uIlCvsZyvtoMNLbkE91p7uySj6EnUGNWL9viggmeGDoThIx6eK0DJIexWK1EFO0S1vFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(346002)(39860400002)(376002)(366004)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(36756003)(6636002)(316002)(66476007)(31696002)(37006003)(66946007)(66556008)(5660300002)(3450700001)(41300700001)(2906002)(38100700002)(8936002)(4326008)(8676002)(6512007)(26005)(6862004)(2616005)(6666004)(6506007)(53546011)(31686004)(83380400001)(6486002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UStjb0NRZzdZaHMyYUFQYmFHKzl5Q0JaZExSOVIwanhYMy9Odk5iMDVtR1ND?=
 =?utf-8?B?TExpWXR5cGdtRENrcHl3dVY5b0NYMVc4S1VJMXF4Ni9laGord2ZoVGxHRitV?=
 =?utf-8?B?NkJEclFnQjhBRG5TQUpIMGhvbnYwUHlTNkU2WHlXZWtxNTRUTzR6Z1Rhci9k?=
 =?utf-8?B?ZzZjZlFlYkY3ZlN1UXk3dCtHM2o0VkUwemY3L1N3Sk8wcjc3dk85dkVGdWRP?=
 =?utf-8?B?Y0IwellMSktlYllrQk1qNTVKK0FYanRidEU0Yisya0dIaW5aTkF0RTZQRkdG?=
 =?utf-8?B?TG5WRWt3VFRsaDdFaG1WYnRmK2NXa0wzTTdKMUFaRXdtaTNQNnF6WVBQZ1Zz?=
 =?utf-8?B?dkxBaCtYWVNiNjdvQzNYMTR1NkNBN0piQWMvTFFwZXFVd0MwQXN4ZGtWV1I0?=
 =?utf-8?B?dW5TZGU1elBtWWpQUVRHdXpmakg2eDNKeHdqcUZjR1lMQWJicTlDZ1VhYm53?=
 =?utf-8?B?dSttOTFsYWk0bE0xYm5SZmNvMDVLNktWWXFiSHhPZW1KTWtKRUdnVWt0YWFG?=
 =?utf-8?B?Q0N3UGp2alU3UXZxNStjL0Erbi9vWksyUm9aWjhaK0Z2NGx6SnFVNDc0Kyt6?=
 =?utf-8?B?blRhSUlvTHNodWtaSGJGOS9QclUyTmNKbm9mSVBkVjRnK0pKQXhBTlJtc3JM?=
 =?utf-8?B?RUpiV2JlbnNTbWZMMXNHdE1PZ3BwOVBBZDdhVThVS0VlZHl5K1FienREdEl5?=
 =?utf-8?B?NGg0RkxrWHk5Q2xObk9vM2RKQTlRaTBpemwxWWMvWm50VzZTcXJRREtkdUJF?=
 =?utf-8?B?dnRWTU9XNlovVDBGcThYdXVDbjBiek02TkxRcDZvdWV5eG1rME5YL2g1ZERP?=
 =?utf-8?B?eU94c3hnYTYrMDVVd1V5SHVPcWNrR2UwdThTZ0ZNWlU2aDhZSFpOU29MZnVT?=
 =?utf-8?B?dGhoaGlxY05POHJybzdmTnJFdDFUYk9yOW5jaDhtQ09HZzRTOUQ4c1hUZWo2?=
 =?utf-8?B?eG9WQktpUDNKaFVLQVc2V21nTllWS21jcjZpckcvYjhFZ1krVUdGZXlNWHlQ?=
 =?utf-8?B?WlF2OGpPNWQvWVN2aXQrdkt3ZlA3VnB1b1EvTS95Slc0c0FyRWdHdlJTS0xw?=
 =?utf-8?B?eVdOUFA2cWNCbjlFdGJLclpmcGx4WDNmYm91d24rZzdFTnhiU1BnUS9wUy9p?=
 =?utf-8?B?NG9NVHA4WTlreEpERGhSdG9PcmZFV2Z0ZjRQaDJhM0lMWGhNbHdyR3FjMG5E?=
 =?utf-8?B?d3FLQVVNSE1aaWJRV1I4Z3JmdUowMHdYS2xSdUorQks0TDhpMzNiUkV4NW1o?=
 =?utf-8?B?dndEcEtiVGhTTkt6UTBoRFFPT3h5MkZHdlkyVG5MTEJ4MFBpWGpvNlVWY0hT?=
 =?utf-8?B?SkltZGwvWVRTZ3ZqS1hVdTV0WHZrdVk3OTJ0M0FsS01yaUhKUU1pYUpadEFZ?=
 =?utf-8?B?cUJNWUVFeDR1Yi8yMVkwNm9HeS95L2UvRlBTK2lmT05UR1NDMjRhK01ncWdQ?=
 =?utf-8?B?M2hzaWJpWjJFeGNud2lPYTBqMU5KMzFnd0JEdlVUb2JyZ1QrRXdWQ2pEVkxB?=
 =?utf-8?B?R3BtS3JsM1FQZGtoN2c5TXIxSEgwSjlqM1FtaENYdGZzaEJnSU9OYjNkUFdm?=
 =?utf-8?B?U2h4aHkwRjhxdWtQSCs2Vi9ZN1lsMWRkQlpCdXljOTkwOTdDK2Z5QW5zUFVp?=
 =?utf-8?B?eml3cmNCc0VUZU9ZS3ZPSDBPNUJSeUE3UFNRQ2xVRWFNV1NwWWtCQzRmNUJw?=
 =?utf-8?B?cDJuc1RpZzNVVlNRaXo1QUpMYm91S0VXd09xb0JJQ3JOckcyWXRUNjczRitJ?=
 =?utf-8?B?SndQTzlrK2ZibE52a0dpNmczYW9UcTNvbkVOeVQwZVNGTWgvUU9hcmQxODRM?=
 =?utf-8?B?ZXByaUpLWFo0WGxTNFFBcm1TKzNlbkZpUDdxYWp6THpnbmVibG5yK3hZU0x6?=
 =?utf-8?B?YXZjd1V5REc4bGlXT3B3UHkxbjhGS1I5bXJSVU8wdDRiVTBBaS9ldnpyRHF3?=
 =?utf-8?B?cUcwZzFsaFdHVU5zaGZZaU1oc3JBMmJxa21qbWNFY2RkSHJLR21aK1psWmpj?=
 =?utf-8?B?ZUdYMXZHN2xyOCtUcXgzWnB4UUFpcW5oUytRL2hPSjVac1RMNFBaVUM2bXYv?=
 =?utf-8?B?blU4cGJndU5tVHJKVjQvbnJ4KzVZZjRRS0x3Q1l5WkR0ZitGSTlRYnMybStv?=
 =?utf-8?Q?GFH7tZd3B2fNez57PGVrQaB6g?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2c34b3e-f70b-4c38-84b9-08dbcfcd3618
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 11:27:29.0100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o3Bu0dfMWHghhtMCHk9+8FlYd1/UIEtDLY746fSz/mwgGtfoCAaSJaokoBRtnIr0Z0ETjBisETzufUuIGC+rQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5322
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/17/2023 11:47 PM, John Allen wrote:
> On Thu, Oct 12, 2023 at 02:31:19PM +0530, Nikunj A. Dadhania wrote:
>> On 10/11/2023 1:32 AM, John Allen wrote:
>>> If kvm supports shadow stack, pass through shadow stack MSRs to improve
>>> guest performance.
>>>
>>> Signed-off-by: John Allen <john.allen@amd.com>
>>> ---
>>>  arch/x86/kvm/svm/svm.c | 26 ++++++++++++++++++++++++++
>>>  arch/x86/kvm/svm/svm.h |  2 +-
>>>  2 files changed, 27 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index e435e4fbadda..984e89d7a734 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -139,6 +139,13 @@ static const struct svm_direct_access_msrs {
>>>  	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
>>>  	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
>>>  	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
>>> +	{ .index = MSR_IA32_U_CET,                      .always = false },
>>> +	{ .index = MSR_IA32_S_CET,                      .always = false },
>>> +	{ .index = MSR_IA32_INT_SSP_TAB,                .always = false },
>>> +	{ .index = MSR_IA32_PL0_SSP,                    .always = false },
>>> +	{ .index = MSR_IA32_PL1_SSP,                    .always = false },
>>> +	{ .index = MSR_IA32_PL2_SSP,                    .always = false },
>>> +	{ .index = MSR_IA32_PL3_SSP,                    .always = false },
>>
>> First three MSRs are emulated in the patch 1, any specific reason for skipping MSR_IA32_PL[0-3]_SSP ?
> 
> I'm not sure what you mean. 

MSR_IA32_U_CET, MSR_IA32_S_CET and MSR_IA32_INT_SSP_TAB are selectively emulated and there is no good explanation why MSR_IA32_PL[0-3]_SSP do not need emulation. Moreover, MSR interception is initially set (i.e. always=false) for MSR_IA32_PL[0-3]_SSP.

> The PLx_SSP MSRS should be getting passed
> through here unless I'm misunderstanding something.

In that case, intercept should be cleared from the very beginning.

+	{ .index = MSR_IA32_PL0_SSP,                    .always = true },
+	{ .index = MSR_IA32_PL1_SSP,                    .always = true },
+	{ .index = MSR_IA32_PL2_SSP,                    .always = true },
+	{ .index = MSR_IA32_PL3_SSP,                    .always = true },

Regards
Nikunj


