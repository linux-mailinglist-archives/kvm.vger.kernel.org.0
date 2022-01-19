Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB78493FC9
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 19:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356708AbiASSXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 13:23:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25304 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235941AbiASSXg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 13:23:36 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JIBbZR023405;
        Wed, 19 Jan 2022 18:23:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Yf6cnYb6QdxduGssJDBzWHEyg67Wg9UPrVhBnrWaGno=;
 b=hiVtchQgigRh6o8RxacR9ey9CFEo07fpaPV3Eob+TGFRU9QjNcgjIFKi3Tu7jIMo5CTr
 Gc8gJe4/+876VXL8ynv1hYGBeHLaIVp878hq0cuZM1Uf4p2FJQvirHUdtSnerTbRMOYA
 OgNPbri4IBSUtNEx7rtw/VSBzul/pprGXhN9wqUhyh8sXXPBlI8C391OndEg1pGLO4dV
 NNmUfEYY3s4n1Vby4Nj22BaO0q3Nm6kazQx5SP05RzDVgvdwYMz6GKPt0McR2ZRkq5fv
 54XULpWTyOapjCrbk+JvMwPf2+Sj/CWva8IdTLYl3mIwmLXjkW+lpHuLc23Ph4zkiTy9 hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dpp8s2ees-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 18:23:34 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20JIJ9eJ019821;
        Wed, 19 Jan 2022 18:23:34 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dpp8s2ee6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 18:23:34 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20JIHk4I016269;
        Wed, 19 Jan 2022 18:23:32 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3dknw9hbp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 18:23:32 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20JINSRk32571698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 18:23:28 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13B83A406B;
        Wed, 19 Jan 2022 18:23:28 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5AC8A4055;
        Wed, 19 Jan 2022 18:23:26 +0000 (GMT)
Received: from [9.171.7.240] (unknown [9.171.7.240])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jan 2022 18:23:26 +0000 (GMT)
Message-ID: <cebcc3de-e332-6381-f450-a6a26ef88182@linux.ibm.com>
Date:   Wed, 19 Jan 2022 19:25:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 21/30] KVM: s390: pci: handle refresh of PCI
 translations
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
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
 <3d8c05d7-79ec-dfa8-bfcb-b8888183612a@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <3d8c05d7-79ec-dfa8-bfcb-b8888183612a@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: I7juRovRK3MX_SqBTY1lyfF8JNodhXdB
X-Proofpoint-GUID: SWtv8itAXkmqmluka92Yih1K3COdnTqZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-19_10,2022-01-19_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 mlxlogscore=999
 malwarescore=0 suspectscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/19/22 17:39, Matthew Rosato wrote:
> On 1/19/22 4:29 AM, Pierre Morel wrote:
>>
>>
>> On 1/14/22 21:31, Matthew Rosato wrote:
> ...
>>> +static int dma_table_shadow(struct kvm_vcpu *vcpu, struct zpci_dev 
>>> *zdev,
>>> +                dma_addr_t dma_addr, size_t size)
>>> +{
>>> +    unsigned int nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
>>> +    struct kvm_zdev *kzdev = zdev->kzdev;
>>> +    unsigned long *entry, *gentry;
>>> +    int i, rc = 0, rc2;
>>> +
>>> +    if (!nr_pages || !kzdev)
>>> +        return -EINVAL;
>>> +
>>> +    mutex_lock(&kzdev->ioat.lock);
>>> +    if (!zdev->dma_table || !kzdev->ioat.head[0]) {
>>> +        rc = -EINVAL;
>>> +        goto out_unlock;
>>> +    }
>>> +
>>> +    for (i = 0; i < nr_pages; i++) {
>>> +        gentry = dma_walk_guest_cpu_trans(vcpu, &kzdev->ioat, 
>>> dma_addr);
>>> +        if (!gentry)
>>> +            continue;
>>> +        entry = dma_walk_cpu_trans(zdev->dma_table, dma_addr);
>>> +
>>> +        if (!entry) {
>>> +            rc = -ENOMEM;
>>> +            goto out_unlock;
>>> +        }
>>> +
>>> +        rc2 = dma_shadow_cpu_trans(vcpu, entry, gentry);
>>> +        if (rc2 < 0) {
>>> +            rc = -EIO;
>>> +            goto out_unlock;
>>> +        }
>>> +        dma_addr += PAGE_SIZE;
>>> +        rc += rc2;
>>> +    }
>>> +
>>
>> In case of error, shouldn't we invalidate the shadow tables entries we 
>> did validate until the error?
> 
> Hmm, I don't think this is strictly necessary - the status returned 
> should indicate the specified DMA range is now in an indeterminate state 
> (putting the onus on the guest to take corrective action via a global 
> refresh).
> 
> In fact I think I screwed that up below in kvm_s390_pci_refresh_trans, 
> the fabricated status should always be KVM_S390_RPCIT_INS_RES.

OK

> 
>>
>>> +out_unlock:
>>> +    mutex_unlock(&kzdev->ioat.lock);
>>> +    return rc;
>>> +}
>>> +
>>> +int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long 
>>> req,
>>> +                   unsigned long start, unsigned long size,
>>> +                   u8 *status)
>>> +{
>>> +    struct zpci_dev *zdev;
>>> +    u32 fh = req >> 32;
>>> +    int rc;
>>> +
>>> +    /* Make sure this is a valid device associated with this guest */
>>> +    zdev = get_zdev_by_fh(fh);
>>> +    if (!zdev || !zdev->kzdev || zdev->kzdev->kvm != vcpu->kvm) {
>>> +        *status = 0;
>>
>> Wouldn't it be interesting to add some debug information here.
>> When would this appear?
> 
> Yes, I agree -- One of the follow-ons I'd like to add after this series 
> is s390dbf entries; this seems like a good spot for one.
> 
> As to when this could happen; it should not under normal circumstances, 
> but consider something like arbitrary function handles coming from the 
> intercepted guest instruction.  We need to ensure that the specified 
> function 1) exists and 2) is associated with the guest issuing the refresh.
> 
>>
>> Also if we have this error this looks like we have a VM problem, 
>> shouldn't we treat this in QEMU and return -EOPNOTSUPP ?
>>
> 
> Well, I'm not sure if we can really tell where the problem is (it could 
> for example indicate a misbehaving guest, or a bug in our KVM tracking 
> of hostdevs).
> 
> The guest chose the function handle, and if we got here then that means 
> it doesn't indicate that it's an emulated device, which means either we 
> are using the assist and KVM should handle the intercept or we are not 
> and userspace should handle it.  But in both of those cases, there 
> should be a host device and it should be associated with the guest.

