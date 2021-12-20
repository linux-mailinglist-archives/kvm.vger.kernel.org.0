Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90C547B20D
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 18:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240180AbhLTRZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 12:25:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25244 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233139AbhLTRZO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Dec 2021 12:25:14 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BKGSs9b016600;
        Mon, 20 Dec 2021 17:25:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gqSD4h4kvlqVEOACO6pfhDgwtbRTJH/z9VOTPQEA4kA=;
 b=HulK5k8roXdJwT2+/7jcKYJIoYIrtt6K2Nc1XG07kQ9SsQEd7PHq57hJSfTYZABx3SEH
 ZSLgBzm6SZY40PRY8Yi/mjPwLLjvvJV3P0TziY+tLYKXw1KlRnCAKVNo6H+TG3PYIdFj
 VffkAQUY/PBa6ANod83V0w5h7fFWTjNuO+2l9w0YPDcce/cEJys3x8kq71mEnPr7r28I
 E7yI+hY7PXomDAVcsAEOKvqfkdKvqf08hGBXcMAGmk28JqqGQ4K8P9jnp/ARZvwCuhlN
 xrkiWCK0I1ylKG/WxtmZlreEkEegfTOmbpowcp6nQXSz4dxJc5qIrro72qra6ePwW/xb iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d1sqn8dp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 17:25:14 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BKGrFvq016984;
        Mon, 20 Dec 2021 17:25:13 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d1sqn8dn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 17:25:13 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BKHNUda015231;
        Mon, 20 Dec 2021 17:25:11 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3d1799x17p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 17:25:11 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BKHP7iB41353608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Dec 2021 17:25:07 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A47C2AE051;
        Mon, 20 Dec 2021 17:25:07 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C414AE045;
        Mon, 20 Dec 2021 17:25:06 +0000 (GMT)
Received: from [9.171.18.110] (unknown [9.171.18.110])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Dec 2021 17:25:06 +0000 (GMT)
Message-ID: <3c7e0bb9-f698-066b-8f6d-93c45438ff32@linux.ibm.com>
Date:   Mon, 20 Dec 2021 18:26:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 13/32] KVM: s390: pci: add basic kvm_zdev structure
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-14-mjrosato@linux.ibm.com>
 <37b5de48-adef-225e-fafc-f918b64e7736@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <37b5de48-adef-225e-fafc-f918b64e7736@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NIW17LTxKi8tqhU4MdcEcwiTb9b4kVic
X-Proofpoint-GUID: z_THP8IatfApU7TLD_NvyKHRKAC_bPMc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-20_08,2021-12-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 clxscore=1015 bulkscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112200096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/17/21 21:26, Matthew Rosato wrote:
> On 12/7/21 3:57 PM, Matthew Rosato wrote:
>> This structure will be used to carry kvm passthrough information 
>> related to
>> zPCI devices.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
> ...
>>   static inline bool zdev_enabled(struct zpci_dev *zdev)
>> diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
>> index b3aaadc60ead..95ea865e5d29 100644
>> --- a/arch/s390/kvm/Makefile
>> +++ b/arch/s390/kvm/Makefile
>> @@ -10,6 +10,6 @@ common-objs = $(KVM)/kvm_main.o $(KVM)/eventfd.o  
>> $(KVM)/async_pf.o \
>>   ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
>>   kvm-objs := $(common-objs) kvm-s390.o intercept.o interrupt.o priv.o 
>> sigp.o
>> -kvm-objs += diag.o gaccess.o guestdbg.o vsie.o pv.o
>> +kvm-objs += diag.o gaccess.o guestdbg.o vsie.o pv.o pci.o
> 
> This should instead be
> 
> kvm-objs-$(CONFIG_PCI) += pci.o
> 
> I think this makes sense as we aren't about to do PCI passthrough 
> support anyway if the host kernel doesn't support PCI (no vfio-pci, 
> etc).   This will quiet the kernel test robot complaints about 
> CONFIG_PCI_NR_FUNCTIONS seen on the next patch in this series.

hum, then you will need more than this to put all pci references in 
priv.c and kvm-s390.c away.

> 
>>   obj-$(CONFIG_KVM) += kvm.o



-- 
Pierre Morel
IBM Lab Boeblingen
