Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24ABE2D985A
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 13:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438775AbgLNMyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 07:54:23 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33962 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438578AbgLNMyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 07:54:21 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BECTavt036297;
        Mon, 14 Dec 2020 12:53:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=TyN5NiP+pm9Wh7fsGtmJtNXj1E290bUBsVJnYDXZfAY=;
 b=aDDjIWDtWIcCLBhfeAIjGT6cU6uui7byqHirnLChDtq2WvOcgYbg48m0ULBDVlZeeR3v
 LcOm3TEgGHQa3RxEToQBjKoYE0aXSdSb7vvUt5e3HGtVCzTQ7WZ2PDghjXNC4rpibgD8
 XY4GICOmHKVIPfolHUzeQ8S36vvaaUqQhhPnre7Prh+eu9WohkUXyMlNLLaxioWTkJ+T
 L8D8YqzIwWad/dPCK/7HP6TusX8oFdeX/GmY8A6BjNzzEoSpfkO4sasR9wiBqiWdZcLN
 hwx/6LzpbLNUD8314d8Mf+8pfyXc0OnnblUJetiKB1DoWoqTAQod+IHQvjI3G/WrsIku 9A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35ckcb54ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 12:53:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BECp4DA154341;
        Mon, 14 Dec 2020 12:53:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35e6jpcwfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 12:53:32 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BECrSUP025721;
        Mon, 14 Dec 2020 12:53:28 GMT
Received: from [10.175.173.239] (/10.175.173.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 04:53:28 -0800
Subject: Re: [PATCH v3 08/17] KVM: x86/xen: register shared_info page
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, kvm@vger.kernel.org
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-9-dwmw2@infradead.org>
 <da2f8101-c318-d7e5-1e93-f9b99f1718dd@oracle.com>
 <51c4cbf069c14447f8382be9a570e180449d823f.camel@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <ac6c4865-453d-0d01-a14f-12aa5354c322@oracle.com>
Date:   Mon, 14 Dec 2020 12:53:24 +0000
MIME-Version: 1.0
In-Reply-To: <51c4cbf069c14447f8382be9a570e180449d823f.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140089
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 12:02 PM, David Woodhouse wrote:
> On Mon, 2020-12-14 at 10:45 +0000, Joao Martins wrote:
>> On 12/14/20 8:38 AM, David Woodhouse wrote:
>>> From: Joao Martins <joao.m.martins@oracle.com>
>>>
>>> We add a new ioctl, XEN_HVM_SHARED_INFO, to allow hypervisor
>>> to know where the guest's shared info page is.
>>>
>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
>>> ---
>>>  arch/x86/include/asm/kvm_host.h |  2 ++
>>>  arch/x86/kvm/xen.c              | 27 +++++++++++++++++++++++++++
>>>  arch/x86/kvm/xen.h              |  1 -
>>>  include/uapi/linux/kvm.h        |  4 ++++
>>>  4 files changed, 33 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/include/asm/kvm_host.h
>>> b/arch/x86/include/asm/kvm_host.h
>>> index c9a4feaee2e7..8bcd83dacf43 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -893,6 +893,8 @@ struct msr_bitmap_range {
>>>  /* Xen emulation context */
>>>  struct kvm_xen {
>>>  	bool long_mode;
>>> +	bool shinfo_set;
>>> +	struct gfn_to_hva_cache shinfo_cache;
>>>  };
>>>  
>>>  enum kvm_irqchip_mode {
>>> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
>>> index 52cb9e465542..9dd9c42842b8 100644
>>> --- a/arch/x86/kvm/xen.c
>>> +++ b/arch/x86/kvm/xen.c
>>> @@ -13,9 +13,23 @@
>>>  #include <linux/kvm_host.h>
>>>  
>>>  #include <trace/events/kvm.h>
>>> +#include <xen/interface/xen.h>
>>>  
>>>  #include "trace.h"
>>>  
>>> +static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
>>> +{
>>> +	int ret;
>>> +
>>> +	ret = kvm_gfn_to_hva_cache_init(kvm, &kvm-
>>>> arch.xen.shinfo_cache,
>>> +					gfn_to_gpa(gfn), PAGE_SIZE);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	kvm->arch.xen.shinfo_set = true;
>>
>> Can't you just use:
>>
>> 	kvm->arch.xen.shinfo_cache.gpa
>>
>> Rather than added a bool just to say you set a shinfo?
> 
> I see no reason why a guest shouldn't be able to use GPA zero if it
> really wanted to. Using a separate boolean matches what KVM does for
> the wallclock info.
> 
Ah OK -- I didn't notice @pv_time_enabled before suggesting this.

An helper would probably suffice without sacrificing footprint in
data structures (because you will add 3 of these). The helpers would be, say:

	kvm_xen_shared_info_set(vcpu->kvm)
	kvm_xen_vcpu_info_set(vcpu)
	kvm_xen_vcpu_runstate_set(vcpu)

And maybe backed by a:

	kvm_gfn_to_hva_cache_valid(&v->kvm->arch.xen.shinfo_cache)

Which would check whether a cache is initialized or valid.

But anyhow, I don't feel strongly about it, specially if there's an existing
one which sort of sets the precedent.

	Joao
