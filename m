Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8F636D44B
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 10:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236805AbhD1I4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 04:56:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63598 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229643AbhD1I4L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 04:56:11 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13S8YTXV129192;
        Wed, 28 Apr 2021 04:54:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Tp0edf/2acg6WFqoQDlzR28/GgvSqWKs66oAahEjRQc=;
 b=Mifayfwo7VyhKGVY2WPb0tKsypYRPE44bHAPZruA+S3qjFYx4GhIrkFB1E5Zm1/s5HbS
 kKXTn1KHSklZYX/KuvAibTulJ9j3LnT0fTT+QEfyQKVGlo+belSgH3lrk5VQeseWSnFJ
 ml2XYhGwk34qLrPYrPJAIld8BgwtmYi+KM01XppdfQ26IZ992rfCt0opWltjLDsx6VUy
 QVyS/4gOf7AqsrH2GB0k+AFDsVa85WTqMEvcMykGaYo0Om2rgLJPcS3jAyPrGOEWClnA
 9UpEFvyMyETI2VijpJJy19ZzmEN/IL7QTRJnz4IMxLJFYre6i2mMeJz8FFWEK5fSTH5S Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38740t90ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 04:54:45 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13S8Yg53129733;
        Wed, 28 Apr 2021 04:54:44 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38740t90ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 04:54:44 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13S8pjgE005706;
        Wed, 28 Apr 2021 08:54:42 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 384ay8s04c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 08:54:42 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13S8sdtp41877800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Apr 2021 08:54:39 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3153A4060;
        Wed, 28 Apr 2021 08:54:38 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32DCFA405C;
        Wed, 28 Apr 2021 08:54:38 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.77.184])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Apr 2021 08:54:38 +0000 (GMT)
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
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <cf2a6c6c-21ea-df7b-94d1-940a344b8d26@de.ibm.com>
Date:   Wed, 28 Apr 2021 10:54:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YIkgzUWEPaXQTCOv@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9mrNRjeyjN8gAGXrrEdil-zwPEDmAhGP
X-Proofpoint-ORIG-GUID: 7A4D5dq6kxNyr7Yih462Yq0uln1QYQIF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-28_03:2021-04-27,2021-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 spamscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104280057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28.04.21 10:46, Peter Zijlstra wrote:
> On Tue, Apr 27, 2021 at 04:59:25PM +0200, Christian Borntraeger wrote:
>> Peter,
>>
>> I just realized that we moved away sysctl tunabled to debugfs in next.
>> We have seen several cases where it was benefitial to set
>> sched_migration_cost_ns to a lower value. For example with KVM I can
>> easily get 50% more transactions with 50000 instead of 500000.
>> Until now it was possible to use tuned or /etc/sysctl.conf to set
>> these things permanently.
>>
>> Given that some people do not want to have debugfs mounted all the time
>> I would consider this a regression. The sysctl tunable was always
>> available.
>>
>> I am ok with the "informational" things being in debugfs, but not
>> the tunables. So how do we proceed here?
> 
> It's all SCHED_DEBUG; IOW you're relying on DEBUG infrastructure for
> production performance, and that's your fail.

No its not. sched_migration_cost_ns was NEVER protected by CONFIG_SCHED_DEBUG.
It was available on all kernels with CONFIG_SMP.

> 
> I very explicitly do not care to support people that poke random values
> into those 'tunables'. If people wants to do that, they get to keep any
> and all pieces.
> 
> The right thing to do here is to analyze the situation and determine why
> migration_cost needs changing; is that an architectural thing, does s390
> benefit from less sticky tasks due to its cache setup (the book caches
> could be absorbing some of the penalties here for example). Or is it
> something that's workload related, does KVM intrinsically not care about
> migrating so much, or is it something else.
> 
> Basically, you get to figure out what the actual performance issue is,
> and then we can look at what to do about it so that everyone benefits,
> and not grow some random tweaks on the interweb that might or might not
> actually work for someone else.

Yes, I agree. We have seen the effect of this value recently and we want
look into that. Still that does not change the fact that you are removing
an interface that was there for ages.
