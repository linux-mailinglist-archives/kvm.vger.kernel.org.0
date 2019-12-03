Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A1E10F4AF
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 02:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfLCBvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 20:51:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55086 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbfLCBvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 20:51:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB31mlrc048021;
        Tue, 3 Dec 2019 01:51:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=GFBLAQ+sSPK7hmUZO+tcBqSPCBWAfnog65pvUny/6L8=;
 b=lCU55fTsLjgvBBw/OWmOOchQYTH8Oo48aL7H62eWNsWAW94/Q+G7FiGhTk7CkAYq4T6b
 MKAsSV95quJv87ob5+2T//wcn7hzei38Ijg7SkpKud6OSIhxq7x7MAguNv8K+XRFKIUw
 X6axpTFj2alZCRwHK72YtcpN9W3LFISs51DKYdStxj3piouDrOcoaldOie+38LBkz47D
 cuBqUTiSU2VJkGpjw62DrvW8SEv94AAo+6apuZcnRsiRXmx/gaGcme0K/9xU1+p+Q/Eo
 i8assiUqgR6Q8IRXib2PhSzyvTgh2W/QvQCtRNVc6fGCYsQIGG+v1nIMH7Jm+md48gZc rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wkgcq42kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 01:51:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB31mWMM095444;
        Tue, 3 Dec 2019 01:51:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2wn7pnv73x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 01:51:38 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB31pbqC019401;
        Tue, 3 Dec 2019 01:51:37 GMT
Received: from [192.168.14.112] (/109.66.202.5)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 17:51:37 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [kvm-unit-tests PATCH v3] x86: Add RDTSC test
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191202204356.250357-1-aaronlewis@google.com>
Date:   Tue, 3 Dec 2019 03:51:31 +0200
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FD9C936D-35CC-4183-AF33-E6B9C52CC460@oracle.com>
References: <20191202204356.250357-1-aaronlewis@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030015
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 2 Dec 2019, at 22:43, Aaron Lewis <aaronlewis@google.com> wrote:
>=20
> Verify that the difference between a guest RDTSC instruction and the
> IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12's VM-exit
> MSR-store list is less than 750 cycles, 99.9% of the time.
>=20
> 662f1d1d1931 ("KVM: nVMX: Add support for capturing highest observable =
L2 TSC=E2=80=9D)

Reviewed-by: Liran Alon <liran.alon@oracle.com>

