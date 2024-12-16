Return-Path: <kvm+bounces-33874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3AD59F3978
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 20:08:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBA1E1671CB
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 19:08:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A706207DE7;
	Mon, 16 Dec 2024 19:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TkfX2/vr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8AF1CD213
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 19:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734376094; cv=none; b=OZMG5YTgFJ9mxPEee6b9MCZoY6gE+UUsHfYZh9LuP//7CJCKLFHl16pgT07rTyZ0eQ5jBMvaXU7OIXWFgnst92nSiXu9FGH1oLdWVYVSg8KCtEh5m1+cThXuMMcaJsn/na8PDTq5j+wwpWz7hTs08LI+i6I006TFnW8C3w14y0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734376094; c=relaxed/simple;
	bh=XHY6RRaofeSqNpkhu+XLNYYsg9u82MtyFmn0jiwVWsA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LuRVDFLVcVDgB3QGUJmhCM4+m9loW6YFB1GLqUDsPN1s6kO4p36TDJcYUUFDDtnu1/JdH1gMihi7g+45Tgs43G8bk+Vle2jjdyCS08AxkIS3rIHbj4YGVV1t2HlapdKxrj+rPZlW/njs30WbUd9R1xakY1uuwKx75K6kalHGooI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TkfX2/vr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39216C4CEE2
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 19:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734376094;
	bh=XHY6RRaofeSqNpkhu+XLNYYsg9u82MtyFmn0jiwVWsA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=TkfX2/vrJe5kDcuLTFaUaWx08VpRm4uXSE8szVaU7qVRHQN8OZd6l1JGnQw7x4SGd
	 cNevUAUyIXyj09UZoCc15JLZ/yA+9IKRbpRnPA7u2Aa15n0TrJxLSDjHCGM+Zl+XdN
	 NQO6N60LBfGcgklotDOA1buuKzHla36A3ECkDCtWToY1PVyAPwCMZFy/2ikehq9wJA
	 8b/fYJw2tglJsLtT0t2/Flw2Hig5/j0lxPiNEbdt3WsplFeUkc6j8oiSOQkRZg41LN
	 VrvtN5Dlf7ck/2yPKf4o9P7J3grHvFHkGt2hERXeTHDBc3nwsuz+tIAq733KioZHAe
	 yPLi+pxjdKKIg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 2EFA0C41614; Mon, 16 Dec 2024 19:08:14 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218267] [Sapphire Rapids][Upstream]Boot up multiple Windows VMs
 hang
Date: Mon, 16 Dec 2024 19:08:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218267-28872-5V2mMZW0sp@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218267-28872@https.bugzilla.kernel.org/>
References: <bug-218267-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D218267

--- Comment #8 from Sean Christopherson (seanjc@google.com) ---
Thanks Chao!

Until the ucode update is available, I think we can workaround the issue in=
 KVM
by clearing VECTORING_INFO_VALID_MASK _immediately_ after exit, i.e. before
queueing the event for re-injection, if it should be impossible for the exi=
t to
have occurred while vectoring.  I'm not sure I want to carry something like
this long-term since a ucode fix is imminent, but at the least it can hopef=
ully
unblock end users.

The below uses a fairly conservative list of exits (a false positive could =
be
quite painful).  A slightly less conservative approach would be to also
include:

case EXIT_REASON_EXTERNAL_INTERRUPT:
case EXIT_REASON_TRIPLE_FAULT:
case EXIT_REASON_INIT_SIGNAL:
case EXIT_REASON_SIPI_SIGNAL:
case EXIT_REASON_INTERRUPT_WINDOW:
case EXIT_REASON_NMI_WINDOW:

as those exits should all be recognized only at instruction boundaries.

Compile tested only...

---
 arch/x86/kvm/vmx/vmx.c | 66 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 893366e53732..7240bd72b5f2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -147,6 +147,9 @@ module_param_named(preemption_timer,
enable_preemption_timer, bool, S_IRUGO);
 extern bool __read_mostly allow_smaller_maxphyaddr;
 module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);

