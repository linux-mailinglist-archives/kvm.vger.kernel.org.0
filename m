Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04D42D78C5
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 16:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406543AbgLKPFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 10:05:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37226 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391320AbgLKPFe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 10:05:34 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BBF3FqM186370;
        Fri, 11 Dec 2020 10:04:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TD6dAFeZSG0MPwksqcu/qp9ycyV9Jq+X3YSHPoRGj2s=;
 b=UBVBi0IsZyV91DOHdcHaAwWAfB1xwvfJ683FaWE4gKnrzcRcatmGQjTGgufQIXLTVf98
 PkEo8DgICjkXegnq0E4OAIYvlp4ooivkpzIqXfWy3B7VCki4Rc0bxIQRSfB2DMBnffAF
 V0NLrMJ9uK++WAVNtSNIX6cYEm7fdYtTDIx9pE+D6jr+PjDWMRgQ1yr2OMFVHkclNRNl
 FyqOH/W0In7X4C8TuA64+BonOa0QUOrf5B1Y8a5Qd6kmKG9xPZgcnublE2VsNPCF4WxP
 EWAstjODFcAHITdRIj6NJt9/NMZP8gR1bzcQYVJVr1ECnTTdTQ3FyKFGvq8qjVpMWM2S wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35c6fcrsn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 10:04:52 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BBF3re5193680;
        Fri, 11 Dec 2020 10:04:50 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35c6fcrska-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 10:04:50 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BBF24wK022256;
        Fri, 11 Dec 2020 15:04:49 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01dal.us.ibm.com with ESMTP id 3581ua4ceq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 15:04:49 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BBF4lYj23593376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Dec 2020 15:04:47 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DA20AE062;
        Fri, 11 Dec 2020 15:04:47 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2375AAE068;
        Fri, 11 Dec 2020 15:04:45 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.37.122])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 11 Dec 2020 15:04:44 +0000 (GMT)
Subject: Re: [RFC 0/4] vfio-pci/zdev: Fixing s390 vfio-pci ISM support
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
 <20201210133306.70d1a556.cohuck@redhat.com>
 <ce9d4ef2-2629-59b7-99ed-4c8212cb004f@linux.ibm.com>
 <20201211153501.7767a603.cohuck@redhat.com>
 <6c9528f3-f012-ba15-1d68-7caefb942356@linux.ibm.com>
