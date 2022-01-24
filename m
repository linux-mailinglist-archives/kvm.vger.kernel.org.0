Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3B3498633
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 18:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244371AbiAXROf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 12:14:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43910 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244430AbiAXROF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 12:14:05 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OFjDMg017614;
        Mon, 24 Jan 2022 17:14:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dXmZKoE+UR/LnkjHSxxzyrRlw3bhfBb5oC00h5Il9Z4=;
 b=YrEpnPnt44Zvvnexw/Ywp2SdmPxAY9xjygz3MFtTv5ql6mr13uy0v+jX/DhqT4+WpwEX
 +ydMkXrqdsl5JkZFbGURzpn0ZPWqknvDmECFLQ4jEq+0Vp5/avjW7VK/EXRENrgbeguW
 yJ64WkxX+tac/NTi2qC0GGivUCzpYQ+m+v3hO+CzmdaJep80SV8SWc7xWwRfLxKaDd65
 a1lfvY3m69E55imRbJUhPio/EpcD05RsT1t/WT1l5RcqAxD92IH20a3Tu1FXyEXBS9ot
 JAKhH6O60KXfvEuX6DBkKFOKTo0gzZ1Nhu8Of8dFS/Lfx8RnVAi6mswO2HQeZdtHfRtz sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dsxnxk1tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 17:14:04 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20OGw9Zx000550;
        Mon, 24 Jan 2022 17:14:04 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dsxnxk1sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 17:14:04 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20OHBMEI018900;
        Mon, 24 Jan 2022 17:14:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3dr9j8xr9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 17:14:02 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20OHDxfK46989632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jan 2022 17:13:59 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 395F011C050;
        Mon, 24 Jan 2022 17:13:59 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C46711C052;
        Mon, 24 Jan 2022 17:13:58 +0000 (GMT)
Received: from [9.171.89.189] (unknown [9.171.89.189])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jan 2022 17:13:58 +0000 (GMT)
Message-ID: <579f8642-5b3d-7d23-cc95-403393c372fd@linux.ibm.com>
Date:   Mon, 24 Jan 2022 18:15:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 17/30] KVM: s390: mechanism to enable guest zPCI
 Interpretation
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
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-18-mjrosato@linux.ibm.com>
 <7125d611-5440-09ae-429a-7a087dd77868@linux.ibm.com>
 <7a1fa398-3304-cb30-10c0-83e12ac9e8ac@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <7a1fa398-3304-cb30-10c0-83e12ac9e8ac@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ph3t5M1mcdi5cNc0dcYjajN-fKloz766
