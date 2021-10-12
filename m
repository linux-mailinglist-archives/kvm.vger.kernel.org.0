Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC37A42A005
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 10:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbhJLIiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 04:38:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40398 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234745AbhJLIiG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 04:38:06 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C8CB7x027311;
        Tue, 12 Oct 2021 04:36:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=clgthSWCQb948dpI0HY7W2uAGrXqwjNJF48BWMWj+PA=;
 b=ITy+HwOQwlTwI2Ywsphuyz3hujZFu5Gcs3CYv0atYg0MTAf7/MGiOo99T0/emNHLW0y6
 3+BOJoH/4XdWRrbhktgg1Q7YkuXHN0S8REJ/hSQacW/pLkfU1mEjlQTagddDG/nTIy1I
 CChbhBJ58W9Eq8c5YbRseI7tnc9b6C7jDLNcHLeY9UHPrmh9vskCOvRIx4ffYt1/W+fv
 WgIAP0gU32fx1QLp5lWz4xz+jjR0e4TpA83oOUuukZdalCoX3VBkKu49kn8cFvgc2g4q
 yyKUcvdVbGksOORWSqL7X0SYOSsWDkYn0xf2+gJWq2jdTPKvIMVJCNrGyCkHvJGNj2gX SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bn6n20em0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 04:36:04 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19C8EVbV003122;
        Tue, 12 Oct 2021 04:36:04 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bn6n20ek8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 04:36:04 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19C8XpbR024314;
        Tue, 12 Oct 2021 08:36:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3bk2bj6964-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 08:36:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19C8ZsCl46989778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 08:35:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B8404C04E;
        Tue, 12 Oct 2021 08:35:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 873F64C050;
        Tue, 12 Oct 2021 08:35:53 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.7.88])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 08:35:53 +0000 (GMT)
Date:   Tue, 12 Oct 2021 10:35:50 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: Re: [PATCH v5 08/14] KVM: s390: pv: handle secure storage
 exceptions for normal guests
Message-ID: <20211012103550.501857f5@p-imbrenda>
In-Reply-To: <f442a49f-dbc4-5c38-ffa1-6b17742592c3@linux.ibm.com>
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
        <20210920132502.36111-9-imbrenda@linux.ibm.com>
        <f442a49f-dbc4-5c38-ffa1-6b17742592c3@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XxPXb4BXkf5Qz2hd_qh0N4TO2Yn4Gxe8
X-Proofpoint-GUID: 0nHswJhhYAqjQsYfIfe1v7v3C53-AikG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_02,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 mlxlogscore=968 impostorscore=0
 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120047
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Oct 2021 10:16:26 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 9/20/21 15:24, Claudio Imbrenda wrote:
> > With upcoming patches, normal guests might touch secure pages.
> > 
> > This patch extends the existing exception handler to convert the pages
> > to non secure also when the exception is triggered by a normal guest.
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
> >   arch/s390/mm/fault.c | 10 +++++++++-
> >   1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> > index eb68b4f36927..74784581f42d 100644
> > --- a/arch/s390/mm/fault.c
> > +++ b/arch/s390/mm/fault.c
> > @@ -767,6 +767,7 @@ void do_secure_storage_access(struct pt_regs *regs)
> >   	struct vm_area_struct *vma;
> >   	struct mm_struct *mm;
> >   	struct page *page;
> > +	struct gmap *gmap;
> >   	int rc;
> >   
> >   	/*
> > @@ -796,6 +797,14 @@ void do_secure_storage_access(struct pt_regs *regs)
> >   	}
> >   
> >   	switch (get_fault_type(regs)) {
> > +	case GMAP_FAULT:
> > +		gmap = (struct gmap *)S390_lowcore.gmap;
> > +		addr = __gmap_translate(gmap, addr);
> > +		if (IS_ERR_VALUE(addr)) {
> > +			do_fault_error(regs, VM_ACCESS_FLAGS, VM_FAULT_BADMAP);
> > +			break;
> > +		}
> > +		fallthrough;  
> 
> This would trigger an export and not a destroy, right?

correct. but this would only happen for leftover secure pages touched
by non-secure guests, before the background thread could clean them up.

> 
> >   	case USER_FAULT:
> >   		mm = current->mm;
> >   		mmap_read_lock(mm);
> > @@ -824,7 +833,6 @@ void do_secure_storage_access(struct pt_regs *regs)
> >   		if (rc)
> >   			BUG();
> >   		break;
> > -	case GMAP_FAULT:
> >   	default:
> >   		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
> >   		WARN_ON_ONCE(1);
> >   
> 

