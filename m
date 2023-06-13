Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C5672EE2F
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 23:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbjFMVls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 17:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjFMVlr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 17:41:47 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B91CDE
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 14:41:46 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-548a11fc6d4so4185927a12.2
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 14:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686692506; x=1689284506;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vK5JfKpR6d+d4sLxZBfYIMTC1bOplOmakkfhYn13yS0=;
        b=xAm6+tJrxd9CFMAVc5uBeY4VOd99YLoeCTY9VZF7wqBBulWcVPr6TCrXo0Q75lMvl0
         I9lcDmX8eipDbWtZw7HsAmzDnhL7omkp6sKg1n71zNUOHKlxgeBq9RuKIj9grPgkgimf
         6wEAuAH8EjR/9Hu6JV/v1cYaT1m6n+muNenHv1vt7pWsfCZKBgRviSQhpfBq1bBglaLj
         amtiaZMMhnPTVVZWVlKS8RGIP+xZ4TghKbYCZrQ5yw51TKuv/dRKsJydaSBit63LzZjT
         gES+j1FFNTV1X1IrBBb+RWYiKCBVJD03P11BEhiX0SbCDfNfnADMhh6lW7f3uWDp4WtW
         +XYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686692506; x=1689284506;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vK5JfKpR6d+d4sLxZBfYIMTC1bOplOmakkfhYn13yS0=;
        b=SLJjZ6D429/4DY8u5ZIlVlQbK8MT82/LCi9pYG6H+E0cTRB0ePGIt0q20MUk4Ropy5
         xYhlqWtTu4VW+QyhyvR6/h5SfH6hHyWia5MmBuqP+AcdwARFaQCMx9CLTQjBvB/6YtlC
         85M1/HZHW02e9gCxeUh/2m/05L1oIqZRAKZT35Eo8JwW4nmkpfiEBBif0a5yjC4+1ffd
         rD5TYQWyf+hbkUkpTaX/sbp2AF9xvyju6fT+UppraEcX++TaGaOrdL3HJuQuWOPNYdnX
         tn4ReU7DksyGDWUq7xFfe0kA1MMyY3JMM7GSQfGDNs4XVPfb5Av+jclltWSwr33izHR3
         boJw==
X-Gm-Message-State: AC+VfDzrsWDyeEnAiki0D1Ye5nfimChjbq9XjStKpGr8lKtfja4kw4Oe
        MUw1aVAZArGe4+M9ylNIprvCpka2Gy8=
X-Google-Smtp-Source: ACHHUZ72lCkng8ZM94wY94gJadZotOWnP7a14zEdJutFz3J64/YEkZj+/71/cI9Bm8bB2EJmSd9V6JcUmBM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:6447:0:b0:53f:2668:2bd3 with SMTP id
 y68-20020a636447000000b0053f26682bd3mr2096037pgb.7.1686692505705; Tue, 13 Jun
 2023 14:41:45 -0700 (PDT)
Date:   Tue, 13 Jun 2023 14:40:46 -0700
In-Reply-To: <20230413184219.36404-1-minipli@grsecurity.net>
Mime-Version: 1.0
References: <20230413184219.36404-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <168668855812.1968967.9918672463130718790.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 00/16] x86: cleanups, fixes and new tests
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
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

On Thu, 13 Apr 2023 20:42:03 +0200, Mathias Krause wrote:
> v1: https://lore.kernel.org/kvm/b6322bd0-3639-fb2a-7211-974386865bac@grsecurity.net/
> 
> This is v2 of the "non-canonical memory access" test. It evolved into a
> small series, bringing cleanups and fixes along the way.
> 
> I integrated Sean's feedback and changed the test to make use of
> ASM_TRY() instead of using the hand-rolled exception handler. I also
> switched all other users in emulator64.c to ASM_TRY() and was able to
> drop the one-off exception handler all together.
> 
> [...]

Applied everything except the code label change to kvm-x86 next.  I replied to
that specific patch, feel free to follow-up there.

I tweaked "x86/run_in_user: Reload SS after successful return" to use an "rm"
constraint instead of hardcoding use of AX, holler if that's wrong for some
reason.  I'm planning on sending a pull request later this week, so you've got
a few days to object.

Thanks a ton for the cleanups!

[01/16] x86: Drop types.h
        https://github.com/kvm-x86/kvm-unit-tests/commit/0452fa5aecea
[02/16] x86: Use symbolic names in exception_mnemonic()
        https://github.com/kvm-x86/kvm-unit-tests/commit/8cfb268d401b
[03/16] x86: Add vendor specific exception vectors
        https://github.com/kvm-x86/kvm-unit-tests/commit/f224dba008df
[04/16] x86/cet: Use symbolic name for #CP
        https://github.com/kvm-x86/kvm-unit-tests/commit/00d585d8731b
[05/16] x86/access: Use 'bool' type as defined via libcflat.h
        https://github.com/kvm-x86/kvm-unit-tests/commit/c304eda6ae7f
[06/16] x86/run_in_user: Change type of code label
	DID NOT APPLY
[07/16] x86/run_in_user: Preserve exception handler
        https://github.com/kvm-x86/kvm-unit-tests/commit/d0ef95181cfb
[08/16] x86/run_in_user: Relax register constraints of inline asm
        https://github.com/kvm-x86/kvm-unit-tests/commit/45bafaf28fbb
[09/16] x86/run_in_user: Reload SS after successful return
        https://github.com/kvm-x86/kvm-unit-tests/commit/8338209b8245
[10/16] x86/fault_test: Preserve exception handler
        https://github.com/kvm-x86/kvm-unit-tests/commit/11aac640d01b
[11/16] x86/emulator64: Relax register constraints for usr_gs_mov()
        https://github.com/kvm-x86/kvm-unit-tests/commit/c66547850058
[12/16] x86/emulator64: Switch test_sreg() to ASM_TRY()
        https://github.com/kvm-x86/kvm-unit-tests/commit/9d74b31d1c81
[13/16] x86/emulator64: Add non-null selector test
        https://github.com/kvm-x86/kvm-unit-tests/commit/23c647d0ef29
[14/16] x86/emulator64: Switch test_jmp_noncanonical() to ASM_TRY()
        https://github.com/kvm-x86/kvm-unit-tests/commit/ac4f843474b4
[15/16] x86/emulator64: Switch test_mmx_movq_mf() to ASM_TRY()
        https://github.com/kvm-x86/kvm-unit-tests/commit/5a3515ea1bc2
[16/16] x86/emulator64: Test non-canonical memory access exceptions
        https://github.com/kvm-x86/kvm-unit-tests/commit/e3a9b2f5490e

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next
