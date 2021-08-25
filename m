Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DF73F7A8E
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 18:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239755AbhHYQcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 12:32:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14312 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238543AbhHYQcH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Aug 2021 12:32:07 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17PG7D9S025250
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 12:31:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=tpOmSafrAtTNfWKgguZEgUj0OQXVsiL4uSbZAXUGCfU=;
 b=U6FOij6mGODMC6LeKHhbDR7NnrMRpjn7tcGwFonAYcnyVmM8hST6UPCAUrrIOgMCAXc0
 GEpNagXZGXmKGfNeMnl+YXF/OBykDRy2+Ne19SHoKBAC9gyb8QCvMA1zvvYpwEIgJEdd
 mqbcr3EPV1oh23uC7ofANAAw6caiFSZ2TV4HE6Cl9OxlycJQcNj/GO/3qc2rLJT7FCqD
 n0HHFVxUt/YFiWzwn/MB+NhyPTwop7Ip3FdgBF/Lq6u0dcJjKcu6ZPJSZCgA9a2gLmso
 11ifjue1Es1sZblwijnWdwYQUPs6a6MQzKmzavu1UKM4LBZOW/i9NAa/9qZ4Y30T6+hr qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3anpt561af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 12:31:20 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17PG8G3S034279
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 12:31:20 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3anpt5619n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Aug 2021 12:31:20 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17PGS9LL003217;
        Wed, 25 Aug 2021 16:31:17 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3ajs48ebn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Aug 2021 16:31:17 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17PGVEla37159394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Aug 2021 16:31:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 790F3AE057;
        Wed, 25 Aug 2021 16:31:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15EE0AE056;
        Wed, 25 Aug 2021 16:31:14 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.94])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 25 Aug 2021 16:31:14 +0000 (GMT)
Date:   Wed, 25 Aug 2021 18:31:01 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: fixing I/O memory allocation
Message-ID: <20210825183101.32d091f2@p-imbrenda>
In-Reply-To: <1629908421-8543-3-git-send-email-pmorel@linux.ibm.com>
References: <1629908421-8543-1-git-send-email-pmorel@linux.ibm.com>
        <1629908421-8543-3-git-send-email-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Spkt-83F3cZ8i9WxKQrivVtot8qtxJWL
X-Proofpoint-ORIG-GUID: gvCQGBjE4cwqqbpjn1xcUfZmK7MZET8e
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-25_06:2021-08-25,2021-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108250096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 25 Aug 2021 18:20:21 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> The allocator allocate pages it follows the size must be rounded
> to pages before the allocation.
> 
> Fixes: b0fe3988 "s390x: define UV compatible I/O allocation"
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/malloc_io.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
> index 78582eac..080fc694 100644
> --- a/lib/s390x/malloc_io.c
> +++ b/lib/s390x/malloc_io.c
> @@ -41,7 +41,7 @@ static void unshare_pages(void *p, int count)
>  
>  void *alloc_io_mem(int size, int flags)
>  {
> -	int order = get_order(size >> PAGE_SHIFT);
> +	int order = get_order(PAGE_ALIGN(size) >> PAGE_SHIFT);
>  	void *p;
>  	int n;
>  
> @@ -62,7 +62,7 @@ void *alloc_io_mem(int size, int flags)
>  
>  void free_io_mem(void *p, int size)
>  {
> -	int order = get_order(size >> PAGE_SHIFT);
> +	int order = get_order(PAGE_ALIGN(size) >> PAGE_SHIFT);
>  
>  	assert(IS_ALIGNED((uintptr_t)p, PAGE_SIZE));
>  

