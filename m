Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5249B7BEB2
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 12:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbfGaKzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 06:55:49 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53179 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbfGaKzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 06:55:49 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so60289713wms.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 03:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=TDzD4mVy0JnW8wivYuq40NvZrehE5P3+AXFL+h905R8=;
        b=WNMsbmyz6D6vL9V6DopwuW1s80Gg6oqYGLlA0GJ8RnDqXKSMBuyTYqRBqfhzj9Vffq
         wl9a5rf74ruxe3IlxypYN4x9BVxL7mlQPHncZ0jmz8pBEGtUAlq88DV0+PNuEQokidbI
         01jJzGXYdAnjNlSgmwuOLPLupEQt93/+w7eji2TzrzBQG4t/JWkd3GctA3MGZbpVADTA
         6B1ItYcMYe+vJZQmPWGongPZrKj1kDGsrDGbxHDk0PuAb1ZzpGWQQimPQogwr2ESvDcR
         JzQuXGQUq4oyde/xmWLagYhdQLfu2Nvi6w80bNdvcg/Dv+8UtAmQOMIILMuZdUy9HJdN
         Um1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TDzD4mVy0JnW8wivYuq40NvZrehE5P3+AXFL+h905R8=;
        b=Z+KlLkb8MGGZauSXnxc0u3jP84tTXquBVJvQPzi/tU2jUPASVR5B6kSBQ++Wa5FgjQ
         lBufBIEHbm3sKZjCqBZ2EWc3SxoObSNZNeQLYFhXaLI7o0dn05QvGxDAnIHhLbPcy9X1
         CUm+37ZdVxsmy5fAmgxyxS5WvSrOs+l9no3w53USqVdCxig+JSTjalpcbKVjjqzjhBjm
         6tr5zQrtDPHKw7JCaIkgeG4qER1B4vcJ17315ggGgYr/E6ZWBirJzsg8P/CZfV6o2aB6
         tK5PLt5scQDjI6NgUJ2gOHmxiEAkRJ28glMD7+PBeHvL0zA5/eSLcpT/uAYSga20lC+/
         2UPQ==
X-Gm-Message-State: APjAAAU45eeuZdYOkLy/RFPCmbJDBZKzrKhLrwV282qlbCaYl+V6/lAa
        chzSI67m8optjCBgNMvFE8dz8Wh9oeIJMg==
X-Google-Smtp-Source: APXvYqzdekKZMBfdaKCjtzUencNZJvkLCqiIWA5u9hwHKpwmTeSFcpzTl4f4+JaBlbZ+1xTy2sL1sQ==
X-Received: by 2002:a1c:7d08:: with SMTP id y8mr93262568wmc.50.1564570546683;
        Wed, 31 Jul 2019 03:55:46 -0700 (PDT)
Received: from hackbox2.linaro.org ([81.128.185.34])
        by smtp.gmail.com with ESMTPSA id a84sm85426114wmf.29.2019.07.31.03.55.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 03:55:45 -0700 (PDT)
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
To:     linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        drjones@redhat.com, sean.j.christopherson@intel.com,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH] selftests: kvm: Adding config fragments
Date:   Wed, 31 Jul 2019 11:55:40 +0100
Message-Id: <20190731105540.28962-1-naresh.kamboju@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

selftests kvm test cases need pre-required kernel configs for the test
to get pass.

Signed-off-by: Naresh Kamboju <naresh.kamboju@linaro.org>
---
 tools/testing/selftests/kvm/config | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/config

diff --git a/tools/testing/selftests/kvm/config b/tools/testing/selftests/kvm/config
new file mode 100644
index 000000000000..3b1cbd726af6
--- /dev/null
+++ b/tools/testing/selftests/kvm/config
@@ -0,0 +1,26 @@
+CONFIG_ARCH_ENABLE_THP_MIGRATION=y
+CONFIG_HAVE_KVM_IRQCHIP=y
+CONFIG_HAVE_KVM_IRQFD=y
+CONFIG_HAVE_KVM_IRQ_ROUTING=y
+CONFIG_HAVE_KVM_EVENTFD=y
+CONFIG_KVM_MMIO=y
+CONFIG_KVM_ASYNC_PF=y
+CONFIG_HAVE_KVM_MSI=y
+CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
+CONFIG_KVM_VFIO=y
+CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
+CONFIG_KVM_COMPAT=y
+CONFIG_HAVE_KVM_IRQ_BYPASS=y
+CONFIG_HAVE_KVM_NO_POLL=y
+CONFIG_KVM=y
+CONFIG_VHOST_NET=y
+CONFIG_VHOST=y
+CONFIG_VHOST_CROSS_ENDIAN_LEGACY=y
+CONFIG_USER_RETURN_NOTIFIER=y
+CONFIG_PREEMPT_NOTIFIERS=y
+CONFIG_TRANSPARENT_HUGEPAGE=y
+CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
+CONFIG_THP_SWAP=y
+CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
+CONFIG_IRQ_BYPASS_MANAGER=y
+CONFIG_XARRAY_MULTI=y
-- 
2.17.1

