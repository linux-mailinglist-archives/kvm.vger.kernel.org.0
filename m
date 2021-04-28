Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F9336D4D0
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 11:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238023AbhD1JdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 05:33:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26970 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230113AbhD1JdF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 05:33:05 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13S93vxX124524;
        Wed, 28 Apr 2021 05:31:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=btYEloHK0BDOl3YUFoyRHSZiZbjGJtxaduAuivbpMcU=;
 b=eVlM5mAVHXMbm/jgMUW7UqzwqPDtZsjUyFkTdBkXkUVvQzzptWuy327CbbvWcxC1mM+U
 wS2m+lsiLPIsB4ZQa5YqKQiL00x34EHnHP4Cj6Sc3PeDAJ2pcoXJQOkMEKOIwD4nB0ce
 tB8gm+w/QaTVyEjWw1SgbwffdYh4UqSvtJ321aeCUHB7eRrGLFqz09Fp5p+1yQXEqcvC
 RNvWxATi7n76tPhsqO/J4MvEq7TDWCOGM1tEWndx/SQb4mqWXSvX3vp+QwZhPP3vpAeM
 QieiIy3dCFwmaykwZnmLrUnSNhHBUEqjK8PuQ+KF+cDhU5U70iVwW1VnRoKA4a86TcEM og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3874mx8y47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 05:31:41 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13S95BUG134079;
        Wed, 28 Apr 2021 05:31:41 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3874mx8y3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 05:31:41 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13S9Rhat014735;
        Wed, 28 Apr 2021 09:31:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 384akh9su5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 09:31:38 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13S9VZj528311830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Apr 2021 09:31:36 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D75BCA405C;
        Wed, 28 Apr 2021 09:31:35 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8059A4054;
        Wed, 28 Apr 2021 09:31:34 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.77.184])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Apr 2021 09:31:34 +0000 (GMT)
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
 <cf2a6c6c-21ea-df7b-94d1-940a344b8d26@de.ibm.com>
 <YIkp/6/NDL7KsvpY@hirez.programming.kicks-ass.net>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <2326ce94-3707-b099-4fe8-c79547bd8e25@de.ibm.com>
Date:   Wed, 28 Apr 2021 11:31:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YIkp/6/NDL7KsvpY@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rcj_GYXrVcyKoaoaSbUMxbF98QFld4ox
X-Proofpoint-GUID: XAA5ieffU6naM4zQX3nA2hP0P-aUZIKs
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-28_03:2021-04-27,2021-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=992 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104280062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28.04.21 11:25, Peter Zijlstra wrote:
> On Wed, Apr 28, 2021 at 10:54:37AM +0200, Christian Borntraeger wrote:
>>
>>
>> On 28.04.21 10:46, Peter Zijlstra wrote:
>>> On Tue, Apr 27, 2021 at 04:59:25PM +0200, Christian Borntraeger wrote:
>>>> Peter,
>>>>
>>>> I just realized that we moved away sysctl tunabled to debugfs in next.
>>>> We have seen several cases where it was benefitial to set
>>>> sched_migration_cost_ns to a lower value. For example with KVM I can
>>>> easily get 50% more transactions with 50000 instead of 500000.
>>>> Until now it was possible to use tuned or /etc/sysctl.conf to set
>>>> these things permanently.
>>>>
>>>> Given that some people do not want to have debugfs mounted all the time
>>>> I would consider this a regression. The sysctl tunable was always
>>>> available.
>>>>
>>>> I am ok with the "informational" things being in debugfs, but not
>>>> the tunables. So how do we proceed here?
>>>
>>> It's all SCHED_DEBUG; IOW you're relying on DEBUG infrastructure for
>>> production performance, and that's your fail.
>>
>> No its not. sched_migration_cost_ns was NEVER protected by CONFIG_SCHED_DEBUG.
>> It was available on all kernels with CONFIG_SMP.
> 
> The relevant section from origin/master:kernel/sysctl.c:

[...]
> How is migration_cost not under SCHED_DEBUG? The bigger problem is that
> world+dog has SCHED_DEBUG=y in their .config.

Hmm, yes my bad. I disabled it but it was silently reenabled due to a
dependency. So yes you are right, it is under SCHED_DEBUG.
