Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5274213C2
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 18:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbhJDQPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 12:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236499AbhJDQPR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 12:15:17 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF42C06174E
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 09:13:28 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id b20so74352892lfv.3
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 09:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wu2Sbxcf5EVRYolmaoh2RSe+DqpVoS+BAjX+Kaizi48=;
        b=f/uWlCZP2+MFwzszq+m0m/TsYjyg7V/v86sUvQ8S9duOnhju8rZ8HKHGMe+gjCVmq6
         MiqJhuiHfxe9QAe5wZdWtGxKDTh11YgDPeXlmzhK+a5wSamY1h0PYbEBfdpYVZLd+q3j
         4x/8wPbPnNwgxUGbiBEs7D00SfKnxEctE0BaTwpOMbzOk9lLdevbvls9texMD57lb9lZ
         0Cn6y61otXRZZLcbgaRO159+pbK5R6jivc/WCyZzttjJcb/DZdb+wGMHiTBr3wooaMxr
         NHGqJxGhoX413/DJuZ2rR7s8iWvmMDqu6q1T2R6/4GQIdtoXBlbBHZA4C85kS4k8GyiJ
         hbCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wu2Sbxcf5EVRYolmaoh2RSe+DqpVoS+BAjX+Kaizi48=;
        b=wHeihK1OahxQYY4Ov1gK0VVqDv0S24o1Bmdr3oDLBhZIDrL+sjQcZ+XqKC1umS4Xka
         9TXqYociQYEYjSNaQGaOsLrAsNzlP5P4tBI+xEIp1BN8ySuFKbf8Sy6bqjLhMC+rSIlF
         +zKFGSk900WmX87PeQ9j1FmU4jzbQhGNv7h9ZEb990JAMuXkRxLGLE094jfDI0UBr4YD
         oD7IUr64NPtGRoZiFVphfSYYnEJiuNFe7CDHbgkFfx1PrdX1BJamQXL4lagc4xXMGSor
         dsbW66mjcf+EymmkzO0zcD9WG5UJSCew1sS+8R7mbjs/cXF8F2Vy+3p8jse/oduplZPn
         KPkg==
X-Gm-Message-State: AOAM530kfBWP9LQe7XBUn0BByGx8W2KWoxDGdyedQjmeusVbPeFjD7DW
        J5Cblup/D0daljnxrTDpDoSq5uHPkC+pICcrxibgVQ==
X-Google-Smtp-Source: ABdhPJxvCRV7JJ//o6iMYzW5L1q/SZH90XtOI+mjrFOlvB4QT+GKZmFWCCbthQOs7zyoP8qP/M79xBk9fx7vs6r7l34=
X-Received: by 2002:a19:6a16:: with SMTP id u22mr15585258lfu.444.1633364006443;
 Mon, 04 Oct 2021 09:13:26 -0700 (PDT)
MIME-Version: 1.0
References: <1446878298.170497.1633338512925@office.mailbox.org>
 <b6abc5a3-39ea-b463-9df5-f50bdcb16d08@redhat.com> <936688112.157288.1633339838738@office.mailbox.org>
 <c4773ecc-053f-9bc6-03af-5039397a4531@redhat.com>
In-Reply-To: <c4773ecc-053f-9bc6-03af-5039397a4531@redhat.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 4 Oct 2021 09:13:14 -0700
Message-ID: <CAKwvOd=rrM4fGdGMkD5+kdA49a6K+JcUiR4K2-go=MMt++ukPA@mail.gmail.com>
Subject: Re: [BUG] [5.15] Compilation error in arch/x86/kvm/mmu/spte.h with clang-14
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvic9@mailbox.org, "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 4, 2021 at 2:49 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 04/10/21 11:30, torvic9@mailbox.org wrote:
> >
> >> Paolo Bonzini <pbonzini@redhat.com> hat am 04.10.2021 11:26 geschrieben:
> >>
> >>
> >> On 04/10/21 11:08, torvic9@mailbox.org wrote:
> >>> I encounter the following issue when compiling 5.15-rc4 with clang-14:
> >>>
> >>> In file included from arch/x86/kvm/mmu/mmu.c:27:
> >>> arch/x86/kvm/mmu/spte.h:318:9: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
> >>>           return __is_bad_mt_xwr(rsvd_check, spte) |
> >>>                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >>>                                                    ||
> >>> arch/x86/kvm/mmu/spte.h:318:9: note: cast one or both operands to int to silence this warning
> >>
> >> The warning is wrong, as mentioned in the line right above:
> >
> > So it's an issue with clang-14 then?
> > (I add Nick and Nathan)
>
> My clang here doesn't have the option, so I'm going to ask---are you
> using W=1?  I can see why clang is warning for KVM's code, but in my
> opinion such a check should only be in -Wextra.

This is a newly added warning in top of tree clang.

>
> Paolo
>
> >>
> >>           /*
> >>            * Use a bitwise-OR instead of a logical-OR to aggregate the reserved
> >>            * bits and EPT's invalid memtype/XWR checks to avoid an extra Jcc
> >>            * (this is extremely unlikely to be short-circuited as true).
> >>            */
> >>
> >> Paolo
> >
>


-- 
Thanks,
~Nick Desaulniers
