Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAF6768C89
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 09:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjGaHCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 03:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjGaHB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 03:01:59 -0400
Received: from mgamail.intel.com (unknown [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C6D136;
        Mon, 31 Jul 2023 00:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690786917; x=1722322917;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2x+aDBKIgjBRpBNelsbYxqc0kMz8OS2Y/LweincpM90=;
  b=gRsBxE9Sm7X3LlawcVR4PKUJCtm1PkQDLbQfAxN1s6hiJ64PQlapwvQ3
   cjCbxZqciFj++WGN+YxsGT86QTYmJYlz7x5B/GH/nyxeFWcJY/ZdSMixF
   E1f1YsWmdWioq/zG/eOwn3iIMvgHg1Jd3E4km4zhRwr2iYuMuz95g3n84
   2CVS4Nrs2FQo1X0YyZ3+GlGGLqlrZ/1rrpeLe3CHHd5j3tFAEEop9nFiS
   UaxXcvmXHKsqdMwyO88m2b/zLjP9O2iI9g4S69mVkiF5v1x5k6FQGEhIu
   V4oBucdSLb5oS4tT+1+WxRuLQbV9uLkYIJSUF2eKi/Snho1dPfEUa4uZn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10787"; a="371648571"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="371648571"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 00:01:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="871543329"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga001.fm.intel.com with ESMTP; 31 Jul 2023 00:01:50 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Xin Li <xin3.li@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Liam R . Howlett" <Liam.Howlett@Oracle.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Breno Leitao <leitao@debian.org>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Brian Gerst <brgerst@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ze Gao <zegao2021@gmail.com>, Fei Li <fei1.li@intel.com>,
        Conghui <conghui.chen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Yantengsi <siyanteng@loongson.cn>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sathvika Vasireddy <sv@linux.ibm.com>
Subject: [PATCH v9 00/36] x86: enable FRED for x86-64
Date:   Sun, 30 Jul 2023 23:32:41 -0700
Message-Id: <20230731063317.3720-1-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set enables the Intel flexible return and event delivery
(FRED) architecture for x86-64.

The FRED architecture defines simple new transitions that change
privilege level (ring transitions). The FRED architecture was
designed with the following goals:

1) Improve overall performance and response time by replacing event
   delivery through the interrupt descriptor table (IDT event
   delivery) and event return by the IRET instruction with lower
   latency transitions.

2) Improve software robustness by ensuring that event delivery
   establishes the full supervisor context and that event return
   establishes the full user context.

The new transitions defined by the FRED architecture are FRED event
delivery and, for returning from events, two FRED return instructions.
FRED event delivery can effect a transition from ring 3 to ring 0, but
it is used also to deliver events incident to ring 0. One FRED
instruction (ERETU) effects a return from ring 0 to ring 3, while the
other (ERETS) returns while remaining in ring 0. Collectively, FRED
event delivery and the FRED return instructions are FRED transitions.

Search for the latest FRED spec in most search engines with this search pattern:

  site:intel.com FRED (flexible return and event delivery) specification

As of now there is no publicly avaiable CPU supporting FRED, thus the Intel
Simics® Simulator is used as software development and testing vehicles. And
it can be downloaded from:
  https://www.intel.com/content/www/us/en/developer/articles/tool/simics-simulator.html

To enable FRED, the Simics package 8112 QSP-CPU needs to be installed with CPU
model configured as:
	$cpu_comp_class = "x86-experimental-fred"


Changes since v8:
* Move the FRED initialization patch after all required changes are in
  place (Thomas Gleixner).
* Don't do syscall early out in fred_entry_from_user() before there are
  proper performance numbers and justifications (Thomas Gleixner).
* Add the control exception handler to the FRED exception handler table
  (Thomas Gleixner).
* Introduce a macro sysvec_install() to derive the asm handler name from
  a C handler, which simplifies the code and avoids an ugly typecast
  (Thomas Gleixner).
* Remove junk code that assumes no local APIC on x86_64 (Thomas Gleixner).
* Put IDTENTRY changes in a separate patch (Thomas Gleixner).
* Use high-order 48 bits above the lowest 16 bit SS only when FRED is
  enabled (Thomas Gleixner).
* Explain why writing directly to the IA32_KERNEL_GS_BASE MSR is
  doing the right thing (Thomas Gleixner).
* Reword some patch descriptions (Thomas Gleixner).
* Add a new macro VMX_DO_FRED_EVENT_IRQOFF for FRED instead of
  refactoring VMX_DO_EVENT_IRQOFF (Sean Christopherson).
* Do NOT use a trampoline, just LEA+PUSH the return RIP, PUSH the error
  code, and jump to the FRED kernel entry point for NMI or call
  external_interrupt() for IRQs (Sean Christopherson).
* Call external_interrupt() only when FRED is enabled, and convert the
  non-FRED handling to external_interrupt() after FRED lands (Sean
  Christopherson).
