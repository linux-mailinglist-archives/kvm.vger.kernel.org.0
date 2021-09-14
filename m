Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0BF40B546
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhINQwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:52:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34952 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229379AbhINQwF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 12:52:05 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18EGacw6017828;
        Tue, 14 Sep 2021 12:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Rh3adKXOvTjnVLe7wTOUMZo3kGUE1+HavKT6nVaxveU=;
 b=FZP0WW8r6fDKNDLzVE79X/joPRQfRDxRd1pBy/bu0sRMU9tIhDZRAMd/QHCMAVQICxsz
 aQRudNMD1uNqWG4m/+EAcDs2RVe6R5Q0kvtcBeE8QSXzX52SonJYPUapuAz7vaF7nBYA
 j84ozPTFlwlVUbwYIKyflqSqbIDvsDLWcjSMvEJmJE2a3QW0ySE4vSI+xSJOhkKaJHXZ
 gWWZb2tbLzq68LvampgFUKFhtyQZE9UrjAA3fYWekA7896QGuQ+APue95BhQQ/DSg9lh
 ms+bOyWnO/uZn+MK4XcqNGbH1dAzpo4mL83fMSfyhYzNlEgkSJhxoIqplnEm+1unBYKG ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2ydjg83h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 12:50:45 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18EGe8jT032210;
        Tue, 14 Sep 2021 12:50:44 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2ydjg82f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 12:50:44 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18EGTdXN018652;
        Tue, 14 Sep 2021 16:50:42 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3b0m39w8d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 16:50:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18EGobta45154708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 16:50:37 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DE5D4205E;
        Tue, 14 Sep 2021 16:50:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CDBA42056;
        Tue, 14 Sep 2021 16:50:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.12])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Sep 2021 16:50:36 +0000 (GMT)
Date:   Tue, 14 Sep 2021 18:50:33 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Subject: Re: [PATCH resend RFC 0/9] s390: fixes, cleanups and optimizations
 for page table walkers
Message-ID: <20210914185033.367020b3@p-imbrenda>
In-Reply-To: <20210909162248.14969-1-david@redhat.com>
References: <20210909162248.14969-1-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PFTO1wmqLkc7mGdR--al99-8qbnnou4J
X-Proofpoint-ORIG-GUID: GntbYdhzAhAgpOL2BHZLbv00a8NJIqdw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109030001 definitions=main-2109140091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Sep 2021 18:22:39 +0200
David Hildenbrand <david@redhat.com> wrote:

> Resend because I missed ccing people on the actual patches ...
> 
> RFC because the patches are essentially untested and I did not actually
> try to trigger any of the things these patches are supposed to fix. It

this is an interesting series, and the code makes sense, but I would
really like to see some regression tests, and maybe even some
selftests to trigger (at least some of) the issues.

the follow-up question is: how did we manage to go on so long without
noticing these issues? :D

> merely matches my current understanding (and what other code does :) ). I
> did compile-test as far as possible.
> 
> After learning more about the wonderful world of page tables and their
> interaction with the mmap_sem and VMAs, I spotted some issues in our
> page table walkers that allow user space to trigger nasty behavior when
> playing dirty tricks with munmap() or mmap() of hugetlb. While some issues
> should be hard to trigger, others are fairly easy because we provide
> conventient interfaces (e.g., KVM_S390_GET_SKEYS and KVM_S390_SET_SKEYS).
> 
> Future work:
> - Don't use get_locked_pte() when it's not required to actually allocate
>   page tables -- similar to how storage keys are now handled. Examples are
>   get_pgste() and __gmap_zap.
> - Don't use get_locked_pte() and instead let page fault logic allocate page
>   tables when we actually do need page tables -- also, similar to how
>   storage keys are now handled. Examples are set_pgste_bits() and
>   pgste_perform_essa().
> - Maybe switch to mm/pagewalk.c to avoid custom page table walkers. For
>   __gmap_zap() that's very easy.
> 
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Niklas Schnelle <schnelle@linux.ibm.com>
> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Cc: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
> 
> David Hildenbrand (9):
>   s390/gmap: validate VMA in __gmap_zap()
>   s390/gmap: don't unconditionally call pte_unmap_unlock() in
>     __gmap_zap()
>   s390/mm: validate VMA in PGSTE manipulation functions
>   s390/mm: fix VMA and page table handling code in storage key handling
>     functions
>   s390/uv: fully validate the VMA before calling follow_page()
>   s390/pci_mmio: fully validate the VMA before calling follow_pte()
>   s390/mm: no need for pte_alloc_map_lock() if we know the pmd is
>     present
>   s390/mm: optimize set_guest_storage_key()
>   s390/mm: optimize reset_guest_reference_bit()
> 
>  arch/s390/kernel/uv.c    |   2 +-
>  arch/s390/mm/gmap.c      |  11 +++-
>  arch/s390/mm/pgtable.c   | 109 +++++++++++++++++++++++++++------------
>  arch/s390/pci/pci_mmio.c |   4 +-
>  4 files changed, 89 insertions(+), 37 deletions(-)
> 
> 
> base-commit: 7d2a07b769330c34b4deabeed939325c77a7ec2f

