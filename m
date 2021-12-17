Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3858479327
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 18:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239954AbhLQRyl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 12:54:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4458 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236205AbhLQRyk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 12:54:40 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BHFbiT3038646;
        Fri, 17 Dec 2021 17:54:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pC5Vw65YNMKN7BRe0+upli9ur6fMFqFYirBeQT/nF+8=;
 b=OAKWXY/CChPMl1aE1tA1TVyVq0ZYVRor5hESdjw0+QNvhMnbwWl187w3qR48cHE9ps/e
 JxwvnQugfwFecfOlMN3RrVFq/k5axWFTzqnKtUc59dVezCQF5D/z+3C/LngZy+je4VKU
 9MohTIVFPu2+0tBnrtv8a3gIj/Xm0okEIu7VdCDOo5Ixl2vHCqDMqAAIzB6RI/jFp1QF
 Fu4N9GHSpwG8My/4+A26+OyMOWhyQln5gPHvsw5iiD5er/94O0BhbNPQeAtRutV8J67I
 XVKWO98X6FPVHNhKcrVisToT+unco2ryCADPJebHETeDvxu+Q2GkYm0Nc4qHV2cG3Mw7 2w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cymkx73he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 17:54:40 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BHHe4v5019853;
        Fri, 17 Dec 2021 17:54:40 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cymkx73h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 17:54:40 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BHHDTcP015277;
        Fri, 17 Dec 2021 17:54:39 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 3cy772f37m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 17:54:39 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BHHsbeO9110338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 17:54:37 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B99A5124054;
        Fri, 17 Dec 2021 17:54:37 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60EAD124058;
        Fri, 17 Dec 2021 17:54:33 +0000 (GMT)
Received: from [9.211.79.24] (unknown [9.211.79.24])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 17 Dec 2021 17:54:33 +0000 (GMT)
Message-ID: <28bc9d59-9772-ceae-f48d-1cd3445a105d@linux.ibm.com>
Date:   Fri, 17 Dec 2021 12:54:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 25/32] vfio/pci: re-introduce CONFIG_VFIO_PCI_ZDEV
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-26-mjrosato@linux.ibm.com>
 <01530507-184c-782d-0ae3-632df0308d56@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <01530507-184c-782d-0ae3-632df0308d56@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pffhY7zYv-hrkZTELdQ_1Ydm31F73XE5
X-Proofpoint-ORIG-GUID: WYSFZ5k5DHr3IwWXYRannv5Iehw7-TfV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_07,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170100
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/21 11:49 AM, Christian Borntraeger wrote:
> 
> 
> Am 07.12.21 um 21:57 schrieb Matthew Rosato:
>> This was previously removed as unnecessary; while that was true, 
>> subsequent
>> changes will make KVM an additional required component for vfio-pci-zdev.
>> Let's re-introduce CONFIG_VFIO_PCI_ZDEV as now there is actually a reason
>> to say 'n' for it (when not planning to CONFIG_KVM).
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   drivers/vfio/pci/Kconfig      | 11 +++++++++++
>>   drivers/vfio/pci/Makefile     |  2 +-
>>   include/linux/vfio_pci_core.h |  2 +-
>>   3 files changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
>> index 860424ccda1b..fedd1d4cb592 100644
>> --- a/drivers/vfio/pci/Kconfig
>> +++ b/drivers/vfio/pci/Kconfig
>> @@ -42,5 +42,16 @@ config VFIO_PCI_IGD
>>         and LPC bridge config space.
>>         To enable Intel IGD assignment through vfio-pci, say Y.
>> +
>> +config VFIO_PCI_ZDEV
>> +    bool "VFIO PCI extensions for s390x KVM passthrough"
>> +    depends on S390 && KVM
> 
> does this also depend on vfio-pci?
> 

Yes - but this config statement is already contained within an 'if 
VFIO_PCI' block along with config VFIO_PCI_VGA and config VFIO_PCI_IGD.


