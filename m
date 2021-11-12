Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD7F44E77C
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 14:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhKLNkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 08:40:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231436AbhKLNkj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 08:40:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636724268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6cq2Esb5iKdBbRztuK1mvJNAfyvIP7lgfmlaMv3Qpjk=;
        b=QMpKDLYT8sx6U/dnxCYt7H8j0tul7QJoT70pMLCF8I62x9VMrKCIMl7ngJeDvwqRLavcYx
        9VzWrOAR2JAS/50Kjrywud6iuGI89ncRdy+TB0dQXxo+hDgR8IEUlKuNLQ2JK/bziunRO5
        c7qAusFL5DnEiQ997GVk4VjP7LjwFso=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-LixIfWZmOmCVjR1EynJJlQ-1; Fri, 12 Nov 2021 08:37:45 -0500
X-MC-Unique: LixIfWZmOmCVjR1EynJJlQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1FFC100C669;
        Fri, 12 Nov 2021 13:37:44 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.194.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1082860862;
        Fri, 12 Nov 2021 13:37:42 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com, marcorr@google.com,
        zxwang42@gmail.com
Subject: [PATCH kvm-unit-tests 1/2] unittests.cfg: groups should be space separated
Date:   Fri, 12 Nov 2021 14:37:38 +0100
Message-Id: <20211112133739.103327-2-drjones@redhat.com>
In-Reply-To: <20211112133739.103327-1-drjones@redhat.com>
References: <20211112133739.103327-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As specified in the comment blocks at the tops of the unittests.cfg
files, multiple groups assigned to 'groups' should be space separated.
Currently any nonword character works for the deliminator, but the
implementation may change. Stick to the specs.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 README.md         | 2 +-
 arm/unittests.cfg | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/README.md b/README.md
index b498aafd1a77..6e6a9d0429bc 100644
--- a/README.md
+++ b/README.md
@@ -101,7 +101,7 @@ host. kvm-unit-tests provides two ways to handle tests like those.
      a) independently, `ARCH-run ARCH/test`
 
      b) by specifying any other non-nodefault group it is in,
-        groups = nodefault,mygroup : `./run_tests.sh -g mygroup`
+        groups = nodefault mygroup : `./run_tests.sh -g mygroup`
 
      c) by specifying all tests should be run, `./run_tests.sh -a`
 
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index f776b66ef96d..945c2d074719 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -232,7 +232,7 @@ arch = arm64
 [micro-bench]
 file = micro-bench.flat
 smp = 2
-groups = nodefault,micro-bench
+groups = nodefault micro-bench
 accel = kvm
 arch = arm64
 
-- 
2.31.1

