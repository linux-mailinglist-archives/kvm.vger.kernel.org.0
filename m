Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C4D277669
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 18:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgIXQQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 12:16:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33256 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726752AbgIXQQi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 12:16:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600964198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Y6S8pU2nQYTpJinNkJK17Qmf1PlZwC/pHcK4ltKc09s=;
        b=UNKElsR7ICqHNpMNbthzaf9w/61+PtA8NGuSethJEOkeKBGDIinQaQ0gp2z5A9EhsgaSqg
        5AUf165PhVJZbMtHjimrFpfKqLIAj8VGQ7MAS/NpkjrTdKSiS4iyb6FFP/2h09tOJSuq/Y
        zW/3Xvu81WOGPIV6GmECcokWk0cQFlg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-WpjpCq6qOlCGRFRJ03_YmQ-1; Thu, 24 Sep 2020 12:16:36 -0400
X-MC-Unique: WpjpCq6qOlCGRFRJ03_YmQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27F151007469;
        Thu, 24 Sep 2020 16:16:35 +0000 (UTC)
Received: from thuth.com (ovpn-113-113.ams2.redhat.com [10.36.113.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49F1373662;
        Thu, 24 Sep 2020 16:16:33 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Drew Jones <drjones@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH 4/9] travis.yml: Add the selftest-setup ppc64 test
Date:   Thu, 24 Sep 2020 18:16:07 +0200
Message-Id: <20200924161612.144549-5-thuth@redhat.com>
In-Reply-To: <20200924161612.144549-1-thuth@redhat.com>
References: <20200924161612.144549-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This test now seems to be working with the newer version of QEMU in
Ubuntu Focal, so we can run it now in the Travis builds, too.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.travis.yml b/.travis.yml
index 01951dc..7e96faa 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -92,7 +92,7 @@ jobs:
       env:
       - CONFIG="--arch=ppc64 --endian=little --cross-prefix=powerpc64le-linux-gnu-"
       - BUILD_DIR="."
-      - TESTS="spapr_hcall emulator rtas-set-time-of-day"
+      - TESTS="selftest-setup spapr_hcall emulator rtas-set-time-of-day"
       - ACCEL="tcg,cap-htm=off"
 
     - addons:
-- 
2.18.2

