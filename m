Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D35E3AE
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 15:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbfD2NZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 09:25:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbfD2NZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Apr 2019 09:25:47 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 22A108667B;
        Mon, 29 Apr 2019 13:25:47 +0000 (UTC)
Received: from flask (unknown [10.40.205.238])
        by smtp.corp.redhat.com (Postfix) with SMTP id 0F5A34387;
        Mon, 29 Apr 2019 13:25:44 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Mon, 29 Apr 2019 15:25:44 +0200
From:   =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH] Revert "KVM: doc: Document the life cycle of a VM and its resources"
Date:   Mon, 29 Apr 2019 15:25:35 +0200
Message-Id: <20190429132535.8302-1-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 29 Apr 2019 13:25:47 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This reverts commit 919f6cd8bb2fe7151f8aecebc3b3d1ca2567396e.

The patch was applied twice.
The first commit is eca6be566d47029f945a5f8e1c94d374e31df2ca.

Reported-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 Documentation/virtual/kvm/api.txt | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index b62ad0d94234..26dc1280b49b 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -69,23 +69,6 @@ by and on behalf of the VM's process may not be freed/unaccounted when
 the VM is shut down.
 
 
-It is important to note that althought VM ioctls may only be issued from
-the process that created the VM, a VM's lifecycle is associated with its
-file descriptor, not its creator (process).  In other words, the VM and
-its resources, *including the associated address space*, are not freed
-until the last reference to the VM's file descriptor has been released.
-For example, if fork() is issued after ioctl(KVM_CREATE_VM), the VM will
-not be freed until both the parent (original) process and its child have
-put their references to the VM's file descriptor.
-
-Because a VM's resources are not freed until the last reference to its
-file descriptor is released, creating additional references to a VM via
-via fork(), dup(), etc... without careful consideration is strongly
-discouraged and may have unwanted side effects, e.g. memory allocated
-by and on behalf of the VM's process may not be freed/unaccounted when
-the VM is shut down.
-
-
 3. Extensions
 -------------
 
-- 
2.20.1

