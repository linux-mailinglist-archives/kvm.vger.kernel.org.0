Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA1EC1516D7
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 09:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgBDINP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 03:13:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34924 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726406AbgBDINO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 03:13:14 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0148BXRn140769
        for <kvm@vger.kernel.org>; Tue, 4 Feb 2020 03:13:13 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxmkmf779-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 03:13:13 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 4 Feb 2020 08:13:11 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 4 Feb 2020 08:13:08 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0148D6Mc29950130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Feb 2020 08:13:06 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0679A4040;
        Tue,  4 Feb 2020 08:13:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70DC9A4053;
        Tue,  4 Feb 2020 08:13:06 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.61])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Feb 2020 08:13:06 +0000 (GMT)
Subject: Re: [RFCv2 29/37] DOCUMENTATION: protvirt: Diag 308 IPL
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-30-borntraeger@de.ibm.com>
 <20200203171333.6be61670.cohuck@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Tue, 4 Feb 2020 09:13:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200203171333.6be61670.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20020408-0020-0000-0000-000003A6CDBF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020408-0021-0000-0000-000021FE9220
Message-Id: <dcc226cc-afb4-7fea-a839-7fc99080508d@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-04_02:2020-02-04,2020-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 mlxscore=0 adultscore=0 impostorscore=0 spamscore=0
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1911200001 definitions=main-2002040060
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 03.02.20 17:13, Cornelia Huck wrote:
> On Mon,  3 Feb 2020 08:19:49 -0500
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> From: Janosch Frank <frankja@linux.ibm.com>
>>
>> Description of changes that are necessary to move a KVM VM into
>> Protected Virtualization mode.
> 
> Maybe move this up to the top of the series, so that new reviewers can
> get a quick idea about the architecture as a whole? It might also make
Will do. 
> sense to make the two documents link to each other...
I added both files to the kvm index file and changed the title
to contain s390. I also added a link to the base doc.

> 
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  Documentation/virt/kvm/s390-pv-boot.rst | 64 +++++++++++++++++++++++++
>>  1 file changed, 64 insertions(+)
>>  create mode 100644 Documentation/virt/kvm/s390-pv-boot.rst
>>
>> diff --git a/Documentation/virt/kvm/s390-pv-boot.rst b/Documentation/virt/kvm/s390-pv-boot.rst
>> new file mode 100644
>> index 000000000000..431cd5d7f686
>> --- /dev/null
>> +++ b/Documentation/virt/kvm/s390-pv-boot.rst
>> @@ -0,0 +1,64 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +=========================
>> +Boot/IPL of Protected VMs
>> +=========================
> 
> ...especially as the reader will have no idea what a "Protected VM" is,
> unless they have read the other document before.

> 
> 
>> +
>> +Summary
>> +-------
>> +Protected VMs are encrypted while not running. On IPL a small
>> +plaintext bootloader is started which provides information about the
>> +encrypted components and necessary metadata to KVM to decrypt it.
> 
> s/it/the PVM/ ?

ack

This section looks now:

---
Protected Virtual Machines (PVM) are not accessible by I/O or the
hypervisor.  When the hypervisor wants to access the memory of PVMs
the memory needs to be made accessible. When doing so, the memory will
be encrypted.  See :doc:`s390-pv` for details.

On IPL a....
---

> 
>> +
>> +Based on this data, KVM will make the PV known to the Ultravisor and
> 
> I think the other document uses 'PVM'... probably better to keep that
> consistent.

The feature name might change to secure execution (SE). I will need to
go over this again. But I think we can continue to name the virtual
machines protected virtual machines as this is more a description than
a brand name.


> 
>> +instruct it to secure its memory, decrypt the components and verify
> 
> Too many it and its here... maybe use the abbreviations instead?

fixed

> 
>> +the data and address list hashes, to ensure integrity. Afterwards KVM
>> +can run the PV via SIE which the UV will intercept and execute on
>> +KVM's behalf.
>> +
>> +The switch into PV mode lets us load encrypted guest executables and
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
>> +For PVs this concept has been continued with new subcodes:
> 
> s/continued/extended/ ?

yes.

> 
>> +
>> +Subcode 8: Set an IPL Information Block of type 5.
> 
> "type 5" == information block for PVMs? Better spell that out.

ack

> 
>> +Subcode 9: Store the saved block in guest memory
>> +Subcode 10: Move into Protected Virtualization mode
>> +
>> +The new PV load-device-specific-parameters field specifies all data,
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
> s/kernel cmd/kernel command line/ ?

ack

> 
>> +initrd. The components are decrypted by the UV.
>> +
>> +All non-decrypted data of the non-PV guest instance are zero on first
>> +access of the PV.
> 
> "non-PV guest" == "the guest before it switches to protected
> virtualization mode" ?

ack
> 
>> +
>> +
>> +When running in a protected mode some subcodes will result in
> 
> s/in a/in/

ack
> 
>> +exceptions or return error codes.
>> +
>> +Subcodes 4 and 7 will result in specification exceptions.
> 
> "Subcodes 4 and 7, which would not clear the guest memory, ..." ?

Subcodes 4 and 7 will result in specification exceptions as they would
not clear out the guest memory.

> 
>> +When removing a secure VM, the UV will clear all memory, so we can't
>> +have non-clearing IPL subcodes.
>> +
>> +Subcodes 8, 9, 10 will result in specification exceptions.
>> +Re-IPL into a protected mode is only possible via a detour into non
>> +protected mode.
> 
> In general, this looks like a good overview about how the guest can
> move into protected virt mode.
> 
> Some information I'm missing in this doc: Where do the keys come from?
> I assume from the machine... is there one key per CEC? Can keys be
> transferred? Can an image be introspected to find out if it is possible
> to run it on a given system?
> 
> (Not sure if there is a better resting place for that kind of
> information.)

There will be tooling as part of the s390-tools. I will add 

---
Keys
----
Every CEC will have a unique public key to enable tooling to build
encrypted images.
See  `s390-tools <https://github.com/ibm-s390-tools/s390-tools/>`_
for the tooling.
---

The s390 tools part is not yet upstream but it will be soon.

