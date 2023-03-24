Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2376C895E
	for <lists+kvm@lfdr.de>; Sat, 25 Mar 2023 00:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbjCXXiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 19:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbjCXXiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 19:38:06 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B3BB445
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 16:38:05 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id s11-20020a170902a50b00b001a1f8fc0d2cso1980925plq.15
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 16:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679701085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PNQHc7+j5k4G3GKWcHuPMRCfr2auT/r3lxLrkI95edk=;
        b=MM0OI7VLCDdSfmtNZQLja50LXOeRA717Ok9X0E+qZTDtW0XF5IkuOArd8+Qbvoclyj
         UY5Dsn5ZioFyW4Bk5KmkRZ03C/QGudsZSf7QO2BYWKNi4ws+ik0QxAKNTxzPFi7jTlNq
         tt/bAjdawvk6fEEnt9qZztqeHN//bLZHunD8NB5LxIauDLNfgohbRECgV9xhMr6V92F1
         8rcuXRjhfH1MeEELm5l0W2IbqEtuQqWXQPVQckizW2S8gTUCb3Gs3HNvnt48W/iwziYw
         2+AC0K6CtArVRyz8hkZMfKzOvItWx/NTHXtBC2rWLc++JWhH0LSZYqxTSbI6hKE48eqO
         dwYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679701085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PNQHc7+j5k4G3GKWcHuPMRCfr2auT/r3lxLrkI95edk=;
        b=Xr1lmBjT5ViKL+L9OEwmHs+D51Ej8r0VwTc6koYumYFWjPiHw/VyjxvowGT5YudDgT
         r4oyOe5EJl7ZHtiCzI4W/YzVFyeE5a7IV/FYsV6HUb9xuwfo6/bwZmIinu+yFdBr1+Ro
         kQ6TcevLepVmx10WRSIjUK0cVAJZCqNIvZWKr2Ys2cr9cxkwffdxF3t7s7oKLWk0dioT
         zlo3o72t+/W1H2AnuqE68SSSMlpDf7PrswdgghyKYwmb8gCVy2NcRth1NkEfzQaIrhMS
         eAqSHScK47MQ4dT3mXKiCfOjINzgUUqoaTkx9rQaHp2MTF0KjjQnNWtBZY21e2Dc/Jsd
         1sNA==
X-Gm-Message-State: AAQBX9c1Ap4IY4PxS1mmzlgNUJe7XBngPvkyE1UMDmA7j5zkxxXRM7WX
        mLWXaIilPrX450kWm2euusBjXEPBHME=
X-Google-Smtp-Source: AK7set8W3IA/DOkfvDwAYbgvO1ETvvH8dCfFnzjBjs+aUfGnOVL9irCGhRTZzRZy311AhuOqMrSC+/9iGQI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a0b:b0:625:4ff8:3505 with SMTP id
 g11-20020a056a001a0b00b006254ff83505mr2566161pfv.1.1679701085351; Fri, 24 Mar
 2023 16:38:05 -0700 (PDT)
Date:   Fri, 24 Mar 2023 16:37:46 -0700
In-Reply-To: <20230217193336.15278-1-minipli@grsecurity.net>
Mime-Version: 1.0
References: <20230217193336.15278-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <167961301405.2556397.3492995846054138772.b4-ty@google.com>
Subject: Re: [PATCH v2 0/2] KVM: Minor structure layout changes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Feb 2023 20:33:34 +0100, Mathias Krause wrote:
> v1: https://lore.kernel.org/kvm/20230213163351.30704-1-minipli@grsecurity.net/
> 
> This used to be a more exhaustive patch set shrinking kvm_vcpu's size.
> But we concluded that this would be too fragile to maintain and would
> require a more radical layout change to group often used members
> together instead of chopping off individual padding bytes.
> 
> [...]

Applied patch 1 to kvm-x86 pmu, and patch 2 to generic, thanks!

[1/2] KVM: x86: Shrink struct kvm_pmu
      https://github.com/kvm-x86/linux/commit/12aad9164763
[2/2] KVM: Shrink struct kvm_mmu_memory_cache
      https://github.com/kvm-x86/linux/commit/f530b531fb9e

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
