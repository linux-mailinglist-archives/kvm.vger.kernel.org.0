Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2151D42425C
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 18:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239352AbhJFQQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 12:16:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33992 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232004AbhJFQQy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 12:16:54 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 196FbJOU012188;
        Wed, 6 Oct 2021 12:15:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=IOCt3ebMzZB6KlH1GgT1rYe6xQXAd1+YICWeGDfKGJM=;
 b=jUk1AE0L8tTJyQVdeOo0KDCrLgwSuan7curFfF44YLusJsbCgJsDBEvGQZ5aIxKnbL55
 DpQaxJ1ecZahFxx0CyWe86K8kvBp/ECZ3+s7DHsuLFiT32Gh+UMn+0MHxHWtH0v8Xt9z
 /Q+rxMw1aVa3QSumTYwxTY5aQiouEYcFDXS01DLSVTcRI4YJjJ9mL1t7nIGteeYsYvBZ
 QnT39JCufWFgxxRZV6trDpl2pG/bwpP/UTbIa0HMtdc8R7LoCSLAsfbn/wydhZtIe5J6
 ATfd8iTuLuZtDH4TaionfLXJeKQ2vuA3NFWNpyWdFTlg262UQPkX967gh2qqOehe4xL6 OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bh8cb3atc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 12:15:01 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 196FbeUQ013284;
        Wed, 6 Oct 2021 12:15:01 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bh8cb3asp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 12:15:00 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 196GCjcd009856;
        Wed, 6 Oct 2021 16:14:59 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3bef2achpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 16:14:59 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 196G9SMp60293416
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Oct 2021 16:09:28 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B81CAE056;
        Wed,  6 Oct 2021 16:14:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5527BAE045;
        Wed,  6 Oct 2021 16:14:47 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.200])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 Oct 2021 16:14:47 +0000 (GMT)
Date:   Wed, 6 Oct 2021 18:14:44 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: Re: [PATCH v5 04/14] KVM: s390: pv: avoid stalls when making pages
 secure
Message-ID: <20211006181444.532a1e43@p-imbrenda>
In-Reply-To: <f1c3068c-6fa4-02e3-1513-464694660511@de.ibm.com>
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
        <20210920132502.36111-5-imbrenda@linux.ibm.com>
        <f1c3068c-6fa4-02e3-1513-464694660511@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0lkMRY8HT1gZjeFdx466V6JfPsUApLI-
X-Proofpoint-GUID: POmuNy5O8Vt6ClRrrd3JJu5a7SQe8j3f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-06_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 clxscore=1015 adultscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110060101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Oct 2021 17:54:00 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am 20.09.21 um 15:24 schrieb Claudio Imbrenda:
> > Improve make_secure_pte to avoid stalls when the system is heavily
> > overcommitted. This was especially problematic in kvm_s390_pv_unpack,
> > because of the loop over all pages that needed unpacking.
> > 
> > Due to the locks being held, it was not possible to simply replace
> > uv_call with uv_call_sched. A more complex approach was
> > needed, in which uv_call is replaced with __uv_call, which does not
> > loop. When the UVC needs to be executed again, -EAGAIN is returned, and
> > the caller (or its caller) will try again.
> > 
> > When -EAGAIN is returned, the path is the same as when the page is in
> > writeback (and the writeback check is also performed, which is
> > harmless).
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Fixes: 214d9bbcd3a672 ("s390/mm: provide memory management functions for protected KVM guests")
> > ---
> >   arch/s390/kernel/uv.c     | 29 +++++++++++++++++++++++------
> >   arch/s390/kvm/intercept.c |  5 +++++
> >   2 files changed, 28 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> > index aeb0a15bcbb7..68a8fbafcb9c 100644
> > --- a/arch/s390/kernel/uv.c
> > +++ b/arch/s390/kernel/uv.c
> > @@ -180,7 +180,7 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
> >   {
> >   	pte_t entry = READ_ONCE(*ptep);
> >   	struct page *page;
> > -	int expected, rc = 0;
> > +	int expected, cc = 0;
> >   
> >   	if (!pte_present(entry))
> >   		return -ENXIO;
> > @@ -196,12 +196,25 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
> >   	if (!page_ref_freeze(page, expected))
> >   		return -EBUSY;
> >   	set_bit(PG_arch_1, &page->flags);
> > -	rc = uv_call(0, (u64)uvcb);
> > +	/*
> > +	 * If the UVC does not succeed or fail immediately, we don't want to
> > +	 * loop for long, or we might get stall notifications.
> > +	 * On the other hand, this is a complex scenario and we are holding a lot of
> > +	 * locks, so we can't easily sleep and reschedule. We try only once,
> > +	 * and if the UVC returned busy or partial completion, we return
> > +	 * -EAGAIN and we let the callers deal with it.
> > +	 */
> > +	cc = __uv_call(0, (u64)uvcb);
> >   	page_ref_unfreeze(page, expected);
> > -	/* Return -ENXIO if the page was not mapped, -EINVAL otherwise */
> > -	if (rc)
> > -		rc = uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
> > -	return rc;
> > +	/*
> > +	 * Return -ENXIO if the page was not mapped, -EINVAL for other errors.
> > +	 * If busy or partially completed, return -EAGAIN.
> > +	 */
> > +	if (cc == UVC_CC_OK)
> > +		return 0;
> > +	else if (cc == UVC_CC_BUSY || cc == UVC_CC_PARTIAL)
> > +		return -EAGAIN;
> > +	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
> >   }
> >   
> >   /*
> > @@ -254,6 +267,10 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
> >   	mmap_read_unlock(gmap->mm);
> >   
> >   	if (rc == -EAGAIN) {
> > +		/*
> > +		 * If we are here because the UVC returned busy or partial
> > +		 * completion, this is just a useless check, but it is safe.
> > +		 */
> >   		wait_on_page_writeback(page);
> >   	} else if (rc == -EBUSY) {
> >   		/*
> > diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> > index 72b25b7cc6ae..47833ade4da5 100644
> > --- a/arch/s390/kvm/intercept.c
> > +++ b/arch/s390/kvm/intercept.c
> > @@ -516,6 +516,11 @@ static int handle_pv_uvc(struct kvm_vcpu *vcpu)
> >   	 */
> >   	if (rc == -EINVAL)
> >   		return 0;
> > +	/*
> > +	 * If we got -EAGAIN here, we simply return it. It will eventually
> > +	 * get propagated all the way to userspace, which should then try
> > +	 * again.
> > +	 */  
> 
> This cpoment is new over v4, right? Can this happen often? If not then this is ok
> otherwise we should consider your proposal of doing

yes, the comment is new. I would expect this to happen only when the
system is under load. in any case this is better than busy waiting on
the UVC

> 
> if (rc == -EINVAL || rc == -EAGAIN)
> 
> to reduce overhead.
> 
> Anyway,for both ways
> 
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> >   	return rc;
> >   }
> >   
> >   

