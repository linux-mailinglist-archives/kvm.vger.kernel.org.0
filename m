Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312B6429A14
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235433AbhJLAIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:08:37 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51392 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbhJLAIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:25 -0400
Message-ID: <20211011223611.964445769@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=y4+0Q5/F0AE4WZ3PGBK1rdQuc9zuwv3SlxUifq1uq3o=;
        b=gL/gE4YAnBkOWsWtPdfJ3DaBnmv8141V7E1hQjPWdPZhdcgK/7S9vAaaHvBo22XWZzKP0o
        4ImcBIKM/UsSJCdqyhZY9rVFcmCULAAjO9v0kqdt2eivdx5pz8DrwArr581jQqoa5XIqaQ
        JkEZuuiYqYTXitHVjDxeaRqwaa3ffJU2R3lRNdO2QazVBjdkGnqAKvaCmpqdKp010qTAAy
        86EIXNmpQ6k3kOeI8OvBbiwBcP0mb1JnHFHDacgBoM0eYV9s50TCnwLCSqn6mysIfHlrkM
        bIRev8lrhbd6EhWx7wIiAjqhHHLjyerPFs+x63GG+CgB3VTgQbLrkhtFX8/HQw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=y4+0Q5/F0AE4WZ3PGBK1rdQuc9zuwv3SlxUifq1uq3o=;
        b=Vfc+fqaR41EyJ0Xi1smC7n+B7aYqVUBvpFoMuSxcWD1pA01J2cB1J6kbGsbebUA0ux409F
        MkP3srusPcdUIRBg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 28/31] x86/sev: Include fpu/xcr.h
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:41 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Include the header which only provides the XRC accessors. That's all what
is needed here.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/sev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -23,7 +23,7 @@
 #include <asm/stacktrace.h>
 #include <asm/sev.h>
 #include <asm/insn-eval.h>
-#include <asm/fpu/internal.h>
+#include <asm/fpu/xcr.h>
 #include <asm/processor.h>
 #include <asm/realmode.h>
 #include <asm/traps.h>

