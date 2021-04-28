Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E683636D9D5
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 16:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239291AbhD1OvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 10:51:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10122 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236514AbhD1OvT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 10:51:19 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13SEWhNI083557;
        Wed, 28 Apr 2021 10:49:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+MDph5yR3gYbc4z7haBiYjH/hMic3Sw60Vgj+9HGaec=;
 b=mb9YVMMZj01Xa68naoO6IhPCxdEPXk79yUFu2lZMm4k8Y+wsbB5JiWMSPS+gmFRYlb8D
 GC16uszM+zQbk3T1+fhwJ1luwTPmNLeFgetiuGUWo7Hvz78X0Uu42IcWs6n2cPGpnSTN
 jziiJLCj1m8u5SKWAM+ChFln9rHuDAw0xV0+aT1iGCN4o+TAO0M9zzaOydJ8hNPhtaB7
 OP6hXTrevFHJhqRyUxGAZAdrBzoTjJlm2QaniKs454MCQT8SOadjZF3anUpJSGxY66Ut
 tCqWEO+SLaZW79IxW2RSfbkmBA0izhxEWeM16NQrExtXci4JTX5Fm3OhLHoLYJvGPTuj Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3879c612yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 10:49:53 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13SEY7qp095552;
        Wed, 28 Apr 2021 10:49:53 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3879c612xs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 10:49:53 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13SEhm14029529;
        Wed, 28 Apr 2021 14:49:50 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 384gjxs21t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 14:49:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13SEnlLV38601106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Apr 2021 14:49:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55D68A405B;
        Wed, 28 Apr 2021 14:49:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D754A405F;
        Wed, 28 Apr 2021 14:49:45 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.77.184])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Apr 2021 14:49:45 +0000 (GMT)
Subject: Re: sched: Move SCHED_DEBUG sysctl to debugfs
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     bristot@redhat.com, bsegall@google.com, dietmar.eggemann@arm.com,
        greg@kroah.com, gregkh@linuxfoundation.org, joshdon@google.com,
        juri.lelli@redhat.com, linux-kernel@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@kernel.org,
        rostedt@goodmis.org, valentin.schneider@arm.com,
        vincent.guittot@linaro.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210412102001.287610138@infradead.org>
 <20210427145925.5246-1-borntraeger@de.ibm.com>
 <YIkgzUWEPaXQTCOv@hirez.programming.kicks-ass.net>
 <da373590-f0d7-e3a2-cef9-4527fc9f3056@de.ibm.com>
 <YIlXQ43b6+7sUl+f@hirez.programming.kicks-ass.net>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <89ccb344-7a03-65e6-826d-4807e1ab2815@de.ibm.com>
Date:   Wed, 28 Apr 2021 16:49:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YIlXQ43b6+7sUl+f@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GKX48hxqsFAcv5mlCEJdq8v7NzUQSymF
X-Proofpoint-GUID: CPDMzAY1Lun_Kjk7BCoCWWMTM9fKYc_1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-28_09:2021-04-28,2021-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104280098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28.04.21 14:38, Peter Zijlstra wrote:
> On Wed, Apr 28, 2021 at 11:42:57AM +0200, Christian Borntraeger wrote:
>> On 28.04.21 10:46, Peter Zijlstra wrote:
>> [..]
>>> The right thing to do here is to analyze the situation and determine why
>>> migration_cost needs changing; is that an architectural thing, does s390
>>> benefit from less sticky tasks due to its cache setup (the book caches
>>> could be absorbing some of the penalties here for example). Or is it
>>> something that's workload related, does KVM intrinsically not care about
>>> migrating so much, or is it something else.
>>
>> So lets focus on the performance issue.
>>
>> One workload where we have seen this is transactional workload that is
>> triggered by external network requests. So every external request
>> triggered a wakup of a guest and a wakeup of a process in the guest.
>> The end result was that KVM was 40% slower than z/VM (in terms of
>> transactions per second) while we had more idle time.
>> With smaller sched_migration_cost_ns (e.g. 100000) KVM was as fast
>> as z/VM.
>>
>> So to me it looks like that the wakeup and reschedule to a free CPU
>> was just not fast enough. It might also depend where I/O interrupts
>> land. Not sure yet.
> 
> So there's unfortunately three places where migration_cost is used; one
> is in {nohz_,}newidle_balance(), see below. Someone tried removing it
> before and that ran into so weird regressions somewhere. But it is worth
> checking if this is the thing that matters for your workload.
> 
> The other (main) use is in task_hot(), where we try and prevent
> migrating tasks that have recently run on a CPU. We already have an
> exception for SMT there, because SMT siblings share all cache levels per
> defintion, so moving it to the sibling should have no ill effect.
> 
> It could be that the current measure is fundamentally too high for your
> machine -- it is basically a random number that was determined many
> years ago on some random x86 machine, so it not reflecting reality today
> on an entirely different platform is no surprise.
> 
> Back in the day, we had some magic code that measured cache latency per
> sched_domain and we used that, but that suffered from boot-to-boot
> variance and made things rather non-deterministic, but the idea of
> having per-domain cost certainly makes sense.
> 
> Over the years people have tried bringing parts of that back, but it
> never really had convincing numbers justifying the complexity. So that's
> another thing you could be looking at I suppose.
> 
> And then finally we have an almost random use in rebalance_domains(),
> and I can't remember the story behind that one :/
> 
> 
> Anyway, TL;DR, try and figure out which of these three is responsible
> for your performance woes. If it's the first, the below patch might be a
> good candidate. If it's task_hot(), we might need to re-eval per domain
> costs. If its that other thing, I'll have to dig to figure out wth that
> was supposed to accomplish ;-)

Thanks for the insight. I will try to find out which of these areas make
a difference here.
[..]
