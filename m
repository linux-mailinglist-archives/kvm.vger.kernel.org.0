Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0C84709B3
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 20:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343506AbhLJTIX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 14:08:23 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59554 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1343500AbhLJTIW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 14:08:22 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BAHqptU022918;
        Fri, 10 Dec 2021 19:04:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=LmWwjt87t4nyi6IEqGGPkJPpsktR0NH6F2d1Qqf6rmY=;
 b=od4rWQEpqb5ZsyQdsvPbhbqJ0+Z/QH1HqNwNbk129WDxIMBj3J6MAdoDeevQX8N9Mort
 tzj9V4eI3MjJQQHG3PBq+anAKkvsF0WW6Nr9HYI63zJfNuB+BQvuq41O0dnYDrJvaPDf
 DtEm1zapMKD/tr5WxQDMLmuchy91NEKiaZW5B60sVYaDXMlkcdM2hPJOk1XLgZWCGAAG
 xxwQFK0/zT6WDARRLC6jECs40uOHqr8kbZc1/oU7jBA8uNJ/NddcU84bku8L2SXh7kLN
 zWdM8n6he/sImM4OLQoqBaxWghqJ18+GDrAUnOwN3vHUWPvtnbAhYsN7NjKJCwqM6JHI Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cvavnt7wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 19:04:46 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BAIBLhV006703;
        Fri, 10 Dec 2021 19:04:46 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cvavnt7wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 19:04:46 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BAIcOA4017571;
        Fri, 10 Dec 2021 19:04:45 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 3cqyydauvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 19:04:45 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BAJ4hM922086090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 19:04:44 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFB3DBE051;
        Fri, 10 Dec 2021 19:04:43 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 193D0BE05B;
        Fri, 10 Dec 2021 19:04:41 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.80.105])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 10 Dec 2021 19:04:41 +0000 (GMT)
Message-ID: <f1878a2f16cd8124936b1deba6b72d4b61645d0d.camel@linux.ibm.com>
Subject: Re: [PATCH 11/32] s390/pci: add helper function to find device by
 handle
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 10 Dec 2021 14:04:40 -0500
In-Reply-To: <20211207205743.150299-12-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
         <20211207205743.150299-12-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mCFwCctr5Z3KWoTmy34FiHEC5d0m1RRl
X-Proofpoint-ORIG-GUID: RFNKVdduOf2ZQCzXCg_AklQwg9Lnbt4N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_07,2021-12-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 spamscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-12-07 at 15:57 -0500, Matthew Rosato wrote:
> Intercepted zPCI instructions will specify the desired function via a
> function handle.  Add a routine to find the device with the specified
> handle.
> 
> Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Eric Farman <farman@linux.ibm.com>

> ---
>  arch/s390/include/asm/pci.h |  1 +
>  arch/s390/pci/pci.c         | 16 ++++++++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/arch/s390/include/asm/pci.h
> b/arch/s390/include/asm/pci.h
> index 1a8f9f42da3a..00a2c24d6d2b 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -275,6 +275,7 @@ static inline struct zpci_dev *to_zpci_dev(struct
> device *dev)
>  }
>  
>  struct zpci_dev *get_zdev_by_fid(u32);
> +struct zpci_dev *get_zdev_by_fh(u32 fh);
>  
>  /* DMA */
>  int zpci_dma_init(void);
> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> index 9b4d3d78b444..af1c0ae017b1 100644
> --- a/arch/s390/pci/pci.c
> +++ b/arch/s390/pci/pci.c
> @@ -76,6 +76,22 @@ struct zpci_dev *get_zdev_by_fid(u32 fid)
>  	return zdev;
>  }
>  
> +struct zpci_dev *get_zdev_by_fh(u32 fh)
> +{
> +	struct zpci_dev *tmp, *zdev = NULL;
> +
> +	spin_lock(&zpci_list_lock);
> +	list_for_each_entry(tmp, &zpci_list, entry) {
> +		if (tmp->fh == fh) {
> +			zdev = tmp;
> +			break;
> +		}
> +	}
> +	spin_unlock(&zpci_list_lock);
> +	return zdev;
> +}
> +EXPORT_SYMBOL_GPL(get_zdev_by_fh);
> +
>  void zpci_remove_reserved_devices(void)
>  {
>  	struct zpci_dev *tmp, *zdev;

