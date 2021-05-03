Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B2837186D
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 17:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhECPug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 11:50:36 -0400
Received: from mail-bn8nam11on2083.outbound.protection.outlook.com ([40.107.236.83]:58048
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230236AbhECPue (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 11:50:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f6TBYYf0Gv9HjVfSX4ByayLIzgekrV3ZhBSBCEZj6gkxQpmNUXArFu1siUnsfYGXgnWuMAl7GNbUpQ2YMbM4ADMebJ5CpmW2544rdTVNyP8kTozKbqDQ++O9953QlDEX8qrTDHXM3u3NMudaYZxC3vVsJKzu8VnX0Ogi8QTka8BlhVMElD/PVlu0Xu32jliGeN4XrXrOStvseZK//oc5SlfarJDUorCT5Ed7dHGvrplLw0vLwptazAXxNL+Oj6+QDGv8AJU72+YEDc2z/eALEKv7oDvkYSmVN0z2NuXleJiH1kKhgMY/O0zE44tMd0Xc2r0jqAwiuo4KJ/uir/cGrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypfhZ+9UCPFWtJuhWc1IhuUdlzVd3yActK96Pdg+H3w=;
 b=hXOrlKTYfKI4VdWpXXdUm/SnXY5oRnYFhqac/Qat+kuGUksSn+yHoDPLbS/6HdSyiMlKzLOn0cLzgPOuK7R0GMIBlKE/z+tw5PZRaiCAonDDGvzAj/D/HqcdRMCvVQG2CXU3LAoD7RbGJo76zCG38hf6AByrd9YQiY+erxtooCldAVleDfLWDgYOmv5tVFYimrTE4NVZY2iAwZ3J0urxApdPW0Mtn9R/Cg3TmzHIRf53D7X/di0zhdf2klwMBPhgBorjkSD3izNlZ+iqq+B7lG76MdMSUdvgFLt3+0/3+mA0404vYp3xgP9TuFSPIZUPEIjeub/z3yeIw333Zy9hng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypfhZ+9UCPFWtJuhWc1IhuUdlzVd3yActK96Pdg+H3w=;
 b=xUcmdDINIvubJyjw8aEzWj8+YM35Lxu+zI98BK2ilT1DwrM8Ef1cn2iUVJcKbSBe056aroZefsdF0gZggfz9BjyQ/394Ion0I98FjVofFJhoMIiwnc7SRGL6RzUYZ9lYVe5XBrtXHc8mXTzeKWRu2FtjW8nbNynLbV/GV7oLLAQ=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2511.namprd12.prod.outlook.com (2603:10b6:802:23::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.38; Mon, 3 May
 2021 15:49:39 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4087.044; Mon, 3 May 2021
 15:49:39 +0000
Cc:     brijesh.singh@amd.com, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH Part2 RFC v2 10/37] x86/fault: Add support to handle the
 RMP fault for kernel address
To:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
 <20210430123822.13825-11-brijesh.singh@amd.com>
 <c3950468-af35-a46d-2d50-238245ed37b3@intel.com>
 <CALCETrVEyBaG41gS4ntu6ikJqeiWs2gMuqfo_Yk0cdgpHyN9Dg@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <4abe9ed9-a296-7b27-6b81-288185394ff6@amd.com>
Date:   Mon, 3 May 2021 10:49:37 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <CALCETrVEyBaG41gS4ntu6ikJqeiWs2gMuqfo_Yk0cdgpHyN9Dg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN6PR2101CA0001.namprd21.prod.outlook.com
 (2603:10b6:805:106::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN6PR2101CA0001.namprd21.prod.outlook.com (2603:10b6:805:106::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.1 via Frontend Transport; Mon, 3 May 2021 15:49:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfdc3f74-e633-4e4f-39ac-08d90e4b0f46
X-MS-TrafficTypeDiagnostic: SN1PR12MB2511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25110A21E6480CD2AE73189AE55B9@SN1PR12MB2511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TEp7Jd7lNmpOv71vge4IwJhZRs2L7++FkUzDjnex9pwVs4+gltz9uxXh0cc4zwtzAErmxz9Dnv5QBJ/kTTvuyKqWw3AWeylYOrNsIMI5i3pgGxW1DE4kTVsYF0dRTbsNvgcBW17uXkzEyptHz1q/RM7a7YhLVFBpvddUk6DZg/8Yd+q0wIs1McoH3I4dkT4XIilG3MiaMwMUfR4b4D4/vC++dPeaQZoTCd5amprB2GSEicvmM6ntb1wWEhXtcD1sWqg1A74lxGlmK8G5Oz2lRweJVadG4MNJQEeJBWBpgbRfwRIRIdAI73Xcb5XjGFsnFagf+guST4CeeKtAuQiMnjFTBUxmnSbi6wUdT8dXvhGymeTWP/QF5X9mrZ3QVd1bmBJvSZ0qZL2h4feKOg9kTCzaQYbzyMHrcUaxOF8D0w8jpeFtbmsV0e2pccwhrQrnp09zbWeVWExQdAeSF4IRBiSSSk67dWGxf05Vzqlx+b7lnS2NIW46xvsHm6E+mi45CyF7Ej949sclEAWAO/wzEkeO9RXNzPZevfH69YrTYq1w1m0wlVsgiw0Zpqnb75CkFulCdV8d4Zro/YmtGOXDCf3BJNsf2qd2U12G8MhRv2iAW44Jot8yC+boIqMzV7anKBe1TKnniKjHHauoL6qsoZKpzTg/Pe2zuqsTxw+P7S1+60ciFMh301SqX0Uh3KOMDPs6BEI83QcdB+qlaVUCbx0CnoK+l8pqAlKpmN/vt+o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(136003)(396003)(346002)(376002)(4326008)(83380400001)(110136005)(31696002)(6486002)(66946007)(54906003)(16526019)(52116002)(66556008)(2906002)(7416002)(66476007)(186003)(478600001)(8676002)(5660300002)(956004)(316002)(26005)(53546011)(31686004)(6512007)(6506007)(36756003)(38100700002)(38350700002)(2616005)(8936002)(86362001)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cXJ2cjhBQXJBVk94d3grU2hydk5xWG1mSWJkbkwxakJ5MkZncE1QTVh6dGQ2?=
 =?utf-8?B?VFN6TUN3VmZ1THRpNW1NcVdrZ3ZpcDdhbU1xZHEwbnJ2bGUzOEhJU1VtQ1h6?=
 =?utf-8?B?MDZuNlYvemRKZEg4TmFEZWxKdlBFS3JpSTNnSnpNWTdCTGlWbFQ2WkZXYnBo?=
 =?utf-8?B?RG1xektWUUxpd0lmNnVOaDQ5b0xCYzRtMlFOcEdibFI4NGYvUGxILzd5Y0N1?=
 =?utf-8?B?NXZHd1ZRYzNsdEtrNTlLUE5zU1RmT0syckVkOVg5TjRKckUvNVV2OWZIeGVB?=
 =?utf-8?B?MkQ3dkhLMVNlMVF4a3JRbjZLbG9TRmNvZkFMSkhvNEs0M1UyUUcyNnREWm5Z?=
 =?utf-8?B?QTJSd2hlU2QwTHdoSldYcktHdnRCelA3NXpEUlNRTmd2eXdKSlAwWU1yN0hF?=
 =?utf-8?B?Ri9PeHNWdnRsVXZMZHlhblRwR3Y3WWFUdURsMTR4RmpuLzNEekxlUEhoTXpF?=
 =?utf-8?B?blFhZlhCNU55NHIyUk00YmdNbmlBeFUwMUF5M2JBNm9aUlJJM1B3M0lqYjlP?=
 =?utf-8?B?VnhvYTUzU3hzZnVUK2ZjaVArQkM0ZkR3aVBzT1U4SkpZOG5td2pVQXNWN2o0?=
 =?utf-8?B?b3ozMVBkZ2tEemk0TVBIYXdqak94NnpVQ1FZbFd2Z1N0c3Ywb3hqdG9DRHUx?=
 =?utf-8?B?ZXZiOTlwRElrR0IzU2t0MnVtSVNUR0xNT2hEcy9TNGVTVnU4M0w3dDVad1Uv?=
 =?utf-8?B?Ri9XTlpsTkZVRG5CaFlTWExnaHFLNUliZEY3STg4bERoRmxJYW9Hb1VFbWpp?=
 =?utf-8?B?djZRMUdocnY2NXg2TzNsT1RLTVZmeHd3T1Q5dzlVZkxPZkJ3TGIrVzdOVWp3?=
 =?utf-8?B?TnhTWjVXdTgvdnR4V0RQdjRFbFgyQzJFd1NKV2wzd1JSb3RiMnBNQmZyVGFs?=
 =?utf-8?B?YnRod01uUE9sR0JDQXQrM1prQnoxemtGMU8yd29TTEdJNld3dnFDVXhRaFg3?=
 =?utf-8?B?TW90OHF1WThWSTFSaVNvN3BDOGVmVHhPNXNOcjR6VERYUXhZSy90YUFYYkdw?=
 =?utf-8?B?WmZTQmpNVG4wcHBxNkZHZitnNVJHcG5LYnJPenFEWkYzUnYyTWZESDQrZjk0?=
 =?utf-8?B?NkpXYmxCOXIwYTRUT1A4cmNtM1VCOXBwT09JYzlYRi8wVGJUWEl3VUZUTHJw?=
 =?utf-8?B?N3pjdGUralYrRk85VlNrZ2NuV3pqTTRXNHhZeTNhK2VqNmtpSXJndTdoWWFZ?=
 =?utf-8?B?eWkydU5RWmppeUxYMFJPa0lCdS9jeU1iazBsc3B4dmp2RVRORGtOeXFCcmpU?=
 =?utf-8?B?T2VScERMTlhSUU02RG1nQnZUK0RvK3BrdGVtZlNwdTIvdEdmVnlNT0VoVWtQ?=
 =?utf-8?B?UHBZRG5ZK3N5NDRSSWJIRjdWREtRQVA1bU1vcDZZOW1iNlZCV3hvQnF6dU95?=
 =?utf-8?B?UlI0MWhHR2Z6ZXZzUUNnOGloNGFWUkcwTlFlVmp5Q0tRTWpMT01UZ0FLRXZ6?=
 =?utf-8?B?LzRpa3dCTlZ0citHNzQ0WkR2UnZpR3Z1Wkt6ZzJHQUVEaUk1a3QwdTFCamhx?=
 =?utf-8?B?QmQ2RkJPV2NzR3VJQ0tBeUhqSklKenR0aENheG9WL01TRXhKWTJiajBpZk9W?=
 =?utf-8?B?dW5SdGlJVlEwckZqWHN5cERnYTdLMEJxc20wRzdHcUMvaTh3RHJOUmo3ZmRU?=
 =?utf-8?B?dDZRWTVPTGQ1R29XY2g0Z2UrWG9tMWxzaE9VQXYxYTJXMUxRN0VVOFg0TWJK?=
 =?utf-8?B?bk9Jd3N1Vy9pZG0xMzhwcXBseUc2dWNzSllkbzdFWm93VXlWUVVIQ2k4SnVR?=
 =?utf-8?Q?aDE38kr4+SXMkY/xpf+b53agufi/dJJkBg/6Mkq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfdc3f74-e633-4e4f-39ac-08d90e4b0f46
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2021 15:49:39.2101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R1B3o+c5MOk2Xzh1n/RAYbq1rId6L9Onhfd4ereaF71mB61OTNYaZnmILIlc4vRZ3Mn2eJIFrdLDyQlnVuu1Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/3/21 10:03 AM, Andy Lutomirski wrote:
> On Mon, May 3, 2021 at 7:44 AM Dave Hansen <dave.hansen@intel.com> wrote:
>> On 4/30/21 5:37 AM, Brijesh Singh wrote:
>>> When SEV-SNP is enabled globally, a write from the host goes through the
>>> RMP check. When the host writes to pages, hardware checks the following
>>> conditions at the end of page walk:
>>>
>>> 1. Assigned bit in the RMP table is zero (i.e page is shared).
>>> 2. If the page table entry that gives the sPA indicates that the target
>>>    page size is a large page, then all RMP entries for the 4KB
>>>    constituting pages of the target must have the assigned bit 0.
>>> 3. Immutable bit in the RMP table is not zero.
>>>
>>> The hardware will raise page fault if one of the above conditions is not
>>> met. A host should not encounter the RMP fault in normal execution, but
>>> a malicious guest could trick the hypervisor into it. e.g., a guest does
>>> not make the GHCB page shared, on #VMGEXIT, the hypervisor will attempt
>>> to write to GHCB page.
>> Is that the only case which is left?  If so, why don't you simply split
>> the direct map for GHCB pages before giving them to the guest?  Or, map
>> them with vmap() so that the mapping is always 4k?
> If I read Brijesh's message right, this isn't about 4k.  It's about
> the guest violating host expectations about the page type.
>
> I need to go and do a full read of all the relevant specs, but I think
> there's an analogous situation in TDX: if the host touches guest
> private memory, the TDX hardware will get extremely angry (more so
> than AMD hardware).  And, if I have understood this patch correctly,
> it's fudging around the underlying bug by intentionally screwing up
> the RMP contents to avoid a page fault.  Assuming I've understood
> everything correctly (a big if!), then I think this is backwards.  The
> host kernel should not ever access guest memory without a plan in
> place to handle failure.  We need real accessors, along the lines of
> copy_from_guest() and copy_to_guest().

You understood it correctly. Its an underlying bug either in host or
guest which may cause the host accessing the guest private pages. If it
happen avoiding the host crash is much preferred (especially when its a
guest kernel bug).


