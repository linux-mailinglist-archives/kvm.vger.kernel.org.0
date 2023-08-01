Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCFE76A570
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 02:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbjHAAVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 20:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbjHAAVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 20:21:36 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30114199E
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 17:21:34 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-564fb1018bcso61593117b3.0
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 17:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690849293; x=1691454093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MiBo42sK/GMXkVAkei5JHweORvWMqcmgUZYS33J6fF0=;
        b=xCOyw96l+NGIsCoqla91ojMChbo7SK0mxjsBS5En4m6U8FZuat4rWttoEUC2kEUlRC
         Kc5Tdi3f/aC074kdK9WPVcbpEqFOD5snoJtJRh/GW8NPp7DdzGioQ2jCQ53aKAAMVNgV
         H5LOLNlPJaayXRR+pgE4o+eqbb3X+xSKM0jo1106+iKscpzsP1EGPa0ydb/aj4FLtxsY
         0donlqAlwXUUmCYafnPKmqmI1HPi+8LHmgKCNUbUmu3rVwJ7KhsLSWeNCX/OGzUbsggN
         aeRLetSPiTZb1U7EoSaftIT6N09FIkj+uoCbe5WsmP3ETqmIpdraN0k9VEsoVBooWVQW
         kbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690849293; x=1691454093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MiBo42sK/GMXkVAkei5JHweORvWMqcmgUZYS33J6fF0=;
        b=G7PyCRS2TS4LxVFwR3r1hUBokKSBRml2MPzRX5E8UBY+DkHDvBm98RX1Ri27x48sFI
         Wn/KduH6WmeC1f1473Dp8kLcEFmlihX3HwZ645SXDHq/Z0FtAh1QkLgKyNcAjfJrvoVJ
         FKiqGc3Biyo0MzAY7d6VtNeoQA2cDJc4fXA2up7vaquFdbBv8RD0O3Q61o1k2k6252Hm
         M5XkJVMoSAlsoyxrgXtj4Y1FNXFLZvymG/LKJJD10Ld7ggQG5V3SjRFJLVbOvyDeUFkc
         UDpKZ7q1a9QYYMuRYv0hPM1MOw1ccaF5CwVjeNtqqrvWgOnSyMkCECTq+yJqL5Y/W22H
         SzNw==
X-Gm-Message-State: ABy/qLZ7z4hJnV5nmtfYJ0VPOrOagnSgVl1TbetoqT/+FPj4RRNrGfE1
        Lxk/VO8s0lmyA1PImqURv7OMIaBitFn4
X-Google-Smtp-Source: APBJJlGpUWg+0m6Di2ciPKp63ZPdDfCAbOAGMntPsJDwNxKLL6tSalkKPOVTHrd+Kt2b4p6aLGkz6Mdh0g5v
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a81:b710:0:b0:576:92da:cd3d with SMTP id
 v16-20020a81b710000000b0057692dacd3dmr79492ywh.8.1690849293487; Mon, 31 Jul
 2023 17:21:33 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue,  1 Aug 2023 00:21:22 +0000
In-Reply-To: <20230801002127.534020-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230801002127.534020-1-mizhang@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801002127.534020-3-mizhang@google.com>
Subject: [PATCH v3 2/6] KVM: Documentation: Update the field name gfns and its
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
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
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
 Documentation/virt/kvm/x86/mmu.rst | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
index 561efa8ec7d7..35e642303962 100644
--- a/Documentation/virt/kvm/x86/mmu.rst
+++ b/Documentation/virt/kvm/x86/mmu.rst
@@ -221,11 +221,14 @@ Shadow pages contain the following information:
     at __pa(sp2->spt).  sp2 will point back at sp1 through parent_pte.
     The spt array forms a DAG structure with the shadow page as a node, and
     guest pages as leaves.
-  gfns:
-    An array of 512 guest frame numbers, one for each present pte.  Used to
-    perform a reverse map from a pte to a gfn. When role.direct is set, any
-    element of this array can be calculated from the gfn field when used, in
-    this case, the array of gfns is not allocated. See role.direct and gfn.
+  shadowed_translation:
+    An array of 512 shadow translation entries, one for each present pte. Used
+    to perform a reverse map from a pte to a gfn as well as its access
+    permission. When role.direct is set, the shadow_translation array is not
+    allocated. This is because the gfn contained in any element of this array
+    can be calculated from the gfn field when used.  In addition, when
+    role.direct is set, KVM does not track access permission for each of the
+    gfn. See role.direct and gfn.
   root_count:
     A counter keeping track of how many hardware registers (guest cr3 or
     pdptrs) are now pointing at the page.  While this counter is nonzero, the
-- 
2.41.0.585.gd2178a4bd4-goog