* Use __packed instead of __attribute__((__packed__)) (Borislav Petkov).
* Put all comments above the members, like the rest of the file does
  (Borislav Petkov).
* Reflect the FRED spec 5.0 change that ERETS and ERETU add 8 to %rsp
  before popping the return context from the stack.
* Reflect stack frame definition changes from FRED spec 3.0 to 5.0.
* Add ENDBR to the FRED_ENTER asm macro after kernel IBT is added to
  FRED base line in FRED spec 5.0.
* Add a document which briefly introduces FRED features.
* Remove 2 patches, "allow FRED systems to use interrupt vectors
  0x10-0x1f" and "allow dynamic stack frame size", from this patch set,
  as they are "optimizations" only.
* Send 2 patches, "header file for event types" and "do not modify the
  DPL bits for a null selector", as pre-FRED patches.

Changes since v7:
* Always call external_interrupt() for VMX IRQ handling on x86_64, thus avoid
  re-entering the noinstr code.
* Create a FRED stack frame when FRED is compiled-in but not enabled, which
  uses some extra stack space but simplifies the code.
* Add a log message when FRED is enabled.

Changes since v6:
* Add a comment to explain why it is safe to write to a previous FRED stack
  frame. (Lai Jiangshan).
* Export fred_entrypoint_kernel(), required when kvm-intel built as a module.
* Reserve a REDZONE for CALL emulation and Align RSP to a 64-byte boundary
  before pushing a new FRED stack frame.
* Replace pt_regs csx flags prefix FRED_CSL_ with FRED_CSX_.

Changes since v5:
* Initialize system_interrupt_handlers with dispatch_table_spurious_interrupt()
  instead of NULL to get rid of a branch (Peter Zijlstra).
* Disallow #DB inside #MCE for robustness sake (Peter Zijlstra).
* Add a comment for FRED stack level settings (Lai Jiangshan).
* Move the NMI bit from an invalid stack frame, which caused ERETU to fault,
  to the fault handler's stack frame, thus to unblock NMI ASAP if NMI is blocked
  (Lai Jiangshan).
* Refactor VMX_DO_EVENT_IRQOFF to handle IRQ/NMI in IRQ/NMI induced VM exits
  when FRED is enabled (Sean Christopherson).

Changes since v4:
* Do NOT use the term "injection", which in the KVM context means to
  reinject an event into the guest (Sean Christopherson).
* Add the explanation of why to execute "int $2" to invoke the NMI handler
  in NMI caused VM exits (Sean Christopherson).
* Use cs/ss instead of csx/ssx when initializing the pt_regs structure
  for calling external_interrupt(), otherwise it breaks i386 build.

Changes since v3:
* Call external_interrupt() to handle IRQ in IRQ caused VM exits.
* Execute "int $2" to handle NMI in NMI caused VM exits.
* Rename csl/ssl of the pt_regs structure to csx/ssx (x for extended)
  (Andrew Cooper).

Changes since v2:
* Improve comments for changes in arch/x86/include/asm/idtentry.h.

Changes since v1:
* call irqentry_nmi_{enter,exit}() in both IDT and FRED debug fault kernel
  handler (Peter Zijlstra).
* Initialize a FRED exception handler to fred_bad_event() instead of NULL
  if no FRED handler defined for an exception vector (Peter Zijlstra).
* Push calling irqentry_{enter,exit}() and instrumentation_{begin,end}()
  down into individual FRED exception handlers, instead of in the dispatch
  framework (Peter Zijlstra).

H. Peter Anvin (Intel) (22):
  x86/fred: Add Kconfig option for FRED (CONFIG_X86_FRED)
  x86/fred: Disable FRED support if CONFIG_X86_FRED is disabled
  x86/cpufeatures: Add the cpu feature bit for FRED
  x86/opcode: Add ERETU, ERETS instructions to x86-opcode-map
  x86/objtool: Teach objtool about ERETU and ERETS
  x86/cpu: Add X86_CR4_FRED macro
  x86/cpu: Add MSR numbers for FRED configuration
  x86/fred: Make unions for the cs and ss fields in struct pt_regs
  x86/fred: Add a new header file for FRED definitions
  x86/fred: Reserve space for the FRED stack frame
  x86/fred: Update MSR_IA32_FRED_RSP0 during task switch
  x86/fred: Let ret_from_fork_asm() jmp to fred_exit_user when FRED is
    enabled
  x86/fred: Disallow the swapgs instruction when FRED is enabled
  x86/fred: No ESPFIX needed when FRED is enabled
  x86/fred: Allow single-step trap and NMI when starting a new task
  x86/fred: Add a page fault entry stub for FRED
  x86/fred: Add a debug fault entry stub for FRED
  x86/fred: Add a NMI entry stub for FRED
  x86/traps: Add a system interrupt handler table for system interrupt
    dispatch
  x86/traps: Add external_interrupt() to dispatch external interrupts
  x86/fred: FRED entry/exit and dispatch code
  x86/fred: FRED initialization code

