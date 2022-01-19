Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF92F493EF1
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 18:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356361AbiASRVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 12:21:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45702 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345023AbiASRU4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 12:20:56 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JGkBTB030110;
        Wed, 19 Jan 2022 17:20:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3uw+z/VojdzjNc/t+SKjEJeyaLUdroAxl9NK5dGEu14=;
 b=VS2KXljTdlf+cbDp2BsbFmbzHvIWCyieLci2/2K/33dImS4/p2AbfBCnOn32BYKj6eO6
 aLPZRQ0w8zTpe1As6ukpiOp8JOl37EkdluVnRVtZpdstYB8bm0TNOb4R6Sf3L5hTWioJ
 6WgrkUXOUns2Ig+pRJg+Gca9kmLlGsrY9yx6JRim5vvHE2oReaSKnfvxDMXlDdIOojFU
 4kidqm2g9fhcsXxPoh1kIemDJHQd7T9QXu8plDH2fKM3wslfzYhPR5G7wmY4pDvpenXd
 7yjs2SdSDnl53pBOSWhBe7o9rEBc/puTtVS9naW7GcP+BphSkajr7l+jXWKdE/wbUpbP Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dpmeg44dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 17:20:54 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20JHEFGK020418;
        Wed, 19 Jan 2022 17:20:53 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dpmeg44cs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 17:20:53 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20JHDG5u012217;
        Wed, 19 Jan 2022 17:20:52 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 3dknwcyxya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 17:20:52 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20JHKpPw32178528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 17:20:51 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 210C313605D;
        Wed, 19 Jan 2022 17:20:51 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58E6513606E;
        Wed, 19 Jan 2022 17:20:49 +0000 (GMT)
Received: from [9.163.19.30] (unknown [9.163.19.30])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jan 2022 17:20:49 +0000 (GMT)
Message-ID: <06c00181-22f6-1807-b957-61a913758e03@linux.ibm.com>
Date:   Wed, 19 Jan 2022 12:20:48 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 26/30] vfio-pci/zdev: wire up zPCI adapter interrupt
 forwarding support
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-27-mjrosato@linux.ibm.com>
 <adc1df1b-97a0-c41b-cfbf-71a68ea4362d@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <adc1df1b-97a0-c41b-cfbf-71a68ea4362d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cuZgQ90triUhTe-5MPixB4Bi-_oF-btt
X-Proofpoint-ORIG-GUID: vr5C-0o5LWi1yf_eHSltZEcHaWRLLkIX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-19_10,2022-01-19_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/19/22 12:10 PM, Pierre Morel wrote:
> 
> 
> On 1/14/22 21:31, Matthew Rosato wrote:
...
>> diff --git a/include/uapi/linux/vfio_zdev.h 
>> b/include/uapi/linux/vfio_zdev.h
>> index 575f0410dc66..c574e23f9385 100644
>> --- a/include/uapi/linux/vfio_zdev.h
>> +++ b/include/uapi/linux/vfio_zdev.h
>> @@ -90,4 +90,24 @@ struct vfio_device_zpci_interp {
>>       __u32 fh;        /* Host device function handle */
>>   };
>> +/**
>> + * VFIO_DEVICE_FEATURE_ZPCI_AIF
>> + *
>> + * This feature is used for enabling forwarding of adapter interrupts 
>> directly
>> + * from firmware to the guest.  When setting this feature, the flags 
>> indicate
>> + * whether to enable/disable the feature and the structure defined 
>> below is
>> + * used to setup the forwarding structures.  When getting this 
>> feature, only
>> + * the flags are used to indicate the current state.
>> + */
>> +struct vfio_device_zpci_aif {
>> +    __u64 flags;
>> +#define VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT 1
>> +#define VFIO_DEVICE_ZPCI_FLAG_AIF_HOST 2
> 
> Generaly it looks good to me but I miss some explanation on these flags.

I can add a small line comment for each, like:

  AIF_FLOAT 1 /* Floating interrupts enabled */
  AIF_HOST 2  /* Host delivery forced */

But here's a bit more detail:

On SET:
AIF_FLOAT = 1 means enable the interrupt forwarding assist for floating 
interrupt delivery
AIF_FLOAT = 0 means to disable it.
AIF_HOST = 1 means the assist will always deliver the interrupt to the 
host and let the host inject it
AIF_HOST = 0 host only gets interrupts when firmware can't deliver

on GET, we just indicate the current settings from the most recent SET, 
meaning:
AIF_FLOAT = 1 interrupt forwarding assist is currently active
AIF_FLOAT = 0 interrupt forwarding assist is not currently active
AIF_HOST = 1 interrupt forwarding will always go through host
AIF_HOST = 0 interrupt forwarding will only go through the host when 
necessary

> 
> Which makes me realize that a more complete documentation under 
> Documentation/S390 for VFIO zPCI as we have for VFIO AP and VFIO CCW 
> would be of great interest.

You're not wrong -- a similar comment came up for QEMU.  I will add this 
to my todo list as a follow-on.



