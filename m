Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060CF474A20
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 18:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236765AbhLNRzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 12:55:08 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14572 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231778AbhLNRzH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 12:55:07 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BEH5aEg020660;
        Tue, 14 Dec 2021 17:55:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9Ui7e8x4oiWOeuaIgdnuQgKBwCYMpxHO+ESkl8+CQL8=;
 b=Iw3m1rtmyUKzCEgpi0qqsrogdNdWF72+rzB6i+1BmoyRr+5Ha9rUTP4nLzl72qOhvUgH
 qkNaiO1plu+cCp0vjldCNIij7e3hZ3i/dBmyEXcaWgSkEMOMV3Y2idyeQuQDAQL71yCH
 BoTP8jRKEAY+yr3BDscHd68PsZQgS86T/hFJfEK/2Oz4C0nlMrOu06GOaOYrQraPrSDn
 eC2fgd5/uV8Vvdu+LRkoFJMj6lRyto9QD/W7/cPcyOSH7/1mRehRJh4qq1E/Ebdl0eT9
 b+WP2UKpFCt6fIWXiT/uEYRUZkdNugPE4azbsoN1f1/lbXquUrzLqTdLGv9Q1e9Fih2X nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r9p73k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 17:55:07 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BEHrB4j025205;
        Tue, 14 Dec 2021 17:55:06 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r9p735-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 17:55:06 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BEHkpxP015528;
        Tue, 14 Dec 2021 17:55:05 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 3cvkmatkj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 17:55:05 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BEHt2xM10813744
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 17:55:02 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56ECCAC066;
        Tue, 14 Dec 2021 17:55:02 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46E58AC059;
        Tue, 14 Dec 2021 17:54:57 +0000 (GMT)
Received: from [9.211.79.24] (unknown [9.211.79.24])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 14 Dec 2021 17:54:57 +0000 (GMT)
Message-ID: <a963388d-b13e-07c5-c256-c91671b3aa73@linux.ibm.com>
Date:   Tue, 14 Dec 2021 12:54:55 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 23/32] KVM: s390: pci: handle refresh of PCI translations
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
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-24-mjrosato@linux.ibm.com>
 <d2af697e-bf48-e78b-eed6-766f0790232f@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <d2af697e-bf48-e78b-eed6-766f0790232f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FkaTcAfJX5LIyrxycFS-ceLyvqhLmxEV
X-Proofpoint-ORIG-GUID: 8xweLf3dy6EPgbqdS4GogyytxbIRuXCh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_07,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 impostorscore=0 adultscore=0 spamscore=0
 clxscore=1015 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/21 11:59 AM, Pierre Morel wrote:
