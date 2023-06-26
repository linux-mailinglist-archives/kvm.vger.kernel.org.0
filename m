Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC95D73E7F9
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 20:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbjFZSUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 14:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbjFZSUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 14:20:34 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F53E75
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 11:20:24 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b7f04caf5eso6952975ad.1
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 11:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687803624; x=1690395624;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qTMxx/LJnmIWvUmH+gdz70kQEF0zmvOjZ2b4ibjV0JA=;
        b=S4eXFyS5rCCSmx6iv7PwkGg0BQvm/qIBJWemgkd6QqmzpVRLetRiUZjak1W1mQyzZr
         mMKoaj7RIcwyjjYeEciNW4ODHuDXAB0C13yWbXWuat885LfNkeAe1aW17ajmWdoYdpXC
         lk8VuAdGvlhi04z5vwImriXcHwbtXGq5yiwmyAeXX64MSqe0tt/49ZE3I4ee91HgxP3c
         zZI/w6Nc73N8LQ4zawaNdpS2epI7IexAi7Wb/yi0aenclZFLqPugb8wyTg5JeBEyxrHx
         Xt5PuAKkhVJcUdmnZRtHtS5GOOJqKuDtYqs0xkgs9jrVWM7sdTirDlmdiNS+WWD/3Ss3
         DLzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687803624; x=1690395624;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qTMxx/LJnmIWvUmH+gdz70kQEF0zmvOjZ2b4ibjV0JA=;
        b=giNAWY36R0fE/ctkqHw7a94B0cHUplJaS2KASZZPwvhu6DAeGDDd/A4o3csypGTGPX
         dgAAM7RUGwzJPZvehyEOS16OlhCBQIWSBfEZ+s3XQI3KLsTTaCxOt4gLpqi9MlVPa+A4
         9n6cpzc2pQEc6B0GkIxO4zeqHMjbNdQOsJYZp2MMx+gjKejpaGvuxYLJzphnGoFTVmfS
         V8stJDMIn18fRkiZzABHRMNd3Z6epChcY3Emw4an+HxXpSNxemUXzjwmMUu8KYqeEuWa
         PdYkY8Zwtw4T7kB0TLjukvxGUVWlXL8lRG71lh/UNruoYMYIH3qcRVz1rL2W8xT4zZMQ
         7dzw==
X-Gm-Message-State: AC+VfDx5da1ItqeAzvrLFEK85+pasRGWtb66GKMITOi6PmfM59sN8f48
        Divjmpz+i3bkkJUZVRbGrvNzkVipwFxI
X-Google-Smtp-Source: ACHHUZ552kVkUSFqA9TwyT8wN0iazFX/dbob8KYbdGOsmC7IlUncgj9SPNf6gA/YueLd90akYh2M8MrAKzKf
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a17:902:b608:b0:1b5:bd8:5aaa with SMTP id
 b8-20020a170902b60800b001b50bd85aaamr1078296pls.1.1687803624119; Mon, 26 Jun
 2023 11:20:24 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 26 Jun 2023 18:20:12 +0000
In-Reply-To: <20230626182016.4127366-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230626182016.4127366-1-mizhang@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230626182016.4127366-3-mizhang@google.com>
Subject: [PATCH v2 2/6] KVM: Documentation: Update the field name gfns and its
 description in kvm_mmu_page
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the field 'gfns' in kvm_mmu_page to 'shadowed_translation' to be
consistent with the code. Also update the corresponding 'gfns' in the
comments. The more detailed description of 'shadowed_translation' is
already inlined in the data structure definition, so no need to duplicate
the text but simply just update the names.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
---
 Documentation/virt/kvm/x86/mmu.rst | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
index 561efa8ec7d7..4c9044b4dc6c 100644
--- a/Documentation/virt/kvm/x86/mmu.rst
+++ b/Documentation/virt/kvm/x86/mmu.rst
@@ -221,11 +221,12 @@ Shadow pages contain the following information:
     at __pa(sp2->spt).  sp2 will point back at sp1 through parent_pte.
     The spt array forms a DAG structure with the shadow page as a node, and
     guest pages as leaves.
-  gfns:
-    An array of 512 guest frame numbers, one for each present pte.  Used to
-    perform a reverse map from a pte to a gfn. When role.direct is set, any
+  shadowed_translation:
+    An array of 512 shadow translation entries, one for each present pte. Used
+    to perform a reverse map from a pte to a gfn. When role.direct is set, any
     element of this array can be calculated from the gfn field when used, in
-    this case, the array of gfns is not allocated. See role.direct and gfn.
+    this case, the array of shadowed_translation is not allocated. See
+    role.direct and gfn.
   root_count:
     A counter keeping track of how many hardware registers (guest cr3 or
     pdptrs) are now pointing at the page.  While this counter is nonzero, the
-- 
2.41.0.162.gfafddb0af9-goog

