Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E028FA6661
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 12:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbfICKPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 06:15:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40990 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727667AbfICKPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 06:15:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83AD7kj076681;
        Tue, 3 Sep 2019 10:13:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=+anirc1ufKGxJEU4Z3PGmZS+/UggyBKlolV/D6idGx4=;
 b=oJ6IszhCYg8UZZC98Psi/7dz6TtNj0ADinKqQ/cZM2pOQMV2oOgl8VGH4KJ+8Cz0n5sb
 kqlLMUqnLuENqbMfLHtxRIDqXqRzI91bNGm13xds4bQAzV5R3kbXuXbjPosV7d6YzSZ4
 wPCeqtSLCf2WxjxAQXzP+E7ujZue6950wH/pwJ6+hFC7ERmmOmGAASN3kUAmGkcJH/Io
 92vuoOk6yI21GTh+L/b5B0BVI88dRO83ayVo1XLmKRgqfsfQG9SbBVL7Mn+EqonKec84
 6ZfDcHWenf0DaVnX6WOaxw6Le1quHVlLHNGCr5ZhsNmuJYAKo4lD6kQi5MEL7zM+vcUp jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2usnssr4ft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 10:13:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83ADM9u145634;
        Tue, 3 Sep 2019 10:13:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2us4wdmpev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 10:13:40 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x83ADa4O013873;
        Tue, 3 Sep 2019 10:13:36 GMT
Received: from [10.175.205.235] (/10.175.205.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 03:13:36 -0700
Subject: Re: Is: Default governor regardless of cpuidle driver Was: [PATCH v2]
 cpuidle-haltpoll: vcpu hotplug support
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        kvm-devel <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20190829151027.9930-1-joao.m.martins@oracle.com>
 <c8cf8dcc-76a3-3e15-f514-2cb9df1bbbdc@oracle.com>
 <20190829172343.GA18825@amt.cnet>
 <CAJZ5v0j8BEjdNyAn=ut9BxSH5Gphs_AivADPwXX=rJ1TF1+88A@mail.gmail.com>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <457e8ca1-beb3-ca39-b257-e7bc6bb35d4d@oracle.com>
Date:   Tue, 3 Sep 2019 11:13:31 +0100
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0j8BEjdNyAn=ut9BxSH5Gphs_AivADPwXX=rJ1TF1+88A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030105
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/19 10:55 PM, Rafael J. Wysocki wrote:
> On Thu, Aug 29, 2019 at 7:24 PM Marcelo Tosatti <mtosatti@redhat.com> wrote:
>>
>> On Thu, Aug 29, 2019 at 06:16:05PM +0100, Joao Martins wrote:
>>> On 8/29/19 4:10 PM, Joao Martins wrote:
>>>> When cpus != maxcpus cpuidle-haltpoll will fail to register all vcpus
>>>> past the online ones and thus fail to register the idle driver.
>>>> This is because cpuidle_add_sysfs() will return with -ENODEV as a
>>>> consequence from get_cpu_device() return no device for a non-existing
>>>> CPU.
>>>>
>>>> Instead switch to cpuidle_register_driver() and manually register each
>>>> of the present cpus through cpuhp_setup_state() callback and future
>>>> ones that get onlined. This mimmics similar logic that intel_idle does.
>>>>
>>>> Fixes: fa86ee90eb11 ("add cpuidle-haltpoll driver")
>>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>>>> ---
>>>
>>> While testing the above, I found out another issue on the haltpoll series.
>>> But I am not sure what is best suited to cpuidle framework, hence requesting
>>> some advise if below is a reasonable solution or something else is preferred.
>>>
>>> Essentially after haltpoll governor got introduced and regardless of the cpuidle
>>> driver the default governor is gonna be haltpoll for a guest (given haltpoll
>>> governor doesn't get registered for baremetal).
>>
>> Right.
>>
>>> Right now, for a KVM guest, the
>>> idle governors have these ratings:
>>>
>>>  * ladder            -> 10
>>>  * teo               -> 19
>>>  * menu              -> 20
>>>  * haltpoll          -> 21
>>>  * ladder + nohz=off -> 25
>>
>> Yes. PowerPC KVM guests crash currently due to the use of the haltpoll
>> governor (have a patch in my queue to fix this, but your solution
>> embraces more cases).
>>
>>> When a guest is booted with MWAIT and intel_idle is probed and sucessfully
>>> registered, we will end up with a haltpoll governor being used as opposed to
>>> 'menu' (which used to be the default case). This would prevent IIUC that other
>>> C-states get used other than poll_state (state 0) and state 1.
>>>
>>> Given that haltpoll governor is largely only useful with a cpuidle-haltpoll
>>> it doesn't look reasonable to be the default? What about using haltpoll governor
>>> as default when haltpoll idle driver registers or modloads.
>>>
>>> My idea to achieve the above would be to decrease the rating to 9 (before the
>>> lowest rated governor) and retain old defaults before haltpoll. Then we would
>>> allow a cpuidle driver to define a preferred governor to switch on idle driver
>>> registration. Naturally all of would be ignored if overidden by
>>> cpuidle.governor=.
>>>
>>> The diff below the scissors line is an example of that.
>>>
>>> Thoughts?
>>
>> Works for me. Rafael?
> 
> It works for me too, basically, except that I would rename
> cpuidle_default_governor in the patch to cpuidle_prev_governor.
> 

Great! I'll send over a series with this then (splitted accordingly).

Also, In the course of hotplug/hotunplug testing, I found two small issues with
modload/modunload -- regardless of the hotplug patch. So I am gonna add that to
the series too.

	Joao
