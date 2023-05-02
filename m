Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F356F4A96
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 21:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjEBTu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 15:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjEBTuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 15:50:25 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EE611B
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 12:50:24 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f315712406so183739665e9.0
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 12:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683057023; x=1685649023;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aqI5T8eLMgeyqD26lhRa9P7yJtAZhZLu+/rRmSJfqpA=;
        b=mr/EA+sLRTXYRCpA7Ws/FAyfpXxhdIVTdxWL/lPo9ofzrRWsBdQlfnSG+d/rhLkxPI
         SykHb8O+2CiT7232YNKdqTsmCG0pi1ru2TVjPFtLakBzMyUQ7AM5vtiAAZLlF9OR0HhL
         NhhjW+xXBzwZ0N24/qMwJjMN5R88wWbHN0FVuj+wEl1FYN46m6M0ABsP0GYPmX/MmzGi
         Z+PpNHL0fQ2Bv8AWeCkKseu2blsDXs4CF654PyS8QT38NltPWCr/IO5+d69ruKb0KYTx
         FV2ex2NHrh11OqzPpOFq87KPP1VVPYn8bNewLsYwqX2LdqWkS72XBhfedqiSBCV7JdPn
         aIzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683057023; x=1685649023;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aqI5T8eLMgeyqD26lhRa9P7yJtAZhZLu+/rRmSJfqpA=;
        b=bjbRdkd+8sKlPrZZw0mdDgQule/oNCJGPA19S00kwihHp7nsWVkyDBghVscXVW53VX
         GA/OQECNeAgwQ7ynf1148eUZIJq1p3kLtBsWK1SJqA1+7PZDhSWxiDKbFqj32Lz4NW7l
         1tYA0h+1aMYjmiGdECzLqq2eMEei3De+wF0TLqHlkIicpGV/i3drinFCpHYgV7wDyQB3
         5k/GUjL2+zhFircDXxC0DVbeOcrItr1NQGjNQlvsrv6uAacavQPA5SCzw4PQV8qArRUs
         YWCj79b3SQSkFZJChjrvCfIM49KX3fC2ZbjjtvNjMJwbgqnTaNobdEbDL94OU50EgZnq
         tCAw==
X-Gm-Message-State: AC+VfDxA3BBHrx1Qc0+mcLhbEfnuydu17fAogEmmC/xOWPeccJVsMq50
        FPm/fqOy3JRvlBO1A/y5/A3N5FodjylORH7c9suXoQ==
X-Google-Smtp-Source: ACHHUZ49Qn3lCeoXNSoHPj9ir2pp1XXjSo3jgUFRk8BgO6qVl3wb4f7N2j2N+WRoNVcWSS8gdc3K0BrNVCIGYEG6deY=
X-Received: by 2002:a05:600c:1f14:b0:3f1:80d0:906b with SMTP id
 bd20-20020a05600c1f1400b003f180d0906bmr15121813wmb.4.1683057022778; Tue, 02
 May 2023 12:50:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-5-amoorthy@google.com>
 <CAF7b7mqq3UMeO3M-Fy8SqyL=mjxY4-TyA_PjgGsdVWZrsU2LLQ@mail.gmail.com> <ZFFbwOXZ5uI/gdaf@google.com>
In-Reply-To: <ZFFbwOXZ5uI/gdaf@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Tue, 2 May 2023 12:49:46 -0700
Message-ID: <CAF7b7moqW41QRNowSnz3E-T+VQMrkeJthDVxM2tuNHtJ5TTjjQ@mail.gmail.com>
Subject: Re: [PATCH v3 04/22] KVM: x86: Set vCPU exit reason to
 KVM_EXIT_UNKNOWN at the start of KVM_RUN
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        jthoughton@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
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

Thanks for nailing this down for me! One more question: should we be
concerned about any guest memory accesses occurring in the preamble to
that vcpu_run() call in kvm_arch_vcpu_ioctl_run()?

I only see two spots from which an EFAULT could make it to userspace,
those being the sync_regs() and cui() calls. The former looks clean
but I'm not sure about the latter. As written it's not an issue per se
if the cui() call tries a vCPU memory access- the
kvm_populate_efault_info() helper will just not populate the run
struct and WARN_ON_ONCE(). But it would be good to know about.