Xin Li (14):
  Documentation/x86/64: Add documentation for FRED
  x86/fred: Define a common function type fred_handler
  x86/fred: Add a machine check entry stub for FRED
  x86/fred: Add a double fault entry stub for FRED
  x86/entry: Remove idtentry_sysvec from entry_{32,64}.S
  x86/idtentry: Incorporate definitions/declarations of the FRED
    external interrupt handler type
  x86/traps: Add sysvec_install() to install a system interrupt handler
  x86/idtentry: Incorporate declaration/definition of the FRED exception
    handler type
  x86/fred: Fixup fault on ERETU by jumping to fred_entrypoint_user
  x86/traps: Export external_interrupt() for handling IRQ in IRQ induced
    VM exits
  x86/fred: Export fred_entrypoint_kernel() for handling NMI in NMI
    induced VM exits
  KVM: VMX: Add VMX_DO_FRED_EVENT_IRQOFF for IRQ/NMI handling
  x86/syscall: Split IDT syscall setup code into idt_syscall_init()
  x86/fred: Disable FRED by default in its early stage

 .../admin-guide/kernel-parameters.txt         |   4 +
 Documentation/arch/x86/x86_64/fred.rst        | 102 ++++++++
 Documentation/arch/x86/x86_64/index.rst       |   1 +
 arch/x86/Kconfig                              |   9 +
 arch/x86/entry/Makefile                       |   5 +-
 arch/x86/entry/entry_32.S                     |   4 -
 arch/x86/entry/entry_64.S                     |  14 +-
 arch/x86/entry/entry_64_fred.S                |  58 +++++
 arch/x86/entry/entry_fred.c                   | 220 ++++++++++++++++++
 arch/x86/entry/vsyscall/vsyscall_64.c         |   2 +-
 arch/x86/include/asm/asm-prototypes.h         |   1 +
 arch/x86/include/asm/cpufeatures.h            |   1 +
 arch/x86/include/asm/disabled-features.h      |   8 +-
 arch/x86/include/asm/extable_fixup_types.h    |   4 +-
 arch/x86/include/asm/fred.h                   | 157 +++++++++++++
 arch/x86/include/asm/idtentry.h               | 115 ++++++++-
 arch/x86/include/asm/msr-index.h              |  13 +-
 arch/x86/include/asm/ptrace.h                 |  57 ++++-
 arch/x86/include/asm/switch_to.h              |  11 +-
 arch/x86/include/asm/thread_info.h            |  12 +-
 arch/x86/include/asm/traps.h                  |  23 ++
 arch/x86/include/uapi/asm/processor-flags.h   |   2 +
 arch/x86/kernel/Makefile                      |   1 +
 arch/x86/kernel/cpu/acrn.c                    |   5 +-
 arch/x86/kernel/cpu/common.c                  |  47 +++-
 arch/x86/kernel/cpu/mce/core.c                |  15 ++
 arch/x86/kernel/cpu/mshyperv.c                |  16 +-
 arch/x86/kernel/espfix_64.c                   |   8 +
 arch/x86/kernel/fred.c                        |  67 ++++++
 arch/x86/kernel/irqinit.c                     |   7 +-
 arch/x86/kernel/kvm.c                         |   2 +-
 arch/x86/kernel/nmi.c                         |  19 ++
 arch/x86/kernel/process_64.c                  |  31 ++-
 arch/x86/kernel/traps.c                       | 153 ++++++++++--
 arch/x86/kvm/vmx/vmenter.S                    |  88 +++++++
 arch/x86/kvm/vmx/vmx.c                        |  19 +-
 arch/x86/lib/x86-opcode-map.txt               |   2 +-
 arch/x86/mm/extable.c                         |  79 +++++++
 arch/x86/mm/fault.c                           |  18 +-
 drivers/xen/events/events_base.c              |   3 +-
 tools/arch/x86/include/asm/cpufeatures.h      |   1 +
 .../arch/x86/include/asm/disabled-features.h  |   8 +-
 tools/arch/x86/include/asm/msr-index.h        |  13 +-
 tools/arch/x86/lib/x86-opcode-map.txt         |   2 +-
 tools/objtool/arch/x86/decode.c               |  19 +-
 45 files changed, 1348 insertions(+), 98 deletions(-)
 create mode 100644 Documentation/arch/x86/x86_64/fred.rst
 create mode 100644 arch/x86/entry/entry_64_fred.S
 create mode 100644 arch/x86/entry/entry_fred.c
 create mode 100644 arch/x86/include/asm/fred.h
 create mode 100644 arch/x86/kernel/fred.c

-- 
2.34.1

