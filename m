Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A17D366D12
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 15:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242733AbhDUNod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 09:44:33 -0400
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:4769
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242759AbhDUNoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 09:44:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFv4ZAOmscIkQz8Ndtb5jJkpiQcNNkdW+q6BwviXifb5cDC7GlCTMBQzXVEjFm67hRfYJAucgv9HT+zTPPSqTXaPQXRxsvb1XVPXtU0Zcm71ApEXGnaILNuB50ZPzPG22t+0SGpL7kbiOZKmOEo+fDv8E3iMkXwjRJnIl8mTHwFkFaQFPPsJ7DytVRkAwMWeYBWCs/R4y0VxI1F3BOFTXgIhLGmPbBlnsE6Hw+oWoBLledXytTZKlhWCq0Rd5969h/9tIxvzs7We4rx6CCBqEtXbdR8Bi9dN5UdrjT6N8CAMNrEajGVEcTG058AqFTvUdbNIt5l4LRdbFLATwfiSlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJy6PBprzJALDqQ6yPg1AiC0FaKCkhf8msw9SM4tqtA=;
 b=IyEVKRkzVD2PTWB7Oct00/gzI7M8EnRszkr03gHgysp/S4SBgQFKNcCVPpow7FKzqQBuOV3FKRXJ8XA9+LXA5BvK38Jd8l3dtSKbBH6LoipK+Q7ieplqP/C/rwwc5PF34G27f1+Jz2IylJU4XmTpNtT9oIZqKoTXeseQHNc+pPJXr/7pvzUkNbvTVzMcHzaKlMzddzFesszW8KWsCHeEJft9JSm4H0jYYI0/R4/v+4l9RUWmwlxwc17Qz37Xi1dodCuXITc0a+kYiV+w0/4AWqcaXyVBizbqb2crRwRsOKPYhf3Wh4hoLYRPO5L+nEXnrgB+Q5i8m+M8FMvUpzSZdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJy6PBprzJALDqQ6yPg1AiC0FaKCkhf8msw9SM4tqtA=;
 b=bk9cG3bvA+TersLugacway7DV8ISDb1sIfil++zOkc69O4Ifn/i+9FnbkHL1SUlUx7rpl3GrZSQO9+icy5Ac5sN6IomGO7wf8BSGyuSZv1j7vk62QQ4K1sBDPDoekhpZiBaYzEHF6Q/47udKhjKx91su22aBOxz1c0Bn3H6/HHQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2829.namprd12.prod.outlook.com (2603:10b6:805:e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.21; Wed, 21 Apr
 2021 13:43:35 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 13:43:35 +0000
Cc:     brijesh.singh@amd.com, ak@linux.intel.com,
        herbert@gondor.apana.org.au, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part2 PATCH 07/30] mm: add support to split the large THP
 based on RMP violation
To:     Vlastimil Babka <vbabka@suse.cz>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-8-brijesh.singh@amd.com>
 <0edd1350-4865-dd71-5c14-3d57c784d62d@intel.com>
 <86c9d9db-a881-efa4-c937-12fc62ce97e8@amd.com>
 <f8bf7e26-26dc-e19a-007c-40b26e0a0a45@intel.com>
 <55445efd-dc29-3693-a189-710c8a61dec2@suse.cz>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <0a7a2ea4-6f07-61f8-fc02-c084734788ec@amd.com>
