Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4838710A67B
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 23:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfKZWYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 17:24:22 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47928 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbfKZWYV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 17:24:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAQMEEW7040049;
        Tue, 26 Nov 2019 22:24:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=SJDVCpw6qPueKJtDR+L1/n7oTWYZFEcQk+lmiUm1XOQ=;
 b=C5nG9+5/j2IzWmBbcT53Mx4kZNnBym6/gKEXYKQzSIRfYl5IW+driqmOOqynLFJ0eaFk
 2SKa6hFaYW61hQycJaLGSfqMQMDzh+lx3GQNH3Mp1/D1fos6nqzWZHYyrgfq357vjKbI
 NO9JZVMO6Hcm95AWX2PTdcdfp5w5eTGbzSAuy4+iS5wlEoVfFRgipvphNaqKv8kN32Um
 F4Rw3p1lgQK+3OiJIsM18r+8KpS8yIf9bPSYZUoRbqCiZCpnvtybAY7PT0lQ90ZHL6gP
 tRqt5KRzFOTR6n8HogCVp0CMJDDZByqBXulPwAlOGNbIsBMcltq5WC+rc0n+9qt5hJ67 Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wevqq9paj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 22:24:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAQMOBrQ051915;
        Tue, 26 Nov 2019 22:24:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wh0reb91m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 22:24:15 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAQMNm0k015074;
        Tue, 26 Nov 2019 22:23:48 GMT
Received: from [192.168.14.112] (/109.66.202.5)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Nov 2019 14:23:48 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [kvm-unit-tests PATCH v2] x86: Add RDTSC test
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191126214443.99189-1-aaronlewis@google.com>
Date:   Wed, 27 Nov 2019 00:23:45 +0200
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <54EDFF36-0746-470B-A73E-4479D2A662DC@oracle.com>
References: <20191126214443.99189-1-aaronlewis@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911260189
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911260188
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 26 Nov 2019, at 23:44, Aaron Lewis <aaronlewis@google.com> wrote:
>=20
> Verify that the difference between a guest RDTSC instruction and the
> IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12's VM-exit
> MSR-store list is less than 750 cycles, 99.9% of the time.

It will help if commit message would also reference the KVM commit which =
fixes the issue tested by this test.
i.e. 662f1d1d1931 ("KVM: nVMX: Add support for capturing highest =
observable L2 TSC=E2=80=9D)

>=20
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
> x86/unittests.cfg |  6 ++++
> x86/vmx.h         |  1 +
> x86/vmx_tests.c   | 91 +++++++++++++++++++++++++++++++++++++++++++++++
> 3 files changed, 98 insertions(+)
>=20
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index b4865ac..5291d96 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -284,6 +284,12 @@ extra_params =3D -cpu host,+vmx -append =
vmx_vmcs_shadow_test
> arch =3D x86_64
> groups =3D vmx
>=20
> +[vmx_rdtsc_vmexit_diff_test]
> +file =3D vmx.flat
> +extra_params =3D -cpu host,+vmx -append rdtsc_vmexit_diff_test
> +arch =3D x86_64
> +groups =3D vmx
> +

I think we are missing some clear guidance on when a VMX unit-test =
should have it=E2=80=99s own test-section in x86/unittests.cfg.

I believe the guidance should be that all VMX tests are suppose to be =
run by [vmx] except those that have special requirements
on execution environment (e.g. vmx_smp*) or destroy execution =
environment after they run (e.g. vmx_init_signal_test) or
require special timeout if they fail (e.g. =
vmx_apic_passthrough_tpr_threshold_test).
These tests should both be removed from [vmx] by "-append -test_name=E2=80=
=9D and have their own section which runs them.

Being concrete to this patch, I think it shouldn=E2=80=99t have it=E2=80=99=
s own section.
For example, it will cause the test to run twice: Both as part of [vmx] =
and as part of [vmx_rdtsc_vmexit_diff_test].

And I can submit a separate patches to:
1) Rename vmx_eoi_bitmap_ioapic_scan & vmx_apic_passthrough_thread to =
prefix with vmx_smp*
    (It actually seems to me that currently there are no vmx_smp* tests =
at all=E2=80=A6)
    and create a [vmx_smp] section for running them.
2) Remove vmx_hlt_with_rvi_test and vmx_apicv_test sections.

Does anyone think differently?

> [debug]
> file =3D debug.flat
> arch =3D x86_64
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
> index 1d8932f..fcf71e7 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -8790,7 +8790,97 @@ static void vmx_vmcs_shadow_test(void)
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
> +#define HOST_RDTSC_LIMIT 750

Nit: I suggest to rename HOST_RDTSC_LIMIT to =
HOST_CAPTURED_GUEST_TSC_DIFF_THRESHOLD.

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
> +	TEST_ASSERT((vmcs_read(CPU_EXEC_CTRL1) & CPU_USE_TSC_SCALING) =3D=3D=
 0);

It=E2=80=99s problematic to vmcs_read(CPU_EXEC_CTRL1) when test runs on =
CPU that doesn=E2=80=99t support
secondary VM-execution control. As this will cause VMfailInvalid (i.e. =
Clear CF,PF,AF,SF,OF and set ZF).

What=E2=80=99s worse is that vmcs_read() today doesn=E2=80=99t assert =
that RFLAGS.ZF=3D=3D0 after executing VMREAD.
Maybe we should submit a separate patch for that as-well=E2=80=A6

Anyway, you can just change your assert condition to:
TEST_ASSERT(!(ctrl_cpu_rev[0].clr & CPU_SECONDARY) || =
!(vmcs_read(CPU_EXEC_CTRL1) & CPU_USE_TSC_SCALING));

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
> +		if (rdtsc_vmexit_diff_test_iteration() >=3D =
HOST_RDTSC_LIMIT)
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
> @@ -9056,5 +9146,6 @@ struct vmx_test vmx_tests[] =3D {
> 	/* Atomic MSR switch tests. */
> 	TEST(atomic_switch_max_msrs_test),
> 	TEST(atomic_switch_overflow_msrs_test),
> +	TEST(rdtsc_vmexit_diff_test),
> 	{ NULL, NULL, NULL, NULL, NULL, {0} },
> };
> --=20
> 2.24.0.432.g9d3f5f5b63-goog
>=20

