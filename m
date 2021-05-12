Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCFE37B724
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 09:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhELH4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 03:56:20 -0400
Received: from 8bytes.org ([81.169.241.247]:38532 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230026AbhELH4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 03:56:17 -0400
Received: from cap.home.8bytes.org (p549ad305.dip0.t-ipconnect.de [84.154.211.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 4BF4D90;
        Wed, 12 May 2021 09:55:07 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org, Hyunwook Baek <baekhw@google.com>
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
Subject: [PATCH 0/6] x86/sev-es: Fixes for SEV-ES guest support
Date:   Wed, 12 May 2021 09:54:39 +0200
Message-Id: <20210512075445.18935-1-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

here is a collection of fixes for the SEV-ES guest support. They fix
simple and more severe issues and are all targeted for v5.13. The most
important fixes are the revert of 7024f60d6552 which just doesn't work
in any context the #VC handler could run and the fix to forward #PF
exceptions caused during emulation. The issue that 7024f60d6552
intended to fix should be fixed correctly with these patches too.

Please review and test.

Regards,

	Joerg

Joerg Roedel (6):
  x86/sev-es: Don't return NULL from sev_es_get_ghcb()
  x86/sev-es: Forward page-faults which happen during emulation
  x86/sev-es: Use __put_user()/__get_user
  Revert "x86/sev-es: Handle string port IO to kernel memory properly"
  x86/sev-es: Fix error message in runtime #VC handler
  x86/sev-es: Leave NMI-mode before sending signals

 arch/x86/kernel/sev.c | 76 +++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 38 deletions(-)


base-commit: 059e5c321a65657877924256ea8ad9c0df257b45
-- 
2.31.1

