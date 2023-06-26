Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD34873E7FE
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 20:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjFZSUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 14:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjFZSUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 14:20:38 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1BD10F9
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 11:20:31 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-66881827473so1571374b3a.2
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 11:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687803631; x=1690395631;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ImRtxMlYFksXesGcg5ZEwinCVjK+1eznyzb1zuEq5IA=;
        b=Tdy68PWDHkjiU3GFNBhBXBkqsqiqqWAGIXJ/q4OjjptAOSfM5EY42+vLqgA8D8nXAS
         clXF5BXCK0DJ71Va0Wz2nmU5U75ABUVVNq5Soj0T8VDpURZ3pOkkmiT0d6CAOe1ulwju
         zjeQJ1DH2VB+yypRy/vE4EAQw+QA0GV5wZ7PWldp9hocIQmtrsxFMYgGiycX6CpHqZ+C
         255CmNUW5d30tex1Crn09VGfnKT0f9g0h5xWaV48MbkB4xvLFFnOQMwOlGyQja8q+FmG
         9OnaPlIw+hwtf7bPt6nXd4VP1MQrnjlW8kFoiViD+b4ievS/+PZxZqEjIARqxF5GbQdU
         vW4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687803631; x=1690395631;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ImRtxMlYFksXesGcg5ZEwinCVjK+1eznyzb1zuEq5IA=;
        b=Xg+aqFcPbFrtPewSTqIfFfEt4JHo3F4n9MptBmefvJq9cGTA19ODS353yR/ZEWM32G
         HBl1eMcQs3CBXvCAMELwonBvC9d5TCxxaK+sZTlq4PW58yYbS32uXQ7YordkkmelosRi
         XbcC7HpuJ7S8fQSXUqJ9BZ6KGNq44kSnp7eRKsz6e02HZCBT3A2HwboXeZn4guxEU/hG
         wt01BualPdUME1qilmLBoYYm0IBizCpKPHaY7l4qv3DnVFcF7CrmySWjQlT4AMXJcGaM
         moYBHjYHuwZm2OuPK7VJ6F6e3Yer9Hz8gj1OJB/SeqbQp2zhz1PIHBqorHZYGT/D1YnS
         S9Ag==
X-Gm-Message-State: AC+VfDz9jM94Kmo/PjZy8v5lxFNNQufQELem14TObsnAdpNXHj/Y0ZMg
        7dvNn/13ZGgFn46fr8vYCGYkJ00gAH90
X-Google-Smtp-Source: ACHHUZ6Xm5XTTB6gU7PnMdzSwbfdec0L51WkX0uwv6yQ15WhSWbv1AKPANZ7pk/pz4xlrtsDhZ9AsKLmNz+V
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6a00:2d0f:b0:675:b734:d30f with SMTP id
 fa15-20020a056a002d0f00b00675b734d30fmr1001451pfb.4.1687803631156; Mon, 26
 Jun 2023 11:20:31 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 26 Jun 2023 18:20:16 +0000
In-Reply-To: <20230626182016.4127366-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230626182016.4127366-1-mizhang@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230626182016.4127366-7-mizhang@google.com>
Subject: [PATCH v2 6/6] KVM: Documentation: Add the missing description for
 tdp_mmu_page into kvm_mmu_page
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
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

Add the description for tdp_mmu_page into kvm_mmu_page description.
tdp_mmu_page is a field to differentiate shadow pages from TDP MMU and
non-TDP MMU. When TDP MMU is enabled, sp->tdp_mmu_page=1 indicates a shadow
page for L1, while sp->tdp_mmu_page=0 indicates a shadow page for an L2.
When TDP MMU is disabled, sp->tdp_mmu_page is always 0. So update the doc
to reflect the information.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 Documentation/virt/kvm/x86/mmu.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
index cc4bd190c93d..678dc0260a54 100644
--- a/Documentation/virt/kvm/x86/mmu.rst
+++ b/Documentation/virt/kvm/x86/mmu.rst
@@ -278,6 +278,8 @@ Shadow pages contain the following information:
     since the last time the page table was actually used; if emulation
     is triggered too frequently on this page, KVM will unmap the page
     to avoid emulation in the future.
+  tdp_mmu_page:
+    Is 1 if the shadow page is a TDP MMU page.
 
 Reverse map
 ===========
-- 
2.41.0.162.gfafddb0af9-goog

