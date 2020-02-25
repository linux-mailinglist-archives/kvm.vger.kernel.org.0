Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4BD16EF06
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 20:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731582AbgBYTan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 14:30:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40832 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731450AbgBYTam (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 14:30:42 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01PJTuBN031007
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 14:30:41 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yd4h33kt6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 14:30:40 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 25 Feb 2020 19:30:39 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 25 Feb 2020 19:30:37 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01PJUY4651183628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 19:30:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1591D52050;
        Tue, 25 Feb 2020 19:30:34 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.53.31])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7FFAE5204E;
        Tue, 25 Feb 2020 19:30:33 +0000 (GMT)
Subject: Re: [PATCH v4 36/36] KVM: s390: protvirt: Add KVM api documentation
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
 <20200224114107.4646-37-borntraeger@de.ibm.com>
 <20200225165059.5a2f48a5.cohuck@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Tue, 25 Feb 2020 20:30:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200225165059.5a2f48a5.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20022519-4275-0000-0000-000003A569DD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022519-4276-0000-0000-000038B98074
Message-Id: <a392d135-c0aa-3513-b633-70aa6c7e88bd@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-25_07:2020-02-25,2020-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 bulkscore=0 suspectscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250137
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25.02.20 16:50, Cornelia Huck wrote:
> On Mon, 24 Feb 2020 06:41:07 -0500
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> From: Janosch Frank <frankja@linux.ibm.com>
>>
>> Add documentation for KVM_CAP_S390_PROTECTED capability and the
>> KVM_S390_PV_COMMAND ioctl.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>  Documentation/virt/kvm/api.rst | 55 ++++++++++++++++++++++++++++++++++
>>  1 file changed, 55 insertions(+)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 7505d7a6c0d8..20abb8b2594e 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -4648,6 +4648,51 @@ the clear cpu reset definition in the POP. However, the cpu is not put
>>  into ESA mode. This reset is a superset of the initial reset.
>>  
>>  
>> +4.125 KVM_S390_PV_COMMAND
>> +-------------------------
>> +
>> +:Capability: KVM_CAP_S390_PROTECTED
>> +:Architectures: s390
>> +:Type: vm ioctl
>> +:Parameters: struct kvm_pv_cmd
>> +:Returns: 0 on success, < 0 on error
>> +
>> +::
>> +
>> +  struct kvm_pv_cmd {
>> +	__u32 cmd;	/* Command to be executed */
>> +	__u16 rc;	/* Ultravisor return code */
>> +	__u16 rrc;	/* Ultravisor return reason code */
>> +	__u64 data;	/* Data or address */
>> +	__u32 flags;    /* flags for future extensions. Must be 0 for now */
>> +	__u32 reserved[3];
>> +  };
>> +
>> +cmd values:
>> +
>> +KVM_PV_ENABLE
>> +  Allocate memory and register the VM with the Ultravisor, thereby
>> +  donating memory to the Ultravisor making it inaccessible to KVM.
>> +  Also converts all existing CPUs to protected ones. Future hotplug
>> +  CPUs will become protected during creation.
> 
> "Allocate memory and register the VM with the Ultravisor, thereby
> donating memory to the Ultravisor that will become inaccsessible to
> KVM. All existing CPUs are converted to protected ones. After this
> command has succeeded, any CPU added via hotplug will become protected
> during its creation as well."


ok

>> +
>> +KVM_PV_DISABLE
>> +  Deregisters the VM from the Ultravisor and frees memory that was
>> +  donated, so the kernel can use it again. All registered VCPUs are
>> +  converted back to non-protected ones.
> 
> "Deregister the VM from the Ultravisor and reclaim the memory that had
> been donated to the Ultravisor, making it usable by the kernel again.
> ..."

ok

> 
>> +
>> +KVM_PV_VM_SET_SEC_PARMS
>> +  Pass the image header from VM memory to the Ultravisor in
>> +  preparation of image unpacking and verification.
>> +
>> +KVM_PV_VM_UNPACK
>> +  Unpack (protect and decrypt) a page of the encrypted boot image.
>> +
>> +KVM_PV_VM_VERIFY
>> +  Verify the integrity of the unpacked image. Only if this succeeds,
>> +  KVM is allowed to start protected VCPUs.
>> +
>> +
>>  5. The kvm_run structure
>>  ========================
>>  
>> @@ -6026,3 +6071,13 @@ Architectures: s390
>>  
>>  This capability indicates that the KVM_S390_NORMAL_RESET and
>>  KVM_S390_CLEAR_RESET ioctls are available.
>> +
>> +8.23 KVM_CAP_S390_PROTECTED
>> +
>> +Architecture: s390
>> +
>> +This capability indicates that KVM can start protected VMs and the
>> +Ultravisor has therefore been initialized.> 
> "This capability indicates that the Ultravisor has been initialized and
> KVM can therefore start protected VMs."

ok.
> 
>> +This will provide the new KVM_S390_PV_COMMAND ioctl and it will allow
>> +KVM_MP_STATE_LOAD as new MP_STATE. KVM_SET_MP_STATE can now fail for
>> +protected guests when the state change is invalid.
> 

> "This capability governs the KVM_S390_PV_COMMAND ioctl and the
> KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
> guests when the state change is invalid."

ok

