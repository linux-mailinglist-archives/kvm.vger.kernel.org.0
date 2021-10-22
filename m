Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A6143768C
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 14:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhJVMOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 08:14:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14526 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230230AbhJVMOH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 08:14:07 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M9I7w3002492;
        Fri, 22 Oct 2021 08:11:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=/l1fyHkMy1Qb5+XWNoEXx/Ur+bpaKZI2ollk5ADkAWY=;
 b=mV9uHxgV18YPcmfRbNZJDYJ/7BzcypHWxQ5mL2phXVVifkGLS1Du6CzzNg3p3YamLPRT
 qw0Ngsyj0jPiD8uk74DHvzbkDs1WZWgin3rFEX9aKLT02W2qyrcBWGUvI/4YIuwaZhdm
 VNzXzFFWN+i/BB/5SZTgV3osbs/cziAd0yILVkcxBYzrm7tVIf2rj1nB9ulrPfby/ax1
 W6C5LvWN1JtjJS4G5eQJ9Kn7m6xnfScMTl8Yy3ZbfsZuK81qB0YPixSueb1unkVIBaIg
 ubcU4LcfYceU9rstq8/noG+i1gEca3PnNMZe7lfC1rZIOh5bDwE1eiDTuMMrSMv2NbIM aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3butj3b54a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 08:11:49 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19MBjL0s006621;
        Fri, 22 Oct 2021 08:11:49 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3butj3b53k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 08:11:49 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19MC28gs018699;
        Fri, 22 Oct 2021 12:11:47 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3bqpcar7bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 12:11:46 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19MCBhrb4588078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 12:11:43 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6930DAE057;
        Fri, 22 Oct 2021 12:11:43 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0B6EAE064;
        Fri, 22 Oct 2021 12:11:42 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.134])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Oct 2021 12:11:42 +0000 (GMT)
Date:   Fri, 22 Oct 2021 14:11:40 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: Fix handle_sske page fault handling
Message-ID: <20211022141140.02da5325@p-imbrenda>
In-Reply-To: <20211022112913.211986-1-scgl@linux.ibm.com>
References: <20211022112913.211986-1-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1mRHsr0H9bkcdCehY4RvNLo-5ECsuA3v
X-Proofpoint-ORIG-GUID: nXqEN9du1qGzPAgEP4qgFHrEFZLHmmU6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_03,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=999 phishscore=0
 clxscore=1015 adultscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110220068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Oct 2021 13:29:13 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Retry if fixup_user_fault succeeds.
> The same issue in handle_pfmf was fixed by
> a11bdb1a6b78 (KVM: s390: Fix pfmf and conditional skey emulation).
> 
> Fixes: bd096f644319 ("KVM: s390: Add skey emulation fault handling")
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

with the description fixed as indicated by Christian:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/priv.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 53da4ceb16a3..417154b314a6 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -397,6 +397,8 @@ static int handle_sske(struct kvm_vcpu *vcpu)
>  		mmap_read_unlock(current->mm);
>  		if (rc == -EFAULT)
>  			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
> +		if (rc == -EAGAIN)
> +			continue;
>  		if (rc < 0)
>  			return rc;
>  		start += PAGE_SIZE;

