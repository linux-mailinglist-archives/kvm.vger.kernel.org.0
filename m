Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69092493E75
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 17:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350059AbiASQkH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 11:40:07 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23184 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232196AbiASQkF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 11:40:05 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JFdKYh014754;
        Wed, 19 Jan 2022 16:40:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=EOSNhzlOBbaowhsnJEogSqXvdKPXftjOqaJR60pxLjw=;
 b=e3ZOmww1EPnFb/Sw3UueeYZ8x0x/pb5Dz5r1KYqfdJdVcJRiBS4FI/dTMdq9Sr2xYGsl
 Iu/hF7QJglyWYtR+X7Azkvql0uWRAbC4jVwzBksliMBNeg7TPfTyvz5frr+/N9AqfhBR
 uG3/f8lDZsHi4rrqzzJo0LafIU7xIVSnoXfiwiPU98GMpqTTyrVccnnN0UUCipotZn6g
 WqVB2gbpR1k+V2sq1Q43SATXyIpt3uWxkHzWqXDHMyffmIQAxGLVoTXbNlY54/8gFUkK
 ZbMoTKgNAyUtuqFseqUFwworn9VwmvC8rsPpaDElftB7CUG3TgkQjfFCNyIHQkPzi2Hs uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dpkmsmr0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 16:40:04 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20JFj8BQ016732;
        Wed, 19 Jan 2022 16:40:03 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dpkmsmr02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 16:40:03 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20JGX7iE032748;
        Wed, 19 Jan 2022 16:40:02 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 3dknwambk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 16:40:02 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20JGe1Uf27853086
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 16:40:01 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94E5413606E;
        Wed, 19 Jan 2022 16:40:01 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 832B1136053;
        Wed, 19 Jan 2022 16:39:59 +0000 (GMT)
Received: from [9.163.19.30] (unknown [9.163.19.30])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jan 2022 16:39:59 +0000 (GMT)
Message-ID: <3d8c05d7-79ec-dfa8-bfcb-b8888183612a@linux.ibm.com>
Date:   Wed, 19 Jan 2022 11:39:58 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 21/30] KVM: s390: pci: handle refresh of PCI
 translations
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
 <20220114203145.242984-22-mjrosato@linux.ibm.com>
 <265e3448-2e8e-c38b-e625-1546ae3d408b@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <265e3448-2e8e-c38b-e625-1546ae3d408b@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4ya52jZpPl15v2xKswiA8lb3CXSz_mqS
X-Proofpoint-ORIG-GUID: 0EN3XinWS3SSWG23xQ-_PJ3Adgw7CsBF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-19_09,2022-01-19_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015 spamscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/19/22 4:29 AM, Pierre Morel wrote:
> 
> 
> On 1/14/22 21:31, Matthew Rosato wrote:
...
>> +static int dma_table_shadow(struct kvm_vcpu *vcpu, struct zpci_dev 
>> *zdev,
>> +                dma_addr_t dma_addr, size_t size)
>> +{
>> +    unsigned int nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
>> +    struct kvm_zdev *kzdev = zdev->kzdev;
>> +    unsigned long *entry, *gentry;
>> +    int i, rc = 0, rc2;
>> +
>> +    if (!nr_pages || !kzdev)
>> +        return -EINVAL;
>> +
>> +    mutex_lock(&kzdev->ioat.lock);
>> +    if (!zdev->dma_table || !kzdev->ioat.head[0]) {
>> +        rc = -EINVAL;
>> +        goto out_unlock;
>> +    }
>> +
>> +    for (i = 0; i < nr_pages; i++) {
>> +        gentry = dma_walk_guest_cpu_trans(vcpu, &kzdev->ioat, dma_addr);
>> +        if (!gentry)
>> +            continue;
>> +        entry = dma_walk_cpu_trans(zdev->dma_table, dma_addr);
>> +
>> +        if (!entry) {
>> +            rc = -ENOMEM;
>> +            goto out_unlock;
>> +        }
>> +
>> +        rc2 = dma_shadow_cpu_trans(vcpu, entry, gentry);
>> +        if (rc2 < 0) {
>> +            rc = -EIO;
>> +            goto out_unlock;
>> +        }
>> +        dma_addr += PAGE_SIZE;
>> +        rc += rc2;
>> +    }
>> +
> 
> In case of error, shouldn't we invalidate the shadow tables entries we 
> did validate until the error?

Hmm, I don't think this is strictly necessary - the status returned 
should indicate the specified DMA range is now in an indeterminate state 
(putting the onus on the guest to take corrective action via a global 
refresh).

In fact I think I screwed that up below in kvm_s390_pci_refresh_trans, 
the fabricated status should always be KVM_S390_RPCIT_INS_RES.

> 
>> +out_unlock:
>> +    mutex_unlock(&kzdev->ioat.lock);
>> +    return rc;
>> +}
>> +
>> +int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long req,
>> +                   unsigned long start, unsigned long size,
>> +                   u8 *status)
>> +{
>> +    struct zpci_dev *zdev;
>> +    u32 fh = req >> 32;
>> +    int rc;
>> +
>> +    /* Make sure this is a valid device associated with this guest */
>> +    zdev = get_zdev_by_fh(fh);
>> +    if (!zdev || !zdev->kzdev || zdev->kzdev->kvm != vcpu->kvm) {
>> +        *status = 0;
> 
> Wouldn't it be interesting to add some debug information here.
> When would this appear?

Yes, I agree -- One of the follow-ons I'd like to add after this series 
is s390dbf entries; this seems like a good spot for one.

As to when this could happen; it should not under normal circumstances, 
but consider something like arbitrary function handles coming from the 
intercepted guest instruction.  We need to ensure that the specified 
function 1) exists and 2) is associated with the guest issuing the refresh.

