Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E62F492CF3
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 19:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347718AbiARSFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 13:05:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61800 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237348AbiARSFl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 13:05:41 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IGvbt8015118;
        Tue, 18 Jan 2022 18:05:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fSu/Xg8aajTRlELlulYjnIVdNTp9KCsX1D7Q3mCfhvI=;
 b=kqj789nuPIB5EFkJvYifwCBg/rZ03aMKtpwznroks084hXzkyIEqWcT36i/qH5/KUHFo
 Oxd4kchQxvipjAPHp7WfiZFuYZ51Y6QQaJZ1rrtiF+aH2mhHQS9+DVV5iWqiI/CazA5G
 QHyypcqp7I5ELvF7n8HmkKTgKi1GuJ37O+jQyJpZ3sZz+gcEfEYSfzSsyX7K6ayGo2Kb
 d5MET6fRFaTfuvb5LNTEQJb3oJ80HCkGchOHb4sDzM+AGkmKBifKAT/WyelK2dRD1J4/
 2QZbdTVuWDxpPC4Js2PvsgXomMBG1dcfeXovc7zQXXE+88YReYL0HNCO32/ulkwm9zvR PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dp1hfsjgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:05:40 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20II5eAd004347;
        Tue, 18 Jan 2022 18:05:40 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dp1hfsjg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:05:40 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20II1vkl014261;
        Tue, 18 Jan 2022 18:05:38 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma05wdc.us.ibm.com with ESMTP id 3dknwaq3eh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:05:38 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20II5aFr34078978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 18:05:36 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C11C6E052;
        Tue, 18 Jan 2022 18:05:36 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66F7A6E05F;
        Tue, 18 Jan 2022 18:05:34 +0000 (GMT)
Received: from [9.163.19.30] (unknown [9.163.19.30])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 18:05:34 +0000 (GMT)
Message-ID: <2b624b9b-3cc3-23cd-d53f-385332ae6a0e@linux.ibm.com>
Date:   Tue, 18 Jan 2022 13:05:33 -0500
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
 <e1cd6368-bb1a-1a4d-df83-8190524b9a4d@linux.ibm.com>
 <4cde7eee-72ef-6bec-bb19-606ca57302dd@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <4cde7eee-72ef-6bec-bb19-606ca57302dd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -xnS3U12NbZCRBlClX7mf8S5XnZOptRb
X-Proofpoint-ORIG-GUID: NWtrTaeC_H6_LdyNZxD6Dbc2UrhQRqdQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/22 12:45 PM, Pierre Morel wrote:
> 
> 
> On 1/18/22 18:32, Matthew Rosato wrote:
>> On 1/18/22 12:20 PM, Pierre Morel wrote:
>>>
>>>
>>> On 1/14/22 21:31, Matthew Rosato wrote:
>>>> This was previously removed as unnecessary; while that was true, 
>>>> subsequent
>>>> changes will make KVM an additional required component for 
>>>> vfio-pci-zdev.
>>>> Let's re-introduce CONFIG_VFIO_PCI_ZDEV as now there is actually a 
>>>> reason
>>>> to say 'n' for it (when not planning to CONFIG_KVM).
>>>>
>>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>>> ---
>>>>   drivers/vfio/pci/Kconfig      | 11 +++++++++++
>>>>   drivers/vfio/pci/Makefile     |  2 +-
>>>>   include/linux/vfio_pci_core.h |  2 +-
>>>>   3 files changed, 13 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
>>>> index 860424ccda1b..fedd1d4cb592 100644
>>>> --- a/drivers/vfio/pci/Kconfig
>>>> +++ b/drivers/vfio/pci/Kconfig
>>>> @@ -42,5 +42,16 @@ config VFIO_PCI_IGD
>>>>         and LPC bridge config space.
>>>>         To enable Intel IGD assignment through vfio-pci, say Y.
>>>> +
>>>> +config VFIO_PCI_ZDEV
>>>> +    bool "VFIO PCI extensions for s390x KVM passthrough"
>>>> +    depends on S390 && KVM
>>>> +    default y
>>>> +    help
>>>> +      Support s390x-specific extensions to enable support for 
>>>> enhancements
>>>> +      to KVM passthrough capabilities, such as interpretive 
>>>> execution of
>>>> +      zPCI instructions.
>>>> +
>>>> +      To enable s390x KVM vfio-pci extensions, say Y.
>>>
>>> In several patches we check on CONFIG_PCI (14,15,16,17 and 22) but we 
>>> may have PCI without VFIO_PCI, wouldn't it be a problem?
>>>
>>> Here we define a new CONFIG entry and I have two questions:
>>>
>>> 1- there is no dependency on VFIO_PCI while the functionality is 
>>> obviously based on VFIO_PCI
>>
>> It's not obvious from this diff, but this 'config VFIO_PCI_ZDEV' 
>> statement is within an 'if VFIO_PCI' statement, just like VFIO_PCI_IGD 
>> above -- so the dependency is there.
> 
> sorry, I remember now you already answered this to Christian last time.
> 
>>
>>>
>>> 2- Wouldn't it be possible to use this item and the single condition 
>>> for the different checks we need through the new VFIO interpretation 
>>> functionality.
>>
>> Possibly, but 1) we'd have to make linking arch/s390/kvm/pci.o 
>> dependent on CONFIG_VFIO_PCI instead of CONFIG_PCI in patch 14 and 2) 
>> if the relationship between CONFIG_VFIO_PCI and CONFIG_PCI were to 
>> ever change (though I don't see why it would..), we would be broken 
>> because the symbols we are referencing really require CONFIG_PCI (as 
>> they are located in s390 PCI).
>>
> 
> Yes but VFIO_PCI_ZDEV depends on KVM, PCI and on VFIO_PCI
> Wouldn't a single config item for this new code be easier to manage and 
> understand?
> 

I guess my primary resistance is to abstracting/hiding the dependency. 
Yes, userspace will never setup for zPCI interpretation without 
CONFIG_VFIO_PCI{_ZDEV}, but that's not where the compilation dependency 
is -- it's on CONFIG_PCI specifically.

But I guess on the other hand you could argue why even bother building 
pci.o into kvm without CONFIG_VFIO_PCI_ZDEV as it will never be used.

OK, I will have a look at making this change.  It will require a little 
reorganization, at least moving this patch up before patch 14.
