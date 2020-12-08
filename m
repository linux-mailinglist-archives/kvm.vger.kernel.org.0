Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198492D259F
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 09:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgLHISq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 03:18:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57756 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728225AbgLHISq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Dec 2020 03:18:46 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B8828od019774;
        Tue, 8 Dec 2020 03:17:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mXuFQVw+gv8Cjt7TBTV5Y1fu2I+MlrP43Kjv5G519yM=;
 b=b1KzXZmlqFMENb1rL7SaMIezeWRiniSRLQTCwzR8YgCe+pPKbBeAQYCLh0WdCnVs7v0g
 773KiQqehIojCPlibzACdq6nfWgOQGZKB0x7qf5ofcxr0CNXHMm/gj2B+9BcHcaY4AHl
 MYoY3ZExUswwchYSXRSjMCI013P7wFmHj9qDV/FJGVHC1kgjtQJ6RYtKRBHVOM/sP8/6
 FTtS/L2MWBpMkNUbYiCJfYrifb741dq0AZxDQ4u8LZeRJJpE+/LX3x8whHDgHe1JwcXN
 m0YBfLIoklmVdVtAolMosC9aUt+jR8is3hKqoPcXK68++Prjq2Mur/jY3aw0IfwFaziG NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 359qrpeyya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 03:17:50 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B88GshY083620;
        Tue, 8 Dec 2020 03:17:50 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 359qrpeyxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 03:17:50 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B88C3dE009880;
        Tue, 8 Dec 2020 08:17:48 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3581u8mxvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 08:17:48 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B88GUPE51183894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Dec 2020 08:16:30 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E52CA405B;
        Tue,  8 Dec 2020 08:16:30 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03F9BA4062;
        Tue,  8 Dec 2020 08:16:29 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.37.89])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Dec 2020 08:16:28 +0000 (GMT)
Subject: Re: [for-6.0 v5 12/13] securable guest memory: Alter virtio default
 properties for protected guests
To:     David Gibson <david@gibson.dropbear.id.au>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, pair@us.ibm.com,
        brijesh.singh@amd.com, frankja@linux.ibm.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, david@redhat.com,
        dgilbert@redhat.com, Eduardo Habkost <ehabkost@redhat.com>,
        qemu-devel@nongnu.org, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        berrange@redhat.com, thuth@redhat.com, pbonzini@redhat.com,
        rth@twiddle.net, mdroth@linux.vnet.ibm.com
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <20201204054415.579042-13-david@gibson.dropbear.id.au>
 <d739cae2-9197-76a5-1c19-057bfe832187@de.ibm.com>
 <20201204091706.4432dc1e.cohuck@redhat.com>
 <038214d1-580d-6692-cd1e-701cd41b5cf8@de.ibm.com>
 <20201204154310.158b410e.pasic@linux.ibm.com>
 <20201208015403.GB2555@yekko.fritz.box>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <54a86780-4ee2-089c-397a-83601ec1daec@de.ibm.com>
Date:   Tue, 8 Dec 2020 09:16:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201208015403.GB2555@yekko.fritz.box>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-08_03:2020-12-04,2020-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 phishscore=0 adultscore=0
 mlxlogscore=999 impostorscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080046
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08.12.20 02:54, David Gibson wrote:
> On Fri, Dec 04, 2020 at 03:43:10PM +0100, Halil Pasic wrote:
>> On Fri, 4 Dec 2020 09:29:59 +0100
>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>>
>>> On 04.12.20 09:17, Cornelia Huck wrote:
>>>> On Fri, 4 Dec 2020 09:10:36 +0100
>>>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>>>>
>>>>> On 04.12.20 06:44, David Gibson wrote:
>>>>>> The default behaviour for virtio devices is not to use the platforms normal
>>>>>> DMA paths, but instead to use the fact that it's running in a hypervisor
>>>>>> to directly access guest memory.  That doesn't work if the guest's memory
>>>>>> is protected from hypervisor access, such as with AMD's SEV or POWER's PEF.
>>>>>>
>>>>>> So, if a securable guest memory mechanism is enabled, then apply the
>>>>>> iommu_platform=on option so it will go through normal DMA mechanisms.
>>>>>> Those will presumably have some way of marking memory as shared with
>>>>>> the hypervisor or hardware so that DMA will work.
>>>>>>
>>>>>> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
>>>>>> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
>>>>>> ---
>>>>>>  hw/core/machine.c | 13 +++++++++++++
>>>>>>  1 file changed, 13 insertions(+)
>>>>>>
>>>>>> diff --git a/hw/core/machine.c b/hw/core/machine.c
>>>>>> index a67a27d03c..d16273d75d 100644
>>>>>> --- a/hw/core/machine.c
>>>>>> +++ b/hw/core/machine.c
>>>>>> @@ -28,6 +28,8 @@
>>>>>>  #include "hw/mem/nvdimm.h"
>>>>>>  #include "migration/vmstate.h"
>>>>>>  #include "exec/securable-guest-memory.h"
>>>>>> +#include "hw/virtio/virtio.h"
>>>>>> +#include "hw/virtio/virtio-pci.h"
>>>>>>  
>>>>>>  GlobalProperty hw_compat_5_1[] = {
>>>>>>      { "vhost-scsi", "num_queues", "1"},
>>>>>> @@ -1169,6 +1171,17 @@ void machine_run_board_init(MachineState *machine)
>>>>>>           * areas.
>>>>>>           */
>>>>>>          machine_set_mem_merge(OBJECT(machine), false, &error_abort);
>>>>>> +
>>>>>> +        /*
>>>>>> +         * Virtio devices can't count on directly accessing guest
>>>>>> +         * memory, so they need iommu_platform=on to use normal DMA
>>>>>> +         * mechanisms.  That requires also disabling legacy virtio
>>>>>> +         * support for those virtio pci devices which allow it.
>>>>>> +         */
>>>>>> +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legacy",
>>>>>> +                                   "on", true);
>>>>>> +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_platform",
>>>>>> +                                   "on", false);  
>>>>>
>>>>> I have not followed all the history (sorry). Should we also set iommu_platform
>>>>> for virtio-ccw? Halil?
>>>>>
>>>>
>>>> That line should add iommu_platform for all virtio devices, shouldn't
>>>> it?
>>>
>>> Yes, sorry. Was misreading that with the line above. 
>>>
>>
>> I believe this is the best we can get. In a sense it is still a
>> pessimization,
> 
> I'm not really clear on what you're getting at here.

I think Halils point is that somebody might come up with a solution where things would
work even without iommu_platform. But as he said, still the best setting we can get
to cover all cases.
