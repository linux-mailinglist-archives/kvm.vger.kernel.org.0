Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D764E3D3B
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 12:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiCVLJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 07:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbiCVLIx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 07:08:53 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2F682D00;
        Tue, 22 Mar 2022 04:07:25 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id j13-20020a05600c1c0d00b0038c8f94aac2so1642221wms.3;
        Tue, 22 Mar 2022 04:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7thz8A1qDZ9O9kPPviZdxO9DIiJuxrdkli/BxSR2ssw=;
        b=n/DsP31Ag3DGCqh9F+O3ZhVFcPBnDla0XMad+AH7nL3g2GNpOYX98M0MANxLiDA7ft
         WTnGACa4Ie/Jj27sjx6d4hEbGhC20DPbw3KpuEhHuUbvhk5n1p/0vHC4e8kgs4dNxG1Q
         /zl/yc/O43fRMTg1UgTy0LAmRm71oixqEqi9sT8fZYb3RaZW6PRSLYYEmqbaP/ruyJ5h
         u7LDrunerom5ZG97edOsrhuy65hCQZRxHMPncTBUTRmTK6QAmp5Py9XYdyn3wthcoW5F
         3FaMcPLKri9qFypW1QHXeZKCcto5I6DaouqPT37cM/6ew8IYS8xtubc0lrCPJG2R6nfm
         U/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=7thz8A1qDZ9O9kPPviZdxO9DIiJuxrdkli/BxSR2ssw=;
        b=V/IjkCURh39gg/ES7njl/FsDC3Nwaa02g0EBQazwdi5LaQDoWY4aFeL8Y+3o1PQg04
         qdd0MZhZv4UjtOP4czPWHZASmCepqRDgFY8JpRYUYOkWc+SaDXm0iF+ijOfUpjfhA4aX
         HiL70khih3cbTj+LRxZ0QnIrc3I7g7h5ZrI759V5YH6QpQ9nq9k8pE9oLpn5v8Djkgzf
         6xJSgP5WSDU7mZaWWI5NgfEhxxSF1mzi+9lVc1mI36UT5rSRCUp4kZniFtWE59HfKW+C
         XS+tMVfZhnTXYJc6XZVXA6iPZYLUXPRM17vC20SS8TLXAl8yHYeSbCj4l+DtqyFaJbd0
         ObWw==
X-Gm-Message-State: AOAM533mg0KB//24CUFrKOsh3Qj3aXsev6Jh18gotM2+Kv1F0AF7pg3+
        lo/BpEXiyMfXkq+Xpn94YbUyStS0RyA=
X-Google-Smtp-Source: ABdhPJwlHPsjgi7u2ucteECw2jdvrPzfehXTh8hSg4hWYqw6Xpqyt9hupR+psdsbQWA/eeAP5+L6rw==
X-Received: by 2002:a1c:e908:0:b0:38c:782c:2a62 with SMTP id q8-20020a1ce908000000b0038c782c2a62mr3128805wmc.135.1647947243799;
        Tue, 22 Mar 2022 04:07:23 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y11-20020a056000168b00b002041af9a73fsm4221856wrd.84.2022.03.22.04.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 04:07:23 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 2/2] Documentation: kvm: include new locks
Date:   Tue, 22 Mar 2022 12:07:20 +0100
Message-Id: <20220322110720.222499-3-pbonzini@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220322110720.222499-1-pbonzini@redhat.com>
References: <20220322110720.222499-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm->mn_invalidate_lock and kvm->slots_arch_lock were not included in the
documentation, add them.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/locking.rst | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 4f21063bfbd6..486efcd36fd6 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -226,6 +226,12 @@ time it will be set using the Dirty tracking mechanism described above.
 :Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
 		migration.
 
+``kvm->mn_invalidate_lock``
+^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+:Type:          spinlock_t
+:Arch:          any
+:Protects:      mn_active_invalidate_count, mn_memslots_update_rcuwait
 
 ``kvm_arch::tsc_write_lock``
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
@@ -255,6 +261,15 @@ time it will be set using the Dirty tracking mechanism described above.
 		The srcu index can be stored in kvm_vcpu->srcu_idx per vcpu
 		if it is needed by multiple functions.
 
+``kvm->slots_arch_lock``
+^^^^^^^^^^^^^^^^^^^^^^^^
+:Type:          mutex
+:Arch:          any (only needed on x86 though)
+:Protects:      any arch-specific fields of memslots that have to be modified
+                in a ``kvm->srcu`` read-side critical section.
+:Comment:       must be held before reading the pointer to the current memslots,
+                until after all changes to the memslots are complete
+
 ``wakeup_vcpus_on_cpu_lock``
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 :Type:		spinlock_t
-- 
2.35.1

