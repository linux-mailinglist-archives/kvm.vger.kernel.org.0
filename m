Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB33767925
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 01:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbjG1Xty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 19:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjG1Xtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 19:49:52 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3D1422C
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 16:49:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d087ffcc43cso2484224276.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 16:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690588191; x=1691192991;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DKuAUegaPzT2dlDDYBmBZr79HoAY+aEQdI3dh05x1do=;
        b=IHEo6B7QLOdOilVB5wc5aR/qpiIxDS03sgjaJUTOEJcD6VD61l9Lyy1JFy0LvDREO9
         FET/mL7wXo598iMXAYeEqcLFLCCp57wbjR6HQuS/Z6C8ADSCjceP4yMfaJ0tw5prWMpw
         2JpFGadvMn3PBiCc1JpOjLxl0DRKoktbH5ffR03xZ2bIslQYsbWKZJgcD5gYCPO52zSQ
         ocflUPkWAdb02Gk8/JK/K6DzWKS2jMQiF6lIZbbL++1gc6dI2CLX3tg77py5Pn+4uX8u
         D3qoNkTvtsuMxx9C3YzhpWTEXn2pzd+VXCFWoYJGeOpR8t2hXl7ej8sAr35DOqbhVSgd
         mMsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690588191; x=1691192991;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DKuAUegaPzT2dlDDYBmBZr79HoAY+aEQdI3dh05x1do=;
        b=cB5yUc65gGTcvZZrBa7rWPnPotN8DPKuYNynNz8NqqrPe9Knvx/s6QaxbfFdMdRV1+
         cPnekGFDXdB6vfMazXWB9nlYfXaPqOwdBug6sUjSPo0HCfaIN57Xtfz64t2uhfxIzkDM
         Onx/noL09QkvxNPG649WG1soOS3n02qEizbG9pvTNI9HRVP47k2WXj0LVElvXxMr4lyj
         vU7NO1EmwLzCrJGRee3/wUbXKL1Loxm31JCDumL5nNatHEpCbB0ErT8ThcXXvo2aCrFC
         roV0LVTVwxN4ogrHULkIvdF9HPibCsHCWtJOnx6XRTATBSJyHlgcdTB2qeJAg/+cMAZg
         NKUQ==
X-Gm-Message-State: ABy/qLZovLZTwsx7eAmwOOYJ3MfQV16+K9TlbLVFaLUZzTxdFHyD+JG7
        LYRDPznp8nUtLBA2N/EOlTaUPCFgiQQ=
X-Google-Smtp-Source: APBJJlGAkeWqd8KJHMn6lV6CBNP775TxKkAeVKZcTh6dZof9dTQs+DyK7ozs4XGf3NiPP8Svy1OAk6NS0so=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ae49:0:b0:d29:d655:2690 with SMTP id
 g9-20020a25ae49000000b00d29d6552690mr11054ybe.10.1690588191184; Fri, 28 Jul
 2023 16:49:51 -0700 (PDT)
Date:   Fri, 28 Jul 2023 16:49:42 -0700
In-Reply-To: <20230615063757.3039121-1-aik@amd.com>
Mime-Version: 1.0
References: <20230615063757.3039121-1-aik@amd.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <169058576410.1024559.1052772292093755719.b4-ty@google.com>
Subject: Re: [PATCH kernel 0/9] KVM: SEV: Enable AMD SEV-ES DebugSwap
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Alexey Kardashevskiy <aik@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 15 Jun 2023 16:37:48 +1000, Alexey Kardashevskiy wrote:
> This is to use another AMD SEV-ES hardware assisted register swap,
> more detail in 6/9. In the process it's been suggested to fix other
> things, here is the attempt, with the great help of amders.
> 
> The previous conversation is here:
> https://lore.kernel.org/r/20230411125718.2297768-1-aik@amd.com
> 
> [...]

Finally applied to kvm-x86 svm, thanks!  Though I was *really* tempted to see
just how snarky the pings would get at week 5+ ;-)

[1/9] KVM: SEV: move set_dr_intercepts/clr_dr_intercepts from the header
      https://github.com/kvm-x86/linux/commit/b265ee7bae11
[2/9] KVM: SEV: Move SEV's GP_VECTOR intercept setup to SEV
      https://github.com/kvm-x86/linux/commit/29de732cc95c
[3/9] KVM: SVM: Rewrite sev_es_prepare_switch_to_guest()'s comment about swap types
      https://github.com/kvm-x86/linux/commit/f8d808ed1ba0
[4/9] KVM: SEV-ES: explicitly disable debug
      https://github.com/kvm-x86/linux/commit/2837dd00f8fc
[5/9] KVM: SVM/SEV/SEV-ES: Rework intercepts
      https://github.com/kvm-x86/linux/commit/5aefd3a05fe1
[6/9] KVM: SEV: Enable data breakpoints in SEV-ES
      https://github.com/kvm-x86/linux/commit/fb71b1298709
[7/9] KVM: SEV-ES: Eliminate #DB intercept when DebugSwap enabled
      https://github.com/kvm-x86/linux/commit/8b54cc7e1817
[8/9] KVM: SVM: Don't defer NMI unblocking until next exit for SEV-ES guests
      https://github.com/kvm-x86/linux/commit/c54268e1036f
[9/9] KVM: SVM: Don't try to pointlessly single-step SEV-ES guests for NMI window
      https://github.com/kvm-x86/linux/commit/e11f81043a12

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
