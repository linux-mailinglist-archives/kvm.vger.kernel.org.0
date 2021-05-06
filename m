Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF4C375186
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 11:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbhEFJc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 05:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbhEFJcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 05:32:55 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3288EC061574;
        Thu,  6 May 2021 02:31:58 -0700 (PDT)
Received: from cap.home.8bytes.org (p5b0069de.dip0.t-ipconnect.de [91.0.105.222])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id EB37B247;
        Thu,  6 May 2021 11:31:55 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Eric Biederman <ebiederm@xmission.com>, x86@kernel.org
Cc:     kexec@lists.infradead.org, Joerg Roedel <jroedel@suse.de>,
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
        Joerg Roedel <joro@8bytes.org>, linux-coco@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 0/2] x86: Disable kexec for SEV-ES guests
Date:   Thu,  6 May 2021 11:31:20 +0200
Message-Id: <20210506093122.28607-1-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

two small patches to disable kexec on x86 when running as an SEV-ES
guest. Trying to kexec a new kernel would fail anyway because there is
no mechanism yet to hand over the APs from the old to the new kernel.
Supporting this needs changes in the Hypervisor and the guest kernel
as well.

This code is currently being work on, but disable kexec in SEV-ES
guests until it is ready.

Please review.

Regards,

	Joerg

Joerg Roedel (2):
  kexec: Allow architecture code to opt-out at runtime
  x86/kexec/64: Forbid kexec when running as an SEV-ES guest

 arch/x86/kernel/machine_kexec_64.c |  8 ++++++++
 kernel/kexec.c                     | 14 ++++++++++++++
 2 files changed, 22 insertions(+)

-- 
2.31.1

