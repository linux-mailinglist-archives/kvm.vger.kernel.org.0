Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE27435CA4
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 10:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhJUIK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 04:10:58 -0400
Received: from 8bytes.org ([81.169.241.247]:34326 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231464AbhJUIK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 04:10:56 -0400
Received: from cap.home.8bytes.org (p4ff2b5b0.dip0.t-ipconnect.de [79.242.181.176])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id E8E227F;
        Thu, 21 Oct 2021 10:08:36 +0200 (CEST)
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
        Marc Orr <marcorr@google.com>, Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Xinyang Ge <xing@microsoft.com>, linux-coco@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 0/2] x86/sev: Two fixes for SEV-ES VC stack handling
Date:   Thu, 21 Oct 2021 10:08:31 +0200
Message-Id: <20211021080833.30875-1-joro@8bytes.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

here are two fixes for recently discovered issues in the handling of
VC handler stack.

Please review.

Thanks,

	Joerg

Joerg Roedel (2):
  x86/sev: Fix stack type check in vc_switch_off_ist()
  x86/sev: Allow #VC exceptions on the VC2 stack

 arch/x86/kernel/sev.c   | 21 +++++++++++++++++----
 arch/x86/kernel/traps.c |  2 +-
 2 files changed, 18 insertions(+), 5 deletions(-)


base-commit: 519d81956ee277b4419c723adfb154603c2565ba
-- 
2.33.1

