Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1CB49231D
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 10:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbiARJv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 04:51:28 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52440 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231138AbiARJv1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 04:51:27 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I9dmGF010451;
        Tue, 18 Jan 2022 09:51:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wkQSZXMEaVNsfpa3rh5xL6K8iqoae3evtKToNnXBQDg=;
 b=RvA3G9cyrCfSf6/EmB5v9/yQzWpWZZo0qYUpilTygousLbcMz5+3iJPp1Ja6dqmiDZVe
 mPZ2v3gjQxXNrAqRRrnX6yvXIGS1CDb7MY8E6zvyiSJcKG6EjfmHzUv63xmMvTzar0d1
 P1B1nJ+z1gES3e8R46UkM9+X9j1teVbwBM8nI+YohpWhnOsvVfiddSbXqcSGERl9tvAg
 T89MgrJj9JgwG7yBnBiS01DBpLjDYaLeERUE252xZmps08QvcFA1GIeoouqE3JKVikHv
 XG6dGCb1HPTyLaNpnDi9y+X60k02gbPXo+/2h6AwEDX0Mt3ORGVqnqnNhSnAMv4Gl9Mi cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnkwhh0at-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:51:27 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20I94wPm039130;
        Tue, 18 Jan 2022 09:51:26 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnkwhh0a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:51:26 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20I9lEL1028620;
        Tue, 18 Jan 2022 09:51:24 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3dnm6r2heq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:51:24 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20I9pJ6X41746784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 09:51:19 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BBFCAE051;
        Tue, 18 Jan 2022 09:51:19 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B94CAE056;
        Tue, 18 Jan 2022 09:51:18 +0000 (GMT)
Received: from [9.171.70.230] (unknown [9.171.70.230])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 09:51:18 +0000 (GMT)
Message-ID: <d0113a43-5858-6283-89ef-882713df8175@linux.ibm.com>
Date:   Tue, 18 Jan 2022 10:53:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 11/30] s390/pci: add helper function to find device by
 handle
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
 <20220114203145.242984-12-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-12-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1bfXwWhvq8C1_q3jgowm0JriXSb4HunK
X-Proofpoint-GUID: nngQqh42oN8_dJUiUmkSVS8PIaxH7oKE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_02,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 bulkscore=0 phishscore=0
 impostorscore=0 spamscore=0 adultscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> Intercepted zPCI instructions will specify the desired function via a
> function handle.  Add a routine to find the device with the specified
> handle.
> 
> Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>


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
> index 0c9879dae752..1e939b4cf25e 100644
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

-- 
Pierre Morel
IBM Lab Boeblingen
