Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A691E9338
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 20:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbgE3SxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 May 2020 14:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729296AbgE3SxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 May 2020 14:53:04 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA65C08C5C9
        for <kvm@vger.kernel.org>; Sat, 30 May 2020 11:53:03 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id o9so3265527ljj.6
        for <kvm@vger.kernel.org>; Sat, 30 May 2020 11:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZHzJltOh4wlFbNpZhBw/XeTB/tCPGs6HUO1he1lSBzM=;
        b=OCKRD3WBSxWqJ660azgGmH4vrTVrjzQGz1F8EUVxr3/PjeBwCXSVOh6EicOBytWsK4
         doerNBJ3zzjyEoQu/BaNQ3fZld1nB7BeR3HkzqFS6p4AfHT8QxaH4DbLqJohCuREeqaw
         yK1NF6J/j1kHP1gm2ttUycjI1buYzyxyyRYTc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZHzJltOh4wlFbNpZhBw/XeTB/tCPGs6HUO1he1lSBzM=;
        b=ZxPbpQgvN3LuxispBBORDulsk6ofmhHWbYJi8RaNHD5AZ4B6xKqdXKUBpjTasmBlYh
         aGhtF2mgIk6/a1rXUNbv8sWO5hb+IXu100MXBsNJg9vvt+6oyuqNINn+wc7rJ+Oq0bq6
         v7lg8bsBf8GM/zr16agOgTwBRGFZxSYJHbcnOsGI808y1HzCiCVkww5j2ISlTqDCWU7g
         mgFGfkMtIUmchv4SX7BUl0cbmtFtft+bjBRHtHZ2FnPosm5YOeTnq1eyjnuOLdXXvFkt
         Lpq94RlZBF95Lm50gRwjEXCsAKV7SdNq+yHV9oVuNWgULtm7G4KdRD5zWr0diLBXxlJz
         qy6Q==
X-Gm-Message-State: AOAM530L8s/9bcZy1toZFC6eWAKazrZ7U5+70FfzfNCu3tEY9xosvtM+
        6hd2n1o6sMe+wnC8WzeOX0hCcEhq++k=
X-Google-Smtp-Source: ABdhPJyoAQkASi7G7J8tTPmEIGZDVWk6yudCud4/fz9V5gAgZMd4gC3lheOMSzLJOmybohGTKT1vqg==
X-Received: by 2002:a05:651c:554:: with SMTP id q20mr2014901ljp.137.1590864781838;
        Sat, 30 May 2020 11:53:01 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id n3sm2769866ljg.6.2020.05.30.11.53.00
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 11:53:00 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id a25so3286213ljp.3
        for <kvm@vger.kernel.org>; Sat, 30 May 2020 11:53:00 -0700 (PDT)
X-Received: by 2002:a2e:150f:: with SMTP id s15mr6718682ljd.102.1590864780355;
 Sat, 30 May 2020 11:53:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200528234025.GT23230@ZenIV.linux.org.uk> <20200529232723.44942-1-viro@ZenIV.linux.org.uk>
 <20200529232723.44942-8-viro@ZenIV.linux.org.uk> <CAHk-=wgq2dzOdN4_=eY-XwxmcgyBM_esnPtXCvz1zStZKjiHKA@mail.gmail.com>
 <20200530143147.GN23230@ZenIV.linux.org.uk> <81563af6-6ea2-3e21-fe53-9955910e303a@redhat.com>
 <CAHk-=wiW=cKaMyBKgZMOOJQbpAyeRrz--o2H_7CdDpbn+az9vQ@mail.gmail.com> <20200530183853.GQ23230@ZenIV.linux.org.uk>
In-Reply-To: <20200530183853.GQ23230@ZenIV.linux.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 30 May 2020 11:52:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjmCBXj0==no0f9Og6NZuAVWPEFXUgRL+fRmJ8PovbdPQ@mail.gmail.com>
Message-ID: <CAHk-=wjmCBXj0==no0f9Og6NZuAVWPEFXUgRL+fRmJ8PovbdPQ@mail.gmail.com>
Subject: Re: [PATCH 8/9] x86: kvm_hv_set_msr(): use __put_user() instead of
 32bit __clear_user()
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 30, 2020 at 11:39 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Actually, it's somewhat less brittle than you think (on non-mips, at least)
> and not due to those long-ago access_ok().

It really isn't.

Your very first statement shows how broken it is:

> FWIW, the kvm side of things (vhost is yet another pile of fun) is
>
> [x86] kvm_hv_set_msr_pw():
> arch/x86/kvm/hyperv.c:1027:             if (__copy_to_user((void __user *)addr, instructions, 4))
>         HV_X64_MSR_HYPERCALL
> arch/x86/kvm/hyperv.c:1132:             if (__clear_user((void __user *)addr, sizeof(u32)))
>         HV_X64_MSR_VP_ASSIST_PAGE
> in both cases addr comes from
>                 gfn = data >> HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_SHIFT;
>                 addr = kvm_vcpu_gfn_to_hva(vcpu, gfn);
>                 if (kvm_is_error_hva(addr))
>                         return 1;

Just look at that. You have _zero_ indication that 'adds" is a user
space address. It could be a kernel address.

That kvm_vcpu_gfn_to_hva() function is a complicated mess that first
looks for the right 'memslot', and basically uses a search with a
default slot to try to figure it out. It doesn't even use locking for
any of it, but assumes the arrays are stable, and that it can use
atomics to reliably read and set the last successfully found slot.

And none of that code verifies that the end result is a user address.

It _literally_ all depends on this optimistically lock-free code being
bug-free, and never using a slot that isn't a user slot. And as
mentioned, there _are_ non-user memslots.

It's fragile as hell.

And it's all completely and utterly pointless. ALL of the above is
incredibly much more expensive than just checking the damn address
range.

So the optimization is completely bogus to begin with, and all it
results in is that any bug in this _incredibly_ subtle code will be a
security proiblem.

And I don't understand why you mention set_fs() vs access_ok(). None
of this code has anything that messes with set_fs(). The access_ok()
is garbage and shouldn't exist, and those user accesses should all use
the checking versions and the double underscores are wrong.

I have no idea why you think the double underscores could _possibly_
be worth defending.

            Linus
