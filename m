Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF73E496399
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 18:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378835AbiAUROS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 12:14:18 -0500
Received: from mail-bn1nam07on2046.outbound.protection.outlook.com ([40.107.212.46]:24699
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231567AbiAUROR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 12:14:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQv0PsjU4w9MEwrY4Da4el8UrFepL/YktwBdIKbz+LmEJxyTJrnZFXNebv1yrvh1v3TCma+Kn56LLljyez77qNbcn3s0EQJGxZGY+cFceYNmLnhsxKQ95MwJ3mXzTlEu8kid7vGyGzX9VzbxysVJ2WR65DHsvsquQ2Q7GnShQ1kBQ86oRHD0uWT/2AbuKEEhkSO170uCsEAWTxjk1qe1JNuwEsGxXQnQJ3rGcwQMQci6PLL0anIfCRhrhUaaWyP1GzFqSaNC02g4LLL2EtyxlBZIRT8ceOJEmfiDCgfC+v035LPc+nz7/UnkU0QCbXvhWxeBMheyJyPd1qRq3opggg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8wynW7sCUe7/Ggs+t9f5YntYbce8yRZjJase/jHdAT0=;
 b=B8y1JHJh9/S20etnDdA60rwumUN8wkKoY5V7SbaYhQ+E1cX+E1rHpB4EIGFqGYdV5VJ+mU5oz7RW0C3KTZGRz/z5uFtmPoVd6X+w69CNIAIeYuLehSTnlYyijoA6RCbwNjrXtIizmSYis9eqoS6SiWA6whhX658dWuVWOZZBFoGZcdSQvQNKoTOPvWu8MHOHsirsKpwS/Xy3j/eKPTAiobLpU/1Xdk2DFsSznIAJhkw8rQZlE7TMwBmS7Rgy6x2F191M8NEiw6RXKWGos9/cQpgwuDWRKGA6Emb+nDV8Y6EGFi12usrI/P4uQN4PHLibEn4aBo2Cu2aSj/aVzLJ8iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8wynW7sCUe7/Ggs+t9f5YntYbce8yRZjJase/jHdAT0=;
 b=NmnCXyP86RJj89Qb8H8wJNZsjaYiVrn3AfUWOnR9LqSqDxzyCFE3QCJ3iqRy3+aNJOY2+4wT3hjw7C6Bcn1s0dtXe8+dbvuJV85C+BFg2f3QmrNHFvnTYWJTBq27uOBOeur0KKfkMdw1Xgsx/pe3HI3m8+DI9uiuWKB6IuNrNdQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) by
 DM5PR12MB1803.namprd12.prod.outlook.com (2603:10b6:3:10d::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.10; Fri, 21 Jan 2022 17:14:15 +0000
Received: from DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::f110:6f08:2156:15dc]) by DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::f110:6f08:2156:15dc%7]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 17:14:15 +0000
Message-ID: <33da2a09-603e-dca9-7f93-a481fe6cbccf@amd.com>
Date:   Fri, 21 Jan 2022 22:44:05 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@amd.com>
Subject: Re: [RFC PATCH 6/6] KVM: SVM: Pin SEV pages in MMU during
 sev_launch_update_data()
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
References: <20220118110621.62462-1-nikunj@amd.com>
 <20220118110621.62462-7-nikunj@amd.com>
 <CAMkAt6p1-82LTRNB3pkPRwYh=wGpreUN=jcUeBj_dZt8ss9w0Q@mail.gmail.com>
 <4e68ae1c-e0ed-2620-fbd1-0f0f7eb28c4f@amd.com>
 <CAMkAt6pnk8apG4VAdM3NRUokBH32pZx-VOrnhzq+7qJu+ubJ3A@mail.gmail.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <CAMkAt6pnk8apG4VAdM3NRUokBH32pZx-VOrnhzq+7qJu+ubJ3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0162.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::17) To DM5PR12MB2470.namprd12.prod.outlook.com
 (2603:10b6:4:b4::39)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e753017d-ea7d-4660-8dc1-08d9dd017326
