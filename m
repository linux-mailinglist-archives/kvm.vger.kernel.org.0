Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA5E3F3BBB
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 23:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbfKGWt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 17:49:58 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:37759 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbfKGWt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 17:49:58 -0500
Received: by mail-pg1-f201.google.com with SMTP id u20so3077029pga.4
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 14:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=t9ntozjX65YwM0irxGvMCIbTKOnw1B1qw4N9v+V/Q1U=;
        b=EkxKZ7h25cwZs9Kwye/dqUn9XreSPPLXv11cpTf6EIPDqp18W+o3iFyzmPUbvakr7v
         JsimfRrn9VrNBjFbPMe0pnpURYJSDBw0ezOwYTzFZWNVgCPnHu+u/8xgssH8blQnqstO
         RLXLrJczRY8E32RcrhiZ1xv7KfxiWoGMl8z+kRc+7/Mxg1KIY22tPgdfm4q6TJs5rm2i
         mcMI6WHrBllwUVgTOy8++TL42e9AO6AZ4zR24+yVuDYlzgZ80eMBspaiwa1Y+mP7Entd
         vDoMKQ1eQG0v2hqZGVSNZHyheJ7Gh7eyrIzhZxAYFPM3JuTM/PUzsL+rIHgRuyhu/Foe
         IlMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t9ntozjX65YwM0irxGvMCIbTKOnw1B1qw4N9v+V/Q1U=;
        b=WUqQPr+uW/JaX6xUfIC/dfq5LRdvV/f2UWzhxIjWKj9MS3tw5hQHVuY6UYdRGj0+ib
         /RALFg7vSXA4ffseH7JpInXMjFgyP07i7NkqOtd2mjWxf9uPiy+1x6wKTLL8P+zQk1Mi
         A6V6nf/4TQdubLPb42yc7cLDNSi++U0/FxZy9KZBcOup7K9Ys/h4la6Op42Tou6LupYH
         Fv6xv7jSb68wNYKI0gf6EhaQVOtiB6t+fVlVSRAsxkGCut3REiy36Sr0SzGBy0f13TCt
         C8KToIt2caN8IyrCoW5T0egKFUL9YlnbO163+yOPHptkc9r6GWCPlQNUkaGLPBDYK1An
         yZhA==
X-Gm-Message-State: APjAAAXEbevmctuZNx86Hdt2Qqj/xId4LC1y+bIzAP4UBit21ijGHZbl
        Mn3IqUWYCxandX8m43kOo9d+bP9LrFXQvpC0b0NmF//LkF2SNkPt/txND35k2xDcNP3KOIUsO33
        79dCTnFTqnsYvxEmoHux/vij504VkoRimvbExlRQ2G7kr3evFKFWMCdjiLI5sW4JKOcCx
X-Google-Smtp-Source: APXvYqzAdykP3rbj4+dZiV4yQvY4cBJPQmYUwW3/ycn86pIrfn4qMO7Ppz937kPw2VnvDU7SVIRNXnGsxaGDiVgK
X-Received: by 2002:a63:6585:: with SMTP id z127mr7824956pgb.330.1573166995308;
 Thu, 07 Nov 2019 14:49:55 -0800 (PST)
Date:   Thu,  7 Nov 2019 14:49:39 -0800
In-Reply-To: <20191107224941.60336-1-aaronlewis@google.com>
Message-Id: <20191107224941.60336-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191107224941.60336-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v3 3/5] kvm: vmx: Rename function find_msr() to vmx_find_msr_index()
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

