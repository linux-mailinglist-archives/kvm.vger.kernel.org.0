Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CFF46EB04
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 16:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235776AbhLIPYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 10:24:43 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17370 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235172AbhLIPYm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 10:24:42 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9EwCo0023869;
        Thu, 9 Dec 2021 15:21:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lkTIk4/eGsjTAIEitjjhFcYQMye7Lsi7gcIXWVUcf+I=;
 b=JFq7ByRdknLvlgsemBQf4Jb7zzhjZ7g9T8nRir30yYm0CFv059Lt9qiyMm5MY7hnyyNS
 VSrD99HhgtYSXUJAM1Krk2z/D7hO9dkouuRZSmll9XPBRLgBIXq9C4F+QWxw66/LKLA6
 EhejkdXHTiQawo3FijeczOYaxY6ywNA+YW/rOnLfyC19cEnt9AgPmfqiJbsEGEH931kP
 qDrwJiQlnqTHIj+2SWKfcYSOu5b2bENUIsLKp2eOZ1yFjYzOtwcCRXN+Yqws9GquT2wZ
 grZVExiD9EF09wOkS/3vVM4MnU2tkRBwVOYcmZP42Bf2qqWyERWz7xK5yUGmO4Le5jw8 YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cum1ggjeh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:21:09 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B9F13Im003293;
        Thu, 9 Dec 2021 15:21:08 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cum1ggjbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:21:08 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B9FBxlI023364;
        Thu, 9 Dec 2021 15:21:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3cqyyajupv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:21:00 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B9FKuid20709666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 15:20:56 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96198A4060;
        Thu,  9 Dec 2021 15:20:56 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F866A4067;
        Thu,  9 Dec 2021 15:20:55 +0000 (GMT)
Received: from [9.171.49.66] (unknown [9.171.49.66])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 15:20:55 +0000 (GMT)
Message-ID: <db120635-01fe-eef8-611a-44fb7ad83d03@linux.ibm.com>
Date:   Thu, 9 Dec 2021 16:20:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 09/32] s390/pci: export some routines related to RPCIT
 processing
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-10-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211207205743.150299-10-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wiW6vBMctt8ct6nBfJor2uYcegrStbq7
X-Proofpoint-GUID: CB-6X_7DL7py6maqPDki6i7wZGxetzOs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_06,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> KVM will re-use dma_walk_cpu_trans to walk the host shadow table and
> will also need to be able to call zpci_refresh_trans to re-issue a RPCIT.
> 
> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Makes sense

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>   arch/s390/pci/pci_dma.c  | 1 +
>   arch/s390/pci/pci_insn.c | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
> index 1f4540d6bd2d..ae55f2f2ecd9 100644
> --- a/arch/s390/pci/pci_dma.c
> +++ b/arch/s390/pci/pci_dma.c
> @@ -116,6 +116,7 @@ unsigned long *dma_walk_cpu_trans(unsigned long *rto, dma_addr_t dma_addr)
>   	px = calc_px(dma_addr);
>   	return &pto[px];
>   }
> +EXPORT_SYMBOL_GPL(dma_walk_cpu_trans);
>   
>   void dma_update_cpu_trans(unsigned long *entry, void *page_addr, int flags)
>   {
> diff --git a/arch/s390/pci/pci_insn.c b/arch/s390/pci/pci_insn.c
> index d1a8bd43ce26..0d1ab268ec24 100644
> --- a/arch/s390/pci/pci_insn.c
> +++ b/arch/s390/pci/pci_insn.c
> @@ -95,6 +95,7 @@ int zpci_refresh_trans(u64 fn, u64 addr, u64 range)
>   
>   	return (cc) ? -EIO : 0;
>   }
> +EXPORT_SYMBOL_GPL(zpci_refresh_trans);
>   
>   /* Set Interruption Controls */
>   int zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib)
> 
