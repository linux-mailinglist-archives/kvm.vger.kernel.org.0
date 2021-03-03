Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CEA32C658
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1451003AbhCDA2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:28:34 -0500
Received: from 8bytes.org ([81.169.241.247]:57288 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242977AbhCCOSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 09:18:25 -0500
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 4A6AF20C;
        Wed,  3 Mar 2021 15:17:22 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 0/5 v2] x86/sev-es: SEV-ES Fixes for v5.12
Date:   Wed,  3 Mar 2021 15:17:11 +0100
Message-Id: <20210303141716.29223-1-joro@8bytes.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

here are a couple of fixes for 5.12 in the SEV-ES guest support code.
Patches 1-3 have in a similar form already been posted, so this is v2.
The last two patches are new an arose from me running an SEV-ES guest
with more debugging features and instrumentation enabled.  I changed
the first patches according to the review comments I received.

Please review.

Thanks,

	Joerg

Joerg Roedel (5):
  x86/sev-es: Introduce ip_within_syscall_gap() helper
  x86/sev-es: Check if regs->sp is trusted before adjusting #VC IST
    stack
  x86/sev-es: Optimize __sev_es_ist_enter() for better readability
  x86/sev-es: Correctly track IRQ states in runtime #VC handler
  x86/sev-es: Use __copy_from_user_inatomic()

 arch/x86/entry/entry_64_compat.S |  2 +
 arch/x86/include/asm/insn-eval.h |  2 +
 arch/x86/include/asm/proto.h     |  1 +
 arch/x86/include/asm/ptrace.h    | 15 ++++++++
 arch/x86/kernel/sev-es.c         | 58 ++++++++++++++++++++--------
 arch/x86/kernel/traps.c          |  3 +-
 arch/x86/lib/insn-eval.c         | 66 +++++++++++++++++++++++++-------
 7 files changed, 114 insertions(+), 33 deletions(-)

-- 
2.30.1

