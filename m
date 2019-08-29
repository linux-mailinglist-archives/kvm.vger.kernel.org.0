Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B96A22FF
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 20:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbfH2SJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 14:09:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33736 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfH2SJV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 14:09:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TI59cU167387;
        Thu, 29 Aug 2019 18:07:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=rIYeliHvmDvjv7DWm9hgk5WX7sUfwp4wx0yb1NI3c9w=;
 b=scjh3u/q34rU9PIefy84s1Rojv3lYQyH1Fy3Z9BsSF/3g3ucFvQ8AGmUvEH61dfWZj5Z
 Rgw8FBvfonNlKvqjzPq3syoxPcv385L14cRaWa+Wd00T/dlMe67vKRUPTf2kYwWMhWbD
 dZw2MoVlk93DRuXk78xl3DZdGErLMGyPfo5uJHzHGr/aVbkqiPBhU6pwDsNiEiSHvj8j
 j9Jh3PcUGSgkHCAY+NXnC0cwMgrEOSEYHd1V3gf0c+a5H+/cM0JwXSC6Zie5MiC+s/zT
 qyvbxmrjmBLjQKWIdlMRtfRLbFtZGexCvjrGhu6gFUSkDYrXSTvlye931ue9IPSFg+et hQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2upknr80mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 18:07:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7THnhRi024593;
        Thu, 29 Aug 2019 18:07:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2unteve736-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 18:07:55 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TI7sof008888;
        Thu, 29 Aug 2019 18:07:54 GMT
Received: from [10.175.160.184] (/10.175.160.184)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 18:07:53 +0000
Subject: Re: Is: Default governor regardless of cpuidle driver Was: [PATCH v2]
 cpuidle-haltpoll: vcpu hotplug support
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
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
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <6c8816af-934a-5bf7-6fb9-f67c05e2c8aa@oracle.com>
Date:   Thu, 29 Aug 2019 19:07:49 +0100
MIME-Version: 1.0
In-Reply-To: <d1d4ade5-04a5-4288-d994-3963bb80fb6b@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290187
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290187
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/29/19 6:42 PM, Daniel Lezcano wrote:
> On 29/08/2019 19:16, Joao Martins wrote:
>> On 8/29/19 4:10 PM, Joao Martins wrote:
>>> When cpus != maxcpus cpuidle-haltpoll will fail to register all vcpus
>>> past the online ones and thus fail to register the idle driver.
>>> This is because cpuidle_add_sysfs() will return with -ENODEV as a
>>> consequence from get_cpu_device() return no device for a non-existing
>>> CPU.
>>>
>>> Instead switch to cpuidle_register_driver() and manually register each
>>> of the present cpus through cpuhp_setup_state() callback and future
>>> ones that get onlined. This mimmics similar logic that intel_idle does.
>>>
>>> Fixes: fa86ee90eb11 ("add cpuidle-haltpoll driver")
>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>>> ---
>>
>> While testing the above, I found out another issue on the haltpoll series.
>> But I am not sure what is best suited to cpuidle framework, hence requesting
>> some advise if below is a reasonable solution or something else is preferred.
>>
>> Essentially after haltpoll governor got introduced and regardless of the cpuidle
>> driver the default governor is gonna be haltpoll for a guest (given haltpoll
>> governor doesn't get registered for baremetal). Right now, for a KVM guest, the
>> idle governors have these ratings:
>>
>>  * ladder            -> 10
>>  * teo               -> 19
>>  * menu              -> 20
>>  * haltpoll          -> 21
>>  * ladder + nohz=off -> 25
>>
>> When a guest is booted with MWAIT and intel_idle is probed and sucessfully
>> registered, we will end up with a haltpoll governor being used as opposed to
>> 'menu' (which used to be the default case). This would prevent IIUC that other
>> C-states get used other than poll_state (state 0) and state 1.
>>
>> Given that haltpoll governor is largely only useful with a cpuidle-haltpoll
>> it doesn't look reasonable to be the default? What about using haltpoll governor
>> as default when haltpoll idle driver registers or modload.
> 
> Are the guest and host kernel the same? IOW compiled with the same
> kernel config?
> 
You just need to toggle this (regardless off CONFIG_HALTPOLL_CPUIDLE):

	CONFIG_CPU_IDLE_GOV_HALTPOLL=y

And *if you are a KVM guest* it will be the default (unless using nohz=off in
which case ladder gets the highest rating -- see the listing right above).

Host will just behave differently because the haltpoll governor is checking if
it is running as kvm guest, and only registering in that case.

> 
>> My idea to achieve the above would be to decrease the rating to 9 (before the
>> lowest rated governor) and retain old defaults before haltpoll. Then we would
>> allow a cpuidle driver to define a preferred governor to switch on idle driver
>> registration. Naturally all of would be ignored if overidden by
>> cpuidle.governor=.
>>
> 
> 
> 
> 
