Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C182CC7EB
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 21:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgLBUgu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 15:36:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35474 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbgLBUgt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 15:36:49 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2KZA1o004516;
        Wed, 2 Dec 2020 20:35:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=NoO5ZnzUZTiGXgB6FbPwx93nxD9U/2l3gbD+Xy+Gcqs=;
 b=HWMEOjQDpoIfWipEOdbYLD+WpaUc7r5sg09FV3aRcf2bN8FAzgQAJ4KvhnMFKkCxLZNC
 O5rvkyAJxVLeo3xX+IVbDJCFU8mZ/i4oZCusbUA1P+vdizThroWj2vPUxp7YaGPHK8X2
 iC9CluRvHPDEdKoYbOJtmyOhuSZeNdtgsaCH5obYsyXxRFsCWTS61w+XCAIboedAIIuy
 OS2bwsNlE/OSqubgY73nuQmKYQ9myaPYm/DBMTU/zctTMXNTuUXdHX7acfYSX9LblY8r
 dsO5wwjFd4OvDiatnHJQVmcy4A6QUTjB+aoeVLh1tdUHxMcTIj6nO7tOsEhp48PAQoqv OA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egktjuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 20:35:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2KUMAn125704;
        Wed, 2 Dec 2020 20:33:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3540auuvsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 20:33:46 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B2KXjkF015423;
        Wed, 2 Dec 2020 20:33:45 GMT
Received: from [10.159.240.123] (/10.159.240.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Dec 2020 12:33:45 -0800
Subject: Re: [PATCH RFC 03/39] KVM: x86/xen: register shared_info page
To:     Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20190220201609.28290-1-joao.m.martins@oracle.com>
 <20190220201609.28290-4-joao.m.martins@oracle.com>
 <b647bed6c75f8743b8afea251a88f00a5feaee29.camel@infradead.org>
 <2d4df59d-f945-32dc-6999-a6f711e972ea@oracle.com>
 <896dc984-fa71-8f2f-d12b-458294f5f706@oracle.com>
From:   Ankur Arora <ankur.a.arora@oracle.com>
Message-ID: <d3775e15-9d5e-3746-84a0-a3049d20c3eb@oracle.com>
Date:   Wed, 2 Dec 2020 12:33:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <896dc984-fa71-8f2f-d12b-458294f5f706@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020123
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-12-02 2:44 a.m., Joao Martins wrote:
> [late response - was on holiday yesterday]
> 
> On 12/2/20 12:40 AM, Ankur Arora wrote:
>> On 2020-12-01 5:07 a.m., David Woodhouse wrote:
>>> On Wed, 2019-02-20 at 20:15 +0000, Joao Martins wrote:
>>>> +static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
>>>> +{
>>>> +       struct shared_info *shared_info;
>>>> +       struct page *page;
>>>> +
>>>> +       page = gfn_to_page(kvm, gfn);
>>>> +       if (is_error_page(page))
>>>> +               return -EINVAL;
>>>> +
>>>> +       kvm->arch.xen.shinfo_addr = gfn;
>>>> +
>>>> +       shared_info = page_to_virt(page);
>>>> +       memset(shared_info, 0, sizeof(struct shared_info));
>>>> +       kvm->arch.xen.shinfo = shared_info;
>>>> +       return 0;
>>>> +}
>>>> +
>>>
>>> Hm.
>>>
>>> How come we get to pin the page and directly dereference it every time,
>>> while kvm_setup_pvclock_page() has to use kvm_write_guest_cached()
>>> instead?
>>
>> So looking at my WIP trees from the time, this is something that
>> we went back and forth on as well with using just a pinned page or a
>> persistent kvm_vcpu_map().
>>
>> I remember distinguishing shared_info/vcpu_info from kvm_setup_pvclock_page()
>> as shared_info is created early and is not expected to change during the
>> lifetime of the guest which didn't seem true for MSR_KVM_SYSTEM_TIME (or
>> MSR_KVM_STEAL_TIME) so that would either need to do a kvm_vcpu_map()
>> kvm_vcpu_unmap() dance or do some kind of synchronization.
>>
>> That said, I don't think this code explicitly disallows any updates
>> to shared_info.
>>
>>>
>>> If that was allowed, wouldn't it have been a much simpler fix for
>>> CVE-2019-3016? What am I missing?
>>
>> Agreed.
>>
>> Perhaps, Paolo can chime in with why KVM never uses pinned page
>> and always prefers to do cached mappings instead?
>>
> Part of the CVE fix to not use cached versions.
> 
> It's not a longterm pin of the page unlike we try to do here (partly due to the nature
> of the pages we are mapping) but we still we map the gpa, RMW the steal time struct, and
> then unmap the page.
> 
> See record_steal_time() -- but more specifically commit b043138246 ("x86/KVM: Make sure
> KVM_VCPU_FLUSH_TLB flag is not missed").
> 
> But I am not sure it's a good idea to follow the same as record_steal_time() given that
> this is a fairly sensitive code path for event channels.
> 
>>>
>>> Should I rework these to use kvm_write_guest_cached()?
>>
>> kvm_vcpu_map() would be better. The event channel logic does RMW operations
>> on shared_info->vcpu_info.
>>
> Indeed, yes.
> 
> Ankur IIRC, we saw missed event channels notifications when we were using the
> {write,read}_cached() version of the patch.
> 
> But I can't remember the reason it was due to, either the evtchn_pending or the mask
> word -- which would make it not inject an upcall.

If memory serves, it was the mask. Though I don't think that we had
kvm_{write,read}_cached in use at that point -- given that they were
definitely not RMW safe.


Ankur

> 
> 	Joao
> 
