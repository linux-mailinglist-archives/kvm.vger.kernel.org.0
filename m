Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049CF492C47
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 18:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347192AbiARRZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 12:25:54 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9110 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347105AbiARRZw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 12:25:52 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IHLgjh010637;
        Tue, 18 Jan 2022 17:25:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=amYZtmY9U+mOG4sGiNz4x8BjayVLTmd+nbfz5UHkSfM=;
 b=BvvdleG8xuy607FXBTC2MX5ZUdyGIJO9zCvJHAodgUVB3MXdJAXWJqqG6u420Cj5zzPL
 0YCBZj/tqnaOX9qVtAx8lgpWtcTCtRCAmcgw9a7P22OHzGAufK3p/pWgw8t1+v6UetSa
 E79lTzsXkRxP62yP6LnIb7bm6ggMP4W461qrOtt71zyQVO9oEYodOb3jVSLt4CA9/Ksr
 Snu0NBqcesybfuBIzouGk2u7l/huXVz51qiIrgM9leXQUQvQfpE8wQxzVJIq+Wqxn70S
 phaXPkhq1yKJC9GyU6DuTMSeezx0uMNjWhaPLx5p1wny1yKUkIrTGLpVfgJFwJLzWNOx Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnwjx00ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:25:51 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IHKTWa009749;
        Tue, 18 Jan 2022 17:25:51 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnwjx00p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:25:51 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IHN2xD015816;
        Tue, 18 Jan 2022 17:25:50 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 3dknw9xe5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:25:49 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IHPm3x36897276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 17:25:48 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C148A6E054;
        Tue, 18 Jan 2022 17:25:48 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA1EB6E059;
        Tue, 18 Jan 2022 17:25:46 +0000 (GMT)
Received: from [9.163.19.30] (unknown [9.163.19.30])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 17:25:46 +0000 (GMT)
Message-ID: <9efaf42c-417c-1fa1-7d1c-d31260966109@linux.ibm.com>
Date:   Tue, 18 Jan 2022 12:25:46 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 16/30] KVM: s390: pci: enable host forwarding of
 Adapter Event Notifications
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
 <20220114203145.242984-17-mjrosato@linux.ibm.com>
 <956b3be4-2792-7bd9-e735-bb2d9ea3b8da@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <956b3be4-2792-7bd9-e735-bb2d9ea3b8da@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lrvJOdko1yofT4eCRX9nddmeVE4_zE5Y
X-Proofpoint-ORIG-GUID: F4kSRCJj2rx7fsb1as_-8_1VKfNZytih
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_04,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201180103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/17/22 12:38 PM, Pierre Morel wrote:
> 
...
>> +static void aen_process_gait(u8 isc)
>> +{
>> +    bool found = false, first = true;
>> +    union zpci_sic_iib iib = {{0}};
>> +    unsigned long si, flags;
>> +
>> +    spin_lock_irqsave(&aift->gait_lock, flags);
>> +
>> +    if (!aift->gait) {
>> +        spin_unlock_irqrestore(&aift->gait_lock, flags);
>> +        return;
>> +    }
>> +
>> +    for (si = 0;;) {
>> +        /* Scan adapter summary indicator bit vector */
>> +        si = airq_iv_scan(aift->sbv, si, airq_iv_end(aift->sbv));
>> +        if (si == -1UL) {
>> +            if (first || found) {
>> +                /* Reenable interrupts. */
>> +                if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, isc,
>> +                              &iib))
>> +                    break;
> 
> AFAIU this code is VFIO interpretation specific code and facility 12 is 
> a precondition for it, so I think this break will never occur.
> If I am right we should not test the return value which will make the 
> code clearer.

Yep, you are correct; we can just ignore the return value here.

> 
>> +                first = found = false;
>> +            } else {
>> +                /* Interrupts on and all bits processed */
>> +                break;
>> +            }
> 
> May be add a comment: "rescan after re-enabling interrupts"

OK

> 
>> +            found = false;
>> +            si = 0;
>> +            continue;
>> +        }
>> +        found = true;
>> +        aen_host_forward(si);
>> +    }
>> +
>> +    spin_unlock_irqrestore(&aift->gait_lock, flags);
>> +}
>> +
>>   static void gib_alert_irq_handler(struct airq_struct *airq,
>>                     struct tpi_info *tpi_info)
>>   {
>> +    struct tpi_adapter_info *info = (struct tpi_adapter_info *)tpi_info;
>> +
>>       inc_irq_stat(IRQIO_GAL);
>> -    process_gib_alert_list();
>> +
>> +    if (IS_ENABLED(CONFIG_PCI) && (info->forward || info->error)) {
>> +        aen_process_gait(info->isc);
>> +        if (info->aism != 0)
>> +            process_gib_alert_list();
>> +    } else
>> +        process_gib_alert_list();
> 
> NIT: I think we need braces around this statement

OK

> 
>>   }
>>   static struct airq_struct gib_alert_irq = {
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 01dc3f6883d0..ab8b56deed11 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -65,7 +65,8 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>>       STATS_DESC_COUNTER(VM, inject_float_mchk),
>>       STATS_DESC_COUNTER(VM, inject_pfault_done),
>>       STATS_DESC_COUNTER(VM, inject_service_signal),
>> -    STATS_DESC_COUNTER(VM, inject_virtio)
>> +    STATS_DESC_COUNTER(VM, inject_virtio),
>> +    STATS_DESC_COUNTER(VM, aen_forward)
>>   };
>>   const struct kvm_stats_header kvm_vm_stats_header = {
>> diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
>> index b2000ed7b8c3..387b637863c9 100644
>> --- a/arch/s390/kvm/pci.h
>> +++ b/arch/s390/kvm/pci.h
>> @@ -12,6 +12,7 @@
>>   #include <linux/pci.h>
>>   #include <linux/mutex.h>
>> +#include <linux/kvm_host.h>
>>   #include <asm/airq.h>
>>   #include <asm/kvm_pci.h>
>> @@ -34,6 +35,14 @@ struct zpci_aift {
>>   extern struct zpci_aift *aift;
>> +static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
>> +                         unsigned long si)
>> +{
>> +    if (!IS_ENABLED(CONFIG_PCI) || aift->kzdev == 0 || 
>> aift->kzdev[si] == 0)
> 
> Shouldn't it be better CONFIG_VFIO_PCI ?

While it's true that we can't be doing interpretation without 
CONFIG_VFIO_PCI=y|m, the reason I'm using CONFIG_PCI here and elsewhere 
in the code is because CONFIG_PCI is what is being used to determine 
whether or not we build arch/s390/kvm/pci.o in patch 14 (and thus 
whether or not the aift exists) -- And the reason we use this is because 
this is where the code dependencies exist (examples include 
ZPCI_NR_DEVICES, the AEN pieces that must be preserved over KVM module 
remove/insert in patch 15)

If we for some reason have a case where CONFIG_KVM=y|m && CONFIG_PCI=y|m 
&& CONFIG_VFIO_PCI=n, this will still work:  aift and aift->kzdev will 
exist (kvm/pci.o is linked) but we will never actually drive this 
routine anyway because we'll never register a device for AEN forwarding 
without CONFIG_VFIO_PCI.



