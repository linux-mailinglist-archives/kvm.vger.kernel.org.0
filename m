Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8A91C1DF5
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 21:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgEATeL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 15:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726475AbgEATeK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 May 2020 15:34:10 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8A4C061A0C;
        Fri,  1 May 2020 12:34:10 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id i7so1916422qkl.12;
        Fri, 01 May 2020 12:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=kfVrPN6y9lsLFf6FqSXZapvj2RnD4kAcpEoqz9NVXVA=;
        b=l+M6ffx8Kub9ieJ5klTStggW2FMVS0kYfyOWyBXasFLngqRD92GB65VNCbXOh9HInw
         N55Re0WbtaIF7p2xBP/aunGnncfJ5xuyVUnDSuA0BKbZZk1FFgjLLeDiwUU/iRvSKrML
         EVVPH1W/I7tFsiclreaRCVEz+6rsvPjLKIarZ/HiGcXv6ilvX9bz3tZW7glktxoNU49g
         xA6U+500y+XE8Q1NEpvWOFA0tIRepTIgbMVezuv+ncVPzOJlI+43OdbHKkM8VM7mEtQD
         1EmQQ+e+rfj398T+qSu4Vyh3pco/q/GOn47Pc1Fa1SGKcutwsrVXAxmjTcY60eZEPfi7
         6PPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=kfVrPN6y9lsLFf6FqSXZapvj2RnD4kAcpEoqz9NVXVA=;
        b=RiR9Bd/sY271g5N3kEvSWp6fHh5+Wc5l/uL9mdsHB25sT6kgIDoBH9p+wL79DN5r+v
         acRlkEMkdgm6ESs9Ptkyy/g3rsO57uRxTDSlWNfksLvWkVt4Do+9omrTS6Msqp3F7Sa7
         JtU9Xjw96sLhym3Ymv6ez/4Cfu9p7L9AdYY/j2JovFcWdQINLVZgw1DmjPjW2REOO8v6
         NbiWx8Wv97bj2v6cUrzShmtEpgeACQLTJRBbp+9sc3poNA8+YF8YpOHW6qBkrWNqV2z3
         KhZqMwrGztY38SPLJxz1o8/AFnC1oxMGnPpx3hbvggIRnqUbNHuKMTEKa64QAJmaq1Ec
         zcCQ==
X-Gm-Message-State: AGi0PuZ8zMmRuow+chfy/I/DbOIOQD1k5IV5pTLQSumxNJRUdANCy5M+
        AGVtD43pWxLujsTDtKBnoovH1Vc5/Gtczw==
X-Google-Smtp-Source: APiQypJZPCbu5MQXz1ynhnhYrfqdUD4mueLaxvwiSauDlRPwu+3OvCoXPzjHW1cMBypPaUjLvyck1w==
X-Received: by 2002:a05:620a:2199:: with SMTP id g25mr648855qka.147.1588361649910;
        Fri, 01 May 2020 12:34:09 -0700 (PDT)
Received: from josh-ZenBook ([70.32.0.110])
        by smtp.gmail.com with ESMTPSA id u7sm3334136qkc.1.2020.05.01.12.34.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 May 2020 12:34:09 -0700 (PDT)
From:   Joshua Abraham <j.abraham1776@gmail.com>
X-Google-Original-From: Joshua Abraham <sinisterpatrician@gmail.com>
Date:   Fri, 1 May 2020 15:34:06 -0400
To:     pbonzini@redhat.com
Cc:     corbet@lwn.net, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, j.abraham1776@gmail.com
Subject: [PATCH] docs: kvm: Fix KVM_KVMCLOCK_CTRL API doc
Message-ID: <20200501193404.GA19745@josh-ZenBook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_KVMCLOCK_CTRL ioctl signals to supported KVM guests
that the hypervisor has paused it. This updates the documentation 
to reflect that the guest, not the host is notified by this API.

Signed-off-by: Joshua Abraham <j.abraham1776@gmail.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index efbbe570aa9b..06a4d9bfc6e5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2572,7 +2572,7 @@ list in 4.68.
 :Parameters: None
 :Returns: 0 on success, -1 on error
 
-This signals to the host kernel that the specified guest is being paused by
+This signals to the guest kernel that the specified guest is being paused by
 userspace.  The host will set a flag in the pvclock structure that is checked
 from the soft lockup watchdog.  The flag is part of the pvclock structure that
 is shared between guest and host, specifically the second bit of the flags
-- 
2.17.1

