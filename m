Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A005359F2D
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 14:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbhDIMsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 08:48:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233569AbhDIMsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 08:48:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6597D61178;
        Fri,  9 Apr 2021 12:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617972481;
        bh=01jspTSWm7bLXEJy5cH57gxxdERvRXGSivEgicYhRac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZnLzeh6l2g55cfYuzcG0DE0SLCajN0/Smc4h48GvGkxjCFxGCJb8AJfQJ3uoe3aS
         xddL7oE+1ApayJWqIGO76K/TTaQn6z7ToaccPknhLbpWpGLklbEgpiXmYIAgk8Zus0
         vGt2RcZCAbiErPqPNrnUrLNT29+gpJgwkVUGP3uuPXSMHo3Dew9an6yo3+EBQWncqE
         jXqeUiWf8Zs8Kk4Fu2hP0OOloofBopVDFVATqg+Dr6L5munEgZ3zMejAo6vIAHcTGW
         4woxFkqE5p96KxDxy/r/OnafHiBM2ncjqzZpZtiN65/BhwHmwFNnxlOBqUfO0qDuuf
         ejyEZNj9oFGsw==
Received: by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1lUqYE-001SLo-AU; Fri, 09 Apr 2021 14:47:54 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/8] docs: vcpu-requests.rst: fix reference for atomic ops
Date:   Fri,  9 Apr 2021 14:47:49 +0200
Message-Id: <fc194806772325d60b7406368ba726f07990b968.1617972339.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617972339.git.mchehab+huawei@kernel.org>
References: <cover.1617972339.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changeset f0400a77ebdc ("atomic: Delete obsolete documentation")
got rid of atomic_ops.rst, pointing that this was superseded by
Documentation/atomic_*.txt.

Update its reference accordingly.

Fixes: f0400a77ebdc ("atomic: Delete obsolete documentation")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/vcpu-requests.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/vcpu-requests.rst b/Documentation/virt/kvm/vcpu-requests.rst
index 5feb3706a7ae..5f8798e7fdf8 100644
--- a/Documentation/virt/kvm/vcpu-requests.rst
+++ b/Documentation/virt/kvm/vcpu-requests.rst
@@ -302,6 +302,6 @@ VCPU returns from the call.
 References
 ==========
 
-.. [atomic-ops] Documentation/core-api/atomic_ops.rst
+.. [atomic-ops] Documentation/atomic_bitops.txt and Documentation/atomic_t.txt
 .. [memory-barriers] Documentation/memory-barriers.txt
 .. [lwn-mb] https://lwn.net/Articles/573436/
-- 
2.30.2

