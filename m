Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0487B3B07DC
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 16:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhFVOvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 10:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbhFVOvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 10:51:00 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C62C061574;
        Tue, 22 Jun 2021 07:48:44 -0700 (PDT)
Received: from cap.home.8bytes.org (p4ff2ba7c.dip0.t-ipconnect.de [79.242.186.124])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 0A56D133;
        Tue, 22 Jun 2021 16:48:41 +0200 (CEST)
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
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH 0/3] x86/sev: Minor updates for SEV guest support
Date:   Tue, 22 Jun 2021 16:48:22 +0200
Message-Id: <20210622144825.27588-1-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

here are three small patches to update SEV-ES guest support in Linux.
It would be great to have at least patch 3 merged for v5.14 to avoid
future merge conflicts. It contains defines needed by KVM and X86
patches under development.

Thanks,

	Joerg

Brijesh Singh (1):
  x86/sev: Add defines for GHCB version 2 MSR protocol requests

Joerg Roedel (2):
  x86/sev: Add Comments to existing GHCB MSR protocol defines
  x86/sev: Use "SEV: " prefix for messages from sev.c

 arch/x86/include/asm/sev-common.h | 17 +++++++++++++++++
 arch/x86/kernel/sev.c             |  2 +-
 2 files changed, 18 insertions(+), 1 deletion(-)


base-commit: be1a5408868af341f61f93c191b5e346ee88c82a
-- 
2.31.1

