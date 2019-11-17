Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90C0DFF89E
	for <lists+kvm@lfdr.de>; Sun, 17 Nov 2019 10:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfKQJCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Nov 2019 04:02:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33510 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbfKQJCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Nov 2019 04:02:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAH906lB165791;
        Sun, 17 Nov 2019 09:02:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=K87XTMst2Lu5yJxW3+2amjx0WBo4HNyMY4Pw854xdSA=;
 b=SIT+2rAYq/jVinl4RRW0shGpfFf6VQjuow/0AebFa1OV6C4TorMtPRl2//OojIMYsmlT
 ExozFyv/S1f4XmflwBwk52jVy4RG8eKgC5mLdToyl4hf1iqfyUWbJSMbLjebXwIt/447
 ++Sj4bT1S6r3/IDhoMpNlJ4UX/ck1QSu/efnM4/Bba3Y7hWBUjoMWxxD24gpJmZJWbnz
 A1yPiWypjFfyuA2fr1ic98nss/82TCo4ttHMuF+AXa958ts18GtLUyvofJFsnVmVcHue
 qqgGcZh0ZamzrEhEb/uzDZ3ORaopjTCJTXtIrCjbk1mWbNtL/rd22Vs0ZByVZTwkgv8u Qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wa8htbba0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Nov 2019 09:02:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAH8s88C105714;
        Sun, 17 Nov 2019 09:02:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2wau92rput-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Nov 2019 09:02:45 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAH92iur029140;
        Sun, 17 Nov 2019 09:02:44 GMT
Received: from [10.191.18.30] (/10.191.18.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 17 Nov 2019 01:02:35 -0800
Subject: Re: [PATCH RESEND v2 1/4] cpuidle-haltpoll: ensure grow start value
 is nonzero
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>
References: <1573041302-4904-1-git-send-email-zhenzhong.duan@oracle.com>
 <1573041302-4904-2-git-send-email-zhenzhong.duan@oracle.com>
 <CAJZ5v0gyszPOvUxd8WX8gxc1OvX_nLUGh3vKn=aXWRj52L76yw@mail.gmail.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <4219f339-556d-e2f8-c54a-99c6bc83eafd@oracle.com>
Date:   Sun, 17 Nov 2019 17:02:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0gyszPOvUxd8WX8gxc1OvX_nLUGh3vKn=aXWRj52L76yw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9443 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911170086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9443 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911170087
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/11/15 18:26, Rafael J. Wysocki wrote:
> On Wed, Nov 6, 2019 at 12:56 PM Zhenzhong Duan
> <zhenzhong.duan@oracle.com> wrote:
>> dev->poll_limit_ns could be zeroed in certain cases (e.g. by
>> guest_halt_poll_ns = 0). If guest_halt_poll_grow_start is zero,
>> dev->poll_limit_ns will never be bigger than zero.
> I would rephrase this in the following way:
>
> "If guest_halt_poll_grow_start is zero and dev->poll_limit_ns becomes
> zero for any reason, it will never be greater than zero again, so use
> ..."

OK, will do, thanks for your suggestion.

Zhenzhong

>
> The patch itself looks OK to me.
>
>> Use param callback to avoid writing zero to guest_halt_poll_grow_start.
>>
>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>> ---
>>   drivers/cpuidle/governors/haltpoll.c | 22 +++++++++++++++++++++-
>>   1 file changed, 21 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
>> index 7a703d2..660859d 100644
>> --- a/drivers/cpuidle/governors/haltpoll.c
>> +++ b/drivers/cpuidle/governors/haltpoll.c
>> @@ -20,6 +20,26 @@
>>   #include <linux/module.h>
>>   #include <linux/kvm_para.h>
>>
>> +static int grow_start_set(const char *val, const struct kernel_param *kp)
>> +{
>> +       int ret;
>> +       unsigned int n;
>> +
>> +       if (!val)
>> +               return -EINVAL;
>> +
>> +       ret = kstrtouint(val, 0, &n);
>> +       if (ret || !n)
>> +               return -EINVAL;
>> +
>> +       return param_set_uint(val, kp);
>> +}
>> +
>> +static const struct kernel_param_ops grow_start_ops = {
>> +       .set = grow_start_set,
>> +       .get = param_get_uint,
>> +};
>> +
>>   static unsigned int guest_halt_poll_ns __read_mostly = 200000;
>>   module_param(guest_halt_poll_ns, uint, 0644);
>>
>> @@ -33,7 +53,7 @@
>>
>>   /* value in us to start growing per-cpu halt_poll_ns */
>>   static unsigned int guest_halt_poll_grow_start __read_mostly = 50000;
>> -module_param(guest_halt_poll_grow_start, uint, 0644);
>> +module_param_cb(guest_halt_poll_grow_start, &grow_start_ops, &guest_halt_poll_grow_start, 0644);
>>
>>   /* allow shrinking guest halt poll */
>>   static bool guest_halt_poll_allow_shrink __read_mostly = true;
>> --
>> 1.8.3.1
>>
