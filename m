Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0964F46F4D8
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 21:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbhLIU1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 15:27:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231964AbhLIU1j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 15:27:39 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9KHBH6019953;
        Thu, 9 Dec 2021 20:24:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WUN0ND8AFkCSQKWmiIyuNColikoX9CCAOZpMI1qsFbs=;
 b=OuHYYzn/Cx/mG4qTSOdu3dw7gr2pc77u1eGdh4/ws7qdIM02aVpt8r91gbaaLJtAQFAH
 uDh+qvqvzdsYOjS8i4VbuRFFubT4RsDPQnSzLXWR16LbMMyVF1GK3F9+eLnX1Qr4gEvQ
 tDKp4XHskloCevDx58hwjn57SIalWYWRcIs1K92eYWQOtHdlzy/RHBVWjdBAXBv0MqJC
 11YQ/TVW9hPcYhnNICnae+x82sAP0fTwYGAyPi6lvxxeqKmzxmQkNqKAnvZBw4NshDPB
 6hIYV4gsgzeo/YDK5dHhszv6wwIBvG+G8rC+DlLWh87zsBdXszvMNR7h9CVbbZLNfiFt Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cuqhr9j1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 20:24:05 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B9KJv0Q001466;
        Thu, 9 Dec 2021 20:24:04 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cuqhr9j19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 20:24:04 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B9KCCX8024080;
        Thu, 9 Dec 2021 20:24:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3cqyya31t4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 20:24:02 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B9KNw0P28180796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 20:23:59 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAC5442047;
        Thu,  9 Dec 2021 20:23:58 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C53FC42041;
        Thu,  9 Dec 2021 20:23:57 +0000 (GMT)
Received: from [9.171.1.84] (unknown [9.171.1.84])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 20:23:57 +0000 (GMT)
Message-ID: <c65a9055-a472-5f89-bfd2-a80ed4973ad9@linux.ibm.com>
Date:   Thu, 9 Dec 2021 21:23:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 14/32] KVM: s390: pci: do initial setup for AEN
 interpretation
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
 <20211207205743.150299-15-mjrosato@linux.ibm.com>
 <596857e3-ab13-7513-eeda-ed407fe22732@linux.ibm.com>
 <31980a07-e2e8-cef3-f0b4-370dad4cb14c@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <31980a07-e2e8-cef3-f0b4-370dad4cb14c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UTPJaa65wVZU5lm61L37tGG_Os4NjTW1
X-Proofpoint-ORIG-GUID: 3nCVEoyZ7Rw6C5oHL8nqxusQajQpaQTH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_09,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 suspectscore=0 adultscore=0 impostorscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 09.12.21 um 21:20 schrieb Matthew Rosato:
> On 12/9/21 2:54 PM, Christian Borntraeger wrote:
>> Am 07.12.21 um 21:57 schrieb Matthew Rosato:
>>> Initial setup for Adapter Event Notification Interpretation for zPCI
>>> passthrough devices.  Specifically, allocate a structure for forwarding of
>>> adapter events and pass the address of this structure to firmware.
>>>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> ---
>>>   arch/s390/include/asm/pci_insn.h |  12 ++++
>>>   arch/s390/kvm/interrupt.c        |  17 +++++
>>>   arch/s390/kvm/kvm-s390.c         |   3 +
>>>   arch/s390/kvm/pci.c              | 113 +++++++++++++++++++++++++++++++
>>>   arch/s390/kvm/pci.h              |  42 ++++++++++++
>>>   5 files changed, 187 insertions(+)
>>>   create mode 100644 arch/s390/kvm/pci.h
>>>
>>> diff --git a/arch/s390/include/asm/pci_insn.h b/arch/s390/include/asm/pci_insn.h
>>> index 5331082fa516..e5f57cfe1d45 100644
>>> --- a/arch/s390/include/asm/pci_insn.h
>>> +++ b/arch/s390/include/asm/pci_insn.h
>>> @@ -101,6 +101,7 @@ struct zpci_fib {
>>>   /* Set Interruption Controls Operation Controls  */
>>>   #define    SIC_IRQ_MODE_ALL        0
>>>   #define    SIC_IRQ_MODE_SINGLE        1
>>> +#define    SIC_SET_AENI_CONTROLS        2
>>>   #define    SIC_IRQ_MODE_DIRECT        4
>>>   #define    SIC_IRQ_MODE_D_ALL        16
>>>   #define    SIC_IRQ_MODE_D_SINGLE        17
>>> @@ -127,9 +128,20 @@ struct zpci_cdiib {
>>>       u64 : 64;
>>>   } __packed __aligned(8);
>>> +/* adapter interruption parameters block */
>>> +struct zpci_aipb {
>>> +    u64 faisb;
>>> +    u64 gait;
>>> +    u16 : 13;
>>> +    u16 afi : 3;
>>> +    u32 : 32;
>>> +    u16 faal;
>>> +} __packed __aligned(8);
>>> +
>>>   union zpci_sic_iib {
>>>       struct zpci_diib diib;
>>>       struct zpci_cdiib cdiib;
>>> +    struct zpci_aipb aipb;
>>>   };
>>>   DECLARE_STATIC_KEY_FALSE(have_mio);
>>> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
>>> index f9b872e358c6..4efe0e95a40f 100644
>>> --- a/arch/s390/kvm/interrupt.c
>>> +++ b/arch/s390/kvm/interrupt.c
>>> @@ -32,6 +32,7 @@
>>>   #include "kvm-s390.h"
>>>   #include "gaccess.h"
>>>   #include "trace-s390.h"
>>> +#include "pci.h"
>>>   #define PFAULT_INIT 0x0600
>>>   #define PFAULT_DONE 0x0680
>>> @@ -3276,8 +3277,16 @@ static struct airq_struct gib_alert_irq = {
>>>   void kvm_s390_gib_destroy(void)
>>>   {
>>> +    struct zpci_aift *aift;
>>> +
>>>       if (!gib)
>>>           return;
>>> +    aift = kvm_s390_pci_get_aift();
>>> +    if (aift) {
>>> +        mutex_lock(&aift->lock)
>>
>> aift is a static variable and later patches seem to access that directly without the wrapper.
>> Can we get rid of kvm_s390_pci_get_aift?
> 
> kvm/interrupt.c must also access it when handling AEN forwarding (next patch)

So maybe just make it non-static and declare it in the header file?
[...]

>> Can we maybe use designated initializer for the static definition of aift, e.g. something
>> like
>> static struct zpci_aift aift = {
>>      .gait_lock = __SPIN_LOCK_UNLOCKED(aift.gait_lock),
>>      .lock    = __MUTEX_INITIALIZER(aift.lock),
>> }
>> and get rid of the init function? >
> 
> Maybe -- I can certainly do the above, but I do add a call to zpci_get_mdd() in the init function (patch 23), so if I want to in patch 23 instead add .mdd = zpci_get_mdd() to this designated initializer I'd have to re-work zpci_get_mdd (patch 12) to return the mdd rather than the CLP LIST PCI return code.  We want at least a warning if we're setting a 0 for mdd because the CLP failed for some bizarre reason.
> 
> I guess one option would be to move the WARN_ON into the zpci_get_mdd() function itself and then now we can do

So maybe leave this as is.
> 
> u32 zpci_get_mdd(void);
> 
> Niklas, what do you think?
> 
