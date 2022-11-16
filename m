Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1435C62B2E7
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 06:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbiKPFlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 00:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbiKPFkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 00:40:52 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2057.outbound.protection.outlook.com [40.107.101.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B841A3C6D1;
        Tue, 15 Nov 2022 21:40:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hBuxrzCEi2lb5A2VLpKxIu6v4RzW8/0scx2/IuU98x+DTh079PpK0R8ZbgoF/tJOjpP8imI7PwSd49YVbuYaIYKrLGFkwXCuRsJQxlmTwSQQJsDZwEtuLhZM2qQJeADQCpnDyw3oIaGJE32AgOssULHWFjEvY2MnabILuHvLSUZluFXklh3W69LeIS54k+bDJk6etxZURI7a8rSjEGSPy5pIIGgr5/tAamO3ZxvS43rFdkT5iDnJrgdxDh9qvZUYZ9AjMUHejDf8eJJ7wJ06VNDtRNSOj97dAl5WtLecSuf9fK9ojKqKa17oHHZxMR4mcmpNt0Lz0l2O/kYlAabUVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ssTPMqhlyT7ZTg7P/RAUH6Rek3Ve/D07Hag+uPvC/bc=;
 b=H7ABmBBDPZSFhwwmemxqx5d9nGP+nlGzqqd9+0FZvmwCwOgPP1goHD+MplVLSSE9ZbiUq33fiTW1jtCu8NAzH4x6D0lnscDZfIMWEEt1krAMF+c5ivK1sJQdHPvkHUAXbBBphlpxNp79Szz4fC5K25Wq+WKa4fWwQuUbvda0D5U5dbEN9WovmCbheY7kGJlX3G7CusWzSI8g42aNzwFPNSVfh2CFGAiwdzdJCG7EgWdoI4MzgFY7lSV+SuhFkKB0utxESZ2uN9xSEQoQwQg5rpGaKMJRvDfql8IeyWociOaAg6vm1DUrSuXBj9dNM+4kjTbNSOSgFMsIm8hb3yNgag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssTPMqhlyT7ZTg7P/RAUH6Rek3Ve/D07Hag+uPvC/bc=;
 b=UuW0EwBqZJ2+r9Z7ggyMK7riYiVH1/e076kvaVDNBF2fY5ddUY85QMuV8i+lofnv99532kLWfH2dMAYMhI18rqVwNvXYmrdSZG89Zoh8C4jWdaOUJvznaEjAP01H8uxYzVTfYkHyZsnWLodQumN2XXoD3gh8OfvVeCG0/zvao+Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by PH7PR12MB6612.namprd12.prod.outlook.com (2603:10b6:510:210::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Wed, 16 Nov
 2022 05:40:41 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::3bd9:dc6b:7c66:d776]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::3bd9:dc6b:7c66:d776%9]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 05:40:41 +0000
Message-ID: <fc8813c6-0091-8571-d934-e33d7d56123d@amd.com>
Date:   Wed, 16 Nov 2022 11:10:31 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCHv5 0/8] Virtual NMI feature
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, pbonzini@redhat.com,
        seanjc@google.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, linux-kernel@vger.kernel.org,
        mail@maciej.szmigiero.name, thomas.lendacky@amd.com,
        vkuznets@redhat.com, santosh.shukla@amd.com
References: <20221027083831.2985-1-santosh.shukla@amd.com>
 <d109feb8-7d07-0bf1-f4ad-76d4230ed498@amd.com>
 <869d05b2ce0437efae1cf505cf4028ceb4920ce2.camel@redhat.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <869d05b2ce0437efae1cf505cf4028ceb4920ce2.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|PH7PR12MB6612:EE_
