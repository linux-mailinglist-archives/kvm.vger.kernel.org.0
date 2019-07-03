Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B497F5D4E7
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 18:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfGBQ55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 12:57:57 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40783 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfGBQ55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 12:57:57 -0400
Received: by mail-wr1-f67.google.com with SMTP id p11so18681711wre.7;
        Tue, 02 Jul 2019 09:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=i3HE+C3o7SG5oivsWvGUnER3uMcg4NiFFFCJjgaX1+M=;
        b=JnTPsPNXMVxBdzKr+g0in7L9lGkXFy5dRAPhwiSnV26253i+ZBAPduwyMTjwQlD8B4
         kFPlKuD4mHY7KVhhE9iCefZRt8upYJsIPnb1MKnf24GEVEMpLqocEWmEp01ZGrxRiT9h
         5u+PTU7jRTDFuJL8YU3g7UQ0/4nQ+1yrdDaE9igV+hFbzOZkx1Szw+5nfz1I9IAq4p74
         0NqIUvBeKlFQ35hicE6E8zd+2yIvJ16HJAHsK1ASSs8zR2UbPn10iUB2WtFVfuwzSrb0
         6Is1NvVsDflXT3EGDsosiKuxhl3qr5apTWzjeacrAYPL5+8jzMIv5D6dKTtcDHE6oHBh
         TYQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=i3HE+C3o7SG5oivsWvGUnER3uMcg4NiFFFCJjgaX1+M=;
        b=VkaUfGyN8M9S4wq+KRuPSuty8oHMyNXmVaVXlFWj83SjD8VDpc9rQPpABzE6VvD9Yi
         x/nF+jxDTSjA3Up5b2P3KAw0hUi2hJKjJASJbjYB38AoFqREnPhlfDx10OeViIa8vy/K
         iY5kKA/tscI3RSbJ5HR+zaBkjKaDX5ryEnZtIfvVD/NROYbnAYgHUwMLN6/4mgRy8YRi
         xyE2EhjrCG2PZXHLuBZCtbftRVk5hft7YkySh6XJeXiKAwDe/fQUq96sZqN9otwKmd3E
         zJxkQNJEZTuSjRwtYz2gBSoZ5k5BlQxerqmnVEmdgt1Ya8sS5D8k2yknTUuDgJHb2wjw
         P94w==
X-Gm-Message-State: APjAAAUp9SHZCLtpsY9poGo17/Ii+pBqHdok3JPc0qA2QQGjuw2afRMr
        5QK1sug11e/pNU6xrqKaeMc7/mo6JIg=
X-Google-Smtp-Source: APXvYqwZFlIoKV/wVYtxyqalaNxF6mYyjy8vrbqIOnqAfpxwb95IPRXeLKUMDaKcM9r1sZXJRFeOhw==
X-Received: by 2002:adf:e84d:: with SMTP id d13mr20915265wrn.88.1562086675086;
        Tue, 02 Jul 2019 09:57:55 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id n3sm14937957wro.59.2019.07.02.09.57.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 09:57:54 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH] Documentation: kvm: document CPUID bit for MSR_KVM_POLL_CONTROL
Date:   Tue,  2 Jul 2019 18:57:53 +0200
Message-Id: <1562086673-30242-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virtual/kvm/cpuid.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
index 979a77ba5377..2bdac528e4a2 100644
--- a/Documentation/virtual/kvm/cpuid.txt
+++ b/Documentation/virtual/kvm/cpuid.txt
@@ -66,6 +66,10 @@ KVM_FEATURE_PV_SEND_IPI            ||    11 || guest checks this feature bit
                                    ||       || before using paravirtualized
                                    ||       || send IPIs.
 ------------------------------------------------------------------------------
+KVM_FEATURE_PV_POLL_CONTROL        ||    12 || host-side polling on HLT can
+                                   ||       || be disabled by writing
+                                   ||       || to msr 0x4b564d05.
+------------------------------------------------------------------------------
 KVM_FEATURE_PV_SCHED_YIELD         ||    13 || guest checks this feature bit
                                    ||       || before using paravirtualized
                                    ||       || sched yield.
-- 
1.8.3.1

