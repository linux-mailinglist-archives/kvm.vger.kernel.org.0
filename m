Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7726D473F57
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 10:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbhLNJZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 04:25:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7896 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230013AbhLNJZp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 04:25:45 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7QDmr026893;
        Tue, 14 Dec 2021 09:25:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QelSted19kdj/Jwfj1e65uMfJekZJldb5VswiaMjuHk=;
 b=PdugAfSnuH7qqMnTyOg9zee2kMGujEOa4TrGbdpXprosuyBu2UOniucoEStokQCtYa80
 En/+97SwUpqs2P47+MyGedMl7bWPiQoayaGDGtUcghe9M0xueihDhzyXyyUFYbRkQilO
 EjFHPgHreJyd2fV3j8bJw2M4/3LmKTs7woUZRX2SNj9Cr8QkpxPQlSfvteB5EqatRnlc
 +cJwDucsHtdHs8k9jHqXvf7lkRXyir+hXZPwycNNGNuZYpyxy97p4rLeqLuMeH8QuyyL
 SCUUfb7Qe/+VRWJeRaS0y60tjqjy45dxmM2nmkPf/sElxvCX5w36jdzH7p9f9hJkDpNm LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cx9rae21p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:25:44 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BE8kAgJ022963;
        Tue, 14 Dec 2021 09:25:44 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cx9rae218-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:25:44 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BE9ECjH031999;
        Tue, 14 Dec 2021 09:25:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3cvk8hvrf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:25:42 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BE9PdDF27459860
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 09:25:39 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF5E1A405B;
        Tue, 14 Dec 2021 09:25:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFD08A4065;
        Tue, 14 Dec 2021 09:25:37 +0000 (GMT)
Received: from [9.171.24.181] (unknown [9.171.24.181])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Dec 2021 09:25:37 +0000 (GMT)
Message-ID: <5392250d-fba1-51ca-a295-ade7d3de6c1e@linux.ibm.com>
Date:   Tue, 14 Dec 2021 10:26:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 21/32] KVM: s390: pci: provide routines for
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
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-22-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20211207205743.150299-22-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ErmeVYSruoojTMuCqQd7U0sPbOMgcFFx
X-Proofpoint-GUID: oGUkEvwSQshr6JfQcJcpbL97yGa5hCy7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_03,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112140052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/7/21 21:57, Matthew Rosato wrote:
> These routines will be wired into the vfio_pci_zdev ioctl handlers to
> respond to requests to enable / disable a device for Adapter Event
> Notifications / Adapter Interuption Forwarding.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_pci.h |   7 ++
>   arch/s390/kvm/pci.c             | 199 ++++++++++++++++++++++++++++++++
>   arch/s390/pci/pci_insn.c        |   1 +
>   3 files changed, 207 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> index 5d6283acb54c..54a0afdbe7d0 100644
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
>   extern int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
>   extern void kvm_s390_pci_dev_release(struct zpci_dev *zdev);
>   extern int kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm);
>   
> +extern int kvm_s390_pci_aif_probe(struct zpci_dev *zdev);
> +extern int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, struct zpci_fib *fib,
> +				   bool assist);
> +extern int kvm_s390_pci_aif_disable(struct zpci_dev *zdev);
> +

No need for extern in the prototype definition.


