Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC2C41B23B
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 16:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241326AbhI1Okj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 10:40:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17972 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231733AbhI1Oki (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 10:40:38 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SEGsFH032654;
        Tue, 28 Sep 2021 10:38:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=X8RyxjDx5WUc1f1p9TAy/o0IqlcNUgf87xHZvEzvKH4=;
 b=rnxvHfsRitw7twQnFmTPAP1HW6LYrzrJVQEO8a/ELVyqgwj1Z1NLpqoQAXHyhvuio+d0
 x6AeVWmm9KSWPgUT++TGFVwCq63A1QcoHETjf5HXEtN70DCteNXZ6FlPOr/4eYoMz8Sa
 Ut5ByFYe/Nj5SPFAxVmgxrQOpseWJjkV/AbF+1tvkRRwlL5QYK5tPFMzW1dy/8fcFovK
 Xo9DbdlKsKOyDDNly8rqMqla4aNHhI6PiO1fBunyz8TnRUEIKolDBDNXgqy8cKkZlj8j
 bw2nIM4Q8CBwDo5Ec1mVCma6busK15FO1WqfEUXDw1tzHea+HiMJziW6/P1yfmvw3OXP KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbktqvw9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 10:38:56 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18SEWq0A023922;
        Tue, 28 Sep 2021 10:38:56 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbktqvw8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 10:38:56 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18SEXGno032456;
        Tue, 28 Sep 2021 14:38:53 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3b9u1jf331-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 14:38:53 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18SEciHP57410014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 14:38:44 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D939942041;
        Tue, 28 Sep 2021 14:38:43 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47BBC42047;
        Tue, 28 Sep 2021 14:38:43 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.56])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Sep 2021 14:38:43 +0000 (GMT)
Date:   Tue, 28 Sep 2021 16:38:41 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Subject: Re: [PATCH resend RFC 0/9] s390: fixes, cleanups and optimizations
 for page table walkers
Message-ID: <20210928163841.18344eb5@p-imbrenda>
In-Reply-To: <98061eff-f856-fc1d-9f04-a31ac5fcd790@de.ibm.com>
References: <20210909162248.14969-1-david@redhat.com>
        <YVL1iwSicgWg1qx+@osiris>
        <98061eff-f856-fc1d-9f04-a31ac5fcd790@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Fk5omedd_Eb4aYGUMmyVBNNHTOsJIl03
X-Proofpoint-GUID: Mpx8QKBbenop1SEVmhUixRGw85NCSgbp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Sep 2021 13:06:26 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am 28.09.21 um 12:59 schrieb Heiko Carstens:
> > On Thu, Sep 09, 2021 at 06:22:39PM +0200, David Hildenbrand wrote:  
> >> Resend because I missed ccing people on the actual patches ...
> >>
> >> RFC because the patches are essentially untested and I did not actually
> >> try to trigger any of the things these patches are supposed to fix. It
> >> merely matches my current understanding (and what other code does :) ). I
> >> did compile-test as far as possible.
> >>
> >> After learning more about the wonderful world of page tables and their
> >> interaction with the mmap_sem and VMAs, I spotted some issues in our
> >> page table walkers that allow user space to trigger nasty behavior when
> >> playing dirty tricks with munmap() or mmap() of hugetlb. While some issues
> >> should be hard to trigger, others are fairly easy because we provide
> >> conventient interfaces (e.g., KVM_S390_GET_SKEYS and KVM_S390_SET_SKEYS).
> >>
> >> Future work:
> >> - Don't use get_locked_pte() when it's not required to actually allocate
> >>    page tables -- similar to how storage keys are now handled. Examples are
> >>    get_pgste() and __gmap_zap.
> >> - Don't use get_locked_pte() and instead let page fault logic allocate page
> >>    tables when we actually do need page tables -- also, similar to how
> >>    storage keys are now handled. Examples are set_pgste_bits() and
> >>    pgste_perform_essa().
> >> - Maybe switch to mm/pagewalk.c to avoid custom page table walkers. For
> >>    __gmap_zap() that's very easy.
> >>
> >> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> >> Cc: Janosch Frank <frankja@linux.ibm.com>
> >> Cc: Cornelia Huck <cohuck@redhat.com>
> >> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> >> Cc: Heiko Carstens <hca@linux.ibm.com>
> >> Cc: Vasily Gorbik <gor@linux.ibm.com>
> >> Cc: Niklas Schnelle <schnelle@linux.ibm.com>
> >> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> >> Cc: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>  
> > 
> > For the whole series:
> > Acked-by: Heiko Carstens <hca@linux.ibm.com>
> > 
> > Christian, given that this is mostly about KVM I'd assume this should
> > go via the KVM tree. Patch 6 (pci_mmio) is already upstream.  
> 
> Right, I think I will queue this even without testing for now.
> Claudio, is patch 7 ok for you with the explanation from David?

yes
