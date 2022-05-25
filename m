Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B34533DCF
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 15:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240673AbiEYNXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 09:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiEYNXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 09:23:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F982A719;
        Wed, 25 May 2022 06:23:31 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PBRW1q004869;
        Wed, 25 May 2022 13:23:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ldOwhqrdMrG+DfU+2aFY9eV2yzo9XQKZE0zxnYIWkkc=;
 b=n8buIVW+eqo1LjqOVBNi5mAzHr3a8xitkxlcWRmbK0Gz/iHsAggkED+o/3IKhQZ9i7I+
 uZNHu3Dek4vrZY9Ts6uHKdjDhzH5ePpizuM2OFvcfLzwluwgPhx+Hf91cQ9dNMwvXtEC
 kbVj3Gq6slou9zvRQ/KiG3H+JNDhIsddMvbthnLoXRbNX1ME3EkyoR5E+4HdSUWU4Q0/
 4EZKWRbLSzwn4IDyIthTHbmbBFYZ+xvz2k47ygqP19jyXrsehnUN7Ji+ezfigAAUyCXh
 KOw78Gz8Js7As/0zPSwSO8uesKUPC0teyr/PUpngLpydBoBNouYyEe9wNNpdqyS+NC6s JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9kkq28c4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:23:28 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24PCYG7n000740;
        Wed, 25 May 2022 13:23:27 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9kkq28bs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:23:27 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24PDEwm1019283;
        Wed, 25 May 2022 13:23:26 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 3g93v87rdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:23:26 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24PDNP2d8126862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 13:23:25 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 763BFAE064;
        Wed, 25 May 2022 13:23:25 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA5C3AE062;
        Wed, 25 May 2022 13:23:20 +0000 (GMT)
Received: from [9.163.3.233] (unknown [9.163.3.233])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 25 May 2022 13:23:20 +0000 (GMT)
Message-ID: <f309313b-2bf0-f740-e372-06f20069e7e6@linux.ibm.com>
Date:   Wed, 25 May 2022 09:23:19 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v8 17/22] vfio-pci/zdev: add open/close device hooks
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220524185907.140285-1-mjrosato@linux.ibm.com>
 <20220524185907.140285-18-mjrosato@linux.ibm.com>
 <20220524210815.GB1343366@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220524210815.GB1343366@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RsxTn6jmwLJMmhUPfitBq5PPdvvqlPmn
X-Proofpoint-GUID: Vm__Pt-8jIcYsMuR8qMX_hkzbxUtc_zJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_03,2022-05-25_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 impostorscore=0 clxscore=1015 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205250067
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/22 5:08 PM, Jason Gunthorpe wrote:
> On Tue, May 24, 2022 at 02:59:02PM -0400, Matthew Rosato wrote:
>> During vfio-pci open_device, pass the KVM associated with the vfio group
>> (if one exists).  This is needed in order to pass a special indicator
>> (GISA) to firmware to allow zPCI interpretation facilities to be used
>> for only the specific KVM associated with the vfio-pci device.  During
>> vfio-pci close_device, unregister the notifier.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>   arch/s390/include/asm/pci.h      |  2 ++
>>   drivers/vfio/pci/vfio_pci_core.c | 11 ++++++++++-
>>   drivers/vfio/pci/vfio_pci_zdev.c | 27 +++++++++++++++++++++++++++
>>   include/linux/vfio_pci_core.h    | 12 ++++++++++++
>>   4 files changed, 51 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
>> index 85eb0ef9d4c3..67fbce1ea0c9 100644
>> +++ b/arch/s390/include/asm/pci.h
>> @@ -5,6 +5,7 @@
>>   #include <linux/pci.h>
>>   #include <linux/mutex.h>
>>   #include <linux/iommu.h>
>> +#include <linux/notifier.h>
>>   #include <linux/pci_hotplug.h>
>>   #include <asm-generic/pci.h>
>>   #include <asm/pci_clp.h>
>> @@ -195,6 +196,7 @@ struct zpci_dev {
>>   	struct s390_domain *s390_domain; /* s390 IOMMU domain data */
>>   	struct kvm_zdev *kzdev;
>>   	struct mutex kzdev_lock;
>> +	struct notifier_block nb; /* vfio notifications */
> 
> This is obsolete now right? Same for the #include ?

Of course, I forgot to remove them...  Will do

> 
>> @@ -418,6 +424,9 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>>   
>>   	vdev->needs_reset = true;
>>   
>> +	if (vfio_pci_zdev_release(vdev))
>> +		pci_info(pdev, "%s: Couldn't restore zPCI state\n", __func__);
>> +
>>   	/*
>>   	 * If we have saved state, restore it.  If we can reset the device,
>>   	 * even better.  Resetting with current state seems better than
>> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
>> index ea4c0d2b0663..d0df85c8b204 100644
>> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
>> @@ -11,6 +11,7 @@
>>   #include <linux/uaccess.h>
>>   #include <linux/vfio.h>
>>   #include <linux/vfio_zdev.h>
>> +#include <linux/kvm_host.h>
>>   #include <asm/pci_clp.h>
>>   #include <asm/pci_io.h>
>>   
>> @@ -136,3 +137,29 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>>   
>>   	return ret;
>>   }
>> +
>> +int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
>> +{
>> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
>> +
>> +	if (!zdev)
>> +		return -ENODEV;
>> +
>> +	if (!vdev->vdev.kvm)
>> +		return 0;
>> +
>> +	return kvm_s390_pci_register_kvm(zdev, vdev->vdev.kvm);
>> +}
>> +
>> +int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
>> +{
>> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> 
> Keeping these functions named open_device/close_device wouuld probably
> be clearer

Agreed, will rename vfio_pci_zdev_{open,close}_device

> 
>> +	if (!zdev)
>> +		return -ENODEV;
>> +
>> +	if (!vdev->vdev.kvm)
>> +		return 0;
>> +
>> +	return kvm_s390_pci_unregister_kvm(zdev);
>> +}
> 
> Again this cannot fail, you should make it return void, not ignore the
> failure - or at least push the ignoring the failure down to the place
> that is causing this.

I'll move that handling into kvm_s390_pci_unregister_kvm and make 
vfio_pci_zdev_close_device return void / will remove the check for the 
rc in vfio_pci_core_disable.

> 
> Otherwise it looks fine to me, thanks
> 

Thanks

