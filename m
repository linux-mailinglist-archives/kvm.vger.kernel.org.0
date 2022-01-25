Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D8649B7E6
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 16:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1582345AbiAYPrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 10:47:07 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38886 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1582206AbiAYPo5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 10:44:57 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PFhY19021268;
        Tue, 25 Jan 2022 15:44:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jD7GIfSyzhnaFc7lMUjvEyCyojhbAjefpbKME+pOOY4=;
 b=oilBtDlQS19lJmYjsxH6RusvgvAXgKgbfd11iIws3s5RAHqsgfmNiOg5RRgTh/Ab5jCJ
 6gRHl+L6x6F/N+N+HEuG+eIUmlURZRm4O541nlHNF+z+I4ULKvRHlLPgLxtW+qaOG2gB
 /L4QWUJJCr67XkZtiXFxawmh7EaTEr70jd54ufZdpDPBUIgo02FYe6vMUmNoqkRnX8eO
 Ex2CyQd3bKRNpIS96h0CpjD8L4Vm8UnUOi37aKcK6XbI3Q4IQCAaDNMFKMopOZLF8XwN
 NPJVTKHbJ5ZRe8BxRurO9nGHP9Gxc5c9T6rUhhXj+pHykXjXGRqCp0ovxk3NWKUcqJ59 cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dtm3jr0mm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 15:44:54 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20PFiR0T023346;
        Tue, 25 Jan 2022 15:44:54 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dtm3jr0m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 15:44:54 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20PFhZs2005537;
        Tue, 25 Jan 2022 15:44:53 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 3dr9jaweeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 15:44:53 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PFiju331523240
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 15:44:45 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF7F4C6063;
        Tue, 25 Jan 2022 15:44:45 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7E1DC605A;
        Tue, 25 Jan 2022 15:44:43 +0000 (GMT)
Received: from [9.163.21.206] (unknown [9.163.21.206])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jan 2022 15:44:43 +0000 (GMT)
Message-ID: <145c27e6-75e6-b94b-18d8-237de8cade9d@linux.ibm.com>
Date:   Tue, 25 Jan 2022 10:44:43 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 19/30] KVM: s390: pci: provide routines for
 enabling/disabling interrupt forwarding
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
 <20220114203145.242984-20-mjrosato@linux.ibm.com>
 <bb8f5da2-19d2-bf94-a2b4-f5b6f0f91995@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <bb8f5da2-19d2-bf94-a2b4-f5b6f0f91995@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _RotL5ur243KCiUMSN_uAyEp8BSStNV-
X-Proofpoint-GUID: 0q8la1QscCkY2qep56zIYrbMNCFYmJNX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_03,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 clxscore=1015 adultscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250100
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 7:41 AM, Pierre Morel wrote:
> 
> 
> On 1/14/22 21:31, Matthew Rosato wrote:
...
>> +/* Modify PCI: Register floating adapter interruption forwarding */
>> +static int kvm_zpci_set_airq(struct zpci_dev *zdev)
>> +{
>> +    u64 req = ZPCI_CREATE_REQ(zdev->fh, 0, ZPCI_MOD_FC_REG_INT);
>> +    struct zpci_fib fib = {0};
> 
> I prefer {} instead of {0} even it does the same it looks wrong to me.
>

OK

...

>> +int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, struct zpci_fib *fib,
>> +                bool assist)
>> +{
>> +    struct page *aibv_page, *aisb_page = NULL;
>> +    unsigned int msi_vecs, idx;
>> +    struct zpci_gaite *gaite;
>> +    unsigned long bit;
>> +    struct kvm *kvm;
>> +    phys_addr_t gaddr;
>> +    int rc = 0;
>> +
>> +    /*
>> +     * Interrupt forwarding is only applicable if the device is already
>> +     * enabled for interpretation
>> +     */
>> +    if (zdev->gd == 0)
>> +        return -EINVAL;
>> +
>> +    kvm = zdev->kzdev->kvm;
>> +    msi_vecs = min_t(unsigned int, fib->fmt0.noi, zdev->max_msi);
>> +
>> +    /* Replace AIBV address */
>> +    idx = srcu_read_lock(&kvm->srcu);
>> +    aibv_page = gfn_to_page(kvm, gpa_to_gfn((gpa_t)fib->fmt0.aibv));
>> +    srcu_read_unlock(&kvm->srcu, idx);
>> +    if (is_error_page(aibv_page)) {
>> +        rc = -EIO;
>> +        goto out;
>> +    }
>> +    gaddr = page_to_phys(aibv_page) + (fib->fmt0.aibv & ~PAGE_MASK);
>> +    fib->fmt0.aibv = gaddr;
>> +
>> +    /* Pin the guest AISB if one was specified */
>> +    if (fib->fmt0.sum == 1) {
>> +        idx = srcu_read_lock(&kvm->srcu);
>> +        aisb_page = gfn_to_page(kvm, gpa_to_gfn((gpa_t)fib->fmt0.aisb));
>> +        srcu_read_unlock(&kvm->srcu, idx);
>> +        if (is_error_page(aisb_page)) {
>> +            rc = -EIO;
>> +            goto unpin1;
>> +        }
>> +    }
>> +
>> +    /* AISB must be allocated before we can fill in GAITE */
>> +    mutex_lock(&aift->lock);
>> +    bit = airq_iv_alloc_bit(aift->sbv);
>> +    if (bit == -1UL)
>> +        goto unpin2;
>> +    zdev->aisb = bit;
> 
> aisb here is the aisb offset right?

Yes

> Then may be add a comment as in gait and fmt0 aisb is an address.

Sure, good point

> 
>> +    zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA |
>> +                          AIRQ_IV_BITLOCK |
>> +                          AIRQ_IV_GUESTVEC,
>> +                    (unsigned long *)fib->fmt0.aibv);
> 
> phys_to_virt ?

