Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361E21E1240
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 18:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391128AbgEYQAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 12:00:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47206 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391039AbgEYQAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 12:00:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04PFwghJ129757;
        Mon, 25 May 2020 15:59:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Y0KNdejFsfkVxkixHd4qUi3/9lIVbUPFXxLx2tMB3mo=;
 b=ktt0B1DHcMRPvUUhQIHh+XEmZH4NOxqhRe6nehGlGe6jWE0wP/BKZz6JEMgAEzDgr4Wt
 Iyw2VMRvZgMlAMUPTq1xWQNlvHNIQS9Hk3zTqSdffRXf5mV7hA6z5WHxk6GB/6HyB/zQ
 51jwLGiQCLXMbGUesZSNUg71QQxsrm082PQgdMQkm+jHvJ5iwhpa4nL7UvoNyapqmpQW
 g7iyh42jaEG3tha5rot3T7+WEyCSd7fsSajvSIfQKeIQe0mEQ6IoQXkD4BNCMPKkSjC4
 hISIz4pP5LzYrh0UZJHOsSXum9iprA2Sk1BD+A4AkSaZD/Phl7WyugXVyCvpQ+/wSsGS nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 316vfn6096-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 25 May 2020 15:59:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04PFrU0i025028;
        Mon, 25 May 2020 15:57:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 317j5jjg0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 May 2020 15:57:12 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04PFv3EO022146;
        Mon, 25 May 2020 15:57:08 GMT
Received: from [192.168.14.112] (/79.178.199.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 May 2020 08:57:03 -0700
Subject: Re: [RFC 00/16] KVM protected memory extension
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <42685c32-a7a9-b971-0cf4-e8af8d9a40c6@oracle.com>
 <20200525144656.phfxjp2qip6736fj@box>
From:   Liran Alon <liran.alon@oracle.com>
Message-ID: <29c62691-0d50-8a02-5f43-761fa56ab551@oracle.com>
Date:   Mon, 25 May 2020 18:56:57 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200525144656.phfxjp2qip6736fj@box>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9632 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxlogscore=804 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005250124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9632 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxlogscore=835 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005250125
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 25/05/2020 17:46, Kirill A. Shutemov wrote:
> On Mon, May 25, 2020 at 04:47:18PM +0300, Liran Alon wrote:
>> On 22/05/2020 15:51, Kirill A. Shutemov wrote:
>>> == Background / Problem ==
>>>
>>> There are a number of hardware features (MKTME, SEV) which protect guest
>>> memory from some unauthorized host access. The patchset proposes a purely
>>> software feature that mitigates some of the same host-side read-only
>>> attacks.
>>>
>>>
>>> == What does this set mitigate? ==
>>>
>>>    - Host kernel ”accidental” access to guest data (think speculation)
>> Just to clarify: This is any host kernel memory info-leak vulnerability. Not
>> just speculative execution memory info-leaks. Also architectural ones.
>>
>> In addition, note that removing guest data from host kernel VA space also
>> makes guest<->host memory exploits more difficult.
>> E.g. Guest cannot use already available memory buffer in kernel VA space for
>> ROP or placing valuable guest-controlled code/data in general.
>>
>>>    - Host kernel induced access to guest data (write(fd, &guest_data_ptr, len))
>>>
>>>    - Host userspace access to guest data (compromised qemu)
>> I don't quite understand what is the benefit of preventing userspace VMM
>> access to guest data while the host kernel can still access it.
> Let me clarify: the guest memory mapped into host userspace is not
> accessible by both host kernel and userspace. Host still has way to access
> it via a new interface: GUP(FOLL_KVM). The GUP will give you struct page
> that kernel has to map (temporarily) if need to access the data. So only
> blessed codepaths would know how to deal with the memory.
Yes, I understood that. I meant explicit host kernel access.
>
> It can help preventing some host->guest attack on the compromised host.
> Like if an VM has successfully attacked the host it cannot attack other
> VMs as easy.

We have mechanisms to sandbox the userspace VMM process for that.

You need to be more specific on what is the attack scenario you attempt 
to address
here that is not covered by existing mechanisms. i.e. Be crystal clear 
on the extra value
of the feature of not exposing guest data to userspace VMM.

>
> It would also help to protect against guest->host attack by removing one
> more places where the guest's data is mapped on the host.
Because guest have explicit interface to request which guest pages can 
be mapped in userspace VMM, the value of this is very small.

Guest already have ability to map guest controlled code/data in 
userspace VMM either via this interface or via forcing userspace VMM
to create various objects during device emulation handling. The only 
extra property this patch-series provides, is that only a
small portion of guest pages will be mapped to host userspace instead of 
all of it. Resulting in smaller regions for exploits that require
guessing a virtual address. But: (a) Userspace VMM device emulation may 
still allow guest to spray userspace heap with objects containing
guest controlled data. (b) How is userspace VMM suppose to limit which 
guest pages should not be mapped to userspace VMM even though guest have
explicitly requested them to be mapped? (E.g. Because they are valid DMA 
sources/targets for virtual devices or because it's vGPU frame-buffer).
>> QEMU is more easily compromised than the host kernel because it's
>> guest<->host attack surface is larger (E.g. Various device emulation).
>> But this compromise comes from the guest itself. Not other guests. In
>> contrast to host kernel attack surface, which an info-leak there can
>> be exploited from one guest to leak another guest data.
> Consider the case when unprivileged guest user exploits bug in a QEMU
> device emulation to gain access to data it cannot normally have access
> within the guest. With the feature it would able to see only other shared
> regions of guest memory such as DMA and IO buffers, but not the rest.
This is a scenario where an unpriviledged guest userspace have direct 
access to a virtual device
and is able to exploit a bug in device emulation handling such that it 
will allow it to compromise
the security *inside* the guest. i.e. Leak guest kernel data or other 
guest userspace processes data.

That's true. Good point. This is a very important missing argument from 
the cover-letter.

Now it's crystal clear on the trade-off considered here:
Is the extra complication and perf cost provided by the mechanism of 
this patch-series worth
to protect against the scenario of a userspace VMM vulnerability that 
may be accessible to unpriviledged
guest userspace process to leak other *in-guest* data that is not 
otherwise accessible to that process?

-Liran


