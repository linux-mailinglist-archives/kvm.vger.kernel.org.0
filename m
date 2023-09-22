Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13E87AB5DF
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 18:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjIVQ2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 12:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjIVQ2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 12:28:38 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF2C139
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 09:28:31 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59c4ec85ea9so32990877b3.0
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 09:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695400110; x=1696004910; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YgMWQptUu9PpVehDy7PqussmWjS/u4yFTkwq7x9MQYo=;
        b=XYaJVG/o+90l+05pBdMQdsDeKqXXJKO0XssMAKnJskjak1GVk+fuUZTMNLw/hP55wE
         /rbbfc6C0Yf++6pgQg6uuxR4Vu/rk/Vy4RW769Aps/tmJ+46F+bevCOToCk/HAvrmGA5
         1eZopZQ6WZPpNNH/PRvQD55Bk8HXFFB/giXGoM8G7mFKSzP8gOOTK/pXKJl6sPKEOzbM
         JCmJmSYRiAYWyPLop35zr3l9rbOqi0+t+Ed2C6GgH6WDoTI57/t9FKpx0pcSQ/KYTs8Q
         BEg3h1GPePHWMaMKLOXUKnjCJ8mhSxGQ7PtswZeu0CaM6vIRe9b1iiVzhmw1hsjR6qOH
         XOvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695400110; x=1696004910;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YgMWQptUu9PpVehDy7PqussmWjS/u4yFTkwq7x9MQYo=;
        b=khmllC7wYJ2R7acWtMlJO3jvJccM11tPd7nsJc32jLPvHhF40B9GsDMb10FcQ7ku5x
         TYmOmcFA3UKA8iVODLvIT9y8aYU4l9s3m+4Op6XWJleU4g1V0yNMXmXBKrOW0xtsQ/cu
         Xck3bTddA8+UUdObrADCXPdm0MdmqPDUJ4cb9XdIYekY0/RMZ7sHyfsMSxz2kQNXJsVB
         S6WmkqiZhEcqoQKtXF4Ds2XrzBhe1tQ6KTaI2D9IoKwkl0mwnh2Z3GJbmagZMBMSBc64
         iE2IMFtso+Xq1reSj4EAt8UT0oCLJ2ZXXcZK9D/x1I1kb9P39GcmBFEb+yWq5idtSBI3
         ve9Q==
X-Gm-Message-State: AOJu0Yz99Af1E/3Fizb8fMMfUkl3WqUShG+dMtsQosXOmAA730JrrCMw
        5Gbvag1Ocwgu1r2PAmtLIKfKB+IS5eM=
X-Google-Smtp-Source: AGHT+IE+38oMtXzdyZIZade6M1a7MFSda/76kT0PzIMG2YtJmUF3WDZ37f+xy4bBW3bDBvpcst/Scy5RcJs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:dfcf:0:b0:d85:4f44:1407 with SMTP id
 w198-20020a25dfcf000000b00d854f441407mr122346ybg.8.1695400110673; Fri, 22 Sep
 2023 09:28:30 -0700 (PDT)
Date:   Fri, 22 Sep 2023 09:28:08 -0700
In-Reply-To: <117db856-9aec-e91c-b1d4-db2b90ae563d@intel.com>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-8-seanjc@google.com>
 <117db856-9aec-e91c-b1d4-db2b90ae563d@intel.com>
Message-ID: <ZQ3AmLO2SYv3DszH@google.com>
Subject: Re: [RFC PATCH v12 07/33] KVM: Add KVM_EXIT_MEMORY_FAULT exit to
 report faults to userspace
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Anish Moorthy <amoorthy@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Content-Type: multipart/mixed; charset="UTF-8"; boundary="vg/iUEEUXUvwrXq6"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--vg/iUEEUXUvwrXq6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Removing non-KVM lists/people from Cc, this is going to get way off the guest_memfd
track...

On Fri, Sep 22, 2023, Xiaoyao Li wrote:
> On 9/14/2023 9:55 AM, Sean Christopherson wrote:
> > Place "struct memory_fault" in a second anonymous union so that filling
> > memory_fault doesn't clobber state from other yet-to-be-fulfilled exits,
> > and to provide additional information if KVM does NOT ultimately exit to
> > userspace with KVM_EXIT_MEMORY_FAULT, e.g. if KVM suppresses (or worse,
> > loses) the exit, as KVM often suppresses exits for memory failures that
> > occur when accessing paravirt data structures.  The initial usage for
> > private memory will be all-or-nothing, but other features such as the
> > proposed "userfault on missing mappings" support will use
> > KVM_EXIT_MEMORY_FAULT for potentially _all_ guest memory accesses, i.e.
> > will run afoul of KVM's various quirks.
> 
> So when exit reason is KVM_EXIT_MEMORY_FAULT, how can we tell which field in
> the first union is valid?

