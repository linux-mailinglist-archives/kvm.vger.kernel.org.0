Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED42FA356D
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 13:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfH3LJW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 07:09:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47488 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbfH3LJV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 07:09:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UB7w6i107234;
        Fri, 30 Aug 2019 11:08:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=WxH5c0AO/ppWqHS1hPmVJ/ebozPUhe7msAT0OzNYuVE=;
 b=Y/JS0lJ40hk3QYTWq1xwWGw9rjSc7JoY3MHqcpR00edYeHJQz4RE9GQ+9p4zHs2k7Jdv
 nichp2/QDARf6t0NwVvKnifdU+W5oWVUNB973KViWooKQbxWfTn9lrOw5UcVbn8YhQZp
 lVZ//+ojXfrIUd8Nvg/W2VlCNdPBBgW51Szi8oO5zKk4qd6TUW5FQ6B6jvhZzIr+xo/1
 dsi/ksiwmukPKQn1br8yhX1lIMPVSya+Ss3aJPbHeRo2uP/zBg6W8LLte4WxzAETxAA+
 tgR8cOqzYD79ftwx3CZwsIOuXRurTWGMcdVOQjegULjC2rkNuZ/jx0QwfW9cXEk4B1zL Tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uq2nc0036-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 11:08:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UB40Lb177359;
        Fri, 30 Aug 2019 11:07:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uphav1gmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 11:07:10 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7UB750V029324;
        Fri, 30 Aug 2019 11:07:06 GMT
Received: from [10.175.203.89] (/10.175.203.89)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 04:07:05 -0700
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
 <f8c63af5-2509-310d-7ba0-7687b20e3b44@oracle.com>
 <b759d5a9-f418-817e-eefa-2302d17cb6ea@linaro.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <b164bd75-bc9a-0f07-e831-004a0bb5fe1b@oracle.com>
Date:   Fri, 30 Aug 2019 12:07:00 +0100
MIME-Version: 1.0
In-Reply-To: <b759d5a9-f418-817e-eefa-2302d17cb6ea@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300120
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/29/19 10:51 PM, Daniel Lezcano wrote:
> On 29/08/2019 23:12, Joao Martins wrote:
> 
> [ ... ]
> 
>>>> Say you wanted to have a kvm specific config, you would still see the same
>>>> problem if you happen to compile intel_idle together with haltpoll
>>>> driver+governor. 
>>>
>>> Can a guest work with an intel_idle driver?
>>>
>> Yes.
>>
>> If you use Qemu you would add '-overcommit cpu-pm=on' to try it out. ofc,
>> assuming you're on a relatively recent Qemu (v3.0+) and a fairly recent kernel
>> version as host (v4.17+).
> 
> Ok, thanks for the clarification.
> 
>>>> Creating two separate configs here, with and without haltpoll
>>>> for VMs doesn't sound effective for distros.
>>>
>>> Agree
>>>
>>>> Perhaps decreasing the rating of
>>>> haltpoll governor, but while a short term fix it wouldn't give much sensible
>>>> defaults without the one-off runtime switch.
> 
> The rating has little meaning because each governor fits a specific
> situation (server, desktop, etc...) and it would probably make sense to
> remove it and add a default governor in the config file like the cpufreq.
> 
ICYM, I had attached a patch in the first message of this thread [0] right below
the scissors mark. It's not based on config file, but it's the same thing you're
saying (IIUC) but at runtime and thus allowing a driver to state a 'preferred'
governor to switch to at idle registration -- let me know if you think that
looks a sensible approach. Note that the intent of that patch follows the
thinking of leaving all defaults as before haltpoll governor was introduced, but
once user modloads/uses cpuidle-haltpoll this governor then gets switched on.

[0] https://lore.kernel.org/kvm/c8cf8dcc-76a3-3e15-f514-2cb9df1bbbdc@oracle.com/

I would think a config-based preference on a governor would be good *if* one
could actually switch idle governors at runtime like you can with cpufreq -- in
case userspace wants something else other than the default. Right now we can't
do that unless you toggle 'cpuidle_sysfs_switch', or picking one at boot with
'cpuidle.governor='.

> May be I missed the point from some previous discussion but IMHO the
> problem you are facing is coming from the design: there is no need to
> create a halt governor but move the code inside the cpuidle-halt driver
> instead and ignore the state asked by the governor and return the state
> the driver entered.
> 
Marcello's original patch series (first 3 revisions to be exact) actually had
everything in the idle driver, but after some revisions (v4+) Rafael asked him
to split the logic into a governor and unify it with poll state[1].

[1]
https://lore.kernel.org/kvm/CAJZ5v0gPbSXB3r71XaT-4Q7LsiFO_UVymBwOmU8J1W5+COk_1g@mail.gmail.com/

	Joao
