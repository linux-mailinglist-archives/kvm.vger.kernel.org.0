Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1D34E1BFA
	for <lists+kvm@lfdr.de>; Sun, 20 Mar 2022 15:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242813AbiCTOJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Mar 2022 10:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236015AbiCTOJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Mar 2022 10:09:01 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CC91B84DF;
        Sun, 20 Mar 2022 07:07:37 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id bg31-20020a05600c3c9f00b00381590dbb33so7118669wmb.3;
        Sun, 20 Mar 2022 07:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EXoDv3gZjZlfNDNfk4gMVFKbUxSlNIRV3iYCgj/tOU4=;
        b=pL3GoBc8IUoW5U9b+laC9tQJtAlDAOClEapvvA6pIM7qUELx0HGxZIX58P1GW11xFS
         LBaHrZoey5cz2qmALwvtG1KeuWLMibLedy5TZnsj/ARQXYFUIdS5bcIg/jw1x71wYKsk
         vt/2yEdRawBpDavrcmhCmTo9WGBfprqwbjyz7GQlxBxGjCE0SDQR4XReFeY8ydt0UfOD
         pE5RAV3Pil2DDzdHkorsjkJLQbqzkIZZ7OE5Vknlj9eOlhG/iMJHR0MxMZfhpF9DVlR/
         7j/tdVxp1BV+66IzQpgUQP3ApqeCC9YyIYtzqnQ2NXDdLjipx9Zodt4OOFRX79gVqQHj
         KYMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=EXoDv3gZjZlfNDNfk4gMVFKbUxSlNIRV3iYCgj/tOU4=;
        b=H5ZgU/eNqVMKYKoYnsxF4N/EeZ42COmg7G+Yzs33zkDsdU1hh7OcLVvi3KYCHkZU1t
         4AIcl8asaCq9yJIh8cF9+VU1ixxGnDNzM4IXrG5E/exYLA1OELTxwRqrOID7OVsXICLZ
         igFnQCkH7pDMm8d2Xeasn6cogH5web63xsfWK0VIo+hMED/0EuIM0sqgms4od4dy2iUk
         5Cbzuxli3svNQfykiPZJWDMwEuUwX9Q6YkXDsi813S5/7t2uq1TQggAorV4hV1jcscOu
         EKWKfWqUxGEmNKJxBWwYCMmkI8WNy6XintpZ3RWswl2na0BUTedmfM61/msnuqUK90OQ
         NZTg==
X-Gm-Message-State: AOAM530J7jXO67XwC9J+5VbdjE9JwBPuAFM52Qhm3T4hZADUdBpnTGu3
        8KVtcERMGLqzDIc2rN+i1o4=
X-Google-Smtp-Source: ABdhPJzsOMtNb48pQQoTI+Ftz0DdsxJkqKT1KMPq8CLCHZByMuRrhjEmpaKBIGewlk7FVyt1G765YQ==
X-Received: by 2002:a05:600c:19d1:b0:389:d567:e9a0 with SMTP id u17-20020a05600c19d100b00389d567e9a0mr23006674wmq.137.1647785255741;
        Sun, 20 Mar 2022 07:07:35 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id o6-20020a5d6486000000b00203d22118d8sm13160127wri.35.2022.03.20.07.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Mar 2022 07:07:34 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>
Subject: [GIT PULL] KVM/SLS change for 5.17 final
Date:   Sun, 20 Mar 2022 15:07:31 +0100
Message-Id: <20220320140731.95666-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.35.1
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

Linus,

Sorry for sending this so late, I've been sick on Thursday-Friday and
only managed to see the thread afterwards.  I might send the pull request
for 5.18 later today so I tweaked the usual "for-linus" tag name.

The following changes since commit 34e047aa16c0123bbae8e2f6df33e5ecc1f56601:

  Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux (2022-03-18 12:32:59 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-5.17

for you to fetch changes up to fe83f5eae432ccc8e90082d6ed506d5233547473:

  kvm/emulate: Fix SETcc emulation function offsets with SLS (2022-03-20 14:55:46 +0100)

The patch diffstat is mostly a large comment, which will be tweaked further
when IBT comes in 5.18.  For Peter, this is also available as a topic branch
"kvm-sls-fix" at https://git.kernel.org/pub/scm/virt/kvm/kvm.git.

----------------------------------------------------------------
Fix for the SLS mitigation, which makes a "SETcc/RET" pair grow to
"SETcc/RET/INT3".  This doesn't fit anymore in 4 bytes, so the
alignment has to change to 8.

----------------------------------------------------------------
Borislav Petkov (1):
      kvm/emulate: Fix SETcc emulation function offsets with SLS

 arch/x86/kvm/emulate.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)