/facepalm

At one point, I believe we had discussed a second exit reason field?  But yeah,
as is, there's no way for userspace to glean anything useful from the first union.

The more I think about this, the more I think it's a fool's errand.  Even if KVM
provides the exit_reason history, userspace can't act on the previous, unfulfilled
exit without *knowing* that it's safe/correct to process the previous exit.  I
don't see how that's remotely possible.

Practically speaking, there is one known instance of this in KVM, and it's a
rather riduclous edge case that has existed "forever".  I'm very strongly inclined
to do nothing special, and simply treat clobbering an exit that userspace actually
cares about like any other KVM bug.

> When exit reason is not KVM_EXIT_MEMORY_FAULT, how can we know the info in
> the second union run.memory is valid without a run.memory.valid field?

Anish's series adds a flag in kvm_run.flags to track whether or not memory_fault
has been filled.  The idea is that KVM would clear the flag early in KVM_RUN, and
then set the flag when memory_fault is first filled.

	/* KVM_CAP_MEMORY_FAULT_INFO flag for kvm_run.flags */
	#define KVM_RUN_MEMORY_FAULT_FILLED (1 << 8)

I didn't propose that flag here because clobbering memory_fault from the page
fault path would be a flagrant KVM bug.

Honestly, I'm becoming more and more skeptical that separating memory_fault is
worthwhile, or even desirable.  Similar to memory_fault clobbering something else,
userspace can only take action if memory_fault is clobbered if userspace somehow
knows that it's safe/correct to do so.

Even if KVM exits "immediately" after initially filling memory_fault, the fact
that KVM is exiting for a different reason (or a different memory fault) means
that KVM did *something* between filling memory_fault and actually exiting.  And
it's completely impossible for usersepace to know what that "something" was.

E.g. in the splat from selftests[1], KVM reacts to a failure during Real Mode
event injection by synthesizing a triple fault

	ret = emulate_int_real(ctxt, irq);

	if (ret != X86EMUL_CONTINUE) {
		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);

There are multiple KVM bugs at play: read_emulate() and write_emulate() incorrectly
assume *all* failures should be treated like MMIO, and conversely ->read_std() and
->write_std() don't handle *any* failures as MMIO.

Circling back to my "capturing the history is pointless" assertion, by the time
userspace gets an exit, the vCPU is already in shutdown, and KVM has clobbered
memory_fault something like five times.  There is zero chance userspace can do
anything but shed a tear for the VM and move on.

The whole "let's annotate all memory faults" idea came from my desire to push KVM
towards a future where all -EFAULT exits are annotated[2].  I still think we should
point KVM in that general direction, i.e. implement something that _can_ provide
100% "coverage" in the future, even though we don't expect to get there anytime soon.

I bring that up because neither private memory nor userfault-on-missing needs to
annotate anything other than -EFAULT during guest page faults.  I.e. all of this
paranoia about clobbering memory_fault isn't actually buying us anything other
than noise and complexity.  The cases we need to work _today_ are perfectly fine,
and _if_ some future use cases needs all/more paths to be 100% accurate, then the
right thing to do is to make whatever changes are necessary for KVM to be 100%
accurate.

In other words, trying to gracefully handle memory_fault clobbering is pointless.
KVM either needs to guarantee there's no clobbering (guest page fault paths) or
treat the annotation as best effort and informational-only (everything else at
this time).  Future features may grow the set of paths that needs strong guarantees,
but that just means fixing more paths and treating any violation of the contract
like any other KVM bug.

And if we stop being unnecessarily paranoid, KVM_RUN_MEMORY_FAULT_FILLED can also
go away.  The flag came about in part because *unconditionally* sanitizing
kvm_run.exit_reason at the start of KVM_RUN would break KVM's ABI, as userspace
may rely on the exit_reason being preserved when calling back into KVM to complete
userspace I/O (or MMIO)[3].  But the goal is purely to avoid exiting with stale
memory_fault information, not to sanitize every other existing exit_reason, and
that can be achieved by simply making the reset conditional.

