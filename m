Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477032CC7DE
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 21:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbgLBUdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 15:33:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57786 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728781AbgLBUdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 15:33:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2KTSdw165964;
        Wed, 2 Dec 2020 20:32:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4ZTHgzowENKV9HQmSlHClfuqrgbKyEkgKGQT/XWcDAo=;
 b=etWZK15yLUu3zVLWcHgK7XfHWk1m1EXPAGyRtVYbLwmXjmRbR9u64h6BSNeKX7QK+GF+
 2HNZLb5KN5lm9/dugZXDRCTk06kSBXzPRtbOJkwuFIYTDeosa1VN7IffjnQfSTtjBOTv
 5jDJtCjNIpqlTWGJs70ngcqRYwf7xplX7fKPpqRzdfFpVX6XWrL++nYBRPeW9GhWIwcv
 lXg7Q7dmOUMlZQQkqTOdtEgRxZYcLR8OdSEiWuxnRqrXT3/hA+oLnSoi188wGb9d+pcI
 hYKYFd3rHAP063/LbFY9xY4WuBNk9VfaXM/mwKWS3PPiCYW3jeMn1LwWWakTaHOdQPbv 1Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 353dyqtm6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 20:32:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2KULKu125625;
        Wed, 2 Dec 2020 20:32:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3540auure8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 20:32:16 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B2KWFLe014269;
        Wed, 2 Dec 2020 20:32:15 GMT
Received: from [10.159.240.123] (/10.159.240.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Dec 2020 12:32:15 -0800
Subject: Re: [PATCH RFC 03/39] KVM: x86/xen: register shared_info page
To:     David Woodhouse <dwmw2@infradead.org>,
        Joao Martins <joao.m.martins@oracle.com>
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
 <58db65203b9464f6f225f4ef97c45af3c72cf068.camel@infradead.org>
From:   Ankur Arora <ankur.a.arora@oracle.com>
Message-ID: <6ea92fe2-4067-d0e0-b716-16d39a7a6065@oracle.com>
Date:   Wed, 2 Dec 2020 12:32:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <58db65203b9464f6f225f4ef97c45af3c72cf068.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-12-02 4:20 a.m., David Woodhouse wrote:
> On Wed, 2020-12-02 at 10:44 +0000, Joao Martins wrote:
>> [late response - was on holiday yesterday]
>>
>> On 12/2/20 12:40 AM, Ankur Arora wrote:
>>> On 2020-12-01 5:07 a.m., David Woodhouse wrote:
>>>> On Wed, 2019-02-20 at 20:15 +0000, Joao Martins wrote:
>>>>> +static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
>>>>> +{
>>>>> +       struct shared_info *shared_info;
>>>>> +       struct page *page;
>>>>> +
>>>>> +       page = gfn_to_page(kvm, gfn);
>>>>> +       if (is_error_page(page))
>>>>> +               return -EINVAL;
>>>>> +
>>>>> +       kvm->arch.xen.shinfo_addr = gfn;
>>>>> +
>>>>> +       shared_info = page_to_virt(page);
>>>>> +       memset(shared_info, 0, sizeof(struct shared_info));
>>>>> +       kvm->arch.xen.shinfo = shared_info;
>>>>> +       return 0;
>>>>> +}
>>>>> +
>>>>
>>>> Hm.
>>>>
>>>> How come we get to pin the page and directly dereference it every time,
>>>> while kvm_setup_pvclock_page() has to use kvm_write_guest_cached()
>>>> instead?
>>>
>>> So looking at my WIP trees from the time, this is something that
>>> we went back and forth on as well with using just a pinned page or a
>>> persistent kvm_vcpu_map().
>>>
>>> I remember distinguishing shared_info/vcpu_info from kvm_setup_pvclock_page()
>>> as shared_info is created early and is not expected to change during the
>>> lifetime of the guest which didn't seem true for MSR_KVM_SYSTEM_TIME (or
>>> MSR_KVM_STEAL_TIME) so that would either need to do a kvm_vcpu_map()
>>> kvm_vcpu_unmap() dance or do some kind of synchronization.
>>>
>>> That said, I don't think this code explicitly disallows any updates
>>> to shared_info.
>>>
>>>>
>>>> If that was allowed, wouldn't it have been a much simpler fix for
>>>> CVE-2019-3016? What am I missing?
>>>
>>> Agreed.
>>>
>>> Perhaps, Paolo can chime in with why KVM never uses pinned page
>>> and always prefers to do cached mappings instead?
>>>
>>
>> Part of the CVE fix to not use cached versions.
>>
>> It's not a longterm pin of the page unlike we try to do here (partly due to the nature
>> of the pages we are mapping) but we still we map the gpa, RMW the steal time struct, and
>> then unmap the page.
>>
>> See record_steal_time() -- but more specifically commit b043138246 ("x86/KVM: Make sure
>> KVM_VCPU_FLUSH_TLB flag is not missed").
>>
>> But I am not sure it's a good idea to follow the same as record_steal_time() given that
>> this is a fairly sensitive code path for event channels.
> 
> Right. We definitely need to use atomic RMW operations (like the CVE
> fix did) so the page needs to be *mapped*.
> 
> My question was about a permanent pinned mapping vs the map/unmap as we
> need it that record_steal_time() does.
> 
> On IRC, Paolo told me that permanent pinning causes problems for memory
> hotplug, and pointed me at the trick we do with an MMU notifier and
> kvm_vcpu_reload_apic_access_page().

Okay that answers my question. Thanks for clearing that up.

Not sure of a good place to document this but it would be good to
have this written down somewhere. Maybe kvm_map_gfn()?

> 
> I'm going to stick with the pinning we have for the moment, and just
> fix up the fact that it leaks the pinned pages if the guest sets the
> shared_info address more than once.
> 
> At some point the apic page MMU notifier thing can be made generic, and
> we can use that for this and for KVM steal time too.
> 

Yeah, that's something that'll definitely be good to have.

Ankur
