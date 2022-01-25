Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6888F49B431
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 13:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453010AbiAYMm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 07:42:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18872 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1383526AbiAYMjy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 07:39:54 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PCK2EM007397;
        Tue, 25 Jan 2022 12:39:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SlywLxpsS5eWz0E4+pWBh8y5971KSf+ttGtRG3Lqu3k=;
 b=b9VVPRtMSo22exWAFDoH4O/QIR9Y6OgPBkvDs2370CnA/pbyoKhzSyuSv0Q1mPLQngJH
 pnM6il1efSAj5qFDKsPDzbIwJmdGcmuTTQpjbIuwyuWEVFBWwbaGR9H2MtWbJDNhUPdG
 JG+xev46hhslSyO0ri66ZYsHI4lILxHWDZ3Bdby+caedlp9RQwM107JWTIWraHHW+5co
 Qulu92yBpCAZsLwP3rcMug2yzZ0VmLXsDTF1fjr3hLkEexw2R7UTMM/MkVwZnbdiYIrX
 G84Li9jItckRzTcK4jEEWrAPLH0FY84rsuaBt2CjdVO9fKm2Bbdp2V21JyIOoMgud1p7 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dth2rgf30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:39:52 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20PCK3oH007628;
        Tue, 25 Jan 2022 12:39:52 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dth2rgf1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:39:52 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20PCWKxY011423;
        Tue, 25 Jan 2022 12:39:50 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3dr96je31y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:39:49 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PCdkuW41157052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 12:39:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C427AE058;
        Tue, 25 Jan 2022 12:39:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F90DAE059;
        Tue, 25 Jan 2022 12:39:45 +0000 (GMT)
Received: from [9.171.58.95] (unknown [9.171.58.95])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jan 2022 12:39:45 +0000 (GMT)
Message-ID: <bb8f5da2-19d2-bf94-a2b4-f5b6f0f91995@linux.ibm.com>
Date:   Tue, 25 Jan 2022 13:41:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 19/30] KVM: s390: pci: provide routines for
 enabling/disabling interrupt forwarding
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
 <20220114203145.242984-20-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-20-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oP0Omze7txDfAZSgiv_LhcVOwylGaruv