Somewhat of a tangent, I think we should add KVM_CAP_MEMORY_FAULT_INFO if the
KVM_EXIT_MEMORY_FAULT supports comes in with guest_memfd.

Unless someone comes up with a good argument for keeping the paranoid behavior,
I'll post the below patch as fixup for the guest_memfd series, and work with Anish
to massage the attached patch (result of the below being sqaushed) in case his
series lands first.

[1] https://lore.kernel.org/all/202309141107.30863e9d-oliver.sang@intel.com
[2] https://lore.kernel.org/all/Y+6iX6a22+GEuH1b@google.com
[3] https://lore.kernel.org/all/ZFFbwOXZ5uI%2Fgdaf@google.com

---
 Documentation/virt/kvm/api.rst | 21 +++++++++++++++++++
 arch/x86/kvm/x86.c             |  1 +
 include/uapi/linux/kvm.h       | 37 ++++++++++------------------------
 virt/kvm/kvm_main.c            | 10 +++++++++
 4 files changed, 43 insertions(+), 26 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 5e08f2a157ef..d5c9e46e2d12 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7829,6 +7829,27 @@ This capability is aimed to mitigate the threat that malicious VMs can
 cause CPU stuck (due to event windows don't open up) and make the CPU
 unavailable to host or other VMs.
 
+7.34 KVM_CAP_MEMORY_FAULT_INFO
+------------------------------
+
+:Architectures: x86
+:Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
+
+The presence of this capability indicates that KVM_RUN *may* fill
+kvm_run.memory_fault in response to failed guest memory accesses in a vCPU
+context.  KVM only guarantees that errors that occur when handling guest page
+fault VM-Exits will be annotated, all other error paths are best effort.
+
+The information in kvm_run.memory_fault is valid if and only if KVM_RUN returns
+an error with errno=EFAULT or errno=EHWPOISON *and* kvm_run.exit_reason is set
+to KVM_EXIT_MEMORY_FAULT.
+
+Note: Userspaces which attempt to resolve memory faults so that they can retry
+KVM_RUN are encouraged to guard against repeatedly receiving the same
+error/annotated fault.
+
+See KVM_EXIT_MEMORY_FAULT for more information.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 767236b4d771..e25076fdd720 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4525,6 +4525,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 	case KVM_CAP_IRQFD_RESAMPLE:
+	case KVM_CAP_MEMORY_FAULT_INFO:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 65fc983af840..7f0ee6475141 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -525,6 +525,13 @@ struct kvm_run {
 #define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
 			__u32 flags;
 		} notify;
+		/* KVM_EXIT_MEMORY_FAULT */
+		struct {
+#define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
+			__u64 flags;
+			__u64 gpa;
+			__u64 size;
+		} memory_fault;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -546,29 +553,6 @@ struct kvm_run {
 		struct kvm_sync_regs regs;
 		char padding[SYNC_REGS_SIZE_BYTES];
 	} s;
-
-	/*
-	 * This second exit union holds structs for exit types which may be
-	 * triggered after KVM has already initiated a different exit, or which
-	 * may be ultimately dropped by KVM.
-	 *
-	 * For example, because of limitations in KVM's uAPI, KVM x86 can
-	 * generate a memory fault exit an MMIO exit is initiated (exit_reason
-	 * and kvm_run.mmio are filled).  And conversely, KVM often disables
-	 * paravirt features if a memory fault occurs when accessing paravirt
-	 * data instead of reporting the error to userspace.
-	 */
-	union {
-		/* KVM_EXIT_MEMORY_FAULT */
-		struct {
-#define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
-			__u64 flags;
-			__u64 gpa;
-			__u64 size;
-		} memory_fault;
-		/* Fix the size of the union. */
-		char padding2[256];
-	};
 };
 
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
@@ -1231,9 +1215,10 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
 #define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
 #define KVM_CAP_USER_MEMORY2 230
-#define KVM_CAP_MEMORY_ATTRIBUTES 231
-#define KVM_CAP_GUEST_MEMFD 232
-#define KVM_CAP_VM_TYPES 233
+#define KVM_CAP_MEMORY_FAULT_INFO 231
+#define KVM_CAP_MEMORY_ATTRIBUTES 232
+#define KVM_CAP_GUEST_MEMFD 233
+#define KVM_CAP_VM_TYPES 234
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 96fc609459e3..d78e97b527e5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4450,6 +4450,16 @@ static long kvm_vcpu_ioctl(struct file *filp,
 				synchronize_rcu();
 			put_pid(oldpid);
 		}
