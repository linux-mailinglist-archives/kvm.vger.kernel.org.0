Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8659A6279A1
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 10:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbiKNJ4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 04:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235804AbiKNJ43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 04:56:29 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE046350;
        Mon, 14 Nov 2022 01:56:28 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id b11so9874397pjp.2;
        Mon, 14 Nov 2022 01:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PBMjCbtkIrxMRKIb6zPikezyi8Od6LCYWau7l7rE+mY=;
        b=OoRDgpH253Ru3XLAFGlHbIIR8LjoVxyr0fA82tB9/eW6OHFzHSX9kaT8uiO3/u2qdN
         moSqcYbtTHAYozEgB5x6KEPf2XzQKoRJxmUcNgA1wZ1/QUYg476hkXNu0y9p8y2Q5QMC
         0Kg4KnxVnGIn+uUbWV2gdoGCHj9ZT1uI3yTwns1/vYpaNzZuzCAXABULrYrlL/RFLjxE
         /bGHHlNs+ytZSnGoPmTGMvy+R9CItCpRC/r/4CqRp+1GTvpi6zdN2g0rh9F18yEhimZQ
         TG9r4ue0c8ZFrtmptUNk6x07KVZmi5LdZfXHygHcv2bjGaoO2tozjV4qaQocKuBvF7TS
         IVZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PBMjCbtkIrxMRKIb6zPikezyi8Od6LCYWau7l7rE+mY=;
        b=jXfhN9qdtLVukQmz4wU6DXoamTdWGR9IvJDxe7pKzt9z7GjIFPXzsLruCazQvkDhHE
         7wezeB2fY2LlCf3iBM/J58NVThOic6pfaPIxTF1jIHOC0cA0IGnQBbbadPExSUsRhz/u
         nhO2dYSlEYjM/siaLUDc4H9VcCU0Odw+q1+YdQLuYGr6sjZQ635dCGv4lcoMKBHDbPCQ
         4sl7Lo1QD0pV2dXOCDeDmvprbcN/ssUcQgUf9nUckRy9c8/RZ0oPbf5r62MWJw3TY1Dv
         iMTcBUW2yjd92CwHjINZgEOKKzUJrRyETSRfkSnPDqvUXJayiYzOspz2LvhrAu8yJ135
         r6YQ==
X-Gm-Message-State: ANoB5pl3/eB09TjAFu5SMTQNZUSjfqz79c+2I8XgTyUxu9s8ZWhkWuLz
        sDb65hOrLkgZwAuoHjytQ+M=
X-Google-Smtp-Source: AA0mqf4REbJhAuiqN5nHAIljBGwl4C2S/omJHvrNmtbjmW1+83cKhW445mB3UcVXbp161L1XzI5Tzw==
X-Received: by 2002:a17:902:ef84:b0:186:7e8f:54dc with SMTP id iz4-20020a170902ef8400b001867e8f54dcmr12794518plb.156.1668419788319;
        Mon, 14 Nov 2022 01:56:28 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d29-20020aa797bd000000b0056c6e59fb69sm6266472pfq.83.2022.11.14.01.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 01:56:27 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/14] KVM: x86: Remove unnecessary exported symbols
Date:   Mon, 14 Nov 2022 17:55:52 +0800
Message-Id: <20221114095606.39785-1-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inspired by the Sean's minor fix [1], more unnecessary (from a GPL
developer's perspective) exported symbols could be cleaned up
(automation to find out true positives is possible). This move helps reduce
the attack surface of KVM modules and guides more developers to practice
the principle of low coupling in the KVM context.

[1] https://lore.kernel.org/kvm/20221110010354.1342128-1-seanjc@google.com/

Like Xu (13):
  KVM: x86: Remove unnecessary export of kvm_inject_pending_timer_irqs()
  KVM: x86: Remove unnecessary export of kvm_get_apic_base()
  KVM: x86: Remove unnecessary export of kvm_set_apic_base()
  KVM: x86: Remove unnecessary export of kvm_inject_page_fault()
  KVM: x86: Remove unnecessary export of kvm_inject_nmi()
  KVM: x86: Remove unnecessary export of kvm_require_cpl()
  KVM: x86: Remove unnecessary export of kvm_emulate_as_nop()
  KVM: x86: Remove unnecessary export of kvm_scale_tsc()
  KVM: x86: Remove unnecessary export of kvm_vcpu_is_reset_bsp()
  KVM: x86: Remove unnecessary export of kvm_hv_assist_page_enabled()
  KVM: x86: Remove unnecessary export of kvm_can_use_hv_timer()
  KVM: x86: Remove unnecessary export of kvm_lapic_hv_timer_in_use()
  KVM: x86: Remove unnecessary export of kvm_apic_update_apicv()

Sean Christopherson (1):
  KVM: x86: Remove unnecessary export of kvm_cpu_has_pending_timer()

 arch/x86/kvm/hyperv.c |  1 -
 arch/x86/kvm/irq.c    |  2 --
 arch/x86/kvm/lapic.c  |  3 ---
 arch/x86/kvm/x86.c    | 18 +++++-------------
 arch/x86/kvm/x86.h    |  2 ++
 5 files changed, 7 insertions(+), 19 deletions(-)

-- 
2.38.1

