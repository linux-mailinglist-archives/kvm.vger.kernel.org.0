Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB2F36C883
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 17:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbhD0PTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 11:19:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63730 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235659AbhD0PTJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 11:19:09 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13RF5WOq078713;
        Tue, 27 Apr 2021 11:17:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=15y1mYdOqZDhvaUTkeGjtPkIrb+NclH60/6bu+vDob0=;
 b=UIJU+hjmbZ7Li3H4LXdNdjcvcj+5xhhKov3LrsnJXihEReOBy2IpLj4hv344ulagKADs
 eXL8tCxmxVFGJ2A/d0OPFlOApHmKC5TqEPoWyJxOjlXNskCFdRNB5tF0iazgPzgMUnFc
 IgloiHl4P3UsUYJQnLWz4odgDhbB+ui2ciQ89gBqTIVtqcU/nCcEhb8tJIS1mqPn97Zw
 BZ22GWLFeZ34/dBfYKDRlppJxmenXlMKyX3yqFHhsXxllitW/TzPUm8mTWabZkBo7OEH
 XRGdR6hg+iqKL6QUd4LISZx+MScOtdyxMICDP5HwxmBb8fA61SP7QIQu/BpD1jQdwjEx Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 386ksjk5m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 11:17:47 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13RF6g51086258;
        Tue, 27 Apr 2021 11:17:46 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 386ksjk5k3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 11:17:46 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13RFHifK016747;
        Tue, 27 Apr 2021 15:17:44 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 384akh9dwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 15:17:44 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13RFGjx629491698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 15:16:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 280DCAE04D;
        Tue, 27 Apr 2021 15:17:10 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5584BAE045;
        Tue, 27 Apr 2021 15:17:09 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.69.120])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Apr 2021 15:17:09 +0000 (GMT)
Subject: Re: sched: Move SCHED_DEBUG sysctl to debugfs
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     peterz@infradead.org, bristot@redhat.com, bsegall@google.com,
        dietmar.eggemann@arm.com, greg@kroah.com,
        gregkh@linuxfoundation.org, joshdon@google.com,
        juri.lelli@redhat.com, linux-kernel@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@kernel.org,
        valentin.schneider@arm.com, vincent.guittot@linaro.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20210412102001.287610138@infradead.org>
 <20210427145925.5246-1-borntraeger@de.ibm.com>
 <20210427110926.24f41fbb@gandalf.local.home>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <ae04549f-b009-9d90-d312-5c544f5a5e14@de.ibm.com>
Date:   Tue, 27 Apr 2021 17:17:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210427110926.24f41fbb@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8LnwMr35GvdP4-iKrSuyQ1vsFGyXLnDn
X-Proofpoint-GUID: 8p0vcg5TR-O8GTMPBnw3xzhxG9KNmE4H
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-27_08:2021-04-27,2021-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104270107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27.04.21 17:09, Steven Rostedt wrote:
> On Tue, 27 Apr 2021 16:59:25 +0200
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
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
> Should there be a schedfs created?
> 
> This is the reason I created the tracefs file system, was to get the
> tracing code out of debugfs, as debugfs is a catch all for everything and
> can lead to poor and insecure interfaces that people do not want to add on
> systems that they still want tracing on.
> 
> Or perhaps we should add a "tunefs" for tunables that are stable interfaces
> that should not be in /proc but also not in debugfs.

Yes, a tunefs or schedfs could be considered a replacement for sysctl.
It will still break existing setups with kernel.sched* things in /etc/sysctl.conf
but at least there is a stable transition path.


