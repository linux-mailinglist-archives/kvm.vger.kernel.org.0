Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1864792FF
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 18:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238449AbhLQRnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 12:43:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15822 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238518AbhLQRm7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 12:42:59 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BHHLvKi024132;
        Fri, 17 Dec 2021 17:42:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xqxP4WBcDQzakO2WKSxBM/qT0CRp0SAYV75Dpsw0VNs=;
 b=Oc6sF1ZLEfrNG3vXNOX92WRRUEhDYZ/IeuTDeLjqLQYia2TRUPPRcAPqOxrNPjK+3YNY
 aShSDLfrkv0IHXOMcvEVbV4zuIwVBZ/seRhz/jN2/GhxEcXA54jDaAJWSEeoyp6bz1os
 lue8eij6gO6n+O84CvYhb0429gzPbQxyB6rAf9d74meJSNcYeuvj0cmFUt8U7oyy614U
 57eQRFeyVyWbniYD+CP2AEKwizhCL2d78f3Dh8pUWKF9k98eYGneYejUA0HPNRKFQ3Cw
 zEthVfOgqqj+e9TnLIjdAB9b5uKbf1RKA0weVoN2FcVJbBUwiJz9pTJR0BvEcl5nHAbS hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cyqbjyq90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 17:42:58 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BHHNIf1031311;
        Fri, 17 Dec 2021 17:42:58 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cyqbjyq8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 17:42:58 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BHHBfmB012876;
        Fri, 17 Dec 2021 17:42:57 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01dal.us.ibm.com with ESMTP id 3cy7e55xeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 17:42:57 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BHHgtlv36110826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 17:42:56 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD06B12405A;
        Fri, 17 Dec 2021 17:42:55 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4113C124058;
        Fri, 17 Dec 2021 17:42:52 +0000 (GMT)
Received: from [9.211.79.24] (unknown [9.211.79.24])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 17 Dec 2021 17:42:52 +0000 (GMT)
Message-ID: <abc2bcc9-f5bd-e32a-6561-286c3a508408@linux.ibm.com>
Date:   Fri, 17 Dec 2021 12:42:51 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 15/32] KVM: s390: pci: enable host forwarding of Adapter
 Event Notifications
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-16-mjrosato@linux.ibm.com>
 <8fdf9da0-8213-f116-5e2f-5767e1d9b80e@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <8fdf9da0-8213-f116-5e2f-5767e1d9b80e@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 99mPdl16XJNvCoqPHhILdhOpWd8NVRGF
X-Proofpoint-ORIG-GUID: p5OVMoIjX3pJtdLk4eBmFHTKVqpPxEm1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_07,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112170100
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/21 11:56 AM, Christian Borntraeger wrote:
> Am 07.12.21 um 21:57 schrieb Matthew Rosato:
>> In cases where interrupts are not forwarded to the guest via firmware,
>> KVM is responsible for ensuring delivery.  When an interrupt presents
>> with the forwarding bit, we must process the forwarding tables until
>> all interrupts are delivered.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
> [...]
> 
>> +static void aen_host_forward(struct zpci_aift *aift, unsigned long si)
>> +{
>> +    struct kvm_s390_gisa_interrupt *gi;
>> +    struct zpci_gaite *gaite;
>> +    struct kvm *kvm;
>> +
>> +    gaite = (struct zpci_gaite *)aift->gait +
>> +        (si * sizeof(struct zpci_gaite));
>> +    if (gaite->count == 0)
>> +        return;
>> +    if (gaite->aisb != 0)
>> +        set_bit_inv(gaite->aisbo, (unsigned long *)gaite->aisb);
>> +
>> +    kvm = kvm_s390_pci_si_to_kvm(aift, si);
>> +    if (kvm == 0)
>> +        return;
>> +    gi = &kvm->arch.gisa_int;
>> +
>> +    if (!(gi->origin->g1.simm & AIS_MODE_MASK(gaite->gisc)) ||
>> +        !(gi->origin->g1.nimm & AIS_MODE_MASK(gaite->gisc))) {
>> +        gisa_set_ipm_gisc(gi->origin, gaite->gisc);
>> +        if (hrtimer_active(&gi->timer))
>> +            hrtimer_cancel(&gi->timer);
>> +        hrtimer_start(&gi->timer, 0, HRTIMER_MODE_REL);
>> +        kvm->stat.aen_forward++;
>> +    }
>> +}
>> +
>> +static void aen_process_gait(u8 isc)
>> +{
>> +    bool found = false, first = true;
>> +    union zpci_sic_iib iib = {{0}};
>> +    unsigned long si, flags;
>> +    struct zpci_aift *aift;
>> +
>> +    aift = kvm_s390_pci_get_aift();
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
>> +                first = found = false;
>> +            } else {
>> +                /* Interrupts on and all bits processed */
>> +                break;
>> +            }
>> +            found = false;
>> +            si = 0;
>> +            continue;
>> +        }
>> +        found = true;
>> +        aen_host_forward(aift, si);
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
>> +    if (info->forward || info->error)
>> +        aen_process_gait(info->isc);
>> +    else
>> +        process_gib_alert_list();
>>   }
> 
> Not sure, would it make sense to actually do both after an alert 
> interrupt or do we always get a separate interrupt for event vs. irq?
> [..]

Good point - I thought this was an either/or scenario but I went back 
and doubled checked -- looks like it is indeed possible to get a single 
interrupt that indicates processing of both AEN events and the alert 
list is required.  (It is also possible to get interrupts that indicate 
processing of only one or the other is required).  So, my code above is 
wrong.

However, we also don't need to call process_gib_alert_list() 
unconditionally after handling AEN -- there is more information we can 
check in tpi_adapter_info to decide whether that is necessary (aism);  I 
will add this.
