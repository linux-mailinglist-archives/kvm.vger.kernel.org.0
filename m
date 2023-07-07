Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C89074B5DE
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 19:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbjGGRd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 13:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjGGRdz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 13:33:55 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB8F1FE6
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 10:33:54 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id 71dfb90a1353d-4716e4adb14so763504e0c.0
        for <kvm@vger.kernel.org>; Fri, 07 Jul 2023 10:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688751234; x=1691343234;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4mMOiGGWfSgQUV0NfkWe8yufDp7AyZbYXXdDzBmEvKU=;
        b=MAxHnYzA5EIjqml/WSQZK9Z1mksPsbZAJHdmddPeh2/2igAnmPHbJ5HPh4QZUQ0PsP
         vqqf8k26Sq0Pzr35rpBA8DgbyvNkgiqg6igQ3FGsefgG/13OJSJN39hx1yMhGPDuv/dS
         yg0ynhkrO7u6yhbLyTYUEnxP2bJnrZamJM5eGrMpQgT0Z4rQFROxYX49gtSMZd7lOYfx
         YRZth89KBr0tlZzJ6Gw5V3dnesBunFf4C6YkRB0F8JnL5Jb0g08+0vWZ0feY3FWK893z
         0NTj2DXKwA4CifwoAtVmicBXZwSoLBLS+OG+a/t5sIF70DemdUMjxMbArHBKNO85JgZ9
         HtjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688751234; x=1691343234;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4mMOiGGWfSgQUV0NfkWe8yufDp7AyZbYXXdDzBmEvKU=;
        b=Z7N3KZiPWJLPzMViI/fBAHT1BVGUH2E37ZcYCqTbfTqYaEoTPgpzCpZot27iVxmTbm
         Jgasl4QSq6vtdQaezXfrEAaatwZHMl8xgM9HLM6JjrXxvwQWQA6RtxCHTPNPlLMJd4fu
         yeregl7UCKcjI0PccEmMewFXgP5ntZCSsoaJL/V+d1PKqhtj5sZlkHLtCKY3QYRDRvND
         81AfThC7J27ukKmILZcaHqmB4MjhbTiDcVUTdi1jLjjogiwU/KRROB2TR3oQROVxoiNB
         UtEBRRr73lmHqw92WFH/bsyZTDR7X8ymx4n/O46ipu1Q8kmvjSPpwc30wmc+hb42kADl
         e9sg==
X-Gm-Message-State: ABy/qLbra7UQMNjxUtHuXJVGl5m3YN5+3k7vlml/U3fZx3Rs72ttiuFD
        cnG9/R1eSWtlAsgsoe0g61EIPR+6HLxx51dP4/Vd4xNJNpeY8G0aFvQ=
X-Google-Smtp-Source: APBJJlFR4KNOJRbrQtlj8C2ws1LLrgKjQ8Vx35fAKhuAVMV1LErH4cOIuWnQm1EVnoRsJ6LuuI0NyqvlgSBWdFbbjO4=
X-Received: by 2002:a1f:3d11:0:b0:471:875d:598e with SMTP id
 k17-20020a1f3d11000000b00471875d598emr3772263vka.14.1688751233855; Fri, 07
 Jul 2023 10:33:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-8-amoorthy@google.com>
 <ZIoUc2hLd0zMOhO+@google.com>
In-Reply-To: <ZIoUc2hLd0zMOhO+@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Fri, 7 Jul 2023 10:33:18 -0700
Message-ID: <CAF7b7mrDH4Y+uWPW9kxL==i1LDURMHdNv+maFj_PH7jwPb3JwQ@mail.gmail.com>
Subject: Re: [PATCH v4 07/16] KVM: Simplify error handling in __gfn_to_pfn_memslot()
To:     Sean Christopherson <seanjc@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Done

(somebody please let me know if these short "ack"/"done" messages are
frowned upon btw. Nobody's complained about it so far, but I'm not
sure if people consider it spam)
