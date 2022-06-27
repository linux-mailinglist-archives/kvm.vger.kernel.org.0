Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E811755DD61
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbiF0JwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 05:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbiF0JwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 05:52:02 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA05263F3;
        Mon, 27 Jun 2022 02:52:00 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id w24so8721775pjg.5;
        Mon, 27 Jun 2022 02:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2cG8fbzR7+gSe64OpxIhFg9qrmMhTpmF6O45hxZflsM=;
        b=GWZnMH8B8gSPfjfFy6K8OY0ryGr0AlIE5f5FllGrc2v3EOFqd3Qm9XGAVYT/mDzAqy
         S/Aha1zwB11XwyNRz4bkUq4EvC4F/RQ2/wjwB//TD9/9M4+hgt62Plyft3icFPNTDG/F
         OYuc4pvJYiLwiN9JA0YhsJ6Sks+d2Mkf1eND4EwfGuv7S0x69+HkxrNNU5OncpbHPSnv
         GnGnloQgFHPdSRUXoc7q6hTGZB2eZcUZ3sfT1P9yHzsYJSqGclSWpgBVGAxIMfVjhiDG
         TGdDtXgU598R+6lQvR0RZoZv+fn3iaCx36p7nO0L0UhGR9MrHAXJO6aNwh6EjSkhmE+c
         4Tlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2cG8fbzR7+gSe64OpxIhFg9qrmMhTpmF6O45hxZflsM=;
        b=QieuS6UvqHBvTlK++ofa5ZwgxGJvAs+t4uzsYPw+LczJf4SQDa+WHymPt9UP4FNW0z
         3fK3TUwSaXTvsLtEH4KWuBb0qeQ4iFr6JD8E4K56UjY8DkW9QaNuxbHGy4VohOMU2R+u
         IFJKJJuAEGhHNWQAb2NSggfRiU6T6qXTW+9a2iR+fi5BF2R55NSTo1Gm2rEyjQJTeruR
         /wQTBOg7r3BcdQUohrAgWtqGl4SJBa4apuERXun4lvNuFRrYdHkSGlHCmAdieivgvVqM
         2vEyXoUHEJ0IBcqxGPwne4e1T1OIm6NFvIRpfER6hCX44rYk0LwS8iRG+cMWLSQdq6Sy
         L5Gg==
X-Gm-Message-State: AJIora/QNz9oTNIyBc+4M39VQhXaDOH4ZGCfocjGZ4Y/n5H8WG4mETqw
        I3k2lRK9fvBTdNRUjnCOB7o=
X-Google-Smtp-Source: AGRyM1v+OC+sotsqxlAGI9ck77bnETYvYZSfr5HQbc3snuIdWwbtWhQu0mtmcXGPK+sXUaLUzeHUgg==
X-Received: by 2002:a17:902:b216:b0:16a:854:e641 with SMTP id t22-20020a170902b21600b0016a0854e641mr13288272plr.154.1656323520115;
        Mon, 27 Jun 2022 02:52:00 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id p6-20020a170902eac600b0016a6e9a2ec8sm6022128pld.250.2022.06.27.02.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 02:51:59 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 396CB1038BD; Mon, 27 Jun 2022 16:51:56 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        kvm@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH next 0/2] Documentation: KVM: KVM_CAP_VM_DISABLE_NX_HUGE_PAGES documentation fixes
Date:   Mon, 27 Jun 2022 16:51:49 +0700
Message-Id: <20220627095151.19339-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.36.0
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

After merging kvm tree for linux-next, Stephen Rothwell reported
htmldocs warnings on KVM_CAP_VM_DISABLE_NX_HUGE_PAGES capability
documentation:

Documentation/virt/kvm/api.rst:8210: WARNING: Title underline too short.

8.38 KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
---------------------------
Documentation/virt/kvm/api.rst:8217: WARNING: Unexpected indentation.

Fix these warnings by:

  [1/2]: extend the heading underline
  [2/2]: properly format the capability table

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: David Matlack <dmatlack@google.com>
Cc: Ben Gardon <bgardon@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Bagas Sanjaya (2):
  Documentation: KVM: extend KVM_CAP_VM_DISABLE_NX_HUGE_PAGES heading
    underline
  KVM: x86/MMU: properly format KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
    capability table

 Documentation/virt/kvm/api.rst | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
An old man doll... just what I always wanted! - Clara

