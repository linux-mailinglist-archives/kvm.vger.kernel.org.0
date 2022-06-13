Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76B654A049
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 22:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351027AbiFMUyo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 16:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351308AbiFMUx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 16:53:28 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773A2F22;
        Mon, 13 Jun 2022 13:16:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UwMOkhEIxx8NH3wDwWUg2zkL9XfSbP06n7M993sFLnsEqi55/xsX6T7vOUZeCS9bkL/5hhhEbkWgUyPpjYaLo4I6jHSrqAGcQph/6tibo+pdZhLRCamKfGFbXBJ2a5t1fKP0GiMzISR1XkrFPljnevKWSMUEZ8Qmw3RecauuLu/H55NI3Lkng6WKNuLSBXcgJhltTdl4Na2msPjtm13ygg5rq0HIEiAcVm+ZTyFb8LLAcSHxgumxtpGId4oR7Ho/rx/a/mlx+Ovck8P7FdKWMH5HRzZmo0urGdt79iROVChm2/gJ/Sk1xlN6PoWRwsfMA2itUmvhH4ZQY6OEjXSI2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h/8JhsqcOMpcWNJaQ+Z+UWya3jaZlhXTsFKX1fGsTzE=;
 b=EjHrDs6QsBX2jDrYun9s9iFh65WDIBpTyZxktpE9jfxrQimosapepjNNsJy9KeqbTJFU/04v9N0QnnRzWhDs8E+wsIlnLmm9GE7Qx3dWwanFNaFMa2/1c+MgPvGMhAiErWacqDehbZPoH2KrvJhWOOyKH0w5ZU9uW6RQwJHfXbaZovXzvf3w4GlkTJPVKMaRKO+IwUXCxXg0LnDfhrX3FKYV0bJ57c/+b0SWoUjapSw7hxNCWl3b9zuCI9MHn1yutM8WRna3d9YShpjIQTBwVQFLZ8WvEyckjdpXoZD9Wn724MemySBHJ/f3LcEwlMOr63NCb+yZue4ICNhLKnZlfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h/8JhsqcOMpcWNJaQ+Z+UWya3jaZlhXTsFKX1fGsTzE=;
 b=GKKWTHo9xYq3E0KHIpboTvJ81GfajDXXb76P7NDNiluEJp9AZP+8tptuScx8zmoEZImK7BoIHczeOHyFR7JHoRVTvM4xIIGMYA/msuXgmlxnmmQvEVwCTVd3QJ1ubt4Wew8EEgYjCR3XQBKwx/b/FBipGSdgwM2wmiUsT9cGZ/I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB2859.namprd12.prod.outlook.com (2603:10b6:5:15d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15; Mon, 13 Jun
 2022 20:16:17 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::db8:5b23:acf0:6f9a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::db8:5b23:acf0:6f9a%4]) with mapi id 15.20.5332.021; Mon, 13 Jun 2022
 20:16:17 +0000
Message-ID: <17a3d97e-3087-e79a-120d-b4a45f6c4fba@amd.com>
Date:   Mon, 13 Jun 2022 15:16:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v4 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Babu Moger <babu.moger@amd.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        fenghua.yu@intel.com, tony.luck@intel.com, wanpengli@tencent.com,
        kvm@vger.kernel.org, peterz@infradead.org, seanjc@google.com,
        joro@8bytes.org, x86@kernel.org, kyung.min.park@intel.com,
        linux-kernel@vger.kernel.org, krish.sadhukhan@oracle.com,
        hpa@zytor.com, mgross@linux.intel.com, vkuznets@redhat.com,
        kim.phillips@amd.com, wei.huang2@amd.com
References: <161188083424.28787.9510741752032213167.stgit@bmoger-ubuntu>
 <161188100955.28787.11816849358413330720.stgit@bmoger-ubuntu>
 <CALMp9eTU5h4juDyGePnuDN39FudYUqyAnnQdALZM8KfiMo93YA@mail.gmail.com>
 <5d380b11-079f-e941-25cf-747f66310695@amd.com>
 <CALMp9eRnC1RgRwj64TJcXdhhL6g835N_-E8FbeHVre6aX=18-A@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CALMp9eRnC1RgRwj64TJcXdhhL6g835N_-E8FbeHVre6aX=18-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0P223CA0029.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::11) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e45a7ac-43b2-4507-07b7-08da4d799285
