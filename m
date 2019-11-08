Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD5FF3F88
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 06:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbfKHFOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 00:14:55 -0500
Received: from mail-ua1-f74.google.com ([209.85.222.74]:54737 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbfKHFOz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 00:14:55 -0500
Received: by mail-ua1-f74.google.com with SMTP id x2so1833817uaj.21
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 21:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=t9ntozjX65YwM0irxGvMCIbTKOnw1B1qw4N9v+V/Q1U=;
        b=a0IgFnUtkBRHfOvXtqUTSTzYwD7TtYSNYeaRYM77PbryGwk2e1e5RiOhs3hVcpODhQ
         SWidz4GF730RnLEKw509GbKTU1mqbFIeozX6vYrO3RjeWKecJIrpEAkoWHrlCDmxsPwZ
         Sy3V6wxRWIE2qCRU5EM87rXntn9ntvaATbYITdYuVZBSuaigkiDVMxaBQMOrVUhpIoaN
         tdQYpxu7nCedSZs0nyQBByaXK8uGwYuEHUsHHRZVdhJGtvzV039J/22kEtf0bSPMMv/7
         y+npJVEPMFfqDkzcZGWe3W6iPU3ykXf5nor29I7TwMdW/NopEVrH000ZWG3BMohldiI0
         pc8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t9ntozjX65YwM0irxGvMCIbTKOnw1B1qw4N9v+V/Q1U=;
        b=WxzlJnhoTLPRaIqOi2bl7WGfpUgEkruf0wozJ/IwX3sirWQ2mruysNoi7YK0dEEaht
         mF3IIte9mrMAnHVsx2ldgpgbPgcy98jnh/feS8B+7DL8VHM9/NTEC5fP1DEp9vlr6tj/
         c9VfG5nOG1gfXd2LRRrSXFMFwnFzh4MOQEffPSTV411j+1R90HFxxnF8lDYw8gdHNhhe
         iETfAE1tn9DOm2hB3TDoXi0DZi3Pr7mNeZK+YdSfrf8yxVHcf7GlbMFAFmrucRJ1oo6I
         dEfgdDFh8FdfkYod+GcwzEKraM7Tf2W+klSoczS3jB7gk7DmifIGobVBAR80cSHY7H8x
         9Dtg==
X-Gm-Message-State: APjAAAUwJ2YHT04mX2sss01PkJDn7EP5NC72jqt7RH+bEwD57FJT66bI
        4BWgW0TvZ2pvPLMLVE8K9/bvQJTYAQmHm3S82WmF8NPmnkkJLL5pcMlOFlxsxr9+Tm0zSO4sose
        S5QhV/Wl4sskDHofAYu+v9tEW817KMfxTXU/aJv7/HYQDPh1K0rol7OfZexHevEozlsJv
X-Google-Smtp-Source: APXvYqyJIeiTKi48eTMLCGmyUWtX+04Gq9DovEpt3uUMWLCvmCYvD8+rrAOAmt3YyVSkg7OUvWQk5+BV5hJO578I
X-Received: by 2002:a9f:2304:: with SMTP id 4mr5436423uae.69.1573190093993;
 Thu, 07 Nov 2019 21:14:53 -0800 (PST)
Date:   Thu,  7 Nov 2019 21:14:38 -0800
In-Reply-To: <20191108051439.185635-1-aaronlewis@google.com>
Message-Id: <20191108051439.185635-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191108051439.185635-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v4 3/4] kvm: vmx: Rename function find_msr() to vmx_find_msr_index()
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename function find_msr() to vmx_find_msr_index() in preparation for an
upcoming patch where we export it and use it in nested.c.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d9afafc0e399..3fa836a5569a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -835,7 +835,7 @@ static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 	vm_exit_controls_clearbit(vmx, exit);
 }
 
-static int find_msr(struct vmx_msrs *m, unsigned int msr)
+static int vmx_find_msr_index(struct vmx_msrs *m, u32 msr)
 {
 	unsigned int i;
 
@@ -869,7 +869,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
 		}
 		break;
 	}
-	i = find_msr(&m->guest, msr);
+	i = vmx_find_msr_index(&m->guest, msr);
 	if (i < 0)
 		goto skip_guest;
 	--m->guest.nr;
@@ -877,7 +877,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);
 
 skip_guest:
-	i = find_msr(&m->host, msr);
+	i = vmx_find_msr_index(&m->host, msr);
 	if (i < 0)
 		return;
 
@@ -936,9 +936,9 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 		wrmsrl(MSR_IA32_PEBS_ENABLE, 0);
 	}
 
-	i = find_msr(&m->guest, msr);
+	i = vmx_find_msr_index(&m->guest, msr);
 	if (!entry_only)
-		j = find_msr(&m->host, msr);
+		j = vmx_find_msr_index(&m->host, msr);
 
 	if ((i < 0 && m->guest.nr == NR_LOADSTORE_MSRS) ||
 		(j < 0 &&  m->host.nr == NR_LOADSTORE_MSRS)) {
-- 
2.24.0.432.g9d3f5f5b63-goog

