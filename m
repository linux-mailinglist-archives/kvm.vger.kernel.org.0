Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DE41F7A87
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 17:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgFLPP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jun 2020 11:15:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37194 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726085AbgFLPPZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Jun 2020 11:15:25 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05CEWLWc135855;
        Fri, 12 Jun 2020 11:15:23 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31m8u1xgt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jun 2020 11:15:22 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05CF0uMW088858;
        Fri, 12 Jun 2020 11:15:21 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31m8u1xgn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jun 2020 11:15:20 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05CF5pb0008300;
        Fri, 12 Jun 2020 15:15:10 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 31g2s83h9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jun 2020 15:15:10 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05CFF7g142926352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jun 2020 15:15:07 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84E0C42045;
        Fri, 12 Jun 2020 15:15:07 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A0B042049;
        Fri, 12 Jun 2020 15:15:07 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.76.70])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Jun 2020 15:15:07 +0000 (GMT)
Subject: Re: [PATCH] s390: protvirt: virtio: Refuse device without IOMMU
To:     Mauricio Tavares <raubvogel@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <1591794711-5915-1-git-send-email-pmorel@linux.ibm.com>
 <CAHEKYV6edAHyrW-VQtW5ufZkqpXbfd1sU9N4BqOktezdffHTsg@mail.gmail.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <56545c29-c906-0020-6727-0e35c21741f5@linux.ibm.com>
Date:   Fri, 12 Jun 2020 17:15:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAHEKYV6edAHyrW-VQtW5ufZkqpXbfd1sU9N4BqOktezdffHTsg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-11_23:2020-06-11,2020-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 mlxlogscore=999 spamscore=0 cotscore=-2147483648 phishscore=0
 suspectscore=0 adultscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006110174
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-12 15:45, Mauricio Tavares wrote:
> On Wed, Jun 10, 2020 at 12:32 PM Pierre Morel <pmorel@linux.ibm.com> wrote:
>>
>> Protected Virtualisation protects the memory of the guest and
>> do not allow a the host to access all of its memory.
>>
>> Let's refuse a VIRTIO device which does not use IOMMU
>> protected access.
>>
>        Stupid questions:

not stupid at all. :)

> 
> 1. Do all CPU families we care about (which are?) support IOMMU? Ex:
> would it recognize an ARM thingie with SMMU? [1]

In Message-ID: <6356ba7f-afab-75e1-05ff-4a22b88c610e@linux.ibm.com>
(as answer to Jason) I modified the patch and propose to take care of 
this problem by using force_dma_unencrypted() inside virtio core instead 
of a S390 specific test.

If we use force_dma_unencrypted(dev) to check if we must refuse a device 
without the VIRTIO_F_IOMMU_PLATFORM feature, we are safe:
only architectures defining CONFIG_ARCH_HAS_FORCE_DMA_UNENCRYPTED will 
have to define force_dma_unencrypted(dev), and they can choose what to 
do by checking the architecture functionalities and/or the device.

> 2. Would it make sense to have some kind of
> yes-I-know-the-consequences-but-I-need-to-have-a-virtio-device-without-iommu-in-this-guest
> flag?

Yes, two ways:

Never refuse a device without VIRTIO_F_IOMMU_PLATFORM, by not defining 
CONFIG_ARCH_HAS_FORCE_DMA_UNENCRYPTED or by always return 0 in 
force_dma_unencrypted()

have force_dma_unencrypted() selectively answer by checking the device 
and/or architecture state.

> 
...snip...
>>
> 
> [1] https://developer.arm.com/architectures/system-architectures/system-components/system-mmu-support
> 

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
