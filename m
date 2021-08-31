Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E16A3FCA72
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 17:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhHaPBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 11:01:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8758 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230237AbhHaPBa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Aug 2021 11:01:30 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17VEXgOX052678;
        Tue, 31 Aug 2021 11:00:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=RSQq3d/OCX6e+KwInguQOP3701NVqw2TYZjRipujqNM=;
 b=MOFC321WsYTJuNjzi3AZ2idVnvkbn4ThydG7hEdV3q4QSEDGEq40O50yZrCUu+VDLIzu
 p8WGFR/3yrUVlQ/yzkXN79BO+1Xw0ucBc+I7AofY86KsGRjRhdFyIK0biBu33OFdAmpY
 pECXRqb4o5f1/hOvwF4XT+3mvQm4EcFLRM7N2B1mDOq5t5U1joPnJU9RMRB1GgdhSCif
 oEZEXZvDNyvKyjLnPKLbqwGJwjqlaOQK14qv2zatoBpegZ+cyFUFgAi4GgLxtTztJ/IR
 a6PUMY08pfQnc+BYhWJ5uZ4VarRHwrXg99CCYAeteYMkaXz/Nezrcu4+5k9llSj2Kcv7 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3asnbrk3fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 11:00:32 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17VEYKZ6058163;
        Tue, 31 Aug 2021 11:00:32 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3asnbrk3dk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 11:00:32 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17VEhch5001300;
        Tue, 31 Aug 2021 15:00:29 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3aqcs93k2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 15:00:29 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17VEuOAQ56033660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 14:56:24 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A0D7A405F;
        Tue, 31 Aug 2021 15:00:24 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4E6FA4073;
        Tue, 31 Aug 2021 15:00:23 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.243])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 31 Aug 2021 15:00:23 +0000 (GMT)
Date:   Tue, 31 Aug 2021 17:00:20 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: Re: [PATCH v4 04/14] KVM: s390: pv: avoid stalls when making pages
 secure
Message-ID: <20210831170020.7aa4a1ba@p-imbrenda>
In-Reply-To: <731aeb25-3883-5941-9400-7cd8c43fc31c@de.ibm.com>
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
        <20210818132620.46770-5-imbrenda@linux.ibm.com>
        <731aeb25-3883-5941-9400-7cd8c43fc31c@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kIMrMhuxujv6YR_10kdu8yLvoMoQr5jn
X-Proofpoint-ORIG-GUID: 3ALZJTao_-UlUM7k9ExpeqYzb3M1phxN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_07:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108310079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 31 Aug 2021 16:32:24 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 18.08.21 15:26, Claudio Imbrenda wrote:
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
> 
> To me it looks like
> handle_pv_uvc does not handle EAGAIN but also calls into this code. Is this code
> path ok or do we need to change something here?

EAGAIN will be propagated all the way to userspace, which will retry.

if the UVC fails, the page does not get unpinned, and the next attempt
to run the UVC in the guest will trigger this same path.

if you don't like it, I can change handle_pv_uvc like this

	if (rc == -EINVAL || rc == -EAGAIN)

which will save a trip to userspace

> 
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Fixes: 214d9bbcd3a672 ("s390/mm: provide memory management functions for protected KVM guests")
> > ---
> >   arch/s390/kernel/uv.c | 29 +++++++++++++++++++++++------
> >   1 file changed, 23 insertions(+), 6 deletions(-)
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
> >   

