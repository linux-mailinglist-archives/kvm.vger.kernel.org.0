Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F915478DBC
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 15:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbhLQOXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 09:23:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21722 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237406AbhLQOXP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 09:23:15 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BHEHkYI016472;
        Fri, 17 Dec 2021 14:23:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=T+MmfEqmroqNT+czvb7P6GbZfONsbmETEBPPtvorRiE=;
 b=GzBjBoH7T8UUtr2L7veVCjHFvohuaBx61Ebc4e0Ho5qgtLCopHAwbHmQM7QLbk/mkdor
 Db3Mr8NR1FuBSrk5/Vlms6+ai6lrGVK5Db9JYuh8uM89AdtXFiGmGrnwXs0rKpY9LVdq
 LJ2szwubvB3RQqjkNmAkYjNAEpSh5R33/bPx/Cc4EcUVkDgfIFYO3yNGRJ45f3g/2Vj3
 ZqzMQzilUH7PjB5AToAsaTlnPiC57eD05t4X90g62uMQbwrfz5xGWt1fJWGPZCuyvscP
 5rfDqFHkFpENbFCN1IYmIjHdnnS2XPmmXMMA0QY2sUBn4xLGdQEgWtkXNM1p+71PnonU cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d0v6883qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 14:23:14 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BHEKfm2030721;
        Fri, 17 Dec 2021 14:23:14 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d0v6883qa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 14:23:14 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BHEF1Gt017456;
        Fri, 17 Dec 2021 14:23:12 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3cy7vw0xtw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 14:23:12 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BHEN9Aj42205676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 14:23:09 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4848FA405C;
        Fri, 17 Dec 2021 14:23:09 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4A09A4054;
        Fri, 17 Dec 2021 14:23:08 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.6.194])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Dec 2021 14:23:08 +0000 (GMT)
Date:   Fri, 17 Dec 2021 15:23:05 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com
Subject: Re: [PATCH kvm-unit-tests 1/2] s390x: diag288: Add missing clobber
Message-ID: <20211217152305.2be9c9cf@p-imbrenda>
In-Reply-To: <329aced6-df4f-2802-cbc6-99469c5f9462@linux.ibm.com>
References: <20211217103137.1293092-1-nrb@linux.ibm.com>
        <20211217103137.1293092-2-nrb@linux.ibm.com>
        <3e2035bd-0929-488c-28f3-d8256bec14a4@redhat.com>
        <329aced6-df4f-2802-cbc6-99469c5f9462@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XaCNZVdUMaYAcGtqH_PCJFqqhoO4yuvp
X-Proofpoint-GUID: INKmudSublU5_Yn_whiKHXoMOKxfd6p4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_05,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112170082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Dec 2021 15:16:34 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 12/17/21 14:47, Thomas Huth wrote:
> > On 17/12/2021 11.31, Nico Boehr wrote:  
> >> We clobber r0 and thus should let the compiler know we're doing so.
> >>
> >> Because we change from basic to extended ASM, we need to change the
> >> register names, as %r0 will be interpreted as a token in the assembler
> >> template.
> >>
> >> For consistency, we align with the common style in kvm-unit-tests which
> >> is just 0.
> >>
> >> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> >> ---
> >>    s390x/diag288.c | 7 ++++---
> >>    1 file changed, 4 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/s390x/diag288.c b/s390x/diag288.c
> >> index 072c04a5cbd6..da7b06c365bf 100644
> >> --- a/s390x/diag288.c
> >> +++ b/s390x/diag288.c
> >> @@ -94,11 +94,12 @@ static void test_bite(void)
> >>    	/* Arm watchdog */
> >>    	lc->restart_new_psw.mask = extract_psw_mask() & ~PSW_MASK_EXT;
> >>    	diag288(CODE_INIT, 15, ACTION_RESTART);
> >> -	asm volatile("		larl	%r0, 1f\n"
> >> -		     "		stg	%r0, 424\n"
> >> +	asm volatile("		larl	0, 1f\n"
> >> +		     "		stg	0, 424\n"  
> > 
> > Would it work to use %%r0 instead?  
> 
> Yes, but I told him that looks weird, so that one is on me.
> @claudio @thomas What's your preferred way of dealing with this?

I would prefer just 0 since that's what we use everywhere else too,
but I won't oppose %%r0 if there are strong arguments for it (but then
we need to decide a policy and stick to it)

> 
> >   
> >>    		     "0:	nop\n"
> >>    		     "		j	0b\n"
> >> -		     "1:");
> >> +		     "1:"
> >> +		     : : : "0");
> >>    	report_pass("restart");
> >>    }  
> > 
> > Anyway:
> > Reviewed-by: Thomas Huth <thuth@redhat.com>
> >   
> 

