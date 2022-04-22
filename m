Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A5D50B3F7
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 11:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445944AbiDVJ1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 05:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445943AbiDVJ06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 05:26:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5955A40E60
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 02:24:05 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23M9D4l0016852;
        Fri, 22 Apr 2022 09:23:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5YoUscdCvZqMTS+O22FyvVCvWlKSJU/srPDMwqRJN5c=;
 b=iug3hUjKwA7qBXyQjdc0X3LRWzYCBSio54oJJfuPPhWLhC9Z73AXjXFROYk8tY3QH+yd
 TlQGunZ//Gq5Snqh7stw1bCu2RXkLw8tKUvPkHl1LG93CJEWODsp5pAgZ2Il/1fZykHS
 2X0L8g/Er6s5BZHCODQmzNRxenVradimvmX4mEAOUWDx2kbKX/iTeBw1WMJUVdsNcrVj
 kW2yKCQdfyFk6mBvl61psbA5uIoFqQsRGveAMeSEdgqK4XjYqkoou3U5jjq//kEreK9K
 kdZEgLK8GOkNEClG7GyPtjfAybpkDV5k9Xv5PUTxRmRRPHA8dyjqgYSSvqkWCFOp7ien 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjm2jm4n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 09:23:59 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23M8H8K0007805;
        Fri, 22 Apr 2022 09:23:58 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjm2jm4mn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 09:23:58 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23M9NGu9019134;
        Fri, 22 Apr 2022 09:23:56 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3ffne9944f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 09:23:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23M9NrrP28836344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 09:23:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0176BA405E;
        Fri, 22 Apr 2022 09:23:53 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A8EEA4055;
        Fri, 22 Apr 2022 09:23:52 +0000 (GMT)
Received: from [9.171.20.253] (unknown [9.171.20.253])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Apr 2022 09:23:52 +0000 (GMT)
Message-ID: <f3515bef-9724-5e3d-0e42-3baa289ed441@linux.ibm.com>
Date:   Fri, 22 Apr 2022 11:27:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v5 5/9] s390x/pci: enable for load/store intepretation
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
 <20220404181726.60291-6-mjrosato@linux.ibm.com>
 <cb628847-9b52-b64a-da1e-18f69fe20e4b@linux.ibm.com>
 <1d9a128a-1391-712b-abdc-7d4d9c1e5cc0@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <1d9a128a-1391-712b-abdc-7d4d9c1e5cc0@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Z1MuzbFHrS26hqKl5rR8s3w-doGZW0QD
