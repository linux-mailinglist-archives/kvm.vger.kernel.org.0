Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456F47D9B98
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 16:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345987AbjJ0OjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 10:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345871AbjJ0OjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 10:39:00 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973EA187;
        Fri, 27 Oct 2023 07:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698417537; x=1729953537;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=15oAMppkHxqFcvZpRQVCeqFUeFGfKOHfvAhV5S36eVA=;
  b=IeIjOmNy4vvJu8wRXRympgWFH5OTXazFsTJ8FAsnHeTidex6aw0sTExf
   gbK0XJF3Ceaw+xi034Vsbl3lopiJVyVntJa+UQWQD6bmmWSIR+tjzo5VM
   cW+akqnaruIiSeNh/GnlYDuum80YR9J2AJgKYnc2ZwKKIjxSic79K6okG
   +F7Ub1OpJnl02ozUn+hdSEJOvxMUr6JVvcJxl0s8MlX91jGgPWstn+k2W
   ewy5qroj06250duHhMeFFBt/4Q+8YH9DUS4uIvzplaTF+qYXJrEIlT0nf
   ubKDdqgXA6oanSiG0Yxz/Zs8PAeywIuyivuA8DbZV8mji3YvJeBj8TPmj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="386670100"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="386670100"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 07:38:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="812616"
Received: from dmnassar-mobl.amr.corp.intel.com (HELO desk) ([10.212.203.39])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 07:37:59 -0700
Date:   Fri, 27 Oct 2023 07:38:34 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Nikolay Borisov <nik.borisov@suse.com>
Cc:     linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Alyssa Milburn <alyssa.milburn@intel.com>,
        Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH v4 0/6] Delay VERW
Message-ID: <20231027-delay-verw-v4-0-9a3622d4bcf7@linux.intel.com>
X-B4-Tracking: v=1; b=H4sIABTEO2UC/23MTQ6CMBhF0a2Yji3pf4sj92EcYPkqTRBMwQoh7
 N2mTiA6fDd5Z0EDBA8DOh0WFCD6wfddGuJ4QLapujtgX6eNGGGcEkpxDW014wjhjWsitCiNujH
 LUTo8Azg/ZeyC0DWVxg9jH+asR5r7F2JkC0WKCbbOSUFKxZmqz63vXlPhuxHawvaPjEW2BcQOY
 Alw1BjKBbGG6P8A3wJyB/AESKYUV1oDcPkLrOv6AXtbl6wuAQAA
X-Mailer: b4 0.12.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.3 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v4:
- Fill unused part of mds_verw_sel cacheline with int3. (Andrew)
- Fix the formatting in documentation (0-day CI).
- s/inspite/in spite/ (Sean).
- Explicitly skip FB_CLEAR optimization when MDS affected (Sean).

v3: https://lore.kernel.org/r/20231025-delay-verw-v3-0-52663677ee35@linux.intel.com
- Use .entry.text section for VERW memory operand. (Andrew/PeterZ)
- Fix the duplicate header inclusion. (Chao)

v2: https://lore.kernel.org/r/20231024-delay-verw-v2-0-f1881340c807@linux.intel.com
- Removed the extra EXEC_VERW macro layers. (Sean)
- Move NOPL before VERW. (Sean)
- s/USER_CLEAR_CPU_BUFFERS/CLEAR_CPU_BUFFERS/. (Josh/Dave)
- Removed the comments before CLEAR_CPU_BUFFERS. (Josh)
- Remove CLEAR_CPU_BUFFERS from NMI returning to kernel and document the
  reason. (Josh/Dave)
- Reformat comment in md_clear_update_mitigation(). (Josh)
- Squash "x86/bugs: Cleanup mds_user_clear" patch. (Nikolay)
- s/GUEST_CLEAR_CPU_BUFFERS/CLEAR_CPU_BUFFERS/. (Josh)
- Added a patch from Sean to use CFLAGS.CF for VMLAUNCH/VMRESUME
  selection. This facilitates a single CLEAR_CPU_BUFFERS location for both
  VMLAUNCH and VMRESUME. (Sean)

v1: https://lore.kernel.org/r/20231020-delay-verw-v1-0-cff54096326d@linux.intel.com

