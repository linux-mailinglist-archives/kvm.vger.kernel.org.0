Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E9D2CBB0C
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 11:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgLBKvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 05:51:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58082 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgLBKvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 05:51:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2AnlPV143571;
        Wed, 2 Dec 2020 10:50:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=LBy33kEE4ZuMQSVUj6AUv7nj24FXkABu94+C69N2jaI=;
 b=kzw6m3hAI73rfrheil0tHYx3sFso7rgbnp6mnSaJbLhUFUiDd/fvEQ3h+oiLQVSExBQH
 sDSHN/zOGb4PRs3JH48Mpla0v6f7saJZwKwogN6OAvtdNClOXA8K7EGIkz6GTSCMImHw
 nW3YXqbMP/zFEaxW5aObpmDt3a4Vyx/QIy0kpz5wjI+ex+pe7H1DIOOCgrAlw38Gkd+U
 WqCh7or4kEpQogBARIkwaDjPG1QPC91EjKwLuTgzwZUNECzTT4o2G/Ds1H3voohEnW3d
 MXNstftL/D/i/z28NkXeVvQQpQpdXBeOvWTy1OayV9pbfJ1JYagJmnBMfJ9jaV2f2RFN qQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 353dyqqk0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 10:50:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2AjNWT041209;
        Wed, 2 Dec 2020 10:50:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3540fyg1bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 10:50:37 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B2AoZpk000516;
        Wed, 2 Dec 2020 10:50:36 GMT
Received: from [10.175.181.158] (/10.175.181.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Dec 2020 02:50:35 -0800
Subject: Re: [PATCH RFC 03/39] KVM: x86/xen: register shared_info page
To:     Ankur Arora <ankur.a.arora@oracle.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
References: <20190220201609.28290-1-joao.m.martins@oracle.com>
 <20190220201609.28290-4-joao.m.martins@oracle.com>
 <b647bed6c75f8743b8afea251a88f00a5feaee29.camel@infradead.org>
 <2d4df59d-f945-32dc-6999-a6f711e972ea@oracle.com>
 <3ac692ed7dd77aa2ed23646bb1741a7b40bddcff.camel@infradead.org>
 <a6102420-cbda-700a-b049-31db96d357b1@oracle.com>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <474f59b0-184d-12a1-4172-c65d8970810e@oracle.com>
Date:   Wed, 2 Dec 2020 10:50:31 +0000
MIME-Version: 1.0
In-Reply-To: <a6102420-cbda-700a-b049-31db96d357b1@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020063
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/20 5:17 AM, Ankur Arora wrote:
> On 2020-12-01 5:26 p.m., David Woodhouse wrote
>> On Tue, 2020-12-01 at 16:40 -0800, Ankur Arora wrote:
>>> On 2020-12-01 5:07 a.m., David Woodhouse wrote:

[...]

>>>> If that was allowed, wouldn't it have been a much simpler fix for
>>>> CVE-2019-3016? What am I missing?
>>>
>>> Agreed.
>>>
>>> Perhaps, Paolo can chime in with why KVM never uses pinned page
>>> and always prefers to do cached mappings instead?
>>>
>>>>
>>>> Should I rework these to use kvm_write_guest_cached()?
>>>
>>> kvm_vcpu_map() would be better. The event channel logic does RMW operations
>>> on shared_info->vcpu_info.
>>
>> I've ported the shared_info/vcpu_info parts and made a test case, and
>> was going back through to make it use kvm_write_guest_cached(). But I
>> should probably plug on through the evtchn bits before I do that.
>>
>> I also don't see much locking on the cache, and can't convince myself
>> that accessing the shared_info page from multiple CPUs with
>> kvm_write_guest_cached() or kvm_map_gfn() is sane unless they each have
>> their own cache.
> 
> I think you could get a VCPU specific cache with kvm_vcpu_map().
> 

steal clock handling creates such a mapping cache (struct gfn_to_pfn_cache).

	Joao
