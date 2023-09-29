Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0C07B2A51
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 04:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjI2CW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 22:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbjI2CWz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 22:22:55 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020691A2
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 19:22:52 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59f6902dc8bso197246847b3.0
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 19:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695954169; x=1696558969; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cCQmLrHNj6hBYxVHzs+GYHSoiBb3xQHe+uxIQTYV62w=;
        b=sXYphqcT8VcsIanol7GM82yrfDBPv3mMcuMOlcml1bgCGnXROOAroGv1RjDg6gKCWz
         C/gCVRdy0EXiYX5P2bYJ0N994H508wAqlD0sLmDD1yXmOrKbp7SbELd8keWFNRNR61Rz
         FjhWZ5cT3f9TvgmOlHhxfhfkR3JeYGUCqVTi3KuRaJre7TbMs4RtcLRgLDhq/7V5ssqP
         qfCkSMF13j2CbaUvEj1mba/T4Up1+Uwex6YzZjQkNtzx3vbdHsj8kylOBsBH1NQRXyDS
         EbvN4CU0iQ54JqGEGJWWFL0DDWSgYZYyZ4feq+kfm5maihX+4H8BiNN3V2dsgfPzqsNT
         jyxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695954169; x=1696558969;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cCQmLrHNj6hBYxVHzs+GYHSoiBb3xQHe+uxIQTYV62w=;
        b=lcyOo3J46wMUIyVLzlUntiEXfRpNnxe0/a1smwLaqFJCdblCSQxBaT1vCqX8oocWfI
         DUBsk3xVJjGjHrFdTnER54i81/WCwbOgPgfg7BffHVPKMJ7n5kjELLxeXEv0xpWIQhcs
         HUN5CCza4RzwnM3n9OlZlTntErrfSXRVzsFHfVEqxnIcU2jsEFaGtbLjIJCnmr8qhmEN
         IyOZL4fkM5z+OZ2wOJqoq0k9h0kya8oqcdrR8ThO+kNLRz0HLAUKcPZ12riYNhLRMaRx
         yQusGs8Z/YjHRsxX+1b8fIkoFsaw/8ijqfThWlERuLddzuvM/29G7Lm2kqOxN4Oku47x
         z2FA==
X-Gm-Message-State: AOJu0YwOEGbsKy0UWk7oFyBG4ZbPDer8LEZ6gjKfGywCLPf/pjLHBdP9
        6qOai57Z1df0zKToFUzJ8L6pENu4xko=
X-Google-Smtp-Source: AGHT+IEn1MTrZUTmzEwrrKm3Q2AHVsC4LZZBSFJ1rZfvxsZDnhNyQF36TYNYkaShIUmZ8FrkKwQb6H6e29Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7606:0:b0:d84:2619:56df with SMTP id
 r6-20020a257606000000b00d84261956dfmr45410ybc.13.1695954169592; Thu, 28 Sep
 2023 19:22:49 -0700 (PDT)
Date:   Thu, 28 Sep 2023 19:22:18 -0700
In-Reply-To: <20230921203331.3746712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230921203331.3746712-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <169595360540.1385318.4400894421413326576.b4-ty@google.com>
Subject: Re: [PATCH 00/13] KVM: guest_memfd fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Binbin Wu <binbin.wu@linux.intel.com>
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

On Thu, 21 Sep 2023 13:33:17 -0700, Sean Christopherson wrote:
> Fix a variety of bugs in the guest_memfd series, almost all of which are
> my fault, and add assertions and testcases to detect future regressions.
> 
> The last patch, renaming guest_mem.c to guest_memfd.c, is obviously not a
> bug fix, I included it here so that if we want to go with guest_memfd.c,
> squashing everything will be straightforward.
> 
> [...]

Applied to kvm-x86 guest_memfd.  I'll apply Mike's hugepage fix on top (when it
arrives), will send out a patch to fix the off-by-one reported by Binbin, and
will post a miniseries to clean up KVM_EXIT_MEMORY_FAULT.

[01/13] KVM: Assert that mmu_invalidate_in_progress *never* goes negative
        https://github.com/kvm-x86/linux/commit/46c10adeda81
[02/13] KVM: Actually truncate the inode when doing PUNCH_HOLE for guest_memfd
        https://github.com/kvm-x86/linux/commit/936144404469
[03/13] KVM: WARN if *any* MMU invalidation sequence doesn't add a range
        https://github.com/kvm-x86/linux/commit/1912c5dff3ac
[04/13] KVM: WARN if there are danging MMU invalidations at VM destruction
        https://github.com/kvm-x86/linux/commit/37bbf72db864
[05/13] KVM: Fix MMU invalidation bookkeeping in guest_memfd
        https://github.com/kvm-x86/linux/commit/b25ab9cae30f
[06/13] KVM: Disallow hugepages for incompatible gmem bindings, but let 'em succeed
        https://github.com/kvm-x86/linux/commit/1c297b84f3a4
[07/13] KVM: x86/mmu: Track PRIVATE impact on hugepage mappings for all memslots
        https://github.com/kvm-x86/linux/commit/26cf4453d2d9
[08/13] KVM: x86/mmu: Zap shared-only memslots when private attribute changes
        https://github.com/kvm-x86/linux/commit/fb6f779719ca
[09/13] KVM: Always add relevant ranges to invalidation set when changing attributes
        https://github.com/kvm-x86/linux/commit/69c7916df569
[10/13] KVM: x86/mmu: Drop repeated add() of to-be-invalidated range
        https://github.com/kvm-x86/linux/commit/e6b1a6922470
[11/13] KVM: selftests: Refactor private mem conversions to prep for punch_hole test
        https://github.com/kvm-x86/linux/commit/5782107f5d2b
[12/13] KVM: selftests: Add a "pure" PUNCH_HOLE on guest_memfd testcase
        https://github.com/kvm-x86/linux/commit/848d5faa2099
[13/13] KVM: Rename guest_mem.c to guest_memfd.c
        https://github.com/kvm-x86/linux/commit/6a92dc57b0e6

--
https://github.com/kvm-x86/linux/tree/next
