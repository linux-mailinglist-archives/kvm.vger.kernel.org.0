Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582D82B9ABF
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 19:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbgKSShL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 13:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728908AbgKSShL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Nov 2020 13:37:11 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B606C0613CF;
        Thu, 19 Nov 2020 10:37:11 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id a18so5325732pfl.3;
        Thu, 19 Nov 2020 10:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:reply-to:mime-version
         :content-transfer-encoding;
        bh=12as8FlhjKsw6Yc9OgHJwzJoKwzpusnZd9yPEeWisJQ=;
        b=Lyj6PPZ+l5+1QVqnlOl2S2tCrsnUcYjCnxX2HiO+FVlduBUJMlQ/c7bFIXhkGAgJa3
         FVvgvtizoEGxXXOfX89ypoMYaqah529fTGIYPkOj+Uxihi+9WcthTxqc1s6JvRd7vpo/
         rSx/obTYb3JtpUgcU5YtILoSpeOrOMESpxxo2Ldu6lptGGuVNoYxOhtbDmxMyLf8t6PR
         kx6PVmofW6Oc6+Rj648br0+b7uEkB90xdZitlR60665OinNi+hXrvCPKVaulHTqISSlv
         m7xluoxpDGV3XihfPOcfN5u05PadGe24hLteDQz0+agmi5FLiWdOb5nlMDlEm8Gh9Igg
         JY/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :mime-version:content-transfer-encoding;
        bh=12as8FlhjKsw6Yc9OgHJwzJoKwzpusnZd9yPEeWisJQ=;
        b=pGP6Gm9VN2UBzfQhmOt7TQdaXwtg0dICn2hoea1h1czOiGpxp6LtLbFHmsU2z0XbMO
         BD3wUlbdqrJoB5q7QzclW1k6InrhMbEpDlOKdkHYtdqXc6r1dzSy9gMdy22oMSI7LidY
         RTk779V9QY00eJiTBaNirbgiuF6xzjc3u/tStlksW6koaLE0RZ1g3EdV8Jl/Rzlf/AcN
         oywXM1ezn3zbVsNGx8efmm/aqwUxwGxLHYugJKjwo7qn164jljHg53PsLQQx4e7M1lrm
         pYDdTwEC1puZucVYjr5+k6SEJOjwOaW2GZzBmcI1mBeH39F5uHz1LQnpGQI0hnP5eotW
         aD+g==
X-Gm-Message-State: AOAM531lbqr1CtlMXaQy3n4v0c619vn7TE+khVlGRtZjoHjjupaHt5eA
        gJ0PKSKOr0Pk2zGYPwWWGak=
X-Google-Smtp-Source: ABdhPJw/X81bu2htCXilelR2XkX2DvhC/1T2NPfXTlJav8EixSzp7vT8vcqh2eogM3F80vCyd5iQxg==
X-Received: by 2002:a17:90a:b904:: with SMTP id p4mr5488997pjr.81.1605811030710;
        Thu, 19 Nov 2020 10:37:10 -0800 (PST)
Received: from seanjc-glaptop.roam.corp.google.com (c-71-238-67-106.hsd1.or.comcast.net. [71.238.67.106])
        by smtp.gmail.com with ESMTPSA id b3sm525758pfd.66.2020.11.19.10.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 10:37:10 -0800 (PST)
From:   Sean Christopherson <sean.kvm@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH] MAINTAINERS: Update email address for Sean Christopherson
Date:   Thu, 19 Nov 2020 10:37:07 -0800
Message-Id: <20201119183707.291864-1-sean.kvm@gmail.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Reply-To: Sean Christopherson <seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Update my email address to one provided by my new benefactor.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: kvm@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
Resorted to sending this via a private dummy account as getting my corp
email to play nice with git-sendemail has been further delayed, and I
assume y'all are tired of getting bounces.

 .mailmap    | 1 +
 MAINTAINERS | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/.mailmap b/.mailmap
index 1e14566a3d56..a0d1685a165a 100644
--- a/.mailmap
+++ b/.mailmap
@@ -287,6 +287,7 @@ Santosh Shilimkar <ssantosh@kernel.org>
 Sarangdhar Joshi <spjoshi@codeaurora.org>
 Sascha Hauer <s.hauer@pengutronix.de>
 S.Çağlar Onur <caglar@pardus.org.tr>
+Sean Christopherson <seanjc@google.com> <sean.j.christopherson@intel.com>
 Sean Nyekjaer <sean@geanix.com> <sean.nyekjaer@prevas.dk>
 Sebastian Reichel <sre@kernel.org> <sebastian.reichel@collabora.co.uk>
 Sebastian Reichel <sre@kernel.org> <sre@debian.org>
diff --git a/MAINTAINERS b/MAINTAINERS
index 4a34b25ecc1f..0478d9ef72fc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9662,7 +9662,7 @@ F:	tools/testing/selftests/kvm/s390x/
 
 KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)
 M:	Paolo Bonzini <pbonzini@redhat.com>
-R:	Sean Christopherson <sean.j.christopherson@intel.com>
+R:	Sean Christopherson <seanjc@google.com>
 R:	Vitaly Kuznetsov <vkuznets@redhat.com>
 R:	Wanpeng Li <wanpengli@tencent.com>
 R:	Jim Mattson <jmattson@google.com>
-- 
2.29.2.299.gdc1121823c-goog

