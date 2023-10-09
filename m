Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8867BEB30
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 22:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378529AbjJIUGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 16:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378515AbjJIUGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 16:06:02 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D18A3
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 13:06:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d8997e79faeso5267697276.1
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 13:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696881960; x=1697486760; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mgUM1zPjlumMD3VBLFlCnfcUq27pdayX7zRx8uSu+k8=;
        b=Oo/wRl0cvbko3s18LCvBc21xY2UTkHKXhwcGApsSiHR8BKie02pQLd8yqOgPilh48R
         XYd16fTOecmH5PubyopcEKfjWSHCBrAC9LjLPhOQBzsJ6zkwIs6SK4IyeSBFhFfpNNdR
         +izzoWM9xRiM5MQObkSlmsbt+LFLSUEuzF3Jvnr0wveLrsTTG6/cgOmV+00BEnlI6tYP
         ly/EYNmiP/NRMGqo6JKQc709rD2FU2Sx6BRpfKEF7BH6p0sahx5DFkv1uxOInpp8dW9c
         x8LdT+93zyeNaMfbdvVgwycnlgVLIw+OzH63F+ZcE2sCLo5RMoNKYpxjunIxpOuQWOW8
         zfZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696881960; x=1697486760;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mgUM1zPjlumMD3VBLFlCnfcUq27pdayX7zRx8uSu+k8=;
        b=O+yKRWuMS/XiAqDMs+Hz2RJqDU3AkTU8fPFPtAT25wSaGYIJeSH+NOdQBdCpr4D98g
         oZjoA/Jyc7cj0G2KC71MGMGzLwd+eNU+neM3xTgLRzrPTPOB3RPufC7C75okKdA98pOA
         Lyb68hw5yKksd1CfZSkNZtv2SPXJNgcd3j05NdRFNvrt0VnK9vxFsdU4Tmpf/pSa/UUD
         o7jyLgZ5riaEM4TwhJjPOnuhu2wAcwr+PFYjrmSOU9Dg+1mcrmVEQuaoCkbd5L10Xd6v
         vcnsMXEDriI6kcdXUJKCUqoXm+Pf4aA2jObnMVGOjvfHQqpA4HE0/hJFSnHV2FJv3h9c
         tc1w==
X-Gm-Message-State: AOJu0YzdKjtcu2jH46kvzwdCTSq7NftAAmJ/Bhv+/i6hRoGf+FxHRDPx
        ZQ8Bz3mL7JUIeCXt3PWO89GgWstLUIw=
X-Google-Smtp-Source: AGHT+IFswUFYv+E1JAh0jUKucqfmy80VgTB8wOboFE+TaISabbXxXdFibYColR2QXqUnGv9EmScJfBNcrnY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6a04:0:b0:d89:42d7:e72d with SMTP id
 f4-20020a256a04000000b00d8942d7e72dmr276988ybc.3.1696881959859; Mon, 09 Oct
 2023 13:05:59 -0700 (PDT)
Date:   Mon,  9 Oct 2023 13:05:36 -0700
In-Reply-To: <20230929230246.1954854-1-jmattson@google.com>
Mime-Version: 1.0
References: <20230929230246.1954854-1-jmattson@google.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <169688028046.124915.12822717049960972546.b4-ty@google.com>
Subject: Re: [PATCH v4 0/3] KVM: x86: Update HWCR virtualization
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        "'Paolo Bonzini '" <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Sep 2023 16:02:43 -0700, Jim Mattson wrote:
> Allow HWCR.McStatusWrEn to be cleared once set, and allow
> HWCR.TscFreqSel to be set as well.
> 
> v1 -> v2: KVM no longer sets HWCR.TscFreqSel
>           HWCR.TscFreqSel can be cleared from userspace
>           Selftest modified accordingly
> v2 -> v3: kvm_set_msr_common() changes simplified
> v3 -> v4: kvm_set_msr_common() changes further simplified
>           HWCR.TscFreqSel can be modified from the guest
> 	  Targets reordered in selftest Makefile
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/3] KVM: x86: Allow HWCR.McStatusWrEn to be cleared once set
      https://github.com/kvm-x86/linux/commit/598a790fc20f
[2/3] KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
      https://github.com/kvm-x86/linux/commit/8b0e00fba934
[3/3] KVM: selftests: Test behavior of HWCR
      https://github.com/kvm-x86/linux/commit/591455325a79

--
https://github.com/kvm-x86/linux/tree/next
