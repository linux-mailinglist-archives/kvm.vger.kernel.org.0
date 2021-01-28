Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7C1307432
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 11:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbhA1Kw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 05:52:58 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50974 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbhA1Kw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 05:52:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10SAmlnJ050101;
        Thu, 28 Jan 2021 10:51:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=BuluHwMd9NSzqvDt1SRfZihs9bpXUQcjEOj8pAKtjR4=;
 b=hrBqPD9mK0YU52moBTip1VITk5Lay0/G3S365Famc+CPkQUAHZiUMeGPj8XktrXaDiYl
 R75Yzuym40JZD5+cdQVYIWzZpuPZUf54vsFn+6oTWgZZyy9QSULM8FygXR0XL7cyKoqF
 Alcpz2KwuVBn9hPM5kN/gVWJOYNfZVhgu+T+9/cvFA+z9IC3vUknBoBlxm8IX733VYRp
 FE6pD3qOcB8Eeia8n+qOqD3x7TSSviFM3ktuGXTtfYDQI1J035eM6PuphSnrGGm30sG3
 QRyY887MJjmtq5/6mQGfrUxyQ0aADBzNjwFzTPinPFtFRratHPttN2cKxwpKp8moqnXB EA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 368brkufkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 10:51:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10SAjAdq079505;
        Thu, 28 Jan 2021 10:49:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 368wcqhkqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 10:49:15 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10SAnBcQ022723;
        Thu, 28 Jan 2021 10:49:11 GMT
Received: from [10.175.203.223] (/10.175.203.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Jan 2021 02:49:11 -0800
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH 1/5] KVM: Make the maximum number of user memslots a
 per-VM thing
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>
References: <20210127175731.2020089-1-vkuznets@redhat.com>
 <20210127175731.2020089-2-vkuznets@redhat.com>
 <09f96415-b32d-1073-0b4f-9c6e30d23b3a@oracle.com>
 <877dnx30vv.fsf@vitty.brq.redhat.com>
Message-ID: <5b6ac6b4-3cc8-2dc3-cd8c-a4e322379409@oracle.com>
Date:   Thu, 28 Jan 2021 11:48:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <877dnx30vv.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280053
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28.01.2021 09:45, Vitaly Kuznetsov wrote:
> "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com> writes:
> 
>> On 27.01.2021 18:57, Vitaly Kuznetsov wrote:
>>> Limiting the maximum number of user memslots globally can be undesirable as
>>> different VMs may have different needs. Generally, a relatively small
>>> number should suffice and a VMM may want to enforce the limitation so a VM
>>> won't accidentally eat too much memory. On the other hand, the number of
>>> required memslots can depend on the number of assigned vCPUs, e.g. each
>>> Hyper-V SynIC may require up to two additional slots per vCPU.
>>>
>>> Prepare to limit the maximum number of user memslots per-VM. No real
>>> functional change in this patch as the limit is still hard-coded to
>>> KVM_USER_MEM_SLOTS.
>>>
>>> Suggested-by: Sean Christopherson <seanjc@google.com>
>>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>> ---
>>
>> Perhaps I didn't understand the idea clearly but I thought it was
>> to protect the kernel from a rogue userspace VMM allocating many
>> memslots and so consuming a lot of memory in kernel?
>>
>> But then what's the difference between allocating 32k memslots for
>> one VM and allocating 509 slots for 64 VMs?
>>
> 
> It was Sean's idea :-) Initially, I had the exact same thoughts but now
> I agree with
> 
> "I see it as an easy way to mitigate the damage.  E.g. if a containers use case
> is spinning up hundreds of VMs and something goes awry in the config, it would
> be the difference between consuming tens of MBs and hundreds of MBs.  Cgroup
> limits should also be in play, but defense in depth and all that. "
> 
> https://urldefense.com/v3/__https://lore.kernel.org/kvm/YAcU6swvNkpPffE7@google.com/__;!!GqivPVa7Brio!MEvJAWTpdPwU7jynHog2X5g4AHX7YCbRlNvTC9x4xdmk3aiSMjwT_rMpvZM6g8TkoJfvcw$
> 
> That said it is not really a security feature, VMM still stays in
> control.
> 
>> A guest can't add a memslot on its own, only the host software
>> (like QEMU) can, right?
>>
> 
> VMMs (especially big ones like QEMU) are complex and e.g. each driver
> can cause memory regions (-> memslots in KVM) to change. With this
> feature it becomes possible to set a limit upfront (based on VM
> configuration) so it'll be more obvious when it's hit.
> 

I see: it's a kind of a "big switch", so every VMM doesn't have to be
modified or audited.
Thanks for the explanation.

Maciej
