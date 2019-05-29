Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB1CB2E96E
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 01:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfE2XdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 19:33:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39476 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfE2XdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 19:33:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TNSRIp080130;
        Wed, 29 May 2019 23:31:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=ZeIntJUzf6RoM7jUUPQSe8jXByDyh+4YkHIeg3GAXsQ=;
 b=IAaKB5qaUOqWsmMianN1GrQXpj9HG3cU0oz4ab6U1xB/tXO6+QR4XtP3ZMrOtiUMkOoV
 4E5Psrzd26xnaBWY4KxDwMtLYLrwtpzQmCqBocQFFxj26Y0zHm7WphZ5Vy7kvikFllbw
 K8oaFQODFc4ZYWzCBXppsBGoVQwYQdQg2GW8EUlLymnnHNwmkbT5lBnfY5IXgtKbeuvb
 fRuY8+2I/DomXosaX6EOYlvf6BUj2JvvkWAYxRpc9VIrwm5f0jD27GRQgV/1zhr4IIot
 MQ7LFuYSpR3RENpPYFVJ87Ior67/wGNxK49Fdt541GiLuVThQPe3y929dj9OI1biQ4aK dA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2spw4tn09w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 23:31:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TNTqPs081158;
        Wed, 29 May 2019 23:31:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2srbdxp6qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 23:31:17 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4TNV3Z4032602;
        Wed, 29 May 2019 23:31:04 GMT
Received: from [192.168.1.222] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 May 2019 16:31:03 -0700
Subject: Re: [PATCH v2] mm: hwpoison: disable memory error handling on 1GB
 hugepage
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Punit Agrawal <punit.agrawal@arm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Xiao Guangrong <xiaoguangrong@tencent.com>,
        lidongchen@tencent.com, yongkaiwu@tencent.com
References: <20180130013919.GA19959@hori1.linux.bs1.fc.nec.co.jp>
 <1517284444-18149-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <87inbbjx2w.fsf@e105922-lin.cambridge.arm.com>
 <20180207011455.GA15214@hori1.linux.bs1.fc.nec.co.jp>
 <87fu6bfytm.fsf@e105922-lin.cambridge.arm.com>
 <20180208121749.0ac09af2b5a143106f339f55@linux-foundation.org>
 <87wozhvc49.fsf@concordia.ellerman.id.au>
 <e673f38a-9e5f-21f6-421b-b3cb4ff02e91@oracle.com>
 <CANRm+CxAgWVv5aVzQ0wdP_A7QQgqfy7nN_SxyaactG7Mnqfr2A@mail.gmail.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <f79d828c-b0b4-8a20-c316-a13430cfb13c@oracle.com>
Date:   Wed, 29 May 2019 16:31:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CANRm+CxAgWVv5aVzQ0wdP_A7QQgqfy7nN_SxyaactG7Mnqfr2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905290145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/28/19 2:49 AM, Wanpeng Li wrote:
> Cc Paolo,
> Hi all,
> On Wed, 14 Feb 2018 at 06:34, Mike Kravetz <mike.kravetz@oracle.com> wrote:
>>
>> On 02/12/2018 06:48 PM, Michael Ellerman wrote:
>>> Andrew Morton <akpm@linux-foundation.org> writes:
>>>
>>>> On Thu, 08 Feb 2018 12:30:45 +0000 Punit Agrawal <punit.agrawal@arm.com> wrote:
>>>>
>>>>>>
>>>>>> So I don't think that the above test result means that errors are properly
>>>>>> handled, and the proposed patch should help for arm64.
>>>>>
>>>>> Although, the deviation of pud_huge() avoids a kernel crash the code
>>>>> would be easier to maintain and reason about if arm64 helpers are
>>>>> consistent with expectations by core code.
>>>>>
>>>>> I'll look to update the arm64 helpers once this patch gets merged. But
>>>>> it would be helpful if there was a clear expression of semantics for
>>>>> pud_huge() for various cases. Is there any version that can be used as
>>>>> reference?
>>>>
>>>> Is that an ack or tested-by?
>>>>
>>>> Mike keeps plaintively asking the powerpc developers to take a look,
>>>> but they remain steadfastly in hiding.
>>>
>>> Cc'ing linuxppc-dev is always a good idea :)
>>>
>>
>> Thanks Michael,
>>
>> I was mostly concerned about use cases for soft/hard offline of huge pages
>> larger than PMD_SIZE on powerpc.  I know that powerpc supports PGD_SIZE
>> huge pages, and soft/hard offline support was specifically added for this.
>> See, 94310cbcaa3c "mm/madvise: enable (soft|hard) offline of HugeTLB pages
>> at PGD level"
>>
>> This patch will disable that functionality.  So, at a minimum this is a
>> 'heads up'.  If there are actual use cases that depend on this, then more
>> work/discussions will need to happen.  From the e-mail thread on PGD_SIZE
>> support, I can not tell if there is a real use case or this is just a
>> 'nice to have'.
> 
> 1GB hugetlbfs pages are used by DPDK and VMs in cloud deployment, we
> encounter gup_pud_range() panic several times in product environment.
> Is there any plan to reenable and fix arch codes?

I too am aware of slightly more interest in 1G huge pages.  Suspect that as
Intel MMU capacity increases to handle more TLB entries there will be more
and more interest.

Personally, I am not looking at this issue.  Perhaps Naoya will comment as
he know most about this code.

> In addition, https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kvm/mmu.c#n3213
> The memory in guest can be 1GB/2MB/4K, though the host-backed memory
> are 1GB hugetlbfs pages, after above PUD panic is fixed,
> try_to_unmap() which is called in MCA recovery path will mark the PUD
> hwpoison entry. The guest will vmexit and retry endlessly when
> accessing any memory in the guest which is backed by this 1GB poisoned
> hugetlbfs page. We have a plan to split this 1GB hugetblfs page by 2MB
> hugetlbfs pages/4KB pages, maybe file remap to a virtual address range
> which is 2MB/4KB page granularity, also split the KVM MMU 1GB SPTE
> into 2MB/4KB and mark the offensive SPTE w/ a hwpoison flag, a sigbus
> will be delivered to VM at page fault next time for the offensive
> SPTE. Is this proposal acceptable?

I am not sure of the error handling design, but this does sound reasonable.
That block of code which potentially dissolves a huge page on memory error
is hard to understand and I'm not sure if that is even the 'normal'
functionality.  Certainly, we would hate to waste/poison an entire 1G page
for an error on a small subsection.

-- 
Mike Kravetz
