Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC2047956C
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 21:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238247AbhLQU1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 15:27:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231205AbhLQU0y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 15:26:54 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BHJdw2Z023548;
        Fri, 17 Dec 2021 20:26:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NT8db8cmKoNvU/LxztBiVOpOTYslDCSznAhdQdxmHqo=;
 b=HA0csOhPpzoDkWPmTGiMLqbSU4ICpW/mW0yhEtTCF/gv2TQ6HlAxh1AGbkFYbhOjx5Sm
 ACR+WonPxG1s2C5CVW1vsHzQ8GVnHO9qUflpvR4Oy+0aPq0edw3+iV4qiXlG2L8rEFw4
 5vonU5sfQ/C2E2lS3LrZnrdBlQBLvB1wpGF1/xLs39JtudljHPuSs4nldLbAizDL4OEI
 jRSgdctF9MW547K2KDUGWR/5iQoBSDYWexJ/UcIeEqCsuJgKF50/Vn6FVdp+8cg25xlm
 l+daYXMpfj6akteG5f9N61Verg0j+QIMnqHW6XUZIQde+cIUSyTiwgbP47mDZbP2vpip /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d08snyn3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 20:26:53 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BHKQ6pf024095;
        Fri, 17 Dec 2021 20:26:53 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d08snyn3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 20:26:53 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BHK9mjl026992;
        Fri, 17 Dec 2021 20:26:52 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 3cy7e593s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 20:26:52 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BHKQpa831392092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 20:26:51 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CC88124058;
        Fri, 17 Dec 2021 20:26:51 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEAB1124054;
        Fri, 17 Dec 2021 20:26:46 +0000 (GMT)
Received: from [9.211.79.24] (unknown [9.211.79.24])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 17 Dec 2021 20:26:46 +0000 (GMT)
Message-ID: <37b5de48-adef-225e-fafc-f918b64e7736@linux.ibm.com>
Date:   Fri, 17 Dec 2021 15:26:45 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 13/32] KVM: s390: pci: add basic kvm_zdev structure
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-14-mjrosato@linux.ibm.com>
In-Reply-To: <20211207205743.150299-14-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ry33nit8jVfWMuT3yOTY4xszTU6h-RWu
X-Proofpoint-GUID: 1EemLL_KH73qOu0sqW9anHsGLX51NoaG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_08,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/21 3:57 PM, Matthew Rosato wrote:
> This structure will be used to carry kvm passthrough information related to
> zPCI devices.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
...
>   static inline bool zdev_enabled(struct zpci_dev *zdev)
> diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
> index b3aaadc60ead..95ea865e5d29 100644
> --- a/arch/s390/kvm/Makefile
> +++ b/arch/s390/kvm/Makefile
> @@ -10,6 +10,6 @@ common-objs = $(KVM)/kvm_main.o $(KVM)/eventfd.o  $(KVM)/async_pf.o \
>   ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
>   
>   kvm-objs := $(common-objs) kvm-s390.o intercept.o interrupt.o priv.o sigp.o
> -kvm-objs += diag.o gaccess.o guestdbg.o vsie.o pv.o
> +kvm-objs += diag.o gaccess.o guestdbg.o vsie.o pv.o pci.o

This should instead be

kvm-objs-$(CONFIG_PCI) += pci.o

I think this makes sense as we aren't about to do PCI passthrough 
support anyway if the host kernel doesn't support PCI (no vfio-pci, 
etc).   This will quiet the kernel test robot complaints about 
CONFIG_PCI_NR_FUNCTIONS seen on the next patch in this series.

>   
>   obj-$(CONFIG_KVM) += kvm.o
