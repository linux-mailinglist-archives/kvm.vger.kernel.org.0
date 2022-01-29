Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDA34A2EBF
	for <lists+kvm@lfdr.de>; Sat, 29 Jan 2022 13:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244035AbiA2MEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Jan 2022 07:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243641AbiA2MEs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Jan 2022 07:04:48 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AD2C06173B;
        Sat, 29 Jan 2022 04:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/tnH4mtKbmuJnW+L9dQVaa40slr5MEsK8UllbPjXInc=; b=Yvu0AWffVrBcc7cMJ4b5xtQa+6
        Q/GKErMgB6STstmCl7pQmq/VPWWflgfApU8wADh5bXu5kSDOV9gN1DPT9WrDOa31ID9Vu/IF4Dk+n
        /dVImxjV9J6dkAxsZ9nmFdOMG0D98IQkdy8aNxN73S9tUugnEp4E4zsHcT9j4ri0Vp4S1JnyZyOfr
        4xkm2rQunW45pwjrpNxrAHzbj4HSJ7iTq4SMzL1cK3VpgVLMJJ4EmV4C64DEHQs/DSk9vzCZI/Ptm
        mrzII9KQdLXiXi6H09S6FBWauBsqZNmu6HIcYShaWl7LKzE7MIAvXQ+g5NFqzycibJrRK1xPEbLrX
        lFM6aKfg==;
Received: from [2001:8b0:10b:1:4a2a:e3ff:fe14:8625] (helo=u3832b3a9db3152.ant.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nDmSv-004b18-0f; Sat, 29 Jan 2022 12:04:25 +0000
Message-ID: <330bedfee12022c1180d8752fb4abe908dac08d1.camel@infradead.org>
Subject: Re: [PATCH v3 6/9] x86/smpboot: Support parallel startup of
 secondary CPUs
From:   David Woodhouse <dwmw2@infradead.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "luolongjun@huawei.com" <luolongjun@huawei.com>,
        "hejingxian@huawei.com" <hejingxian@huawei.com>,
        Joerg Roedel <joro@8bytes.org>
Date:   Sat, 29 Jan 2022 12:04:19 +0000
In-Reply-To: <e742473935bf81be84adea6fa8061ce0846cc630.camel@infradead.org>
References: <20211215145633.5238-1-dwmw2@infradead.org>
         <20211215145633.5238-7-dwmw2@infradead.org>
         <d10f529e-b1ee-6220-c6fc-80435f0061ee@amd.com>
         <f25c6ad00689fee6ce3e294393c13f3dcdd5985f.camel@infradead.org>
         <3d8e2d0d-1830-48fb-bc2d-995099f39ef0@amd.com>
         <e742473935bf81be84adea6fa8061ce0846cc630.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-bQ5VarWsg7U4rmr5VLf3"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-bQ5VarWsg7U4rmr5VLf3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-12-16 at 19:20 +0000, David Woodhouse wrote:
> On Thu, 2021-12-16 at 13:00 -0600, Tom Lendacky wrote:
> > On 12/16/21 12:24 PM, David Woodhouse wrote:
> > > On Thu, 2021-12-16 at 08:24 -0600, Tom Lendacky wrote:
> > >=20
> > > > This will break an SEV-ES guest because CPUID will generate a #VC a=
nd a
> > > > #VC handler has not been established yet.
> > > >=20
> > > > I guess for now, you can probably just not enable parallel startup =
for
> > > > SEV-ES guests.
> > >=20
> > > OK, thanks. I'll expand it to allow 24 bits of (physical) APIC ID the=
n,
> > > since it's no longer limited to CPUs without X2APIC. Then we can
> > > refrain from doing parallel bringup for SEV-ES guests, as you suggest=
.
> > >=20
> > > What precisely is the check I should be using for that?
> >=20
> > Calling cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT) will return true f=
or=20
> > an SEV-ES guest.
>=20
> Thanks. Incremental patch (which I'll roll into Thomas's patch) looks a
> bit like this. Testing it now...

