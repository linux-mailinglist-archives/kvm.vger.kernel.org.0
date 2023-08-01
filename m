Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B746376A576
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 02:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbjHAAVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 20:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbjHAAVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 20:21:39 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0ECA1BC5
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 17:21:37 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-55c79a5565aso3053758a12.3
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 17:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690849297; x=1691454097;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kVIN1SxWU+09oSbIiYC5Gj1hDPsle00BScGOxCHhrag=;
        b=i2qQfafFamWuvPA18RkGa8E8zFcHZxADjKobAJAfD4VJl0KHKOIts34GO90Xxevqgc
         hl/SB+uKmk2pLiB+Pd8wvX8baxQPSWzwwsS4gu7CoO8hHrUQdLZarh468D1KcnEtSiKN
         MlsrnBB6f5tOLH4Y59PfUbZe02Ei0PNLblWdm3naMBwj9F57jp8VyaSAMai9p4va25V1
         AvwFWeYRcz8hCZPkGrLgoyNT4+NJM13b4w/QiVC7CGIwDLa2INndl+Jn/X7POqiuLf7H
         VH+RNYpsHrblm82aBL7y4qM/wa6Wfs+Of6krp49zjmSohfW0sj/XEmjFyxOaXt0Q0BKB
         GnqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690849297; x=1691454097;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kVIN1SxWU+09oSbIiYC5Gj1hDPsle00BScGOxCHhrag=;
        b=F6cXusq3Di3OwyEvuAcJEUVfeC22K70XeoQZRMLzXOCejRQ7gE7kUtxAALuE+eG9QI
         VvG5TbpxqdvKfhDyg0ZCr+1OzbV/ANH0x+i0PhfV9nMD3lSqYO1/BbWf0x/mcV9HYnqG
         Osij6z6s1Rn1BrG/uG8JxW3lrPj7nEXL8jWQG4sQx4L6qmeSQz08uOuvCh04o13cEsxC
         5oPnR/u2mmMuKVV2/ShCEVehcAwFfRI/ugLbSi0dBnDy3DgZMrwAubt5q0/CmB+qSYez
         viDE0TGxmtmsz0C6vB8RdUDbCUrDKEnsC6OF33WzwtOBBD9DWUvZSmXjuuEOh9pE6n0s
         ixWg==
X-Gm-Message-State: ABy/qLbe1WWHz2lapn2rzwspH+VNDdShxWfAl7+6dgzOrXQOTcUSzO9N
        dsl42GI+fYuSKoWdGImkBfSGHojwCRx8
X-Google-Smtp-Source: APBJJlELwnl3GUQy3Na83yDaRQb7sAcLNrn13muWfp9pcSJTl+zrx0TaA0fbVl0AY71dCRmOn2C9ltzLT5eh
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a63:374a:0:b0:55a:b9bb:7ca with SMTP id
 g10-20020a63374a000000b0055ab9bb07camr54208pgn.10.1690849296762; Mon, 31 Jul
 2023 17:21:36 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue,  1 Aug 2023 00:21:24 +0000
In-Reply-To: <20230801002127.534020-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230801002127.534020-1-mizhang@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801002127.534020-5-mizhang@google.com>
Subject: [PATCH v3 4/6] KVM: Documentation: Add the missing description for
 tdp_mmu_root_count into kvm_mmu_page
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the description of tdp_mmu_root_count into kvm_mmu_page description and
combine it with the description of root_count. tdp_mmu_root_count is an
atomic counter used only in TDP MMU. Update the doc.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
---
 Documentation/virt/kvm/x86/mmu.rst | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
index 17d90974204e..40daf8beb9b1 100644
--- a/Documentation/virt/kvm/x86/mmu.rst
+++ b/Documentation/virt/kvm/x86/mmu.rst
@@ -229,10 +229,14 @@ Shadow pages contain the following information:
     can be calculated from the gfn field when used.  In addition, when
     role.direct is set, KVM does not track access permission for each of the
     gfn. See role.direct and gfn.
-  root_count:
-    A counter keeping track of how many hardware registers (guest cr3 or
-    pdptrs) are now pointing at the page.  While this counter is nonzero, the
-    page cannot be destroyed.  See role.invalid.
+  root_count / tdp_mmu_root_count:
+     root_count is a reference counter for root shadow pages in Shadow MMU.
+     vCPUs elevate the refcount when getting a shadow page that will be used as
+     a root page, i.e. page that will be loaded into hardware directly (CR3,
+     PDPTRs, nCR3 EPTP). Root pages cannot be destroyed while their refcount is
+     non-zero. See role.invalid. tdp_mmu_root_count is similar but exclusively
+     used in TDP MMU as an atomic refcount. When the value is non-zero, it
+     allows vCPUs acquire references while holding mmu_lock for read.
   parent_ptes:
     The reverse mapping for the pte/ptes pointing at this page's spt. If
     parent_ptes bit 0 is zero, only one spte points at this page and
-- 
2.41.0.585.gd2178a4bd4-goog

