Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AFE3DA442
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 15:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237796AbhG2N3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 09:29:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28574 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237879AbhG2N3R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 09:29:17 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TD3j8l140775;
        Thu, 29 Jul 2021 09:29:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=D+Krm7wEIcHILJq+e+8dlm/GDNOuGXd8hlsV+fg3L+A=;
 b=B7gZZ8KPJ6x+FDNpG73yB/sMdKfunQMVQzsnr0X/HF6xMmAO/I2zQaUI6ho3+MNFFnNM
 wE4HP2SYXyD07ro9Huo0mT3UqyQLRMB4FLcVw/zNDqDl7ehzSUBUMaJePPgtCPc1jL8s
 6fTDUd2eLRHbe/BKIknAwJnGJilACNRWMbW3wxuA50k3/R4+UwRX0+vxnsc7U0Mv9R3j
 qzXYutg8ileIwhHsgVr5xpzHNvmHXr/lko3jXkk08/wG59FGeQJggx2KLoQCK/p3KPVW
 H/8doQpFzIsK8Dm9T4eG86oXodGx3Ewz+3YxtCUpB2ugKiBNNjtNBxULMYZGY/bH8tlH xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3qb6mr28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:29:14 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16TD3xW9142523;
        Thu, 29 Jul 2021 09:29:13 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3qb6mr1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:29:13 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16TDJ3JY029273;
        Thu, 29 Jul 2021 13:29:12 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3a235ks4km-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 13:29:12 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16TDT8uE27787618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 13:29:08 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63408A4054;
        Thu, 29 Jul 2021 13:29:08 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 004F4A405B;
        Thu, 29 Jul 2021 13:29:08 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.151])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 13:29:07 +0000 (GMT)
Date:   Thu, 29 Jul 2021 15:28:35 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/13] KVM: s390: pv: handle secure storage
 exceptions for normal guests
Message-ID: <20210729152835.1f470ba8@p-imbrenda>
In-Reply-To: <103c158c-dba6-7421-af8d-4d771c1cf087@linux.ibm.com>
References: <20210728142631.41860-1-imbrenda@linux.ibm.com>
        <20210728142631.41860-6-imbrenda@linux.ibm.com>
        <103c158c-dba6-7421-af8d-4d771c1cf087@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fsFJnLjPDBwVZnGG07JOHGk5GRJ0EOSH
X-Proofpoint-ORIG-GUID: KXl1dRyg6QSw7fpwRzcobsWec5VHOKce
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 phishscore=0 bulkscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Jul 2021 14:17:11 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 7/28/21 4:26 PM, Claudio Imbrenda wrote:
> > With upcoming patches, normal guests might touch secure pages.
> > 
> > This patch extends the existing exception handler to convert the
> > pages to non secure also when the exception is triggered by a
> > normal guest.
> > 
> > This can happen for example when a secure guest reboots; the first
> > stage of a secure guest is non secure, and in general a secure guest
> > can reboot into non-secure mode.
> > 
> > If the secure memory of the previous boot has not been cleared up
> > completely yet, a non-secure guest might touch secure memory, which
> > will need to be handled properly.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/mm/fault.c | 12 +++++++++++-
> >  1 file changed, 11 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> > index eb68b4f36927..b89d625ea2ec 100644
> > --- a/arch/s390/mm/fault.c
> > +++ b/arch/s390/mm/fault.c
> > @@ -767,6 +767,7 @@ void do_secure_storage_access(struct pt_regs
> > *regs) struct vm_area_struct *vma;
> >  	struct mm_struct *mm;
> >  	struct page *page;
> > +	struct gmap *gmap;
> >  	int rc;
> >  
> >  	/*
> > @@ -796,6 +797,16 @@ void do_secure_storage_access(struct pt_regs
> > *regs) }
> >  
> >  	switch (get_fault_type(regs)) {
> > +	case GMAP_FAULT:
> > +		gmap = (struct gmap *)S390_lowcore.gmap;
> > +		/*
> > +		 * Very unlikely, but if it happens, simply try
> > again.
> > +		 * The next attempt will trigger a different
> > exception.
> > +		 */  
> 
> If we keep this the way it currently is then the comment needs to go
> to the EFAULT check since it makes no sense above the
> gmap_translate().
> 
> > +		addr = __gmap_translate(gmap, addr);  
> 
> So we had a valid gmap PTE to end up here where the guest touched a
> secure page and triggered the exception. But we suddenly can't
> translate the gaddr to a vmaddr because the gmap tracking doesn't
> have an entry for the address.
> 
> My first instinct is to SIGSEGV the process since I can't come up
> with a way out of this situation except for the process to map this
> back in. The only reason I can think of that it was removed from the
> mapping is malicious intent or a bug.
> 
> I think this is needs a VM_FAULT_BADMAP and a do_fault_error() call.

fair enough, the next version will have that

> > +		if (addr == -EFAULT)
> > +			break;
> > +		fallthrough;
> >  	case USER_FAULT:
> >  		mm = current->mm;
> >  		mmap_read_lock(mm);
> > @@ -824,7 +835,6 @@ void do_secure_storage_access(struct pt_regs
> > *regs) if (rc)
> >  			BUG();
> >  		break;
> > -	case GMAP_FAULT:
> >  	default:
> >  		do_fault_error(regs, VM_READ | VM_WRITE,
> > VM_FAULT_BADMAP); WARN_ON_ONCE(1);
> >   
> 

