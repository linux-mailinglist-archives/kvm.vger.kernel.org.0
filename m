Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAB062C32D
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 16:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbiKPP4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 10:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbiKPPzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 10:55:50 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9B856546;
        Wed, 16 Nov 2022 07:55:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8n6PCzoibSUHkptPino2NDbzA2z3j4cZvsfoIg99K4emLpma2pWajdlNtGmbTxMkJuyUbN8YUbwVClmKAzeMTuKViAeAGql/RfcwH05oENFaJHBRMSQW55/cinFb6Qp7obM7hSK6CnPbGbUedi9OPF+G3el8UH22aZz6gQTHvntubmxlhMoAwh35MzIstSTpYPtguWuo20RQwTrMGmolfzRu1bMwu64EDOCMZxCUaGqq4X71xFMmqMsrUB4X+U/9lNeg88u2Nl3cac1Chy/bSEaqvf9RjaEHAAAhvJxcmaQzZEf95jtXz/puOx7oy3jLbS397q4q9c3XOWjFHK+ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nanFK8Jg6Am7vQ6maG9FubXrvk1eBZX1qgE1TkC/xrU=;
 b=XFQDErUKLT2nzpSSB6nBHWZttZki0Kp0LENytbFbw1anyPzVs5krmhJEzmnt4+3kofy/SC4MsVTT3W5S+IzSwHjZE9tTVmIRGyV0b4reNtoZ1YJfJ0vHb2LnGJQlPhI1RE1NuwCHZWRnsaYF/DXfy13IAqIqC6S2iUdjN3/U3oBjeeGP9rpm19HRy8V0Re1SPv0e7CH+1l8+NRbbgtL1u8zYpiMcLS21ZgHbGK4mz9uQBwORrsbB6+aDiXiMxLj6HrWamkjXCvEvX9n55Yj/7IYUpg1lLCkiyRxufSjwFKXOrWVKPTLr9a27bixE9htRSRNTVRDPAQliT5gxJuCH/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nanFK8Jg6Am7vQ6maG9FubXrvk1eBZX1qgE1TkC/xrU=;
 b=rYAl9SevkzfHlXLDw2KXiZ4H6C30WV5VDGvoBfMhr/9igDG5KlD41RNsG8sqhVVRAgKTXfOGJamzO1TGtQPYmB/wK7xZ3niOkBC8f3f85TDfrdNbs2K3WriT9rPfhqBNdYABX/kINB6stVHOFs1OJOFHSUPRPquh1FBIDOkEW1Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 15:55:10 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 15:55:10 +0000
Message-ID: <bc7fd8db-88e6-ea9c-2266-d0e129025e6b@amd.com>
Date:   Wed, 16 Nov 2022 09:55:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCHv5 0/8] Virtual NMI feature
Content-Language: en-US
To:     Santosh Shukla <santosh.shukla@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, pbonzini@redhat.com,
        seanjc@google.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, linux-kernel@vger.kernel.org,
        mail@maciej.szmigiero.name, vkuznets@redhat.com
References: <20221027083831.2985-1-santosh.shukla@amd.com>
 <d109feb8-7d07-0bf1-f4ad-76d4230ed498@amd.com>
 <869d05b2ce0437efae1cf505cf4028ceb4920ce2.camel@redhat.com>
 <fc8813c6-0091-8571-d934-e33d7d56123d@amd.com>
 <f764c7a1eb4a9fe294f04ea48db2dae9c18116c8.camel@redhat.com>
 <ce8f06df-5c7a-e122-3eb7-0d20207cfd2c@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ce8f06df-5c7a-e122-3eb7-0d20207cfd2c@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0389.namprd03.prod.outlook.com
 (2603:10b6:610:119::28) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|MN0PR12MB5953:EE_
