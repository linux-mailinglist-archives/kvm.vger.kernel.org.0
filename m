Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB61414978
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236050AbhIVMsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 08:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236097AbhIVMsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 08:48:41 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB988C061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:11 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id c21-20020ac85195000000b002a540bbf1caso9346898qtn.2
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RXQp8EhHyhXXySKkvUjyl1brDMjtu4rtTGvd2k1suTI=;
        b=s3+Mgqu8sfSi0tCYFDk4JwgQAxV1pz/6CO4GlvQdNLDT7G6pSVteqrVOUbJoNQUICx
         LPAepd4yvGh/3gSXd2CJz1kK14w6Nm8zL7ncfnx9iJ1CAINHfXbGYrOzC7+nUK9sOwDJ
         TRTbDtDkBYd2yp9w7m5pbi8ISYYfo5tAJQ+iiB2U0e7oNl0yZpepUFhPgrXK+zQxz2gq
         qPATu9Av7z25m0JBFjYVY4Gdy1woTsZHYxjRVdMn9Tu+zs3Ldi+eyk6f1OFiqe9uCn4o
         AMyzKKS4CA9z9xgmDH/DgDUCCRAKw+/tN4deBLr5pwMD+TSO5M8pPOU7OrlX2Zwhbr1c
         /alQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RXQp8EhHyhXXySKkvUjyl1brDMjtu4rtTGvd2k1suTI=;
        b=u8Vc/zKYR47nt6T7+xSx7Sp24NBdabZQsRFlJo3XDhC1cVOK0NjfTUFvwzMkA1RQpg
         PSfSaGSPrKlpcWE8tseB5i38RBGFdB3QiK8pAvcPVJQZne2UQA6iocLjJDTxvaNQKXnn
         6fFMkatGqlTJl1kscRXrWC2ABOJ+c2fKp88NZzfSyfTwlnjWGeS2dkDI/qwymHxz9SmA
         MinEZqlP8VGdh5lKYLkgzSQ1LSy0rpD0L3jJlq5n0u6EP5R8PhGPycSfMCtA2a3VKS3F
         IHQ5+gW2J4Pbe4JDTchvtF9/1ZjjBucuR6TT+XIxp1omlisFLNJ/eZAvxDUCkTXxRlCr
         jhnQ==
X-Gm-Message-State: AOAM53338CaAcEjDKPKwkeYIynGmFxQRbxc8BKNrvPL6R34lX/L0hcqt
        XF8G1zb+ps7YlHqxQBpV9/yQvx65Tg==
X-Google-Smtp-Source: ABdhPJzaj/UlUNVyzlfyuYkTDj+4eIBqbXRkw5oe7YW85EAs0vshHaSjcz6Z29FkHRA7oZj25ajpysCUvQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:45c3:: with SMTP id v3mr37263884qvt.41.1632314830924;
 Wed, 22 Sep 2021 05:47:10 -0700 (PDT)
Date:   Wed, 22 Sep 2021 13:46:54 +0100
In-Reply-To: <20210922124704.600087-1-tabba@google.com>
Message-Id: <20210922124704.600087-3-tabba@google.com>
Mime-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 02/12] KVM: arm64: Don't include switch.h into nvhe/kvm-main.c
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

hyp-main.c includes switch.h while it only requires adjust-pc.h.
Fix it to remove an unnecessary dependency.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2da6aa8da868..8ca1104f4774 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -4,7 +4,7 @@
  * Author: Andrew Scull <ascull@google.com>
  */
 
-#include <hyp/switch.h>
+#include <hyp/adjust_pc.h>
 
 #include <asm/pgtable-types.h>
 #include <asm/kvm_asm.h>
-- 
2.33.0.464.g1972c5931b-goog

