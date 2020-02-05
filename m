Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDF1A1533E1
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 16:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgBEP3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 10:29:47 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:35055 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgBEP3r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 10:29:47 -0500
Received: by mail-wr1-f54.google.com with SMTP id w12so3269510wrt.2
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 07:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=CdPJM86ZQ5sCp4YPhiWnGiejzLwA7DOCPC4pjKic284=;
        b=nEH7uJdsUOptDz6cDTzqswogbmPlecr1bvuUPiGcqAJVANrEvv67PGDs9FMtmWfZrY
         fyQE7binfcfObGf7kqaCZbWClmVBijUf60mezm7rirxrWbSotB62WFq8Vzvi/fm7uiFr
         pArhFHeujoL2i1QLl+EM28DoMXuByEmH7m8z8VLZGZWDnzl4hpdcEeZ9RhkVwqvnfkoM
         eky6Nf+pqtrVWaP9+a/U+mo2OphlQL9xBeNNxNMi3v+T3B/wA4LV4cuvnfv08/PGERwg
         rC/EiuOUU4QCcY8lk1n7jYhn4pgDyMK7NjefqG90hpMOMnENug+xWYtATjO2BuLJ6674
         /kaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=CdPJM86ZQ5sCp4YPhiWnGiejzLwA7DOCPC4pjKic284=;
        b=UegxLzJb/mWpGyaXK8OQ1ZBthCaDorvgSYJcFtq+eUaJyZwLY7jvXcpQzG7G7FEkpl
         41hxBsOydJsoJF07OUWYocCq8t0d+x8bfiN9NH5vZJhnZGZIjYvZ1lUT4is7VjZ976fj
         0/5dE8yzF29hamDSr/sIMjqS+FPl8lD7GnMWV5SMZ3oMJA31Lld9damMgLb3/+zmHm8A
         +fR1Hvoz6KfOhDrrTaj48hA0KRe2hUu2TUu4d0r0HX6C/sVA1uvT2/VbBU7uGjiYDj5M
         MhDvuNys5wMq+rx6nzPOFiSgYHeWIptHN49M4vlho6M3Uzq/ba8TloKacWezH5AdEX/O
         vRew==
X-Gm-Message-State: APjAAAUSBId2y925dOuZcZgJGI3MgeGgw/0J4G3VmWkfL0E5tgz0dQ9R
        zIQwg+7oLCpUNBMnVJPcknMJLLPl
X-Google-Smtp-Source: APXvYqx7jM3XG97FWHXNzQAX3am86LTdS8iKaJw5hkGK5NYYSiH6r/DdfmmvEfl7tErzxXi9oqb0bw==
X-Received: by 2002:adf:e446:: with SMTP id t6mr16275508wrm.222.1580916583678;
        Wed, 05 Feb 2020 07:29:43 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id p11sm215427wrn.40.2020.02.05.07.29.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Feb 2020 07:29:42 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com
Subject: [PATCH kvm-unit-tests] x86: provide enabled and disabled variation of the PCID test
Date:   Wed,  5 Feb 2020 16:29:40 +0100
Message-Id: <1580916580-4098-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PCID test checks for exceptions when PCID=0 or INVPCID=0 in
CPUID.  Cover that by adding a separate testcase with different
CPUID.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/unittests.cfg | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index aae1523..f2401eb 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -228,7 +228,12 @@ extra_params = --append "10000000 `date +%s`"
 
 [pcid]
 file = pcid.flat
-extra_params = -cpu qemu64,+pcid
+extra_params = -cpu qemu64,+pcid,+invpcid
+arch = x86_64
+
+[pcid-disabled]
+file = pcid.flat
+extra_params = -cpu qemu64,-pcid,-invpcid
 arch = x86_64
 
 [rdpru]
-- 
1.8.3.1

