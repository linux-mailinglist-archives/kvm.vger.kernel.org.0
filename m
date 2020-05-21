Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E8B1DC6E7
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 08:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgEUGPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 02:15:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42162 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727042AbgEUGPw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 May 2020 02:15:52 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04L648bQ076222;
        Thu, 21 May 2020 02:15:52 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 315km8gyba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 May 2020 02:15:52 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04L65LKm080441;
        Thu, 21 May 2020 02:15:51 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 315km8gyat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 May 2020 02:15:51 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04L6ESRw006208;
        Thu, 21 May 2020 06:15:50 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 313whbbyb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 May 2020 06:15:50 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04L6FmQu41812362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 May 2020 06:15:48 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65547AC059;
        Thu, 21 May 2020 06:15:48 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA2B4AC062;
        Thu, 21 May 2020 06:15:47 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.205.15])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTPS;
        Thu, 21 May 2020 06:15:47 +0000 (GMT)
Subject: Re: [PATCH v7 3/3] s390/kvm: diagnose 0x318 get/set handling
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
References: <20200515221935.18775-1-walling@linux.ibm.com>
 <20200515221935.18775-4-walling@linux.ibm.com>
 <b08dbb8a-76fd-3693-d470-6171074ffce4@de.ibm.com>
From:   Collin Walling <walling@linux.ibm.com>
Message-ID: <d1ef0fed-053c-8e95-f5a6-53423de27957@linux.ibm.com>
Date:   Thu, 21 May 2020 02:15:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <b08dbb8a-76fd-3693-d470-6171074ffce4@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-21_02:2020-05-20,2020-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 cotscore=-2147483648 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005210040
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/18/20 5:15 AM, Christian Borntraeger wrote:
> 
> 
> On 16.05.20 00:19, Collin Walling wrote:
>> DIAGNOSE 0x318 (diag 318) sets information regarding the environment
>> the VM is running in (Linux, z/VM, etc) and is observed via
>> firmware/service events.
>>
>> This is a privileged s390x instruction that must be intercepted by
>> SIE. Userspace handling is required, so let's introduce some functions
>> to communicate between userspace and KVM via ioctls. These will be used
>> to get/set the diag 318 related information.
>>
>> The Control Program Name Code (CPNC) is stored in the SIE block. The
>> CPNC along with the Control Program Version Code (CPVC) are stored in
>> the kvm_arch struct.
>>
>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>> ---
>>  Documentation/virt/kvm/devices/vm.rst | 21 +++++++
>>  arch/s390/include/asm/kvm_host.h      |  5 +-
>>  arch/s390/include/uapi/asm/kvm.h      |  4 ++
>>  arch/s390/kvm/kvm-s390.c              | 82 +++++++++++++++++++++++++++
>>  arch/s390/kvm/vsie.c                  |  2 +
>>  5 files changed, 113 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
>> index 0aa5b1cfd700..52cc906dd7bd 100644
>> --- a/Documentation/virt/kvm/devices/vm.rst
>> +++ b/Documentation/virt/kvm/devices/vm.rst
>> @@ -314,3 +314,24 @@ Allows userspace to query the status of migration mode.
>>  	     if it is enabled
>>  :Returns:   -EFAULT if the given address is not accessible from kernel space;
>>  	    0 in case of success.
>> +
>> +6. GROUP: KVM_S390_VM_MISC
>> +==========================
>> +
>> +:Architectures: s390
>> +
>> +6.1. KVM_S390_VM_MISC_DIAG_318 (r/w)
>> +-----------------------------------
>> +
>> +Allows userspace to retrieve and set the DIAGNOSE 0x318 information,
>> +which consists of a 1-byte "Control Program Name Code" and a 7-byte
>> +"Control Program Version Code" (a 64 bit value all in all). This
>> +information is set by the guest (usually during IPL). This interface is
>> +intended to allow retrieving and setting it during migration; while no
>> +real harm is done if the information is changed outside of migration,
>> +it is strongly discouraged.
>> +
>> +:Parameters: address of a buffer in user space (u64), where the
>> +	     information is read from or stored into
>> +:Returns:    -EFAULT if the given address is not accessible from kernel space;
>> +	     0 in case of success
> 
> 
> An alternative would be a new sync_reg value + KVM capability.
> 
> 

I did some investigation into this (new grounds for me)

sync_reg would handle the migration part, and then we'd just need the
ioctl so the diag instruction handler can set the data. Does that sound
right?

-- 
Regards,
Collin

Stay safe and stay healthy
