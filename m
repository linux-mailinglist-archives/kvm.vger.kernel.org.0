Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B599240B560
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhINQzY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:55:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41226 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229934AbhINQzW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 12:55:22 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18EF0L8M022464;
        Tue, 14 Sep 2021 12:54:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=GfG/7HI3i+q7EZLlPaNnfg+JTXf1jkJ/F4TGRx7dM9U=;
 b=fu5yc1MUC2APxvzhkk1GqW/OndgryVFmSchtjsi+2sn16t3UeGnJt76kb6VKnE/CWpd8
 IZQA7DxPiTmK32m/z2M4OBMzp3k0k34FoiPFxP540kYNkpN61omIC+n4uIuwWj7eUsR8
 32XYhhyVTeaWHkyypIrc7x6wrfy0uU7f2n3DAZ/PSX6PR8OhvwuIMl39pHSlJmdhH/lL
 SnUkffvA7wBpHTTKcPM7wP1wz/nv+zKioDaSK305E6i7bEcVofEVlzbb5jq8ZkJMKiDK
 bPM2FxoEyx1fb00ddYbdEg/LDgf8POCy0TSNNjnCwetgD9Pu/yvavQZpyNavcb8wyF9w Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2x0gjuwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 12:54:03 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18EF1b6o026966;
        Tue, 14 Sep 2021 12:54:03 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2x0gjuvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 12:54:03 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18EGrTbO031893;
        Tue, 14 Sep 2021 16:54:00 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3b0kqjnbkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 16:54:00 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18EGnOmL40305050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 16:49:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6303311C050;
        Tue, 14 Sep 2021 16:53:56 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D141711C054;
        Tue, 14 Sep 2021 16:53:55 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.12])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Sep 2021 16:53:55 +0000 (GMT)
Date:   Tue, 14 Sep 2021 18:53:53 +0200
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
Subject: Re: [PATCH resend RFC 5/9] s390/uv: fully validate the VMA before
 calling follow_page()
Message-ID: <20210914185353.11693a22@p-imbrenda>
In-Reply-To: <20210909162248.14969-6-david@redhat.com>
References: <20210909162248.14969-1-david@redhat.com>
 <20210909162248.14969-6-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Z1PLCzsiM64_PBNjRurTNJIZ4AAUrBEd
X-Proofpoint-ORIG-GUID: sUjOLi-GmuYEiGWMqjuSpFwe9VIEEt-c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Sep 2021 18:22:44 +0200
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
> Fixes: 214d9bbcd3a6 ("s390/mm: provide memory management functions for protected KVM guests")
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kernel/uv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index aeb0a15bcbb7..193205fb2777 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -227,7 +227,7 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>  	uaddr = __gmap_translate(gmap, gaddr);
>  	if (IS_ERR_VALUE(uaddr))
>  		goto out;
> -	vma = find_vma(gmap->mm, uaddr);
> +	vma = vma_lookup(gmap->mm, uaddr);
>  	if (!vma)
>  		goto out;
>  	/*

