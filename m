Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1858A1D34FE
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 17:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbgENPY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 11:24:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11924 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726056AbgENPY4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 11:24:56 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04EF5R9W055716;
        Thu, 14 May 2020 11:24:55 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 310tjpa97e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 11:24:55 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04EF5Ukt056083;
        Thu, 14 May 2020 11:24:54 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 310tjpa96r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 11:24:54 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04EFLp5h026527;
        Thu, 14 May 2020 15:24:53 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 3100ubfme8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 15:24:53 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04EFOmH98454502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 15:24:48 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65E5FC605B;
        Thu, 14 May 2020 15:24:49 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7579C605A;
        Thu, 14 May 2020 15:24:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.130.116])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Thu, 14 May 2020 15:24:48 +0000 (GMT)
Subject: Re: [PATCH v6 2/2] s390/kvm: diagnose 318 handling
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <20200513221557.14366-1-walling@linux.ibm.com>
 <20200513221557.14366-3-walling@linux.ibm.com>
 <20200514110544.147a63f8.cohuck@redhat.com>
From:   Collin Walling <walling@linux.ibm.com>
Message-ID: <d4cfe6dc-4ce6-b588-88fd-9e0bc6684e8a@linux.ibm.com>
Date:   Thu, 14 May 2020 11:24:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200514110544.147a63f8.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_05:2020-05-14,2020-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 clxscore=1015
 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501
 cotscore=-2147483648 malwarescore=0 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140133
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/14/20 5:05 AM, Cornelia Huck wrote:
> On Wed, 13 May 2020 18:15:57 -0400
> Collin Walling <walling@linux.ibm.com> wrote:
> 
>> DIAGNOSE 0x318 (diag318) is a privileged s390x instruction that must
>> be intercepted by SIE and handled via KVM. Let's introduce some
>> functions to communicate between userspace and KVM via ioctls. These
>> will be used to get/set the diag318 related information, as well as
>> check the system if KVM supports handling this instruction.
>>
>> This information can help with diagnosing the environment the VM is
>> running in (Linux, z/VM, etc) if the OS calls this instruction.
>>
>> By default, this feature is disabled and can only be enabled if a
>> user space program (such as QEMU) explicitly requests it.
>>
>> The Control Program Name Code (CPNC) is stored in the SIE block
>> and a copy is retained in each VCPU. The Control Program Version
>> Code (CPVC) is not designed to be stored in the SIE block, so we
>> retain a copy in each VCPU next to the CPNC.
>>
>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>> ---
>>  Documentation/virt/kvm/devices/vm.rst | 29 +++++++++
>>  arch/s390/include/asm/kvm_host.h      |  6 +-
>>  arch/s390/include/uapi/asm/kvm.h      |  5 ++
>>  arch/s390/kvm/diag.c                  | 20 ++++++
>>  arch/s390/kvm/kvm-s390.c              | 89 +++++++++++++++++++++++++++
>>  arch/s390/kvm/kvm-s390.h              |  1 +
>>  arch/s390/kvm/vsie.c                  |  2 +
>>  7 files changed, 151 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
>> index 0aa5b1cfd700..9344d45ace6d 100644
>> --- a/Documentation/virt/kvm/devices/vm.rst
>> +++ b/Documentation/virt/kvm/devices/vm.rst
>> @@ -314,3 +314,32 @@ Allows userspace to query the status of migration mode.
>>  	     if it is enabled
>>  :Returns:   -EFAULT if the given address is not accessible from kernel space;
>>  	    0 in case of success.
>> +
>> +6. GROUP: KVM_S390_VM_MISC
> 
> This needs to be rstyfied, matching the remainder of the file.
> 
>> +Architectures: s390
>> +
>> + 6.1. KVM_S390_VM_MISC_ENABLE_DIAG318
>> +
>> + Allows userspace to enable the DIAGNOSE 0x318 instruction call for a
>> + guest OS. By default, KVM will not allow this instruction to be executed
>> + by a guest, even if support is in place. Userspace must explicitly enable
>> + the instruction handling for DIAGNOSE 0x318 via this call.
>> +
>> + Parameters: none
>> + Returns:    0 after setting a flag telling KVM to enable this feature
>> +
>> + 6.2. KVM_S390_VM_MISC_DIAG318 (r/w)
>> +
>> + Allows userspace to retrieve and set the DIAGNOSE 0x318 information,
>> + which consists of a 1-byte "Control Program Name Code" and a 7-byte
>> + "Control Program Version Code" (a 64 bit value all in all). This
>> + information is set by the guest (usually during IPL). This interface is
>> + intended to allow retrieving and setting it during migration; while no
>> + real harm is done if the information is changed outside of migration,
>> + it is strongly discouraged.
> 
> (Sorry if we discussed that already, but that was some time ago and the
> info has dropped out of my cache...)
> 
> Had we considered doing this in userspace only? If QEMU wanted to
> emulate diag 318 in tcg, it would basically need to mirror what KVM
> does; diag 318 does not seem like something where we want to optimize
> for performance, so dropping to userspace seems feasible? We'd just
> need an interface for userspace to forward anything set by the guest.
> 

My reservation with respect to handling this in userspace only is that
the data set by the instruction call is relevant to both host-level and
guest-level kernels. That data is set during kernel setup.

Right now, the instruction call is used to set a hard-coded "name code"
value, but later we want to use this instruction to also set some sort
of unique version code. The format of the version code is not yet
determined.

If guest support is handled in userspace only, then we'll have to update
the version codes in both the Linux kernel /and/ QEMU, which might be a
bit messy if things go out of sync.

>> +
>> + Parameters: address of a buffer in user space (u64), where the
>> +	     information is read from or stored into
>> + Returns:    -EFAULT if the given address is not accessible from kernel space;
>> +	     -EOPNOTSUPP if feature has not been requested to be enabled first;
>> +	     0 in case of success
> 


-- 
--
Regards,
Collin

Stay safe and stay healthy
