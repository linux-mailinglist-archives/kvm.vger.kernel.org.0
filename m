Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF603D653D
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 19:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240107AbhGZQcL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 12:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240057AbhGZQcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 12:32:08 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F445C0A0D4A
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 09:53:14 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id u15so12620893iol.13
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 09:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v0vC2s6bfOYSpCJxntho7Zz1d3YR0dCQ19xUE9gBrh4=;
        b=LPi0FFE+NJ4svpmMxmGGeRDyDwRS4SPkAXliPPAIk0TU00KePY6YwfpFdaWxSJ7KoW
         bNck5ELVHAZU3U7dM4AELK8A8GOA/qmbhG1g3473ZHM57hUAHNY5Sf4fHM+MonMi1O8a
         ufTo8o3lPlnkwjbRVhqqj9Ii1y1EbakV0n+mAoJcKOVDU2n9/NykTwJ+AIlpu8S13xyq
         CCaLRxdTIDrLxxj99R2zTFHUm23rQxD+6Riom8o0JeJOCRh0ql4KpCk9og4yyWBmEyjV
         QHtzYmD/fXkvGr6NH2xip/p9fcFLhOfVAs+PZXv30OCO6EUZ6A/yNWY5C7XpkVKq9sBK
         7keQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v0vC2s6bfOYSpCJxntho7Zz1d3YR0dCQ19xUE9gBrh4=;
        b=D1l/5nthboyXCchbgHZGSvawyv6xP+M6BJMBWAI8v14h4PeKLnAZ36kwL7B/+dkZoN
         cJTM+Qw6ytRgeXF3vVokNWCDsLMqQF9o1p0WbB0EI0MOZ5ACPqc9YofyrLNOwyBwsPF1
         HHrwGw0OdO1VL6Sh5rGE2HDSkomn1ExQoq9PhnTuYjW8sTibLiP5KwCIcUG0DF5s86tN
         n+nVoXlHCmWiwLRTA1zw04eazUjsITRxBi56Q7ECm0fuC95saGplXdJ3D2lklCngYcRH
         1tsPpsvi0esBJPRsFAYHMAZ8l4P6jIZlC+LioljUyuO4VJAdpV3jBoNkAjz8gJ5Zl+rN
         qi2A==
X-Gm-Message-State: AOAM5335cQotDrgzhk4C3lk/0nuY1IwKJkSd5Jx+9KG+X6lC5KCyhqEp
        gV/hc58tcxwlXO38lm8RRFnUrKt7EICTbSgIBBOqPw==
X-Google-Smtp-Source: ABdhPJwyP3hAQLxBy6C5A0njv6cNJGYxDG5KRrMXNe91XfUQlMlJVTr3fVwFbQmSYjQSyXb3jn36Eiq7noWGxNx+3nQ=
X-Received: by 2002:a6b:e90b:: with SMTP id u11mr15593423iof.134.1627318393877;
 Mon, 26 Jul 2021 09:53:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210726163106.1433600-1-pbonzini@redhat.com>
In-Reply-To: <20210726163106.1433600-1-pbonzini@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 26 Jul 2021 09:53:02 -0700
Message-ID: <CANgfPd_Hzr77ywspQn3ee1PTWp2fKZ=maiwztJj2uvHNAsWqjw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: enable TDP MMU by default
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021 at 9:31 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> With the addition of fast page fault support, the TDP-specific MMU has reached
> feature parity with the original MMU.  All my testing in the last few months
> has been done with the TDP MMU; switch the default on 64-bit machines.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Yay! Thank you for your support in getting this merged and enabled
Paolo, and thanks to David and Sean for helping upstream code and for
so many reviews!
I'm sure this will provoke some bug reports, and I'll keep a close eye
on the mailing list to help address the issues quickly.
In the meantime,

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index f86158d41af0..43f12f5d12c0 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -10,7 +10,7 @@
>  #include <asm/cmpxchg.h>
>  #include <trace/events/kvm.h>
>
> -static bool __read_mostly tdp_mmu_enabled = false;
> +static bool __read_mostly tdp_mmu_enabled = true;
>  module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
>
>  /* Initializes the TDP MMU for the VM, if enabled. */
> --
> 2.27.0
>
