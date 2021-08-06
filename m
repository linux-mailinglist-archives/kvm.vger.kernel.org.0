Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5639E3E2758
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 11:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244184AbhHFJfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 05:35:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53732 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231553AbhHFJfL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Aug 2021 05:35:11 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1769Y826107788;
        Fri, 6 Aug 2021 05:34:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=3N1ANuGehQP50JYQGMKyzDGlpKf1Q5tikfCuzLVOuDY=;
 b=EnXYc+MGpwvYLB3WwYdqN8RSjAfSjbSDrK9+U3F/6CT5QoZa1d9XvSugCNcE7cCT9LGY
 8itp/xxtPEm1i7sueVLtHfeZvPdncXM17P4mO9+WU/st+uZzTa4Q2cF/43fqXX0iIQ+T
 jPh80nHBk1iMquUCvLLVCuRPNhPFbYslTXDJRZnkYgWlUwevhTvzKIuQ8UmqoGcuhwoq
 a5dy7EpF1NXesoK8p2gnrPlDGKEE08HxEpFn8Ub2/6p6BItWPl8jEGPCd5S+8QFzo4Wy
 RPWIOwsSb1FmLKTG3F9mA5LCihjpsynHo79ICCht4wWHX0Wqjte36qf/hSTpn5ep+PFe KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a8m9ukwkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 05:34:55 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1769YEIv108199;
        Fri, 6 Aug 2021 05:34:55 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a8m9ukwk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 05:34:55 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1769VrnJ007629;
        Fri, 6 Aug 2021 09:34:53 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3a4wshvyf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 09:34:53 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1769Ynn556361348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Aug 2021 09:34:49 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED78D4205E;
        Fri,  6 Aug 2021 09:34:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BD6B4204F;
        Fri,  6 Aug 2021 09:34:48 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.6.208])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Aug 2021 09:34:48 +0000 (GMT)
Date:   Fri, 6 Aug 2021 11:33:25 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: Re: [PATCH v3 02/14] KVM: s390: pv: avoid stall notifications for
 some UVCs
Message-ID: <20210806113325.51279c4c@p-imbrenda>
In-Reply-To: <7ef282bb-d90f-9cbb-678b-4293790fb8c6@redhat.com>
References: <20210804154046.88552-1-imbrenda@linux.ibm.com>
        <20210804154046.88552-3-imbrenda@linux.ibm.com>
        <7ef282bb-d90f-9cbb-678b-4293790fb8c6@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PwUKpNAF2UG9b-gCw-m3CuWXIXWUCsC2
X-Proofpoint-ORIG-GUID: pRwNuTELVZAyWv-7QB42H4KYKu7I1Wz-
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-06_02:2021-08-05,2021-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108060067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Aug 2021 09:30:04 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 04.08.21 17:40, Claudio Imbrenda wrote:
> > Improve make_secure_pte to avoid stalls when the system is heavily
> > overcommitted. This was especially problematic in
> > kvm_s390_pv_unpack, because of the loop over all pages that needed
> > unpacking.
> > 
> > Also fix kvm_s390_pv_init_vm to avoid stalls when the system is
> > heavily overcommitted.  
> 
> I suggest splitting this change into a separate patch and adding a
> bit more meat to the description why using the other variant is
> possible in the called context. I was kind of surprise to find that
> change buried in this patch.
> 
> Then, you can give both patches a more descriptive patch subject.

fair enough, I'll split them

> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Fixes: 214d9bbcd3a672 ("s390/mm: provide memory management
> > functions for protected KVM guests") ---
> >   arch/s390/kernel/uv.c | 29 +++++++++++++++++++++++------
> >   arch/s390/kvm/pv.c    |  2 +-
> >   2 files changed, 24 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> > index aeb0a15bcbb7..68a8fbafcb9c 100644
> > --- a/arch/s390/kernel/uv.c
> > +++ b/arch/s390/kernel/uv.c
> > @@ -180,7 +180,7 @@ static int make_secure_pte(pte_t *ptep,
> > unsigned long addr, {
> >   	pte_t entry = READ_ONCE(*ptep);
> >   	struct page *page;
> > -	int expected, rc = 0;
> > +	int expected, cc = 0;
> >   
> >   	if (!pte_present(entry))
> >   		return -ENXIO;
> > @@ -196,12 +196,25 @@ static int make_secure_pte(pte_t *ptep,
> > unsigned long addr, if (!page_ref_freeze(page, expected))
> >   		return -EBUSY;
> >   	set_bit(PG_arch_1, &page->flags);
> > -	rc = uv_call(0, (u64)uvcb);
> > +	/*
> > +	 * If the UVC does not succeed or fail immediately, we
> > don't want to
> > +	 * loop for long, or we might get stall notifications.
> > +	 * On the other hand, this is a complex scenario and we
> > are holding a lot of
> > +	 * locks, so we can't easily sleep and reschedule. We try
> > only once,
> > +	 * and if the UVC returned busy or partial completion, we
> > return
> > +	 * -EAGAIN and we let the callers deal with it.
> > +	 */
> > +	cc = __uv_call(0, (u64)uvcb);
> >   	page_ref_unfreeze(page, expected);
> > -	/* Return -ENXIO if the page was not mapped, -EINVAL
> > otherwise */
> > -	if (rc)
> > -		rc = uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
> > -	return rc;
> > +	/*
> > +	 * Return -ENXIO if the page was not mapped, -EINVAL for
> > other errors.
> > +	 * If busy or partially completed, return -EAGAIN.
> > +	 */
> > +	if (cc == UVC_CC_OK)
> > +		return 0;
> > +	else if (cc == UVC_CC_BUSY || cc == UVC_CC_PARTIAL)
> > +		return -EAGAIN;
> > +	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
> >   }  
> 
> That looks conceptually like the right thing to me.
> 

