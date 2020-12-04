Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448DC2CF66D
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 22:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgLDVzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 16:55:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28710 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725933AbgLDVzD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 16:55:03 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4Lh9rj180814;
        Fri, 4 Dec 2020 16:54:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=hkG/6yTFISThyBoLmsLxNYz65p9USehDQ4JZTauElTc=;
 b=VTTN9QxC+GAe9Yg7NuzSIFTZ8tGyJeo/LgfBS72jhjRjZIzVVzQZnZN/8jo5KMEuDqC0
 UoYe8lOTT1TW4IQX12Fgg2oePbtAX0G3e2O8mjuPzsLUoVjMXjwbb8YAyvhnMTMaH7eI
 fhP5pmrKfVaxYz8sWWgQD/I0jmbMlxb7NVT44vOGIWhE2pXPgDybwCRWPeBK5S+U3r7K
 28eV816c6AafGnw4jhySsnChsOHUTkKEueTRzqqX0NOeuc9ZLplPOy1MaCynZ4C+AEka
 Zm51GV3ZJoBB4mvPcuqZDisYhav4cvygeZcehkDfufUTiKC1iUNDKgfCqecGLZ/9SkZ+ Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 357sdk6hpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 16:54:21 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B4Li3mn183337;
        Fri, 4 Dec 2020 16:54:20 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 357sdk6hnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 16:54:20 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B4LWg21023963;
        Fri, 4 Dec 2020 21:54:18 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3573v9s5rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 21:54:18 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B4LsFLp55247358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Dec 2020 21:54:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0170A4054;
        Fri,  4 Dec 2020 21:54:15 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BA82A405C;
        Fri,  4 Dec 2020 21:54:15 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.41.218])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri,  4 Dec 2020 21:54:15 +0000 (GMT)
Date:   Fri, 4 Dec 2020 22:54:13 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com, david@redhat.com,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH] s390/vfio-ap: Clean up vfio_ap resources when KVM
 pointer invalidated
Message-ID: <20201204225413.2d91cf9f.pasic@linux.ibm.com>
In-Reply-To: <cf2c6632-bcdc-fb93-471b-bfd834d87902@linux.ibm.com>
References: <20201202234101.32169-1-akrowiak@linux.ibm.com>
 <20201203185514.54060568.pasic@linux.ibm.com>
 <a8a90aed-97df-6f10-85c2-8e18dba8f085@linux.ibm.com>
 <20201204200502.1c34ae58.pasic@linux.ibm.com>
 <cf2c6632-bcdc-fb93-471b-bfd834d87902@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_09:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0
 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Dec 2020 14:46:30 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 12/4/20 2:05 PM, Halil Pasic wrote:
> > On Fri, 4 Dec 2020 09:43:59 -0500
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >>>> +{
> >>>> +	if (matrix_mdev->kvm) {
> >>>> +		(matrix_mdev->kvm);
> >>>> +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;  
> >>> Is a plain assignment to arch.crypto.pqap_hook apropriate, or do we need
> >>> to take more care?
> >>>
> >>> For instance kvm_arch_crypto_set_masks() takes kvm->lock before poking
> >>> kvm->arch.crypto.crycb.  
> >> I do not think so. The CRYCB is used by KVM to provide crypto resources
> >> to the guest so it makes sense to protect it from changes to it while
> >> passing
> >> the AP devices through to the guest. The hook is used only when an AQIC
> >> executed on the guest is intercepted by KVM. If the notifier
> >> is being invoked to notify vfio_ap that KVM has been set to NULL, this means
> >> the guest is gone in which case there will be no AP instructions to
> >> intercept.  
> > If the update to pqap_hook isn't observed as atomic we still have a
> > problem. With torn writes or reads we would try to use a corrupt function
> > pointer. While the compiler probably ain't likely to generate silly code
> > for the above assignment (multiple write instructions less then
> > quadword wide), I know of nothing that would prohibit the compiler to do
> > so.  
> 
> I see that in the handle_pqap() function in arch/s390/kvm/priv.c
> that gets called when the AQIC instruction is intercepted,
> the pqap_hook is protected by locking the owner of the hook:
> 
>          if (!try_module_get(vcpu->kvm->arch.crypto.pqap_hook->owner))
>              return -EOPNOTSUPP;
>          ret = vcpu->kvm->arch.crypto.pqap_hook->hook(vcpu);
> module_put(vcpu->kvm->arch.crypto.pqap_hook->owner);
> 
> Maybe that is what we should do when the kvm->arch.crypto.pqap_hook
> is set to NULL?

To my best knowledge that ain't no locking but mere refcounting. The
purpose of that is probably to prevent the owner module, and the code
pointed to by the 'hook' function pointer from being unloaded while we
are executing that very same code.

Why is that necessary, frankly I have no idea. We do tend to invalidate
the callback before doing our module_put in vfio_ap_mdev_release(). Maybe
the case you are handling right now is the reason (because the
callback is invalidated in vfio_ap_mdev_release() only if !!kvm.

Regards,
Halil

