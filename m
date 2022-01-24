Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBED498387
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 16:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240411AbiAXP2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 10:28:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9786 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234124AbiAXP2V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 10:28:21 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OFKTSt039798;
        Mon, 24 Jan 2022 15:28:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kRM/GanzUsfL3rVc/Li147Vx511/1dQpjefk9VYvMg0=;
 b=XCl3PSqyYZCkSektRHeTk4g88ieB1biEBWZDk3uFSXXopaqi4qrVjzBPJvOVdVpSZYvF
 YsuUM29PDqoTO7qvqo2x4yDBrhkJc873XV3iQlzAZ9uVPbIqp1nYjyK53b2fVXZTo0Ma
 MRXt3tmLljLVMjon631hgssF8MZcWkPrnnbCNTK6mE6RNUlevfVZO3S7OMlEgkajS8C4
 VD3KMCIZYWCXFyjZ1m+BXkv7RD5nk11uX2TUk52fIgwdJK/hJSj4gsQDzBpyyZlI444d
 ZRnIhpmGVIEOa70Qsz4kTYDqU0jGqwqWGiI6nkD6HOi/kj8pn2wflvuS/HUbMpOq1rN/ ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dsxnx85d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 15:28:21 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20OFL1I2001440;
        Mon, 24 Jan 2022 15:28:20 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dsxnx85cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 15:28:20 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20OFD7xM015089;
        Mon, 24 Jan 2022 15:28:19 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 3dr9j9gh8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 15:28:19 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20OFSIsB19530122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jan 2022 15:28:18 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16BC96A05D;
        Mon, 24 Jan 2022 15:28:18 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3771B6A054;
        Mon, 24 Jan 2022 15:28:16 +0000 (GMT)
Received: from [9.163.21.206] (unknown [9.163.21.206])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jan 2022 15:28:15 +0000 (GMT)
Message-ID: <7a1fa398-3304-cb30-10c0-83e12ac9e8ac@linux.ibm.com>
Date:   Mon, 24 Jan 2022 10:28:15 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 17/30] KVM: s390: mechanism to enable guest zPCI
 Interpretation
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
 <20220114203145.242984-18-mjrosato@linux.ibm.com>
 <7125d611-5440-09ae-429a-7a087dd77868@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <7125d611-5440-09ae-429a-7a087dd77868@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: K7F7amDEbYFy0270m0ORRUS0ArBb4EF6
X-Proofpoint-ORIG-GUID: 9zHWB8uB2RkfJLOW6FtgV9GDJahOHR7-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-24_08,2022-01-24_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 bulkscore=0 mlxscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201240101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/24/22 9:24 AM, Pierre Morel wrote:
> 
> 
> On 1/14/22 21:31, Matthew Rosato wrote:
>> The guest must have access to certain facilities in order to allow
>> interpretive execution of zPCI instructions and adapter event
>> notifications.  However, there are some cases where a guest might
>> disable interpretation -- provide a mechanism via which we can defer
>> enabling the associated zPCI interpretation facilities until the guest
>> indicates it wishes to use them.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h |  4 ++++
>>   arch/s390/kvm/kvm-s390.c         | 40 ++++++++++++++++++++++++++++++++
>>   arch/s390/kvm/kvm-s390.h         | 10 ++++++++
>>   3 files changed, 54 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h 
>> b/arch/s390/include/asm/kvm_host.h
>> index 3f147b8d050b..38982c1de413 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -252,7 +252,10 @@ struct kvm_s390_sie_block {
>>   #define ECB2_IEP    0x20
>>   #define ECB2_PFMFI    0x08
>>   #define ECB2_ESCA    0x04
>> +#define ECB2_ZPCI_LSI    0x02
>>       __u8    ecb2;                   /* 0x0062 */
>> +#define ECB3_AISI    0x20
>> +#define ECB3_AISII    0x10
>>   #define ECB3_DEA 0x08
>>   #define ECB3_AES 0x04
>>   #define ECB3_RI  0x01
>> @@ -938,6 +941,7 @@ struct kvm_arch{
>>       int use_cmma;
>>       int use_pfmfi;
>>       int use_skf;
>> +    int use_zpci_interp;
>>       int user_cpu_state_ctrl;
>>       int user_sigp;
>>       int user_stsi;
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index ab8b56deed11..b6c32fc3b272 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -1029,6 +1029,44 @@ static int kvm_s390_vm_set_crypto(struct kvm 
>> *kvm, struct kvm_device_attr *attr)
>>       return 0;
>>   }
>> +static void kvm_s390_vcpu_pci_setup(struct kvm_vcpu *vcpu)
>> +{
>> +    /* Only set the ECB bits after guest requests zPCI interpretation */
>> +    if (!vcpu->kvm->arch.use_zpci_interp)
>> +        return;
>> +
>> +    vcpu->arch.sie_block->ecb2 |= ECB2_ZPCI_LSI;
>> +    vcpu->arch.sie_block->ecb3 |= ECB3_AISII + ECB3_AISI;
> 
> As far as I understood, the interpretation is only possible if a gisa 
> designation is associated with the PCI function via CLP enable.
> 

This is true.  Once ECB is enabled, you must have either a SHM bit on 
for emulated device support or SHM bits off + a GISA designation 
registered for interpretation.  Otherwise, PCI instructions will fail.

> Why do we setup the SIE ECB only when the guest requests for 
> interpretation and not systematically in vcpu_setup?

Once the ECB is enabled for a guest, emulated device FHs must have a SHM 
bit in order to continue working properly (so do passthrough devices 
that don't setup interpretation).  This was not a requirement before 
this series -- simply having the ECB bit off would ensure intercepts for 
all devices regardless of SHM bit settings, so by doing an opt-in once 
the guest indicates it will be doing interpretation we can preserve 
backwards-compatibility with an initial mode where SHM bits are not 
necessarily required.  However once userspace indicates it understands 
interpretation, we can assume it is will also use SHM bits properly.

> 
> If ECB2_ZPCI_LSI, ECB3_AISII or ECB3_AISI have an effect when the gisa 
> designation is not specified shouldn't we have a way to clear these bits?
> 

I'm not sure that's necessary -- The idea here was for the userspace to 
indicate 1) that it knows how to setup for interpreted devices and 2) 
that it has a guest that wants to use at least 1 interpreted device.
Once we know that userspace understands how to manage interpreted 
devices (implied by its use of these new vfio feature ioctls) I think it 
should be OK to leave these bits on and expect userspace to always do 
the appropriate steps (SHM bits for emulated devices / forced intercept 
passthrough devices, GISA designation for interpreted devices).