> 
> 
> On 12/7/21 21:57, Matthew Rosato wrote:
>> Add a routine that will perform a shadow operation between a guest
>> and host IOAT.  A subsequent patch will invoke this in response to
>> an 04 RPCIT instruction intercept.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_pci.h |   1 +
>>   arch/s390/include/asm/pci_dma.h |   1 +
>>   arch/s390/kvm/pci.c             | 191 ++++++++++++++++++++++++++++++++
>>   arch/s390/kvm/pci.h             |   4 +-
>>   4 files changed, 196 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/include/asm/kvm_pci.h 
>> b/arch/s390/include/asm/kvm_pci.h
>> index 254275399f21..97e3a369135d 100644
>> --- a/arch/s390/include/asm/kvm_pci.h
>> +++ b/arch/s390/include/asm/kvm_pci.h
>> @@ -30,6 +30,7 @@ struct kvm_zdev_ioat {
>>   struct kvm_zdev {
>>       struct zpci_dev *zdev;
>>       struct kvm *kvm;
>> +    u64 rpcit_count;
>>       struct kvm_zdev_ioat ioat;
>>       struct zpci_fib fib;
>>   };
>> diff --git a/arch/s390/include/asm/pci_dma.h 
>> b/arch/s390/include/asm/pci_dma.h
>> index e1d3c1d3fc8a..0ca15e5db3d9 100644
>> --- a/arch/s390/include/asm/pci_dma.h
>> +++ b/arch/s390/include/asm/pci_dma.h
>> @@ -52,6 +52,7 @@ enum zpci_ioat_dtype {
>>   #define ZPCI_TABLE_ENTRIES        (ZPCI_TABLE_SIZE / 
>> ZPCI_TABLE_ENTRY_SIZE)
>>   #define ZPCI_TABLE_PAGES        (ZPCI_TABLE_SIZE >> PAGE_SHIFT)
>>   #define ZPCI_TABLE_ENTRIES_PAGES    (ZPCI_TABLE_ENTRIES * 
>> ZPCI_TABLE_PAGES)
>> +#define ZPCI_TABLE_ENTRIES_PER_PAGE    (ZPCI_TABLE_ENTRIES / 
>> ZPCI_TABLE_PAGES)
>>   #define ZPCI_TABLE_BITS            11
>>   #define ZPCI_PT_BITS            8
>> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
>> index a1c0c0881332..858c5ecdc8b9 100644
>> --- a/arch/s390/kvm/pci.c
>> +++ b/arch/s390/kvm/pci.c
>> @@ -123,6 +123,195 @@ int kvm_s390_pci_aen_init(u8 nisc)
>>       return rc;
>>   }
> 
> ...snip...
> 
>> +
>> +int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long req,
>> +                   unsigned long start, unsigned long size)
>> +{
>> +    struct zpci_dev *zdev;
>> +    u32 fh;
>> +    int rc;
>> +
>> +    /* If the device has a SHM bit on, let userspace take care of 
>> this */
>> +    fh = req >> 32;
>> +    if ((fh & aift.mdd) != 0)
>> +        return -EOPNOTSUPP;
> 
> I think you should make this check in the caller.

OK

> 
>> +
>> +    /* Make sure this is a valid device associated with this guest */
>> +    zdev = get_zdev_by_fh(fh);
>> +    if (!zdev || !zdev->kzdev || zdev->kzdev->kvm != vcpu->kvm)
>> +        return -EINVAL;
>> +
>> +    /* Only proceed if the device is using the assist */
>> +    if (zdev->kzdev->ioat.head[0] == 0)
>> +        return -EOPNOTSUPP;
> 
> Using the assist means using interpretation over using interception and 
> legacy vfio-pci. right?

Right - more specifically that the IOAT assist feature was never set via 
the vfio feature ioctl, so we can't handle the RPCIT for this device and 
so throw to userspace.

The way the QEMU series is being implemented, a device using 
interpretation will always have the IOAT feature set on.

> 
>> +
>> +    rc = dma_table_shadow(vcpu, zdev, start, size);
>> +    if (rc > 0)
>> +        rc = zpci_refresh_trans((u64) zdev->fh << 32, start, size);
> 
> Here you lose the status reported by the hardware.
> You should directly use __rpcit(fn, addr, range, &status);

OK, I can have a look at doing this.

@Niklas thoughts on how you would want this exported.  Renamed to 
zpci_rpcit or so?

> 
> 
>> +    zdev->kzdev->rpcit_count++;
>> +
>> +    return rc;
>> +}
>> +
>>   /* Modify PCI: Register floating adapter interruption forwarding */
>>   static int kvm_zpci_set_airq(struct zpci_dev *zdev)
>>   {
>> @@ -590,4 +779,6 @@ void kvm_s390_pci_init(void)
>>   {
>>       spin_lock_init(&aift.gait_lock);
>>       mutex_init(&aift.lock);
>> +
>> +    WARN_ON(zpci_get_mdd(&aift.mdd));
>>   }
>> diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
>> index 3c86888fe1b3..d252a631b693 100644
>> --- a/arch/s390/kvm/pci.h
>> +++ b/arch/s390/kvm/pci.h
>> @@ -33,6 +33,7 @@ struct zpci_aift {
>>       struct kvm_zdev **kzdev;
>>       spinlock_t gait_lock; /* Protects the gait, used during AEN 
>> forward */
>>       struct mutex lock; /* Protects the other structures in aift */
>> +    u32 mdd;
>>   };
>>   static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift 
>> *aift,
>> @@ -47,7 +48,8 @@ struct zpci_aift *kvm_s390_pci_get_aift(void);
>>   int kvm_s390_pci_aen_init(u8 nisc);
>>   void kvm_s390_pci_aen_exit(void);
>> -
>> +int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long req,
>> +                   unsigned long start, unsigned long end);
>>   void kvm_s390_pci_init(void);
>>   #endif /* __KVM_S390_PCI_H */
>>
> 