Further inspection shows I really did want a bit to indicate that this
is a secondary AP startup, which Thomas had documented as such in the
comments in head_64.S but then actually called STARTUP_USE_APICID.=20

Otherwise the special case of smpboot_control=3D=3Dzero for startup of the
BSP which uses the pre-existing initial_gs etc., might also get invoked
in the rare case that an AP has APIC ID #0.

So we really do need Sean's fix to do the masking in the right place,
which I had 'fixed' by removing that mask altogether. And we also need
Sean's fix to stop scribbling on initial_fs when each AP will calculate
it for itself anyway.

I've rebased and pushed to
https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/paralle=
l-5.17

I'll do some more testing and repost the series during next week. The
win is slightly more modest than the original patch sets because it now
only parallelises x86/cpu:kick. I'm going to do more careful review and
testing before doing the same for x86/cpu:wait-init in a later series.
You can see that coming together in the git tree but I'm only going to
post up to the 'Serialise topology updates' patch again for now.

The only real change is this patch; perhaps now we've fixed it Thomas
will provide a Signed-off-by for it? :)

Now looks like this...

=46rom 888741f787a2e59b1471f15177c1ba981d06ad04 Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 12 Feb 2021 18:30:28 +0100
Subject: [PATCH v3.1 6/9] x86/smpboot: Support parallel startup of secondar=
y CPUs

To allow for parallel AP bringup, we need to avoid the use of global
variables for passing information to the APs, as well as preventing them
from all trying to use the same real-mode stack simultaneously.

So, introduce a 'lock' field in struct trampoline_header to use as a
simple bit-spinlock for the real-mode stack. That lock also protects
the global variables initial_gs, initial_stack and early_gdt_descr,
which can now be calculated...

So how do we calculate those addresses? Well, they they can all be found
from the per_cpu data for this CPU. Simples! Except... how does it know
what its CPU# is? OK, we export the cpuid_to_apicid[] array and it can
search it to find its APIC ID in there.

But now you whine at me that it doesn't even know its APIC ID? Well, if
it's a relatively modern CPU then the APIC ID is in CPUID leaf 0x0B so
we can use that. Otherwise... erm... OK, otherwise it can't have parallel
CPU bringup for now. We'll still use a global variable for those CPUs and
bring them up one at a time.

So add a global 'smpboot_control' field which either contains the APIC
ID, or a flag indicating that it can be found in CPUID.

This adds the 'do_parallel_bringup' flag in preparation but doesn't
actually enable parallel bringup yet.

[ dwmw2: Minor tweaks, write a commit message ]
[ seanc: Fix stray override of initial_gs in common_cpu_up() ]
Not-signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 arch/x86/include/asm/realmode.h      |  3 ++
 arch/x86/include/asm/smp.h           |  9 +++-
 arch/x86/kernel/acpi/sleep.c         |  1 +
 arch/x86/kernel/apic/apic.c          |  2 +-
 arch/x86/kernel/head_64.S            | 73 ++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c            | 32 ++++++++++--
 arch/x86/realmode/init.c             |  3 ++
 arch/x86/realmode/rm/trampoline_64.S | 14 ++++++
 kernel/smpboot.c                     |  2 +-
 9 files changed, 132 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmod=
e.h
index 331474b150f1..1693bc834163 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -51,6 +51,7 @@ struct trampoline_header {
 	u64 efer;
 	u32 cr4;
 	u32 flags;
+	u32 lock;
 #endif
 };
=20
@@ -64,6 +65,8 @@ extern unsigned long initial_stack;
 extern unsigned long initial_vc_handler;
 #endif
=20
+extern u32 *trampoline_lock;
+
 extern unsigned char real_mode_blob[];
 extern unsigned char real_mode_relocs[];
=20
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 81a0211a372d..4fe1320c2e8d 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -196,5 +196,12 @@ extern void nmi_selftest(void);
 #define nmi_selftest() do { } while (0)
 #endif