> 
> Also if we have this error this looks like we have a VM problem, 
> shouldn't we treat this in QEMU and return -EOPNOTSUPP ?
> 

Well, I'm not sure if we can really tell where the problem is (it could 
for example indicate a misbehaving guest, or a bug in our KVM tracking 
of hostdevs).

The guest chose the function handle, and if we got here then that means 
it doesn't indicate that it's an emulated device, which means either we 
are using the assist and KVM should handle the intercept or we are not 
and userspace should handle it.  But in both of those cases, there 
should be a host device and it should be associated with the guest.

I think if we decide to throw this to userspace in this event, QEMU 
needs some extra code to handle it (basically, if QEMU receives the 
intercept and the device is neither emulated nor using intercept mode 
then we must treat as an invalid handle as this intercept should have 
been handled by KVM)


>> +        return -EINVAL;
>> +    }
>> +
>> +    /* Only proceed if the device is using the assist */
>> +    if (zdev->kzdev->ioat.head[0] == 0)
>> +        return -EOPNOTSUPP;
>> +
>> +    rc = dma_table_shadow(vcpu, zdev, start, size);
>> +    if (rc < 0) {
>> +        /*
>> +         * If errors encountered during shadow operations, we must
>> +         * fabricate status to present to the guest
>> +         */
>> +        switch (rc) {
>> +        case -ENOMEM:
>> +            *status = KVM_S390_RPCIT_INS_RES;
>> +            break;
>> +        default:
>> +            *status = KVM_S390_RPCIT_ERR;
>> +            break;

As mentioned above I think this switch statement should go away and 
instead always set KVM_S390_RPCIT_INS_RES when rc < 0.

>> +        }
>> +    } else if (rc > 0) {
>> +        /* Host RPCIT must be issued */
>> +        rc = zpci_refresh_trans((u64) zdev->fh << 32, start, size,
>> +                    status);
>> +    }
>> +    zdev->kzdev->rpcit_count++;
>> +
>> +    return rc;
>> +}
>> +
>>   /* Modify PCI: Register floating adapter interruption forwarding */
>>   static int kvm_zpci_set_airq(struct zpci_dev *zdev)
>>   {
>> @@ -620,6 +822,8 @@ EXPORT_SYMBOL_GPL(kvm_s390_pci_attach_kvm);
>>   int kvm_s390_pci_init(void)
>>   {
>> +    int rc;
>> +
>>       aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
>>       if (!aift)
>>           return -ENOMEM;
>> @@ -627,5 +831,7 @@ int kvm_s390_pci_init(void)
>>       spin_lock_init(&aift->gait_lock);
>>       mutex_init(&aift->lock);
>> -    return 0;
>> +    rc = zpci_get_mdd(&aift->mdd);
>> +
>> +    return rc;
>>   }
>> diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
>> index 54355634df82..bb2be7fc3934 100644
>> --- a/arch/s390/kvm/pci.h
>> +++ b/arch/s390/kvm/pci.h
>> @@ -18,6 +18,9 @@
>>   #define KVM_S390_PCI_DTSM_MASK 0x40
>> +#define KVM_S390_RPCIT_INS_RES 0x10
>> +#define KVM_S390_RPCIT_ERR 0x28
>> +
>>   struct zpci_gaite {
>>       u32 gisa;
>>       u8 gisc;
>> @@ -33,6 +36,7 @@ struct zpci_aift {
>>       struct kvm_zdev **kzdev;
>>       spinlock_t gait_lock; /* Protects the gait, used during AEN 
>> forward */
>>       struct mutex lock; /* Protects the other structures in aift */
>> +    u32 mdd;
>>   };
>>   extern struct zpci_aift *aift;
>> @@ -47,7 +51,9 @@ static inline struct kvm 
>> *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
>>   int kvm_s390_pci_aen_init(u8 nisc);
>>   void kvm_s390_pci_aen_exit(void);
>> -
>> +int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long req,
>> +                   unsigned long start, unsigned long end,
>> +                   u8 *status);
>>   int kvm_s390_pci_init(void);
>>   #endif /* __KVM_S390_PCI_H */
>>
> 

