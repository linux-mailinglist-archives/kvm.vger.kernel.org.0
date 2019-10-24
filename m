Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0EF0E3803
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 18:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503450AbfJXQgQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 12:36:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45268 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2503367AbfJXQdQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 12:33:16 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9OGV7oO061136
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 12:33:15 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vuesd223k-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 12:33:15 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Thu, 24 Oct 2019 17:33:12 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 17:33:09 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9OGX7FY40304744
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 16:33:07 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA6B9AE055;
        Thu, 24 Oct 2019 16:33:07 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52804AE051;
        Thu, 24 Oct 2019 16:33:07 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.39])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Oct 2019 16:33:07 +0000 (GMT)
Date:   Thu, 24 Oct 2019 18:33:06 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        cohuck@redhat.com, gor@linux.ibm.com
Subject: Re: [RFC 07/37] KVM: s390: protvirt: Secure memory is not mergeable
In-Reply-To: <f80519a0-a8da-1a98-c450-b81dfcf2e897@redhat.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-8-frankja@linux.ibm.com>
        <f80519a0-a8da-1a98-c450-b81dfcf2e897@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19102416-0020-0000-0000-0000037DFD62
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102416-0021-0000-0000-000021D445A7
Message-Id: <20191024183306.4c2bd289@p-imbrenda.boeblingen.de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-24_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=960 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910240154
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Oct 2019 18:07:14 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 24.10.19 13:40, Janosch Frank wrote:
> > KSM will not work on secure pages, because when the kernel reads a
> > secure page, it will be encrypted and hence no two pages will look
> > the same.
> > 
> > Let's mark the guest pages as unmergeable when we transition to
> > secure mode.
> > 
> > Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> > ---
> >   arch/s390/include/asm/gmap.h |  1 +
> >   arch/s390/kvm/kvm-s390.c     |  6 ++++++
> >   arch/s390/mm/gmap.c          | 28 ++++++++++++++++++----------
> >   3 files changed, 25 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/s390/include/asm/gmap.h
> > b/arch/s390/include/asm/gmap.h index 6efc0b501227..eab6a2ec3599
> > 100644 --- a/arch/s390/include/asm/gmap.h
> > +++ b/arch/s390/include/asm/gmap.h
> > @@ -145,4 +145,5 @@ int gmap_mprotect_notify(struct gmap *,
> > unsigned long start, 
> >   void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long
> > dirty_bitmap[4], unsigned long gaddr, unsigned long vmaddr);
> > +int gmap_mark_unmergeable(void);
> >   #endif /* _ASM_S390_GMAP_H */
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index 924132d92782..d1ba12f857e7 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -2176,6 +2176,12 @@ static int kvm_s390_handle_pv(struct kvm
> > *kvm, struct kvm_pv_cmd *cmd) if (r)
> >   			break;
> >   
> > +		down_write(&current->mm->mmap_sem);
> > +		r = gmap_mark_unmergeable();
> > +		up_write(&current->mm->mmap_sem);
> > +		if (r)
> > +			break;
> > +
> >   		mutex_lock(&kvm->lock);
> >   		kvm_s390_vcpu_block_all(kvm);
> >   		/* FMT 4 SIE needs esca */
> > diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> > index edcdca97e85e..bf365a09f900 100644
> > --- a/arch/s390/mm/gmap.c
> > +++ b/arch/s390/mm/gmap.c
> > @@ -2548,6 +2548,23 @@ int s390_enable_sie(void)
> >   }
> >   EXPORT_SYMBOL_GPL(s390_enable_sie);
> >   
> > +int gmap_mark_unmergeable(void)
> > +{
> > +	struct mm_struct *mm = current->mm;
> > +	struct vm_area_struct *vma;
> > +
> > +	for (vma = mm->mmap; vma; vma = vma->vm_next) {
> > +		if (ksm_madvise(vma, vma->vm_start, vma->vm_end,
> > +				MADV_UNMERGEABLE, &vma->vm_flags))
> > {
> > +			mm->context.uses_skeys = 0;  
> 
> That skey setting does not make too much sense when coming via 
> kvm_s390_handle_pv(). handle that in the caller?

protected guests run keyless; any attempt to use keys in the guest will
result in an exception in the guest.

> 
> > +			return -ENOMEM;
> > +		}
> > +	}
> > +	mm->def_flags &= ~VM_MERGEABLE;
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(gmap_mark_unmergeable);
> > +
> >   /*
> >    * Enable storage key handling from now on and initialize the
> > storage
> >    * keys with the default key.
> > @@ -2593,7 +2610,6 @@ static const struct mm_walk_ops
> > enable_skey_walk_ops = { int s390_enable_skey(void)
> >   {
> >   	struct mm_struct *mm = current->mm;
> > -	struct vm_area_struct *vma;
> >   	int rc = 0;
> >   
> >   	down_write(&mm->mmap_sem);
> > @@ -2601,15 +2617,7 @@ int s390_enable_skey(void)
> >   		goto out_up;
> >   
> >   	mm->context.uses_skeys = 1;
> > -	for (vma = mm->mmap; vma; vma = vma->vm_next) {
> > -		if (ksm_madvise(vma, vma->vm_start, vma->vm_end,
> > -				MADV_UNMERGEABLE, &vma->vm_flags))
> > {
> > -			mm->context.uses_skeys = 0;
> > -			rc = -ENOMEM;
> > -			goto out_up;
> > -		}
> > -	}
> > -	mm->def_flags &= ~VM_MERGEABLE;
> > +	gmap_mark_unmergeable();
> >   
> >   	walk_page_range(mm, 0, TASK_SIZE, &enable_skey_walk_ops,
> > NULL); 
> >   
> 
> 

