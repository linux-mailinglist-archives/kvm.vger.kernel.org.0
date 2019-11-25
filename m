Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5E21096E0
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 00:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfKYXWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 18:22:21 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42252 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfKYXWV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 18:22:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAPNJ4Bo087276;
        Mon, 25 Nov 2019 23:22:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=+oo15igCoOs0j7Toc0uYRSWcb26gDJwfkEtYE99Zh74=;
 b=O/t+uTFb7D3D78MxDqMYOpLEsvb5G7hSV2XIttHag83nCcnV7Md4HjshYCauK+P5O76m
 01Km+yOyPsTxIhBpDTiIzXjt1zptDUtEfPKSArgbrjjJ5XW3WbmXGgN5tACG46F6FnwH
 dC2Pn2vC3fgS7rzL4E8ucCcZrwW6cDB2o/KraZMC9adgKR8/LLyEP51c5JWIy0HRJg1E
 G9ubSB2oSaBMFmdezIERtrhpT2l3BOS22te2c23IjalR0rwj9gZYg6OOzRpRRM9o1nrb
 e+Y8VepVMrlKqdLRJcVB1NFd8AlbqceHHDsIiA4/ZKHiOLhmfMpORMh5QFesJTvOv07Y pw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wev6u2v0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Nov 2019 23:22:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAPNItQq108703;
        Mon, 25 Nov 2019 23:22:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wfex755v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Nov 2019 23:22:13 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAPNMDS0001611;
        Mon, 25 Nov 2019 23:22:13 GMT
Received: from [192.168.14.112] (/109.66.202.5)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 Nov 2019 15:22:13 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [kvm-unit-tests PATCH] x86: Add RDTSC test
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191125224428.77547-1-aaronlewis@google.com>
Date:   Tue, 26 Nov 2019 01:22:09 +0200
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <23263B46-00C3-4DB0-9D59-077CD5A7A265@oracle.com>
References: <20191125224428.77547-1-aaronlewis@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9452 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911250182
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9452 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911250182
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 26 Nov 2019, at 0:44, Aaron Lewis <aaronlewis@google.com> wrote:
>=20
> Verify that the difference between an L2 RDTSC instruction and the
> IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12's VM-exit
> MSR-store list is less than 750 cycles, 99.9% of the time.
>=20
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
> x86/unittests.cfg |  6 ++++
> x86/vmx_tests.c   | 89 +++++++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 95 insertions(+)
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
> [debug]
> file =3D debug.flat
> arch =3D x86_64
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 1d8932f..f42ae2c 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -8790,7 +8790,94 @@ static void vmx_vmcs_shadow_test(void)
> 	enter_guest();
> }
>=20
> +/*
> + * This test monitors the difference between an L2 RDTSC instruction
> + * and the IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12
> + * VM-exit MSR-store list when taking a VM-exit on the instruction
> + * following RDTSC.
> + */
> +#define RDTSC_DIFF_ITERS 100000
> +#define RDTSC_DIFF_FAILS 100
> +#define L1_RDTSC_LIMIT 750

General note: I personally dislike the use of terms L1 & L2 in =
kvm-unit-tests.
I prefer to use host vs. guest OR vmx root mode vs. non-root mode.

Especially considering that kvm-unit-tests have de-facto became =
cpu-unit-tests as it can run on top of any CPU implementation.
Either vCPU on top of some hypervisor (KVM being one of them) or a =
BareMetal CPU (Like Nadav Amit runs to verify tests correctness :P).

> +
> +/*
> + * Set 'use TSC offsetting' and set the L2 offset to the
> + * inverse of L1's current TSC value, so that L2 starts running
> + * with an effective TSC value of 0.
> + */
> +static void reset_l2_tsc_to_zero(void)
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
> +		asm volatile("rdtsc; vmcall" : : : "eax", "edx=E2=80=9D);

I would add a comment here on why you use inline asm inside of just { =
l2_rdtsc =3D rdtsc(); vmcall(); }.
(Because of the extra cycles wasted on =E2=80=9CORing=E2=80=9D RDX:RAX =
and saving result to some global before vmcall).

> +}
> +
> +/*
> + * This function only considers the "use TSC offsetting" VM-execution
> + * control.  It does not handle "use TSC scaling" (because the latter
> + * isn't available to L1 today.)

Because function correctness assume the latter, consider adding a =
runtime assert() on it?

> + */
> +static unsigned long long l1_time_to_l2_time(unsigned long long t)
> +{
> +	if (vmcs_read(CPU_EXEC_CTRL0) & CPU_USE_TSC_OFFSET)
> +		t +=3D vmcs_read(TSC_OFFSET);
> +
> +	return t;
> +}
> +
> +static unsigned long long get_tsc_diff(void)

I think get_tsc_diff() is a bit of too generic name. May cause =
confusion.
I would consider renaming to rdtsc_vmexit_diff_test_iteration() or just =
put logic inline test itself.

> +{
> +	unsigned long long l2_tsc, l1_to_l2_tsc;
> +
> +	enter_guest();
> +	skip_exit_vmcall();
> +	l2_tsc =3D (u32) regs.rax + (regs.rdx << 32);
> +	l1_to_l2_tsc =3D l1_time_to_l2_time(exit_msr_store[0].value);
> +
> +	return l1_to_l2_tsc - l2_tsc;
> +}
> +
> +static void rdtsc_vmexit_diff_test(void)
> +{
> +	int fail =3D 0;
> +	int i;
> +
> +	test_set_guest(rdtsc_vmexit_diff_test_guest);
> +
> +	reset_l2_tsc_to_zero();
>=20
> +	/*
> +	 * Set up the VMCS12 VM-exit MSR-store list to store just one
> +	 * MSR: IA32_TIME_STAMP_COUNTER. Note that the value stored is
> +	 * in the L1 time domain (i.e., it is not adjusted according
> +	 * to the TSC multiplier and TSC offset fields in the VMCS12,
> +	 * as an L2 RDTSC would be.)
> +	 */
> +	exit_msr_store =3D alloc_page();
> +	exit_msr_store[0].index =3D MSR_IA32_TSC;
> +	vmcs_write(EXI_MSR_ST_CNT, 1);
> +	vmcs_write(EXIT_MSR_ST_ADDR, virt_to_phys(exit_msr_store));
> +
> +	for (i =3D 0; i < RDTSC_DIFF_ITERS; i++) {
> +		if (get_tsc_diff() < L1_RDTSC_LIMIT)

Isn=E2=80=99t having a small diff between the value written to =
exit_msr_store[0].value to L2=E2=80=99s RDTSC result a good thing?
i.e. We wish that the MSR value captured by host will be very close to =
the guest RDTSC value on guest->host VMExit.
So shouldn=E2=80=99t the condition be (get_tsc_diff() >=3D =
L1_RDTSC_LIMIT)?

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
> @@ -9056,5 +9143,7 @@ struct vmx_test vmx_tests[] =3D {
> 	/* Atomic MSR switch tests. */
> 	TEST(atomic_switch_max_msrs_test),
> 	TEST(atomic_switch_overflow_msrs_test),
> +	/* Miscellaneous tests */

You can consider it de-facto part of =E2=80=9CAtomic MSR switch =
tests.=E2=80=9D and remove this comment.

> +	TEST(rdtsc_vmexit_diff_test),
> 	{ NULL, NULL, NULL, NULL, NULL, {0} },
> };
> --=20
> 2.24.0.432.g9d3f5f5b63-goog
>=20