+
+		/*
+		 * Reset the exit reason if the previous userspace exit was due
+		 * to a memory fault.  Not all -EFAULT exits are annotated, and
+		 * so leaving exit_reason set to KVM_EXIT_MEMORY_FAULT could
+		 * result in feeding userspace stale information.
+		 */
+		if (vcpu->run->exit_reason == KVM_EXIT_MEMORY_FAULT)
+			vcpu->run->exit_reason = KVM_EXIT_UNKNOWN
+
 		r = kvm_arch_vcpu_ioctl_run(vcpu);
 		trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
 		break;

base-commit: 67aa951d727ad2715f7ad891929f18b7f2567a0f
-- 


--vg/iUEEUXUvwrXq6
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-Add-KVM_EXIT_MEMORY_FAULT-exit-to-report-faults-.patch"

From ca887b5ed3b344562411cf2876a68a82bd0f584b Mon Sep 17 00:00:00 2001
From: Chao Peng <chao.p.peng@linux.intel.com>
Date: Wed, 13 Sep 2023 18:55:05 -0700
Subject: [PATCH] KVM: Add KVM_EXIT_MEMORY_FAULT exit to report faults to
 userspace

Add a new KVM exit type to allow userspace to handle memory faults that
KVM cannot resolve, but that userspace *may* be able to handle (without
terminating the guest).

KVM will initially use KVM_EXIT_MEMORY_FAULT to report implicit
conversions between private and shared memory.  With guest private memory,
there will be  two kind of memory conversions:

  - explicit conversion: happens when the guest explicitly calls into KVM
    to map a range (as private or shared)

  - implicit conversion: happens when the guest attempts to access a gfn
    that is configured in the "wrong" state (private vs. shared)

On x86 (first architecture to support guest private memory), explicit
conversions will be reported via KVM_EXIT_HYPERCALL+KVM_HC_MAP_GPA_RANGE,
but reporting KVM_EXIT_HYPERCALL for implicit conversions is undesriable
as there is (obviously) no hypercall, and there is no guarantee that the
guest actually intends to convert between private and shared, i.e. what
KVM thinks is an implicit conversion "request" could actually be the
result of a guest code bug.

KVM_EXIT_MEMORY_FAULT will be used to report memory faults that appear to
be implicit conversions.

Use bit 3 for flagging private memory so that KVM can use bits 0-2 for
capturing RWX behavior if/when userspace needs such information.

Add a new capability, KVM_CAP_MEMORY_FAULT_INFO, to advertise support for
KVM_EXIT_MEMORY_FAULT.  There is at least one other in-flight use case for
using KVM_EXIT_MEMORY_FAULT+memory_fault to resolve faults in userspace,
providing a dedicated capability allows userspace to query KVM support for
annotating faults without having to depend on an unrelated feature, i.e.
the proposed userfault-on-missing functionality shouldn't have to depend
on private memory support.

Note!  To allow for future possibilities where KVM reports
KVM_EXIT_MEMORY_FAULT and fills run->memory_fault on _any_ unresolved
fault, KVM returns "-EFAULT" (-1 with errno == EFAULT from userspace's
perspective), not '0'!  Due to historical baggage within KVM, exiting to
userspace with '0' from deep callstacks, e.g. in emulation paths, is
infeasible as doing so would require a near-complete overhaul of KVM,
whereas KVM already propagates -errno return codes to userspace even when
the -errno originated in a low level helper.

Returning an errno will also allow KVM to differentiate hardware poisoned
memory errors, i.e. by returning with errno=EHWPOISON.

Link: https://lore.kernel.org/all/20230908222905.1321305-5-amoorthy@google.com
Cc: Anish Moorthy <amoorthy@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Yu Zhang <yu.c.zhang@linux.intel.com>
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Co-developed-by: Anish Moorthy <amoorthy@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst | 45 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c             |  1 +
 include/linux/kvm_host.h       | 15 ++++++++++++
 include/uapi/linux/kvm.h       |  9 +++++++
 virt/kvm/kvm_main.c            | 10 ++++++++
 5 files changed, 80 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 21a7578142a1..63347d0add3b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6702,6 +6702,30 @@ array field represents return values. The userspace should update the return
 values of SBI call before resuming the VCPU. For more details on RISC-V SBI
 spec refer, https://github.com/riscv/riscv-sbi-doc.
 
