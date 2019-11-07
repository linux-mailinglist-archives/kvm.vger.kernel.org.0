Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCD2BF3BE1
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 00:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfKGXAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 18:00:25 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35716 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfKGXAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 18:00:25 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7MxKdQ100029;
        Thu, 7 Nov 2019 23:00:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=hMvj+hVqyNGxyYN2WyHAKwugyrY8ExM4MJfq1cNFtyo=;
 b=dCVhpfJnF2V+KrWOtZ4tVfjp8zPTRF/uA8/Dojxx2dkA+rFxBwKfFqSMo0WL4XgoVFbu
 l04Y4qqqnUCuzR/Puw1s3/E/Eqa7PUO9om5lDJLK/SyF2x9IcYOw9uPZSAaTAWO2JmkJ
 MAm7xPbhWPnZJUkRkV5vh+f0RD/XJnv/2GmMrKDp8dVcgrIOEcq1K5EOMQr/nS97+yx6
 +zkznNJU4VsM5NZeHgLEoUX8BEYEw21b4Bn+6zD2+D2weXDpE53Rf6Xxo9h36P3TCA6A
 rBrTXpuWKEY1sQtuV5htEBM4wtu2M3/2COoqWGdGOPuk8mhm2lk5eab6XF4IzrK350jG pA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w41w19jhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 23:00:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7MxNR4097318;
        Thu, 7 Nov 2019 23:00:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2w41wg36kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 23:00:18 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA7N0H0F020270;
        Thu, 7 Nov 2019 23:00:17 GMT
Received: from [192.168.14.112] (/79.182.207.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 15:00:17 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v3 4/5] KVM: nVMX: Prepare MSR-store area
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191107224941.60336-5-aaronlewis@google.com>
Date:   Fri, 8 Nov 2019 01:00:13 +0200
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DA3ABA30-66FC-4CD8-A828-77686A868FD0@oracle.com>
References: <20191107224941.60336-1-aaronlewis@google.com>
 <20191107224941.60336-5-aaronlewis@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=989
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070211
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070211
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 8 Nov 2019, at 0:49, Aaron Lewis <aaronlewis@google.com> wrote:
>=20
> Prepare the MSR-store area to be used in a follow up patch.
>=20
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
> arch/x86/kvm/vmx/nested.c | 17 ++++++++++++++++-
> arch/x86/kvm/vmx/vmx.h    |  4 ++++
> 2 files changed, 20 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 7b058d7b9fcc..c249be43fff2 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -982,6 +982,14 @@ static int nested_vmx_store_msr(struct kvm_vcpu =
*vcpu, u64 gpa, u32 count)
> 	return 0;
> }
>=20
> +static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> +	struct vmx_msrs *autostore =3D &vmx->msr_autostore.guest;
> +
> +	autostore->nr =3D 0;
> +}
> +
> static bool nested_cr3_valid(struct kvm_vcpu *vcpu, unsigned long val)
> {
> 	unsigned long invalid_mask;
> @@ -2027,7 +2035,7 @@ static void prepare_vmcs02_constant_state(struct =
vcpu_vmx *vmx)
> 	 * addresses are constant (for vmcs02), the counts can change =
based
> 	 * on L2's behavior, e.g. switching to/from long mode.
> 	 */
> -	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
> +	vmcs_write64(VM_EXIT_MSR_STORE_ADDR, =
__pa(vmx->msr_autostore.guest.val));
> 	vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, =
__pa(vmx->msr_autoload.host.val));
> 	vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR, =
__pa(vmx->msr_autoload.guest.val));
>=20
> @@ -2294,6 +2302,13 @@ static void prepare_vmcs02_rare(struct vcpu_vmx =
*vmx, struct vmcs12 *vmcs12)
> 		vmcs_write64(EOI_EXIT_BITMAP3, =
vmcs12->eoi_exit_bitmap3);
> 	}
>=20
> +	/*
> +	 * Make sure the msr_autostore list is up to date before we set =
the
> +	 * count in the vmcs02.
> +	 */
> +	prepare_vmx_msr_autostore_list(&vmx->vcpu, MSR_IA32_TSC);

Doesn=E2=80=99t this fail compilation?
prepare_vmx_msr_autostore_list() is declared with single parameter while =
it is called here with two parameters.

Also, why do we need this as a separate patch?
It made sense if next patch was split between all the framework code and =
the code specific using it in regards to MSR_IA32_TSC,
but current separation is a bit bizarre. It is also OK if this patch and =
next one will just be merged to one (with no such separation).

> +
> +	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, =
vmx->msr_autostore.guest.nr);
> 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
> 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, =
vmx->msr_autoload.guest.nr);
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 1dad8e5c8f86..2616f639cf50 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -230,6 +230,10 @@ struct vcpu_vmx {
> 		struct vmx_msrs host;
> 	} msr_autoload;
>=20
> +	struct msr_autostore {
> +		struct vmx_msrs guest;
> +	} msr_autostore;
> +
> 	struct {
> 		int vm86_active;
> 		ulong save_rflags;
> --=20
> 2.24.0.432.g9d3f5f5b63-goog
>=20

