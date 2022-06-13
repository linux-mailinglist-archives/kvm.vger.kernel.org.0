Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D2A549C9C
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 21:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345942AbiFMTBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 15:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346242AbiFMTAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 15:00:20 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B65D99698
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 09:19:47 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id w36-20020a17090a6ba700b001e876698a01so6589358pjj.5
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 09:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=sy+hmtF7QKGhId1UgWThmfgFGGqtRHfIUJnJ5VlAWU0=;
        b=qrtFAHt9rp+72ySJkfHU7Fg5FmipHO1J6AWR5Swn2IiWMy2/NArZiMfakO3QjNb3B0
         GmjpctXxY4ozxNYdvp2wSgh09QgpjtMaIgjT1WIg90tbaktKV7yTsGpfOd2gaYI5xuQB
         kGPRBBtzQvy8WGwGe5wa2B0nZj5Gmc40dfzLhCPC8caKQnFlajkHevIoUpRhYJibO5Yl
         EIYL+U9VCoXKvpNF+1UjtfJlpK2J9aIlGi4gJmeGivVGYEa5j7asTZ0KmZ07pF5+Nhdr
         UXk7SGoTA0wkvw/PdN+7adsuXp6nExu+mo4SCI5aThjSUedxIF1z2QFwdQB0Hg2Pnasc
         E7jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=sy+hmtF7QKGhId1UgWThmfgFGGqtRHfIUJnJ5VlAWU0=;
        b=wQpaMjac6eDkEpGlqicGpzRARCzNwPjDjT7PcWkQF525K0zHykqxGvtC4SbiNfb4Lx
         hFqpbv4gm2C7Oxo9TmSk3StZAombquj2RRo6EvaVE6w1XaoscvfjA1607AqEcL1/G3w6
         InWEkAv9jLweeSc4q5ytgCcqRNJLoLAJZfrzH5Q5N9pxw2F/QKt3vstzo7RFojyfUmrj
         tDHwPi8hMOg1yhRBnYgYZZgZBbc+Eg4Vw3hlSj2417Yw0yv6sztDVUNM6AhHqUeC2FPu
         zjm3QUdkn8DXrIu88bJdzZODsbHcSPdthoiM0i9aqRN2JuD44082Rg22aFVz159OIDuw
         PT0g==
X-Gm-Message-State: AJIora+X7Vucguorhfkt9WDmUcVLfoSA+sDfuEaiGg6tcPUCxVcPhRZN
        auszdVxXunt1PQwGxZuqT7ZM24keif0=
X-Google-Smtp-Source: AGRyM1vE38OcLZYRVPHib6kgCVJ/M2iTypkcdODR6DxYQT/Af3g0vj733jESj1NcLT/9Rd2w3OiIJl6JOxs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:d50f:b0:166:41a8:abf5 with SMTP id
 b15-20020a170902d50f00b0016641a8abf5mr100470plg.17.1655137186866; Mon, 13 Jun
 2022 09:19:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 13 Jun 2022 16:19:39 +0000
In-Reply-To: <20220613161942.1586791-1-seanjc@google.com>
Message-Id: <20220613161942.1586791-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220613161942.1586791-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 1/4] KVM: selftests: Add a missing apostrophe in comment to
 show ownership
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Add an apostrophe in a comment about it being the caller's, not callers,
responsibility to free an object.

Reported-by: Andrew Jones <drjones@redhat.com>
Fixes: 768e9a61856b ("KVM: selftests: Purge vm+vcpu_id == vcpu silliness")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 39f2f5f1338f..0c550fb0dab2 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1434,7 +1434,7 @@ void vcpu_run_complete_io(struct kvm_vcpu *vcpu)
 /*
  * Get the list of guest registers which are supported for
  * KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls.  Returns a kvm_reg_list pointer,
- * it is the callers responsibility to free the list.
+ * it is the caller's responsibility to free the list.
  */
 struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vcpu *vcpu)
 {
-- 
2.36.1.476.g0c4daa206d-goog

