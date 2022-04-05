Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3C04F499A
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443040AbiDEWUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390892AbiDEPca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 11:32:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC45C488B8;
        Tue,  5 Apr 2022 06:39:29 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235DWbbo008443;
        Tue, 5 Apr 2022 13:39:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=JvygiKjUfCw1Vn4t2zTnFCbaEK5qIilq0QC8bPCPk30=;
 b=IqwyA8d5JzordcQWweo6LI5fAsrCxJWQirbID8hYioC2F3oCnsFaorX6W35RoY9mInZ0
 O7B2Dvb/jH0gyy4gIiV4Vb8XYgMc4y/hYRD3rd5QnG8nrHgZy9iqP0lICJ6zk3GCtRly
 xN2jOtVuBIXWLeZg+4rHSse9l+Rn56AQfnC/kBZPDqyHtul1TwFAMFHDGv1y9ofRFMoa
 kuqI+hdR3eBNK32M7DvHDXbNBDPwhfnQR90p92fDEokFMCrY4iQEkP5KHDi+1cxy8Nbv
 uSrOFkcoaUmXtBJmULfHtLZB4YQR76tHV9kKiY2KAuomaIy/m6V1v2GouhT/MhW1wy9B UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f6yuq44kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 13:39:27 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 235Dc37I031954;
        Tue, 5 Apr 2022 13:39:27 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f6yuq44jq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 13:39:27 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 235DX69q012527;
        Tue, 5 Apr 2022 13:39:24 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3f6drhmuge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 13:39:24 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 235DdLEN45023516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 13:39:21 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1CD05204F;
        Tue,  5 Apr 2022 13:39:20 +0000 (GMT)
Received: from sig-9-145-21-185.uk.ibm.com (unknown [9.145.21.185])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9AE1F5204E;
        Tue,  5 Apr 2022 13:39:19 +0000 (GMT)
Message-ID: <9a551f04c3878ecb3a26fed6aff2834fbfe41f18.camel@linux.ibm.com>
Subject: Re: [PATCH v5 14/21] KVM: s390: pci: provide routines for
 enabling/disabling interrupt forwarding
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Date:   Tue, 05 Apr 2022 15:39:19 +0200
In-Reply-To: <20220404174349.58530-15-mjrosato@linux.ibm.com>
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
         <20220404174349.58530-15-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QycQEkVhsxMxrsnlMPWXxtZ8LmJBc-4E
X-Proofpoint-ORIG-GUID: wWBGp5ydGUmV22wXetM4AMt5bdToFO4P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-05_02,2022-04-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 phishscore=0 adultscore=0 clxscore=1015 mlxlogscore=954 lowpriorityscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204050079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-04-04 at 13:43 -0400, Matthew Rosato wrote:
> These routines will be wired into a kvm ioctl in order to respond to
> requests to enable / disable a device for Adapter Event Notifications /
> Adapter Interuption Forwarding.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  arch/s390/kvm/pci.c      | 247 +++++++++++++++++++++++++++++++++++++++
>  arch/s390/kvm/pci.h      |   1 +
>  arch/s390/pci/pci_insn.c |   1 +
>  3 files changed, 249 insertions(+)
> 
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index 01bd8a2f503b..f0fd68569a9d 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -11,6 +11,7 @@
>  #include <linux/pci.h>
>  #include <asm/pci.h>
>  #include <asm/pci_insn.h>
> +#include <asm/pci_io.h>
>  #include "pci.h"
>  
>  struct zpci_aift *aift;
> @@ -152,6 +153,252 @@ int kvm_s390_pci_aen_init(u8 nisc)
>  	return rc;
>  }
>  
> +/* Modify PCI: Register floating adapter interruption forwarding */
> +static int kvm_zpci_set_airq(struct zpci_dev *zdev)
> +{
> +	u64 req = ZPCI_CREATE_REQ(zdev->fh, 0, ZPCI_MOD_FC_REG_INT);
> +	struct zpci_fib fib = {};

Hmm this one uses '{}' as initializer while all current callers of
zpci_mod_fc() use '{0}'. As far as I know the empty braces are a GNU
extension so should work for the kernel but for consistency I'd go with
'{0}' or possibly '{.foo = bar, ...}' where that is more readable.
There too uninitialized fields will be set to 0. Unless of course there
is a conflicting KVM convention that I don't know about.

> +	u8 status;
> +
> +	fib.fmt0.isc = zdev->kzdev->fib.fmt0.isc;
> +	fib.fmt0.sum = 1;       /* enable summary notifications */
> +	fib.fmt0.noi = airq_iv_end(zdev->aibv);
> +	fib.fmt0.aibv = virt_to_phys(zdev->aibv->vector);
> +	fib.fmt0.aibvo = 0;
> +	fib.fmt0.aisb = virt_to_phys(aift->sbv->vector + (zdev->aisb / 64) * 8);
> +	fib.fmt0.aisbo = zdev->aisb & 63;
> +	fib.gd = zdev->gisa;
> +
> +	return zpci_mod_fc(req, &fib, &status) ? -EIO : 0;
> +}
> +
> +/* Modify PCI: Unregister floating adapter interruption forwarding */
> +static int kvm_zpci_clear_airq(struct zpci_dev *zdev)
> +{
> +	u64 req = ZPCI_CREATE_REQ(zdev->fh, 0, ZPCI_MOD_FC_DEREG_INT);
> +	struct zpci_fib fib = {};

Same here

> +	u8 cc, status;
> +
> +	fib.gd = zdev->gisa;
> +
> +	cc = zpci_mod_fc(req, &fib, &status);
> +	if (cc == 3 || (cc == 1 && status == 24))
> +		/* Function already gone or IRQs already deregistered. */
> +		cc = 0;
> +
> +	return cc ? -EIO : 0;
> +}
> +
> 
---8<---
>  int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
>  {
>  	struct kvm_zdev *kzdev;
> diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
> index d4997e2236ef..b4bf3d1d4b66 100644
> --- a/arch/s390/kvm/pci.h
> +++ b/arch/s390/kvm/pci.h
> @@ -20,6 +20,7 @@
>  struct kvm_zdev {
>  	struct zpci_dev *zdev;
>  	struct kvm *kvm;
> +	struct zpci_fib fib;
>  };
>  
>  struct zpci_gaite {
> diff --git a/arch/s390/pci/pci_insn.c b/arch/s390/pci/pci_insn.c
> index 4c6967b73932..cd9fb186a6be 100644
> --- a/arch/s390/pci/pci_insn.c
> +++ b/arch/s390/pci/pci_insn.c
> @@ -60,6 +60,7 @@ u8 zpci_mod_fc(u64 req, struct zpci_fib *fib, u8 *status)
>  
>  	return cc;
>  }
> +EXPORT_SYMBOL_GPL(zpci_mod_fc);
>  
>  /* Refresh PCI Translations */
>  static inline u8 __rpcit(u64 fn, u64 addr, u64 range, u8 *status)

Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>


