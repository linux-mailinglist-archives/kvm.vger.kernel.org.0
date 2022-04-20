Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6EA508BDC
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 17:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237859AbiDTPQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 11:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380236AbiDTPPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 11:15:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5A94553E
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 08:12:53 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KDS9oQ005575;
        Wed, 20 Apr 2022 15:12:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2QjDcmuQezqaNkyEO6jI8dBmrXaIfCpYK/bI29yIygM=;
 b=iODecKy6eTuthRJLWnFBgU7QfENmRjCceN9DisDFPbfj5Rd/JqChgX/r/ES/rjJXu5Vc
 9iu85HbW6I7frGI2Ojv1guhSvtYWi7n2aLfurBvTe6gBY6Qp6yd7h0sIwmWpYibLGB/U
 fihnWViBFEZoVPmWHZKq6LvtukC4qAiqeRev2HgfPmg1+aECUbupwDda07TiuHGCY4gJ
 PV8bQN1sMkPOG5oevDmtBOP0nkQJ4w7TlcsPVQ5vsZd+wlT6UDuTnLcYEG/uCYmxTidM
 OecN7qzdQpWyjtECbfqnFf+nhhu0mDY4nloEZ6GlThTGsMJGaxEF8dVq9RIa7A1SOFa6 pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjf52037r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 15:12:39 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KF7CXZ026644;
        Wed, 20 Apr 2022 15:12:39 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjf520372-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 15:12:39 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KF33Nb018672;
        Wed, 20 Apr 2022 15:12:38 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02wdc.us.ibm.com with ESMTP id 3fg2xw1qp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 15:12:38 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KFCbel25166218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 15:12:37 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B19F7AE060;
        Wed, 20 Apr 2022 15:12:37 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA18FAE05C;
        Wed, 20 Apr 2022 15:12:35 +0000 (GMT)
Received: from [9.211.82.47] (unknown [9.211.82.47])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 20 Apr 2022 15:12:35 +0000 (GMT)
Message-ID: <1d9a128a-1391-712b-abdc-7d4d9c1e5cc0@linux.ibm.com>
Date:   Wed, 20 Apr 2022 11:12:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v5 5/9] s390x/pci: enable for load/store intepretation
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
 <20220404181726.60291-6-mjrosato@linux.ibm.com>
 <cb628847-9b52-b64a-da1e-18f69fe20e4b@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <cb628847-9b52-b64a-da1e-18f69fe20e4b@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VQkOyMvibtvLhK9kE5Pjk8lXQdukuxaH
X-Proofpoint-ORIG-GUID: KLLJjORwFVWkq2bf7jyoGfePBSlGTOGj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_04,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 phishscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200090
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/19/22 3:47 PM, Pierre Morel wrote:
> 
> 
> On 4/4/22 20:17, Matthew Rosato wrote:
>> If the appropriate CPU facilty is available as well as the necessary
>> ZPCI_OP ioctl, then the underlying KVM host will enable load/store
>> intepretation for any guest device without a SHM bit in the guest
>> function handle.  For a device that will be using interpretation
>> support, ensure the guest function handle matches the host function
>> handle; this value is re-checked every time the guest issues a SET PCI FN
>> to enable the guest device as it is the only opportunity to reflect
>> function handle changes.
>>
>> By default, unless interpret=off is specified, interpretation support 
>> will
>> always be assumed and exploited if the necessary ioctl and features are
>> available on the host kernel.  When these are unavailable, we will 
>> silently
>> revert to the interception model; this allows existing guest 
>> configurations
>> to work unmodified on hosts with and without zPCI interpretation support,
>> allowing QEMU to choose the best support model available.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   hw/s390x/meson.build            |  1 +
>>   hw/s390x/s390-pci-bus.c         | 66 ++++++++++++++++++++++++++++++++-
>>   hw/s390x/s390-pci-inst.c        | 12 ++++++
>>   hw/s390x/s390-pci-kvm.c         | 21 +++++++++++
>>   include/hw/s390x/s390-pci-bus.h |  1 +
>>   include/hw/s390x/s390-pci-kvm.h | 24 ++++++++++++
>>   target/s390x/kvm/kvm.c          |  7 ++++
>>   target/s390x/kvm/kvm_s390x.h    |  1 +
>>   8 files changed, 132 insertions(+), 1 deletion(-)
>>   create mode 100644 hw/s390x/s390-pci-kvm.c
>>   create mode 100644 include/hw/s390x/s390-pci-kvm.h
>>
> 
> ...snip...
> 
>>           if (s390_pci_msix_init(pbdev)) {
>> @@ -1360,6 +1423,7 @@ static Property s390_pci_device_properties[] = {
>>       DEFINE_PROP_UINT16("uid", S390PCIBusDevice, uid, UID_UNDEFINED),
>>       DEFINE_PROP_S390_PCI_FID("fid", S390PCIBusDevice, fid),
>>       DEFINE_PROP_STRING("target", S390PCIBusDevice, target),
>> +    DEFINE_PROP_BOOL("interpret", S390PCIBusDevice, interp, true),
>>       DEFINE_PROP_END_OF_LIST(),
>>   };
>> diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
>> index 6d400d4147..c898c8abe9 100644
>> --- a/hw/s390x/s390-pci-inst.c
>> +++ b/hw/s390x/s390-pci-inst.c
>> @@ -18,6 +18,8 @@
>>   #include "sysemu/hw_accel.h"
>>   #include "hw/s390x/s390-pci-inst.h"
>>   #include "hw/s390x/s390-pci-bus.h"
>> +#include "hw/s390x/s390-pci-kvm.h"
>> +#include "hw/s390x/s390-pci-vfio.h"
>>   #include "hw/s390x/tod.h"
>>   #ifndef DEBUG_S390PCI_INST
>> @@ -246,6 +248,16 @@ int clp_service_call(S390CPU *cpu, uint8_t r2, 
>> uintptr_t ra)
>>                   goto out;
>>               }
>> +            /*
>> +             * Take this opportunity to make sure we still have an 
>> accurate
>> +             * host fh.  It's possible part of the handle changed 
>> while the
>> +             * device was disabled to the guest (e.g. vfio hot reset for
>> +             * ISM during plug)
>> +             */
>> +            if (pbdev->interp) {
>> +                /* Take this opportunity to make sure we are sync'd 
>> with host */
>> +                s390_pci_get_host_fh(pbdev, &pbdev->fh);
>> +            }
>>               pbdev->fh |= FH_MASK_ENABLE;
> 
> Are we sure here that the PCI device is always enabled?
> Shouldn't we check?

I guess you mean the host device?  Interesting thought.

So, to be clear, the idea on setting FH_MASK_ENABLE here is that we are 
handling a guest CLP SET PCI FN enable so the guest fh should always 
have FH_MASK_ENABLE set if we return CLP_RC_OK to the guest.

But for interpretation, if we find the host function is disabled, I 
suppose we could return an error on the guest CLP (not sure which error 
yet); otherwise, if we return the force-enabled handle and CLP_RC_OK as 
we do here then the guest will just get errors attempting to use it.



