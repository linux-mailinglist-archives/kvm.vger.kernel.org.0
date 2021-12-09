Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF5E46EB2C
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 16:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236375AbhLIPcU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 10:32:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18756 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231371AbhLIPcT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 10:32:19 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9FM2Kd013251;
        Thu, 9 Dec 2021 15:28:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7OngiWdZx77vIHpZ2oC5RsazscGBNhLbYdx2EDiL50Q=;
 b=dtB5Lsz4MtecMpKIvxzRjzlUDp6IebwCwFAPK/b8dw2L3FO/wR8nHvRYJdCOHmaUX8JE
 Biey/O9Acl52j8oZUMMro1QlZCJGZ6jBZ+44oFceATDBZVHKJmVmbvuVqPgkmMNatSVN
 4Hl5H2wPNQ2JPmvx82c5Wy5xEK5+d5sWgyv+m5zfTIAkn9rDFa64egvNgnt10xseS9+U
 IznazDbadwg5sL5dCZ0Ec7zgM+dg6sy9gVUFwW5PQUo1A+6ubXo5H57DAoiKmIUy2EKj
 C4dbzX6l3kMUDS171X7cefNwtnWU8RUf8yfaENEi4vEteaPVd6cAGccNwwqqo8f7CicZ Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cukkh1j94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:28:45 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B9ET2k6012213;
        Thu, 9 Dec 2021 15:28:44 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cukkh1j87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:28:44 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B9FCUFK029667;
        Thu, 9 Dec 2021 15:28:42 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3cqyya106d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:28:42 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B9FSeDm29491586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 15:28:40 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E582AA4064;
        Thu,  9 Dec 2021 15:28:39 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E935EA405B;
        Thu,  9 Dec 2021 15:28:38 +0000 (GMT)
Received: from [9.171.49.66] (unknown [9.171.49.66])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 15:28:38 +0000 (GMT)
Message-ID: <8357aa40-a518-1645-d4f2-bd12975bcb4b@linux.ibm.com>
Date:   Thu, 9 Dec 2021 16:28:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 11/32] s390/pci: add helper function to find device by
 handle
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
 <20211207205743.150299-12-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211207205743.150299-12-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: V-IfF0SV2WDiAWAHx01LYneFLL4nWb1N
X-Proofpoint-ORIG-GUID: BPW_wyB90wFSomuiexKh9wdSohW0PZQ_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_06,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> Intercepted zPCI instructions will specify the desired function via a
> function handle.  Add a routine to find the device with the specified
> handle.
> 
> Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

I guess we do not have hundreds of devices, so this should be fast enough.
I guess long term wit hundreds of VFs we might want to redo the zpci_list
into a tree but for now as this is just like get_zdev_by_fid

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>   arch/s390/include/asm/pci.h |  1 +
>   arch/s390/pci/pci.c         | 16 ++++++++++++++++
>   2 files changed, 17 insertions(+)
> 
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 1a8f9f42da3a..00a2c24d6d2b 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -275,6 +275,7 @@ static inline struct zpci_dev *to_zpci_dev(struct device *dev)
>   }
>   
>   struct zpci_dev *get_zdev_by_fid(u32);
> +struct zpci_dev *get_zdev_by_fh(u32 fh);
>   
>   /* DMA */
>   int zpci_dma_init(void);
> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> index 9b4d3d78b444..af1c0ae017b1 100644
> --- a/arch/s390/pci/pci.c
> +++ b/arch/s390/pci/pci.c
> @@ -76,6 +76,22 @@ struct zpci_dev *get_zdev_by_fid(u32 fid)
>   	return zdev;
>   }
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
>   void zpci_remove_reserved_devices(void)
>   {
>   	struct zpci_dev *tmp, *zdev;
> 
