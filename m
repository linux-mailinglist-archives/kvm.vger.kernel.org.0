Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5661FF896
	for <lists+kvm@lfdr.de>; Sun, 17 Nov 2019 09:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbfKQI6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Nov 2019 03:58:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46442 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfKQI6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Nov 2019 03:58:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAH8s1vQ149506;
        Sun, 17 Nov 2019 08:58:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=1u2ztYk0IAZBqMVrZBfzmUSNb952oa7sXB/iqEXknJY=;
 b=VMwFC2wdsmFrI9HYJJbWusT9LsBuCZvVRQRFwi5oC9iGxyYu5yzBnsIEJJjsFMSRLwX9
 RksFjmNvtpGvTHFa5ZRzxRBMhI0x/iS2Jez0vY3OpFzw7qi3/JtbSYXaO6sg031heWAI
 D0bwQUx1dKZhRhDTE1QsKcKCkTMxMmiTKmG+doN+ca/WmQZnfxIPjA5CCRqYl5WnQaPc
 U3nqZwbQeI5nk1NxxaAD8g61ikEVV1S6MmXmj5ciGUVObua3GLAh0SfXyi+ysYw7vqYX
 uHrhAcR8/ld84YKWFiPEqDVTtx5TovfZNnK+0IwjDiGr66kk3J1beRBTekGwAqSQwD3m ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wa92pb82k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Nov 2019 08:58:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAH8r51U126207;
        Sun, 17 Nov 2019 08:58:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2watmhf52v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Nov 2019 08:58:09 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAH8w3uN019422;
        Sun, 17 Nov 2019 08:58:03 GMT
Received: from [10.191.18.30] (/10.191.18.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 17 Nov 2019 00:58:03 -0800
Subject: Re: [PATCH RESEND v2 3/4] cpuidle-haltpoll: ensure cpu_halt_poll_us
 in right scope
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, rafael.j.wysocki@intel.com,
        joao.m.martins@oracle.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, linux-pm@vger.kernel.org
References: <1573041302-4904-1-git-send-email-zhenzhong.duan@oracle.com>
 <1573041302-4904-4-git-send-email-zhenzhong.duan@oracle.com>
 <6161954.sKiXg2khOt@kreacher>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <5ff7cb30-b6fb-d9df-ee8d-bf21b95c9cb1@oracle.com>
Date:   Sun, 17 Nov 2019 16:57:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <6161954.sKiXg2khOt@kreacher>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9443 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911170086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9443 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911170086
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/11/15 18:45, Rafael J. Wysocki wrote:

> On Wednesday, November 6, 2019 12:55:01 PM CET Zhenzhong Duan wrote:
>> As user can adjust guest_halt_poll_grow_start and guest_halt_poll_ns
>> which leads to cpu_halt_poll_us beyond the two boundaries. This patch
>> ensures cpu_halt_poll_us in that scope.
>>
>> If guest_halt_poll_shrink is 0, shrink the cpu_halt_poll_us to
>> guest_halt_poll_grow_start instead of 0. To disable poll we can set
>> guest_halt_poll_ns to 0.
>>
>> If user wrongly set guest_halt_poll_grow_start > guest_halt_poll_ns > 0,
>> guest_halt_poll_ns take precedency and poll time is a fixed value of
>> guest_halt_poll_ns.
>>
>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>> ---
>>   drivers/cpuidle/governors/haltpoll.c | 28 +++++++++++++---------------
>>   1 file changed, 13 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
>> index 660859d..4a39df4 100644
>> --- a/drivers/cpuidle/governors/haltpoll.c
>> +++ b/drivers/cpuidle/governors/haltpoll.c
>> @@ -97,32 +97,30 @@ static int haltpoll_select(struct cpuidle_driver *drv,
>>   
>>   static void adjust_poll_limit(struct cpuidle_device *dev, unsigned int block_us)
>>   {
>> -	unsigned int val;
>> +	unsigned int val = dev->poll_limit_ns;
> Not necessary to initialize it here.

Then an random val may bypass all the check and get assigned to dev->poll_limit_ns

if guest_halt_poll_grow_start< block_ns< uninitialized val< guest_halt_poll_ns

With my change, dev->poll_limit_ns will not be changed in that case, logic same as original code.

>
>>   	u64 block_ns = block_us*NSEC_PER_USEC;
>>   
>>   	/* Grow cpu_halt_poll_us if
>> -	 * cpu_halt_poll_us < block_ns < guest_halt_poll_us
>> +	 * cpu_halt_poll_us < block_ns <= guest_halt_poll_us
> You could update the comment to say "dev->poll_limit_ns" instead of
> "cpu_halt_poll_us" while at it.

Will do, also guest_halt_poll_us to guest_halt_poll_ns

>
>>   	 */
>> -	if (block_ns > dev->poll_limit_ns && block_ns <= guest_halt_poll_ns) {
>> +	if (block_ns > dev->poll_limit_ns && block_ns <= guest_halt_poll_ns &&
>> +	    guest_halt_poll_grow)
> The "{" brace is still needed as per the coding style and I'm not sure why
> to avoid guest_halt_poll_grow equal to zero here?

Will add "{}" and remove guest_halt_poll_grow check. My inital thought was to prevent

dev->poll_limit_ns get shrinked with guest_halt_poll_grow=0.

>
>>   		val = dev->poll_limit_ns * guest_halt_poll_grow;
>> -
>> -		if (val < guest_halt_poll_grow_start)
>> -			val = guest_halt_poll_grow_start;
>> -		if (val > guest_halt_poll_ns)
>> -			val = guest_halt_poll_ns;
>> -
>> -		dev->poll_limit_ns = val;
>> -	} else if (block_ns > guest_halt_poll_ns &&
>> -		   guest_halt_poll_allow_shrink) {
>> +	else if (block_ns > guest_halt_poll_ns &&
>> +		 guest_halt_poll_allow_shrink) {
>>   		unsigned int shrink = guest_halt_poll_shrink;
>>   
>> -		val = dev->poll_limit_ns;
>>   		if (shrink == 0)
>> -			val = 0;
>> +			val = guest_halt_poll_grow_start;
> That's going to be corrected below, so the original code would be fine.

val was assigned twice using 'val = 0' while it's once with my change, optimal a bit?

>
>>   		else
>>   			val /= shrink;
> Here you can do
>
> 			val = dev->poll_limit_ns / shrink;

Any special reason？Looks no difference for me.

>
>> -		dev->poll_limit_ns = val;
>>   	}
>> +	if (val < guest_halt_poll_grow_start)
>> +		val = guest_halt_poll_grow_start;
> Note that guest_halt_poll_grow_start is in us (as per the comment next to its
> definition and the initial value).  That is a bug in the original code too,
> but anyway.

Good catch! will fix the comment. The default 50000ns vs 50000us, looks author means ns.
guest_halt_poll_ns defaults to 200000, also hints ns for guest_halt_poll_grow_start.

Thanks

Zhenzhong

