Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9551127FA23
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 09:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731353AbgJAHWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 03:22:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36854 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731371AbgJAHWt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 03:22:49 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601536968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=q3VX2HZ1pS8feGfzyxG5cAr4WcdFjaSW4U4XDOx6dUk=;
        b=I8EiFcl21e68FgKIM8QP0YpUK0ybGNNOwte9J1yDKqfGV9vDFa8JSt4otp/R86u9ccJOLX
        86Acc2OxCPpqTP8Vqls36ztHKjxtGfVnwXaffedYS4nDTw3rfiLs776WU/kXC+wZBswl8F
        MRz1CTE9xmiSvaAg0lPjMot62LRdcbQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-LZL1d0qQMfa_XNBUWaD-YQ-1; Thu, 01 Oct 2020 03:22:46 -0400
X-MC-Unique: LZL1d0qQMfa_XNBUWaD-YQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8852C801AAC
        for <kvm@vger.kernel.org>; Thu,  1 Oct 2020 07:22:45 +0000 (UTC)
Received: from thuth.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B614160BF1;
        Thu,  1 Oct 2020 07:22:41 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, lvivier@redhat.com
Subject: [PATCH v2 3/7] travis.yml: Add the selftest-setup ppc64 test
Date:   Thu,  1 Oct 2020 09:22:30 +0200
Message-Id: <20201001072234.143703-4-thuth@redhat.com>
In-Reply-To: <20201001072234.143703-1-thuth@redhat.com>
References: <20201001072234.143703-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index 5cd6dbf..547d8d7 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -90,7 +90,7 @@ jobs:
       env:
       - CONFIG="--arch=ppc64 --endian=little --cross-prefix=powerpc64le-linux-gnu-"
       - BUILD_DIR="."
-      - TESTS="spapr_hcall emulator rtas-set-time-of-day"
+      - TESTS="selftest-setup spapr_hcall emulator rtas-set-time-of-day"
       - ACCEL="tcg,cap-htm=off"
 
     - addons:
-- 
2.18.2