Message-ID: <a974c5cc-fc42-7bf0-66a6-df095da7105f@linux.ibm.com>
Date:   Fri, 11 Dec 2020 10:04:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <6c9528f3-f012-ba15-1d68-7caefb942356@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_02:2020-12-11,2020-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012110095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/11/20 10:01 AM, Matthew Rosato wrote:
> On 12/11/20 9:35 AM, Cornelia Huck wrote:
>> On Thu, 10 Dec 2020 10:51:23 -0500
>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>
>>> On 12/10/20 7:33 AM, Cornelia Huck wrote:
>>>> On Wed,  9 Dec 2020 15:27:46 -0500
>>>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>>>> Today, ISM devices are completely disallowed for vfio-pci 
>>>>> passthrough as
>>>>> QEMU will reject the device due to an (inappropriate) MSI-X check.
>>>>> However, in an effort to enable ISM device passthrough, I realized 
>>>>> that the
>>>>> manner in which ISM performs block write operations is highly 
>>>>> incompatible
>>>>> with the way that QEMU s390 PCI instruction interception and
>>>>> vfio_pci_bar_rw break up I/O operations into 8B and 4B operations 
>>>>> -- ISM
>>>>> devices have particular requirements in regards to the alignment, 
>>>>> size and
>>>>> order of writes performed.  Furthermore, they require that 
>>>>> legacy/non-MIO
>>>>> s390 PCI instructions are used, which is also not guaranteed when 
>>>>> the I/O
>>>>> is passed through the typical userspace channels.
>>>>
>>>> The part about the non-MIO instructions confuses me. How can MIO
>>>> instructions be generated with the current code, and why does changing
>>>
>>> So to be clear, they are not being generated at all in the guest as the
>>> necessary facility is reported as unavailable.
>>>
>>> Let's talk about Linux in LPAR / the host kernel:  When hardware that
>>> supports MIO instructions is available, all userspace I/O traffic is
>>> going to be routed through the MIO variants of the s390 PCI
>>> instructions.  This is working well for other device types, but does not
>>> work for ISM which does not support these variants.  However, the ISM
>>> driver also does not invoke the userspace I/O routines for the kernel,
>>> it invokes the s390 PCI layer directly, which in turn ensures the proper
>>> PCI instructions are used -- This approach falls apart when the guest
>>> ISM driver invokes those routines in the guest -- we (qemu) pass those
>>> non-MIO instructions from the guest as memory operations through
>>> vfio-pci, traversing through the vfio I/O layer in the guest
>>> (vfio_pci_bar_rw and friends), where we then arrive in the host s390 PCI
>>> layer -- where the MIO variant is used because the facility is 
>>> available.
>>>
>>> Per conversations with Niklas (on CC), it's not trivial to decide by the
>>> time we reach the s390 PCI I/O layer to switch gears and use the non-MIO
>>> instruction set.
>>>
>>>> the write pattern help?
>>>
>>> The write pattern is a separate issue from non-MIO instruction
>>> requirements...  Certain address spaces require specific instructions to
>>> be used (so, no substituting PCISTG for PCISTB - that happens too by
>>> default for any writes coming into the host s390 PCI layer that are
>>> <=8B, and they all are when the PCISTB is broken up into 8B memory
>>> operations that travel through vfio_pci_bar_rw, which further breaks
>>> those up into 4B operations).  There's also a requirement for some
>>> writes that the data, if broken up, be written in a certain order in
>>> order to properly trigger events. :(  The ability to pass the entire
>>> PCISTB payload vs breaking it into 8B chunks is also significantly 
>>> faster.
>>
>> Let me summarize this to make sure I understand this new region
>> correctly:
>>
>> - some devices may have relaxed alignment/length requirements for
>>    pcistb (and friends?)
> 
> The relaxed alignment bit is really specific to PCISTB behavior, so the 
> "and friends" doesn't apply there.
> 
>> - some devices may actually require writes to be done in a large chunk
>>    instead of being broken up (is that a strict subset of the devices
>>    above?)
> 
> Yes, this is specific to ISM devices, which are always a relaxed 
> alignment/length device.
> 
> The inverse is an interesting question though (relaxed alignment devices 
> that are not ISM, which you've posed as a possible future extension for 
> emulated devices).  I'm not sure that any (real devices) exist where 
> (relaxed_alignment && !ism), but 'what if' -- I guess the right approach 
> would mean additional code in QEMU to handle relaxed alignment for the 
> vfio mmio path as well (seen as pcistb_default in my qemu patchset) and 
> being very specific in QEMU to only enable the region for an ism device.

Let me be more precise there...  It would be additional code to handle 
relaxed alignment for the default pcistb path (pcistb_default) which 
would include BOTH emulated devices (should we ever surface the relaxed 
alignment CLP bit and the guest kernel honor it) as well as any s390x 
vfio-pci device that doesn't use this new I/O region described here.

> 
>> - some devices do not support the new MIO instructions (is that a
>>    subset of the relaxed alignment devices? I'm not familiar with the
>>    MIO instructions)
>>
> 
> The non-MIO requirement is again specific to ISM, which is a subset of 
> the relaxed alignment devices.  In this case, the requirement is not 
> limited to PCISTB, and that's why PCILG is also included here.  The ISM 
> driver does not use PCISTG, and the only PCISTG instructions coming from 
> the guest against an ISM device would be against the config space and 
> those are OK to go through vfio still; so what was provided via the 
> region is effectively the bare-minimum requirement to allow ISM to 
> function properly in the guest.
> 
>> The patchsets introduce a new region that (a) is used by QEMU to submit
>> writes in one go, and (b) makes sure to call into the non-MIO
>> instructions directly; it's basically killing two birds with one stone
>> for ISM devices. Are these two requirements (large writes and non-MIO)
>> always going hand-in-hand, or is ISM just an odd device?
> 
> I would say that ISM is definitely a special-case device, even just 
> looking at the way it's implemented in the base kernel (interacting 
> directly with the s390 kernel PCI layer in order to avoid use of MIO 
> instructions -- no other driver does this).  But that said, having the 
> two requirements hand-in-hand I think is not bad, though -- This 
> approach ensures the specific instruction the guest wanted (or in this 
> case, needed) is actually executed on the underlying host.
> 
> That said, the ability to re-use the large write for other devices would 
> be nice -- but as hinted in the QEMU cover letter, this approach only 
> works because ISM does not support MSI-X; using this approach for 
> MSI-X-enabled devices breaks the MSI-X masking that vfio-pci does in 
> QEMU (I tried an approach that used this region approach for all 3 
> instructions as a test, PCISTG/PCISTB/PCILG, and threw it against mlx -- 
> any writes against an MSI-X enabled bar will miss the msi-x notifiers 
> since we aren't performing memory operations against the typical 
> vfio-pci bar).
> 
>>
>> If there's an expectation that the new region will always use the
>> non-MIO instructions (in addition to the changed write handling), it
>> should be noted in the description for the region as well.
>>
> 
> Yes, this is indeed the expectation; I can clarify that.
> 

