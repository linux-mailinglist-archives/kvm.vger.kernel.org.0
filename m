Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28545492C6A
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 18:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347338AbiARRdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 12:33:04 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1088 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229568AbiARRdD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 12:33:03 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IH23pW020690;
        Tue, 18 Jan 2022 17:33:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RnxkHMfBnvNfQr8Ica+D+dP7pha12KacO4sVFRCcNZM=;
 b=iDrcxMRP+ThSo/n/ymiqvHpoGgzWexZonQIfLSqFE33M2/bRVJvJVlaHRkLyYvFSayuo
 8SQ6yLY9HNkbwEXT8sVXBtp3gU8DK855bs5i4CvzhOr8skJpS4+bSSCSzaKtrQjqEQhL
 CWiMQV00LRSHQdaQtNbCmX/XN5CvD1OOs6zo59vSWYG4EDs7a//1GfDeART0AZSgSMSh
 IrvYmaZgPbkHPK1PAWRbzC6PR3jLOICdsPJvkcC1C/IDK27shIm1HzdC6FW903PgpHEY
 ExSOxL5/dqkXyJNOP32PEjacyuGK8Q9ZWBsSuTCkbN6yEX83XxDEF1W9Y3sCQy1EA8K5 Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dp1kegqaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:33:02 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IHR6GD005192;
        Tue, 18 Jan 2022 17:33:02 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dp1kegqa1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:33:02 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IHNFnH002626;
        Tue, 18 Jan 2022 17:33:00 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3dknwapke6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:33:00 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IHWxV826870178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 17:32:59 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90EE36E062;
        Tue, 18 Jan 2022 17:32:59 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA17C6E052;
        Tue, 18 Jan 2022 17:32:57 +0000 (GMT)
Received: from [9.163.19.30] (unknown [9.163.19.30])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 17:32:57 +0000 (GMT)
Message-ID: <e1cd6368-bb1a-1a4d-df83-8190524b9a4d@linux.ibm.com>
Date:   Tue, 18 Jan 2022 12:32:56 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 23/30] vfio/pci: re-introduce CONFIG_VFIO_PCI_ZDEV
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-24-mjrosato@linux.ibm.com>
 <1ea61cf3-65b2-87ec-55b4-7dfa5f623d15@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <1ea61cf3-65b2-87ec-55b4-7dfa5f623d15@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9i6Hj0KTeqVpjtVkzm16alwqWHqoE861
X-Proofpoint-ORIG-GUID: MD-8iwRKWhthPWYzryOewjexSrZyrnpS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/22 12:20 PM, Pierre Morel wrote:
> 
> 
> On 1/14/22 21:31, Matthew Rosato wrote:
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
>> +    default y
>> +    help
>> +      Support s390x-specific extensions to enable support for 
>> enhancements
>> +      to KVM passthrough capabilities, such as interpretive execution of
>> +      zPCI instructions.
>> +
>> +      To enable s390x KVM vfio-pci extensions, say Y.
> 
> In several patches we check on CONFIG_PCI (14,15,16,17 and 22) but we 
> may have PCI without VFIO_PCI, wouldn't it be a problem?
> 
> Here we define a new CONFIG entry and I have two questions:
> 
> 1- there is no dependency on VFIO_PCI while the functionality is 
> obviously based on VFIO_PCI

It's not obvious from this diff, but this 'config VFIO_PCI_ZDEV' 
statement is within an 'if VFIO_PCI' statement, just like VFIO_PCI_IGD 
above -- so the dependency is there.

> 
> 2- Wouldn't it be possible to use this item and the single condition for 
> the different checks we need through the new VFIO interpretation 
> functionality.

Possibly, but 1) we'd have to make linking arch/s390/kvm/pci.o dependent 
on CONFIG_VFIO_PCI instead of CONFIG_PCI in patch 14 and 2) if the 
relationship between CONFIG_VFIO_PCI and CONFIG_PCI were to ever change 
(though I don't see why it would..), we would be broken because the 
symbols we are referencing really require CONFIG_PCI (as they are 
located in s390 PCI).