That is right if we can not find an associated zdev = F(fh)
but the two other errors are KVM or QEMU errors AFAIU.

> 
> I think if we decide to throw this to userspace in this event, QEMU 
> needs some extra code to handle it (basically, if QEMU receives the 
> intercept and the device is neither emulated nor using intercept mode 
> then we must treat as an invalid handle as this intercept should have 
> been handled by KVM)

I do not want to start a discussion on this, I think we can let it like 
this at first and come back to it when we have a good idea on how to 
handle this.
May be just add a /* TODO */


> 
> 
>>> +        return -EINVAL;
>>> +    }
>>> +
>>> +    /* Only proceed if the device is using the assist */
>>> +    if (zdev->kzdev->ioat.head[0] == 0)
>>> +        return -EOPNOTSUPP;
>>> +
>>> +    rc = dma_table_shadow(vcpu, zdev, start, size);
>>> +    if (rc < 0) {
>>> +        /*
>>> +         * If errors encountered during shadow operations, we must
>>> +         * fabricate status to present to the guest
>>> +         */
>>> +        switch (rc) {
>>> +        case -ENOMEM:
>>> +            *status = KVM_S390_RPCIT_INS_RES;
>>> +            break;
>>> +        default:
>>> +            *status = KVM_S390_RPCIT_ERR;
>>> +            break;
> 
> As mentioned above I think this switch statement should go away and 
> instead always set KVM_S390_RPCIT_INS_RES when rc < 0.
> 
>>> +        }
>>> +    } else if (rc > 0) {
>>> +        /* Host RPCIT must be issued */
>>> +        rc = zpci_refresh_trans((u64) zdev->fh << 32, start, size,
>>> +                    status);
>>> +    }
>>> +    zdev->kzdev->rpcit_count++;
>>> +
>>> +    return rc;
>>> +}
>>> +
>>>   /* Modify PCI: Register floating adapter interruption forwarding */
>>>   static int kvm_zpci_set_airq(struct zpci_dev *zdev)
>>>   {
>>> @@ -620,6 +822,8 @@ EXPORT_SYMBOL_GPL(kvm_s390_pci_attach_kvm);
>>>   int kvm_s390_pci_init(void)
>>>   {
>>> +    int rc;
>>> +
>>>       aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
>>>       if (!aift)
>>>           return -ENOMEM;
>>> @@ -627,5 +831,7 @@ int kvm_s390_pci_init(void)
>>>       spin_lock_init(&aift->gait_lock);
>>>       mutex_init(&aift->lock);
>>> -    return 0;
>>> +    rc = zpci_get_mdd(&aift->mdd);
>>> +
>>> +    return rc;
>>>   }
>>> diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
>>> index 54355634df82..bb2be7fc3934 100644
>>> --- a/arch/s390/kvm/pci.h
>>> +++ b/arch/s390/kvm/pci.h
>>> @@ -18,6 +18,9 @@
>>>   #define KVM_S390_PCI_DTSM_MASK 0x40
>>> +#define KVM_S390_RPCIT_INS_RES 0x10
>>> +#define KVM_S390_RPCIT_ERR 0x28
>>> +
>>>   struct zpci_gaite {
>>>       u32 gisa;
>>>       u8 gisc;
>>> @@ -33,6 +36,7 @@ struct zpci_aift {
>>>       struct kvm_zdev **kzdev;
>>>       spinlock_t gait_lock; /* Protects the gait, used during AEN 
>>> forward */
>>>       struct mutex lock; /* Protects the other structures in aift */
>>> +    u32 mdd;
>>>   };
>>>   extern struct zpci_aift *aift;
>>> @@ -47,7 +51,9 @@ static inline struct kvm 
>>> *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
>>>   int kvm_s390_pci_aen_init(u8 nisc);
>>>   void kvm_s390_pci_aen_exit(void);
>>> -
>>> +int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long 
>>> req,
>>> +                   unsigned long start, unsigned long end,
>>> +                   u8 *status);
>>>   int kvm_s390_pci_init(void);
>>>   #endif /* __KVM_S390_PCI_H */
>>>
>>
> 

-- 
Pierre Morel
IBM Lab Boeblingen
