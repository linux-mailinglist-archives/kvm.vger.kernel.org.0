Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6CC40B569
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhINQ4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:56:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7980 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231363AbhINQ4D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 12:56:03 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18EFpo7G029541;
        Tue, 14 Sep 2021 12:54:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Qy4X9/oxBqi8dDd9OpSU+FwGexrK2UVH0Cx+696cXRs=;
 b=MA8QjBHw5XGtOmak3ByHmKiE6nLHvfV4vxc9CTBwKy9XbFeil7MQ8hX4VCnzSeptxk4h
 hxoA6/SYZSCeRAFroQJ1Urm6NKb0wr/UDiU1aWjhQn/xd/NaT2AEd2EOF7pbfjoUM4Pi
 +qkSLiYZd86lG6OmZzGI7xe8w6WDSEtO4q9Six3slR2IjdjUKSQOFYxFQGF2DUa8Ck5j
 ZXGkCfFMziW70zfBmk76zO/bJ9xdzX1BKJpLMkL6SpoknGasjcf813ntLuP+j7aSMdKk
 Q3BUCC5/3jrFXOLOxZQdPeM4HxwkTIWKX4F9vLe7SyEiRM9BTNsTovOanghrJY0b3sHh wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2s7xb5ps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 12:54:44 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18EGr80I001161;
        Tue, 14 Sep 2021 12:54:44 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2s7xb5p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 12:54:44 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18EGqDZZ018914;
        Tue, 14 Sep 2021 16:54:42 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3b0m39d9qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 16:54:42 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18EGo6TG52232492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 16:50:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2641811C05E;
        Tue, 14 Sep 2021 16:54:38 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92E9711C052;
        Tue, 14 Sep 2021 16:54:37 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.12])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Sep 2021 16:54:37 +0000 (GMT)
Date:   Tue, 14 Sep 2021 18:54:33 +0200
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
Subject: Re: [PATCH resend RFC 6/9] s390/pci_mmio: fully validate the VMA
 before calling follow_pte()
Message-ID: <20210914185433.41f0a0b9@p-imbrenda>
In-Reply-To: <20210909162248.14969-7-david@redhat.com>
References: <20210909162248.14969-1-david@redhat.com>
 <20210909162248.14969-7-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: b5CqA5O8AQhIJ8v0xe0ZWHEx_u2mGu8j
X-Proofpoint-ORIG-GUID: VFoUS8JAy4Q4tgXxfmyp6ep_atmJX52K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 clxscore=1015 mlxscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Sep 2021 18:22:45 +0200
David Hildenbrand <david@redhat.com> wrote:

> We should not walk/touch page tables outside of VMA boundaries when
> holding only the mmap sem in read mode. Evil user space can modify the
> VMA layout just before this function runs and e.g., trigger races with
> page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
> with read mmap_sem in munmap").
> 
> find_vma() does not check if the address is >= the VMA start address;
> use vma_lookup() instead.
> 
> Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/pci/pci_mmio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
> index ae683aa623ac..c5b35ea129cf 100644
> --- a/arch/s390/pci/pci_mmio.c
> +++ b/arch/s390/pci/pci_mmio.c
> @@ -159,7 +159,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned
> long, mmio_addr, 
>  	mmap_read_lock(current->mm);
>  	ret = -EINVAL;
> -	vma = find_vma(current->mm, mmio_addr);
> +	vma = vma_lookup(current->mm, mmio_addr);
>  	if (!vma)
>  		goto out_unlock_mmap;
>  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> @@ -298,7 +298,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned
> long, mmio_addr, 
>  	mmap_read_lock(current->mm);
>  	ret = -EINVAL;
> -	vma = find_vma(current->mm, mmio_addr);
> +	vma = vma_lookup(current->mm, mmio_addr);
>  	if (!vma)
>  		goto out_unlock_mmap;
>  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))

