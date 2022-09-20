Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175DB5BDB3B
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 06:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiITEPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 00:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiITEPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 00:15:19 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A86827DD4
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:15:18 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 184-20020a2507c1000000b00696056767cfso1067155ybh.22
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=qjLjZKvyeIeRGOesNjjS3cTK/aOXc6uRAWIPLUpvrd8=;
        b=kxmzAzbRSSTmS/necb6FSVv6pOQxsL0i1TKoQQkJzxVpnz6tGtjcVaaklDcLGbUrk+
         joWUq64QCKwGg4ZH+Pmid3mVhBwqX/jtj6ocDSh60ZxPJbMfz793LvV1G1rOUSyWVMW7
         +YJTy+bqPqOwHDb2vJ5ZpuZbRONzDrfo1nmDJ0S751UuB3WUO9oobSow+G7IwVsGTFHk
         Y8Tx4t89Lh6aiwnZlAJgPwcmmaMsncZNCUw+ReiKUpUAW8PLOdJ1RAHq2oGtkbG6tLbb
         HWSvstxZ+QSgKh/OMYyPJr8FTKLATudnX55pqZnSKa2EARd9Cbd5zTrkxrUTXcLWIwwi
         HcCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=qjLjZKvyeIeRGOesNjjS3cTK/aOXc6uRAWIPLUpvrd8=;
        b=eMvXfmi0vJOCZHicDBB3lk+ftD/BsfMzkyl2wbuzRrc6UXHxNIM6OzdeMlbPFYp2by
         p+fHio0hWtfBTT2d8ukGq1qn5z5m6WQxhOAWKw1KCrh0qDSsxL+l4hHgbV9CcslHllhz
         SQ3f12Eqeatocue8HxObDWtL0Dfhzz6/EqYf0nPQyKfdefPb4spEyMyV89yVBnV5pxWO
         ysF+6kHcdI3i0+Qp+ypQncljjGd29+EVyc6W8DuE3w+JEW3BCwG1wwml8gnyOWdF8Ew+
         1wTqH6a3WwOnC7HBzg93u6msEdBRf0diik1+1cRxxZDNUeVqyXoVb4D26sTJHHL8B8wu
         YkGQ==
X-Gm-Message-State: ACrzQf2HuppgwgaPHyEsa83jrtS3kH+RZowTxipYVYRvMZrCa/+Xw6cH
        R0ELKACa4P1KCj2ElSxEB94o6A9Is7gmdDMcd1Rl2S4sL59Iulv68WzSevtH2IPFvg8enKpkyy6
        7zdrLSbSIUhfZZtkzOTfZgKkYehSLxw1Mm/xzs42y94Vym9jV2aRBvYKmzDIAJS0=
X-Google-Smtp-Source: AMsMyM4JNtOCdb6R8HptXS8YUiTx/ILZ4Xh5QhI7jbZOyJFuBxoaMBBtVCq8X3G0fqCqeU/ItHPx55UZnBKgNw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6902:1102:b0:6af:d093:7f2d with SMTP
 id o2-20020a056902110200b006afd0937f2dmr18517821ybu.642.1663647317295; Mon,
 19 Sep 2022 21:15:17 -0700 (PDT)
Date:   Tue, 20 Sep 2022 04:14:59 +0000
In-Reply-To: <20220920041509.3131141-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920041509.3131141-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920041509.3131141-4-ricarkol@google.com>
Subject: [PATCH v6 03/13] KVM: selftests: Add missing close and munmap in __vm_mem_region_delete()
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Deleting a memslot (when freeing a VM) is not closing the backing fd,
nor it's unmapping the alias mapping. Fix by adding the missing close
and munmap.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9889fe0d8919..9dd03eda2eb9 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -544,6 +544,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	sparsebit_free(&region->unused_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+	if (region->fd >= 0) {
+		/* There's an extra map when using shared memory. */
+		ret = munmap(region->mmap_alias, region->mmap_size);
+		TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+		close(region->fd);
+	}
 
 	free(region);
 }
-- 
2.37.3.968.ga6b4b080e4-goog

