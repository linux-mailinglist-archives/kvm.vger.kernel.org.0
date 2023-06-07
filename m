Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC05F7272EE
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 01:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbjFGX1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 19:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbjFGX1S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 19:27:18 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328542109
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 16:27:17 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5655d99da53so1788037b3.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 16:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686180436; x=1688772436;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IkZBoX8htxyFu9zdTbtouog4VuAI3fRedhhd5geunXw=;
        b=NqAmhoZIUTuPDbTVmUESmYgHkm4IwbzYC3Cc5EamzB8S0vAg9GcWAOKbEyoWiUBYpq
         KRaEaiTmv6P5l6ec+zlZNaFQTsuzEi7SWALtOu2au9v3NQwYGHFFBL7K9ypM6PDDfCbh
         jYGwYsBjDGAvlxoYQpMxeZhwpUl2JrnHXZBDarsfDEoQUVxViqN6UvCZZn7ZjzxFzosJ
         ogdUwQvVOZhpV9+HDSHuRGIhIjAcH1hgtk4EjVLfaXeP9sA5ZP9/G2D564Ne5qYN3Sel
         PfqXpuHp2hn/O9S1phMf623uXAz8vv3YI8fxIc0Gjt7inSkGpZj21dJcI8OMkFQ66/Wl
         BSGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686180436; x=1688772436;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IkZBoX8htxyFu9zdTbtouog4VuAI3fRedhhd5geunXw=;
        b=Gh9HXTmUB+qjxpWVUnTMjl7rtyqWkRlRmnuXRlzbIoQxQvmFWW9NKOVW5/k2utSVWz
         4D5npPR6mwDtDSVgn2NQt6jloDWWKZax7Y1jlK+LmSoW2L9WIQZAwTE1hR2wTbcw4J2G
         5EttVCp/0lHDpv2OLcEOgQ0i+rBMvq9nZ/3oFz40J7+4f6ZfK6RqTidiSe2+muR6OsEy
         0+i0XlmK4gEkocO60xb3jVUVdsOsy8ZLCiX1qAOs7pg8JY3EtgMgtKemvEDDg8yxCPuU
         4Ku/gbPVi0DbKyEEqkcuJfMKhX8ij3/X2LrbJ5FrTL1rZTA2E8BOK8NRpihbCXYRY4w4
         n3pQ==
X-Gm-Message-State: AC+VfDz5Nk1JUwvWvWv6Ggjbv2id3exRYPjc9bWPlLfCWV/1Jt8CrD09
        4mEh3VVWR8cdqXIdewUfD7YzEAeFapQ=
X-Google-Smtp-Source: ACHHUZ6fQHIZRylq7gJPgy4r0THvLHfYnO2vwpL789MGrKiR+EJ9sEmuAZgJ+PieTXlVTIqT7rj3DwVzRik=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ce07:0:b0:557:616:7d63 with SMTP id
 t7-20020a81ce07000000b0055706167d63mr323400ywi.1.1686180436473; Wed, 07 Jun
 2023 16:27:16 -0700 (PDT)
Date:   Wed,  7 Jun 2023 16:25:54 -0700
In-Reply-To: <20221122161152.293072-1-mlevitsk@redhat.com>
Mime-Version: 1.0
References: <20221122161152.293072-1-mlevitsk@redhat.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <168617899162.1602813.11898597003154958715.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH v3 00/27] kvm-unit-tests: set of fixes and
 new tests
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        "=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
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

On Tue, 22 Nov 2022 18:11:25 +0200, Maxim Levitsky wrote:
> This is set of fixes and new unit tests that I developed for the
> KVM unit tests.
> 
> I also did some work to separate the SVM code into a minimal
> support library so that you could use it from an arbitrary test.
> 
> V2:
> 
> [...]

Applied select patches to kvm-x86 next, mostly things that are smallish and
straightforward.

Please, please split all of this stuff into more manageable series, with
one theme per series.  Even with the patches I applied out of the way, there
are at least 4 or 5 distinct series here.

[01/27] x86: replace irq_{enable|disable}() with sti()/cli()
        https://github.com/kvm-x86/kvm-unit-tests/commit/ed31b56333aa
[02/27] x86: introduce sti_nop() and sti_nop_cli()
        https://github.com/kvm-x86/kvm-unit-tests/commit/a159f4c91608
[03/27] x86: add few helper functions for apic local timer
        https://github.com/kvm-x86/kvm-unit-tests/commit/7a507c9f5b74
[04/27] svm: remove nop after stgi/clgi
        https://github.com/kvm-x86/kvm-unit-tests/commit/783f817a17f1
[05/27] svm: make svm_intr_intercept_mix_if/gif test a bit more robust
        https://github.com/kvm-x86/kvm-unit-tests/commit/d0ffdee8f95b
[06/27] svm: use apic_start_timer/apic_stop_timer instead of open coding it
        https://github.com/kvm-x86/kvm-unit-tests/commit/2e4e8a4fe921
[09/27] svm: add simple nested shutdown test.
        https://github.com/kvm-x86/kvm-unit-tests/commit/e5bedc838c3b

[13/27] svm: remove get_npt_pte extern
        https://github.com/kvm-x86/kvm-unit-tests/commit/cc15e55699e9

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next