+::
+
+		/* KVM_EXIT_MEMORY_FAULT */
+		struct {
+  #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
+			__u64 flags;
+			__u64 gpa;
+			__u64 size;
+		} memory;
+
+KVM_EXIT_MEMORY_FAULT indicates the vCPU has encountered a memory fault that
+could not be resolved by KVM.  The 'gpa' and 'size' (in bytes) describe the
+guest physical address range [gpa, gpa + size) of the fault.  The 'flags' field
+describes properties of the faulting access that are likely pertinent:
+
+ - KVM_MEMORY_EXIT_FLAG_PRIVATE - When set, indicates the memory fault occurred
+   on a private memory access.  When clear, indicates the fault occurred on a
+   shared access.
+
+Note!  KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in that it
+accompanies a return code of '-1', not '0'!  errno will always be set to EFAULT
+or EHWPOISON when KVM exits with KVM_EXIT_MEMORY_FAULT, userspace should assume
+kvm_run.exit_reason is stale/undefined for all other error numbers.
+
 ::
 
     /* KVM_EXIT_NOTIFY */
@@ -7736,6 +7760,27 @@ This capability is aimed to mitigate the threat that malicious VMs can
 cause CPU stuck (due to event windows don't open up) and make the CPU
 unavailable to host or other VMs.
 
+7.34 KVM_CAP_MEMORY_FAULT_INFO
+------------------------------
+
+:Architectures: x86
+:Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
+
+The presence of this capability indicates that KVM_RUN *may* fill
+kvm_run.memory_fault in response to failed guest memory accesses in a vCPU
+context.  KVM only guarantees that errors that occur when handling guest page
+fault VM-Exits will be annotated, all other error paths are best effort.
+
+The information in kvm_run.memory_fault is valid if and only if KVM_RUN returns
+an error with errno=EFAULT or errno=EHWPOISON *and* kvm_run.exit_reason is set
+to KVM_EXIT_MEMORY_FAULT.
+
+Note: Userspaces which attempt to resolve memory faults so that they can retry
+KVM_RUN are encouraged to guard against repeatedly receiving the same
+error/annotated fault.
+
+See KVM_EXIT_MEMORY_FAULT for more information.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8356907079e1..f58df6efffa4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4518,6 +4518,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 	case KVM_CAP_IRQFD_RESAMPLE:
+	case KVM_CAP_MEMORY_FAULT_INFO:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4e741ff27af3..d8c6ce6c8211 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2327,4 +2327,19 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
+						 gpa_t gpa, gpa_t size,
+						 bool is_write, bool is_exec,
+						 bool is_private)
+{
+	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
+	vcpu->run->memory_fault.gpa = gpa;
+	vcpu->run->memory_fault.size = size;
+
+	/* RWX flags are not (yet) defined or communicated to userspace. */
+	vcpu->run->memory_fault.flags = 0;
+	if (is_private)
+		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
+}
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index bd1abe067f28..5239d3fc1082 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -274,6 +274,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_SBI        35
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
+#define KVM_EXIT_MEMORY_FAULT     38
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -520,6 +521,13 @@ struct kvm_run {
 #define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
 			__u32 flags;
 		} notify;
+		/* KVM_EXIT_MEMORY_FAULT */
+		struct {
+#define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
+			__u64 flags;
+			__u64 gpa;
+			__u64 size;
+		} memory_fault;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -1203,6 +1211,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
 #define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
 #define KVM_CAP_USER_MEMORY2 230
+#define KVM_CAP_MEMORY_FAULT_INFO 231
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7c0e38752526..d13b646188e5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4184,6 +4184,16 @@ static long kvm_vcpu_ioctl(struct file *filp,
 				synchronize_rcu();
 			put_pid(oldpid);
 		}
+
+		/*
+		 * Reset the exit reason if the previous userspace exit was due
+		 * to a memory fault.  Not all -EFAULT exits are annotated, and
+		 * so leaving exit_reason set to KVM_EXIT_MEMORY_FAULT could
+		 * result in feeding userspace stale information.
+		 */
+		if (vcpu->run->exit_reason == KVM_EXIT_MEMORY_FAULT)
+			vcpu->run->exit_reason = KVM_EXIT_UNKNOWN
+
 		r = kvm_arch_vcpu_ioctl_run(vcpu);
 		trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
 		break;

base-commit: 2358793cd9062b068ac25ac9c965c00d685eea92
-- 
2.42.0.515.g380fc7ccd1-goog


--vg/iUEEUXUvwrXq6--
