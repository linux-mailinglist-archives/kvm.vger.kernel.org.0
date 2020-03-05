Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF7717A968
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 16:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgCEP5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 10:57:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46459 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726998AbgCEP5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 10:57:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583423836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=giheljeQP6Uu0Yz/rFBlh12QkzN9q9BUOHVrPPrqkx8=;
        b=HX5orCBVqSUEiQcESWb3nSt7EB5GfI+WGL3dewtZSp/970ljwfL6tN/OwezSZmee9gBb2F
        r+3cpk75oYmd6Jb2CdmFeuzPt05tUlkN4mjXyC8vx75jqYsOO6M5V5okJg4vFWl7H1C/R/
        F5czHRhS6v6xsjOBND3BC6xbQKKDZkY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-TyHK2V3BPEKePur92QHmXA-1; Thu, 05 Mar 2020 10:57:15 -0500
X-MC-Unique: TyHK2V3BPEKePur92QHmXA-1
Received: by mail-qv1-f72.google.com with SMTP id s2so3271709qvt.16
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 07:57:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=giheljeQP6Uu0Yz/rFBlh12QkzN9q9BUOHVrPPrqkx8=;
        b=I/E9j7TWVu4xrENqUyNzbnsBxvZIEo7qM5zTcBwyBnNH8y/uL1fy6QJOYm2eGXLXh5
         6KXhcPuXfLeUG7mcbjcmHjHv3jqvXNAt6TCXsK8vV5TpeEu29nJnPCvCWwGFRavnOuGQ
         QgU4cr4w12XEFIlYb1Q5dP8tdAQytDAMY1zKlUiZ0ANJAR0jQXJ//ioNyGPNDuPiexcD
         RCAp/QgIG/N0jUhbrHqPQytrI1ogFjRtXNk9w0KeIYI10NAA8xpTy9kbyQTPhJ96Xq9u
         KXGPuOxoNcaj56IqI8RCHREN2uWfn8n1TBDjawHm5OnPz9DQbEMVAAhLqAMpkwOdhhH9
         74BQ==
X-Gm-Message-State: ANhLgQ3PQNKckOIrhd1Vv+MyM6iktoJipfMr9h+rBRVCV8QLkl5ZQ3qj
        8RufDL1MBX71gcNqaZopt492rvl3q6lN+HYidsx7Rgosy/JXLJyht/CVoL7gc9U/474DOF5qV9m
        SvxoYF0JsUgAe
X-Received: by 2002:a05:620a:1278:: with SMTP id b24mr8060002qkl.387.1583423834576;
        Thu, 05 Mar 2020 07:57:14 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuS9VXeOpu9/W83Z1y6Y24APvGXa7o2yN6VxlQqagLVu9bnEMeqGkR1oGxJCIotDVDEQlOaQA==
X-Received: by 2002:a05:620a:1278:: with SMTP id b24mr8059984qkl.387.1583423834350;
        Thu, 05 Mar 2020 07:57:14 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id c13sm10172236qtv.37.2020.03.05.07.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 07:57:13 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     linmiaohe@huawei.com, Paolo Bonzini <pbonzini@redhat.com>,
        peterx@redhat.com
Subject: [PATCH v2 1/2] KVM: Documentation: Update fast page fault for indirect sp
Date:   Thu,  5 Mar 2020 10:57:08 -0500
Message-Id: <20200305155709.118503-2-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305155709.118503-1-peterx@redhat.com>
References: <20200305155709.118503-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

gfn_to_pfn_atomic() is not used anywhere.  Before dropping it,
reorganize the locking document to state the fact that we're not
enabling fast page fault for indirect sps.  The previous wording is
confusing that it seems we have implemented it however it's not.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 Documentation/virt/kvm/locking.rst | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index c02291beac3f..d045b2a89505 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -96,8 +96,10 @@ will happen:
 We dirty-log for gfn1, that means gfn2 is lost in dirty-bitmap.
 
 For direct sp, we can easily avoid it since the spte of direct sp is fixed
-to gfn. For indirect sp, before we do cmpxchg, we call gfn_to_pfn_atomic()
-to pin gfn to pfn, because after gfn_to_pfn_atomic():
+to gfn.  For indirect sp, we disabled fast page fault for simplicity.
+
+A solution for indirect sp is that, before we do cmpxchg, we pin the
+pfn of the gfn atomically.  After the pinning:
 
 - We have held the refcount of pfn that means the pfn can not be freed and
   be reused for another gfn.
@@ -106,9 +108,6 @@ to pin gfn to pfn, because after gfn_to_pfn_atomic():
 
 Then, we can ensure the dirty bitmaps is correctly set for a gfn.
 
-Currently, to simplify the whole things, we disable fast page fault for
-indirect shadow page.
-
 2) Dirty bit tracking
 
 In the origin code, the spte can be fast updated (non-atomically) if the
-- 
2.24.1