X-Proofpoint-ORIG-GUID: 9JqfT1mtV0dSzouRf6hgbfxJFlpOst8G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_02,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204220040
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/20/22 17:12, Matthew Rosato wrote:
> On 4/19/22 3:47 PM, Pierre Morel wrote:
>>
>>
>> On 4/4/22 20:17, Matthew Rosato wrote:
>>> If the appropriate CPU facilty is available as well as the necessary
>>> ZPCI_OP ioctl, then the underlying KVM host will enable load/store
>>> intepretation for any guest device without a SHM bit in the guest
>>> function handle.  For a device that will be using interpretation
>>> support, ensure the guest function handle matches the host function
>>> handle; this value is re-checked every time the guest issues a SET 
>>> PCI FN
>>> to enable the guest device as it is the only opportunity to reflect
>>> function handle changes.
>>>
>>> By default, unless interpret=off is specified, interpretation support 
>>> will
>>> always be assumed and exploited if the necessary ioctl and features are
>>> available on the host kernel.  When these are unavailable, we will 
>>> silently
>>> revert to the interception model; this allows existing guest 
>>> configurations
>>> to work unmodified on hosts with and without zPCI interpretation 
>>> support,
>>> allowing QEMU to choose the best support model available.
>>>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> ---
>>>   hw/s390x/meson.build            |  1 +
>>>   hw/s390x/s390-pci-bus.c         | 66 ++++++++++++++++++++++++++++++++-
>>>   hw/s390x/s390-pci-inst.c        | 12 ++++++
>>>   hw/s390x/s390-pci-kvm.c         | 21 +++++++++++
>>>   include/hw/s390x/s390-pci-bus.h |  1 +
>>>   include/hw/s390x/s390-pci-kvm.h | 24 ++++++++++++
>>>   target/s390x/kvm/kvm.c          |  7 ++++
>>>   target/s390x/kvm/kvm_s390x.h    |  1 +
>>>   8 files changed, 132 insertions(+), 1 deletion(-)
>>>   create mode 100644 hw/s390x/s390-pci-kvm.c
>>>   create mode 100644 include/hw/s390x/s390-pci-kvm.h
>>>
>>
>> ...snip...
>>
>>>           if (s390_pci_msix_init(pbdev)) {
>>> @@ -1360,6 +1423,7 @@ static Property s390_pci_device_properties[] = {
>>>       DEFINE_PROP_UINT16("uid", S390PCIBusDevice, uid, UID_UNDEFINED),
>>>       DEFINE_PROP_S390_PCI_FID("fid", S390PCIBusDevice, fid),
>>>       DEFINE_PROP_STRING("target", S390PCIBusDevice, target),
>>> +    DEFINE_PROP_BOOL("interpret", S390PCIBusDevice, interp, true),
>>>       DEFINE_PROP_END_OF_LIST(),
>>>   };
>>> diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
>>> index 6d400d4147..c898c8abe9 100644
>>> --- a/hw/s390x/s390-pci-inst.c
>>> +++ b/hw/s390x/s390-pci-inst.c
>>> @@ -18,6 +18,8 @@
>>>   #include "sysemu/hw_accel.h"
>>>   #include "hw/s390x/s390-pci-inst.h"
>>>   #include "hw/s390x/s390-pci-bus.h"
>>> +#include "hw/s390x/s390-pci-kvm.h"
>>> +#include "hw/s390x/s390-pci-vfio.h"
>>>   #include "hw/s390x/tod.h"
>>>   #ifndef DEBUG_S390PCI_INST
>>> @@ -246,6 +248,16 @@ int clp_service_call(S390CPU *cpu, uint8_t r2, 
>>> uintptr_t ra)
>>>                   goto out;
>>>               }
>>> +            /*
>>> +             * Take this opportunity to make sure we still have an 
>>> accurate
>>> +             * host fh.  It's possible part of the handle changed 
>>> while the
>>> +             * device was disabled to the guest (e.g. vfio hot reset 
>>> for
>>> +             * ISM during plug)
>>> +             */
>>> +            if (pbdev->interp) {
>>> +                /* Take this opportunity to make sure we are sync'd 
>>> with host */
>>> +                s390_pci_get_host_fh(pbdev, &pbdev->fh);

Here we should check the return value and, AFAIU, assume that the device 
disappear if it did return false.

>>> +            }
>>>               pbdev->fh |= FH_MASK_ENABLE;
>>
>> Are we sure here that the PCI device is always enabled?
>> Shouldn't we check?
> 
> I guess you mean the host device?  Interesting thought.
> 
> So, to be clear, the idea on setting FH_MASK_ENABLE here is that we are 
> handling a guest CLP SET PCI FN enable so the guest fh should always 
> have FH_MASK_ENABLE set if we return CLP_RC_OK to the guest.
> 
> But for interpretation, if we find the host function is disabled, I 
> suppose we could return an error on the guest CLP (not sure which error 
> yet); otherwise, if we return the force-enabled handle and CLP_RC_OK as 
> we do here then the guest will just get errors attempting to use it.

hum, in this case can't we have a loop on
clp enable->error->clp disable->clp enable->error...

I think we should return an error if what the guest asked for could not 
be done.


> 
> 
> 

-- 
Pierre Morel
IBM Lab Boeblingen
