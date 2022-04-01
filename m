Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0F64EE6A9
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 05:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244510AbiDADZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 23:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244491AbiDADZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 23:25:00 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2050.outbound.protection.outlook.com [40.107.236.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2FE25E319;
        Thu, 31 Mar 2022 20:23:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BB4t7KwGnGPPk8dVxwariMYSxiJDrMwaBKN630WjhouXjikj30I30jYBPK6dNQMPQBHpE0HZnw0bS6UDnIkWnLIfF2888zxgTbUiWabzATs/4W72xAufm2k2PLPoeojteEMdMLWE5IpvfGkUxk80rn2VXJqyGOkhLpdiVsoKunv903xkboew+fUUF7xBpXonUt6r0rpEz7fikRLYrV6s4liYhJgvzLBjo0dozfCq4hiQpL6VARCCiqvrKBPAAYSIoSmDyC52oxykTY+vVQm7hbLzwPtY5pd3kuJSUj8G06HJvJbxJU6jz+kmzWjJqYTPlkv9RT/bt/wAOFFE73LK8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=59GENVU7vS5oaBhDsC1COBBv7nQibGH+2Ks6rgrCGVk=;
 b=cJLNzcm6qWbgM4E6RxbNW1bIilOq0UJ/Zv5HDMYUoLUwA6eGSEXzJgrWAjhYPVzeYdTrZ60t9k3RgZviy4zF8IXfADMrTh8wJELchM+3j1V/ZdYAUJalzzMEYYqmI8SjusaE8MzY1tTTuNV6QI3xQkfjeWmqeCAWinzfwl22FvL3i0bhnmg7pTCDY2sRZ0+LLqAoEtr9QBabuNZIBwTYgU9LThuCwDyS6vDxDtGMKUptL8qXGjZBpR2KROqPbfNO+M0GLm5pzOMf/3FoAeSdmVmoqVLjUqmfKm4fiMmzFQCCYGQSYeOV5U5X3F5luW3A82pt5nYoMQNlbNFxQfrvfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59GENVU7vS5oaBhDsC1COBBv7nQibGH+2Ks6rgrCGVk=;
 b=pWAVAyfPQQpkd5VNNuqqJvCpwrdDFah6aYuXCcQxuGcUskW0aifooYcNQ5HgXnW/qGp3EA6B+uTcCR5OUUufYBsCuAm1J5xy1ns4TJ+l4achVIgyQuuDUSYuzzHi+Gs2dj6pAliaBZbaU3vO6osl6vJJ1YmuuY2uJOIpDgnbB2A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) by
 MN2PR12MB3533.namprd12.prod.outlook.com (2603:10b6:208:107::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.21; Fri, 1 Apr
 2022 03:23:08 +0000
Received: from DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::8547:4b1f:9eea:e28b]) by DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::8547:4b1f:9eea:e28b%3]) with mapi id 15.20.5123.025; Fri, 1 Apr 2022
 03:23:08 +0000
Message-ID: <a1fe8fae-6587-e144-3442-93f64fa5263a@amd.com>
Date:   Fri, 1 Apr 2022 08:52:56 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH RFC v1 0/9] KVM: SVM: Defer page pinning for SEV guests
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Peter Gonda <pgonda@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Mingwei Zhang <mizhang@google.com>,
        David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220308043857.13652-1-nikunj@amd.com>
 <YkIh8zM7XfhsFN8L@google.com> <c4b33753-01d7-684e-23ac-1189bd217761@amd.com>
 <YkSz1R3YuFszcZrY@google.com> <5567f4ec-bbcf-4caf-16c1-3621b77a1779@amd.com>
 <CAMkAt6px4A0CyuZ8h7zKzTxQUrZMYEkDXbvZ=3v+kphRTRDjNA@mail.gmail.com>
 <YkX6aKymqZzD0bwb@google.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <YkX6aKymqZzD0bwb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0040.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:c::26) To DM5PR12MB2470.namprd12.prod.outlook.com
 (2603:10b6:4:b4::39)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14581d50-0e39-474e-d0cf-08da138ef153
