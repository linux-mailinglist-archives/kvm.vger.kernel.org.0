Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC4B1C20C9
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 00:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgEAWg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 18:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgEAWg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 18:36:28 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B751CC061A0C;
        Fri,  1 May 2020 15:36:28 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id s30so9190201qth.2;
        Fri, 01 May 2020 15:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=//VBQlgz2QErWHs4KuQV+SD3b0MIBzsXmXLMl95zhSM=;
        b=tmyby0m5RDw9evb17SgY8Fd/Zj4gSnKLPkGIJ7GZiXa1nWbs1C5Zq4GUq5qcp9rkh+
         60AMcevYkZHMZnecNjHbrjtg0EToaP7PchW/S3TYQzEBiRhAsRWVC90QSt7jQhP7qU9G
         yfQNbeMxsq1ca4lQjaF/J+qpaI2BLrd0vXi6UKY5e3BJSaPs3j3KbA2Pr8jRs3A6eUF/
         hWuBw3KQfgzR7MntRCdS+BzluOY2ZLfOy2zkqa1FGVDvf0jO+M2/5RU1ZBYxPtGW/g+Y
         GX+LoueomxFdWudz5mFA1E9vg07z9h8D4pLb4c2eW8PHIDRwIUlYYJAJj/xZx1vz8nhJ
         DlSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=//VBQlgz2QErWHs4KuQV+SD3b0MIBzsXmXLMl95zhSM=;
        b=bKBTRb8hhHAop4/21RmlJ2rCEfIduodq/4tJbyt/vTWu+0WpQZpfDHwsxP4hXoUagu
         gxB6ouaoqAHuuKhXa2HWicWbENSOeJ8xb1SfSA8q4af2hgpidKN7Mjeg0Gg+ap1LrZtN
         3Jv1WqQ7MH6r4Woty4EwziJLSegIWx3zE0fAdX+fmFXfXNppdlFgzQv06ezXzTWXWZvu
         8zkq8jEwSDPwDrpLONW6/jCPvhVNGFgUbOW2VaXdcGzPV5GFR5b+eL66oUYFskqMGdjT
         0Kch16JIjJyj7etkruM+frAUnV1kP8B3/kHuyC5qfSkEyYduXRpJR8da7nazoTLth8P8
         jU4A==
X-Gm-Message-State: AGi0PuZmKzPZ5puyOHxL2Cs5N3m6z4PHKvvLiY0Flh7i/tXqFvUdWET+
        ro78khn+OwgR4sCgU2EcDrM=
X-Google-Smtp-Source: APiQypIPWHr5FoUb18G1X2SssTCIF+/SQKgp8wAoZR4JVUZTJuz+DvKbfIG42v83pL/M+W2M6g1DBw==
X-Received: by 2002:ac8:7ca2:: with SMTP id z2mr6151676qtv.122.1588372587911;
        Fri, 01 May 2020 15:36:27 -0700 (PDT)
Received: from josh-ZenBook ([70.32.0.110])
        by smtp.gmail.com with ESMTPSA id q62sm2629934qke.22.2020.05.01.15.36.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 May 2020 15:36:26 -0700 (PDT)
From:   Joshua Abraham <j.abraham1776@gmail.com>
X-Google-Original-From: Joshua Abraham <sinisterpatrician@gmail.com>
Date:   Fri, 1 May 2020 18:36:24 -0400
To:     pbonzini@redhat.com
Cc:     corbet@lwn.net, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, j.abraham1776@gmail.com
Subject: [PATCH v2] docs: kvm: Fix KVM_KVMCLOCK_CTRL API doc
Message-ID: <20200501223624.GA25826@josh-ZenBook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_KVMCLOCK_CTRL ioctl signals to supported KVM guests
that the hypervisor has paused it. Update the documentation to
reflect that the guest is notified by this API.

Signed-off-by: Joshua Abraham <sinisterpatrician@gmail.com>
---
Changes in v2:
    - Re-word documentation to be clearer. Also fix a small grammar
      error.

 Documentation/virt/kvm/api.rst | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index efbbe570aa9b..d2c1cbce1018 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2572,13 +2572,15 @@ list in 4.68.
 :Parameters: None
 :Returns: 0 on success, -1 on error
 
-This signals to the host kernel that the specified guest is being paused by
-userspace.  The host will set a flag in the pvclock structure that is checked
-from the soft lockup watchdog.  The flag is part of the pvclock structure that
-is shared between guest and host, specifically the second bit of the flags
+This ioctl sets a flag accessible to the guest indicating that the specified
+vCPU has been paused by the host userspace.
+
+The host will set a flag in the pvclock structure that is checked from the
+soft lockup watchdog.  The flag is part of the pvclock structure that is
+shared between guest and host, specifically the second bit of the flags
 field of the pvclock_vcpu_time_info structure.  It will be set exclusively by
 the host and read/cleared exclusively by the guest.  The guest operation of
-checking and clearing the flag must an atomic operation so
+checking and clearing the flag must be an atomic operation so
 load-link/store-conditional, or equivalent must be used.  There are two cases
 where the guest will clear the flag: when the soft lockup watchdog timer resets
 itself or when a soft lockup is detected.  This ioctl can be called any time
-- 
2.17.1

