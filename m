Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEF13F620B
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 17:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238491AbhHXPxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 11:53:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44224 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238443AbhHXPxC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Aug 2021 11:53:02 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17OFY3fG138252;
        Tue, 24 Aug 2021 11:52:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VyqBFI3hf6DgF8Am2Gk4md4w+opA8qElMCV+j5hg7YM=;
 b=JViVQPrifFfI5NVP3HkgsO2MjZLy+JpX6oEg9Xf//VVvJK6aDRN+Ve1cI0tPCCqCyflu
 /Ff0SgxC1oP/MC4zTNXkMO7tPjKO4YIxL0/7MBbAXpxMBIW5rD250aMjhtwZaP23n4U0
 ytJubcoktQkc1lQsXL7QdKpxRKPsKUoY5JJOp/GtTnWrOhZ9cwBYSXTYT1aOxGF/l/6H
 jy4BN2uh+oxvopQpxLoFBHSusCBNMhbAcmVJ7Ks9rKxbD1OxesjgNCN3xNUGEWjDRuiK
 hpO2JAGXr7oUj4VeMKJ/vhrULz/HukGFJ5vVN6O5Ss3MvwSmWEHuCxuqEdqJ37nRBsI0 ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3amwrq42a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Aug 2021 11:52:16 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17OFjgt0010291;
        Tue, 24 Aug 2021 11:52:15 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3amwrq429q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Aug 2021 11:52:15 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17OFhKLR012085;
        Tue, 24 Aug 2021 15:52:15 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 3ajs4c8mgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Aug 2021 15:52:15 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17OFqEPG13238670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 15:52:14 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FD842806E;
        Tue, 24 Aug 2021 15:52:14 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DF1A2806A;
        Tue, 24 Aug 2021 15:52:12 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.11.57])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 Aug 2021 15:52:12 +0000 (GMT)
Subject: Re: [PATCH v2] vfio-pci/zdev: Remove repeated verbose license text
To:     Cai Huoqing <caihuoqing@baidu.com>, farman@linux.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20210824003749.1039-1-caihuoqing@baidu.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <d2e299fb-c636-ea1d-a523-c0e842e0d9e6@linux.ibm.com>
Date:   Tue, 24 Aug 2021 11:52:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210824003749.1039-1-caihuoqing@baidu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rERkOuS85NRo7wLVRk07nbb9rmpRPPWi
X-Proofpoint-ORIG-GUID: d8VTfZZpxlsuVz1BYneESoYR-4cqzCUa
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-24_05:2021-08-24,2021-08-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108240103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/23/21 8:37 PM, Cai Huoqing wrote:
> remove it because SPDX-License-Identifier is already used
> and change "GPL-2.0+" to "GPL-2.0-only"

Could maybe extend the commit message a little to add something along 
the lines of ' to match the more restrictive license that was specified 
by the verbose text being removed.', so as to explain why the identifier 
is being changed here.

With that,

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
> v1->v2: change "GPL-2.0+" to "GPL-2.0-only"
> 
>   drivers/vfio/pci/vfio_pci_zdev.c | 7 +------
>   1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> index 7b011b62c766..104fcf6658db 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -1,15 +1,10 @@
> -// SPDX-License-Identifier: GPL-2.0+
> +// SPDX-License-Identifier: GPL-2.0-only
>   /*
>    * VFIO ZPCI devices support
>    *
>    * Copyright (C) IBM Corp. 2020.  All rights reserved.
>    *	Author(s): Pierre Morel <pmorel@linux.ibm.com>
>    *                 Matthew Rosato <mjrosato@linux.ibm.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - *
>    */
>   #include <linux/io.h>
>   #include <linux/pci.h>
> 