X-MS-TrafficTypeDiagnostic: MN2PR12MB3533:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3533D44CDFEECDB652A8727DE2E09@MN2PR12MB3533.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v2/53bFSGX8lEQd4MKT03HnbvryomXJD/FOg9ApOk5S9Jib+QqUC89YPtYMIlANfsV9ejafvSoC2XoNe8ON7NzfUU7BQSNAECMvpAtCF2Z/EGkayGxFBD74QMasa4i6cG8NUWiNh9WHdPIkzmd9n75AQyDiiO/aaLe8Bx4TFSGQ/4DZe8x718GbDRvVqIU5asRBFNx88ELUJFlEvMsbhorZkrZLWZVMFdEdhVJJtVIG0RoeCIM7YEmq4DUDXeTNL+DzQr27tud6yDgcJG3vrJjfJOP0TF90Dq4b0CwdtuVdxis9kql8JfRJDkMalNpxmsqVgIjdO8VLPBufOkKjOijt1JEqNSMSUjrnaPXl/ctC/4LSmuLrxt+7EwkCgu1upGST6JhxkXb+BlP5ecQdBoaqQeBUmkiulZflP1rJAOwZSeK/q9KYFN7cpdrL8cik5QhXTZD8VMAWPLuhYyKNMkXEy39cAwl0AerOZ5NmHRx+qeXcqP3ELfy1+MIImLkKczf1mV1loL5z+kVsJ4j8SRAhRz+0DgzyukRJd+ywQ5qO33zbgjAGAIlDreiGxkcnySUxxBOPBhLC3EX2605amI9g6K/YIoB4BFLx18NqgoMx/ygrmH32AvgknyDtBtOyYYkDZGFkybhIzZN5SKe8ndgXdOGW+81yPuz0XnWitrYWErl+OukuuMd+SYXcoM8AAgHq8IazHMM/Td74Te17y0s+ye6X+2FJCKtOFdV1drLK7Uu31fQ5BYEtCcCSZkhGIhd0tTuGx4wD25pq+CXCkN9gdoxEj8Dtz8FW6DyXOMOyym5Y8ix63qj2WLoQbeOn+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2470.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(966005)(8936002)(2906002)(38100700002)(6666004)(66946007)(31686004)(66476007)(8676002)(66556008)(53546011)(4326008)(6506007)(2616005)(26005)(186003)(31696002)(316002)(6512007)(36756003)(110136005)(508600001)(54906003)(5660300002)(7416002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjFQQmJKSkNSdkJJUTlvNXJ4QWNlSHROV1o3eVZwVFl3VXhhOVphSkM4SXFw?=
 =?utf-8?B?c28vaG9EaHFVU1dERmhQRThFWFNIbExEYlUvdHVLZ1p2N1k0cHFicUdkWXcx?=
 =?utf-8?B?ZW52UllHRW1tSkZaejZvMnVIeXhQV3pQNXNTYVI5S0U4NXZUT3pXOHlSQ05N?=
 =?utf-8?B?QWdUbWVpRUNzRzRBL3B5YmhkRWRkYW94UHhWTElueWhJWDlRdGJoekNSUGpz?=
 =?utf-8?B?Mm9Bc2x2SHc0ZjdraGgvWXR0ZTg4cTVpOTZUMEltSFdXMTBKamRsd1ZUclgv?=
 =?utf-8?B?V2d2dTBqMjVJRFdVUVJJMnNvdlZqYyswZWVMNVllenJnbXFhU3c3TnRONzd3?=
 =?utf-8?B?ZGUwa2Q3NTQ0RVBEdmdXWGVkcW5FTEVETndlUFJ1OVBRNU5tcW1ibUMzNlZu?=
 =?utf-8?B?N25DRVJ0WHJqaUR5eCtZQjVPZFJQOXhjWitRUkVobDRQQmJMWG53RW0vMDJG?=
 =?utf-8?B?RGRlWldGeS9xQXVLa05IRUx1b3c4MWR6REVjSEFmRlUvUmxIVDFaK3owUFpB?=
 =?utf-8?B?Y1NraHRWb0dEbFl1TmxtbzZTUUpMZXRSRDdJOG01b3ZSVG5jcXpNbEM0YU5k?=
 =?utf-8?B?NmpVVi9TbmtNTVFrQ05sQm1NSXRLS1ZWOHc5bVFhMmF0MTg5K0dXSWY5Q0pW?=
 =?utf-8?B?aWRaMVZmd1VNY1lLS3VjdHYwT05QQTgxM3NETVMxZ2lEWW9YWW5LVXZZaUM2?=
 =?utf-8?B?ZTc2emUva3IxS1A3VU9qUkN5eU94d29KOXY0NG9PeFFkNE5CaGltKzRUR1Vk?=
 =?utf-8?B?ck4xd3NJN1ZaU05PZmxKcUpNNlQ4NHZXeC8wV1dOMFZiZWp0bTVIeWQxN0Yw?=
 =?utf-8?B?WFNvU0orL3dKZEMrd2pCaE5kcHppWjN1NUgrYXcrR1lqYXRWMDNrOXNzOVYr?=
 =?utf-8?B?VCtrOWp6RElmcWVGWEFvQmRNSjNJZ2RuRThGbGZlbU0rdzM1Q1d6T2J6cmZL?=
 =?utf-8?B?NmtySEFlV2FialdHMTc5NGQxYlp6UVRrbUd4a0xEelVXWW8xNCtwY2lPOTY5?=
 =?utf-8?B?aFN3TllyUHFQZjJCaG10UnE3a3k0aDF5NlhXeGRmZU9yY0xkamQ5VU9wS09z?=
 =?utf-8?B?QTVuQStWbG8vdnFlWXJJeXR5eGFjbWY2NjFCemZFTkJmT3FsZUNlRVYyeVJo?=
 =?utf-8?B?bElidnh5V2thaitWZnpuTG1DVnNlOXJGUmlNLzNWRjBBcWVuS0FIM0lEMzlE?=
 =?utf-8?B?cUFKemRtM0lOUjdTTDdxTC82V3pBc0p6QVgrSDNmRjFFSEhJNitWWk15SnNN?=
 =?utf-8?B?M2NCTWVlYzgydFJBMjdyYlY3cUo4YmMxSDlManlOcU9Hc1RNd2VTbzNwaEFD?=
 =?utf-8?B?Y1orVHNCVWRaZkpIenQ3QmFnWlZPRVVUWUJkNjYrcTdabDc0M3RNV2g1NG1j?=
 =?utf-8?B?a0pOZGt3dlJEMmEyODVhRk1UUk5pVHNHQThDVk9NcnAwL1NmRWpuNlVoNENB?=
 =?utf-8?B?a2p2SnlPTVBIQW9uYVN2YllxZVVLY0ZaSS96QmZCNEJxaFpPMDhOOFlMYWs4?=
 =?utf-8?B?N1kwb3I2RTB4Vm1pWURYM1NXRTFhcTlRSlVISjdMeFlUWUVNaSs3M29STFBH?=
 =?utf-8?B?OFh3ZDk1ZmNRKytvNTBDWnpUQXVoRWF6VHQrUEVwKzQycDhqa0wyWlRSaVVU?=
 =?utf-8?B?bHpmSVMxellYM2JadkV1N2daa1RQRlprYWZyUW5wc2FnamNVYkE3bGpMbWM0?=
 =?utf-8?B?VXR0ODhmeHFzRXJ1R2k0OVYzYUlORE1zTUZCRUFLYWgxdGFvOUpQQmZBYVlm?=
 =?utf-8?B?QkZ3MVB1MTFudkhQSXVyaXM0elFCTTk1MjlDNFBWVlFTTW1NcFlXc3NnTkxa?=
 =?utf-8?B?SmkvQko5OHJvQjdMZUxoWTlseVBsaUlnQUNkK1laMTQzT2d2Yk1tcE5rbWh3?=
 =?utf-8?B?RkhUeCtlMGkxemhFN1FENVVURkxwWS9mS3AvTjdwcmZSK2loWmozOUdQZHJG?=
 =?utf-8?B?ZWI1c0hDZm9FTHloTmY5T0phTHBHYVA4UWJiTE1KMjZCeDRkamFUZUFQcGp2?=
 =?utf-8?B?R01CYVhJb29YZW1McUZSaHZOK0pOUVpwbHVPMVIvYndNOWRZT2FHQm01MjdY?=
 =?utf-8?B?ZjVIVndFYlp6ZStaZDB2ak9MZHRPU2Q0eVo4MG5pVEpLODVkUmFwT3Z3dlF1?=
 =?utf-8?B?ODlOUldub1NPMHJ5VGVSTVN5N0hPdjQwa1c1VEd4bVRKR0xIekJGN0wwendi?=
 =?utf-8?B?S1Z4cm45NWdsSVRXQUZFeEMxZ2JRSUd4M2JrQ21qVlRiRGdOVkxXNTg1V1FX?=
 =?utf-8?B?Z0dlZkdFYk1EbzlDbTZxNzJMbkQ3Y29VUHlCaWlsMHRXUlpwK3JZbUtvVHRx?=
 =?utf-8?B?K0lUVXRkVmVKLy9ZR29Yd0p0NHRpdy9SMjFCTkQreWFGV3d3Nzlkdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14581d50-0e39-474e-d0cf-08da138ef153
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2470.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 03:23:08.6119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hGKsQfqby5s+fDxvbd1P/ynd52xZUPGcKc1GUDVnbhVupWcg1kEHv8HHhAXHkQ9FEJcn9ImC+NcCXc7iUVzsbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3533
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/1/2022 12:30 AM, Sean Christopherson wrote:
> On Thu, Mar 31, 2022, Peter Gonda wrote:
>> On Wed, Mar 30, 2022 at 10:48 PM Nikunj A. Dadhania <nikunj@amd.com> wrote:
>>> On 3/31/2022 1:17 AM, Sean Christopherson wrote:
>>>> On Wed, Mar 30, 2022, Nikunj A. Dadhania wrote:
>>>>> On 3/29/2022 2:30 AM, Sean Christopherson wrote:
>>>>>> Let me preface this by saying I generally like the idea and especially the
>>>>>> performance, but...
>>>>>>
>>>>>> I think we should abandon this approach in favor of committing all our resources
>>>>>> to fd-based private memory[*], which (if done right) will provide on-demand pinning
>>>>>> for "free".
>>>>>
>>>>> I will give this a try for SEV, was on my todo list.
>>>>>
>>>>>> I would much rather get that support merged sooner than later, and use
>>>>>> it as a carrot for legacy SEV to get users to move over to its new APIs, with a long
>>>>>> term goal of deprecating and disallowing SEV/SEV-ES guests without fd-based private
>>>>>> memory.
>>>>>
>>>>>> That would require guest kernel support to communicate private vs. shared,
>>>>>
>>>>> Could you explain this in more detail? This is required for punching hole for shared pages?
>>>>
>>>> Unlike SEV-SNP, which enumerates private vs. shared in the error code, SEV and SEV-ES
>>>> don't provide private vs. shared information to the host (KVM) on page fault.  And
>>>> it's even more fundamental then that, as SEV/SEV-ES won't even fault if the guest
>>>> accesses the "wrong" GPA variant, they'll silent consume/corrupt data.
>>>>
>>>> That means KVM can't support implicit conversions for SEV/SEV-ES, and so an explicit
>>>> hypercall is mandatory.  SEV doesn't even have a vendor-agnostic guest/host paravirt
>>>> ABI, and IIRC SEV-ES doesn't provide a conversion/map hypercall in the GHCB spec, so
>>>> running a SEV/SEV-ES guest under UPM would require the guest firmware+kernel to be
>>>> properly enlightened beyond what is required architecturally.
>>>>
>>>
>>> So with guest supporting KVM_FEATURE_HC_MAP_GPA_RANGE and host (KVM) supporting
>>> KVM_HC_MAP_GPA_RANGE hypercall, SEV/SEV-ES guest should communicate private/shared
>>> pages to the hypervisor, this information can be used to mark page shared/private.
>>
>> One concern here may be that the VMM doesn't know which guests have
>> KVM_FEATURE_HC_MAP_GPA_RANGE support and which don't. Only once the
>> guest boots does the guest tell KVM that it supports
>> KVM_FEATURE_HC_MAP_GPA_RANGE. If the guest doesn't we need to pin all
>> the memory before we run the guest to be safe to be safe.
> 
> Yep, that's a big reason why I view purging the existing SEV memory management as
> a long term goal.  The other being that userspace obviously needs to be updated to
> support UPM[*].   I suspect the only feasible way to enable this for SEV/SEV-ES
> would be to restrict it to new VM types that have a disclaimer regarding additional
> requirements.

For SEV/SEV-ES could we base demand pinning on my first RFC[*]. Those patches does not touch 
the core KVM flow. Moreover, it does not expect any guest/firmware changes.

[*] https://lore.kernel.org/kvm/20220118110621.62462-1-nikunj@amd.com/