+static bool __ro_after_init enable_spr141_erratum_workaround =3D true;
+module_param(enable_spr141_erratum_workaround, bool, S_IRUGO);
+
 #define KVM_VM_CR0_ALWAYS_OFF (X86_CR0_NW | X86_CR0_CD)
 #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR0_NE
 #define KVM_VM_CR0_ALWAYS_ON                           \
@@ -7163,8 +7166,67 @@ static void __vmx_complete_interrupts(struct kvm_vcpu
*vcpu,
        }
 }

+static bool is_vectoring_on_exit_impossible(struct vcpu_vmx *vmx)
+{
+       switch (vmx->exit_reason.basic) {
+       case EXIT_REASON_CPUID:
+       case EXIT_REASON_HLT:
+       case EXIT_REASON_INVD:
+       case EXIT_REASON_INVLPG:
+       case EXIT_REASON_RDPMC:
+       case EXIT_REASON_RDTSC:
+       case EXIT_REASON_VMCALL:
+       case EXIT_REASON_VMCLEAR:
+       case EXIT_REASON_VMLAUNCH:
+       case EXIT_REASON_VMPTRLD:
+       case EXIT_REASON_VMPTRST:
+       case EXIT_REASON_VMREAD:
+       case EXIT_REASON_VMRESUME:
+       case EXIT_REASON_VMWRITE:
+       case EXIT_REASON_VMOFF:
+       case EXIT_REASON_VMON:
+       case EXIT_REASON_CR_ACCESS:
+       case EXIT_REASON_DR_ACCESS:
+       case EXIT_REASON_IO_INSTRUCTION:
+       case EXIT_REASON_MSR_READ:
+       case EXIT_REASON_MSR_WRITE:
+       case EXIT_REASON_MSR_LOAD_FAIL:
+       case EXIT_REASON_MWAIT_INSTRUCTION:
+       case EXIT_REASON_MONITOR_TRAP_FLAG:
+       case EXIT_REASON_MONITOR_INSTRUCTION:
+       case EXIT_REASON_PAUSE_INSTRUCTION:
+       case EXIT_REASON_TPR_BELOW_THRESHOLD:
+       case EXIT_REASON_GDTR_IDTR:
+       case EXIT_REASON_LDTR_TR:
+       case EXIT_REASON_INVEPT:
+       case EXIT_REASON_RDTSCP:
+       case EXIT_REASON_PREEMPTION_TIMER:
+       case EXIT_REASON_INVVPID:
+       case EXIT_REASON_WBINVD:
+       case EXIT_REASON_XSETBV:
+       case EXIT_REASON_APIC_WRITE:
+       case EXIT_REASON_RDRAND:
+       case EXIT_REASON_INVPCID:
+       case EXIT_REASON_VMFUNC:
+       case EXIT_REASON_ENCLS:
+       case EXIT_REASON_RDSEED:
+       case EXIT_REASON_XSAVES:
+       case EXIT_REASON_XRSTORS:
+       case EXIT_REASON_UMWAIT:
+       case EXIT_REASON_TPAUSE:
+               return true;
+       }
+
+       return false;
+}
+
 static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 {
+       if ((vmx->idt_vectoring_info & VECTORING_INFO_VALID_MASK) &&
+           enable_spr141_erratum_workaround &&
+           is_vectoring_on_exit_impossible(vmx))
+               vmx->idt_vectoring_info &=3D ~VECTORING_INFO_VALID_MASK;
+
        __vmx_complete_interrupts(&vmx->vcpu, vmx->idt_vectoring_info,
                                  VM_EXIT_INSTRUCTION_LEN,
                                  IDT_VECTORING_ERROR_CODE);
@@ -8487,6 +8549,10 @@ __init int vmx_hardware_setup(void)
        if (!enable_apicv || !cpu_has_vmx_ipiv())
                enable_ipiv =3D false;

+       if (boot_cpu_data.x86_vfm !=3D INTEL_SAPPHIRERAPIDS_X &&
+           boot_cpu_data.x86_vfm !=3D INTEL_EMERALDRAPIDS_X)
+               enable_spr141_erratum_workaround =3D false;
+
        if (cpu_has_vmx_tsc_scaling())
                kvm_caps.has_tsc_control =3D true;


base-commit: 50e5669285fc2586c9f946c1d2601451d77cb49e
--

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

