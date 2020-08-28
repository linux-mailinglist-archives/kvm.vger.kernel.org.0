Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D7D255725
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 11:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgH1JJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 05:09:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63162 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726010AbgH1JJt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Aug 2020 05:09:49 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07S92X7x068328;
        Fri, 28 Aug 2020 05:09:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ATQvFScQRjrC7BAxyv5YWvYgki7m0886xDTKTk2ya3s=;
 b=DLbcwwkgk57xgbBOJYcGAx+c7xzkYolAD2B44ujNbMCoViSOtAl889mHFkGnthKnZd85
 j91AYaHx1BXblhSKNL1vje/Dqsm+5hVSuS52ROZ06id/Co23nfqImbVlqt6YO65Fy0Sf
 iv9ec03k7MZtquitCmqHLrIPuXk2o7CrWhoEksiaKK4fYgINgxf+s5Z4MWUC8i7VAnw3
 traYHbUw7FW6qmS8xGztBqREbzISGFqUtZlNgiiMratHD+oJt8dVUGcgGybRwFMBEr/Z
 I8IJKq5QgqKyJY02qAgSsvM5FWC67VhJBVoW/j3h48z8leWdc/qwU3EEkdRr9QtcLBkE fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 336wka2gum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Aug 2020 05:09:43 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07S94Sd4076782;
        Fri, 28 Aug 2020 05:09:42 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 336wka2gtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Aug 2020 05:09:42 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07S96s6e027602;
        Fri, 28 Aug 2020 09:09:40 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 336buh0ygt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Aug 2020 09:09:40 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07S99bZo33489354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 09:09:37 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 023AFAE057;
        Fri, 28 Aug 2020 09:09:37 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FA9AAE056;
        Fri, 28 Aug 2020 09:09:36 +0000 (GMT)
Received: from oc5500677777.ibm.com (unknown [9.145.164.95])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Aug 2020 09:09:36 +0000 (GMT)
Subject: Re: [PATCH v3] PCI: Introduce flag for detached virtual functions
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>, bhelgaas@google.com,
        pmorel@linux.ibm.com, mpe@ellerman.id.au, oohall@gmail.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
References: <20200827203335.GA2101829@bjorn-Precision-5520>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <babde252-4909-9d3b-e5dc-bae4e6a20cd1@linux.ibm.com>
Date:   Fri, 28 Aug 2020 11:09:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200827203335.GA2101829@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-28_05:2020-08-28,2020-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 mlxscore=0 clxscore=1011
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/27/20 10:33 PM, Bjorn Helgaas wrote:
> On Thu, Aug 27, 2020 at 01:17:48PM -0600, Alex Williamson wrote:
>> On Thu, 27 Aug 2020 13:31:38 -0500
>> Bjorn Helgaas <helgaas@kernel.org> wrote:
>>
>>> Re the subject line, this patch does a lot more than just "introduce a
>>> flag"; AFAICT it actually enables important VFIO functionality, e.g.,
>>> something like:
>>>
>>>   vfio/pci: Enable MMIO access for s390 detached VFs
>>>
>>> On Thu, Aug 13, 2020 at 11:40:43AM -0400, Matthew Rosato wrote:
>>>> s390x has the notion of providing VFs to the kernel in a manner
>>>> where the associated PF is inaccessible other than via firmware.
>>>> These are not treated as typical VFs and access to them is emulated
>>>> by underlying firmware which can still access the PF.  After
>>>> the referened commit however these detached VFs were no longer able
>>>> to work with vfio-pci as the firmware does not provide emulation of
>>>> the PCI_COMMAND_MEMORY bit.  In this case, let's explicitly recognize
>>>> these detached VFs so that vfio-pci can allow memory access to
>>>> them again.  
>>>
>>> Out of curiosity, in what sense is the PF inaccessible?  Is it
>>> *impossible* for Linux to access the PF, or is it just not enumerated
>>> by clp_list_pci() so Linux doesn't know about it?

If it is possible to access the PF that would be a very severe bug in
the machine level hypervisor partition isolation.
Note also that POWER has a very similar setup.
Also even if we have access to the PF, we do get some hypervisor
involvement (pdev->no_vf_scan).
Remind you all OSs on IBM Z are _always_ running under a machine
level hypervisor in logical partitions (with partitioned
memory, no paging).