=20
-#endif /* __ASSEMBLY__ */
+extern unsigned int smpboot_control;
+
+#endif /* !__ASSEMBLY__ */
+
+/* Control bits for startup_64 */
+#define	STARTUP_PARALLEL	0x80000000
+#define	STARTUP_SECONDARY	0x40000000
+
 #endif /* _ASM_X86_SMP_H */
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 1e97f944b47d..4f26cc9346ac 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -114,6 +114,7 @@ int x86_acpi_suspend_lowlevel(void)
 	early_gdt_descr.address =3D
 			(unsigned long)get_cpu_gdt_rw(smp_processor_id());
 	initial_gs =3D per_cpu_offset(smp_processor_id());
+	smpboot_control =3D 0;
 #endif
 	initial_code =3D (unsigned long)wakeup_long64;
        saved_magic =3D 0x123456789abcdef0L;
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b70344bf6600..5b20e051d84c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2335,7 +2335,7 @@ static int nr_logical_cpuids =3D 1;
 /*
  * Used to store mapping between logical CPU IDs and APIC IDs.
  */
-static int cpuid_to_apicid[] =3D {
+int cpuid_to_apicid[] =3D {
 	[0 ... NR_CPUS - 1] =3D -1,
 };
=20
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 9c63fc5988cd..b0d8c9fffc73 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -25,6 +25,7 @@
 #include <asm/export.h>
 #include <asm/nospec-branch.h>
 #include <asm/fixmap.h>
+#include <asm/smp.h>
=20
 /*
  * We are not able to switch in one step to the final KERNEL ADDRESS SPACE
@@ -193,6 +194,66 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_=
GLOBAL)
 1:
 	UNWIND_HINT_EMPTY
=20
+	/*
+	 * Is this the boot CPU coming up? If so everything is available
+	 * in initial_gs, initial_stack and early_gdt_descr.
+	 */
+	movl	smpboot_control(%rip), %eax
+	testl	%eax, %eax
+	jz	.Lsetup_cpu
+
+	/*
+	 * Secondary CPUs find out the offsets via the APIC ID. For parallel
+	 * boot the APIC ID is retrieved from CPUID, otherwise it's encoded
+	 * in smpboot_control:
+	 * Bit 0-29	APIC ID if STARTUP_PARALLEL flag is not set
+	 * Bit 30	STARTUP_SECONDARY flag
+	 * Bit 31	STARTUP_PARALLEL flag (use CPUID 0x0b for APIC ID)
+	 */
+	testl	$STARTUP_PARALLEL, %eax
+	jnz	.Luse_cpuid_0b
+	andl	$0x0FFFFFFF, %eax
+	jmp	.Lsetup_AP
+
+.Luse_cpuid_0b:
+	mov	$0x0B, %eax
+	xorl	%ecx, %ecx
+	cpuid
+	mov	%edx, %eax
+
+.Lsetup_AP:
+	/* EAX contains the APICID of the current CPU */
+	xorl	%ecx, %ecx
+	leaq	cpuid_to_apicid(%rip), %rbx
+
+.Lfind_cpunr:
+	cmpl	(%rbx), %eax
+	jz	.Linit_cpu_data
+	addq	$4, %rbx
+	addq	$8, %rcx
+	jmp	.Lfind_cpunr
+
+.Linit_cpu_data:
+	/* Get the per cpu offset */
+	leaq	__per_cpu_offset(%rip), %rbx
+	addq	%rcx, %rbx
+	movq	(%rbx), %rbx
+	/* Save it for GS BASE setup */
+	movq	%rbx, initial_gs(%rip)
+
+	/* Calculate the GDT address */
+	movq	$gdt_page, %rcx
+	addq	%rbx, %rcx
+	movq	%rcx, early_gdt_descr_base(%rip)
+
+	/* Find the idle task stack */
+	movq	$idle_threads, %rcx
+	addq	%rbx, %rcx
+	movq	(%rcx), %rcx
+	movq	TASK_threadsp(%rcx), %rcx
+	movq	%rcx, initial_stack(%rip)
+
+.Lsetup_cpu:
 	/*
 	 * We must switch to a new descriptor in kernel space for the GDT
 	 * because soon the kernel won't have access anymore to the userspace
@@ -233,6 +294,14 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_=
GLOBAL)
 	 */
 	movq initial_stack(%rip), %rsp
=20
+	/* Drop the realmode protection. For the boot CPU the pointer is NULL! */
+	movq	trampoline_lock(%rip), %rax
+	testq	%rax, %rax
+	jz	.Lsetup_idt
+	lock
+	btrl	$0, (%rax)
+
+.Lsetup_idt:
 	/* Setup and Load IDT */
 	pushq	%rsi
 	call	early_setup_idt
@@ -364,6 +433,7 @@ SYM_DATA(initial_vc_handler,	.quad handle_vc_boot_ghcb)
  * reliably detect the end of the stack.
  */
 SYM_DATA(initial_stack, .quad init_thread_union + THREAD_SIZE - FRAME_SIZE=
)
+SYM_DATA(trampoline_lock, .quad 0);
 	__FINITDATA
=20
 	__INIT
@@ -589,6 +659,9 @@ SYM_DATA_END(level1_fixmap_pgt)
 SYM_DATA(early_gdt_descr,		.word GDT_ENTRIES*8-1)
 SYM_DATA_LOCAL(early_gdt_descr_base,	.quad INIT_PER_CPU_VAR(gdt_page))
=20
+	.align 16
+SYM_DATA(smpboot_control,		.long 0)
+
 	.align 16
 /* This must match the first entry in level2_kernel_pgt */
 SYM_DATA(phys_base, .quad 0x0)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 38c5d65a568d..e060bbd79cc2 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -808,6 +808,16 @@ static int __init cpu_init_udelay(char *str)
 }
 early_param("cpu_init_udelay", cpu_init_udelay);
