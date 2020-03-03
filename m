Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3CA5177910
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 15:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729691AbgCCOdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 09:33:44 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59009 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729208AbgCCOdZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 09:33:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583246004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dxS31utg7cSHnx9gNHaxFkSn2ndxJH0EWB8zmNbHHaU=;
        b=fc7nf0rPfCTLEslCMhY20DTLzYiPZ3hvI0XOKp9vZEB6JBnMpt9y3FBp4IXV9P5DR93btG
        7PejQadGvpFD5C6w/gNmff8rZgwFTJGR9EzYzwGP++v2RatpGqH9AShkNOOqQQprOoeD/R
        Oak51pDYsnmG0e+XRxu4Z6RRiGM8g+w=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-PU00GLycMmOfFHIRbB6J2Q-1; Tue, 03 Mar 2020 09:33:22 -0500
X-MC-Unique: PU00GLycMmOfFHIRbB6J2Q-1
Received: by mail-wr1-f69.google.com with SMTP id 72so1298936wrc.6
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 06:33:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dxS31utg7cSHnx9gNHaxFkSn2ndxJH0EWB8zmNbHHaU=;
        b=H9eLqkNoOF1E9OXEqz6st18e4HVkTlnl1XS+Yvd9XUdyEumR3toRJPVaWCbXD9PihC
         1oCWVznqUtwD2AX94MWjpzhMK8v0ZIFTCJH3cCvLm1KVCUlCVCGiII8f/0anDsKRn3im
         ZYUTpoKpZZ+IMpgCJk/t9w0tIPrlAiFX+cNp7EXY7RNwWR4b52PqoJ7/aouNv68y0T13
         2aMDejy7o18lWpTfDW+T0Q01tNSbrJ14chdiKHNhBBZK9SJoeEoKJoAuEqZ5Z45SeKV8
         Gd2mnVC5N7pD/6xBcuKEIT0fP+QXGZJ3Ekk0hJByv+WB6XdS/B1297kt8y7bEC/tLsCu
         XWTA==
X-Gm-Message-State: ANhLgQ18GlkKDOjBLI3/QEr2/2NrZmm5F7pjY0buIdRrmnBqJDYNYTR0
        EvBZp1TL5DXE8p5nLjbbiYSGfOpGZ94G3OUuICXd/ievx66EIE58heG5saW1zYNM6MV0jzM+X89
        d5KuBYPhl41co
X-Received: by 2002:a7b:c450:: with SMTP id l16mr4305705wmi.166.1583246001724;
        Tue, 03 Mar 2020 06:33:21 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuiwZKiPNPSbaEdU6EDWlISiPkShkWhFvcHlJsEDXIDIJkikpcwOOHzE0oUhcxilTPbMtZMXw==
X-Received: by 2002:a7b:c450:: with SMTP id l16mr4305694wmi.166.1583246001555;
        Tue, 03 Mar 2020 06:33:21 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id s5sm32248504wru.39.2020.03.03.06.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 06:33:20 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Bandan Das <bsd@redhat.com>, Oliver Upton <oupton@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86: remove stale comment from struct x86_emulate_ctxt
Date:   Tue,  3 Mar 2020 15:33:16 +0100
Message-Id: <20200303143316.834912-3-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303143316.834912-1-vkuznets@redhat.com>
References: <20200303143316.834912-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit c44b4c6ab80e ("KVM: emulate: clean up initializations in
init_decode_cache") did some field shuffling and instead of
[opcode_len, _regs) started clearing [has_seg_override, modrm).
The comment about clearing fields altogether is not true anymore.

Fixes: c44b4c6ab80e ("KVM: emulate: clean up initializations in init_decode_cache")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 2a8f2bd2e5cf..c06e8353efd3 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -360,7 +360,6 @@ struct x86_emulate_ctxt {
 	u64 d;
 	unsigned long _eip;
 	struct operand memop;
-	/* Fields above regs are cleared together. */
 	unsigned long _regs[NR_VCPU_REGS];
 	struct operand *memopp;
 	struct fetch_cache fetch;
-- 
2.24.1