>>>
>>> VFs do not implement PCI_COMMAND, so I guess "firmware does not
>>> provide emulation of PCI_COMMAND_MEMORY" means something like "we
>>> can't access the PF so we can't enable/disable PCI_COMMAND_MEMORY"?
>>>
>>> s/referened/referenced/
>>>
>>>> Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
>>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>>> ---
>>>>  arch/s390/pci/pci_bus.c            | 13 +++++++++++++
>>>>  drivers/vfio/pci/vfio_pci_config.c |  8 ++++----
>>>>  include/linux/pci.h                |  4 ++++
>>>>  3 files changed, 21 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/arch/s390/pci/pci_bus.c b/arch/s390/pci/pci_bus.c
>>>> index 642a993..1b33076 100644
>>>> --- a/arch/s390/pci/pci_bus.c
>>>> +++ b/arch/s390/pci/pci_bus.c
>>>> @@ -184,6 +184,19 @@ static inline int zpci_bus_setup_virtfn(struct zpci_bus *zbus,
>>>>  }
>>>>  #endif
>>>>  
>>>> +void pcibios_bus_add_device(struct pci_dev *pdev)
>>>> +{
>>>> +	struct zpci_dev *zdev = to_zpci(pdev);
>>>> +
>>>> +	/*
>>>> +	 * If we have a VF on a non-multifunction bus, it must be a VF that is
>>>> +	 * detached from its parent PF.  We rely on firmware emulation to
>>>> +	 * provide underlying PF details.  
>>>
>>> What exactly does "multifunction bus" mean?  I'm familiar with
>>> multi-function *devices*, but not multi-function buses.

Yes this is a bit of an IBM Z quirk, up until v5.8-rc1
IBM Z Linux only knew isolated PCI functions that would get
a PCI ID of the form <uid>:00:00.0 where the domain
is a value (called UID) that can be determined by the machine administrator.

Now for some multi-function devices one really needs to have some of the physical
PCI information known to the device driver/in the PCI ID.
Still we need to stay compatible to the old scheme and also
somehow deal with the fact that the domain value (UID)
is set per function.
So now for each physical multi-function device we create a zbus
that gets assigned all functions belonging to that physical
device and we use the UID of the function with devfn == 0
as the domain. Resulting in PCI IDs of the form:
<uid>:00:<device>.<function>
Now zbus->multifunction basically says if there is more
than one function on that zbus which is equivalent to saying
that the zbus represents a multi-function device.

>>>
>>>> +	 */
>>>> +	if (zdev->vfn && !zdev->zbus->multifunction)
>>>> +		pdev->detached_vf = 1;
>>>> +}

Note that as of v5.9-rc2 setting pdev->detached_vf would move
into zpci_bus_setup_virtfn() and it will be obvious that
whenever zdev->vfn != 0 (i.e. it really is a VF according to
the platform) we either link the VF with the parent
PF or set pdev->detached_vf. It's just that this version was
sent before that code landed upstream.


>>>> +
>>>>  static int zpci_bus_add_device(struct zpci_bus *zbus, struct zpci_dev *zdev)
>>>>  {
>>>>  	struct pci_bus *bus;
>>>> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
>>>> index d98843f..98f93d1 100644
>>>> --- a/drivers/vfio/pci/vfio_pci_config.c
>>>> +++ b/drivers/vfio/pci/vfio_pci_config.c
>>>> @@ -406,7 +406,7 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
>>>>  	 * PF SR-IOV capability, there's therefore no need to trigger
>>>>  	 * faults based on the virtual value.
>>>>  	 */
>>>> -	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);
>>>> +	return dev_is_vf(&pdev->dev) || (cmd & PCI_COMMAND_MEMORY);  
>>>
>>> I'm not super keen on the idea of having two subtly different ways of
>>> identifying VFs.  I think that will be confusing.  This seems to be
>>> the critical line, so whatever we do here, it will be out of the
>>> ordinary and probably deserves a little comment.
>>>
>>> If Linux doesn't see the PF, does pci_physfn(VF) return NULL, i.e., is
>>> VF->physfn NULL?

No and yes, as Matthew already set pci_physfn(vf) never return NULL
because it returns the pdev itself if is_virtfn is 0.
That said we can easily make Linux have

 pdev->is_virtfn = 1, pdev->physfn = NULL

and in fact it was the first thing I suggested because I feel like
it is indeed the most logical way to encode "detached VF" and AFAIU there
is already some code (ex: in powerpc, eeh_debugfs_break_device())
that assumes this to be the case. However there is also
code that assumes that pdev->is_virtfn implies pdev->physfn != NULL
including in vfio so this requires checking all pdev->is_virtfn/pci_physfn()
uses and of course a clear upstream decision.

>>
>> FWIW, pci_physfn() never returns NULL, it returns the provided pdev if
>> is_virtfn is not set.  This proposal wouldn't change that return value.
>> AIUI pci_physfn(), the caller needs to test that the returned device is
>> different from the provided device if there's really code that wants to
>> traverse to the PF.
> 
> Oh, so this VF has is_virtfn==0.  That seems weird.  There are lots of
> other ways that a VF is different: Vendor/Device IDs are 0xffff, BARs
> are zeroes, etc.
> 
> It sounds like you're sweeping those under the rug by avoiding the
> normal enumeration path (e.g., you don't have to size the BARs), but
> if it actually is a VF, it seems like there might be fewer surprises
> if we treat it as one.
> 
> Why don't you just set is_virtfn=1 since it *is* a VF, and then deal
> with the special cases where you want to touch the PF?
> 
> Bjorn
> 

As we are always running under at least a machine level hypervisor
we're somewhat in the same situation as e.g. a KVM guest in
that the VFs we see have some emulation that makes them act more like
normal PCI functions. It just so happens that the machine level hypervisor
does not emulate the PCI_COMMAND_MEMORY, it does emulate BARs and Vendor/Device IDs
though.
So is_virtfn is 0 for some VF for the same reason it is 0 on KVM/ESXi/HyperV/Jailhouse…
guests on other architectures.
Note that the BAR and Vendor/Device ID emulation
exists also for the VFs created through /sys/…/sriov_numvfs that
do have pdev->is_virtfn set to 1 and yes that means some of the emulation
is not strictly necessary for us (e.g. Vendor/Device ID) but
keeps things the same as on other architectures.
Think of it, if any of the other hypervisors also
don't implement PCI_COMMAND_MEMORY second level guest PCI pass-through
would be broken for the same reason.
