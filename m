Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DBF2D7F96
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 20:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732403AbgLKTow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 14:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbgLKToQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Dec 2020 14:44:16 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F413BC0613D3
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 11:43:35 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id c9so11948641ybs.8
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 11:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=wSUM7ixh9VMkFpje5luwKIhgx5NDbvRWAu95CbNOjek=;
        b=SdZCI7liBQDfdKPOf+3HtJOCKPkLxZo91GpyiM7eFBFlVYLWfbdNBLtZdRNRc9NYrZ
         U14PRtDkJSYDwJaKhWCEU+SIWffC02zh25U3WTnY5zqpr/gzfsYZ8wCvw3Ztmy430SsI
         /hPS6xGSFMjm0mh2TR8GH3IMHYVf7JYoRLaCnU5ZicV/k3BTi9dLhA7hGxpAYQOE7a+5
         xmVqmDx99ozjk6Fw0/7bRhf5q9VcHcAcZT25ictfT1MbMmIkiD49Z0yde7e3Z5YCs3CT
         Fu9iLeTIV4/zzact8tjTn1jnMnR97cRQly2JD3bAKTegCtHE4iYJwDAb3AUmIyNFLh9S
         3VpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=wSUM7ixh9VMkFpje5luwKIhgx5NDbvRWAu95CbNOjek=;
        b=cXtxde5lSklrEWwY6lLQE42bUX9eL/Od4FcZz64VRJcijFKpTHJsFd0m0a4myJia1c
         2hQAbjG3+MJ6r9UtdubJMzXO7GxA+l0UAvYZjZAXBTw1bXL9fH2p8TxtR/a2gP4Ck3pW
         bhracvBxAhZOWnQRVkrcBUxjVTdFWC93LH9kXYOA5cZMPQ539VVnd2YL0JRnA6IAV/0j
         26lrNI0P8z/I1nFIIMGXTc8hw3Gl2DXFwBKePUA0exvlDSzOnnlCShibBFfQU2w5sJgX
         RZe+cGifE4NPyLSq20qSql/xPO2tMQ0tq/XBhwgIgkQN6GwlCLvL7R2upb4po3u8p1sL
         wCwg==
X-Gm-Message-State: AOAM532Z7UZ8cFXDBfqrbMFYasNLauJQ0j9P6DgoOEtI/jy2xyP0aPTx
        czj1Rh+BDyRMM378DLv0pJMZ6kokn6iXwgaN+ZgvTHpTv0GyO65S3VQvTttWzqSQfyAcSaa/PYy
        RcsmrVZzcw3RnMJrxvWo0+fFCwY9sM8Nw9YEgBYjDOXpEgL/oqAo4WrUflaSAM+A=
X-Google-Smtp-Source: ABdhPJy7nQk61k18lUIMoXF0Pu8Es+1J5Or00pUsL4eY84XbJ+XtlFQTjPgYL7VdVJG4XYd6Zrqiu0sTU3mOeA==
Sender: "ricarkol via sendgmr" <ricarkol@ricarkol2.c.googlers.com>
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:5f44:: with SMTP id
 h4mr5787020ybm.505.1607715815207; Fri, 11 Dec 2020 11:43:35 -0800 (PST)
Date:   Fri, 11 Dec 2020 19:43:31 +0000
Message-Id: <20201211194331.3830000-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [kvm-unit-tests PATCH] Makefile: fix use of PWD in target "all"
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "all" target creates the build-head file in the wrong location when
using "make -C" or "sudo make". The reason is that the PWD environment
variable gets the value of the current directory when calling "make -C"
(before the -C changes directories), or is unset in the case of "sudo
make".  Note that the PWD is not changed by the previous "cd $(SRCDIR)".

	/a/b/c $ make -C ../kvm-unit-tests
	=====> creates /a/b/c/build-head

	/a/b/kvm-unit-tests $ sudo make
	=====> creates /build-head
		(note the root)

The consequence of this is that the standalone script can't find the
build-head file:

	/a/b/c $ make -C kvm-unit-tests standalone
	cat: build-head: No such file or directory
	...

	/a/b/kvm-unit-tests $ sudo make standalone
	cat: build-head: No such file or directory
	...

The fix is to not use PWD. "cd $SRCDIR && git rev-parse" is run in a
subshell in order to not break out-of-tree builds, which expect
build-head in the current directory (/a/b/c/build-head below).

Tested:
	out-of-tree build:
	/a/b/c $ ../kvm-unit-tests/configure && make standalone
	
	sudo make:
	/a/b/kvm-unit-tests $ ./configure && sudo make standalone
	
	make -C:
	/a/b/c $ (cd ../kvm-unit-tests && ./configure) && \
				make -C ../kvm-unit-tests standalone

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 0e21a49..e0828fe 100644
--- a/Makefile
+++ b/Makefile
@@ -101,7 +101,7 @@ directories:
 
 -include */.*.d */*/.*.d
 
-all: directories $(shell cd $(SRCDIR) && git rev-parse --verify --short=8 HEAD >$(PWD)/build-head 2>/dev/null)
+all: directories $(shell (cd $(SRCDIR) && git rev-parse --verify --short=8 HEAD) >build-head 2>/dev/null)
 
 standalone: all
 	@scripts/mkstandalone.sh
-- 
2.29.2.576.ga3fc446d84-goog

