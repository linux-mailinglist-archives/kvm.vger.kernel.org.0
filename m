Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65DF695D78
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 09:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbjBNItn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 03:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbjBNItl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 03:49:41 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14E617CDF;
        Tue, 14 Feb 2023 00:49:40 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so19616715pjq.0;
        Tue, 14 Feb 2023 00:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OeJOhh2HGXX9LbI5cEJ5vYHhA9gCjbhShPhnGBtGVak=;
        b=of2MaRkcIaWEyOkhWoFlgVZKqn5ch4pYM9WX2hK3tOe2PH46v2x4eZHr9M+iCZRKvK
         6MGy5y9IxBvYLJQIWDBpVoyqO8/ztTXr3bGZx8u3K6MOr43I5Dx237NGomwojnemPvFX
         a50atXgxeoOF6z6NMKJJdC+wETrkrJnDT754s89Ke/opNCqJhuVtI2OyJmasK7Je7fa3
         nNRuntgUrEo+CiyHpzjOpzibkYVRipy8cZEmhwn/Qp/FRXU1z64lsM4x2ZWC9aOlRn9e
         0Z5LfltzvijiricvFC/NGZItJ22EOJX84y39DloSG98k/9aDwH/2rZsbzBK56oCnPrY0
         bPUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OeJOhh2HGXX9LbI5cEJ5vYHhA9gCjbhShPhnGBtGVak=;
        b=pAiA0PbUZ4KO/os4AGT8USTgRdQgma7KTP45scMGk+5+D2ewRZuUvwopqSG6u8quwU
         KkblGFXRGyxfWINteTwij0JLe5bSJBnma7dLdNkc7KQSzlufkSqK1do64rIXOnEnps4D
         /XTrMwFPgzK1d4AmYhWJEzqZrc+jJlCcFWJIw25LClPkMo09DiiUjLKi3+Ql/E8rKbK3
         ut8Q9NMll/HNCS3zOLyXT2BerAntc+BjgXoV2pi9CVl+wr1lSKELb55cq6s18LwCw/Jh
         icuQl07pi87lOvMRkw3pJDCfKQbeBjn2G5xaUBrVM81RSMtBuT26tV0kheCcCKjNJfL2
         fqMA==
X-Gm-Message-State: AO0yUKXHf33RvVXPHEfHQx8bfNR8HGiOEC5bcE5Sl0pGGMc/x+DDn/wp
        aTsdqwd61eL7HfCV0MY/EHM=
X-Google-Smtp-Source: AK7set8Q+Eu3zg7EvCU/ToTkTUDcuJvnULed3uNEfScRES3cZ0Rk9Bjws2eSDpFI9haulXQyBYyjoQ==
X-Received: by 2002:a17:90b:1c0f:b0:233:fe38:e602 with SMTP id oc15-20020a17090b1c0f00b00233fe38e602mr1609791pjb.20.1676364580290;
        Tue, 14 Feb 2023 00:49:40 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id o9-20020a17090a3d4900b00233b1da232csm6549475pjf.41.2023.02.14.00.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 00:49:40 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: selftests: Report enable_pmu module value when test is skipped
Date:   Tue, 14 Feb 2023 16:49:18 +0800
Message-Id: <20230214084920.59787-1-likexu@tencent.com>
X-Mailer: git-send-email 2.39.1
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

Adequate info can help developers quickly distinguish whether the cause
is a code flaw or a platform limitation when a test fails or is skipped,
and this minor patch-set is doing a little work in that direction.

Base: kvm-x86/next

Like Xu (2):
  KVM: selftests: Add a helper to read kvm boolean module parameters
  KVM: selftests: Report enable_pmu module value when test is skipped

 tools/testing/selftests/kvm/include/kvm_util_base.h        | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c                 | 5 +++++
 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c | 1 +
 3 files changed, 7 insertions(+)

-- 
2.39.1

