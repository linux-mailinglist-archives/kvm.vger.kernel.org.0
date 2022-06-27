Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57EF155DACB
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbiF0JwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 05:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbiF0JwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 05:52:01 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C0E6378;
        Mon, 27 Jun 2022 02:52:00 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o18so7726819plg.2;
        Mon, 27 Jun 2022 02:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dRX8FWNzBU7QvPCSptvJ8/0ZXRASxQI/9/dRpScKoWM=;
        b=D5W8LLPVBsfy3j+4HKtK9yEJ5wEU0qzSXPu9zRUxd/zIGMunanHjC0QgEYlBA17DAW
         xt0UIn9TPTx0LrUOk2U3WavV01Zc17vYhSh3LtNtTu923d3YScxoiRdf3iH1wzHHxj08
         LnzBJWTvio3FBIM9qQFswATUHtvXRqlq1fGIhgJbto41FgKamK3VXpw6Qpwug6Be2Nwx
         8Q+GVrNqld8SaIS/OlQWVq5ZbeVDv6vPJLZJDH8RcJuGhcns7C5nNMmL/UOTT2fcRFvK
         VSMk/lkj/PU68D8ktW6iMbaWtQmJ57ov6kIomOYXSv40ZCGSQqo/GzcEa6T8kMLnqSYq
         4GBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dRX8FWNzBU7QvPCSptvJ8/0ZXRASxQI/9/dRpScKoWM=;
        b=BQVYJRMTURx/GcwN5ene5V+GZrsqeHOSjWO5MwGHlsidAw9siyVDyg+ZJrmzRnrV84
         5QbyUFjcv6bKUIJDfMZrSfy5UsJGLwqSqSX7yKWLglsPeU+48NR6xhuS2cwgLJX5MUKe
         l1p7fxvYJysVjXUJG94q5ayemME3ZmzKNP03Yj2zjmMcxehyqZ2RtpbB0tXwsOZM39G1
         VYdzV93HDLbJnp97AuoJwdR7mJkR7fcHR5jlrpbakppgIiHvmKiyn+EiQss6NyyvCCxW
         6nchVQVB2+hBECXLCMugorSspjAc0K//J8bEjj7Hb6g35kw9EL9jofy3L2W1U/K+3TRy
         dnUA==
X-Gm-Message-State: AJIora+q6YB74Igly30V1T9gZRBeJjAXm3037xC6mH92Z4iXj/HAYMZe
        Vf2kBCNSsWpH0eMWS75Sgxs=
X-Google-Smtp-Source: AGRyM1vtVzM4K0yHjGP9MGHdazzgBgMeEwQiVqV7kI2RBsQLQMD0tQMY75a1Ieu4RL7NzxOip7APJQ==
X-Received: by 2002:a17:903:1c4:b0:16b:7928:95ce with SMTP id e4-20020a17090301c400b0016b792895cemr5896510plh.158.1656323519781;
        Mon, 27 Jun 2022 02:51:59 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id 71-20020a63034a000000b0040d2d9f15e0sm6727357pgd.20.2022.06.27.02.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 02:51:59 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 772C91037D8; Mon, 27 Jun 2022 16:51:56 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        kvm@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH next 2/2] KVM: x86/MMU: properly format KVM_CAP_VM_DISABLE_NX_HUGE_PAGES capability table
Date:   Mon, 27 Jun 2022 16:51:51 +0700
Message-Id: <20220627095151.19339-3-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220627095151.19339-1-bagasdotme@gmail.com>
References: <20220627095151.19339-1-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is unexpected warning on KVM_CAP_VM_DISABLE_NX_HUGE_PAGES capability
table, which cause the table to be rendered as paragraph text instead.

The warning is due to missing colon at capability name and returns keyword,
as well as improper alignment on multi-line returns field.

Fix the warning by adding missing colons and aligning the field.

Link: https://lore.kernel.org/lkml/20220627181937.3be67263@canb.auug.org.au/
Fixes: 084cc29f8bbb03 ("KVM: x86/MMU: Allow NX huge pages to be disabled on a per-vm basis")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: David Matlack <dmatlack@google.com>
Cc: Ben Gardon <bgardon@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/api.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ec9f16f472e709..df8fc905217437 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8209,13 +8209,13 @@ available and supports the `KVM_PV_DUMP_CPU` subcommand.
 8.38 KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
 -------------------------------------
 
-:Capability KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
+:Capability: KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
 :Architectures: x86
 :Type: vm
 :Parameters: arg[0] must be 0.
-:Returns 0 on success, -EPERM if the userspace process does not
-	 have CAP_SYS_BOOT, -EINVAL if args[0] is not 0 or any vCPUs have been
-	 created.
+:Returns: 0 on success, -EPERM if the userspace process does not
+          have CAP_SYS_BOOT, -EINVAL if args[0] is not 0 or any vCPUs have been
+          created.
 
 This capability disables the NX huge pages mitigation for iTLB MULTIHIT.
 
-- 
An old man doll... just what I always wanted! - Clara