>   extern int kvm_s390_pci_interp_probe(struct zpci_dev *zdev);
>   extern int kvm_s390_pci_interp_enable(struct zpci_dev *zdev);
>   extern int kvm_s390_pci_interp_disable(struct zpci_dev *zdev);
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index 57cbe3827ea6..3a29398dd53b 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -10,6 +10,8 @@
>   #include <linux/kvm_host.h>
>   #include <linux/pci.h>
>   #include <asm/kvm_pci.h>
> +#include <asm/pci.h>
> +#include <asm/pci_insn.h>
>   #include <asm/sclp.h>
>   #include "pci.h"
>   #include "kvm-s390.h"
> @@ -120,6 +122,199 @@ int kvm_s390_pci_aen_init(u8 nisc)
>   	return rc;
>   }
>   
> +/* Modify PCI: Register floating adapter interruption forwarding */
> +static int kvm_zpci_set_airq(struct zpci_dev *zdev)
> +{
> +	u64 req = ZPCI_CREATE_REQ(zdev->fh, 0, ZPCI_MOD_FC_REG_INT);
> +	struct zpci_fib fib = {0};
> +	u8 status;
> +
> +	fib.fmt0.isc = zdev->kzdev->fib.fmt0.isc;
> +	fib.fmt0.sum = 1;       /* enable summary notifications */
> +	fib.fmt0.noi = airq_iv_end(zdev->aibv);
> +	fib.fmt0.aibv = (unsigned long) zdev->aibv->vector;

no blanc needed after cast

> +	fib.fmt0.aibvo = 0;
> +	fib.fmt0.aisb = (unsigned long) aift.sbv->vector + (zdev->aisb/64) * 8;

same here and blancs needed arround /

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
> +	if (!(sclp.has_aeni && test_facility(71)))
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
> +	void *gaddr;
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
> +	gaddr = page_to_virt(aibv_page) + (fib->fmt0.aibv & ~PAGE_MASK);
> +	fib->fmt0.aibv = (u64)gaddr;
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
> +	mutex_lock(&aift.lock);
> +	bit = airq_iv_alloc_bit(aift.sbv);
> +	if (bit == -1UL)
> +		goto unpin2;
> +	zdev->aisb = bit;
> +	zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA |
> +					      AIRQ_IV_BITLOCK |
> +					      AIRQ_IV_GUESTVEC,
> +				    (unsigned long *)fib->fmt0.aibv);
> +
> +	spin_lock_irq(&aift.gait_lock);
> +	gaite = (struct zpci_gaite *) aift.gait + (zdev->aisb *
no blanc after cast

> +						   sizeof(struct zpci_gaite));
> +
> +	/* If assist not requested, host will get all alerts */
> +	if (assist)
> +		gaite->gisa = (u32)(u64)&kvm->arch.sie_page2->gisa;
> +	else
> +		gaite->gisa = 0;
> +
> +	gaite->gisc = fib->fmt0.isc;
> +	gaite->count++;
> +	gaite->aisbo = fib->fmt0.aisbo;
> +	gaite->aisb = (u64)(page_address(aisb_page) + (fib->fmt0.aisb &
> +						       ~PAGE_MASK));
> +	aift.kzdev[zdev->aisb] = zdev->kzdev;
> +	spin_unlock_irq(&aift.gait_lock);
> +
> +	/* Update guest FIB for re-issue */
> +	fib->fmt0.aisbo = zdev->aisb & 63;
> +	fib->fmt0.aisb = (unsigned long) aift.sbv->vector + (zdev->aisb/64)*8;

no blanc after cast and blanc arround / and *

> +	fib->fmt0.isc = kvm_s390_gisc_register(kvm, gaite->gisc);
> +
> +	/* Save some guest fib values in the host for later use */
> +	zdev->kzdev->fib.fmt0.isc = fib->fmt0.isc;
> +	zdev->kzdev->fib.fmt0.aibv = fib->fmt0.aibv;
> +	mutex_unlock(&aift.lock);
> +
> +	/* Issue the clp to setup the irq now */
> +	rc = kvm_zpci_set_airq(zdev);
> +	return rc;
> +
> +unpin2:
> +	mutex_unlock(&aift.lock);
> +	if (fib->fmt0.sum == 1) {
> +		gaddr = page_to_virt(aisb_page);
> +		kvm_release_pfn_dirty((u64)gaddr >> PAGE_SHIFT);
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
> +
> +	mutex_lock(&aift.lock);
> +	if (zdev->kzdev->fib.fmt0.aibv == 0)
> +		goto out;
> +	spin_lock_irq(&aift.gait_lock);
> +	gaite = (struct zpci_gaite *) aift.gait + (zdev->aisb *
dito cast
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
> +		aift.kzdev[zdev->aisb] = 0;
> +		/* Clear zdev info */
> +		airq_iv_free_bit(aift.sbv, zdev->aisb);
> +		airq_iv_release(zdev->aibv);
> +		zdev->aisb = 0;
> +		zdev->aibv = NULL;
> +	}
> +	spin_unlock_irq(&aift.gait_lock);
> +	kvm_s390_gisc_unregister(kzdev->kvm, isc);
> +	kzdev->fib.fmt0.isc = 0;
> +	kzdev->fib.fmt0.aibv = 0;
> +out:
> +	mutex_unlock(&aift.lock);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_aif_disable);
> +
>   int kvm_s390_pci_interp_probe(struct zpci_dev *zdev)
>   {
>   	if (!(sclp.has_zpci_interp && test_facility(69)))
> @@ -188,6 +383,10 @@ int kvm_s390_pci_interp_disable(struct zpci_dev *zdev)
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
> index 0d1ab268ec24..b57d3f594113 100644
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