X-MS-TrafficTypeDiagnostic: DM6PR12MB2859:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB285984D06B405098E6BF2AEEECAB9@DM6PR12MB2859.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RHLqfpHMMvrBmK4R0JYQwkfqN+g1xE/BgbDrfMKxaDgauKVdXrhOqBLdb//DalelJZ71ZlSDyK3L3gRsxNksHS2qpkSlppWX2IUFU67ZOzDAtrvgNQl57kdMKUeyGgk69v2ne3q3axIOtrsxCexN6/DoVZZi93THjSr/OOzuZDNOq8vjjtF3asEKCYcqLVCevNDr9dzlGxfDCb10kvAhi7MLbNqh8dCg9D6g9qYUSrX2CisK8OKs8eJI0qyecRnQamKGx3qNJoJm6jWYGn6OuPfcBqSQ6FB86cs0qC7pwkSVbujM7w8Ks9igpULnt1f2Rb/MZwIPKSQck0o2XYi9aW7Kg7eQQp+xHyRiWXFR6KuXYmaFjBE6bOyN9VAninN+3/GBADzOeXWVPOgPo6LcSnm2R1hLjZ1fnn3cWk6yjQ3d2EbgxoK2GIr8maILK2sGjj8EtVbj3sloQ6OgHoaZ7pPiK/UROXsVHga7Oc++ckM2Quq4HMkOIhUqoBkDypPonvJNKxyC5JdxCcWlFEpiEeRJ7BcJcfmZmM3fSfHFibxIUsSs7epktaWHdnC4I+7ny9/AzXl0PEgV9Y8aGsFjTn9x2Lj81T/sCH0trc4ur/loVaaZOpTJO023cSGEydRa1KO+zsGHDrw8Wwou8xzPGAksMLQVTn1smYoUvKd2IWE4h/93t9ir2YIuPo1zraXXgyrcVmRdWSUmlMIgT+QPANBcXeKBw5wfeB6D2MvL3teNKjWUMX/dCHbg118kOU3o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(316002)(36756003)(5660300002)(7416002)(6512007)(83380400001)(186003)(31686004)(26005)(6506007)(38100700002)(508600001)(6486002)(8936002)(6666004)(6916009)(2616005)(31696002)(2906002)(53546011)(4326008)(66946007)(86362001)(66556008)(66476007)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUdXTDByVEQ5Qi91V0ZORmdSdXNra2lNYnBHWUE2VXl4Z2s3ZjRLOUFrNTJF?=
 =?utf-8?B?dFV4NVBZTE0xUnI3cERHblBxa0pHSUdKSmtDVDdPYTNaamQ4VXdpdmU2R3pR?=
 =?utf-8?B?anZNemgxWlZKNDc1V01QdjQ5Y2RWbURsbmllUWRMK2ZJMldISlcrdm9qVWds?=
 =?utf-8?B?dW9ja0grT3J6Qk50T2xzWWYybktUVkdMZ0N3R3FHM1dOanJoN1R6WE9aOEZW?=
 =?utf-8?B?dWlkajNLaFRaTDI4aUxML1ZaL2d4cVcybmVHMytpN3NBeTQrU1BicVphRDZw?=
 =?utf-8?B?V0thRGlGeU5KclB5ZzhmNUtDbXNpTWJoa3dIeXhFckNVNjJrMFQ0UVdNRXVR?=
 =?utf-8?B?TGdSZHByMUp6eUxUOHhGUlJtalNFcWwrUXJJek1LaVNYczgrMEhyQ2JQMmh6?=
 =?utf-8?B?QTR0aGJUQktYNEhlVnNxZzRrS3N6NXY2cEEzQlQ3S0NMOUVoNUN2dHBtNmdE?=
 =?utf-8?B?ZFJsMkU5MVIwN0JsOVg5R05MQi9xQ2hEK0JZajRxU0RRSllnTElBem9WMEo3?=
 =?utf-8?B?R3g1Nzhuc3hzRmZKL25iRVFjU0NBbGtoLzQ3WXE5NytEMVBOR3dxcXlOY050?=
 =?utf-8?B?b1JhbkxOQWtmTGFqbHAvb3FCWE56ays5R0FnR1NyRVZWTHMyTXRSMm05c2xQ?=
 =?utf-8?B?M0FxM0dNelNvU1JybWg3ZnlBZWJJYmZzZ204RldnSzc5TjJxMGxGZ0RUYUtU?=
 =?utf-8?B?MnF1TnNyamdWWk85T1hmcDlkdmJZeUx6RHlscmxMRTdkVnB3Qk1aRlZtQ2NS?=
 =?utf-8?B?YlFmby9YeVRzY2EwTk1INzJBTEtMcGdoMnlKT2tMMDJnS3hnekJoamVid3BP?=
 =?utf-8?B?VDRENTI2NmRnU2d1NGpNVWhjZVBGbkwrbE9ONGpzY09ydjRrRktzaFJkU2hI?=
 =?utf-8?B?alVBRjNWR2NCNmVZemVzUUFJNU92NG9jb0FidUtEQVRKUVRnVnIxT3NMc0FP?=
 =?utf-8?B?UWtXLzFmUW4rcVgvWUpiSHY0NU04a3RQMHRDTUNQenRHbDJDT3dBVWZDOWVx?=
 =?utf-8?B?YUlLWTVKQ1Q4WjBUeVpIWmxSYUVkczFMNkJibExMN0xtZVFtRE9mSVFTU3Av?=
 =?utf-8?B?UGlKMlpIV1NsN0VLMmhtemcyVnpZcnZRdGVwOUg1UDEyY0gzN2pYZnYxaUlh?=
 =?utf-8?B?SGF5WDQvUVB6MWNSUUlJQndWNElBcDVJcmxlU2ZoejFDZEZrSUF5cmVqY3p1?=
 =?utf-8?B?UE03YVgzS2ZRYVpXZkQwQkljYUl6N0NNeHN3Y243MHBQbVhiN0lYYTBiRStF?=
 =?utf-8?B?WWxNODJuNXdNbHFOb0tDS0x1RjhDb1NHM2g4RDFSWDNFblBuNzZ3VGRFYnBV?=
 =?utf-8?B?NlhRMUhjNDIxOUt4R3g1ajJrVUtSbHVsR1VmdytXeVZTaSt5ME1vQUhDSzVV?=
 =?utf-8?B?alkxQTJmYmRZWEYxcGNZOTlybUxGc25CeXdBQkltbGRla2hqYUxRRUUzOWxq?=
 =?utf-8?B?VXVQZ2ZqbjFaTWlUZUYzWmxGaWthU2xwMTFMWXJYNWlrWHFoS29ia1NPajF6?=
 =?utf-8?B?c29uSlpkUHJNaDVhRHVYUVVxYUZIK2VudDBuQjV5bGJ1dUdMZksxMHZlb08r?=
 =?utf-8?B?cnBodkc4cXE3MGFVYVBmWDlSdGNaQnhsdXNwV1VldzVqQUY4MVd5c3NDQ2U1?=
 =?utf-8?B?bjhOczdrNU96QzJhY3hXY1YxcHRiUlZhZndYOS9jOEVxWTM3OVFvaGxER1Y4?=
 =?utf-8?B?a2FMUElHdW1WbWlLaEc3UHg2djBpR1BobTJ0bUJWajRiSFh0NU5reEpIRFZF?=
 =?utf-8?B?ZTgrVE9wMkJvdDlWUmw5RGdLVXU3SzNzNFhYNUw3UW9taDl1U0VUQjlLbXhD?=
 =?utf-8?B?VUhXeFJQNjlGazh1YUhWbHNFc0V1dnRTV2VLYlE4aVliWVI3eEVwYk5NQTIx?=
 =?utf-8?B?M0pEdXJobWVaRG0zdGJEcGRScE9jdVh1LzRzZXpxZ1AzWEd5eTkyVnBCbUpD?=
 =?utf-8?B?bHVpaE55MTZhMXFDZ3pzTFlXUHNZT01pUVVNTFM5SkhsM0hRR016MGZJdlpW?=
 =?utf-8?B?cFhjSDJGT1dLV2tmVUU2L0FiZStFUHFyTjhQYUNhZUZZVUFwZHhQZXVpUThq?=
 =?utf-8?B?Tkx5N3pYdkZ6UFNYcHJ3em1zMkJqWGEzNHVmV3RGTEI5eEQ3TjdBQ2g0YWtL?=
 =?utf-8?B?SHZlTlZsS3ZRbk00UGIrTnMvRVk4K3FNK1E5N3RUOEhsYkNWQTR4T2dQNDV3?=
 =?utf-8?B?eGtPd3RUL0dHUVBKZUxZUjZzR0dteXUzeW9GMDh4OHdpZTc2Zkk5czRnZlI3?=
 =?utf-8?B?bUd4c2FMNm5pelROUEFUTG9nV0kzU0NRN0pSWmFCSVU4Ykt1OUw0KzZ3NEo3?=
 =?utf-8?B?ZE5rdUp5ZjZld1Ewa3N2RHFvQURQdmpoZmNGU2VpSHZLenFZcUhKUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e45a7ac-43b2-4507-07b7-08da4d799285
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 20:16:17.2963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gWLXv3uHf7u72Ka57ec8eGMIoBnn1ED38oBiJ0E6M7yYoZa0hrUdH/NYDa13mrlrpkeX4Vg5qeDblo1ZBxXdpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2859
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/13/22 14:23, Jim Mattson wrote:
> On Mon, Jun 13, 2022 at 8:10 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> On 6/3/22 22:11, Jim Mattson wrote:
>>> On Thu, Jan 28, 2021 at 4:43 PM Babu Moger <babu.moger@amd.com> wrote:
>>>
>>>> This support also fixes an issue where a guest may sometimes see an
>>>> inconsistent value for the SPEC_CTRL MSR on processors that support
>>>> this feature. With the current SPEC_CTRL support, the first write to
>>>> SPEC_CTRL is intercepted and the virtualized version of the SPEC_CTRL
>>>> MSR is not updated. When the guest reads back the SPEC_CTRL MSR, it
>>>> will be 0x0, instead of the actual expected value. There isn’t a
>>>> security concern here, because the host SPEC_CTRL value is or’ed with
>>>> the Guest SPEC_CTRL value to generate the effective SPEC_CTRL value.
>>>> KVM writes with the guest's virtualized SPEC_CTRL value to SPEC_CTRL
>>>> MSR just before the VMRUN, so it will always have the actual value
>>>> even though it doesn’t appear that way in the guest. The guest will
>>>> only see the proper value for the SPEC_CTRL register if the guest was
>>>> to write to the SPEC_CTRL register again. With Virtual SPEC_CTRL
>>>> support, the save area spec_ctrl is properly saved and restored.
>>>> So, the guest will always see the proper value when it is read back.
>>>
>>> Note that there are actually two significant problems with the way the
>>> new feature interacts with the KVM code before this patch:
>>> 1) All bits set by the first non-zero write become sticky until the
>>> vCPU is reset (because svm->spec_ctrl is never modified after the
>>> first non-zero write).
>>
>> When X86_FEATURE_V_SPEC_CTRL is set, then svm->spec_ctrl isn't used.
> 
> Post-patch, yes. I'm talking about how this new hardware feature broke
> versions of KVM *before* this patch was submitted.

Ah, yes, I get it now. I wasn't picking up on the aspect of running older 
KVM versions on the newer hardware, sorry.

I understand what you're driving at, now. We do tell the hardware teams 
that add this type of feature that we need a VMCB enable bit, e.g. make it 
an opt in feature. I'll be sure to communicate that to them again so that 
this type of issue can be avoided in the future.

Thanks,
Tom

> 
