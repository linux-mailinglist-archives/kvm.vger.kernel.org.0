Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B811734478
	for <lists+kvm@lfdr.de>; Sun, 18 Jun 2023 02:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbjFRAJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Jun 2023 20:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbjFRAJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Jun 2023 20:09:17 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1653170A
        for <kvm@vger.kernel.org>; Sat, 17 Jun 2023 17:09:15 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53b9eb7bda0so1045691a12.0
        for <kvm@vger.kernel.org>; Sat, 17 Jun 2023 17:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687046955; x=1689638955;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=v4DzIL/JVZchPV22EuNnJq/QdjxEQvSn2xrLtsDRw40=;
        b=WKB50UB0Mn3hH19NA/nQXNn4+OgIolVAiUqkFQCburr0Gk5bLVcJO0ERA6DsplScVO
         WGEXmbbUibqWtYGZd/7OQuoboJiIH++5nwxAZhSzT2C5EODsSvMTVefqmDd/hdpkwTSr
         jYBWaRY187nNjecdriEmiPHoWRRnGcXXaq7lMlwvT6OLaue5uK8YDrV79FP7A2WZC5nu
         kkEuqmmCQCaEbpEzi41NNFDBXqa38/4Dfg1teK1ACDBuvQJ4vdYkgC+HQVvrHff9cKF6
         tOerjifpAymfFex7td0LJ/dIrHdApOXgD8DDzUW2NwwDCEeBXY6/AL3fLfAj8nbo+0BU
         aMrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687046955; x=1689638955;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v4DzIL/JVZchPV22EuNnJq/QdjxEQvSn2xrLtsDRw40=;
        b=S9bHwjEmntOeLh7V8P4p3iQwsM1kb9HATxYhJHvCBlLgGHMLVUmzcpkMECr8/yG8kF
         H2MEukSEgkAxrqga2GwTdAtwgeMz0BEPBLvkGlaN76s+PTmysdg5C/Ww4ZzA826K8JOe
         0yLUqCj1whf6mY+nCCxXu3ZtWOCim+x5tA5SgsEztxvzan02mL42tyDVN0YEIqZvWCCO
         UzZcBKHTJM2XRtbOnUYHb+qYT72HnQSLQgGGK2/bKEtLsAFR2PsCgAzDSi3GdlFSxVik
         cAy5bD1obKGE7rbY9P+8/AC8Ji4JYzyV0Fj2tghiLiAO9RR67PRViAqiecuPCdOj57DJ
         UaKw==
X-Gm-Message-State: AC+VfDxGlNaNrfG97OhD6J5Gp6+6hZwB2ZSHFRkI0VH9E3+wL/hiWhJR
        D8FjYc/40cWyc3sDFio08OAWgZWxn6xN
X-Google-Smtp-Source: ACHHUZ6FM2shHdCtG4zHIoAoYPcYeJUqWXPelrDHcsq7bWlSJsIKfktBJmeYwjBAYAOYW9Saw4A54qRqqhhh
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a63:83c1:0:b0:553:3ba2:f36 with SMTP id
 h184-20020a6383c1000000b005533ba20f36mr417311pge.9.1687046955292; Sat, 17 Jun
 2023 17:09:15 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Sun, 18 Jun 2023 00:08:52 +0000
In-Reply-To: <20230618000856.1714902-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230618000856.1714902-1-mizhang@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230618000856.1714902-3-mizhang@google.com>
Subject: [PATCH 2/6] KVM: Documentation: Update the field name gfns in kvm_mmu_page
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the 'gfns' in kvm_mmu_page to 'shadowed_translation'to be consistent
with the code. The more detailed description of 'shadowed_translation' is
already inlined in the data structure definition, so no need to duplicate
the text but simply just update the name.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 Documentation/virt/kvm/x86/mmu.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
index 561efa8ec7d7..149dd3cba48f 100644
--- a/Documentation/virt/kvm/x86/mmu.rst
+++ b/Documentation/virt/kvm/x86/mmu.rst
@@ -221,7 +221,7 @@ Shadow pages contain the following information:
     at __pa(sp2->spt).  sp2 will point back at sp1 through parent_pte.
     The spt array forms a DAG structure with the shadow page as a node, and
     guest pages as leaves.
-  gfns:
+  shadowed_translation:
     An array of 512 guest frame numbers, one for each present pte.  Used to
     perform a reverse map from a pte to a gfn. When role.direct is set, any
     element of this array can be calculated from the gfn field when used, in
-- 
2.41.0.162.gfafddb0af9-goog

