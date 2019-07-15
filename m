Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF2F66864D
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 11:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbfGOJ02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 05:26:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58356 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729487AbfGOJ02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 05:26:28 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 36EF687629;
        Mon, 15 Jul 2019 09:26:27 +0000 (UTC)
Received: from [10.36.117.137] (ovpn-117-137.ams2.redhat.com [10.36.117.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C63F245D3;
        Mon, 15 Jul 2019 09:26:14 +0000 (UTC)
Subject: Re: [RFC][Patch v11 1/2] mm: page_hinting: core infrastructure
To:     Dave Hansen <dave.hansen@intel.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        pbonzini@redhat.com, lcapitulino@redhat.com, pagupta@redhat.com,
        wei.w.wang@intel.com, yang.zhang.wz@gmail.com, riel@surriel.com,
        mst@redhat.com, dodgen@google.com, konrad.wilk@oracle.com,
        dhildenb@redhat.com, aarcange@redhat.com,
        alexander.duyck@gmail.com, john.starks@microsoft.com,
        mhocko@suse.com
References: <20190710195158.19640-1-nitesh@redhat.com>
 <20190710195158.19640-2-nitesh@redhat.com>
 <3f9a7e7b-c026-3530-e985-804fc7f1ec31@intel.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwX4EEwECACgFAljj9eoCGwMFCQlmAYAGCwkI
 BwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEE3eEPcA/4Na5IIP/3T/FIQMxIfNzZshIq687qgG
 8UbspuE/YSUDdv7r5szYTK6KPTlqN8NAcSfheywbuYD9A4ZeSBWD3/NAVUdrCaRP2IvFyELj
 xoMvfJccbq45BxzgEspg/bVahNbyuBpLBVjVWwRtFCUEXkyazksSv8pdTMAs9IucChvFmmq3
 jJ2vlaz9lYt/lxN246fIVceckPMiUveimngvXZw21VOAhfQ+/sofXF8JCFv2mFcBDoa7eYob
 s0FLpmqFaeNRHAlzMWgSsP80qx5nWWEvRLdKWi533N2vC/EyunN3HcBwVrXH4hxRBMco3jvM
 m8VKLKao9wKj82qSivUnkPIwsAGNPdFoPbgghCQiBjBe6A75Z2xHFrzo7t1jg7nQfIyNC7ez
 MZBJ59sqA9EDMEJPlLNIeJmqslXPjmMFnE7Mby/+335WJYDulsRybN+W5rLT5aMvhC6x6POK
 z55fMNKrMASCzBJum2Fwjf/VnuGRYkhKCqqZ8gJ3OvmR50tInDV2jZ1DQgc3i550T5JDpToh
 dPBxZocIhzg+MBSRDXcJmHOx/7nQm3iQ6iLuwmXsRC6f5FbFefk9EjuTKcLMvBsEx+2DEx0E
 UnmJ4hVg7u1PQ+2Oy+Lh/opK/BDiqlQ8Pz2jiXv5xkECvr/3Sv59hlOCZMOaiLTTjtOIU7Tq
 7ut6OL64oAq+zsFNBFXLn5EBEADn1959INH2cwYJv0tsxf5MUCghCj/CA/lc/LMthqQ773ga
 uB9mN+F1rE9cyyXb6jyOGn+GUjMbnq1o121Vm0+neKHUCBtHyseBfDXHA6m4B3mUTWo13nid
 0e4AM71r0DS8+KYh6zvweLX/LL5kQS9GQeT+QNroXcC1NzWbitts6TZ+IrPOwT1hfB4WNC+X
 2n4AzDqp3+ILiVST2DT4VBc11Gz6jijpC/KI5Al8ZDhRwG47LUiuQmt3yqrmN63V9wzaPhC+
 xbwIsNZlLUvuRnmBPkTJwwrFRZvwu5GPHNndBjVpAfaSTOfppyKBTccu2AXJXWAE1Xjh6GOC
 8mlFjZwLxWFqdPHR1n2aPVgoiTLk34LR/bXO+e0GpzFXT7enwyvFFFyAS0Nk1q/7EChPcbRb
 hJqEBpRNZemxmg55zC3GLvgLKd5A09MOM2BrMea+l0FUR+PuTenh2YmnmLRTro6eZ/qYwWkC
 u8FFIw4pT0OUDMyLgi+GI1aMpVogTZJ70FgV0pUAlpmrzk/bLbRkF3TwgucpyPtcpmQtTkWS
 gDS50QG9DR/1As3LLLcNkwJBZzBG6PWbvcOyrwMQUF1nl4SSPV0LLH63+BrrHasfJzxKXzqg
 rW28CTAE2x8qi7e/6M/+XXhrsMYG+uaViM7n2je3qKe7ofum3s4vq7oFCPsOgwARAQABwsFl
 BBgBAgAPBQJVy5+RAhsMBQkJZgGAAAoJEE3eEPcA/4NagOsP/jPoIBb/iXVbM+fmSHOjEshl
 KMwEl/m5iLj3iHnHPVLBUWrXPdS7iQijJA/VLxjnFknhaS60hkUNWexDMxVVP/6lbOrs4bDZ
 NEWDMktAeqJaFtxackPszlcpRVkAs6Msn9tu8hlvB517pyUgvuD7ZS9gGOMmYwFQDyytpepo
 YApVV00P0u3AaE0Cj/o71STqGJKZxcVhPaZ+LR+UCBZOyKfEyq+ZN311VpOJZ1IvTExf+S/5
 lqnciDtbO3I4Wq0ArLX1gs1q1XlXLaVaA3yVqeC8E7kOchDNinD3hJS4OX0e1gdsx/e6COvy
 qNg5aL5n0Kl4fcVqM0LdIhsubVs4eiNCa5XMSYpXmVi3HAuFyg9dN+x8thSwI836FoMASwOl
 C7tHsTjnSGufB+D7F7ZBT61BffNBBIm1KdMxcxqLUVXpBQHHlGkbwI+3Ye+nE6HmZH7IwLwV
 W+Ajl7oYF+jeKaH4DZFtgLYGLtZ1LDwKPjX7VAsa4Yx7S5+EBAaZGxK510MjIx6SGrZWBrrV
 TEvdV00F2MnQoeXKzD7O4WFbL55hhyGgfWTHwZ457iN9SgYi1JLPqWkZB0JRXIEtjd4JEQcx
 +8Umfre0Xt4713VxMygW0PnQt5aSQdMD58jHFxTk092mU+yIHj5LeYgvwSgZN4airXk5yRXl
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <0a89271f-c80b-9314-f6bb-8fdf0d714431@redhat.com>
Date:   Mon, 15 Jul 2019 11:26:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <3f9a7e7b-c026-3530-e985-804fc7f1ec31@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 15 Jul 2019 09:26:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10.07.19 22:45, Dave Hansen wrote:
> On 7/10/19 12:51 PM, Nitesh Narayan Lal wrote:
>> +struct zone_free_area {
>> +	unsigned long *bitmap;
>> +	unsigned long base_pfn;
>> +	unsigned long end_pfn;
>> +	atomic_t free_pages;
>> +	unsigned long nbits;
>> +} free_area[MAX_NR_ZONES];
> 
> Why do we need an extra data structure.  What's wrong with putting
> per-zone data in ... 'struct zone'?  The cover letter claims that it
> doesn't touch core-mm infrastructure, but if it depends on mechanisms
> like this, I think that's a very bad thing.
> 
> To be honest, I'm not sure this series is worth reviewing at this point.
>  It's horribly lightly commented and full of kernel antipatterns lik
> 
> void func()
> {
> 	if () {
> 		... indent entire logic
> 		... of function
> 	}
> }

"full of". Hmm.

> 
> It has big "TODO"s.  It's virtually comment-free.  I'm shocked it's at
> the 11th version and still looking like this.
> 
>> +
>> +		for (zone_idx = 0; zone_idx < MAX_NR_ZONES; zone_idx++) {
>> +			unsigned long pages = free_area[zone_idx].end_pfn -
>> +					free_area[zone_idx].base_pfn;
>> +			bitmap_size = (pages >> PAGE_HINTING_MIN_ORDER) + 1;
>> +			if (!bitmap_size)
>> +				continue;
>> +			free_area[zone_idx].bitmap = bitmap_zalloc(bitmap_size,
>> +								   GFP_KERNEL);
> 
> This doesn't support sparse zones.  We can have zones with massive
> spanned page sizes, but very few present pages.  On those zones, this
> will exhaust memory for no good reason.

Yes, AFAIKS, sparse zones are problematic when we have NORMAL/MOVABLE mixed.

1 bit for 2MB, 1 byte for 16MB, 64 bytes for 1GB

IOW, this isn't optimal but only really problematic for big systems /
very huge sparse zones.

> 
> Comparing this to Alex's patch set, it's of much lower quality and at a
> much earlier stage of development.  The two sets are not really even
> comparable right now.  This certainly doesn't sell me on (or even really

To be honest, I find this statement quite harsh. Nitesh's hard work in
the previous RFC's and many discussions with Alex essentially resulted
in the two approaches we have right now. Alex's approach would not look
the way it looks today without Nitesh's RFCs.

So much to that.

> enumerate the deltas in) this approach vs. Alex's.

I am aware that memory hotplug is not properly supported yet (future
work). Sparse zones work but eventually waste a handful of pages (!) -
future work. Anything else you are aware of that is missing?

My opinion:

1. Alex' solution is clearly beneficial, as we don't need to manage/scan
a bitmap. *however* we were concerned right from the beginning if
core-buddy modifications will be accepted upstream for a purely
virtualization-specific (as of now!) feature. If we can get it upstream,
perfect. Back when we discussed the idea with Alex I was skeptical - I
was expecting way more core modifications.

2. We were looking for an alternative solution that doesn't require to
modify the buddy. We have that now - yes, some things have to be worked
out and cleaned up, not arguing against that. A cleaned-up version of
this RFC with some fixes and enhancements should be ready to be used in
*many* (not all) setups. Which is perfectly fine.

So in summary, I think we should try our best to get Alex's series into
shape and accepted upstream. However, if we get upstream resistance or
it will take ages to get it in, I think we can start with this series
here (which requires no major buddy modifications as of now) and the
slowly see if we can convert it into Alex approach.

The important part for me is that the core<->driver interface and the
virtio interface is in a clean shape, so we can essentially swap out the
implementation specific parts in the core.

Cheers.

-- 

Thanks,

David / dhildenb
