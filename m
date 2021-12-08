Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEBE46DBD2
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 20:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbhLHTNX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 14:13:23 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35886 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232974AbhLHTNW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 14:13:22 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8ISl0g004290;
        Wed, 8 Dec 2021 19:09:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6HOwfVrHUMZ3e5lm9dJwACPuGjKsRr/ngZLHs8z/zZ8=;
 b=UV2NBlPBXjvn4zOoildyaANYTjZuz489eN0KMtUfxf322o9Yj1S8L0sEDacKkzngu8n1
 20fAjbA1JrIYlCQ6dqUpl5zgAM88um5joLvspzW2OU+fPlqt3j92qRMULggHbLGFuVEu
 UCxRDnFs+uDxX5vUUzaLwJtfjzNf/ECcGdsVprtUTcLyk+TM+rrvXCAuSSEHzb4avmjk
 dZjapmXy87KMN3He3zwT+Z8ubay18j3/qGXkuSbb7uDiVz/w0CjmABJDUXssVD5TAnYs
 iJ2qOSwJqExl1cF+FiMEIto+7YWH8BYoPklPQy34bZZHPuA1tZttln3eIQk73CzZizxq 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cu2128pq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 19:09:44 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8J50Sn020480;
        Wed, 8 Dec 2021 19:09:44 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cu2128ppw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 19:09:44 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8J3QS0016498;
        Wed, 8 Dec 2021 19:09:43 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 3cqyybv1cs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 19:09:43 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8J9fMT60228058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 19:09:41 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7133AB2065;
        Wed,  8 Dec 2021 19:09:41 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEC4AB2064;
        Wed,  8 Dec 2021 19:09:37 +0000 (GMT)
Received: from [9.211.152.43] (unknown [9.211.152.43])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 19:09:37 +0000 (GMT)
Message-ID: <38419082-3a9e-96d0-0cbf-5c97884b1a95@linux.ibm.com>
Date:   Wed, 8 Dec 2021 14:09:36 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 09/12] s390x/pci: enable adapter event notification for
 interpreted devices
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
 <20211207210425.150923-10-mjrosato@linux.ibm.com>
 <6e4e0755-3ecb-c9d8-6e09-9cee5c9f3fb7@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <6e4e0755-3ecb-c9d8-6e09-9cee5c9f3fb7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sRrE2y-e-8A4a8oaEk6wjTWQsiTLnEOB
X-Proofpoint-ORIG-GUID: AQuupHYrc_6qk39e0ZBdEcDcHBFySsTo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_07,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 impostorscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 6:29 AM, Thomas Huth wrote:
> On 07/12/2021 22.04, Matthew Rosato wrote:
>> Use the associated vfio feature ioctl to enable adapter event 
>> notification
>> and forwarding for devices when requested.  This feature will be set up
>> with or without firmware assist based upon the 'intassist' setting.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   hw/s390x/s390-pci-bus.c          | 24 +++++++--
>>   hw/s390x/s390-pci-inst.c         | 54 +++++++++++++++++++-
>>   hw/s390x/s390-pci-vfio.c         | 88 ++++++++++++++++++++++++++++++++
>>   include/hw/s390x/s390-pci-bus.h  |  1 +
>>   include/hw/s390x/s390-pci-vfio.h | 20 ++++++++
>>   5 files changed, 182 insertions(+), 5 deletions(-)
> [...]
>> diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
>> index 78093aaac7..6f9271df87 100644
>> --- a/hw/s390x/s390-pci-vfio.c
>> +++ b/hw/s390x/s390-pci-vfio.c
>> @@ -152,6 +152,94 @@ int 
>> s390_pci_update_passthrough_fh(S390PCIBusDevice *pbdev)
>>       return 0;
>>   }
>> +int s390_pci_probe_aif(S390PCIBusDevice *pbdev)
>> +{
>> +    VFIOPCIDevice *vdev = container_of(pbdev->pdev, VFIOPCIDevice, 
>> pdev);
> 
> Should this use VFIO_PCI() instead of container_of ?
> 

Yes, VFIO_PCI(pbdev->pdev) should work.

>> +    struct vfio_device_feature feat = {
>> +        .argsz = sizeof(struct vfio_device_feature),
>> +        .flags = VFIO_DEVICE_FEATURE_PROBE + 
>> VFIO_DEVICE_FEATURE_ZPCI_AIF
>> +    };
>> +
>> +    assert(vdev);
> 
> ... then you could likely also drop the assert(), I think?

If I've understood qom.h correctly then yes you're right, if we use the 
instance checker VFIO_PCI() we should trigger an assert through 
object_dynamic_cast_assert() already if the pdev isn't a vfio-pci device 
-- I just verified that by trying to call VFIO_PCI() with something else 
and we indeed get an assert e.g. 'VFIO_PCI: Object 0x... is not an 
instance of type vfio-pci'

So I'll change these and get rid of the extra asserts, thanks.