Date:   Wed, 21 Apr 2021 08:43:32 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <55445efd-dc29-3693-a189-710c8a61dec2@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [165.204.77.11]
X-ClientProxiedBy: SN4PR0201CA0026.namprd02.prod.outlook.com
 (2603:10b6:803:2e::12) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by SN4PR0201CA0026.namprd02.prod.outlook.com (2603:10b6:803:2e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Wed, 21 Apr 2021 13:43:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 080e289b-f733-4ea3-557b-08d904cb75c7
X-MS-TrafficTypeDiagnostic: SN6PR12MB2829:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB28297CDC5856AEF04F4376F6E5479@SN6PR12MB2829.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JUtNXERfTvJ0yx/U5/EtuPJYx0rqsNtT1dDQPQLKSh4l77fNgqJCNG0X6uclU0wkctri7AQ2gUU1uIPT6j6ZtKLdbtqfkeoCdTpaxXDnOjsaceCsMVQvbdHtNOW+KuJOPk5FpXopC8hD2Eewx3MBSLBAjZs7G1LhZHqempEDEcEMQemz2H92KCVd3MklAjy/szDBI1beoZbnI10YKfC/elkllT0SVeMKmDcHKdWCwICquFPYRHd0Gyqe/XUIf1o/12SbDgi58tpGBuKFCiMkDOdFDQYO1k2WwlUbBDsSpTmtCYc5zGexZh0vu6KVoXGQZQQJES9Tc1swhgnEDjeCewY90GJrFDS9oJz5Bo+Ye91lGmpDmMbQPZWR4S14JShNT8CnpydbQhMZGKf2dqQZmj0z7lnQeCuyhbAgr+1LKHfrH34uADSrMK/eEP6CNQgqoSFANFNr3/MiBgzLOArQkLfGeroq7WeK/FtygNVsTUwjo7AIUdV7XjlBgrD63oVmjpFBfoyxfZsTuQlVl7B2/9zGgepZgsZqy022uB7Tq4R2ce06K9YpPl31vXSKBO9VVMJuVAySWTTM7/WP5CuCbbD0iO7alTDRcUzhnDCGTNiwTHkKTWe9AF7wOVl1oDdstLu9X7mUMysuIOHofaA5zxpkwOJetGmr7E1vL0b0o7J8Xlb1qCfFXNo792igttsMtKcy4UMSwJMxvQUsi/+C8l+T4byyIDkrDJyyaWh2amZRnQPCiB+5AHwTf0lUFLdILaOfZduoFQKAav2v9RR4y2pk2zci03XJa8zuecPFPgilSjP2hJ6LmVVuFKD6qgGQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(39850400004)(136003)(376002)(44832011)(31686004)(2906002)(26005)(8676002)(5660300002)(45080400002)(8936002)(6512007)(2616005)(186003)(53546011)(66946007)(478600001)(83380400001)(16526019)(38350700002)(6506007)(31696002)(66556008)(6486002)(66476007)(966005)(52116002)(7416002)(36756003)(956004)(4326008)(54906003)(316002)(86362001)(110136005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ckFzTUs5SlRGd1J3NnZQa1Q1Y1VuR3E3L1lMNXBmZGlwSXg0L3IxYUNtNEla?=
 =?utf-8?B?WTlwSGlOQnVsRm9xdno5S0cxem5SOEtVWWxqVWFYQzZBT0h1WVA4WkNXeFNY?=
 =?utf-8?B?VUdTakVWcXoycWJBV0NYYTRvZERqYjdwY1ZNRTBqbi95QWpKUDV3ZnByY2xq?=
 =?utf-8?B?MXc2Z0lNSTZwUERjVlBFdUthckMwcDY3QVBCVGpDdktSVDYxaHlERDJsQW1z?=
 =?utf-8?B?M2xQakpWbFZLVHd3KzFvNVFtOFlvcVluYlM2L29VN2J1bnoxL01ra1M1VlEv?=
 =?utf-8?B?ZUhucTgrbktyQmUyQjVaNHNpdHJSQ3ZmczRhNDVSNUllanVKZnl1QmVsRGdv?=
 =?utf-8?B?Z2pxUGgrVm9xMi9VcHJIaHh6aTRKb1ZGYkxIYXF4cXhNR0p1U0orNEdIRmQ5?=
 =?utf-8?B?c1VQaTlUSzVGeDlxN2k3YWN1LzN0WU1qRmdUbzdzYWhCM0lqdG5CbXdiMTEv?=
 =?utf-8?B?Yms0THJiaW04YUhDKzgxMkJMK1ZKSUNtSVdBdDRkVnVmc1I5MjFsTEtjMllL?=
 =?utf-8?B?ZmtOSkZRNG5xZFV1ZHhiN3VsYkFQa2xPRDZYRUNiSkJBa1RZM0dXQ3g2MTRP?=
 =?utf-8?B?aUNEMWJTeGw5RkVEMkxLQmk2TmFXSWl1TTZZREwvSW40cHlXZkRZUzJic3JQ?=
 =?utf-8?B?Slp0YzNLZDJGUEhHeHRsTE1rRlpRb2lyYWJCTE9JellHaDRjSHdrdDcyQzIr?=
 =?utf-8?B?SEtSc1R1MnYyR3lOODBLbjBhWUE2b1V4REh4RVRTWUtvN3Byc1NDeUxzMklJ?=
 =?utf-8?B?Y3ZoRWVhMFo5S0FvNnk2RG1mNGtSZ3ZiQW9OSkVZZ3RpaUtjSExVTytLUGFh?=
 =?utf-8?B?VUhOSEpYcGJGQ1dRd0VqWktYQjBIOFlOdGcwVG9qeG5vNkxHK2lib3gxdFcy?=
 =?utf-8?B?ekMrdFU4cDcrdnJDdnNWczNaYWlQZHdZdFlhOEZMSGtxMkgyNGhmanpiQWVI?=
 =?utf-8?B?eW9PV2oxZXl5TUtwUUMvKzVtYWhFUUFmbVhOZ1NTVlBzdWg1K1FlcHZrV3pU?=
 =?utf-8?B?aUxjVE1wamxTcnZXQWpJTDBhaHJLemkyS3FvQjlBNUUyaWRScGRlQjRJZCti?=
 =?utf-8?B?dG5XUUVpTGRKYk5mOTBEUmw0dHVScFhORlhOYzRsamIwSmk2RVg2K0RDMGIw?=
 =?utf-8?B?ek5XRStYdUFtS0V2RG02ZjMreng2UUlTVXZrS3B4N3Q3MGFTenlCWE9ya2Vk?=
 =?utf-8?B?cEpjbFlsUVlOT2tGMk5Mc2poTituMUpMRDA0MEpXbTNnczdBd0dIQUJFT0NY?=
 =?utf-8?B?aUhxUE0vOEpVSTVMRXRiT2E5KzFwYUtXYVVKaHI1TXJ3eGN0QUtIQzZWa0xL?=
 =?utf-8?B?ZklkdldXRStNV2xZRm9TTWxXWlN5UktkbmJTZUNpUkhiTGN1eVM0NlN4cjBD?=
 =?utf-8?B?dWxldXd3TEVrMHkyMUs0KzVUR0VlaVFzNythdHBZUVQyT1VzOGhBUFQrMzMz?=
 =?utf-8?B?TWVIWWlqU1pDZ3ZNQks0MFByTHV0YjdsTnZJcStlNXkvbHNid3NMa0xHcmUw?=
 =?utf-8?B?NkJtWDY2QVphL3hsbWhXVTdPSWpMM1R1MlpDb05pYmhyazYzcUliczEya3JH?=
 =?utf-8?B?Q2kvcWlXM2VyOWhWZ05MNVNwaXA1eXJDTTdtTDZCQnFTTjE0YWcyYXQzbm9O?=
 =?utf-8?B?NXh6WGtSa25uQlV5QXVuS3B2MXJ1eXU5WUNwWWwxenZXcG9OaGI0WU1FSEpZ?=
 =?utf-8?B?ZTFVL0ZGcHFWOGd5SmV5ZDUxM1QvY2xOLy8yaElsQTFiZTlMcHlXMUJQcndR?=
 =?utf-8?Q?iYNMMF7wkFntoXY3D3vkfI1BXVYy3vcNkzSl5tc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 080e289b-f733-4ea3-557b-08d904cb75c7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 13:43:35.1605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zCshHIhWLiEOSTFhv7Nyu6QBXjxToEhONsiUt3chwXMjDn+ME6mMTryNUtlzssVL3qyDha3+Zif52Pl2eIT0ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2829
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/21/21 7:59 AM, Vlastimil Babka wrote:
> On 3/25/21 4:59 PM, Dave Hansen wrote:
>> On 3/25/21 8:24 AM, Brijesh Singh wrote:
>>> On 3/25/21 9:48 AM, Dave Hansen wrote:
>>>> On 3/24/21 10:04 AM, Brijesh Singh wrote:
>>>>> When SEV-SNP is enabled globally in the system, a write from the hypervisor
>>>>> can raise an RMP violation. We can resolve the RMP violation by splitting
>>>>> the virtual address to a lower page level.
>>>>>
>>>>> e.g
>>>>> - guest made a page shared in the RMP entry so that the hypervisor
>>>>>   can write to it.
>>>>> - the hypervisor has mapped the pfn as a large page. A write access
>>>>>   will cause an RMP violation if one of the pages within the 2MB region
>>>>>   is a guest private page.
>>>>>
>>>>> The above RMP violation can be resolved by simply splitting the large
>>>>> page.
>>>> What if the large page is provided by hugetlbfs?
>>> I was not able to find a method to split the large pages in the
>>> hugetlbfs. Unfortunately, at this time a VMM cannot use the backing
>>> memory from the hugetlbfs pool. An SEV-SNP aware VMM can use either
>>> transparent hugepage or small pages.
>> That's really, really nasty.  Especially since it might not be evident
>> until long after boot and the guest is killed.
> I'd assume a SNP-aware QEMU would be needed in the first place and thus this
> QEMU would know not to use hugetlbfs?


Yes, that is correct. Qemu patches will not launch SEV-SNP guest when
hugetlbfs is used. I can also look to add the check in kernel to ensure
that backing pages does not come from the hugetlbfs so that non-QEMU VMM
will also fail to create the SNP guest.

>
>> It's even nastier because hugetlbfs is actually a great fit for SEV-SNP
>> memory.  It's physically contiguous, so it would keep you from having to
> Maybe this could be solvable by remapping the hugetlbfs page with pte's when
> needed (a guest wants to share 4k out of 2MB with the host temporarily). But
> certainly never as flexibly as pte-mapped THP's as the complexity of that
> (refcounting tail pages etc) is significant.
>
>> fracture the direct map all the way down to 4k, it also can't be
>> reclaimed (just like all SEV memory).
> About that... the whitepaper I've seen [1] mentions support for swapping guest
> pages. I'd expect the same mechanism could be used for their migration -
> scattering 4kB unmovable SEV pages around would be terrible for fragmentation. I
> assume neither swap or migration support is part of the patchset(s) yet?


Yes, the patches does not support swapping guest pages yet. We want to
add the support incrementally. The swap/move can be implemented after we
have the base enabled in the kernel. Both the SEV and SNP firmware
provides PSP commands that can be used to swap the guest pages. I
believe KVM mmu notifier can use it during the page move.

>
>> I think the minimal thing you can do here is to fail to add memory to
>> the RMP in the first place if you can't split it.  That way, users will
>> at least fail to _start_ their VM versus dying randomly for no good reason.
>>
>> Even better would be to come up with a stronger contract between host
>> and guest.  I really don't think the host should be exposed to random
>> RMP faults on the direct map.  If the guest wants to share memory, then
>> it needs to tell the host and give the host an opportunity to move the
>> guest physical memory.  It might, for instance, sequester all the shared
>> pages in a single spot to minimize direct map fragmentation.
> Agreed, and the contract should be elaborated before going to implementation
> details (patches). Could a malicious guest violate such contract unilaterally? I
> guess not, because psmash is a hypervisor instruction? And if yes, the
> RMP-specific page fault handlers would be used just to kill such guest, not to
> fix things up during page fault.

The version 2 of GHCB specification defines a contract between the guest
and the host. When guest is ready to share a page with the host it
issues the page state change request to the hypervisor. Hypervisor is
responsible to add the page in the RMP table using the RMPUPDATE
instruction. The page state change request include an operation field.
The operation can be one of the following

1. Add page in RMP table (make guest page private)

2. Remove page from RMP table (make guest page shared)

3. Psmash - split the large RMP entry

4. Unmash - merge small RMP entry into large. The unmash operation
require the PSP assist.

The current RMP-specific fault handler checks if host is attempting to
write to a guest private page. If so, kill the guest. I guess it covers
the case where a malicious guest violates the contract to issue the
page-state-change.


>> I'll let the other x86 folks chime in on this, but I really think this
>> needs a different approach than what's being proposed.
> Not an x86 folk, but agreed :)
>
> [1]
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.amd.com%2Fsystem%2Ffiles%2FTechDocs%2FSEV-SNP-strengthening-vm-isolation-with-integrity-protection-and-more.pdf&amp;data=04%7C01%7Cbrijesh.singh%40amd.com%7C3a8c99a1738940b550af08d904c55938%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637546068243853651%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=x%2Bmtud8IxrykFCPAPgBu2CCAFO9Q26PA3OhryvlX%2BbM%3D&amp;reserved=0
