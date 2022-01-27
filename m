Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FA149DF75
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 11:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239490AbiA0Ka3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 05:30:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15132 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236285AbiA0Ka2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 05:30:28 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20R9fuWe018114;
        Thu, 27 Jan 2022 10:30:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=HGUo32q18MElGnW2l5QdsUZnPlAT3dnhHKTfStsMUGk=;
 b=nSy8qqDkn8BFiAJJ87iDzJqBIR/oKzYTrO3JlT/1sxSgOBQJg5T8CtlDGjtXJAIeChS7
 gkp4j9oJsiMStxZQdgtipwuXghFsL+EUdV9uMlfHGm8dkAfkLLoMtW+KDYk7SAjmpJg4
 KoJ2M6z3iSSS6QRd7uWwWGvyNUcccrG3LJ6CCxMo4gBahPmTmyjrLSpoasRMEgKofUOj
 qfVmsHrfsLYflmOvRs/N2D6XKX2botnObcrZRoiZ2KJnSD7IRXVadACbyb1DAiDT6l+V
 ZqB9yIMisasWc3joIalR6LdiimHdQcG13Ow3u5RcnwSmhbuSivFedJ9MPWCEQggqehcR sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dus0191wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 10:30:28 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20RAFnAg018337;
        Thu, 27 Jan 2022 10:30:27 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dus0191v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 10:30:27 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20RARAAI021239;
        Thu, 27 Jan 2022 10:30:25 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3dr9j9v5m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 10:30:25 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20RAULQU38863120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 10:30:21 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 952A052051;
        Thu, 27 Jan 2022 10:30:21 +0000 (GMT)
Received: from sig-9-145-73-120.uk.ibm.com (unknown [9.145.73.120])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 90A4D52050;
        Thu, 27 Jan 2022 10:30:20 +0000 (GMT)
Message-ID: <9405941130ff2d616bcc73325d815429e5b71d61.camel@linux.ibm.com>
Subject: Re: [PATCH v2 13/30] s390/pci: return status from zpci_refresh_trans
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 27 Jan 2022 11:30:20 +0100
In-Reply-To: <20220114203145.242984-14-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
         <20220114203145.242984-14-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Wk8LCCKjuJX7EqxNAP0KPmOHPbF5cJ5m
X-Proofpoint-ORIG-GUID: 7qv5VKOVW5Z_ud9qH_cjqVNSOID0vi0C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_02,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 phishscore=0 adultscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-01-14 at 15:31 -0500, Matthew Rosato wrote:
> Current callers of zpci_refresh_trans don't need to interrogate the status
> returned from the underlying instructions.  However, a subsequent patch
> will add a KVM caller that needs this information.  Add a new argument to
> zpci_refresh_trans to pass the address of a status byte and update
> existing call sites to provide it.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  arch/s390/include/asm/pci_insn.h |  2 +-
>  arch/s390/pci/pci_dma.c          |  6 ++++--
>  arch/s390/pci/pci_insn.c         | 10 +++++-----
>  drivers/iommu/s390-iommu.c       |  4 +++-
>  4 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pci_insn.h b/arch/s390/include/asm/pci_insn.h
> index 5331082fa516..32759c407b8f 100644
> --- a/arch/s390/include/asm/pci_insn.h
> +++ b/arch/s390/include/asm/pci_insn.h
> @@ -135,7 +135,7 @@ union zpci_sic_iib {
>  DECLARE_STATIC_KEY_FALSE(have_mio);
>  
>  u8 zpci_mod_fc(u64 req, struct zpci_fib *fib, u8 *status);
> -int zpci_refresh_trans(u64 fn, u64 addr, u64 range);
> +int zpci_refresh_trans(u64 fn, u64 addr, u64 range, u8 *status);
> 
---8<---
>  
>  	return (cc) ? -EIO : 0;
> diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
> index 50860ebdd087..845bb99c183e 100644
> --- a/drivers/iommu/s390-iommu.c
> +++ b/drivers/iommu/s390-iommu.c
> @@ -214,6 +214,7 @@ static int s390_iommu_update_trans(struct s390_domain *s390_domain,
>  	unsigned long irq_flags, nr_pages, i;
>  	unsigned long *entry;
>  	int rc = 0;
> +	u8 status;
>  
>  	if (dma_addr < s390_domain->domain.geometry.aperture_start ||
>  	    dma_addr + size > s390_domain->domain.geometry.aperture_end)
> @@ -238,7 +239,8 @@ static int s390_iommu_update_trans(struct s390_domain *s390_domain,
>  	spin_lock(&s390_domain->list_lock);
>  	list_for_each_entry(domain_device, &s390_domain->devices, list) {
>  		rc = zpci_refresh_trans((u64) domain_device->zdev->fh << 32,
> -					start_dma_addr, nr_pages * PAGE_SIZE);
> +					start_dma_addr, nr_pages * PAGE_SIZE,
> +					&status);
>  		if (rc)
>  			break;
>  	}

Looks good.

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>

