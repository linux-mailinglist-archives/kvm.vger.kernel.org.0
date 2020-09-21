Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00D5271F12
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 11:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgIUJlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 05:41:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46850 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726333AbgIUJlV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 05:41:21 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08L9Y8fk074423;
        Mon, 21 Sep 2020 05:41:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LEBz9TEx8uiFEPQqwx50Y1lcY4tdxdDUdEoGP0NDXDg=;
 b=F1ob1yrf0Y6/Rmv7hv95/yw8TZ1rfGfmnJZ4uUfIok3VEGmEViVRZmqh36IrgnNBSmsR
 7a4S6Ira+h90T2k/fACErrLQKWr0k0pMA2MABKcgz/gQ1iHHoV+/rnF8p9padbKrVP93
 6ES6kchi0iLhsUF/K11mozr2+Q84cro6A1laYIW4HfkpMOwpu1AIJFna6yz7GdzNd8ez
 7tlBQtxOLfGGQd3faPDcVts2EYsaCV6rzKvzODNVbyJb7l3Xf3x3dVUTqSd14vA5bU4B
 nvebWvJofVwzUwxKDFYRnfsEmxejuA8Uc7KY4O5ABuglqQbabWXAyNAi45ZtGi6Mywxn EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33psbtgr44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 05:41:20 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08L9ZD8I080070;
        Mon, 21 Sep 2020 05:41:20 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33psbtgr2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 05:41:20 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08L9S71O013874;
        Mon, 21 Sep 2020 09:41:18 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 33n9m7ry0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 09:41:17 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08L9fFpN25100636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Sep 2020 09:41:15 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3AFAA405F;
        Mon, 21 Sep 2020 09:41:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64763A405C;
        Mon, 21 Sep 2020 09:41:14 +0000 (GMT)
Received: from oc5500677777.ibm.com (unknown [9.145.29.18])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Sep 2020 09:41:14 +0000 (GMT)
Subject: Re: [PATCH 2/4] s390/pci: track whether util_str is valid in the
 zpci_dev
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        alex.williamson@redhat.com, cohuck@redhat.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1600529318-8996-1-git-send-email-mjrosato@linux.ibm.com>
 <1600529318-8996-3-git-send-email-mjrosato@linux.ibm.com>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <d1bc0e6b-2a9b-3de0-4dd6-59e26d6c1da4@linux.ibm.com>
Date:   Mon, 21 Sep 2020 11:41:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1600529318-8996-3-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-21_01:2020-09-21,2020-09-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 mlxscore=0 suspectscore=0 impostorscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009210069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Matthew,

On 9/19/20 5:28 PM, Matthew Rosato wrote:
> We'll need to keep track of whether or not the byte string in util_str is
> valid and thus needs to be passed to a vfio-pci passthrough device.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  arch/s390/include/asm/pci.h | 3 ++-
>  arch/s390/pci/pci_clp.c     | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 882e233..32eb975 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -132,7 +132,8 @@ struct zpci_dev {
>  	u8		rid_available	: 1;
>  	u8		has_hp_slot	: 1;
>  	u8		is_physfn	: 1;
> -	u8		reserved	: 5;
> +	u8		util_avail	: 1;

Any reason you're not matching the util_str_avail name in the response struct?
I think this is currently always an EBCDIC encoded string so the information that
even if it looks like binary for anyone with a non-mainframe background
it is in fact a string seems quite helpful.
Other than that

Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>

> +	u8		reserved	: 4;
>  	unsigned int	devfn;		/* DEVFN part of the RID*/
>  
>  	struct mutex lock;
> diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
> index 48bf316..d011134 100644
> --- a/arch/s390/pci/pci_clp.c
> +++ b/arch/s390/pci/pci_clp.c
> @@ -168,6 +168,7 @@ static int clp_store_query_pci_fn(struct zpci_dev *zdev,
>  	if (response->util_str_avail) {
>  		memcpy(zdev->util_str, response->util_str,
>  		       sizeof(zdev->util_str));
> +		zdev->util_avail = 1;
>  	}
>  	zdev->mio_capable = response->mio_addr_avail;
>  	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
> 
