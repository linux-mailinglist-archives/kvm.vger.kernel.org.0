Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C978956CE5
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 16:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfFZOx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 10:53:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60106 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbfFZOx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 10:53:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QEn0u0115886;
        Wed, 26 Jun 2019 14:52:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=O8gsLAnKvEJnxFFzMobAjm8cu3fNADVN1xEFWlBOGbk=;
 b=NUkq18lOFFDWIv9CTLHNhjC+dTnEhg5+Sp2EPg1lNCYslPeZx79gEYt6+PICxltUHb7x
 4OW7B5GmqcMkuDWq13q9q0VlmCnrsv6KVUfOy6nmNo40x/ImzH52Iwp1jUQ/p0IlaEuU
 Q/mTqg6aRbc5nDqUcfrFWrc1hngRRhNpUzWDZ9LOBQhVZb4C/5p55lqB4fSvmh2lu4Rs
 CStecoPZ+OftnKBUbXPFDpJ+yCH4lCdMJi/XsAi8LeQPvKA/HJIexEIz0t+m5s2ErXyz
 9uJg0qq9NpBrPB+ppBig1llbzOHuXsqEDV6KhekjuyjOcfCjRe1DTuk12NwzkJpoVTb/ IQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t9cyqjsa5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 14:52:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QEqfSM175391;
        Wed, 26 Jun 2019 14:52:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tat7cv8ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 14:52:58 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5QEqnwe005115;
        Wed, 26 Jun 2019 14:52:49 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 07:52:49 -0700
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id 6B9A06A0150; Wed, 26 Jun 2019 10:54:13 -0400 (EDT)
Date:   Wed, 26 Jun 2019 10:54:13 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KarimAllah <karahmed@amazon.de>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: cputime takes cstate into consideration
Message-ID: <20190626145413.GE6753@char.us.oracle.com>
References: <CANRm+Cyge6viybs63pt7W-cRdntx+wfyOq5EWE2qmEQ71SzMHg@mail.gmail.com>
 <alpine.DEB.2.21.1906261211410.32342@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1906261211410.32342@nanos.tec.linutronix.de>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260175
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 26, 2019 at 12:33:30PM +0200, Thomas Gleixner wrote:
> On Wed, 26 Jun 2019, Wanpeng Li wrote:
> > After exposing mwait/monitor into kvm guest, the guest can make
> > physical cpu enter deeper cstate through mwait instruction, however,
> > the top command on host still observe 100% cpu utilization since qemu
> > process is running even though guest who has the power management
> > capability executes mwait. Actually we can observe the physical cpu
> > has already enter deeper cstate by powertop on host. Could we take
> > cstate into consideration when accounting cputime etc?
> 
> If MWAIT can be used inside the guest then the host cannot distinguish
> between execution and stuck in mwait.
> 
> It'd need to poll the power monitoring MSRs on every occasion where the
> accounting happens.
> 
> This completely falls apart when you have zero exit guest. (think
> NOHZ_FULL). Then you'd have to bring the guest out with an IPI to access
> the per CPU MSRs.
> 
> I assume a lot of people will be happy about all that :)

There were some ideas that Ankur (CC-ed) mentioned to me of using the perf
counters (in the host) to sample the guest and construct a better
accounting idea of what the guest does. That way the dashboard
from the host would not show 100% CPU utilization.

But the patches that Marcelo posted (" cpuidle-haltpoll driver") in 
"solves" the problem for Linux. That is the guest wants awesome latency and
one way was to expose MWAIT to the guest, or just tweak the guest to do the
idling a bit different.

Marcelo patches are all good for Linux, but Windows is still an issue.

Ankur, would you be OK sharing some of your ideas?
> 
> Thanks,
> 
> 	tglx
> 