X-Proofpoint-ORIG-GUID: MJmP7jYmdwQA9dkL3Pmloyp__ruAlOpw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_02,2022-01-25_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 clxscore=1015 spamscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> These routines will be wired into the vfio_pci_zdev ioctl handlers to
> respond to requests to enable / disable a device for Adapter Event
> Notifications / Adapter Interuption Forwarding.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_pci.h |   7 ++
>   arch/s390/kvm/pci.c             | 203 ++++++++++++++++++++++++++++++++
>   arch/s390/pci/pci_insn.c        |   1 +
>   3 files changed, 211 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> index 072401aa7922..01fe14fffd7a 100644
> --- a/arch/s390/include/asm/kvm_pci.h
> +++ b/arch/s390/include/asm/kvm_pci.h
> @@ -16,16 +16,23 @@
>   #include <linux/kvm_host.h>
>   #include <linux/kvm.h>
>   #include <linux/pci.h>
> +#include <asm/pci_insn.h>
>   
>   struct kvm_zdev {
>   	struct zpci_dev *zdev;
>   	struct kvm *kvm;
> +	struct zpci_fib fib;
>   };
>   
>   int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
>   void kvm_s390_pci_dev_release(struct zpci_dev *zdev);
>   void kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm);
>   
> +int kvm_s390_pci_aif_probe(struct zpci_dev *zdev);
> +int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, struct zpci_fib *fib,
> +			    bool assist);
> +int kvm_s390_pci_aif_disable(struct zpci_dev *zdev);
> +
>   int kvm_s390_pci_interp_probe(struct zpci_dev *zdev);
>   int kvm_s390_pci_interp_enable(struct zpci_dev *zdev);
>   int kvm_s390_pci_interp_disable(struct zpci_dev *zdev);
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index 122d0992b521..7ed9abc476b6 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -12,6 +12,7 @@
>   #include <asm/kvm_pci.h>
>   #include <asm/pci.h>
>   #include <asm/pci_insn.h>
> +#include <asm/pci_io.h>
>   #include <asm/sclp.h>
>   #include "pci.h"
>   #include "kvm-s390.h"
> @@ -145,6 +146,204 @@ int kvm_s390_pci_aen_init(u8 nisc)
>   	return rc;
>   }
>   
> +/* Modify PCI: Register floating adapter interruption forwarding */
> +static int kvm_zpci_set_airq(struct zpci_dev *zdev)
> +{
> +	u64 req = ZPCI_CREATE_REQ(zdev->fh, 0, ZPCI_MOD_FC_REG_INT);
> +	struct zpci_fib fib = {0};

I prefer {} instead of {0} even it does the same it looks wrong to me.

> +	u8 status;
> +
> +	fib.fmt0.isc = zdev->kzdev->fib.fmt0.isc;
> +	fib.fmt0.sum = 1;       /* enable summary notifications */
> +	fib.fmt0.noi = airq_iv_end(zdev->aibv);
> +	fib.fmt0.aibv = virt_to_phys(zdev->aibv->vector);
> +	fib.fmt0.aibvo = 0;
> +	fib.fmt0.aisb = virt_to_phys(aift->sbv->vector + (zdev->aisb / 64) * 8);
> +	fib.fmt0.aisbo = zdev->aisb & 63;
> +	fib.gd = zdev->gd;
> +
> +	return zpci_mod_fc(req, &fib, &status) ? -EIO : 0;
> +}
> +
> +/* Modify PCI: Unregister floating adapter interruption forwarding */
> +static int kvm_zpci_clear_airq(struct zpci_dev *zdev)
> +{
> +	u64 req = ZPCI_CREATE_REQ(zdev->fh, 0, ZPCI_MOD_FC_DEREG_INT);
> +	struct zpci_fib fib = {0};

same here

> +	u8 cc, status;
> +
> +	fib.gd = zdev->gd;
> +
> +	cc = zpci_mod_fc(req, &fib, &status);
> +	if (cc == 3 || (cc == 1 && status == 24))
> +		/* Function already gone or IRQs already deregistered. */
> +		cc = 0;
> +
> +	return cc ? -EIO : 0;
> +}
> +
> +int kvm_s390_pci_aif_probe(struct zpci_dev *zdev)
> +{
> +	/* Must have appropriate hardware facilities */
> +	if (!(sclp.has_aeni && test_facility(71)))
> +		return -EINVAL;
> +
> +	/* Must have a KVM association registered */
> +	if (!zdev->kzdev || !zdev->kzdev->kvm)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_aif_probe);
> +
> +int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, struct zpci_fib *fib,
> +			    bool assist)
> +{
> +	struct page *aibv_page, *aisb_page = NULL;
> +	unsigned int msi_vecs, idx;
> +	struct zpci_gaite *gaite;
> +	unsigned long bit;
> +	struct kvm *kvm;
> +	phys_addr_t gaddr;
> +	int rc = 0;
> +
> +	/*
> +	 * Interrupt forwarding is only applicable if the device is already
> +	 * enabled for interpretation
> +	 */
> +	if (zdev->gd == 0)
> +		return -EINVAL;
> +
> +	kvm = zdev->kzdev->kvm;
> +	msi_vecs = min_t(unsigned int, fib->fmt0.noi, zdev->max_msi);
> +
> +	/* Replace AIBV address */
> +	idx = srcu_read_lock(&kvm->srcu);
> +	aibv_page = gfn_to_page(kvm, gpa_to_gfn((gpa_t)fib->fmt0.aibv));
> +	srcu_read_unlock(&kvm->srcu, idx);
> +	if (is_error_page(aibv_page)) {
> +		rc = -EIO;
> +		goto out;
> +	}
> +	gaddr = page_to_phys(aibv_page) + (fib->fmt0.aibv & ~PAGE_MASK);
> +	fib->fmt0.aibv = gaddr;
> +
> +	/* Pin the guest AISB if one was specified */
> +	if (fib->fmt0.sum == 1) {
> +		idx = srcu_read_lock(&kvm->srcu);
> +		aisb_page = gfn_to_page(kvm, gpa_to_gfn((gpa_t)fib->fmt0.aisb));
> +		srcu_read_unlock(&kvm->srcu, idx);
> +		if (is_error_page(aisb_page)) {
> +			rc = -EIO;
> +			goto unpin1;
> +		}
> +	}
> +
> +	/* AISB must be allocated before we can fill in GAITE */
> +	mutex_lock(&aift->lock);
> +	bit = airq_iv_alloc_bit(aift->sbv);
> +	if (bit == -1UL)
> +		goto unpin2;
> +	zdev->aisb = bit;

aisb here is the aisb offset right?
Then may be add a comment as in gait and fmt0 aisb is an address.

> +	zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA |
> +					      AIRQ_IV_BITLOCK |
> +					      AIRQ_IV_GUESTVEC,
> +				    (unsigned long *)fib->fmt0.aibv);

phys_to_virt ?

> +
> +	spin_lock_irq(&aift->gait_lock);
> +	gaite = (struct zpci_gaite *)aift->gait + (zdev->aisb *
> +						   sizeof(struct zpci_gaite));
> +
> +	/* If assist not requested, host will get all alerts */
> +	if (assist)
> +		gaite->gisa = (u32)(u64)&kvm->arch.sie_page2->gisa;

virt_to_phys ?