X-MS-Office365-Filtering-Correlation-Id: 93d53446-2c5f-4eb3-34bb-08dac7951951
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m8AfkSKHKAbptjL3YrTzqbSELXZ8zIcnxJEqzgIUMx2km1PeNuSYwatHscNGaOBW2zA/iM2brBhA3/oqNs7bIQi9R5KLgXn7aeEPKlkyS2TiJRNrdohM/prLniM8njEKlKADWSB6yzjUr9sv7Z35lYs0pxRGpt94EHKFSunxvUpRD0MEr2FgxX1bZCfhBJEwmBqnsjiYT9gdyHSsvCjBLN1DDfpbSICo7MpGoOT8ZDTkA/fM3DA2NtMGhUjEoX09vjN9QQUD8DXtaUfUx338a4/61vsvhytgaNYC7vYNyX51qwH1p1Rob/1n8NTjpsrTn49aRCE9rsvT+hBBkdAH0F25dacG2H41Rj/ACZH31ynuIBoh1Pki+dD2k2KukKl+HEhMHtdkEU+lhy+dtFYqleGIaXVQfPvY9wXm+Wlw63rTdXqJ1rXaXwag95llSuwWDTLzpYJXJtFhkAlOllr6UZzunIi1hMj0silPDnFK8FXTgbAA9mL0yuGIU+SX7ME0okriTBw7ouHQ4Jk3KpplqNBE7p3IitL+NCqDqvJKDqG5rDrn9LYHq8DE2gFWLlxi5+r7pReDxtIBVk4PgzWvVHLHK3+k4vJUIXVZgEPqe+PhTDkksX1PqmTaFcxAqXW1DSQCeZUlOTLQRELO5MUXuRIVTOSwqH8I+LvX2n038jWzs4UmN0TEasM4OBEFFO1SL/J0CmRkGKup7JJAqguYJ5RsDHk/WQqWWdCbTIhhIvUqOpMDND/DsJpiG2xgNO0Hgdv3HVj80Tqm40xGB5i97ZAAQFifQjKrJu0nz9AIrLn2/dohSczFJdC5g+hCeBfPaCEXCrYO+XPirR3MjFbnPxZPc+2WW126PJfRe8AVj5k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(451199015)(41300700001)(36756003)(44832011)(83380400001)(478600001)(4001150100001)(8936002)(966005)(6486002)(5660300002)(86362001)(38100700002)(6512007)(26005)(6666004)(53546011)(6506007)(2616005)(31696002)(66556008)(186003)(8676002)(4326008)(66946007)(2906002)(31686004)(66476007)(316002)(266194006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHF3SUc3cEVHZVdYeFYwcHBzTHR3c3o0OEM1cVhZdVE2TDgxUEE0NmNvQnhC?=
 =?utf-8?B?YlBid1ZCQ3ZSb0VDU3h2b01OOXh6bmtJLzM4dmZ0c3EyL0FzZUF3ZWxzZWFk?=
 =?utf-8?B?ZWYwRXdaa3RoTmh0eXdtNUZ3L2JQN1QxdGZ0b1RuWnBwMnZva0RScGFHeDRj?=
 =?utf-8?B?emFWOXRIUkhYYXFKRE4zRjB6ZmxzVVMzM3cvWTYySW5PUDFQZWNBNmwyM3Yy?=
 =?utf-8?B?TVlYcjVzZUhXQy9FTFgwWGlEc2w5bDZ4QWR3NWp3R2ZLYlNXQlJaa2tIWENI?=
 =?utf-8?B?c2hPYUlTY1FEMi9GUjhaMmVEcllOM1VNVDRuYU0rbCtnczZIMXdHdHFQR1l2?=
 =?utf-8?B?MmlOMHk1emtETmhrazFIZ2dkbW1DUlJpNk5nTkphcUxpTHVRTHZJZ0JBR0Fv?=
 =?utf-8?B?UnBIbklhNjM4WE5VUGtkNllhS1MzcFNTUUhPQm9WaUdlWkUyU2Fjc3RzTUt6?=
 =?utf-8?B?c1YyYlR2UlVpQ0F6UTVCTVQ5cDFGK0VXaVVuc3BEMjNLSlFnN2FIOXJ6Wk9H?=
 =?utf-8?B?S2N6cklSY0MrMThwTEdKaXZKb3NzbUxORWpoWnVoOEtzQ3RPeUFEM21uSWdI?=
 =?utf-8?B?dXdMcVZXNzVaVTVTakxKOVlEajJlYVJHcW45TGhBc1RoNmR1WjVacFROZVlk?=
 =?utf-8?B?eWliQVJFNUQrUzNGR21IaDF1amQwK3RzdkhEN2tETFpGU04vMGd3NTBwNUt6?=
 =?utf-8?B?cktMT0ptWHR2a3dteklTbGs4a1Mrd2Q4YThmM0JTZmJFVjNPZUlXM1pQQzcx?=
 =?utf-8?B?aUhLMVpXTmhPMzd5RFkrcTNBT2FlWGoxZWZMaURnVjVFeTN1amlPREJTMFlG?=
 =?utf-8?B?TVVqdnV1eENUSnRhMGlaam9GcEFiSCtrb1VuMnk1WUIweVNiMFkwMS93MWxs?=
 =?utf-8?B?dk05dHNKaGRCT3d0VWt6TDBqcy9mKzduR08zYnV5ZTVmZEpvNlQ1OFRHRTRD?=
 =?utf-8?B?UGJZUnRQaW9XSVJqTks1TXNTaU9ZOFBRV3ZVTWhjUFpEcVJ4RE0wcW5WaUg3?=
 =?utf-8?B?d1B6NzZRRkxKRk5IY3NCdGtRTXBQUnRSdVF5dUMrbFNOU0FiZDIxMkxZc0h6?=
 =?utf-8?B?QjNQRjZDWGVWMDd3aytlWlhqNmkvV2VkS3Y2US9LVDlYZ1hGcW94NGRFUmdB?=
 =?utf-8?B?dGIrdjBGYnZqNTFMVFRiM1NabWZRRVU1cHRKbnNMdVVCQmt6L1l3UmRoa09U?=
 =?utf-8?B?MjFsVEgxaTI3bmRvbEcxR1ZRWXdhNFoxQSs0WFQ0d2VMM3h3cnV6NkV4bFdR?=
 =?utf-8?B?U0xjRzJOZWgyYW9XbUJCdkhmMU5wdjc4MU5nSzlyUmxqNUNud0huWDVFMzBL?=
 =?utf-8?B?Q1hVQnloajBxUzZTRkMrQW1wdFNVVEdFTTlQYjRjUXR3SDNPTmpQVy9yV2Jm?=
 =?utf-8?B?UWhHSzV6dUNaWkoyWThZL3k4WTRBQlNpTG52ekZxOW80SFI2RHdpT2VMMWFL?=
 =?utf-8?B?d25MWVh0RXROM1gyWnd4dnlGejBNOUczMC8yeWdzOUNiTEZuWjBGNUh4L0s1?=
 =?utf-8?B?cklXUmxlbU9ldytQWjlUMkdGTHdIQ2hCQno0YTNZcURLZGo2aU5KV2VrOHRq?=
 =?utf-8?B?U3k4dWFYMnowOVgvUVlEQ3JNQjhHcnhqaG11YXl0aUFkYnZwZFhWNzNHRzhO?=
 =?utf-8?B?TENCRUVjVHBqdDJKZWlxb2ZwNTRNYTBtV213Ykcvc0Z5TFVwaHIrK0RoVUtR?=
 =?utf-8?B?Z0w3NWhuWjBvWWl0Qk9jY2RzNklqMkJzQlA5Ukk2YXZ4SWRZY2I3eHgycEVN?=
 =?utf-8?B?cGZNUmNZNTRweUUvMXdFcVhPOWNIYXdIWkVVR1N6V1F6N0ZlTVN0bXExMjlQ?=
 =?utf-8?B?ZWNBRWlmTUJVR2RUWGlVbzcrdHVPNWVoM2EzVk1yTFYvb1pwbVRBV1NxUGtu?=
 =?utf-8?B?L1dmalQrZC80djRyYS85bjYyTDlNVEl0aC9hK0JOMDZaVzBSSWRjMXhaTXE2?=
 =?utf-8?B?d2tsYnlaMHdIeUlBWms2cm9oUFRCNzNnajVrZzRzQU9CWWFOVm91Y0FkOTdT?=
 =?utf-8?B?RUhaU3UrTUtwcnpKazU3UXRTWFhnL05rblh4TFVlMDlIOVppaXBWblJXc3Ar?=
 =?utf-8?B?TG9QQzNnTjZqM05jOXlsdEdpVFBYNGd6ZVp5UFlMbDd2ZHJ2K1UzMTNxNHdu?=
 =?utf-8?Q?TpM6OJGvb29N4pB4fT/3t1rZq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93d53446-2c5f-4eb3-34bb-08dac7951951
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 05:40:41.8121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8HQSLoj+TsKtI1p9BWWtIkScRDOKOmh2MMZ4MEkfX03eF49GoY1BrguuM1L68p8Ehs9zCPHoHwki5bqYy03c4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6612
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maxim,

On 11/14/2022 8:01 PM, Maxim Levitsky wrote:
> On Mon, 2022-11-14 at 13:32 +0530, Santosh Shukla wrote:
>>
>>
>> On 10/27/2022 2:08 PM, Santosh Shukla wrote:
>>> VNMI Spec is at [1].
>>>
>>> Change History:
>>>
>>> v5 (6.1-rc2)
>>> 01,02,06 - Renamed s/X86_FEATURE_V_NMI/X86_FEATURE_AMD_VNMI (Jim Mattson)
>>>
>>
>> Gentle reminder.
>>
>> Thanks,
>> Santosh
>>
> 
> I started reviewing it today and I think there are still few issues,
> and the biggest one is that if a NMI arrives while vNMI injection
> is pending, current code just drops such NMI.
> 
> We had a discussion about this, like forcing immeditate vm exit

I believe, We discussed above case in [1] i.e.. HW can handle
the second (/pending)virtual NMI while the guest processing first virtual NMI w/o vmexit.
is it same scenario or different one that you are mentioning?

[1] https://lore.kernel.org/lkml/1782cdbb-8274-8c3d-fa98-29147f1e5d1e@amd.com/

Thanks,
Santosh

> in this case and such but I have a simplier idea:
> 
> In this case we can just open the NMI window in the good old way
> by intercepting IRET, STGI, and or RSM (which is intercepted anyway),
> 
> and only if we already *just* intercepted IRET, only then just drop 
> the new NMI instead of single stepping over it based on reasoning that
> its 3rd NMI (one is almost done the servicing (its IRET is executing),
> one is pending injection, and we want to inject another one.
> 
> Does this sound good to you? It won't work for SEV-ES as it looks
> like it doesn't intercept IRET, but it might be a reasonable tradeof
> for SEV-ES guests to accept that we can't inject a NMI if one is
> already pending injection.
> 
> Best regards,
> 	Maxim Levitsky
> 

