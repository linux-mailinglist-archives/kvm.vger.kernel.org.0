Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7C16DFA94
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 17:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjDLPvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 11:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjDLPvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 11:51:01 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBE6728A
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 08:50:59 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54f810e01f5so39766347b3.0
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 08:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681314659; x=1683906659;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ogzsp2Zb5oW4pVyV0bLaflVZnjMH0psN7OLO8aR9z+U=;
        b=P4Q77Dt8KKqjxsvadieiyCHUhDBtlNXfW4kerlliv/IuwMrcjORNbIAEEjp/LVCboY
         HE5sHotnLn1MCziHYz1yqsm4UMSp9t6ScPEthqJB0oKYv5vLM9kSRMwMT4uR8sOe80Zk
         IdtyYqfBBGlMdG+wZcCAN8aMwYzx2oyWRXRWULawNtqeogSN+oLTau7yYNPB7S0T0+Xg
         /SSk6bxpEBgArcYHASwZZaoy3CMnY9Gufg81WUuJA+YBvAv8s+jhTicuGRQjr0nDlZB4
         5W/N28B56BxoVOYe3AnhrNT4tSS+SlxFOLaTtiqSyIxZwaOwggBOIFgJ++T2hcm2arRa
         yjEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681314659; x=1683906659;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ogzsp2Zb5oW4pVyV0bLaflVZnjMH0psN7OLO8aR9z+U=;
        b=ATYXmCK6YrRhN8pBUrGb3LZH4+/l1S3+xBsOmtDukZ2MSbnlwCSoLTiqwjHODGMDxg
         pvprZDWw6uRfQZkjPURCuUB39WPbHxn7GiDGRHdEzjaM2AgbwrqCEBFaNLf5tmVD0N5I
         t3wESZx2uOaUEsV31WUWs5F/1OR+yEMBzwqMcZfrYD1U4Q/XRUKYk2LEihXiPG4TArW/
         nwy5g0ZBhalPhFTj3VlKzlDCICE8qjBBPl5lzvhZUaCT05yIefnKIH67WP1Bj2uGg9yO
         24q4eHZT14BzO9u64OWIgpZ4FARpzxaljBBzBYCuDLBSH100u2BAtVLK21KmVXXoTVaa
         K5rA==
X-Gm-Message-State: AAQBX9dtoQ2RXP7TALRVwSUX7yIWJa5dwXIag/MMNVlA/bnk8MDUQUpF
        nZ43xhGw/1Bf6VKONferixjTnBqXXj0=
X-Google-Smtp-Source: AKy350ZxzccsV3vpmgHZjBcrZhDozNj2jpgFS5mxIJp24LtarbiEwtJ2n6Akktb8zEwWeGQEGnwknZAwnYI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:eb08:0:b0:54f:97dd:633 with SMTP id
 n8-20020a81eb08000000b0054f97dd0633mr1398481ywm.4.1681314659054; Wed, 12 Apr
 2023 08:50:59 -0700 (PDT)
Date:   Wed, 12 Apr 2023 08:49:43 -0700
In-Reply-To: <20230405004520.421768-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230405004520.421768-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <168123371052.1068870.10975257258289226380.b4-ty@google.com>
Subject: Re: [PATCH v4 0/6] KVM: x86: Fix unpermitted XTILE CPUID reporting
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 04 Apr 2023 17:45:14 -0700, Sean Christopherson wrote:
> This is v4 of Aaron's "Clean up the supported xfeatures" series.
> 
> Fix a bug where KVM treats/reports XTILE_CFG as supported without
> XTILE_DATA being supported if userspace queries the supported CPUID but
> doesn't request access to AMX, a.k.a. XTILE_DATA.  If userspace reflects
> that CPUID info back into KVM, the resulting VM may use it verbatim and
> attempt to shove bad data into XCR0: XTILE_CFG and XTILE_DATA must be
> set/cleared as a pair in XCR0, despite being enumerated separately.
> 
> [...]

Applied to kvm-x86 selftests (due to the dependencies on the earlier AMX
selftests rework).  Thanks!

[1/6] KVM: x86: Add a helper to handle filtering of unpermitted XCR0 features
      https://github.com/kvm-x86/linux/commit/6be3ae45f567
[2/6] KVM: x86: Filter out XTILE_CFG if XTILE_DATA isn't permitted
      https://github.com/kvm-x86/linux/commit/55cd57b596e8
[3/6] KVM: selftests: Move XGETBV and XSETBV helpers to common code
      https://github.com/kvm-x86/linux/commit/b213812d3f4c
[4/6] KVM: selftests: Rework dynamic XFeature helper to take mask, not bit
      https://github.com/kvm-x86/linux/commit/7040e54fddf6
[5/6] KVM: selftests: Add all known XFEATURE masks to common code
      https://github.com/kvm-x86/linux/commit/28f2302584af
[6/6] KVM: selftests: Add test to verify KVM's supported XCR0
      https://github.com/kvm-x86/linux/commit/03a405b7a522

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
