Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3E0159A2E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 21:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730935AbgBKUD1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 15:03:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60752 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728745AbgBKUD0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Feb 2020 15:03:26 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01BJn8mZ100772
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 15:03:25 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y3yw75vfp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 15:03:25 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 11 Feb 2020 20:03:22 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 11 Feb 2020 20:03:20 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01BK3I4b67043530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Feb 2020 20:03:18 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A562842047;
        Tue, 11 Feb 2020 20:03:18 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E379A42049;
        Tue, 11 Feb 2020 20:03:17 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.170.228])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Feb 2020 20:03:17 +0000 (GMT)
Subject: Re: [PATCH 35/35] DOCUMENTATION: Protected virtual machine
 introduction and IPL
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-36-borntraeger@de.ibm.com>
 <5d8050a6-c730-4325-2d46-2b5c9cdc8408@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Tue, 11 Feb 2020 21:03:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <5d8050a6-c730-4325-2d46-2b5c9cdc8408@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20021120-0020-0000-0000-000003A94221
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021120-0021-0000-0000-0000220123B6
Message-Id: <a2e5f248-4d4d-5650-6f48-174bddd328f9@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-11_05:2020-02-11,2020-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 suspectscore=0 spamscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002110132
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11.02.20 13:23, Thomas Huth wrote:
> On 07/02/2020 12.39, Christian Borntraeger wrote:
>> From: Janosch Frank <frankja@linux.ibm.com>
>>
>> Add documentation about protected KVM guests and description of changes
>> that are necessary to move a KVM VM into Protected Virtualization mode.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> [borntraeger@de.ibm.com: fixing and conversion to rst]
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
> [...]
>> diff --git a/Documentation/virt/kvm/s390-pv-boot.rst b/Documentation/virt/kvm/s390-pv-boot.rst
>> new file mode 100644
>> index 000000000000..47814e53369a
>> --- /dev/null
>> +++ b/Documentation/virt/kvm/s390-pv-boot.rst
>> @@ -0,0 +1,79 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +======================================
>> +s390 (IBM Z) Boot/IPL of Protected VMs
>> +======================================
>> +
>> +Summary
>> +-------
>> +Protected Virtual Machines (PVM) are not accessible by I/O or the
>> +hypervisor.  When the hypervisor wants to access the memory of PVMs
>> +the memory needs to be made accessible. When doing so, the memory will
>> +be encrypted.  See :doc:`s390-pv` for details.
>> +
>> +On IPL a small plaintext bootloader is started which provides
>> +information about the encrypted components and necessary metadata to
>> +KVM to decrypt the protected virtual machine.
>> +
>> +Based on this data, KVM will make the protected virtual machine known
>> +to the Ultravisor(UV) and instruct it to secure the memory of the PVM,
>> +decrypt the components and verify the data and address list hashes, to
>> +ensure integrity. Afterwards KVM can run the PVM via the SIE
>> +instruction which the UV will intercept and execute on KVM's behalf.
>> +
>> +The switch into PV mode lets us load encrypted guest executables and
> 
> Maybe rather: "After the switch into PV mode, the guest can load ..." ?

No its not after the switch. By doing the switch the guest image can be loaded
fro anywhere because it is just like a kernel.

So I will do:

As the guest image is just like an opaque kernel image that does the
switch into PV mode itself, the user can load encrypted guest
executables and data via every available method (network, dasd, scsi,
direct kernel, ...) without the need to change the boot process.



> 
>> +data via every available method (network, dasd, scsi, direct kernel,
>> +...) without the need to change the boot process.
>> +
>> +
>> +Diag308
>> +-------
>> +This diagnose instruction is the basis for VM IPL. The VM can set and
>> +retrieve IPL information blocks, that specify the IPL method/devices
>> +and request VM memory and subsystem resets, as well as IPLs.
>> +
>> +For PVs this concept has been extended with new subcodes:
>> +
>> +Subcode 8: Set an IPL Information Block of type 5 (information block
>> +for PVMs)
>> +Subcode 9: Store the saved block in guest memory
>> +Subcode 10: Move into Protected Virtualization mode
>> +
>> +The new PV load-device-specific-parameters field specifies all data,
> 
> remove the comma?

ack.

> 
>> +that is necessary to move into PV mode.
>> +
>> +* PV Header origin
>> +* PV Header length
>> +* List of Components composed of
>> +   * AES-XTS Tweak prefix
>> +   * Origin
>> +   * Size
>> +
>> +The PV header contains the keys and hashes, which the UV will use to
>> +decrypt and verify the PV, as well as control flags and a start PSW.
>> +
>> +The components are for instance an encrypted kernel, kernel cmd and
> 
> s/kernel cmd/kernel parameters/ ?

ack
> 
>> +initrd. The components are decrypted by the UV.
>> +
>> +All non-decrypted data of the guest before it switches to protected
>> +virtualization mode are zero on first access of the PV.
> 
> Before it switches to protected virtualization mode, all non-decrypted
> data of the guest are ... ?

No, this is about the data after the initial import.
What about

After the initial import of the encrypted data all defined pages will
contain the guest content. All non-specified pages will start out as
zero pages on first access.


> 
>> +
>> +When running in protected mode some subcodes will result in exceptions
>> +or return error codes.
>> +
>> +Subcodes 4 and 7 will result in specification exceptions as they would
>> +not clear out the guest memory.
>> +When removing a secure VM, the UV will clear all memory, so we can't
>> +have non-clearing IPL subcodes.
>> +
>> +Subcodes 8, 9, 10 will result in specification exceptions.
>> +Re-IPL into a protected mode is only possible via a detour into non
>> +protected mode.
>> +
>> +Keys
>> +----
>> +Every CEC will have a unique public key to enable tooling to build
>> +encrypted images.
>> +See  `s390-tools <https://github.com/ibm-s390-tools/s390-tools/>`_
>> +for the tooling.
>> diff --git a/Documentation/virt/kvm/s390-pv.rst b/Documentation/virt/kvm/s390-pv.rst
>> new file mode 100644
>> index 000000000000..dbe9110dfd1e
>> --- /dev/null
>> +++ b/Documentation/virt/kvm/s390-pv.rst
>> @@ -0,0 +1,116 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +=========================================
>> +s390 (IBM Z) Ultravisor and Protected VMs
>> +=========================================
>> +
>> +Summary
>> +-------
>> +Protected virtual machines (PVM) are KVM VMs, where KVM can't access
>> +the VM's state like guest memory and guest registers anymore. Instead,
>> +the PVMs are mostly managed by a new entity called Ultravisor
>> +(UV). The UV provides an API that can be used by PVMs and KVM to
>> +request management actions.
>> +
>> +Each guest starts in the non-protected mode and then may make a
>> +request to transition into protected mode. On transition, KVM
>> +registers the guest and its VCPUs with the Ultravisor and prepares
>> +everything for running it.
>> +
>> +The Ultravisor will secure and decrypt the guest's boot memory
>> +(i.e. kernel/initrd). It will safeguard state changes like VCPU
>> +starts/stops and injected interrupts while the guest is running.
>> +
>> +As access to the guest's state, such as the SIE state description, is
>> +normally needed to be able to run a VM, some changes have been made in
>> +SIE behavior. A new format 4 state description has been introduced,
> 
> s/in SIE behavior/in the behavior of the SIE instruction/ ?

ack
> 

