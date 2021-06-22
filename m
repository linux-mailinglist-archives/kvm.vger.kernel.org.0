Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308213B0002
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 11:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbhFVJO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 05:14:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57785 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229486AbhFVJO7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 05:14:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624353163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1Igklq7VSMhkhXc/lnWk7BeO8P0U0v7mvbLRIWocBkU=;
        b=f9co3dHGbRFyjW5UEcYu48BPKfMVJzRsAYe5JeN18m0+XAcXyIkfbv7YKJFTimd23beqhs
        6wsyw5+CjqvFJjEnc94dTOXZD5eZC3z8lxtAOJdCa33iSV0lqKm6MTTyZeSnAKdldw92wS
        ktcDgu0/A4C9DYIFw2ppE9/G52f1kMY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-bPVNJgvxM-uBFwGRbNYhEg-1; Tue, 22 Jun 2021 05:12:41 -0400
X-MC-Unique: bPVNJgvxM-uBFwGRbNYhEg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9C008042FE
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 09:12:40 +0000 (UTC)
Received: from thuth.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BC4669CB6
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 09:12:40 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] Avoid backticks, use $() instead
Date:   Tue, 22 Jun 2021 11:12:37 +0200
Message-Id: <20210622091237.194410-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The backticks are considered as bad style these days, e.g. when checking
scripts with https://www.shellcheck.net/ ... let's use the modern $()
syntax instead.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 configure             |  2 +-
 run_tests.sh          |  2 +-
 scripts/arch-run.bash | 10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/configure b/configure
index 71aaad4..d21601f 100755
--- a/configure
+++ b/configure
@@ -13,7 +13,7 @@ objcopy=objcopy
 objdump=objdump
 ar=ar
 addr2line=addr2line
-arch=`uname -m | sed -e 's/i.86/i386/;s/arm.*/arm/;s/ppc64.*/ppc64/'`
+arch=$(uname -m | sed -e 's/i.86/i386/;s/arm.*/arm/;s/ppc64.*/ppc64/')
 host=$arch
 cross_prefix=
 endian=""
diff --git a/run_tests.sh b/run_tests.sh
index 65108e7..9f233c5 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -42,7 +42,7 @@ if [ $? -ne 4 ]; then
 fi
 
 only_tests=""
-args=`getopt -u -o ag:htj:v -l all,group:,help,tap13,parallel:,verbose -- $*`
+args=$(getopt -u -o ag:htj:v -l all,group:,help,tap13,parallel:,verbose -- $*)
 [ $? -ne 0 ] && exit 2;
 set -- $args;
 while [ $# -gt 0 ]; do
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 5997e38..9dd963b 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -111,11 +111,11 @@ run_migration ()
 		return 2
 	fi
 
-	migsock=`mktemp -u -t mig-helper-socket.XXXXXXXXXX`
-	migout1=`mktemp -t mig-helper-stdout1.XXXXXXXXXX`
-	qmp1=`mktemp -u -t mig-helper-qmp1.XXXXXXXXXX`
-	qmp2=`mktemp -u -t mig-helper-qmp2.XXXXXXXXXX`
-	fifo=`mktemp -u -t mig-helper-fifo.XXXXXXXXXX`
+	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
+	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
+	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
+	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
+	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
 	qmpout1=/dev/null
 	qmpout2=/dev/null
 
-- 
2.27.0

