Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D4540B55B
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhINQzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:55:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47194 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229795AbhINQzD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 12:55:03 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18EG6CSS012999;
        Tue, 14 Sep 2021 12:53:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=AgbFbypgYKBNBh3qcGbXJns9YRrPJHsG8Iv/U6hlb4g=;
 b=cKGUJe8USAOiiRN/hkPxzsT/kOHgr3CaQXQVnR8Z7536M+iabdasX3HB0AChMSDMs1W2
 +2DeivoefTm8ZK6Hmv9kW5qeBvORcTUwGOtjCzVM2YFbdVHpSFc3hyDtqZwiPgV1k7Ji
 Ec88A9+XbqCxwAgasGG9XkFKkm3EZHMjBeXpQBHRjtISouLnZC0JVD8sBWrtbWsYNu78
 dMYnbDhz+RfSZqHMk86Wa+CHFbxz4oqMtX5BP6CA3VPzmN7bYXoPoO5f51+6vnHq7urU
 YnmDtH949LCApexHVLezNWXZDnmiiLSaY3w17rpmmOq0JFJw+vw8ykpV51Zcb1XpoUp+ GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2w6fcfpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 12:53:44 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18EFd3K5022593;
        Tue, 14 Sep 2021 12:53:43 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2w6fcfpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 12:53:43 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18EGrObb003069;
        Tue, 14 Sep 2021 16:53:42 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3b0kqjpewx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 16:53:41 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18EGrbhr43319708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 16:53:37 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4301D5206B;
        Tue, 14 Sep 2021 16:53:37 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.12])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B593652052;
        Tue, 14 Sep 2021 16:53:36 +0000 (GMT)
Date:   Tue, 14 Sep 2021 18:53:33 +0200
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
Subject: Re: [PATCH resend RFC 1/9] s390/gmap: validate VMA in __gmap_zap()
Message-ID: <20210914185333.0c185dc5@p-imbrenda>
In-Reply-To: <20210909162248.14969-2-david@redhat.com>
References: <20210909162248.14969-1-david@redhat.com>
 <20210909162248.14969-2-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yVhBP9If48rd_4U9Q6DLuTOuO78i0awq
X-Proofpoint-ORIG-GUID: E4Ct5SFi8Pih32dbUeqSyRsGxdNGJp8Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 malwarescore=0 clxscore=1015 phishscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Sep 2021 18:22:40 +0200
David Hildenbrand <david@redhat.com> wrote:

> We should not walk/touch page tables outside of VMA boundaries when
> holding only the mmap sem in read mode. Evil user space can modify the
> VMA layout just before this function runs and e.g., trigger races with
> page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
> with read mmap_sem in munmap"). The pure prescence in our guest_to_host
> radix tree does not imply that there is a VMA.
> 
> Further, we should not allocate page tables (via get_locked_pte()) outside
> of VMA boundaries: if evil user space decides to map hugetlbfs to these
> ranges, bad things will happen because we suddenly have PTE or PMD page
> tables where we shouldn't have them.
> 
> Similarly, we have to check if we suddenly find a hugetlbfs VMA, before
> calling get_locked_pte().
> 
> Note that gmap_discard() is different:
> zap_page_range()->unmap_single_vma() makes sure to stay within VMA
> boundaries.
> 
> Fixes: b31288fa83b2 ("s390/kvm: support collaborative memory management")
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/mm/gmap.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 9bb2c7512cd5..b6b56cd4ca64 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -673,6 +673,7 @@ EXPORT_SYMBOL_GPL(gmap_fault);
>   */
>  void __gmap_zap(struct gmap *gmap, unsigned long gaddr)
>  {
> +	struct vm_area_struct *vma;
>  	unsigned long vmaddr;
>  	spinlock_t *ptl;
>  	pte_t *ptep;
> @@ -682,6 +683,11 @@ void __gmap_zap(struct gmap *gmap, unsigned long gaddr)
>  						   gaddr >> PMD_SHIFT);
>  	if (vmaddr) {
>  		vmaddr |= gaddr & ~PMD_MASK;
> +
> +		vma = vma_lookup(gmap->mm, vmaddr);
> +		if (!vma || is_vm_hugetlb_page(vma))
> +			return;
> +
>  		/* Get pointer to the page table entry */
>  		ptep = get_locked_pte(gmap->mm, vmaddr, &ptl);
>  		if (likely(ptep))

