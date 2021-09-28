Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F96041AD72
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 12:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240288AbhI1LBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 07:01:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25726 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239306AbhI1LBN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 07:01:13 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SAhw1m021117;
        Tue, 28 Sep 2021 06:59:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=VaZ6LXUtqAzNENOKVVw668FIko8Tk+skMoDZhD6+XiY=;
 b=ByT5ME0DLZZNbTMXXkoL9pCjPsWt1eaOT92qk/1aRreLdEtUjfC2hEDMe8LMDkbo7a2A
 elNh+16Xl/FC1bPYFBstbzMUn9AbvrQCEKdldgtIlEsvTAxijax5O8U64i3QS4tGZfAq
 seKVKWrxffGlZDxzMPSnOPeCNazuOKiwZwSqkzf6MtMx61aFO3S7b7CNMuRxbTRCEpcK
 oazupowxR/yrl+9dtTe91GgNPCqv9lms6ee4fLjWQ4eThMuC6+Eozzdu8bSnN1wN2/xl
 iMYYr/xM7xM32beTWrEOZwzA7ssjGYjGQze3Z3JDuayh5QO+CBv+W6mZ4mXWoPeHsTYB Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bby6qbd0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 06:59:31 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18SAIYXa017905;
        Tue, 28 Sep 2021 06:59:31 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bby6qbcyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 06:59:31 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18SArGBB026263;
        Tue, 28 Sep 2021 10:59:29 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3b9u1jd0hf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 10:59:29 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18SAxP2Z40042980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 10:59:25 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45605A407D;
        Tue, 28 Sep 2021 10:59:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF8F7A407C;
        Tue, 28 Sep 2021 10:59:24 +0000 (GMT)
Received: from osiris (unknown [9.145.163.77])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 28 Sep 2021 10:59:24 +0000 (GMT)
Date:   Tue, 28 Sep 2021 12:59:23 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Subject: Re: [PATCH resend RFC 0/9] s390: fixes, cleanups and optimizations
 for page table walkers
Message-ID: <YVL1iwSicgWg1qx+@osiris>
References: <20210909162248.14969-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909162248.14969-1-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: X7BnRuUbNGzOF28ea2UELvb6rVeoVpsC
X-Proofpoint-ORIG-GUID: bA0QBMuJiIPOxbNUT32b4jaARuTjaXLM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 06:22:39PM +0200, David Hildenbrand wrote:
> Resend because I missed ccing people on the actual patches ...
> 
> RFC because the patches are essentially untested and I did not actually
> try to trigger any of the things these patches are supposed to fix. It
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

For the whole series:
Acked-by: Heiko Carstens <hca@linux.ibm.com>

Christian, given that this is mostly about KVM I'd assume this should
go via the KVM tree. Patch 6 (pci_mmio) is already upstream.
