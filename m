Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFA8492319
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 10:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbiARJuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 04:50:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5390 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232585AbiARJuB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 04:50:01 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I9ZB3G026188;
        Tue, 18 Jan 2022 09:50:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WdWePEIxwAY4qLJDiUgZyVeujo+CMkeDTyKQ1h33GCg=;
 b=mFG/DDDHzUjy4cgX4NpDkpVjTtZ5roQgSw6gh5yUU1foRrsZKCrv1gYYmdg8BK5Zh4cJ
 VsaQHGS++0cgsHBcXWiT/ySk1hmM1SSlPptnw08MTJFKP8swpN9R5C9r2MGA0AliZb3O
 RiQMhD0gMEZ24AcA+URiOJQgGU0YnIHuwy8fzTJEGiHXG3Qc9ijxHYl22QbVqmzrcnX4
 M3m9nMQbtcLrU/cV5Nn6juaSf+hs5lmnaoKL5uzr8CO1dk175l2IXf+GQYV/zmi7ljFU
 CTrwVOezG9gODGE1FOKn2JQ7SBcRbMD4GhL4f8XF1MFi0heQwhYYiK4GJWfPzPvui6d+ GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnqv04yr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:50:00 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20I9Vseq011398;
        Tue, 18 Jan 2022 09:50:00 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnqv04yqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:50:00 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20I9m4IP005706;
        Tue, 18 Jan 2022 09:49:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3dknw99etd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:49:57 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20I9nsaP44695848
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 09:49:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5ABE9AE05F;
        Tue, 18 Jan 2022 09:49:54 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6455DAE056;
        Tue, 18 Jan 2022 09:49:53 +0000 (GMT)
Received: from [9.171.70.230] (unknown [9.171.70.230])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 09:49:53 +0000 (GMT)
Message-ID: <df099555-bbfa-6a3f-21ee-b38c7bda8f28@linux.ibm.com>
Date:   Tue, 18 Jan 2022 10:51:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 09/30] s390/pci: export some routines related to RPCIT
 processing
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-10-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-10-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5Wve7qnLcmg3RdRkLtyukhIP1buoneDe
X-Proofpoint-ORIG-GUID: rxQWdoxEHokR-gZf2rZxtJD7zsBZ6heI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_02,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> KVM will re-use dma_walk_cpu_trans to walk the host shadow table and
> will also need to be able to call zpci_refresh_trans to re-issue a RPCIT.
> 
> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>


Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>

> ---
>   arch/s390/pci/pci_dma.c  | 1 +
>   arch/s390/pci/pci_insn.c | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
> index f46833a25526..a81de48d5ea7 100644
> --- a/arch/s390/pci/pci_dma.c
> +++ b/arch/s390/pci/pci_dma.c
> @@ -116,6 +116,7 @@ unsigned long *dma_walk_cpu_trans(unsigned long *rto, dma_addr_t dma_addr)
>   	px = calc_px(dma_addr);
>   	return &pto[px];
>   }
> +EXPORT_SYMBOL_GPL(dma_walk_cpu_trans);
>   
>   void dma_update_cpu_trans(unsigned long *entry, phys_addr_t page_addr, int flags)
>   {
> diff --git a/arch/s390/pci/pci_insn.c b/arch/s390/pci/pci_insn.c
> index 2a47b3936e44..0509554301c7 100644
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

-- 
Pierre Morel
IBM Lab Boeblingen
