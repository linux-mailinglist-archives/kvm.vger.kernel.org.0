Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B4B4748A8
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 17:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbhLNQ6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 11:58:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32864 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231448AbhLNQ6g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 11:58:36 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BEGrVFs030135;
        Tue, 14 Dec 2021 16:58:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rTHtozXI4ViJ1L+tWL+diTmoXATH2TlA/gPNMw/UTDQ=;
 b=XErytREI1hTkMm1pIyOoyxh+b2pIYT0I2ORDoED1o2CBU72c2RepUdYQ84dhA4Quxcgf
 h24A8FbX0kX9kpncerk7XeTA20J0cT++1VS2V7jM22XLiRwYzuu64Iik1uefJBmQeuCu
 A7bwDk3mKfVRUd7a6HzU0q6bQM4vz+qW2kuIkBuioZEvaGgZP7rZHFmr44wDgTKs/5a/
 YYhy+Fmvl6xaSpAmiMAKHGvNX9Z7tiebPqvADmPz9hH8ZAFvHsRmyLe2Ag/ItWAkVwQr
 cv0W4FU+B1kw77nj5sZ6pwsvhnDFPiozIKGpvjIHpkT3nlDqxKDvCZ28nkH8GZI5fpJU qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r7cm3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 16:58:35 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BEGw8Jt018557;
        Tue, 14 Dec 2021 16:58:34 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r7cm2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 16:58:34 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BEGYNbP001931;
        Tue, 14 Dec 2021 16:58:32 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3cvkm9g3gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 16:58:32 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BEGwTOR46727454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 16:58:29 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53806A4057;
        Tue, 14 Dec 2021 16:58:29 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26202A4051;
        Tue, 14 Dec 2021 16:58:28 +0000 (GMT)
Received: from [9.171.24.181] (unknown [9.171.24.181])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Dec 2021 16:58:28 +0000 (GMT)
Message-ID: <d2af697e-bf48-e78b-eed6-766f0790232f@linux.ibm.com>
Date:   Tue, 14 Dec 2021 17:59:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 23/32] KVM: s390: pci: handle refresh of PCI translations
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
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-24-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20211207205743.150299-24-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Jj2xwHmdq6LqFs80QsFgy8iYyJGmc2OV
X-Proofpoint-ORIG-GUID: UMI9tFxO3gTMC4ZQXOKAhmL_tjJwMJ9j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_07,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 suspectscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112140092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/7/21 21:57, Matthew Rosato wrote:
> Add a routine that will perform a shadow operation between a guest
> and host IOAT.  A subsequent patch will invoke this in response to
> an 04 RPCIT instruction intercept.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_pci.h |   1 +
>   arch/s390/include/asm/pci_dma.h |   1 +
>   arch/s390/kvm/pci.c             | 191 ++++++++++++++++++++++++++++++++
>   arch/s390/kvm/pci.h             |   4 +-
>   4 files changed, 196 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> index 254275399f21..97e3a369135d 100644
> --- a/arch/s390/include/asm/kvm_pci.h
> +++ b/arch/s390/include/asm/kvm_pci.h
> @@ -30,6 +30,7 @@ struct kvm_zdev_ioat {
>   struct kvm_zdev {
>   	struct zpci_dev *zdev;
>   	struct kvm *kvm;
> +	u64 rpcit_count;
>   	struct kvm_zdev_ioat ioat;
>   	struct zpci_fib fib;
>   };
> diff --git a/arch/s390/include/asm/pci_dma.h b/arch/s390/include/asm/pci_dma.h
> index e1d3c1d3fc8a..0ca15e5db3d9 100644
> --- a/arch/s390/include/asm/pci_dma.h
> +++ b/arch/s390/include/asm/pci_dma.h
> @@ -52,6 +52,7 @@ enum zpci_ioat_dtype {
>   #define ZPCI_TABLE_ENTRIES		(ZPCI_TABLE_SIZE / ZPCI_TABLE_ENTRY_SIZE)
>   #define ZPCI_TABLE_PAGES		(ZPCI_TABLE_SIZE >> PAGE_SHIFT)
>   #define ZPCI_TABLE_ENTRIES_PAGES	(ZPCI_TABLE_ENTRIES * ZPCI_TABLE_PAGES)
> +#define ZPCI_TABLE_ENTRIES_PER_PAGE	(ZPCI_TABLE_ENTRIES / ZPCI_TABLE_PAGES)
>   
>   #define ZPCI_TABLE_BITS			11
>   #define ZPCI_PT_BITS			8
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index a1c0c0881332..858c5ecdc8b9 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -123,6 +123,195 @@ int kvm_s390_pci_aen_init(u8 nisc)
>   	return rc;
>   }

...snip...

> +
> +int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long req,
> +			       unsigned long start, unsigned long size)
> +{
> +	struct zpci_dev *zdev;
> +	u32 fh;
> +	int rc;
> +
> +	/* If the device has a SHM bit on, let userspace take care of this */
> +	fh = req >> 32;
> +	if ((fh & aift.mdd) != 0)
> +		return -EOPNOTSUPP;

I think you should make this check in the caller.

> +
> +	/* Make sure this is a valid device associated with this guest */
> +	zdev = get_zdev_by_fh(fh);
> +	if (!zdev || !zdev->kzdev || zdev->kzdev->kvm != vcpu->kvm)
> +		return -EINVAL;
> +
> +	/* Only proceed if the device is using the assist */
> +	if (zdev->kzdev->ioat.head[0] == 0)
> +		return -EOPNOTSUPP;

Using the assist means using interpretation over using interception and 
legacy vfio-pci. right?

> +
> +	rc = dma_table_shadow(vcpu, zdev, start, size);
> +	if (rc > 0)
> +		rc = zpci_refresh_trans((u64) zdev->fh << 32, start, size);

Here you lose the status reported by the hardware.
You should directly use __rpcit(fn, addr, range, &status);


> +	zdev->kzdev->rpcit_count++;
> +
> +	return rc;
> +}
> +
>   /* Modify PCI: Register floating adapter interruption forwarding */
>   static int kvm_zpci_set_airq(struct zpci_dev *zdev)
>   {
> @@ -590,4 +779,6 @@ void kvm_s390_pci_init(void)
>   {
>   	spin_lock_init(&aift.gait_lock);
>   	mutex_init(&aift.lock);
> +
> +	WARN_ON(zpci_get_mdd(&aift.mdd));
>   }
> diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
> index 3c86888fe1b3..d252a631b693 100644
> --- a/arch/s390/kvm/pci.h
> +++ b/arch/s390/kvm/pci.h
> @@ -33,6 +33,7 @@ struct zpci_aift {
>   	struct kvm_zdev **kzdev;
>   	spinlock_t gait_lock; /* Protects the gait, used during AEN forward */
>   	struct mutex lock; /* Protects the other structures in aift */
> +	u32 mdd;
>   };
>   
>   static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
> @@ -47,7 +48,8 @@ struct zpci_aift *kvm_s390_pci_get_aift(void);
>   
>   int kvm_s390_pci_aen_init(u8 nisc);
>   void kvm_s390_pci_aen_exit(void);
> -
> +int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long req,
> +			       unsigned long start, unsigned long end);
>   void kvm_s390_pci_init(void);
>   
>   #endif /* __KVM_S390_PCI_H */
> 

-- 
Pierre Morel
IBM Lab Boeblingen
