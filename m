Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0FF2A28BA
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 23:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbfH2VRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 17:17:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49898 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfH2VRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 17:17:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLCDtM144352;
        Thu, 29 Aug 2019 21:16:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=pqCcHwN/Tb4s9RIwNt4YW/FcXMrEyrNCjmPgo/BiU24=;
 b=R9+/03W+3oo8T7JUd0gYHfl1LdrSfdASV/+FuAu71qd9suSsx/s18GF9uU1VfUSxNWPs
 ryJTpvlbLkvFhJ0AzVNUyS/o2TUQk6tnNXzqD+pfmXYky/LXCMQEJeI+USExe5fJvg4N
 yBjKeKduJiqfJDltuwJX85NeVfkKVSHoir56bgYSrDvzhQ0UOkJDAW/iSPOpkF8X+VzZ
 nfI++g4LG6mQw/BRFYZqkRjcy2H/EeJiStCUA0TxWumkF0m7YS6NkN0pCSa4Covv90zL
 FyXkLU1JyoV17twzNcukCdQyrsfsc/FJCVJND3D1llKVAmCJsNTgqpFvoUZ+CJVHVGT+ /Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2upp96r2qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:16:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLE3WP187030;
        Thu, 29 Aug 2019 21:14:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2upkrffc92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:14:12 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TLD1b8012354;
        Thu, 29 Aug 2019 21:13:01 GMT
Received: from [10.175.206.85] (/10.175.206.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 14:13:01 -0700
Subject: Re: Default governor regardless of cpuidle driver
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-pm@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20190829151027.9930-1-joao.m.martins@oracle.com>
 <c8cf8dcc-76a3-3e15-f514-2cb9df1bbbdc@oracle.com>
 <d1d4ade5-04a5-4288-d994-3963bb80fb6b@linaro.org>
 <6c8816af-934a-5bf7-6fb9-f67c05e2c8aa@oracle.com>
 <901ab688-5548-cf96-1dcb-ce50e617e917@linaro.org>
 <722bd6f6-6eee-b24b-9704-c9aecc06302f@oracle.com>
 <2e2a35c8-7f03-d7c8-4701-3bc9d91c1255@linaro.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <f8c63af5-2509-310d-7ba0-7687b20e3b44@oracle.com>
Date:   Thu, 29 Aug 2019 22:12:56 +0100
MIME-Version: 1.0
In-Reply-To: <2e2a35c8-7f03-d7c8-4701-3bc9d91c1255@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290214
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/29/19 9:22 PM, Daniel Lezcano wrote:
> On 29/08/2019 21:11, Joao Martins wrote:
>> On 8/29/19 7:28 PM, Daniel Lezcano wrote:
>>> On 29/08/2019 20:07, Joao Martins wrote:
>>>> On 8/29/19 6:42 PM, Daniel Lezcano wrote:
>>>>> On 29/08/2019 19:16, Joao Martins wrote:
>>>>>> On 8/29/19 4:10 PM, Joao Martins wrote:
>>>>>>> When cpus != maxcpus cpuidle-haltpoll will fail to register all vcpus
>>>>>>> past the online ones and thus fail to register the idle driver.
>>>>>>> This is because cpuidle_add_sysfs() will return with -ENODEV as a
>>>>>>> consequence from get_cpu_device() return no device for a non-existing
>>>>>>> CPU.
>>>>>>>
>>>>>>> Instead switch to cpuidle_register_driver() and manually register each
>>>>>>> of the present cpus through cpuhp_setup_state() callback and future
>>>>>>> ones that get onlined. This mimmics similar logic that intel_idle does.
>>>>>>>
>>>>>>> Fixes: fa86ee90eb11 ("add cpuidle-haltpoll driver")
>>>>>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>>>>>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>>>>>>> ---
>>>>>>
>>>>>> While testing the above, I found out another issue on the haltpoll series.
>>>>>> But I am not sure what is best suited to cpuidle framework, hence requesting
>>>>>> some advise if below is a reasonable solution or something else is preferred.
>>>>>>
>>>>>> Essentially after haltpoll governor got introduced and regardless of the cpuidle
>>>>>> driver the default governor is gonna be haltpoll for a guest (given haltpoll
>>>>>> governor doesn't get registered for baremetal). Right now, for a KVM guest, the
>>>>>> idle governors have these ratings:
>>>>>>
>>>>>>  * ladder            -> 10
>>>>>>  * teo               -> 19
>>>>>>  * menu              -> 20
>>>>>>  * haltpoll          -> 21
>>>>>>  * ladder + nohz=off -> 25
>>>>>>
>>>>>> When a guest is booted with MWAIT and intel_idle is probed and sucessfully
>>>>>> registered, we will end up with a haltpoll governor being used as opposed to
>>>>>> 'menu' (which used to be the default case). This would prevent IIUC that other
>>>>>> C-states get used other than poll_state (state 0) and state 1.
>>>>>>
>>>>>> Given that haltpoll governor is largely only useful with a cpuidle-haltpoll
>>>>>> it doesn't look reasonable to be the default? What about using haltpoll governor
>>>>>> as default when haltpoll idle driver registers or modload.
>>>>>
>>>>> Are the guest and host kernel the same? IOW compiled with the same
>>>>> kernel config?
>>>>>
>>>> You just need to toggle this (regardless off CONFIG_HALTPOLL_CPUIDLE):
>>>>
>>>> 	CONFIG_CPU_IDLE_GOV_HALTPOLL=y
>>>>
>>>> And *if you are a KVM guest* it will be the default (unless using nohz=off in
>>>> which case ladder gets the highest rating -- see the listing right above).
>>>>
>>>> Host will just behave differently because the haltpoll governor is checking if
>>>> it is running as kvm guest, and only registering in that case.
>>>
>>> I understood the problem. Actually my question was about if the kernels
>>> are compiled for host and guest, and can be run indifferently. 
>>
>> /nods Correct.
>>
>>> In this
>>> case a runtime detection must be done as you propose, otherwise that can
>>> be done at config time. I pretty sure it is the former but before
>>> thinking about the runtime side, I wanted to double check.
>>>
>> Hmm, but even with separate kernels/configs for guest and host I think we would
>> still have the same issue.
>>
>> What I was trying to convey is that even when running with a config solely for
>> KVM guests (that is different than baremetal) you can have today various ways of
>> idling. An Intel x86 kvm guest can have no idle driver (but arch-specific),
>> intel_idle (like baremetal config) and haltpoll. There are usecases for these
>> three, and makes sense to consolidate all.
>>
>> Say you wanted to have a kvm specific config, you would still see the same
>> problem if you happen to compile intel_idle together with haltpoll
>> driver+governor. 
> 
> Can a guest work with an intel_idle driver?
> 
Yes.

If you use Qemu you would add '-overcommit cpu-pm=on' to try it out. ofc,
assuming you're on a relatively recent Qemu (v3.0+) and a fairly recent kernel
version as host (v4.17+).

>> Creating two separate configs here, with and without haltpoll
>> for VMs doesn't sound effective for distros.
> 
> Agree
> 
>> Perhaps decreasing the rating of
>> haltpoll governor, but while a short term fix it wouldn't give much sensible
>> defaults without the one-off runtime switch.
> 