Hi,

Legacy instruction VERW was overloaded by some processors to clear
micro-architectural CPU buffers as a mitigation of CPU bugs. This series
moves VERW execution to a later point in exit-to-user path. This is
needed because in some cases it may be possible for kernel data to be
accessed after VERW in arch_exit_to_user_mode(). Such accesses may put
data into MDS affected CPU buffers, for example:

  1. Kernel data accessed by an NMI between VERW and return-to-user can
     remain in CPU buffers (since NMI returning to kernel does not
     execute VERW to clear CPU buffers).
  2. Alyssa reported that after VERW is executed,
     CONFIG_GCC_PLUGIN_STACKLEAK=y scrubs the stack used by a system
     call. Memory accesses during stack scrubbing can move kernel stack
     contents into CPU buffers.
  3. When caller saved registers are restored after a return from
     function executing VERW, the kernel stack accesses can remain in
     CPU buffers(since they occur after VERW).

Although these cases are less practical to exploit, moving VERW closer
to ring transition reduces the attack surface.

Overview of the series:

Patch 1: Prepares VERW macros for use in asm.
Patch 2: Adds macros to 64-bit entry/exit points.
Patch 3: Adds macros to 32-bit entry/exit points.
Patch 4: Enables the new macros.
Patch 5: Uses CFLAGS.CF for VMLAUNCH/VMRESUME selection.
Patch 6: Adds macro to VMenter.

Below is some performance data collected on a Skylake client
compared with previous implementation:

Baseline: v6.6-rc5

| Test               | Configuration          | v1   | v3   |
| ------------------ | ---------------------- | ---- | ---- |
| build-linux-kernel | defconfig              | 1.00 | 1.00 |
| hackbench          | 32 - Process           | 1.02 | 1.06 |
| nginx              | Short Connection - 500 | 1.01 | 1.04 |

Cc: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: Alyssa Milburn <alyssa.milburn@linux.intel.com>
Cc: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Cc: antonio.gomez.iglesias@linux.intel.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
To: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@linux.intel.com>
To: x86@kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
To: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
To: Andy Lutomirski <luto@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
To: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
To: tony.luck@intel.com
To: ak@linux.intel.com
To: tim.c.chen@linux.intel.com
To: Andrew Cooper <andrew.cooper3@citrix.com>
To: Nikolay Borisov <nik.borisov@suse.com>

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
Pawan Gupta (5):
      x86/bugs: Add asm helpers for executing VERW
      x86/entry_64: Add VERW just before userspace transition
      x86/entry_32: Add VERW just before userspace transition
      x86/bugs: Use ALTERNATIVE() instead of mds_user_clear static key
      KVM: VMX: Move VERW closer to VMentry for MDS mitigation

Sean Christopherson (1):
      KVM: VMX: Use BT+JNC, i.e. EFLAGS.CF to select VMRESUME vs. VMLAUNCH

 Documentation/arch/x86/mds.rst       | 38 +++++++++++++++++++++++++-----------
 arch/x86/entry/entry.S               | 17 ++++++++++++++++
 arch/x86/entry/entry_32.S            |  3 +++
 arch/x86/entry/entry_64.S            | 11 +++++++++++
 arch/x86/entry/entry_64_compat.S     |  1 +
 arch/x86/include/asm/cpufeatures.h   |  2 +-
 arch/x86/include/asm/entry-common.h  |  1 -
 arch/x86/include/asm/nospec-branch.h | 27 +++++++++++++------------
 arch/x86/kernel/cpu/bugs.c           | 15 ++++++--------
 arch/x86/kernel/nmi.c                |  2 --
 arch/x86/kvm/vmx/run_flags.h         |  7 +++++--
 arch/x86/kvm/vmx/vmenter.S           |  9 ++++++---
 arch/x86/kvm/vmx/vmx.c               | 19 +++++++++++++-----
 13 files changed, 106 insertions(+), 46 deletions(-)
---
base-commit: 05d3ef8bba77c1b5f98d941d8b2d4aeab8118ef1
change-id: 20231011-delay-verw-d0474986b2c3

Best regards,
-- 
Thanks,
Pawan


