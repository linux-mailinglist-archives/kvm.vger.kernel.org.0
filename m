Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54434AA9BC
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 19:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389390AbfIERJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 13:09:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55850 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732403AbfIERJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 13:09:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85H3tji168969;
        Thu, 5 Sep 2019 17:07:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=TFj6m5l1ONKxOpEbsJmE/2UNSnom/9p9C9uWukqia2o=;
 b=nCscRghQMASXQeAZgxSV2ZLBWeoUL7k9/YQ+5Or7S+h4NoVd2RBQYHQ3EzRwmRMiVioq
 ghWLHxwzcdivg3Dv2QGzet9ZE3rK+RXjdzvIv/sRhZa1AaK9ovLhIJfgmTqz0Mmzfnt3
 sD+IZA+iNDeVVNPOSwk6SC7jTTY++/SRx3cUsK02i+EBIdGcJiMMNgNsHOczhEBCp/pg
 MUTlv5x4RXaq6Z3WPDcLGgY3t4z8YOc7gkuNgLUus0P8Q17zxHtxnuserLdqo138hJnH
 gm08jSvtTgDE8eCS5emmT0wCm81XYfJPsmnVgDCmWdWj1AJAlgD1eO0V2yb4uSstBm3K TQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2uu66e03pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 17:07:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85H3jJs094501;
        Thu, 5 Sep 2019 17:07:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uthq1yb9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 17:07:17 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85H7DQV003379;
        Thu, 5 Sep 2019 17:07:13 GMT
Received: from [192.168.14.112] (/79.182.237.80)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 10:07:13 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v3] KVM: x86: Disable posted interrupts for odd IRQs
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190905125818.22395-1-graf@amazon.com>
Date:   Thu, 5 Sep 2019 20:07:07 +0300
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <867E8A7D-645B-45BE-A6C8-8D59C3D09C53@oracle.com>
References: <20190905125818.22395-1-graf@amazon.com>
To:     Alexander Graf <graf@amazon.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 5 Sep 2019, at 15:58, Alexander Graf <graf@amazon.com> wrote:
>=20
> We can easily route hardware interrupts directly into VM context when
> they target the "Fixed" or "LowPriority" delivery modes.
>=20
> However, on modes such as "SMI" or "Init", we need to go via KVM code
> to actually put the vCPU into a different mode of operation, so we can
> not post the interrupt
>=20
> Add code in the VMX and SVM PI logic to explicitly refuse to establish
> posted mappings for advanced IRQ deliver modes. This reflects the =
logic
> in __apic_accept_irq() which also only ever passes Fixed and =
LowPriority
> interrupts as posted interrupts into the guest.
>=20
> This fixes a bug I have with code which configures real hardware to
> inject virtual SMIs into my guest.
>=20
> Signed-off-by: Alexander Graf <graf@amazon.com>

Reviewed-by: Liran Alon <liran.alon@oracle.com>

>=20
> ---
>=20
> v1 -> v2:
>=20
>  - Make error message more unique
>  - Update commit message to point to __apic_accept_irq()
>=20
> v2 -> v3:
>=20
>  - Use if() rather than switch()
>  - Move abort logic into existing if() branch for broadcast irqs
>  -> remove the updated error message again (thus remove R-B tag from =
Liran)
>  - Fold VMX and SVM changes into single commit
>  - Combine postability check into helper function =
kvm_irq_is_postable()
> ---
> arch/x86/include/asm/kvm_host.h | 7 +++++++
> arch/x86/kvm/svm.c              | 4 +++-
> arch/x86/kvm/vmx/vmx.c          | 6 +++++-
> 3 files changed, 15 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h =
b/arch/x86/include/asm/kvm_host.h
> index 44a5ce57a905..5b14aa1fbeeb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1581,6 +1581,13 @@ bool kvm_intr_is_single_vcpu(struct kvm *kvm, =
struct kvm_lapic_irq *irq,
> void kvm_set_msi_irq(struct kvm *kvm, struct =
kvm_kernel_irq_routing_entry *e,
> 		     struct kvm_lapic_irq *irq);
>=20
> +static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
> +{
> +	/* We can only post Fixed and LowPrio IRQs */
> +	return (irq->delivery_mode =3D=3D dest_Fixed ||
> +		irq->delivery_mode =3D=3D dest_LowestPrio);
> +}
> +
> static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
> {
> 	if (kvm_x86_ops->vcpu_blocking)
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 1f220a85514f..f5b03d0c9bc6 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5260,7 +5260,8 @@ get_pi_vcpu_info(struct kvm *kvm, struct =
kvm_kernel_irq_routing_entry *e,
>=20
> 	kvm_set_msi_irq(kvm, e, &irq);
>=20
> -	if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu)) {
> +	if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
> +	    !kvm_irq_is_postable(&irq)) {
> 		pr_debug("SVM: %s: use legacy intr remap mode for irq =
%u\n",
> 			 __func__, irq.vector);
> 		return -1;
> @@ -5314,6 +5315,7 @@ static int svm_update_pi_irte(struct kvm *kvm, =
unsigned int host_irq,
> 		 * 1. When cannot target interrupt to a specific vcpu.
> 		 * 2. Unsetting posted interrupt.
> 		 * 3. APIC virtialization is disabled for the vcpu.
> +		 * 4. IRQ has incompatible delivery mode (SMI, INIT, =
etc)
> 		 */
> 		if (!get_pi_vcpu_info(kvm, e, &vcpu_info, &svm) && set =
&&
> 		    kvm_vcpu_apicv_active(&svm->vcpu)) {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 570a233e272b..63f3d88b36cc 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7382,10 +7382,14 @@ static int vmx_update_pi_irte(struct kvm *kvm, =
unsigned int host_irq,
> 		 * irqbalance to make the interrupts single-CPU.
> 		 *
> 		 * We will support full lowest-priority interrupt later.
> +		 *
> +		 * In addition, we can only inject generic interrupts =
using
> +		 * the PI mechanism, refuse to route others through it.
> 		 */
>=20
> 		kvm_set_msi_irq(kvm, e, &irq);
> -		if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu)) {
> +		if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
> +		    !kvm_irq_is_postable(&irq)) {
> 			/*
> 			 * Make sure the IRTE is in remapped mode if
> 			 * we don't handle it in posted mode.
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

