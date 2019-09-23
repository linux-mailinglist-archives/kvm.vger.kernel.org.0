Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0B1BB2A8
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 13:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbfIWLMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 07:12:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbfIWLMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 07:12:15 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9CF8B10CC1F4
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 11:12:15 +0000 (UTC)
Received: from thuth.com (ovpn-116-120.ams2.redhat.com [10.36.116.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E95360BF7;
        Mon, 23 Sep 2019 11:12:14 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [kvm-unit-tests PATCH] x86/unittests.cfg: Increase the timeout of the sieve test to 180s
Date:   Mon, 23 Sep 2019 13:12:10 +0200
Message-Id: <20190923111210.9495-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Mon, 23 Sep 2019 11:12:15 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the gitlab-CI (where we are running the tests with TCG), the sieve
test sometimes takes more than 90s to finish, and thus fails due
to the 90s timeout from scripts/runtime.bash. Increase the timeout
for this test to make it always succeed.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 See for example this run here where it took more than 90s:
 
  https://gitlab.com/huth/kvm-unit-tests/-/jobs/301407814
 
 If you don't like the change in unittests.cfg, I can also tweak
 the (global) timeout in .gitlab-ci.yml instead.

 x86/unittests.cfg | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 694ee3d..e951629 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -172,6 +172,7 @@ file = s3.flat
 
 [sieve]
 file = sieve.flat
+timeout = 180
 
 [syscall]
 file = syscall.flat
-- 
2.18.1

