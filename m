Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768E56E9B19
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 19:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjDTRuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 13:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbjDTRuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 13:50:11 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265BE422A
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 10:50:10 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54feaa94819so28294997b3.2
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 10:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682013009; x=1684605009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LPQ/EijRmgVmPolh1fmtIDSbWWxx7irHxImVS52k7FE=;
        b=pzA/YrGc4zNWVaMghW+3JW+s1I32TsRcpiBRG9QiM5H2ds8t0troYUiiQaUpX9kZ2n
         E14LigakfVd5NOzXBF/UsiXn4VxiNYEQrtifpKSwGsDwceen1uZ/BUL+DXGwoN0OkKeR
         KslxAwVfs11HzFFoQLJ7DOVc9wy1th7ok1uQUEuLruB3gbLkwNYHxk39wudbbRxLH0Yf
         KUjff5qKHdlzTI8HLB84ffIIL5giqPBqcG+C5wpRHsBFcA8XfOoTEvdvWLM3kQKIinK+
         cuVzMVwHvHofrD8ksyX1nnaDlR7z7b5wA4TFAgqu0kLVBtdq7pWcJYob4oTMxXBjn+Ja
         Ps8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682013009; x=1684605009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LPQ/EijRmgVmPolh1fmtIDSbWWxx7irHxImVS52k7FE=;
        b=FK10zQ7ZDbCOk1vHP49P4HS1QJkBbu7zxhnlAoEfvpztj4/9o1qC1spG2oVn9DlY9K
         GLji0dbJCWL9fL7LpqjUw/ZvFmnUDGyDxnaQ8p/e8Vxb7XygLZARfcWI4Csa7TsVXLh7
         AaWsDrJ0TE+02AZkeMrxEs5TOlLZCzLVxzfb9pSoHeKhCISB+a7d0Xn6r+lVuBnNDbnm
         hale6+tFOb9hl9US/qg/x+CYtm5G9/EsbjYcdEG4E1XCxJzCu7Ai/YVOwqCMjCAn++qf
         uUnPGJkjR2YTy6/593ErjHfONmVZCwRWIMUkfc0cHophxd06JPqv56XqmESUM9HjA5Hy
         lNew==
X-Gm-Message-State: AAQBX9fql5KLgIRNvUvwJJ9JBiObvpF5n5WZeWwRwWvi7hKLXH2Qg1KH
        gDQP9moapiOZlF/L39cGKBANhGS9ybU=
X-Google-Smtp-Source: AKy350Zy1HflyBTEKvIsbbG7RF43cU27HxpqWds9a6kY4IiDBV5A2IACNrX5p4FbjE1Uk7uw3JqbIczWsgI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:cb42:0:b0:b98:6352:be16 with SMTP id
 b63-20020a25cb42000000b00b986352be16mr750274ybg.5.1682013009449; Thu, 20 Apr
 2023 10:50:09 -0700 (PDT)
Date:   Thu, 20 Apr 2023 10:50:07 -0700
In-Reply-To: <mtdi6smhur5rqffvpu7qux7mptonw223y2653x2nwzvgm72nlo@zyc4w3kwl3rg>
Mime-Version: 1.0
References: <20230301053425.3880773-1-aaronlewis@google.com>
 <20230301053425.3880773-5-aaronlewis@google.com> <ZBzM6M/Bm69KIGQQ@google.com>
 <ZD1sx+G2oWchaleW@google.com> <ZD6xWYI7Uin01fA7@google.com> <mtdi6smhur5rqffvpu7qux7mptonw223y2653x2nwzvgm72nlo@zyc4w3kwl3rg>
Message-ID: <ZEF7T/FG1hUWRRWR@google.com>
Subject: Re: [PATCH 4/8] KVM: selftests: Copy printf.c to KVM selftests
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 18, 2023, Andrew Jones wrote:
> On Tue, Apr 18, 2023 at 08:03:53AM -0700, Sean Christopherson wrote:
> > On Mon, Apr 17, 2023, Aaron Lewis wrote:
> > > On Thu, Mar 23, 2023, Sean Christopherson wrote:
> > > > > +static char *number(char *str, long num, int base, int size, int precision,
> > > > > +		    int type)
> > > > 
> > > > Do we actually need a custom number()?  I.e. can we sub in a libc equivalent?
> > > > That would reduce the craziness of this file by more than a few degrees.
> > > 
> > > Yeah, I think we need it.  One of the biggest problems I'm trying to avoid
> > > here is the use of LIBC in a guest.  Using it always seems to end poorly
> > > because guests generally don't set up AVX-512 or a TLS segmet, nor should
> > > they have to.  Calling into LIBC seems to require both of them too often,
> > > so it seems like it's better to just avoid it.
> > 
> > True, we'd probably end up in a world of hurt.
> > 
> > I was going to suggest copy+pasting from a different source, e.g. musl, in the
> > hopes of reducing the crazy by a degree, but after looking at the musl source,
> > that's a terrible idea :-)
> > 
> > And copying from the kernel has the advantage of keeping any bugs/quirks that
> > users may be expecting and/or relying on.
> 
> What about trying to use tools/include/nolibc/? Maybe we could provide our
> own tools/include/nolibc/arch-*.h files where the my_syscall* macros get
> implemented with ucalls, and then the ucalls would implement the syscalls,
> possibly just forwarding the parameters to real syscalls. We can implement
> copy_from/to_guest() functions to deal with pointer parameters.

Hmm, I was going to say that pulling in nolibc would conflict with the host side's
need for an actual libc, but I think we could solve that conundrum by putting
ucall_fmt() in a dedicated file and compiling it separately, a la string_override.c.

However, I don't think we'd want to override my_syscall to do a ucall.  If I'm
reading the code correctly, that would trigger a ucall after every escape sequence,
which isn't what we want, expecially for a GUEST_ASSERT.

That's solvable by having my_syscall3() be a memcpy() to the buffer provided by
KVM's guest-side vsprintf(), but that still leaves the question of whether or not
taking a dependency on nolibc.h would be a net positive.

E.g. pulling in nolibc.h as-is would well and truly put ucall_fmt.c (or whatever
it's called) into its own world, e.g. it would end up with different typedefs for
all basic types.  Those shouldn't cause problems, but it'd be a weird setup.  And
I don't think we can rule out the possibility of the nolibc dependency causing
subtle problems, e.g. what will happen when linking due to both nolibc and
string_override.c defining globally visible mem{cmp,cpy,set}() functions.

Another minor issue is that nolibc's vfprintf() handles a subset of escapes compared
to the kernel's vsprintf().  That probably won't be a big deal in practice, but it's
again a potential maintenance concern for us in the future.

I'm definitely torn.  As much as I dislike the idea of copy+pasting mode code into
KVM selftests, I think pulling in nolibc would bring its own set of problems.

My vote is probably to copy+paste, at least for the initial implementation.  Being
able to do the equivalent of printf() in the guest would be a huge improvement for
debugging and triaging selftests, i.e. is something I would like to see landed
fairly quickly.  Copy+pasting seems like it gives us the fastest path forward,
e.g. doesn't risk getting bogged down with weird linker errors and whatnot.
