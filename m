Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4D31FC3C
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 23:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfEOVgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 17:36:04 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36856 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfEOVgE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 17:36:04 -0400
Received: by mail-wm1-f67.google.com with SMTP id j187so1424331wmj.1
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 14:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=aSZB7C/XphsX5MeBzppmDed2bocQwSfJBT5KuaN3UEE=;
        b=vGGsTAox+uWNsH8sVPdMUCOun67wEDc4rgj/SajAO9atqJmCwKcAQ0Bh1Ma9OJTiBw
         ihJUemoiGaOAm9lzPcprrGgg1/6hfYOOkwaYnzTO/+nQkuo80PmH7IuREi/9Ff5u2kXr
         /6jJPe3eydqJs7i/BgEkUsImnCAUjRPc9cCvrEiapNVFrMrKipvUOIsSTYViDKX1tiON
         +vmi9pUZklFNIduN4K0HJZkb08ozhV6Lz57A70cFz9eQLPzDJ1jorPmMNAzzWketipW1
         VOM9L2/P9j1bohPAs/q73C0IY3+DwRvLffTDBMsFiXgr4yvsV3aTlY3/vshd3qLIPDdj
         k9qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=aSZB7C/XphsX5MeBzppmDed2bocQwSfJBT5KuaN3UEE=;
        b=rQ+EWlIhdmBoGRJ/LEKcihjquIRPksUsyYANXQTT4RnUOsG6qKsjN7lOxBCqNxEQKB
         0N3FU56z9DI8TJr1I/9nSWy5S5D7qQQucfa/nwvAFFP35VusLTppiTd4DVqwYfp/LqR6
         I/AIJ/zKQLI1Z5M/aef59jnCRB4vk5IM/kfY73A/3KIoOAyrFjbykOxgtjnNMFy387pR
         l5+RudTSYBwJKAykOKf0zPELzhxvFBD5fa6xUzUYYkJlNiRbtd2Z1pJNbjCl1m1y5OJX
         y8wparYIIWdQLC9e4IwpJk7qzS5ZX3W0O+zPV3hfk5Ae+wSRAdPwFtH79bIgsWPd2tOC
         Wcsg==
X-Gm-Message-State: APjAAAXFDbt0NCtb0Oq/GZVm6xqyO4aa4T7VbbfcUgnh0KWcUhgH7zw2
        Z0mU8GhWIzfE90fCFm5tEyFMSRnk
X-Google-Smtp-Source: APXvYqxtld3tBLjQSam8ZH57nfC5Z7KnRvtcgeFgdtWijqnfg7meXKIAYuyZfv9wPzWhbUS8+YJ0+A==
X-Received: by 2002:a1c:1d46:: with SMTP id d67mr15433165wmd.98.1557956161623;
        Wed, 15 May 2019 14:36:01 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b194sm2198797wmb.23.2019.05.15.14.36.00
        for <kvm@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 14:36:00 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] vmware_backdoors: run with -cpu host
Date:   Wed, 15 May 2019 23:35:57 +0200
Message-Id: <1557956157-40196-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After KVM commit 672ff6cff80ca43bf3258410d2b887036969df5f, reading a VMware
pseudo PMC will fail with #GP unless the PMU is supported by the guest.
Invoke the test with PMU emulation to ensure that it passes.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 2abf6d5..ed47d3f 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -157,7 +157,7 @@ check = /proc/sys/kernel/nmi_watchdog=0
 
 [vmware_backdoors]
 file = vmware_backdoors.flat
-extra_params = -machine vmport=on
+extra_params = -machine vmport=on -cpu host
 arch = x86_64
 
 [port80]
-- 
1.8.3.1