=20
+static bool do_parallel_bringup =3D true;
+
+static int __init no_parallel_bringup(char *str)
+{
+	do_parallel_bringup =3D false;
+
+	return 0;
+}
+early_param("no_parallel_bringup", no_parallel_bringup);
+
 static void __init smp_quirk_init_udelay(void)
 {
 	/* if cmdline changed it from default, leave it alone */
@@ -1095,8 +1105,6 @@ int common_cpu_up(unsigned int cpu, struct task_struc=
t *idle)
 #ifdef CONFIG_X86_32
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	per_cpu(cpu_current_top_of_stack, cpu) =3D task_top_of_stack(idle);
-#else
-	initial_gs =3D per_cpu_offset(cpu);
 #endif
 	return 0;
 }
@@ -1115,9 +1123,16 @@ static int do_boot_cpu(int apicid, int cpu, struct t=
ask_struct *idle,
 	unsigned long boot_error =3D 0;
=20
 	idle->thread.sp =3D (unsigned long)task_pt_regs(idle);
-	early_gdt_descr.address =3D (unsigned long)get_cpu_gdt_rw(cpu);
 	initial_code =3D (unsigned long)start_secondary;
-	initial_stack  =3D idle->thread.sp;
+
+	if (IS_ENABLED(CONFIG_X86_32)) {
+		early_gdt_descr.address =3D (unsigned long)get_cpu_gdt_rw(cpu);
+		initial_stack  =3D idle->thread.sp;
+	} else if (do_parallel_bringup) {
+		smpboot_control =3D STARTUP_SECONDARY | STARTUP_PARALLEL;
+	} else {
+		smpboot_control =3D STARTUP_SECONDARY | apicid;
+	}
=20
 	/* Enable the espfix hack for this CPU */
 	init_espfix_ap(cpu);
@@ -1516,6 +1531,15 @@ void __init native_smp_prepare_cpus(unsigned int max=
_cpus)
 	smp_quirk_init_udelay();
=20
 	speculative_store_bypass_ht_init();
+
+	/*
+	 * We can do 64-bit AP bringup in parallel if the CPU reports its
+	 * APIC ID in CPUID leaf 0x0B. Otherwise it's too hard. And not
+	 * for SEV-ES guests because they can't use CPUID that early.
+	 */
+	if (IS_ENABLED(CONFIG_X86_32) || boot_cpu_data.cpuid_level < 0x0B ||
+	    cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
+		do_parallel_bringup =3D false;
 }
=20
 void arch_thaw_secondary_cpus_begin(void)
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index c5e29db02a46..21b9e8b55618 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -154,6 +154,9 @@ static void __init setup_real_mode(void)
=20
 	trampoline_header->flags =3D 0;
=20
+	trampoline_lock =3D &trampoline_header->lock;
+	*trampoline_lock =3D 0;
+
 	trampoline_pgd =3D (u64 *) __va(real_mode_header->trampoline_pgd);
=20
 	/* Map the real mode stub as virtual =3D=3D physical */
diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/tr=
ampoline_64.S
index cc8391f86cdb..12a540904e80 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -49,6 +49,19 @@ SYM_CODE_START(trampoline_start)
 	mov	%ax, %es
 	mov	%ax, %ss
=20
+	/*
+	 * Make sure only one CPU fiddles with the realmode stack
+	 */
+.Llock_rm:
+	btl	$0, tr_lock
+	jnc	2f
+	pause
+	jmp	.Llock_rm
+2:
+	lock
+	btsl	$0, tr_lock
+	jc	.Llock_rm
+
 	# Setup stack
 	movl	$rm_stack_end, %esp
=20
@@ -192,6 +205,7 @@ SYM_DATA_START(trampoline_header)
 	SYM_DATA(tr_efer,		.space 8)
 	SYM_DATA(tr_cr4,		.space 4)
 	SYM_DATA(tr_flags,		.space 4)
+	SYM_DATA(tr_lock,		.space 4)
 SYM_DATA_END(trampoline_header)
=20
 #include "trampoline_common.S"
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index f6bc0bc8a2aa..934e64ff4eed 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -25,7 +25,7 @@
  * For the hotplug case we keep the task structs around and reuse
  * them.
  */
-static DEFINE_PER_CPU(struct task_struct *, idle_threads);
+DEFINE_PER_CPU(struct task_struct *, idle_threads);
=20
 struct task_struct *idle_thread_get(unsigned int cpu)
 {
--=20
2.33.1


--=-bQ5VarWsg7U4rmr5VLf3
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEkQw
ggYQMIID+KADAgECAhBNlCwQ1DvglAnFgS06KwZPMA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQG
EwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eTAeFw0xODExMDIwMDAwMDBaFw0zMDEyMzEyMzU5NTlaMIGWMQswCQYDVQQG
EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYD
VQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAyjztlApB/975Rrno1jvm2pK/KxBOqhq8gr2+JhwpKirSzZxQgT9tlC7zl6hn1fXjSo5MqXUf
ItMltrMaXqcESJuK8dtK56NCSrq4iDKaKq9NxOXFmqXX2zN8HHGjQ2b2Xv0v1L5Nk1MQPKA19xeW
QcpGEGFUUd0kN+oHox+L9aV1rjfNiCj3bJk6kJaOPabPi2503nn/ITX5e8WfPnGw4VuZ79Khj1YB
rf24k5Ee1sLTHsLtpiK9OjG4iQRBdq6Z/TlVx/hGAez5h36bBJMxqdHLpdwIUkTqT8se3ed0PewD
ch/8kHPo5fZl5u1B0ecpq/sDN/5sCG52Ds+QU5O5EwIDAQABo4IBZDCCAWAwHwYDVR0jBBgwFoAU
U3m/WqorSs9UgOHYm8Cd8rIDZsswHQYDVR0OBBYEFAnA8vwL2pTbX/4r36iZQs/J4K0AMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEF
BQcDBDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2Vy
dHJ1c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsGAQUF
BwEBBGowaDA/BggrBgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJT
QUFkZFRydXN0Q0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0G
CSqGSIb3DQEBDAUAA4ICAQBBRHUAqznCFfXejpVtMnFojADdF9d6HBA4kMjjsb0XMZHztuOCtKF+
xswhh2GqkW5JQrM8zVlU+A2VP72Ky2nlRA1GwmIPgou74TZ/XTarHG8zdMSgaDrkVYzz1g3nIVO9
IHk96VwsacIvBF8JfqIs+8aWH2PfSUrNxP6Ys7U0sZYx4rXD6+cqFq/ZW5BUfClN/rhk2ddQXyn7
kkmka2RQb9d90nmNHdgKrwfQ49mQ2hWQNDkJJIXwKjYA6VUR/fZUFeCUisdDe/0ABLTI+jheXUV1
eoYV7lNwNBKpeHdNuO6Aacb533JlfeUHxvBz9OfYWUiXu09sMAviM11Q0DuMZ5760CdO2VnpsXP4
KxaYIhvqPqUMWqRdWyn7crItNkZeroXaecG03i3mM7dkiPaCkgocBg0EBYsbZDZ8bsG3a08LwEsL
1Ygz3SBsyECa0waq4hOf/Z85F2w2ZpXfP+w8q4ifwO90SGZZV+HR/Jh6rEaVPDRF/CEGVqR1hiuQ
OZ1YL5ezMTX0ZSLwrymUE0pwi/KDaiYB15uswgeIAcA6JzPFf9pLkAFFWs1QNyN++niFhsM47qod
x/PL+5jR87myx5uYdBEQkkDc+lKB1Wct6ucXqm2EmsaQ0M95QjTmy+rDWjkDYdw3Ms6mSWE3Bn7i
5ZgtwCLXgAIe5W8mybM2JzCCBhQwggT8oAMCAQICEQDGvhmWZ0DEAx0oURL6O6l+MA0GCSqGSIb3
DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
VQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28g
UlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTIyMDEwNzAw
MDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9y
ZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3GpC2bomUqk+91wLYBzDMcCj5C9m6
oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZHh7htyAkWYVoFsFPrwHounto8xTsy
SSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT9YgcBqKCo65pTFmOnR/VVbjJk4K2
xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNjP+qDrh0db7PAjO1D4d5ftfrsf+kd
RR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy2U+eITZ5LLE5s45mX2oPFknWqxBo
bQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3BgBEmfsYWlBXO8rVXfvPgLs32VdV
NZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/7auNVRmPB3v5SWEsH8xi4Bez2V9U
KxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmdlFYhAflWKQ03Ufiu8t3iBE3VJbc2
5oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9aelIl6vtbhMA+l0nfrsORMa4kobqQ5
C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMBAAGjggHMMIIByDAfBgNVHSMEGDAW
gBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeDMcimo0oz8o1R1Nver3ZVpSkwDgYD
VR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGln
by5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGln
b1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcmwwgYoGCCsGAQUFBwEB
BH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBQ2xpZW50
QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL29j
c3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5mcmFkZWFkLm9yZzANBgkqhkiG9w0B
AQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQvQ/fzPXmtR9t54rpmI2TfyvcKgOXp
qa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvIlSPrzIB4Z2wyIGQpaPLlYflrrVFK
v9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9ChWFfgSXvrWDZspnU3Gjw/rMHrGnql
Htlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0whpBtXdyDjzBtQTaZJ7zTT/vlehc/
tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9IzCCBhQwggT8oAMCAQICEQDGvhmW
Z0DEAx0oURL6O6l+MA0GCSqGSIb3DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0
ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJl
IEVtYWlsIENBMB4XDTIyMDEwNzAwMDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJ
ARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3
GpC2bomUqk+91wLYBzDMcCj5C9m6oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZH
h7htyAkWYVoFsFPrwHounto8xTsySSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT
9YgcBqKCo65pTFmOnR/VVbjJk4K2xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNj
P+qDrh0db7PAjO1D4d5ftfrsf+kdRR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy
2U+eITZ5LLE5s45mX2oPFknWqxBobQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3
BgBEmfsYWlBXO8rVXfvPgLs32VdVNZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/
7auNVRmPB3v5SWEsH8xi4Bez2V9UKxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmd
lFYhAflWKQ03Ufiu8t3iBE3VJbc25oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9ae
lIl6vtbhMA+l0nfrsORMa4kobqQ5C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMB
AAGjggHMMIIByDAfBgNVHSMEGDAWgBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeD
Mcimo0oz8o1R1Nver3ZVpSkwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYw
FAYIKwYBBQUHAwQGCCsGAQUFBwMCMEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYB
BQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9j
cmwuc2VjdGlnby5jb20vU2VjdGlnb1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1h
aWxDQS5jcmwwgYoGCCsGAQUFBwEBBH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdv
LmNvbS9TZWN0aWdvUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAj
BggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQv
Q/fzPXmtR9t54rpmI2TfyvcKgOXpqa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvI
lSPrzIB4Z2wyIGQpaPLlYflrrVFKv9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9Ch
WFfgSXvrWDZspnU3Gjw/rMHrGnqlHtlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0w
hpBtXdyDjzBtQTaZJ7zTT/vlehc/tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9
IzGCBMcwggTDAgEBMIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVz
dGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMT
NVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA
xr4ZlmdAxAMdKFES+jupfjANBglghkgBZQMEAgEFAKCCAeswGAYJKoZIhvcNAQkDMQsGCSqGSIb3
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjIwMTI5MTIwNDE5WjAvBgkqhkiG9w0BCQQxIgQghIKPs0ms
6jawv1FCj9Q+YLQiE/8pLF+s4sauCyxzXfMwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgBtTdOIHj9tU7Cn3Hs+rd1AYUoBsFE9fQac
EFAMx6I6E6/VOcasaOX9TNyi8XYYYvbCHR1YYNTHNIUZsv2TPDoJeHW72ekMUC+LeqeXrRZeCy3Y
kDy6Kf2jdQMcIcvYfnH5qhTtpsd0CW94gJkfCifWj5wZNCmurs0aQbwK3AqCodsnrCSCCPITv4+d
rVkNYs+G3XfaBjXf3/OuEJrTGzhEBx7Qs0n+X8VsUMMO6mJqzfeXhEN/9tr/7rMVt+q3F5sz6axS
KDJELk9l0dH2ndautrQk1oz1mcXzj6UqDK0INNTj15YeIiCyzHYpi2eZe+DtqCc6xJ0mnKknd4K7
1XPzHvaBKukLcChmzuYjXebJWSNu5KHKqdzr7V+7i9dcVrifhqMR6wlTNFa+7AyRy8ki/8NbbKww
oM1nYIO2oPt0S+LG79OtflJbmRR3rK+dEjlreBPlOeu2sJKrHB+QL2KxaOM9o4JtwJAEJihrDL6v
5Ap6K5CQ5U/AGQNObhEPT0RZQupSSv7aPKwiVvLE30AwAn3xJE/15symb3SZQCNieZ824bBPkJ5u
gnPGbROwvOv9xFLybR6se+U/qkrtU7vYMVbP26fC0WFA8opuAvqZLV+pVzIb9AubnZuBGze7t+/7
5+TYAsRCgSLRK33OrR6GXiZQj9hzXeZ6OtxxJJA88QAAAAAAAA==


--=-bQ5VarWsg7U4rmr5VLf3--

