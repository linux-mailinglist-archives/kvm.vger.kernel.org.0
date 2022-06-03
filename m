Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C6153C1B0
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbiFCAnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239928AbiFCAnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:43:46 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC71344CC
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:43:44 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id i4-20020a17090a718400b001e09f0af976so3512110pjk.9
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ulJggE6LhTR+16Vtkph2cEVy2a+ANo/coZcby2aJbGE=;
        b=SARr3Yrp/NFPUl9skOlX3RHfpOAWZhBuwbwrslMgUBPAHtnRp5Caw+Q/hHmieJ74s9
         shPVTAB2wSEOjzdT710CzRzAKYd63QRV9VRoRGmx94bRUSYLLLoDr8R6HGQo3W59MEJt
         9IWJx54IFKcqPdWPUrrG3UNp5z9nvBD45x8JWAKpbznxVYE7m6EsRDU234McMD+9cUfN
         e353gQoT9s08/gq2+ZCujkQ2oh0Xvy0Wr/dobe7nPKgOJ99fbn7fZ8Xa22/ZlrXz3sBS
         vgy4bSpH7mu778h6turQOx0NQKfDCPug8WlPDK4XdwQGXVdRobEa1ooJ5/4HYYPA23mr
         YRkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ulJggE6LhTR+16Vtkph2cEVy2a+ANo/coZcby2aJbGE=;
        b=jxi3Af1tXGsly14mgvdjcXxV3YfVzPd2QSq7sKHCSf8T+WCJJ55n5amPNulMcQs1CP
         PO4/zTKOJdJ/3H4rXGKRRGGq8U/Gvq36dGCNmmdRH8HbmIBRkTPYosDqAJixym12sP7I
         DREKmuGP2hXd4eXTgdIg3sx91Fwmr2s87K0f6I9vDIVTeSSVEavnq+M+tsAooIY7hICF
         PbBn3E6ggrrSw6HRZyiOjalWOW9hv+kUOu7gJGxgHXRpJnch5IPYG3GOq8NNHnB9E1fN
         zWRtGQzrdIYZO0dlXJiAuyRrKBi+mFSrL690K3CyNLPOKcJI88VgwotzbJWiCVVOOM4a
         nWRg==
X-Gm-Message-State: AOAM532j8u2sJiIVARiHPog/B3MqkzDwrY8neUPyJ+3oRKniO09SgKeR
        YWonRAFUV7/Pl+0D2LOFRXbWFyZ4+X4=
X-Google-Smtp-Source: ABdhPJxF7YjHolpL9Nr4LGBBw5yquGD3KuzHOjpscMeGmzJC85pLAWv19iRBw2P1y+AMloJ4YweYHtAjnKc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce02:b0:151:a86d:dc2b with SMTP id
 k2-20020a170902ce0200b00151a86ddc2bmr7674812plg.57.1654217024150; Thu, 02 Jun
 2022 17:43:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:11 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 004/144] KVM: selftests: Drop stale declarations from kvm_util_base.h
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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

Drop declarations for allocate_kvm_dirty_log() and vm_create_device(),
which no longer have implementations.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 92cef0ffb19e..47b77ebda6a3 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -381,11 +381,6 @@ struct kvm_userspace_memory_region *
 kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 				 uint64_t end);
 
-struct kvm_dirty_log *
-allocate_kvm_dirty_log(struct kvm_userspace_memory_region *region);
-
-int vm_create_device(struct kvm_vm *vm, struct kvm_create_device *cd);
-
 #define sync_global_to_guest(vm, g) ({				\
 	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
 	memcpy(_p, &(g), sizeof(g));				\
-- 
2.36.1.255.ge46751e96f-goog