X-Proofpoint-ORIG-GUID: uBw-U-LCFDT2zqd1i1rFodNtkSSnW2WU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-24_08,2022-01-24_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 impostorscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201240114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/24/22 16:28, Matthew Rosato wrote:
> On 1/24/22 9:24 AM, Pierre Morel wrote:
>>
>>
>> On 1/14/22 21:31, Matthew Rosato wrote:
>>> The guest must have access to certain facilities in order to allow
>>> interpretive execution of zPCI instructions and adapter event
>>> notifications.  However, there are some cases where a guest might
>>> disable interpretation -- provide a mechanism via which we can defer
>>> enabling the associated zPCI interpretation facilities until the guest
>>> indicates it wishes to use them.
>>>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> ---
>>>   arch/s390/include/asm/kvm_host.h |  4 ++++
>>>   arch/s390/kvm/kvm-s390.c         | 40 ++++++++++++++++++++++++++++++++
>>>   arch/s390/kvm/kvm-s390.h         | 10 ++++++++
>>>   3 files changed, 54 insertions(+)
>>>
>>> diff --git a/arch/s390/include/asm/kvm_host.h 
>>> b/arch/s390/include/asm/kvm_host.h
>>> index 3f147b8d050b..38982c1de413 100644
>>> --- a/arch/s390/include/asm/kvm_host.h
>>> +++ b/arch/s390/include/asm/kvm_host.h
>>> @@ -252,7 +252,10 @@ struct kvm_s390_sie_block {
>>>   #define ECB2_IEP    0x20
>>>   #define ECB2_PFMFI    0x08
>>>   #define ECB2_ESCA    0x04
>>> +#define ECB2_ZPCI_LSI    0x02
>>>       __u8    ecb2;                   /* 0x0062 */
>>> +#define ECB3_AISI    0x20
>>> +#define ECB3_AISII    0x10
>>>   #define ECB3_DEA 0x08
>>>   #define ECB3_AES 0x04
>>>   #define ECB3_RI  0x01
>>> @@ -938,6 +941,7 @@ struct kvm_arch{
>>>       int use_cmma;
>>>       int use_pfmfi;
>>>       int use_skf;
>>> +    int use_zpci_interp;
>>>       int user_cpu_state_ctrl;
>>>       int user_sigp;
>>>       int user_stsi;
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index ab8b56deed11..b6c32fc3b272 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -1029,6 +1029,44 @@ static int kvm_s390_vm_set_crypto(struct kvm 
>>> *kvm, struct kvm_device_attr *attr)
>>>       return 0;
>>>   }
>>> +static void kvm_s390_vcpu_pci_setup(struct kvm_vcpu *vcpu)
>>> +{
>>> +    /* Only set the ECB bits after guest requests zPCI 
>>> interpretation */
>>> +    if (!vcpu->kvm->arch.use_zpci_interp)
>>> +        return;
>>> +
>>> +    vcpu->arch.sie_block->ecb2 |= ECB2_ZPCI_LSI;
>>> +    vcpu->arch.sie_block->ecb3 |= ECB3_AISII + ECB3_AISI;
>>
>> As far as I understood, the interpretation is only possible if a gisa 
>> designation is associated with the PCI function via CLP enable.
>>
> 
> This is true.  Once ECB is enabled, you must have either a SHM bit on 
> for emulated device support or SHM bits off + a GISA designation 
> registered for interpretation.  Otherwise, PCI instructions will fail.

AFAIU the PCI instruction should not fail but trigger an interception if 
the GISA designation field of the CLP enable.

However, what you do is not false.
So I think we better keep what you propose.

> 
>> Why do we setup the SIE ECB only when the guest requests for 
>> interpretation and not systematically in vcpu_setup?
> 
> Once the ECB is enabled for a guest, emulated device FHs must have a SHM 
> bit in order to continue working properly (so do passthrough devices 
> that don't setup interpretation).  This was not a requirement before 
> this series -- simply having the ECB bit off would ensure intercepts for 
> all devices regardless of SHM bit settings, so by doing an opt-in once 
> the guest indicates it will be doing interpretation we can preserve 
> backwards-compatibility with an initial mode where SHM bits are not 
> necessarily required.  However once userspace indicates it understands 
> interpretation, we can assume it is will also use SHM bits properly.

If not setting GD in CLP enable triggers interception on later PCI 
instructions, preparing all early would allow to chose between 
interpretation or interception on a function basis during the CLP set 
PCI function with the enable command and make the initialization simpler.

However, what you propose is tested and works so we can have this 
discussion later for enhancement, if it is really one.

> 
>>
>> If ECB2_ZPCI_LSI, ECB3_AISII or ECB3_AISI have an effect when the gisa 
>> designation is not specified shouldn't we have a way to clear these bits?
>>
> 
> I'm not sure that's necessary -- The idea here was for the userspace to 
> indicate 1) that it knows how to setup for interpreted devices and 2) 
> that it has a guest that wants to use at least 1 interpreted device.
> Once we know that userspace understands how to manage interpreted 
> devices (implied by its use of these new vfio feature ioctls) I think it 
> should be OK to leave these bits on and expect userspace to always do 
> the appropriate steps (SHM bits for emulated devices / forced intercept 
> passthrough devices, GISA designation for interpreted devices).

Seems reasonable.

Acked-by: Pierre Morel <pmorel@linux.ibm.com>

-- 
Pierre Morel
IBM Lab Boeblingen
