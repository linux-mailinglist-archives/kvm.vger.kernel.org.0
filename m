Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572E147CBB4
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 04:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242122AbhLVD2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 22:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242105AbhLVD2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 22:28:46 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83F6C061401
        for <kvm@vger.kernel.org>; Tue, 21 Dec 2021 19:28:45 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id r17so1966488wrc.3
        for <kvm@vger.kernel.org>; Tue, 21 Dec 2021 19:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GwGmaz0czI4/jq/c3gNLjgrvk2T0ZPOGYi2vGZRAgJ8=;
        b=Jt4H1fUdCEMOLQHX3j8EBBqo9BuEi+lYppPytwWRaVi0mDh8ODMpWedLRWd3H7rBfJ
         AQ5fHBfcUpWYc5BinZTMZtuYyjBr4pkV/mECZlvDJKg0fbo9/CqScbYQrjzunNsD10ws
         R4GC78RSk9bHWAowN0oXp4B+4QcZm1bP1oWOhyPirxW+IdhskSQteDzfNLrSW1UQATzC
         mL5RHZSW7E3tEYfaWw1uFkp/B9IaBmJS4cHPJkxrdDesqtq3ZHdbYUAm1D60lrU4wM7M
         0N/jdAsLtiQ+OARU0DHfXhoDcm6KRc9DVTm2PcVKTwiueoZYle3k8QGZxCEcvc5uziZL
         GXTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GwGmaz0czI4/jq/c3gNLjgrvk2T0ZPOGYi2vGZRAgJ8=;
        b=aixu1zwXtUqEiVdqjIZWzLFFfgV/LHZsF3CyU5Y8yueAvuE7K7tkelsTJ7BFdJ2AIO
         6FoQycVeOY1wuZNnQJlFR5hu6m/OYSGZHFoGHgm65dcD7j5XZLChVCGB4cS1graNTJ3O
         5E+dpE2dCL2iq8fdhLU77pH9W3190DdDe8s6SANFce9mJnnvmzGGLbw02ojK9LNewe+h
         ZdXjNRr6cp7FwwmWtKpgQiuo6XJU14psYlRtVC4ncUXLfVVk2gXq+7nBAr8ytzD7hL0q
         jKfnL9dlsZyHDiISiVkk/JisAY+OzmH34wS3qPTfF1VLGX5K+27xzlH0GHu+CXXOWP9z
         8U0g==
X-Gm-Message-State: AOAM5303ptvRWcu6z8vRP2nUZrb9+qVVAoPziRvFUJvq7iqgExkthc91
        3wJ4LHBfArFD1jtqR8o7GmvcFYquq6iIWcZnRwN5WA==
X-Google-Smtp-Source: ABdhPJyUK9DbRMSBUpws7YF1ETrsADtGZwEQdEB0A/0NZqBFbMnOmeP9lttyWY0swzgjdJ4wCDf6AlQTOuCU5OY1CEk=
X-Received: by 2002:a5d:56c2:: with SMTP id m2mr655955wrw.313.1640143724222;
 Tue, 21 Dec 2021 19:28:44 -0800 (PST)
MIME-Version: 1.0
References: <20211221125617.932371-1-anup.patel@wdc.com> <3e3b5295-f6fb-1ff9-acfe-1a4c47c6ba20@linuxfoundation.org>
 <4d739c28-e07d-f921-8a8d-a5343139e234@redhat.com>
In-Reply-To: <4d739c28-e07d-f921-8a8d-a5343139e234@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 22 Dec 2021 08:58:30 +0530
Message-ID: <CAAhSdy26_a6RBTQB7FYrEAkZNcQ4xH+GkV-iv4yR9LuNEE_CmQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Fix compile error for non-x86 vm_compute_max_gfn()
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Anup Patel <anup.patel@wdc.com>, Shuah Khan <shuah@kernel.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 21, 2021 at 10:53 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/21/21 18:22, Shuah Khan wrote:
> > On 12/21/21 5:56 AM, Anup Patel wrote:
> >> The inline version of vm_compute_max_gfn() in kvm_util.h directly
> >> access members of "struct kvm_vm" which causes compile errors for
> >> non-x86 architectures because lib/elf.c includes "kvm_util.h" before
> >> "kvm_util_internal.h".
> >>
> >> This patch fixes above described compile error by converting inline
> >> version of vm_compute_max_gfn() into a macro.
> >
> > Thank you for the patch. Please include the actual compile error in the
> > change log and send v2,
>
> Hi, a similar patch is already queued and should get to Linus today or
> tomorrow.

Thanks Paolo, I missed Andrew's fix for this.

Regards,
Anup

>
> Paolo
>
