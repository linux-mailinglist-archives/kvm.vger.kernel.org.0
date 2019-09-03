Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A16D4A778A
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 01:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfICXXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 19:23:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60478 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727312AbfICXXz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 19:23:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83NJ1Vl190771;
        Tue, 3 Sep 2019 23:22:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=UJw1Y7uj9g+SZ5DNCrU6LVe85QHvYGaiIqcF/IakMzU=;
 b=EIQPFezCGZombwumJIllsao9P3vulQ05xy4KvTAHKiCCFloSPNeEKHi5OlHoGrv1KywI
 oEjbyHmiYhG44mYXPnuwylFQ1PzN52amHke/Zqanyf1DeLJs33cQ6c6sQsWUJi6B0oRQ
 Drv2yt+TAm6pTYcek0KfqBPYO68mTLgiaot870Q9pRx0VwCHt2BXwhNyJPg/ILYlstTz
 dHS9ipoRL3q3zFEds5pVEeot46kL4vk7FwkCLqaVvmtonqeSjWLha6eU2qfLzqTt5vVV
 3oHXFMY1QDUKJMIrPl8SG4xS0YyxidZue22yDHP8mmwjkwJPZQoA39+sbrFauYHxrsKK zA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2ut1qf80je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 23:22:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83NJNdf003211;
        Tue, 3 Sep 2019 23:20:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2us5phdxgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 23:20:19 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x83NKGsT015382;
        Tue, 3 Sep 2019 23:20:16 GMT
Received: from [192.168.14.112] (/79.176.230.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 16:20:16 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 2/2] KVM: SVM: Disable posted interrupts for odd IRQs
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190903142954.3429-3-graf@amazon.com>
Date:   Wed, 4 Sep 2019 02:20:08 +0300
Cc:     kvm list <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7AEDDBE7-138A-455F-957C-C2DE64BD8B06@oracle.com>
References: <20190903142954.3429-1-graf@amazon.com>
 <20190903142954.3429-3-graf@amazon.com>
To:     Alexander Graf <graf@amazon.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030234
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 3 Sep 2019, at 17:29, Alexander Graf <graf@amazon.com> wrote:
>=20
> We can easily route hardware interrupts directly into VM context when
> they target the "Fixed" or "LowPriority" delivery modes.
>=20
> However, on modes such as "SMI" or "Init", we need to go via KVM code
> to actually put the vCPU into a different mode of operation, so we can
> not post the interrupt
>=20
> Add code in the SVM PI logic to explicitly refuse to establish posted
> mappings for advanced IRQ deliver modes.
>=20
> This fixes a bug I have with code which configures real hardware to
> inject virtual SMIs into my guest.
>=20
> Signed-off-by: Alexander Graf <graf@amazon.com>

Nit: I prefer to squash both commits into one that change both VMX & =
SVM.
As it=E2=80=99s exactly the same change.

> ---
> arch/x86/kvm/svm.c | 16 ++++++++++++++++
> 1 file changed, 16 insertions(+)
>=20
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 1f220a85514f..9a6ea78c3239 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5266,6 +5266,21 @@ get_pi_vcpu_info(struct kvm *kvm, struct =
kvm_kernel_irq_routing_entry *e,
> 		return -1;
> 	}
>=20
> +	switch (irq.delivery_mode) {
> +	case dest_Fixed:
> +	case dest_LowestPrio:
> +		break;
> +	default:
> +		/*
> +		 * For non-trivial interrupt events, we need to go
> +		 * through the full KVM IRQ code, so refuse to take
> +		 * any direct PI assignments here.
> +		 */
> +		pr_debug("SVM: %s: use legacy intr remap mode for irq =
%u\n",
> +			 __func__, irq.vector);
> +		return -1;
> +	}
> +

Prefer changing printed string to something different than the =
!kvm_intr_is_single_vcpu() case.
To assist debugging.

Having said that,
Reviewed-by: Liran Alon <liran.alon@oracle.com>

-Liran

> 	pr_debug("SVM: %s: use GA mode for irq %u\n", __func__,
> 		 irq.vector);
> 	*svm =3D to_svm(vcpu);
> @@ -5314,6 +5329,7 @@ static int svm_update_pi_irte(struct kvm *kvm, =
unsigned int host_irq,
> 		 * 1. When cannot target interrupt to a specific vcpu.
> 		 * 2. Unsetting posted interrupt.
> 		 * 3. APIC virtialization is disabled for the vcpu.
> +		 * 4. IRQ has extended delivery mode (SMI, INIT, etc)
> 		 */
> 		if (!get_pi_vcpu_info(kvm, e, &vcpu_info, &svm) && set =
&&
> 		    kvm_vcpu_apicv_active(&svm->vcpu)) {
> --=20
> 2.17.1
>=20
>=20
>=20
>=20
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
>=20
>=20
>=20

