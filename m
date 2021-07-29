Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1515B3DA458
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 15:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237890AbhG2NaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 09:30:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46862 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237906AbhG2N3U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 09:29:20 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TD4JLu118166;
        Thu, 29 Jul 2021 09:29:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=hLi+1k3Q2pOofVD6JJ72KnRHLVvkzl1EJJ/kEUSRp6E=;
 b=dtY5UjOe8+eHpAi8FY9nzRi5m8MnI8uwWlt9gpPYlX9UutblUmKSXb9G6NjQsDrpKKHj
 vWYk+QlYwZas2r9FjUzOTUjVKmeriyBmplcvc+842+/FePY1ANWACJUONO3u2hOyW4Nv
 v33PLVEtl24pXD4J72NMdRQLMJMr1UWu1DuUtCgnvy1nKilcvuM/GVSfnPVJMl75HdoI
 78JLTXPUx/AIOE1eEYdeCCTQBYRj89g6UYSdwIQcfvYXHQB1ZMFhNMFfU4X5TjaeFDVG
 kB/VRPOlUBUDbb2m2HgE+gvV/682c4NjCl3W4NP/H/kTlfGUZi6w6f+7bNw/7uWcWPSA vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a3v5s2t2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:29:16 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16TD4Xru119820;
        Thu, 29 Jul 2021 09:29:16 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a3v5s2t1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:29:16 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16TDIw2R013339;
        Thu, 29 Jul 2021 13:29:14 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3a235m1qwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 13:29:14 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16TDQQDh33554826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 13:26:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8854A4068;
        Thu, 29 Jul 2021 13:29:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B80DA4060;
        Thu, 29 Jul 2021 13:29:10 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.151])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 13:29:10 +0000 (GMT)
Date:   Thu, 29 Jul 2021 14:52:04 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/13] KVM: s390: pv: avoid stall notifications for
 some UVCs
Message-ID: <20210729145204.2d8c1430@p-imbrenda>
In-Reply-To: <6bbeded3-ef94-6c83-f093-796d76b70792@linux.ibm.com>
References: <20210728142631.41860-1-imbrenda@linux.ibm.com>
        <20210728142631.41860-2-imbrenda@linux.ibm.com>
        <6bbeded3-ef94-6c83-f093-796d76b70792@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gK13XRLPxf-tCKcnhGqyx5OsBHWFH6__
X-Proofpoint-GUID: BhRXjfRSW6J1HrsUV3U88QBodu2a0cCS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Jul 2021 11:58:39 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 7/28/21 4:26 PM, Claudio Imbrenda wrote:
> > Improve make_secure_pte to avoid stalls when the system is heavily
> > overcommitted. This was especially problematic in
> > kvm_s390_pv_unpack, because of the loop over all pages that needed
> > unpacking.
> > 
> > Also fix kvm_s390_pv_init_vm to avoid stalls when the system is
> > heavily overcommitted.  
> 
> Fixes tag?

will be in the next version

> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/kernel/uv.c | 11 ++++++++---
> >  arch/s390/kvm/pv.c    |  2 +-
> >  2 files changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> > index aeb0a15bcbb7..fd0faa51c1bb 100644
> > --- a/arch/s390/kernel/uv.c
> > +++ b/arch/s390/kernel/uv.c
> > @@ -196,11 +196,16 @@ static int make_secure_pte(pte_t *ptep,
> > unsigned long addr, if (!page_ref_freeze(page, expected))
> >  		return -EBUSY;
> >  	set_bit(PG_arch_1, &page->flags);
> > -	rc = uv_call(0, (u64)uvcb);
> > +	rc = __uv_call(0, (u64)uvcb);  
> 
> We should exchange rc with cc since that's what we get back from
> __uv_call(). Technically we always get a cc but for the other
> functions it's only ever 0/1 which translates to success/error so rc
> is ok.

will be in the next version

> >  	page_ref_unfreeze(page, expected);
> > -	/* Return -ENXIO if the page was not mapped, -EINVAL
> > otherwise */
> > -	if (rc)
> > +	/*
> > +	 * Return -ENXIO if the page was not mapped, -EINVAL for
> > other errors.
> > +	 * If busy or partially completed, return -EAGAIN.
> > +	 */
> > +	if (rc == 1)
> >  		rc = uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
> > +	else if (rc > 1)
> > +		rc = -EAGAIN;
> >  	return rc;  
> 
> Could you define the CCs in uv.h and check against the constants here
> so it's easier to understand that the rc > 1 checks against a "UV was
> busy please re-issue the call again" cc?
>
> Maybe also make it explicit for cc 2 and 3 instead of cc > 1

will be in the next version

> >  }
> >  
> > diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> > index c8841f476e91..e007df11a2fe 100644
> > --- a/arch/s390/kvm/pv.c
> > +++ b/arch/s390/kvm/pv.c
> > @@ -196,7 +196,7 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16
> > *rc, u16 *rrc) uvcb.conf_base_stor_origin =
> > (u64)kvm->arch.pv.stor_base; uvcb.conf_virt_stor_origin =
> > (u64)kvm->arch.pv.stor_var; 
> > -	cc = uv_call(0, (u64)&uvcb);
> > +	cc = uv_call_sched(0, (u64)&uvcb);
> >  	*rc = uvcb.header.rc;
> >  	*rrc = uvcb.header.rrc;
> >  	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len
> > %llx rc %x rrc %x", 
> 

