Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDB759EFF5
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 01:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbiHWXrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 19:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiHWXrq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 19:47:46 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84AE78B2E5
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 16:47:44 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3328a211611so261917867b3.5
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 16:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=ut/GA+FacZO/IB75yXmt4cp0F5A6fO+XeMMzxlRyVIU=;
        b=cvNckTePqyKO1Mh/7TAP/WBZP+qSdz3i3TrGqaC0eQEVKAz+Qb+Apyk/bM/98OrDsm
         b3LcSyR7T4ZgjU7fNlm7pnbeS6dH+5m0RcADT3zB/3hL0zs+qvJNwbPms9/4JQfdSAeY
         mDESXd4zWNOfzwEvkqxJ/2PBE6yrKlC2REnoEO8X2kYFEJs2JgNGO+8OZJ+1fEm4Wvw0
         k++Y8iPuWlTCYZ/ABbm0idizeIZCVubCMpOL86WBnAMS6Fv6McfYvqQXbWlJxV0xbMz8
         l7Je9ry8yT6RYmYS9D8u0HhJ61qj2Gr8s3EYz3Io3ludDm/DJ1tPiU1HQgQnP5kvKVAE
         RCJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=ut/GA+FacZO/IB75yXmt4cp0F5A6fO+XeMMzxlRyVIU=;
        b=DtmNYWA9Nin/CLf0dNO7EyYEAOuq3Lm9UgIfw7Frd1oCKEpzQKouwAqH121sXo+BHF
         NInBvUQYtt5d/fXMjgv/PBFNUAhYfdFTGhmBcW6Ie6JrzTM1h/HYIpkPHLZQq2g32ZtU
         9H/7JPJoUWtEQKXuXS/Szd8bQ5Lm2zTgwIHPRVCk47GWBuhyysZhM9rzNpI6WOrHPMey
         dsIGuoxWJJvncY8Y1er4L5HL18R5orNFu/HLpozCkfCClB9AcJpCau8tWuezqRhldTxF
         /akYoSi9PQ+JddB/NHY66Tu/L6jJl3HH1x+xPTSkObDXGI0YRYZLPdgGM0mmFHlbSmqE
         QyzQ==
X-Gm-Message-State: ACgBeo1vy7WF2OJBu3L7g/VV0hxb9kJTKi3H/mNRDC9qBS6pI1CNC1r3
        N40lcKMk1HTeO4WPDwRDIsditbIZwpsuU7AVJcP0mA2gCQY7vpDi/+c6ZGLaPUcK59pPrOTay65
        CqmYAmjresokifRjVokF0znR/KErqwcbw6gEEG84UnVBue+4iCUYLj0qIb/6lh+Q=
X-Google-Smtp-Source: AA6agR4sRR2WWTTG8vwM/bgxmvAP2fbom624sLHsF0EtT7FtMy8KhHDQYKZdab9+Gf/VZnMuG6NGdHSK06u8ew==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a5b:5c4:0:b0:67b:89d6:cbf5 with SMTP id
 w4-20020a5b05c4000000b0067b89d6cbf5mr25468398ybp.286.1661298464038; Tue, 23
 Aug 2022 16:47:44 -0700 (PDT)
Date:   Tue, 23 Aug 2022 23:47:20 +0000
In-Reply-To: <20220823234727.621535-1-ricarkol@google.com>
Message-Id: <20220823234727.621535-7-ricarkol@google.com>
Mime-Version: 1.0
References: <20220823234727.621535-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v5 06/13] KVM: selftests: Stash backing_src_type in struct userspace_mem_region
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatclack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the backing_src_type into struct userspace_mem_region. This struct already
stores a lot of info about memory regions, except the backing source type.
This info will be used by a future commit in order to determine the method for
punching a hole.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 24fde97f6121..b2dbe253d4d0 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -34,6 +34,7 @@ struct userspace_mem_region {
 	struct sparsebit *unused_phy_pages;
 	int fd;
 	off_t offset;
+	enum vm_mem_backing_src_type backing_src_type;
 	void *host_mem;
 	void *host_alias;
 	void *mmap_start;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9dd03eda2eb9..5a9f080ff888 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -887,6 +887,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 			    vm_mem_backing_src_alias(src_type)->name);
 	}
 
+	region->backing_src_type = src_type;
 	region->unused_phy_pages = sparsebit_alloc();
 	sparsebit_set_num(region->unused_phy_pages,
 		guest_paddr >> vm->page_shift, npages);
-- 
2.37.1.595.g718a3a8f04-goog

