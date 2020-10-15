Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CA428EED8
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 10:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387810AbgJOI5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 04:57:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57386 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726329AbgJOI5i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Oct 2020 04:57:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602752256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=Vs53K3dR0CYf1Qg7eg5iONDidevT0kf82kw/Xly804A=;
        b=KHCslS6sdJjuKYJZKULrI+/tVgbx0z87TvmY1Nr1jT/1Li3bQ8FEmKHfG7CCWqIkG+r/YK
        CSgNrJH5sRdXDT2UpKD2yUGQsqgQaiN8+mmgUSdGslg3b+Vq55Ml9X8TckSZOtUrtmYb9F
        EwwGz6d7GLxkvBOKraDmjMWb2Esu+A0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-LfQw1OLbPJSvlwj9yyAtIw-1; Thu, 15 Oct 2020 04:57:34 -0400
X-MC-Unique: LfQw1OLbPJSvlwj9yyAtIw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4033186DD28;
        Thu, 15 Oct 2020 08:57:32 +0000 (UTC)
Received: from [10.36.114.207] (ovpn-114-207.ams2.redhat.com [10.36.114.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3AF695D9D5;
        Thu, 15 Oct 2020 08:57:26 +0000 (UTC)
Subject: Re: cgroup and FALLOC_FL_PUNCH_HOLE: WARNING: CPU: 13 PID: 2438 at
 mm/page_counter.c:57 page_counter_uncharge+0x4b/0x5
From:   David Hildenbrand <david@redhat.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>,
        Mina Almasry <almasrymina@google.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Privoznik <mprivozn@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, KVM <kvm@vger.kernel.org>
References: <c1ea7548-622c-eda7-66f4-e4ae5b6ee8fc@redhat.com>
 <563d1eef-b780-835a-ebf0-88ae111b20c2@redhat.com>
 <CAHS8izPEHZunoeXYS5ONfRoSRMpC7DQwtpjJ8g4nXiddTfNoaA@mail.gmail.com>
 <65a1946f-dbf9-5767-5b51-9c1b786051d1@redhat.com>
 <5f196069-8b98-0ad3-55e8-19af03d715cd@oracle.com>
 <32ea3107-b1bc-f39e-3cf8-f6ef427235ef@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 mQINBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABtCREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT6JAlgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl8Ox4kFCRKpKXgACgkQTd4Q
 9wD/g1oHcA//a6Tj7SBNjFNM1iNhWUo1lxAja0lpSodSnB2g4FCZ4R61SBR4l/psBL73xktp
 rDHrx4aSpwkRP6Epu6mLvhlfjmkRG4OynJ5HG1gfv7RJJfnUdUM1z5kdS8JBrOhMJS2c/gPf
 wv1TGRq2XdMPnfY2o0CxRqpcLkx4vBODvJGl2mQyJF/gPepdDfcT8/PY9BJ7FL6Hrq1gnAo4
 3Iv9qV0JiT2wmZciNyYQhmA1V6dyTRiQ4YAc31zOo2IM+xisPzeSHgw3ONY/XhYvfZ9r7W1l
 pNQdc2G+o4Di9NPFHQQhDw3YTRR1opJaTlRDzxYxzU6ZnUUBghxt9cwUWTpfCktkMZiPSDGd
 KgQBjnweV2jw9UOTxjb4LXqDjmSNkjDdQUOU69jGMUXgihvo4zhYcMX8F5gWdRtMR7DzW/YE
 BgVcyxNkMIXoY1aYj6npHYiNQesQlqjU6azjbH70/SXKM5tNRplgW8TNprMDuntdvV9wNkFs
 9TyM02V5aWxFfI42+aivc4KEw69SE9KXwC7FSf5wXzuTot97N9Phj/Z3+jx443jo2NR34XgF
 89cct7wJMjOF7bBefo0fPPZQuIma0Zym71cP61OP/i11ahNye6HGKfxGCOcs5wW9kRQEk8P9
 M/k2wt3mt/fCQnuP/mWutNPt95w9wSsUyATLmtNrwccz63W5Ag0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAGJAjwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCXw7HsgUJEqkpoQAKCRBN3hD3AP+DWrrpD/4qS3dyVRxDcDHIlmguXjC1Q5tZTwNB
 boaBTPHSy/Nksu0eY7x6HfQJ3xajVH32Ms6t1trDQmPx2iP5+7iDsb7OKAb5eOS8h+BEBDeq
 3ecsQDv0fFJOA9ag5O3LLNk+3x3q7e0uo06XMaY7UHS341ozXUUI7wC7iKfoUTv03iO9El5f
 XpNMx/YrIMduZ2+nd9Di7o5+KIwlb2mAB9sTNHdMrXesX8eBL6T9b+MZJk+mZuPxKNVfEQMQ
 a5SxUEADIPQTPNvBewdeI80yeOCrN+Zzwy/Mrx9EPeu59Y5vSJOx/z6OUImD/GhX7Xvkt3kq
 Er5KTrJz3++B6SH9pum9PuoE/k+nntJkNMmQpR4MCBaV/J9gIOPGodDKnjdng+mXliF3Ptu6
 3oxc2RCyGzTlxyMwuc2U5Q7KtUNTdDe8T0uE+9b8BLMVQDDfJjqY0VVqSUwImzTDLX9S4g/8
 kC4HRcclk8hpyhY2jKGluZO0awwTIMgVEzmTyBphDg/Gx7dZU1Xf8HFuE+UZ5UDHDTnwgv7E
 th6RC9+WrhDNspZ9fJjKWRbveQgUFCpe1sa77LAw+XFrKmBHXp9ZVIe90RMe2tRL06BGiRZr
 jPrnvUsUUsjRoRNJjKKA/REq+sAnhkNPPZ/NNMjaZ5b8Tovi8C0tmxiCHaQYqj7G2rgnT0kt
 WNyWQQ==
Organization: Red Hat GmbH
Message-ID: <075968b6-9e2e-b625-8dc1-a7e5ed0bfd71@redhat.com>
Date:   Thu, 15 Oct 2020 10:57:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <32ea3107-b1bc-f39e-3cf8-f6ef427235ef@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15.10.20 09:56, David Hildenbrand wrote:
> On 14.10.20 20:31, Mike Kravetz wrote:
>> On 10/14/20 11:18 AM, David Hildenbrand wrote:
>>> On 14.10.20 19:56, Mina Almasry wrote:
>>>> On Wed, Oct 14, 2020 at 9:15 AM David Hildenbrand <david@redhat.com> wrote:
>>>>>
>>>>> On 14.10.20 17:22, David Hildenbrand wrote:
>>>>>> Hi everybody,
>>>>>>
>>>>>> Michal Privoznik played with "free page reporting" in QEMU/virtio-balloon
>>>>>> with hugetlbfs and reported that this results in [1]
>>>>>>
>>>>>> 1. WARNING: CPU: 13 PID: 2438 at mm/page_counter.c:57 page_counter_uncharge+0x4b/0x5
>>>>>>
>>>>>> 2. Any hugetlbfs allocations failing. (I assume because some accounting is wrong)
>>>>>>
>>>>>>
>>>>>> QEMU with free page hinting uses fallocate(FALLOC_FL_PUNCH_HOLE)
>>>>>> to discard pages that are reported as free by a VM. The reporting
>>>>>> granularity is in pageblock granularity. So when the guest reports
>>>>>> 2M chunks, we fallocate(FALLOC_FL_PUNCH_HOLE) one huge page in QEMU.
>>>>>>
>>>>>> I was also able to reproduce (also with virtio-mem, which similarly
>>>>>> uses fallocate(FALLOC_FL_PUNCH_HOLE)) on latest v5.9
>>>>>> (and on v5.7.X from F32).
>>>>>>
>>>>>> Looks like something with fallocate(FALLOC_FL_PUNCH_HOLE) accounting
>>>>>> is broken with cgroups. I did *not* try without cgroups yet.
>>>>>>
>>>>>> Any ideas?
>>>>
>>>> Hi David,
>>>>
>>>> I may be able to dig in and take a look. How do I reproduce this
>>>> though? I just fallocate(FALLOC_FL_PUNCH_HOLE) one 2MB page in a
>>>> hugetlb region?
>>>>
>>>
>>> Hi Mina,
>>>
>>> thanks for having a look. I started poking around myself but,
>>> being new to cgroup code, I even failed to understand why that code gets
>>> triggered though the hugetlb controller isn't even enabled.
>>>
>>> I assume you at least have to make sure that there is
>>> a page populated (MMAP_POPULATE, or read/write it). But I am not
>>> sure yet if a single fallocate(FALLOC_FL_PUNCH_HOLE) is
>>> sufficient, or if it will require a sequence of
>>> populate+discard(punch) (or multi-threading).
>>
>> FWIW - I ran libhugetlbfs tests which do a bunch of hole punching
>> with (and without) hugetlb controller enabled and did not see this issue.
>>
>> May need to reproduce via QEMU as below.
> 
> Not sure if relevant, but QEMU should be using
> memfd_create(MFD_HUGETLB|MFD_HUGE_2MB) to obtain a hugetlbfs file.
> 
> Also, QEMU fallocate(FALLOC_FL_PUNCH_HOLE)'s a significant of memory of
> the md (e.g., > 90%).
> 

I just tried to reproduce by doing random accesses + random fallocate(FALLOC_FL_PUNCH_HOLE) within a file - without success.

So could be
1. KVM is involved messing this up
2. Multi-threading is involved

However, I am also able to reproduce with only a single VCPU (there is still the QEMU main thread, but it limits the chance for races).

Even KVM spits fire after a while, which could be a side effect of allocations failing:

error: kvm run failed Bad address
RAX=0000000000000000 RBX=ffff8c12c9c217c0 RCX=ffff8c12fb1b8fc0 RDX=0000000000000007
RSI=ffff8c12c9c217c0 RDI=ffff8c12c9c217c8 RBP=000000000000000d RSP=ffffb3964040fa68
R8 =0000000000000008 R9 =ffff8c12c9c20000 R10=ffff8c12fffd5000 R11=00000000000303c0
R12=ffff8c12c9c217c0 R13=0000000000000008 R14=0000000000000001 R15=fffff31d44270800
RIP=ffffffffaf33ba0f RFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 0000000000000000 00000000 00000000
CS =0010 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
SS =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0000 0000000000000000 00000000 00000000
FS =0000 00007f8fabc87040 00000000 00000000
GS =0000 ffff8c12fbc00000 00000000 00000000
LDT=0000 fffffe0000000000 00000000 00000000
TR =0040 fffffe0000003000 00004087 00008b00 DPL=0 TSS64-busy
GDT=     fffffe0000001000 0000007f
IDT=     fffffe0000000000 00000fff
CR0=80050033 CR2=0000560e10895398 CR3=00000001073b2000 CR4=00350ef0
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000 
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000d01
Code=0f 0b eb e2 90 0f 1f 44 00 00 53 48 89 fb 31 c0 48 8d 7f 08 <48> c7 47 f8 00 00 00 00 48 89 d9 48 c7 c2 44 d3 52

-- 
Thanks,

David / dhildenb

