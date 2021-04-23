Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6334C368F6C
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 11:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241717AbhDWJdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 05:33:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25986 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229939AbhDWJdz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 05:33:55 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13N94AmB183133;
        Fri, 23 Apr 2021 05:32:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=ls43Bhvmg/av+jbLzz7/aLd4mS/CPGhhM61MlkiE+wA=;
 b=NwPWHwKLP7omCZ97un+qBGPwWw6tF327tQ//x1W/lnYNfozPWng70eCSWCbyU0lHSa5R
 BfQnR5yk6xSkek0ArDe0qUhY31ucxzLzZBlwt8g4LDqJz2fpnAzuJbng40okzQP37PWQ
 Jt+UUjvKHq+JW3LuT9cTM0mRZZzZ+1j5naj0TYmxaCz8k9kQU0pIn8t/CcZPEyZoYllY
 heOfYIDbWzWOPQuUz3J6k6KtAiJ+U8MuUZsjy+Ya+IGeixecWtQXbOeDqETRiHE4FS+6
 m3QfhKGiqH1ie6dFl57oLbwLgdz0pcfA3ZB+GmiyAE/kTTtUIQpafdjwThRSaHaqaXaI kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 383tqxswam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 05:32:42 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13N9NUgn084705;
        Fri, 23 Apr 2021 05:32:41 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 383tqxsw98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 05:32:41 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13N9WQEx003330;
        Fri, 23 Apr 2021 09:32:39 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 37yt2ru8ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 09:32:39 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13N9WaSZ44499336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Apr 2021 09:32:36 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53C764C04A;
        Fri, 23 Apr 2021 09:32:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB1A64C050;
        Fri, 23 Apr 2021 09:32:35 +0000 (GMT)
Received: from localhost (unknown [9.171.28.167])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 23 Apr 2021 09:32:35 +0000 (GMT)
Date:   Fri, 23 Apr 2021 11:32:34 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Sven Schnelle <svens@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v3 9/9] KVM: Move instrumentation-safe annotations for
 enter/exit to x86 code
Message-ID: <your-ad-here.call-01619170354-ext-2090@work.hours>
References: <20210415222106.1643837-1-seanjc@google.com>
 <20210415222106.1643837-10-seanjc@google.com>
 <0c74158d-279a-5afa-0778-822c77ac8dc2@de.ibm.com>
 <yt9d4kfypeov.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <yt9d4kfypeov.fsf@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CVTcfdrAiltuMym0SPDmpYabxyQpO3oV
X-Proofpoint-GUID: nlrBmLBZz6P_QB0L9eVTwnmkvBPwdEXC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_15:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1011
 adultscore=0 spamscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 impostorscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021 at 04:38:24PM +0200, Sven Schnelle wrote:
> Christian Borntraeger <borntraeger@de.ibm.com> writes:
> 
> > On 16.04.21 00:21, Sean Christopherson wrote:
> >> Drop the instrumentation_{begin,end}() annonations from the common KVM
> >> guest enter/exit helpers, and massage the x86 code as needed to preserve
> >> the necessary annotations.  x86 is the only architecture whose transition
> >> flow is tagged as noinstr, and more specifically, it is the only
> >> architecture for which instrumentation_{begin,end}() can be non-empty.
> >> No other architecture supports CONFIG_STACK_VALIDATION=y, and s390
> >> is the
> >> only other architecture that support CONFIG_DEBUG_ENTRY=y.  For
> >> instrumentation annontations to be meaningful, both aformentioned configs
> >> must be enabled.
> >> Letting x86 deal with the annotations avoids unnecessary nops by
> >> squashing back-to-back instrumention-safe sequences.
> >
> > We have considered implementing objtool for s390. Not sure where we
> > stand and if we will do this or not. Sven/Heiko?
> 
> We are planning to support objtool on s390. Vasily is working on it -
> maybe he has some thoughts about this.

We got CONFIG_DEBUG_ENTRY=y since 5.12, objtool runs on vmlinux.o but I have
not yet enabled --noinstr option in s390 objtool. So, it's hard to say in
advance if this particular change would make things better or worse.
In general, common code annotations are problematic, because arch
specific code is still not identical and this leads sometimes to different
needs for common code annotations.

I'll try to experiment with --noinstr on s390 shortly.