Ugh, yep -- we just put the physical address in fib->fmt0.aibv a few 
lines earlier via page_to_phys

> 
>> +
>> +    spin_lock_irq(&aift->gait_lock);
>> +    gaite = (struct zpci_gaite *)aift->gait + (zdev->aisb *
>> +                           sizeof(struct zpci_gaite));
>> +
>> +    /* If assist not requested, host will get all alerts */
>> +    if (assist)
>> +        gaite->gisa = (u32)(u64)&kvm->arch.sie_page2->gisa;
> 
> virt_to_phys ?

Yes

> 
>> +    else
>> +        gaite->gisa = 0;
>> +
>> +    gaite->gisc = fib->fmt0.isc;
>> +    gaite->count++;
>> +    gaite->aisbo = fib->fmt0.aisbo;
>> +    gaite->aisb = virt_to_phys(page_address(aisb_page) + 
>> (fib->fmt0.aisb &
>> +                                  ~PAGE_MASK));
>> +    aift->kzdev[zdev->aisb] = zdev->kzdev;
>> +    spin_unlock_irq(&aift->gait_lock);
>> +
>> +    /* Update guest FIB for re-issue */
>> +    fib->fmt0.aisbo = zdev->aisb & 63;
>> +    fib->fmt0.aisb = virt_to_phys(aift->sbv->vector + (zdev->aisb / 
>> 64) * 8);
>> +    fib->fmt0.isc = kvm_s390_gisc_register(kvm, gaite->gisc);
>> +
>> +    /* Save some guest fib values in the host for later use */
>> +    zdev->kzdev->fib.fmt0.isc = fib->fmt0.isc;
>> +    zdev->kzdev->fib.fmt0.aibv = fib->fmt0.aibv;
>> +    mutex_unlock(&aift->lock);
>> +
>> +    /* Issue the clp to setup the irq now */
>> +    rc = kvm_zpci_set_airq(zdev);
>> +    return rc;
>> +
>> +unpin2:
>> +    mutex_unlock(&aift->lock);
>> +    if (fib->fmt0.sum == 1) {
>> +        gaddr = page_to_phys(aisb_page);
>> +        kvm_release_pfn_dirty(gaddr >> PAGE_SHIFT);
>> +    }
>> +unpin1:
>> +    kvm_release_pfn_dirty(fib->fmt0.aibv >> PAGE_SHIFT);
>> +out:
>> +    return rc;
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_s390_pci_aif_enable);
>> +
>> +int kvm_s390_pci_aif_disable(struct zpci_dev *zdev)
>> +{
>> +    struct kvm_zdev *kzdev = zdev->kzdev;
>> +    struct zpci_gaite *gaite;
>> +    int rc;
>> +    u8 isc;
>> +
>> +    if (zdev->gd == 0)
>> +        return -EINVAL;
>> +
>> +    /* Even if the clear fails due to an error, clear the GAITE */
>> +    rc = kvm_zpci_clear_airq(zdev);
> 
> Having a look at kvm_zpci_clear_airq() the only possible error seems to 
> be when an error recovery is in progress.
> The error returned for a wrong FH, function does not exist anymore, or 
> if the interrupt vectors are already deregistered by the instruction are 
> returned as success by the function.
> 
> How can we be sure that we have no conflict with a recovery in progress?
> Shouldn't we in this case let the recovery process handle the function 
> and stop here?

Hmm -- So I think for a userspace-initiated call to this routine, yes. 
We could then assume recovery takes care of things.  However, we also 
call this routine from vfio-pci core when closing the device...

So then let's look at how this would work -- the current recovery action 
for passthrough is always PCI_ERS_RESULT_DISCONNECT.  The process of 
disconnecting the device will trigger vfio-pci to close it's device, 
which in turn will trigger vfio_pci_zdev_release() which will in turn 
also call kvm_390_aif_disable as part of cleanup.  However, in this case 
now we want to clear the GAITE anyway even if kvm_zpci_clear_airq(zdev) 
fails now because we know the device is for sure going away.

I think I need some sort of input to this routine that indicates we must 
cleanup (bool force or something) which would only be specified by the 
call from vfio_pci_zdev_release().

> 
> Doesn't the aif lock mutex placed after and not before the clear_irq 
> open a door for race condition with the recovery?

Good point.

> 
>> +
>> +    mutex_lock(&aift->lock);
>> +    if (zdev->kzdev->fib.fmt0.aibv == 0)
>> +        goto out;
>> +    spin_lock_irq(&aift->gait_lock);
>> +    gaite = (struct zpci_gaite *)aift->gait + (zdev->aisb *
>> +                           sizeof(struct zpci_gaite));
>> +    isc = gaite->gisc;
>> +    gaite->count--;
>> +    if (gaite->count == 0) {
>> +        /* Release guest AIBV and AISB */
>> +        kvm_release_pfn_dirty(kzdev->fib.fmt0.aibv >> PAGE_SHIFT);
>> +        if (gaite->aisb != 0)
>> +            kvm_release_pfn_dirty(gaite->aisb >> PAGE_SHIFT);
>> +        /* Clear the GAIT entry */
>> +        gaite->aisb = 0;
>> +        gaite->gisc = 0;
>> +        gaite->aisbo = 0;
>> +        gaite->gisa = 0;
>> +        aift->kzdev[zdev->aisb] = 0;
>> +        /* Clear zdev info */
>> +        airq_iv_free_bit(aift->sbv, zdev->aisb);
>> +        airq_iv_release(zdev->aibv);
>> +        zdev->aisb = 0;
>> +        zdev->aibv = NULL;
>> +    }
>> +    spin_unlock_irq(&aift->gait_lock);
>> +    kvm_s390_gisc_unregister(kzdev->kvm, isc);
> 
> Don't we need to check the return value?
> And maybe to report it to the caller?

Well, actually, I think we really need to look at the 
kvm_s390_gisc_register() call during aif_enable -- I unconditionally 
assigned it to the fib when in fact it can also return a negative error 
value (which I never check for) -- so I will re-arrange the code in 
aif_enable() to do that earlier using a local variable and leave on 
error in aif_enable if this fails.

kvm_s390_gisc_register() returns 2 possible errors, which are shared 
with gisc_unregister -- So with that change we will detect these errors 
(not using GISA, bad guest ISC) at aif_enable time.

So then for gisc_unregister we should really only possibly hit the 3rd 
error (guest ISC is not registered).  And if for some reason we hit that 
error at disable time, well, that's weird and unexpected (s390dbf?) but 
as far as userspace is concerned the GAITE is cleared and the gisc is 
unregistered, so I think we want to return success still to userspace. 
But we must do the checking at gisc_register() time and fail for the 
other cases there.
