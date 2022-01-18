Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFB2492CF8
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 19:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347549AbiARSIg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 13:08:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29382 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237348AbiARSIf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 13:08:35 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IHRNfu009195;
        Tue, 18 Jan 2022 18:08:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Vrrff/534M3gFRv4swAZXOmk9d9vnH6q62GPtHCmP6Q=;
 b=rK2ibh467Batmkw3L7Kb/pHfhjrpx7shAyelzpWREsSVfA/9lt9chHFRQROZ1RhCFTAu
 fbS4adPTOsIMRYiLv+Zp2YNE0SZhkQ0qr5C+9MvLuSjDFV7tvaTww3qNOxrlGL5KHEDe
 5zmN0ZDYSnMOM+5ee+mA9/zB0/wAKV4HLQ3E0lpWLoVfdI2VXTsNX3oiwjFQg4P7E5Wz
 yGByxfg507aogsne2DRDifjZW/4pHpx1CTYxrFU7U/N7Gui/dQcsmhcg35QcmCUjnMDY
 EDGS9O2y6FCos6aHo2M1ULJ3ipUpO+58TnN6pX8s0rZrShljL6EXtXyG+f/qvBu2Lrgy ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dp1yd924r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:08:29 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IHiCZD012996;
        Tue, 18 Jan 2022 18:08:29 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dp1yd9249-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:08:29 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20II1reo021198;
        Tue, 18 Jan 2022 18:08:28 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 3dknwaq67k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:08:28 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20II8Neo38076882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 18:08:23 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C66BB6E05F;
        Tue, 18 Jan 2022 18:08:23 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E5BD6E060;
        Tue, 18 Jan 2022 18:08:22 +0000 (GMT)
Received: from [9.163.19.30] (unknown [9.163.19.30])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 18:08:22 +0000 (GMT)
Message-ID: <aea53638-b38a-bc33-db46-a9ceefe95c87@linux.ibm.com>
Date:   Tue, 18 Jan 2022 13:08:21 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 4/9] s390x/pci: enable for load/store intepretation
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220114203849.243657-1-mjrosato@linux.ibm.com>
 <20220114203849.243657-5-mjrosato@linux.ibm.com>
 <27a1db36-5664-6c90-ec39-aa6da5c23c31@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <27a1db36-5664-6c90-ec39-aa6da5c23c31@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rrnIHrg9GqvPjJRoRkQxCDoF2oBAA3Lq
X-Proofpoint-ORIG-GUID: xAtsdosmGujN18LnB-HkEINBSBQEzEC-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/17/22 9:51 AM, Thomas Huth wrote:
> On 14/01/2022 21.38, Matthew Rosato wrote:
...
>>   static void s390_pcihost_plug(HotplugHandler *hotplug_dev, 
>> DeviceState *dev,
>>                                 Error **errp)
>>   {
>>       S390pciState *s = S390_PCI_HOST_BRIDGE(hotplug_dev);
>>       PCIDevice *pdev = NULL;
>>       S390PCIBusDevice *pbdev = NULL;
>> +    int rc;
>>       if (object_dynamic_cast(OBJECT(dev), TYPE_PCI_BRIDGE)) {
>>           PCIBridge *pb = PCI_BRIDGE(dev);
>> @@ -1022,12 +1068,33 @@ static void s390_pcihost_plug(HotplugHandler 
>> *hotplug_dev, DeviceState *dev,
>>           set_pbdev_info(pbdev);
>>           if (object_dynamic_cast(OBJECT(dev), "vfio-pci")) {
>> -            pbdev->fh |= FH_SHM_VFIO;
>> +            /*
>> +             * By default, interpretation is always requested; if the 
>> available
>> +             * facilities indicate it is not available, fallback to the
>> +             * intercept model.
>> +             */
>> +            if (pbdev->interp && 
>> !s390_has_feat(S390_FEAT_ZPCI_INTERP)) {
>> +                    DPRINTF("zPCI interpretation facilities 
>> missing.\n");
>> +                    pbdev->interp = false;
>> +                }
> 
> Wrong indentation in the above three lines.

Thanks

> 
>> +            if (pbdev->interp) {
>> +                rc = s390_pci_interp_plug(s, pbdev);
>> +                if (rc) {
>> +                    error_setg(errp, "zpci interp plug failed: %d", rc);
> 
> The error message is a little bit scarce for something that might be 
> presented to the user - maybe write at least "interpretation" instead of 
> "interp" ?
> 
Good point, I'll re-word to something like "Plug failed for zPCI device 
in interpretation mode: %d"

>> +                    return;
>> +                }
>> +            }
>>               pbdev->iommu->dma_limit = s390_pci_start_dma_count(s, 
>> pbdev);
>>               /* Fill in CLP information passed via the vfio region */
>>               s390_pci_get_clp_info(pbdev);
>> +            if (!pbdev->interp) {
>> +                /* Do vfio passthrough but intercept for I/O */
>> +                pbdev->fh |= FH_SHM_VFIO;
>> +            }
>>           } else {
>>               pbdev->fh |= FH_SHM_EMUL;
>> +            /* Always intercept emulated devices */
>> +            pbdev->interp = false;
>>           }
> 
>   Thomas
> 