X-MS-TrafficTypeDiagnostic: DM5PR12MB1803:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB18033E66299C2B7838F73781E25B9@DM5PR12MB1803.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6bUAUKxkdEMqHv4pNz5gQbvPgzUCVb7IWYJdSsbDBfB5SNpotLxNQZiV4a7Ht6JdrWlY8QRKYywp8CiwKJxDC9emToIfLC+ropSVX11D6j2hv9M4+FRHGdr1HwFvxRkxlTY1qAZPAaiz4w2aZw4ivsignj/VflHOIXZjPu8Fo9AljysMopgyrPgrMrEBJRdRC2IfLwtAy6/L/HCID2EWB1uRRb9x84OIRp+KG7Y3SxoF+4JJntCw/EQIhSlA93zB31yRRn0WEAdGVo+zmRwGMw0qUByhC42BXsWC/qdFn0+7g4NaKZZ9Jr9fSZNwvloOHF6sYn0oEObWoAm+y5S8JJtYvPlZmLbiHJURTpPoSpTci0lmpBxjkO9Q3p65pqMgaj9oB0S779/CsY/VwkRiQsf5e+dduqZrHI7iuQ3QDj7iTI6P2l10h1r1TS+uemVaaOt1q0AnKeu+zDkdftFsMz/Ivm20YI53sRVcxwHJnYqXjPpoLxAtXaYFTA64tVaqzD36TVQE3vd/0tLeEl0116C2TJ0xtydmobXsl2AibS9UdjX+QnhUfkvhh1DAXxTl1bCml+4ST6Y61beA4rJn/86Ti5c+o4DmiE1OQfJkPOfBhmLotQxRI1Q/OdJVY29nRDjFZzTwc+XsRKgNBypB4OPlbhmcjIpwvh+2MuE3sjQaFdo/zgmaY5XglrcBfS37lksW1V9rUJruswq+gqdZGpOe2OkiSm86GxL5CRDiNBw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2470.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(2906002)(4326008)(6666004)(66556008)(66476007)(53546011)(66946007)(8936002)(6512007)(38100700002)(6486002)(6916009)(6506007)(26005)(186003)(31686004)(2616005)(8676002)(54906003)(5660300002)(316002)(508600001)(31696002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UkVXT1d1bnh4Ui9pVkFNVG9MeU1iMVExZStKbXpkcC9BelB1S1pnVGJvdTZT?=
 =?utf-8?B?d1FObC9CYnpOckpLTnJnS2h5Um4ycXovWW9KU2hhVW9MUlVtbVgrQ3Z1NzVz?=
 =?utf-8?B?QWFqdEhXakYzNldIRzVkbmNxVHRXTDBKM3dvVTF1WTk0bm1DQ2NoQTloTjFm?=
 =?utf-8?B?QUJtQWFQU0QwYWhQVlViNnlCZHg0cTNkUlYvS2dwMGt0K1RFVkRKL3J1dlAy?=
 =?utf-8?B?eVF6enZld2lLVjllNjJaaXJIS3VHaWY1WE1QU1JJTGIwWWxJZzE4UUsvRFhE?=
 =?utf-8?B?YXM2dUFaajFJYTNxZ2d1TVJyOWtYUDhncXdidUxBRXh0c0tBc29QUWNGMXhH?=
 =?utf-8?B?c240clhDdlkwaTcwT2QyZVI2Ky90bkpySGNOTzIzdEFMMzc4bHFxTE1hTmE5?=
 =?utf-8?B?eVh0NWphZlloMi96c1UvUjYzdkpPYzg1T1NybTZiRld5TlVnK1FZaVltNmsw?=
 =?utf-8?B?UmxMdDY0aGt0b1g2WFBuUkRDb2Ewdlg4M2YzS0ExWHRNdGYxMFpXNFlmY2Qw?=
 =?utf-8?B?cW1OVUZkRHEvNFBUTUNuMmd4SEpia0RScllEUlNQSnYwekQyZnZGNVR4MFpR?=
 =?utf-8?B?NWNzWTZoQ3FNcnZpcG5LNW9zYTgxL1YwVnl6bHVCRk9SOFV2MFRYeUpQUHAv?=
 =?utf-8?B?aGpxVHdKdU9NYVB2QkZxM1g0N0o4VnZSSXNDQkRPSFVpaDhRekZ4VTNRcDBz?=
 =?utf-8?B?aU9ZQkwyeUQ0bkdJc1pUWWkwODhhNWc5b0tOTTF4ZjR5UHNqdTRaRURvZ0pu?=
 =?utf-8?B?dzB2L3ExeGFIYUM3QityUFVTd3JrVVFTdVppZGYrYnp4R2pPMk5FRFRBZUhk?=
 =?utf-8?B?YkI2VlhtRjdVQXN1QkVuZjJyNmtiSEJQOUtnRWZjQmpVL1UyQkxMY0FHUW1T?=
 =?utf-8?B?OU1XZlVzSTV5RkovK0xkaGpXTzJzWkU5VWF3cUw1SUZZajh3aC9NNVZYWDVH?=
 =?utf-8?B?Nzc2b2xyUFA3cXdrTXlMeGNnTFBwR3JNRE4wOHNtM0xtU251Mm8vVUY5Z3VF?=
 =?utf-8?B?QWcrVTJ5aTkxMS9NNVdXNFl2RElROEZQdjRRWDZFOXFoZDhkUHNOcnVvNlVi?=
 =?utf-8?B?S1l3VFdMUWVHY253UktrTlZ0NTFuUGJIQlNOM0hDd0JEMWRNWUlxOUFsVnMr?=
 =?utf-8?B?bnJKV1BaODYzK3dSZGZDTXkrVStlS2FBQ1hZalRabW5TWThnQTFESFZMa3la?=
 =?utf-8?B?NmhTY2JBYWh2Zkt4VDRIam9vaWpHTVhnZVdkd21vV0Z4ZVRKNG9LcGV6bUJy?=
 =?utf-8?B?akFpU0I5Tmw0VUZuRERvSEIxMDhQSVFkWDMwS0VtWVdzNGw1a1FKOE9hOFhn?=
 =?utf-8?B?U0VzckZ1cjdVbkZvalJzekgxNnVBU01QVkhwbFdOUlQzLzc3Rk5rOVFqcFcx?=
 =?utf-8?B?K0hpVXo2b3RYR0lLSnBHeUxQTWhVVkNRVmRvT3luUGp4MUhxZ2t5d1NaSGRZ?=
 =?utf-8?B?eEh6TUhHRGVCSzBkcTVPRXBjRTFkL1o5a1JKSWNxdU0yTVVvZVd2ZURDUmFy?=
 =?utf-8?B?YjNja2FYUHhtR1ZIaGM0dmJ3MXZ6bkxMd1E4S09HWHV6NXVSUmExdjdVMVUr?=
 =?utf-8?B?cDVqTUtFTXlOQXBUSThzVEFoNW5nMFVla3VsYmZ2elRxaGtKQTNOUmhNVFRi?=
 =?utf-8?B?QWkvYlNTMUpqUlFLQzNQOEFoTms5QVh6Yi9BTjFGUVJzcVlzczRKNDhHbmV3?=
 =?utf-8?B?VTFtTXRpdXJieXJXU2NVYUJ5VVByVzJ6RlVqcHpLSVpMamRmcUFHVUJTazl5?=
 =?utf-8?B?a0JXL0RuL3lkMUdyYmt0eUlIcXBRN0IvNXNHc2ZGMlZjV3RaTkdaV3B3S3I0?=
 =?utf-8?B?WnM1ZmE3enZWRlhhL01DOFY5OUpJeWhkTDhKTWRSWFo5M1cwclhNNisrNXZU?=
 =?utf-8?B?dzkxL0oreURIUklISTlLZG5jYVRSTEhIYytjK0d1UUlzZ3p6djdlOFRhMWh1?=
 =?utf-8?B?b2tLUnQzOGwyQVN2SVRNUXlhWDMxUXpzRmtXY2NDREpKNS9xUVl6Mm5SRlN4?=
 =?utf-8?B?VzVWdi9VcDNQZGV6UUFZdktuNVByeVV1TWxIRzFtYkhtS29tdDZQQk9sUmZD?=
 =?utf-8?B?WTZwbXN6OHBCbFZhSDBmZzFXNm1PTVJDUGpObFIrMllOak5BbVV0ZUtTTU00?=
 =?utf-8?B?MXpvOXpucWo2b1JiTXpBTWJKZ1pqUnNpWU9kd1lYNytiWUZkckVEc3pQbXd4?=
 =?utf-8?Q?QIfIzNECs6dxA0SieMtC5uY=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e753017d-ea7d-4660-8dc1-08d9dd017326
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2470.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 17:14:15.1247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mOuwD/nMQ2lPR3f+EKy7Dhw3Ihqv0OTzYYBXgrrOKw/ruJGo26Ug6w8yE5IxRQeqrPA1ZXq22tbWUTea6uNhEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1803
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/21/2022 9:30 PM, Peter Gonda wrote:
> On Thu, Jan 20, 2022 at 9:08 PM Nikunj A. Dadhania <nikunj@amd.com> wrote:
>>
>> On 1/20/2022 9:47 PM, Peter Gonda wrote:
>>> On Tue, Jan 18, 2022 at 4:07 AM Nikunj A Dadhania <nikunj@amd.com> wrote:

>>>>  static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>>  {
>>>>         unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
>>>> @@ -510,15 +615,21 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>>         vaddr_end = vaddr + size;
>>>>
>>>>         /* Lock the user memory. */
>>>> -       inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
>>>> +       if (atomic_read(&kvm->online_vcpus))
>>>> +               inpages = sev_pin_memory_in_mmu(kvm, vaddr, size, &npages);
>>>
>>> IIUC we can only use the sev_pin_memory_in_mmu() when there is an
>>> online vCPU because that means the MMU has been setup enough to use?
>>> Can we add a variable and a comment to help explain that?
>>>
>>> bool mmu_usable = atomic_read(&kvm->online_vcpus) > 0;
>>
>> Sure, will add comment and the variable.
>>
>>>
>>>> +       else
>>>> +               inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
>>>
>>> So I am confused about this case. Since svm_register_enc_region() is
>>> now a NOOP how can a user ensure that memory remains pinned from
>>> sev_launch_update_data() to when the memory would be demand pinned?
>>>
>>> Before users could svm_register_enc_region() which pins the region,
>>> then sev_launch_update_data(), then the VM could run an the data from
>>> sev_launch_update_data() would have never moved. I don't think that
>>> same guarantee is held here?
>>
>> Yes, you are right. One way is to error out of this call if MMU is not setup.
>> Other one would require us to maintain all list of pinned memory via sev_pin_memory()
>> and unpin them in the destroy path.
> 
> Got it. So we'll probably still need regions_list to track those
> pinned regions and free them on destruction.
>
Yes, I will have to bring that structure back.
 
> Also similar changes are probably needed in sev_receive_update_data()?

Right, there are multiple locations where sev_pin_memory() is used, I will go through each 
case and make changes. Alternatively, add to the region_list in sev_pin_memory() and free in 
destruction.

Regards
Nikunj
