Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8951652F563
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 23:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353789AbiETV5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 17:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353784AbiETV5d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 17:57:33 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF5718C059
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:32 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id h31-20020a63575f000000b003f5eb841a0eso4697319pgm.8
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xju6GI4UHmGb+5whaNbhMW72VwBo+kXPtVjs0cWh6sY=;
        b=ffcBXpe7K5ooQbIfpQcMiz4klnhGmvBzTjvWeiwOHSC1YvvJCoRoY5/bQ97H5zgVIS
         zmULc3b2143PvpSjlvmIlkrAdceiic0oj0Ti6+iLN2yDFaMy1MJvCuT0j+fcr1B1ETBt
         zoxY37+jXEl395d7EPo/f6sKL2832+kHiZvjM3kmIgYKhL+7oAXMLTnwCzlP4UAYgguY
         /aPjhU8RRCfXM+oXfae+aWucnjaGAh4REQEabIZn+Hy9Xt+6iUSOWQ8CSoIPL9IYB7sZ
         L91/ichkJj6EbBBtjcb8L1x9X6ZQY1i9QxYoaxZULkuN6kvklBwLMmHWXGwjbCCeqQAL
         emSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xju6GI4UHmGb+5whaNbhMW72VwBo+kXPtVjs0cWh6sY=;
        b=NF8MMLaSjGfKr+U2P3DvdW0qOl+KhRyc3+5WzdWaxj75/uNtyX9kF1Vj15xHQImH0k
         +dJK8RX3QwV408d3Aum9eL8Bt/+i+dbhW6fumzjFkNVYf25zQcEXapflfWhDn08C+JRe
         ihd6Li+FmZiq5j6sV6NoogBgQWKlmGmimHy7m5KQFO/ojE1GqaWAv7WWxlOHUaiE8xG4
         B9xVoZAB/qkhqozwmT87MTgA6DNa6jKeOXYDS9jn1bvheG+KPBp/D36tF9OjmSEcHT0B
         U083DcZk6D4bb+NTHTejFGDhTGFlqSx2CT5ktVjiVaX+JvBUATye48R2F9XnJRgYjfIb
         MWWg==
X-Gm-Message-State: AOAM530PCPpgIf9xGtkXx4u7TdwiJHR+p6POuCuY20V3g0/4I588Sqqv
        n/DMq17nqblx3AxN81ag6cPBs6VCiEcLug==
X-Google-Smtp-Source: ABdhPJxcJsx4srU5/bYWG9TYS7AnIYDeXYJ0DpMuDup3NdAUPEgZtlai4SJeyuzkHbMYxq3SMpge0KkLB5JJLQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:ead5:b0:161:7a01:be10 with SMTP
 id p21-20020a170902ead500b001617a01be10mr11790245pld.4.1653083851802; Fri, 20
 May 2022 14:57:31 -0700 (PDT)
Date:   Fri, 20 May 2022 21:57:16 +0000
In-Reply-To: <20220520215723.3270205-1-dmatlack@google.com>
Message-Id: <20220520215723.3270205-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520215723.3270205-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v3 03/10] KVM: selftests: Drop stale function parameter
 comment for nested_map()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>
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

nested_map() does not take a parameter named eptp_memslot. Drop the
comment referring to it.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/vmx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index fdc1e6deb922..baeaa35de113 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -486,7 +486,6 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
  *   nested_paddr - Nested guest physical address to map
  *   paddr - VM Physical Address
  *   size - The size of the range to map
- *   eptp_memslot - Memory region slot for new virtual translation tables
  *
  * Output Args: None
  *
-- 
2.36.1.124.g0e6072fb45-goog

