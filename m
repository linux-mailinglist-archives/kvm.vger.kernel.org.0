Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78240475D81
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 17:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244871AbhLOQeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 11:34:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19272 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244864AbhLOQeC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 11:34:02 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BFFE9jT024546;
        Wed, 15 Dec 2021 16:33:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ze+bztBabw2XwfeWLI25zY8sviQIOEdH8QLKTEuBv5o=;
 b=XKBdIMbfCq090qIGAWX/tiripPqCvwcYvPSYnkOVLJn+laShiBtCOrorDzKdDigLbYGX
 yoEL9yGbFovYPI8f71fPl8UBjDH1GseNoDJ8lpKgn7fpiq0N349BsA3tuqHk706LUNZt
 V4NsFL3sa4Sira2Obb8JE35ezA7Unurut4/bV1j6JCkQvJI3bhyY8hmsQuHqlhoNYweL
 AGTwE+6xDJ/srSov79V4qmCP0VSUfTFNoZMBunO0TYMSwcg5ee80r8bi6oBxXxHGFcvY
 xOZNv5RJXLEIbAgbty380ltn3E39sOBf+8/JrhW4oqSXRBqnWE9w/RJ1eBv+vTnwPNT9 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cyhyk3d1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 16:33:57 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BFFdD97032379;
        Wed, 15 Dec 2021 16:33:56 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cyhyk3d10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 16:33:56 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BFGR8Ss000596;
        Wed, 15 Dec 2021 16:33:55 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3cy77xxxdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 16:33:55 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BFGWsOn29622720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 16:32:54 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55D0B6A05D;
        Wed, 15 Dec 2021 16:32:54 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1790C6A04F;
        Wed, 15 Dec 2021 16:32:52 +0000 (GMT)
Received: from [9.211.79.24] (unknown [9.211.79.24])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 15 Dec 2021 16:32:52 +0000 (GMT)
Message-ID: <bf6dc2a1-95a8-0e1d-1949-9f5714ee9e28@linux.ibm.com>
Date:   Wed, 15 Dec 2021 11:32:52 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 07/12] s390x/pci: enable for load/store intepretation
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     farman@linux.ibm.com, kvm@vger.kernel.org, schnelle@linux.ibm.com,
        cohuck@redhat.com, richard.henderson@linaro.org, thuth@redhat.com,
        qemu-devel@nongnu.org, pasic@linux.ibm.com,
        alex.williamson@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        david@redhat.com, borntraeger@linux.ibm.com
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
 <20211207210425.150923-8-mjrosato@linux.ibm.com>
 <69925992-e6a0-5536-8190-00a435de72f0@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <69925992-e6a0-5536-8190-00a435de72f0@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4l48PXaIYP7DT46nL2StceXIEioLMWXd
X-Proofpoint-ORIG-GUID: LlnxBaKWjZSQjqgmkGuk5zM-U-4MpNFD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-15_10,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/21 2:44 AM, Pierre Morel wrote:
> 
> 
> On 12/7/21 22:04, Matthew Rosato wrote:
>> Use the associated vfio feature ioctl to enable interpretation for 
>> devices
>> when requested.  As part of this process, we must use the host function
>> handle rather than a QEMU-generated one -- this is provided as part of 
>> the
>> ioctl payload.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   hw/s390x/s390-pci-bus.c          | 69 +++++++++++++++++++++++++++++++-
>>   hw/s390x/s390-pci-inst.c         | 63 ++++++++++++++++++++++++++++-
>>   hw/s390x/s390-pci-vfio.c         | 55 +++++++++++++++++++++++++
>>   include/hw/s390x/s390-pci-bus.h  |  1 +
>>   include/hw/s390x/s390-pci-vfio.h | 15 +++++++
>>   5 files changed, 201 insertions(+), 2 deletions(-)
>>
>> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
>> index 01b58ebc70..451bd32d92 100644
>> --- a/hw/s390x/s390-pci-bus.c
>> +++ b/hw/s390x/s390-pci-bus.c
>> @@ -971,12 +971,57 @@ static void 
>> s390_pci_update_subordinate(PCIDevice *dev, uint32_t nr)
>>       }
>>   }
>> +static int s390_pci_interp_plug(S390pciState *s, S390PCIBusDevice 
>> *pbdev)
>> +{
>> +    uint32_t idx;
>> +    int rc;
>> +
>> +    rc = s390_pci_probe_interp(pbdev);
>> +    if (rc) {
>> +        return rc;
>> +    }
>> +
>> +    rc = s390_pci_update_passthrough_fh(pbdev);
>> +    if (rc) {
>> +        return rc;
>> +    }
>> +
>> +    /*
>> +     * The host device is in an enabled state, but the device must
>> +     * begin as disabled for the guest so mask off the enable bit
>> +     * from the passthrough handle.
>> +     */
> 
> I think you should explain why the device must be seen disabled for the 
> guest.
> AFAIU it is because we need the guest to issue a CLP_ENABLE for us to 
> activate interpretation.
> This is due to the choice of activate/deactivate interpretation during 
> device enable/disable.
> 

Not completely.  While it is true that we need the guest to issue the 
CLP_ENABLE to activate interpretation with the way this is currently 
implemented, existing code also starts all plugged devices with a QEMU 
internal state of

pbdev->state = ZPCI_FS_DISABLED;

and a disabled pbdev->fh, thus expecting a subsequent CLP ENABLE from 
the guest when/if it decides to use the device.

If we were to set the handle to an enabled state here, we must also 
udpate the pbdev state, introducing a difference in how we present 
intercept/emulated devices vs interpreted devices during plug.  I don't 
think we want to do that -- but I can improve this comment here to try 
and better explain that all devices begin plugged as disabled to the guest


> Just curious: why not activate/deactivate interpretation on plug/unplug?
> 

I think it would be possible to do so (while still showing a disabled 
handle initially), but my thinking is that tying these actions to guest 
CLP disable/enable will also be useful later when looking at trying to 
better-handle error events from the guest e.g. hot reset.


