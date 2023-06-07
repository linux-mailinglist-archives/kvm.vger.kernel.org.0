Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC977272FE
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 01:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbjFGXaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 19:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbjFGX36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 19:29:58 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6B32680
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 16:29:57 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53fa2d0c2ebso2556357a12.1
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 16:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686180597; x=1688772597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vjeKInn9gjG8HMVAErb1KMxC08D7u0Ul0IRLypZYJps=;
        b=73CL+PcPPLrgWB/qsX70HH/RcLjkCVbprTkL0fgQ7/0ZU27W9HVD8X60PsE/C2BtVg
         +WvTsjQzgmbKR5bPo0ELiaOMaeXZu/zvI7fBN/fGe+wjQ6EY7jJGzPjxdb7ufjk6NkRi
         Odjbh4bGnvPVKYCHFmJSda/TW9bE8BmQNpzUrn1x+VWWAjq2kziA9qQ6ZDTFHgURLJnU
         /RZf7N/s3GHAzXa13e3h9OZ88a+YKvHiqwjfX4bXLYpAn3quvjKG4ZG97a+zuYeiNvJz
         FPgdS47YHVpIe0ALJqvNu40b9TpA8KxDtZXRQdYh0XUoIhDdPKfm9FAt6oP1vX4aDQNl
         3mjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686180597; x=1688772597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vjeKInn9gjG8HMVAErb1KMxC08D7u0Ul0IRLypZYJps=;
        b=OGl6RUQrU79P5acVABVvIv67suUh6lkhUf9mFmTmQbYYzaXR+hzNYOzN3n9ODg+Vry
         AXfqFb0Mve0lywxTQ2Ne5xzIpYQNj5awEll1LuLGzprAo1bgSshAJZcBFdYtk+Gn6yUP
         ipfQf0UjERh6cbUOzmb/fPAbYaxiWJmxqi8erD9aU2AAMYC+3bim3+UFxYlbHa5ZVOuB
         Yu0v18fhJ27/xMa76EaeDY0IsPjkSUcbdU5sxgn11oKtwehig1qKqKc5rZVjLFXESpln
         8QmJ4+FfN8RmcUJVbV6lROosBf1njJkGBZ4rfZvxr7VHy3aC7J8IPzduybWIxrazh1te
         1v8g==
X-Gm-Message-State: AC+VfDxDJdryON20c/LBgk5TkQuxs+s9zPsG+DC3sYskvSfstGPTJT8s
        wNId8PD+bYet0YtSRNPpr3mNTjY209E=
X-Google-Smtp-Source: ACHHUZ6quXRYuROV3npiiWrrglmfYlnZRbq/AWZBPYwfbJ9GffaoFm7ChecJ0RogHNrmMKMjH9v4OpMmJDM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:603:0:b0:534:6929:8ff5 with SMTP id
 3-20020a630603000000b0053469298ff5mr1562481pgg.10.1686180597232; Wed, 07 Jun
 2023 16:29:57 -0700 (PDT)
Date:   Wed,  7 Jun 2023 16:26:04 -0700
In-Reply-To: <20230406220839.835163-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230406220839.835163-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <168617888130.1601947.14907732055337971930.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Link with "-z noexecstack" to
 suppress irrelevant linker warnings
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>
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

On Thu, 06 Apr 2023 15:08:39 -0700, Sean Christopherson wrote:
> Explicitly tell the linker KUT doesn't need an executable stack to
> suppress gcc-12 warnings about the default behavior of having an
> executable stack being deprecated.  The entire thing is irrelevant for KUT
> (and other freestanding environments) as KUT creates its own stacks, i.e.
> there's no loader/libc that consumes the magic ".note.GNU-stack" section.
> 
>   ld -nostdlib -m elf_x86_64 -T /home/seanjc/go/src/kernel.org/kvm-unit-tests/x86/flat.lds
>      -o x86/vmx.elf x86/vmx.o x86/cstart64.o x86/access.o x86/vmx_tests.o lib/libcflat.a
>   ld: warning: setjmp64.o: missing .note.GNU-stack section implies executable stack
>   ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/1] x86: Link with "-z noexecstack" to suppress irrelevant linker warnings
      https://github.com/kvm-x86/kvm-unit-tests/commit/5f15933dccae

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next