X-MS-Office365-Filtering-Correlation-Id: c733bbf0-77b3-4071-7468-08dac7eaeff4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KZssaEVWmYTsPrvR8Ja298butgAiTtQvmKCljiO5KzZifEYPmxOCN3gp/muP0jUmIfn+f0YQWWXiCS4qgKGphtD7PGWkzSZOgLQD7CmT9dA5FKpLBLEF7nfemIG9A4j7TaTsPMiivlqQ71SfeWtIfpQtoZCph7kyD1TfoHwyeSyKH/l73J/xnlZsBua1jQL6uv60vi048pRTQFpVC/vl3cBFkleObXYaCzcMdiWSxuLl4xMfKQDReqGvU+tdoKmaREPz4dqzK5Wcb4Bbq1NyXc/ulEQEoUtWksKgdkSkYDo4QefLk/L74B4ncBY3Gwou9I8+blVryPX46MZT4ltWk+sPWudpYSeBjpR7rFR6WuVh/clj/B1ENtd8X2vCH85LTDSFIYAYYFDH2gxFrVzPqj4FAyXlnGu4MO8Ow/8pziJtT+dutbMq+DjVKRcCkEX66ZxhGqfSeqBRZQhBqjIv9L8H1Gw3/euw5a+zeCRupZdSFhoZPYMD2FfAGtre29+xBsZsXIlJ4xRgnJcGazbSpk7zzR0n4kL72yiSrTiDQLVzkEfZ4q1xcxUTGvxs7Hfb7+3zyWtIjOapakWr7EPlbLu1/AdPAp9HfrtCxJDQqyY728vClzHdqB+W2GcvHiMkDyCOeJ++80+W0XOAWH9lSbiEoOWguwdP5Qz4sD5Z+mVTGkT+f5nD3K6dZPeN28/88cprpBFQGzjwBciZgh1WyUkvyr2RMzGxoL8p/SOqJm3l0dOiRIbC66ef9mqSoI02lVmPHnqOxEOIZjIARYey0Lp/mNJXTvRyYLvpZkqIvMruhffunkz2YGpO/+xoqr7xqzaUY/uGV/gYN2xdRLI6kt6VuVRBiz0eF9K/Djp6Upg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(451199015)(5660300002)(36756003)(6666004)(53546011)(2906002)(6506007)(4001150100001)(110136005)(83380400001)(26005)(6512007)(38100700002)(4326008)(86362001)(66556008)(66476007)(66946007)(8676002)(31696002)(2616005)(8936002)(186003)(41300700001)(316002)(6486002)(966005)(31686004)(478600001)(266194006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWlDUlZWRW5ZaXdDRDU5dkFqTHNWSGVGeEpXSVZvendUVldvLzl5bWMrc2Fi?=
 =?utf-8?B?Q2p2T05IUm9jNklLa1g1dmdjc0pHY1AwMXFXcmtzZEYweXdybWdCenlPanVw?=
 =?utf-8?B?Y2dhMmcydUhTdXlmb3A0UnJXbEZaU1QwSUtNdjhzYStoNUFzNVJVSE9MVnFr?=
 =?utf-8?B?Nk5HUGRPZ2MrY3hOVGFhRmFsZldCTStrQk9kOEpycXJjNGZqY3NXMEJRVXN5?=
 =?utf-8?B?dHVrc2ZaUnBqTkF0SXd5RGwvYUNKN2ViTUZ1enZMUkJuVm9TSGU0RUdlR2Fi?=
 =?utf-8?B?UGdxZG9RTTYrd3QzTWdUOTZLS0N2TWtDYjhka0luUURpOTlSTlgxaHo1bitu?=
 =?utf-8?B?UTBhZHJjenZia0RkSmd0dy9UR3Vva29zUnZUb1BPY0tIYTRBSks1eHpkR1ho?=
 =?utf-8?B?ZXlObGJoN1dFWklQMHJLY1dCNUI2N052Q3JIaXZkK3drWGRTMm5TQUNUbndN?=
 =?utf-8?B?ZmRLUzV4MDUxN3dCWEE1bUxCb3FVbHA3TG13bFU2M0ptMVZnNUtTRlM3d3hk?=
 =?utf-8?B?Z2pudWZFaElpa1YzanorSFBIK3orSlRWNVJXTWJhalNuTzVRVlo5aTdTUnJE?=
 =?utf-8?B?MUpNUEthVysvZ1BnNkZGcjZVYjdIV0FJdzB2YkhTN2RoeThlRDM4ZmF2NzAz?=
 =?utf-8?B?ZW9aOFE2dU4xb0kwQTZPZmFWQVJ0QkpiL29SNUdmSW5CbDhEbGpxbkJ2b0NU?=
 =?utf-8?B?V2kwSXRLYVFjMDRQWVhTeG94Z0RVMVNaVnp5Q0dwSFVtT2NqNDZmK3VZV1E5?=
 =?utf-8?B?aUxPWGFETDR3RnVEbUpqc0hkNVBrU1JRcVlKcHdwT09aZW9WcitqTlhBSzIz?=
 =?utf-8?B?R0lWU0xZbHorZUpKUkFvbExCZG5GZW5VcHFIbWo4S2hCeFZDeldsSzVYaFBn?=
 =?utf-8?B?dU1ZdXhvVmNvckprRkJmd0Zvb0ZlM09PamtCTGo1Sjh2YmFNbnNVVzRoMUxu?=
 =?utf-8?B?ZnpLNlJZbEdEZTRWVDh5NGcva00xNmg1MlhkQTd1U1hxbEF1S21kVndLQUhM?=
 =?utf-8?B?MDFJbVdSM1JnNit2cTV2TmlrUFNKTm96N29IVVlxaS9XaTY5S0ppRkdIaXBy?=
 =?utf-8?B?QkJxeEcyTXNzTjJpSlg5R3lnQW51TTM5bmN2aGV6VjVhZi9aaHU4aUxVdVRT?=
 =?utf-8?B?emhGcC9tdFpydjEvVmFzMjZublpwZVQwZC92OG4rWEZIa3ViZkJISXBOSGN2?=
 =?utf-8?B?TSs1ZHRzMEJQTHg0TlRuM1RmeVdQc1VBaDI2VHBNN3hmS1dRV3A3bTV6N3Q2?=
 =?utf-8?B?SThvdm1xWmswZ3owZ1dsN2xmNkhMcC90OCt0ZEVXSEdCNmFFUkx5MHZBOXNP?=
 =?utf-8?B?NjhxaGN2cWlhbkJuWVd5MW1jSlJxZFdsMUhkWDVxOGNZU0x2OGdQemRSQXFn?=
 =?utf-8?B?Y05kUVplNGhpTmxIODdlR2E2MXF1c0tmaFJsa1g1c0tQRGxGU2ZKWmNUT0xu?=
 =?utf-8?B?THpkZDhMdEsxemh5M2pMeVFKQk5qaHdOY2ZtRFRoVFpHbWtFS0ZPMk1sM1dy?=
 =?utf-8?B?WDVjK1FHVGlVbUFtVUpkQWY5NnVMak9JRlFwT3hFd1QrLzRXNUlaVWtjMC9X?=
 =?utf-8?B?ZGNJL0QzaVJydHo0SDFGQVpHWE5tL2tuUDVVSVVXdUxrcVBidURDbXdGN3R3?=
 =?utf-8?B?aE0yWDlGbEJEdWVOZDZFTzNkWVA5VlJjdUo0NVhHRE9aRnNuSjFsTmgvK3BC?=
 =?utf-8?B?OVFUcHlCdDVFbXlQcHhnR1ZURmUzbzkwbEEzN3Z3ZjY5a2dNcFlEVkJHa2Nh?=
 =?utf-8?B?cmxSZS9DUktpQ2FoYmw4aFBnaEdnSjJDNWZDa2dpcHZHT2tkQVdDYUhBSDls?=
 =?utf-8?B?L1puSnFVelp5a3Z6NHFYRkMwbkJxUlpOdmNlKzlsKzg1SzFQTTI5Qk8zV0M4?=
 =?utf-8?B?NEpNZzdMRzJ0ejlEaWMveG5weVpEVmd5WkRKdUxud1l0aEJ1NmZlU1JxMEdM?=
 =?utf-8?B?dnF3RlZXOVoza0FRQTNSRjBTVXRNdTJFSFRWZW1YdDdUN2NVSUJGb04wRTkv?=
 =?utf-8?B?cmFmUzdmMDFXT1VaMzNqRHRSbGFOOFg4bi94a0hCOWx2SEtWWDUxTHVQMnBt?=
 =?utf-8?B?Sm5lQWtVZlo1N3QwS01nTDE3b2F6VWVEUFV1YS9pTVd6M0dEeHZnWDZPLzJH?=
 =?utf-8?Q?WCbZt84Dm0JIlMku8xZHq6J1b?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c733bbf0-77b3-4071-7468-08dac7eaeff4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 15:55:10.1819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sejfX4nteVbqPM2N5AgzPzYHVyj3j9ogNyqaV+Dua9d7wg4gZYbs7wHi+9rauNWunmzSKPGmTYhXTVogiXApPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5953
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/22 09:44, Santosh Shukla wrote:
> Hello Maxim,.
> 
> On 11/16/2022 2:51 PM, Maxim Levitsky wrote:
>> On Wed, 2022-11-16 at 11:10 +0530, Santosh Shukla wrote:
>>> Hi Maxim,
>>>
>>> On 11/14/2022 8:01 PM, Maxim Levitsky wrote:
>>>> On Mon, 2022-11-14 at 13:32 +0530, Santosh Shukla wrote:
>>>>>
>>>>>
>>>>> On 10/27/2022 2:08 PM, Santosh Shukla wrote:
>>>>>> VNMI Spec is at [1].
>>>>>>
>>>>>> Change History:
>>>>>>
>>>>>> v5 (6.1-rc2)
>>>>>> 01,02,06 - Renamed s/X86_FEATURE_V_NMI/X86_FEATURE_AMD_VNMI (Jim Mattson)
>>>>>>
>>>>>
>>>>> Gentle reminder.
>>>>>
>>>>> Thanks,
>>>>> Santosh
>>>>>
>>>>
>>>> I started reviewing it today and I think there are still few issues,
>>>> and the biggest one is that if a NMI arrives while vNMI injection
>>>> is pending, current code just drops such NMI.
>>>>
>>>> We had a discussion about this, like forcing immeditate vm exit
>>>
>>> I believe, We discussed above case in [1] i.e.. HW can handle
>>> the second (/pending)virtual NMI while the guest processing first virtual NMI w/o vmexit.
>>> is it same scenario or different one that you are mentioning?
>>>
>>> [1] https://lore.kernel.org/lkml/1782cdbb-8274-8c3d-fa98-29147f1e5d1e@amd.com/>>
>> You misunderstood the issue.
>>
>> Hardware can handle the case when a NMI is in service (that is V_NMI_MASK is set) and another one is injected
>> (V_NMI_PENDING can be set),
>>
>> but it is not possible to handle the case when a NMI is already injected (V_NMI_PENDING set) but
>> and KVM wants to inject another one before the first one went into the service (that is V_NMI_MASK is not set
>> yet).
>>
> 
> In this case, HW will collapse the NMI.
> 
> Note that the HW will take the pending NMI at the boundary of IRET instruction such that
> it will check for the V_NMI_PENDING and if its set then HW will *take* the NMI,
> HW will clear the V_NMI_PENDING bit and set the V_NMI_MASK w/o the VMEXIT!,.
> 
> 
>> Also same can happen when NMIs are blocked in SMM, since V_NMI_MASK is set despite no NMI in service,
>> we will be able to inject only one NMI by setting the V_NMI_PENDING.
>>
> 
> Ditto,. HW will collapse the NMI.

Note, this is how bare-metal NMIs are also handled. Multiple NMIs are 
collapsed into a single NMI if they are received while an NMI is currently 
being processed.

Thanks,
Tom

> 
> Thanks,
> Santosh
>   
>> I think I was able to solve all these issues and I will today post a modified patch series of yours,
>> which should cover all these cases and have some nice refactoring as well.
>>
>>
>> Best regards,
>> 	Maxim Levitsky
>>
>>
>>>
>>> Thanks,
>>> Santosh
>>>
>>>> in this case and such but I have a simplier idea:
>>>>
>>>> In this case we can just open the NMI window in the good old way
>>>> by intercepting IRET, STGI, and or RSM (which is intercepted anyway),
>>>>
>>>> and only if we already *just* intercepted IRET, only then just drop
>>>> the new NMI instead of single stepping over it based on reasoning that
>>>> its 3rd NMI (one is almost done the servicing (its IRET is executing),
>>>> one is pending injection, and we want to inject another one.
>>>>
>>>> Does this sound good to you? It won't work for SEV-ES as it looks
>>>> like it doesn't intercept IRET, but it might be a reasonable tradeof
>>>> for SEV-ES guests to accept that we can't inject a NMI if one is
>>>> already pending injection.
>>>>
>>>> Best regards,
>>>>          Maxim Levitsky
>>>>
>>>
>>
>>
> 