>=20
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
> x86/vmx.h       |  1 +
> x86/vmx_tests.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 94 insertions(+)
>=20
> diff --git a/x86/vmx.h b/x86/vmx.h
> index 8496be7..21ba953 100644
> --- a/x86/vmx.h
> +++ b/x86/vmx.h
> @@ -420,6 +420,7 @@ enum Ctrl1 {
> 	CPU_SHADOW_VMCS		=3D 1ul << 14,
> 	CPU_RDSEED		=3D 1ul << 16,
> 	CPU_PML                 =3D 1ul << 17,
> +	CPU_USE_TSC_SCALING	=3D 1ul << 25,
> };
>=20
> enum Intr_type {
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 1d8932f..6ceaf9a 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -8790,7 +8790,99 @@ static void vmx_vmcs_shadow_test(void)
> 	enter_guest();
> }
>=20
> +/*
> + * This test monitors the difference between a guest RDTSC =
instruction
> + * and the IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12
> + * VM-exit MSR-store list when taking a VM-exit on the instruction
> + * following RDTSC.
> + */
> +#define RDTSC_DIFF_ITERS 100000
> +#define RDTSC_DIFF_FAILS 100
> +#define HOST_CAPTURED_GUEST_TSC_DIFF_THRESHOLD 750
> +
> +/*
> + * Set 'use TSC offsetting' and set the guest offset to the
> + * inverse of the host's current TSC value, so that the guest starts =
running
> + * with an effective TSC value of 0.
> + */
> +static void reset_guest_tsc_to_zero(void)
> +{
> +	TEST_ASSERT_MSG(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET,
> +			"Expected support for 'use TSC offsetting'");
> +
> +	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_USE_TSC_OFFSET);
> +	vmcs_write(TSC_OFFSET, -rdtsc());
> +}
> +
> +static void rdtsc_vmexit_diff_test_guest(void)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < RDTSC_DIFF_ITERS; i++)
> +		/* Ensure rdtsc is the last instruction before the =
vmcall. */
> +		asm volatile("rdtsc; vmcall" : : : "eax", "edx");
> +}
>=20
> +/*
> + * This function only considers the "use TSC offsetting" VM-execution
> + * control.  It does not handle "use TSC scaling" (because the latter
> + * isn't available to the host today.)
> + */
> +static unsigned long long host_time_to_guest_time(unsigned long long =
t)
> +{
> +	TEST_ASSERT(!(ctrl_cpu_rev[0].clr & CPU_SECONDARY) ||
> +		    !(vmcs_read(CPU_EXEC_CTRL1) & CPU_USE_TSC_SCALING));
> +
> +	if (vmcs_read(CPU_EXEC_CTRL0) & CPU_USE_TSC_OFFSET)
> +		t +=3D vmcs_read(TSC_OFFSET);
> +
> +	return t;
> +}
> +
> +static unsigned long long rdtsc_vmexit_diff_test_iteration(void)
> +{
> +	unsigned long long guest_tsc, host_to_guest_tsc;
> +
> +	enter_guest();
> +	skip_exit_vmcall();
> +	guest_tsc =3D (u32) regs.rax + (regs.rdx << 32);
> +	host_to_guest_tsc =3D =
host_time_to_guest_time(exit_msr_store[0].value);
> +
> +	return host_to_guest_tsc - guest_tsc;
> +}
> +
> +static void rdtsc_vmexit_diff_test(void)
> +{
> +	int fail =3D 0;
> +	int i;
> +
> +	test_set_guest(rdtsc_vmexit_diff_test_guest);
> +
> +	reset_guest_tsc_to_zero();
> +
> +	/*
> +	 * Set up the VMCS12 VM-exit MSR-store list to store just one
> +	 * MSR: IA32_TIME_STAMP_COUNTER. Note that the value stored is
> +	 * in the host time domain (i.e., it is not adjusted according
> +	 * to the TSC multiplier and TSC offset fields in the VMCS12,
> +	 * as a guest RDTSC would be.)
> +	 */
> +	exit_msr_store =3D alloc_page();
> +	exit_msr_store[0].index =3D MSR_IA32_TSC;
> +	vmcs_write(EXI_MSR_ST_CNT, 1);
> +	vmcs_write(EXIT_MSR_ST_ADDR, virt_to_phys(exit_msr_store));
> +
> +	for (i =3D 0; i < RDTSC_DIFF_ITERS; i++) {
> +		if (rdtsc_vmexit_diff_test_iteration() >=3D
> +		    HOST_CAPTURED_GUEST_TSC_DIFF_THRESHOLD)
> +			fail++;
> +	}
> +
> +	enter_guest();
> +
> +	report("RDTSC to VM-exit delta too high in %d of %d iterations",
> +	       fail < RDTSC_DIFF_FAILS, fail, RDTSC_DIFF_ITERS);
> +}
>=20
> static int invalid_msr_init(struct vmcs *vmcs)
> {
> @@ -9056,5 +9148,6 @@ struct vmx_test vmx_tests[] =3D {
> 	/* Atomic MSR switch tests. */
> 	TEST(atomic_switch_max_msrs_test),
> 	TEST(atomic_switch_overflow_msrs_test),
> +	TEST(rdtsc_vmexit_diff_test),
> 	{ NULL, NULL, NULL, NULL, NULL, {0} },
> };
> --=20
> 2.24.0.393.g34dc348eaf-goog
>=20

