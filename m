Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2BE1511FF
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 22:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgBCVlu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 16:41:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52572 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbgBCVlu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 16:41:50 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013LcTJU142764
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 16:41:48 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxkn2ywfs-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 16:41:48 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 3 Feb 2020 21:41:46 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 3 Feb 2020 21:41:43 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013Lffcv51183666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 21:41:41 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3B0411C054;
        Mon,  3 Feb 2020 21:41:41 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 379F911C04C;
        Mon,  3 Feb 2020 21:41:41 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.178.76])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  3 Feb 2020 21:41:41 +0000 (GMT)
Subject: Re: [RFCv2 01/37] DOCUMENTATION: protvirt: Protected virtual machine
 introduction
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-2-borntraeger@de.ibm.com>
 <20200203164250.7a2fd5a6.cohuck@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Mon, 3 Feb 2020 22:41:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200203164250.7a2fd5a6.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20020321-4275-0000-0000-0000039DA1BE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020321-4276-0000-0000-000038B1C787
Message-Id: <7a2c1152-e171-5986-9ed5-c528901baa1a@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_07:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 phishscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002030155
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 03.02.20 16:42, Cornelia Huck wrote:
[...]
>> +As access to the guest's state, such as the SIE state description, is
>> +normally needed to be able to run a VM, some changes have been made in
>> +SIE behavior. A new format 4 state description has been introduced,
>> +where some fields have different meanings for a PVM. SIE exits are
>> +minimized as much as possible to improve speed and reduce exposed
>> +guest state.
> 
> Suggestion: Can you include some ASCII art here describing the
> relationship of KVM, PVMs, and the UV? I think there was something in
> the KVM Forum talk.

Uh, maybe I find someone who is good at doing ASCII art - I am not.
I think I would prefer to have a link to the KVM forum talk?

I will add
+
+Links
+-----
+`KVM Forum 2019 presentation <https://static.sched.com/hosted_files/kvmforum2019/3b/ibm_protected_vms_s390x.pdf>`_

at the bottom, just in case.

[...]
>> +Program and Service Call exceptions have another layer of
>> +safeguarding; they can only be injected for instructions that have
>> +been intercepted into KVM. The exceptions need to be a valid outcome
> 
> s/valid/possible/ ?

hmm, this is bikeshedding, but I think valid is better because it refers to
the architecture. 

> 
>> +of an instruction emulation by KVM, e.g. we can never inject a
>> +addressing exception as they are reported by SIE since KVM has no
>> +access to the guest memory.
>> +
>> +
>> +Mask notification interceptions
>> +-------------------------------
>> +As a replacement for the lctl(g) and lpsw(e) instruction
>> +interceptions, two new interception codes have been introduced. One
>> +indicating that the contents of CRs 0, 6 or 14 have been changed. And
>> +one indicating PSW bit 13 changes.
> 
> Hm, I think I already commented on this last time... here is my current
> suggestion :)
> 
> "In order to be notified when a PVM enables a certain class of
> interrupt, KVM cannot intercept lctl(g) and lpsw(e) anymore. As a
> replacement, two new interception codes have been introduced: One
> indicating that the contents of CRs 0, 6, or 14 have been changed,
> indicating different interruption subclasses; and one indicating that
> PSW bit 13 has been changed, indicating whether machine checks are
> enabled."

I will use this with ... indicating that a machine check intervention was
requested and those are now enabled.

> 
>> +
>> +Instruction emulation
>> +---------------------
>> +With the format 4 state description for PVMs, the SIE instruction already
>> +interprets more instructions than it does with format 2. As it is not
>> +able to interpret every instruction, the SIE and the UV safeguard KVM's
>> +emulation inputs and outputs.
> 
> "It is not able to interpret every instruction, but needs to hand some
> tasks to KVM; therefore, the SIE and the UV safeguard..."

Will use this.


> 
> ?
> 
>> +
>> +Guest GRs and most of the instruction data, such as I/O data structures,
>> +are filtered. Instruction data is copied to and from the Secure
>> +Instruction Data Area. Guest GRs are put into / retrieved from the
>> +Interception-Data block.
> 
> These areas are in the SIE control block, right?

SIDA is a new block, linked from SIE control block. The register are stored in
the control block. I think this is really not relevant for such a document (too
much technical detail when explaining the big idea), but I will fix the name of
the location at 0x380 though.  (its now general register save area).
> 
>> +
>> +The Interception-Data block from the state description's offset 0x380
>> +contains GRs 0 - 16. Only GR values needed to emulate an instruction
>> +will be copied into this area.
>> +
>> +The Interception Parameters state description field still contains the
>> +the bytes of the instruction text, but with pre-set register values
>> +instead of the actual ones. I.e. each instruction always uses the same
>> +instruction text, in order not to leak guest instruction text.
> 
> This also implies that the register content that a guest had in r<n>
> may be in r<m> in the interception data block if <m> is the default
> register used for that instruction?

yes. I will do
---
...Guest GRs are put into / retrieved from the
General Register Save Area.

Only GR values needed to emulate an instruction will be copied into this 
area and the real register numbers will be hidden.

The Interception Parameters state description field still contains the
the bytes of the instruction text, but with pre-set register values
instead of the actual ones. I.e. each instruction always uses the same
instruction text, in order not to leak guest instruction text.
This also implies that the register content that a guest had in r<n>
may be in r<m> from the hypervisors point of view.

---

> 
>> +
>> +The Secure Instruction Data Area contains instruction storage
>> +data. Instruction data, i.e. data being referenced by an instruction
>> +like the SCCB for sclp, is moved over the SIDA When an instruction is
> 
> Maybe move the introduction of the 'SIDA' acronym up to the
> introduction of the Secure Instruction Data Area?
> 
> Also, s/moved over the SIDA/moved over to the SIDA./ ?

Fixed. 
> 
[...]
>> +The notification type intercepts inform KVM about guest environment
>> +changes due to guest instruction interpretation. Such an interception
>> +is recognized for example for the store prefix instruction to provide
> 
> s/ for example/, for example,/

fixed.

> 
>> +the new lowcore location. On SIE reentry, any KVM data in the data
>> +areas is ignored, program exceptions are not injected and execution
>> +continues, as if no intercept had happened.
> 
> So, KVM putting stuff there does not cause any exception, it is simply
> discarded?

Might be a bit ambigious. SIE will not inject program interrupts as the
instruction has already completed. What about

On SIE reentry, any KVM data in the data areas is ignored and execution
continues as if the guest instruction has completed. For that reasons
KVM is not allowed to inject a program interrupt. 