> +	else
> +		gaite->gisa = 0;
> +
> +	gaite->gisc = fib->fmt0.isc;
> +	gaite->count++;
> +	gaite->aisbo = fib->fmt0.aisbo;
> +	gaite->aisb = virt_to_phys(page_address(aisb_page) + (fib->fmt0.aisb &
> +							      ~PAGE_MASK));
> +	aift->kzdev[zdev->aisb] = zdev->kzdev;
> +	spin_unlock_irq(&aift->gait_lock);
> +
> +	/* Update guest FIB for re-issue */
> +	fib->fmt0.aisbo = zdev->aisb & 63;
> +	fib->fmt0.aisb = virt_to_phys(aift->sbv->vector + (zdev->aisb / 64) * 8);
> +	fib->fmt0.isc = kvm_s390_gisc_register(kvm, gaite->gisc);
> +
> +	/* Save some guest fib values in the host for later use */
> +	zdev->kzdev->fib.fmt0.isc = fib->fmt0.isc;
> +	zdev->kzdev->fib.fmt0.aibv = fib->fmt0.aibv;
> +	mutex_unlock(&aift->lock);
> +
> +	/* Issue the clp to setup the irq now */
> +	rc = kvm_zpci_set_airq(zdev);
> +	return rc;
> +
> +unpin2:
> +	mutex_unlock(&aift->lock);
> +	if (fib->fmt0.sum == 1) {
> +		gaddr = page_to_phys(aisb_page);
> +		kvm_release_pfn_dirty(gaddr >> PAGE_SHIFT);
> +	}
> +unpin1:
> +	kvm_release_pfn_dirty(fib->fmt0.aibv >> PAGE_SHIFT);
> +out:
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_aif_enable);
> +
> +int kvm_s390_pci_aif_disable(struct zpci_dev *zdev)
> +{
> +	struct kvm_zdev *kzdev = zdev->kzdev;
> +	struct zpci_gaite *gaite;
> +	int rc;
> +	u8 isc;
> +
> +	if (zdev->gd == 0)
> +		return -EINVAL;
> +
> +	/* Even if the clear fails due to an error, clear the GAITE */
> +	rc = kvm_zpci_clear_airq(zdev);

Having a look at kvm_zpci_clear_airq() the only possible error seems to 
be when an error recovery is in progress.
The error returned for a wrong FH, function does not exist anymore, or 
if the interrupt vectors are already deregistered by the instruction are 
returned as success by the function.

How can we be sure that we have no conflict with a recovery in progress?
Shouldn't we in this case let the recovery process handle the function 
and stop here?

Doesn't the aif lock mutex placed after and not before the clear_irq 
open a door for race condition with the recovery?

> +
> +	mutex_lock(&aift->lock);
> +	if (zdev->kzdev->fib.fmt0.aibv == 0)
> +		goto out;
> +	spin_lock_irq(&aift->gait_lock);
> +	gaite = (struct zpci_gaite *)aift->gait + (zdev->aisb *
> +						   sizeof(struct zpci_gaite));
> +	isc = gaite->gisc;
> +	gaite->count--;
> +	if (gaite->count == 0) {
> +		/* Release guest AIBV and AISB */
> +		kvm_release_pfn_dirty(kzdev->fib.fmt0.aibv >> PAGE_SHIFT);
> +		if (gaite->aisb != 0)
> +			kvm_release_pfn_dirty(gaite->aisb >> PAGE_SHIFT);
> +		/* Clear the GAIT entry */
> +		gaite->aisb = 0;
> +		gaite->gisc = 0;
> +		gaite->aisbo = 0;
> +		gaite->gisa = 0;
> +		aift->kzdev[zdev->aisb] = 0;
> +		/* Clear zdev info */
> +		airq_iv_free_bit(aift->sbv, zdev->aisb);
> +		airq_iv_release(zdev->aibv);
> +		zdev->aisb = 0;
> +		zdev->aibv = NULL;
> +	}
> +	spin_unlock_irq(&aift->gait_lock);
> +	kvm_s390_gisc_unregister(kzdev->kvm, isc);

Don't we need to check the return value?
And maybe to report it to the caller?

> +	kzdev->fib.fmt0.isc = 0;
> +	kzdev->fib.fmt0.aibv = 0;
> +out:
> +	mutex_unlock(&aift->lock);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_aif_disable);
> +
>   int kvm_s390_pci_interp_probe(struct zpci_dev *zdev)
>   {
>   	/* Must have appropriate hardware facilities */
> @@ -221,6 +420,10 @@ int kvm_s390_pci_interp_disable(struct zpci_dev *zdev)
>   	if (zdev->gd == 0)
>   		return -EINVAL;
>   
> +	/* Forwarding must be turned off before interpretation */
> +	if (zdev->kzdev->fib.fmt0.aibv != 0)
> +		kvm_s390_pci_aif_disable(zdev);
> +
>   	/* Remove the host CLP guest designation */
>   	zdev->gd = 0;
>   
> diff --git a/arch/s390/pci/pci_insn.c b/arch/s390/pci/pci_insn.c
> index ca6399d52767..f7d0e29bbf0b 100644
> --- a/arch/s390/pci/pci_insn.c
> +++ b/arch/s390/pci/pci_insn.c
> @@ -59,6 +59,7 @@ u8 zpci_mod_fc(u64 req, struct zpci_fib *fib, u8 *status)
>   
>   	return cc;
>   }
> +EXPORT_SYMBOL_GPL(zpci_mod_fc);
>   
>   /* Refresh PCI Translations */
>   static inline u8 __rpcit(u64 fn, u64 addr, u64 range, u8 *status)
> 

-- 
Pierre Morel
IBM Lab Boeblingen
