Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BB94BC2A1
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 23:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240136AbiBRWgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 17:36:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236664AbiBRWgW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 17:36:22 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976065419B
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 14:36:04 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id a8so18121003ejc.8
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 14:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u+sFcg1Jrzd7RdQxBiVyHyjcrIIMdAB2S95NaiORBYQ=;
        b=cGWMjVauB1J5Kz60+ee5aWzyXC1AM3YWk9YtVYIpDse5G74x18lvIyFkPja0Abo2BE
         x35vQ/IgynKUwIAXySKdR7gESn/FCFxB+0QwV5+MYdhS+G+r+74C3G2GEbQ/KuACKSPg
         FGOM54bwhNMTJiu59gOKFKakEbIm3IhB8DdsdONoBkbNGLPhaDpiI23vY1/A4LizwOr+
         GU08VQDrmHuVY4hMkqkbJYpHgIH3shY7nppq7yL8Dj1EXvF8eFWdALTYd9V78sQra+cQ
         a8jdHCxrpmXpRDydmzrnQYWMNvTubkLbi0lCjjinCA3Iw9u8kWX9ZB6pvn5soobO7Dtz
         bFbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u+sFcg1Jrzd7RdQxBiVyHyjcrIIMdAB2S95NaiORBYQ=;
        b=CJP1nbGM61S2h5c+OwYMjhzdYEhVzM5yPOQ67HJjQO/FnBCYjaqcCPbHWUTjUyJ8uH
         U/OTt1ymB2QpauKrEBfhiDMoGZDJmg+AKrNoClKPDKSvuFM3/vdkOOrijfwsU+Cr8oOx
         UbmpKkzOyRwJljlpGJhHMXvEnbXiyrBLFhRyRXSTVXavz2gryVRbz1qE/9g7ELeLYYQW
         6K+inVwpcUX3kMMukPshPKlYf8fXy37Ubw7gvM2/Bn+BA6UxLs5qnRUmYM9IjV8nqPIf
         SjTttpIHdMp1SlQzu+JoL4hYQKdPVwTgjBk6f+Ok8qGswkTNAaU1bv0ENcgN01MQtX1n
         T+VA==
X-Gm-Message-State: AOAM533qUgoB+CvPrNgYe0/NdFOUt8jc2k6+8P/ZnwJo1d5jnaPoPrg6
        eq5NiFMcHzXleg2oazhpSZGeJE1NAl5aGeHF5ir6Mg==
X-Google-Smtp-Source: ABdhPJxCAq71uudZo1yeq2i43zfSBGdz40+2gbUVJ11hY+5K5ovbv3z9+MmVE7/NFhdhZ2/awk1paWaMMa6UYaynntU=
X-Received: by 2002:a17:906:7751:b0:6ce:e3c:81a6 with SMTP id
 o17-20020a170906775100b006ce0e3c81a6mr7806909ejn.278.1645223762896; Fri, 18
 Feb 2022 14:36:02 -0800 (PST)
MIME-Version: 1.0
References: <20211111020738.2512932-1-seanjc@google.com> <20211111020738.2512932-10-seanjc@google.com>
 <YfrQzoIWyv9lNljh@google.com> <CABCJKufg=ONNOvF8+BRXfLoTUfeiZZsdd8TnpV-GaNK_o-HuaA@mail.gmail.com>
 <202202061011.A255DE55B@keescook> <YgAvhG4wvnslbTqP@hirez.programming.kicks-ass.net>
 <202202061854.B5B11282@keescook>
In-Reply-To: <202202061854.B5B11282@keescook>
From:   Will McVicker <willmcvicker@google.com>
Date:   Fri, 18 Feb 2022 14:35:47 -0800
Message-ID: <CABYd82ZmDbgmEGhdWOJ5Um8tiFd4TeQ-QZ2+xwxwqqQs6oi0xg@mail.gmail.com>
Subject: Re: [PATCH v4 09/17] perf/core: Use static_call to optimize perf_guest_info_callbacks
To:     Kees Cook <keescook@chromium.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 6, 2022 at 6:56 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Sun, Feb 06, 2022 at 09:28:52PM +0100, Peter Zijlstra wrote:
> > On Sun, Feb 06, 2022 at 10:45:15AM -0800, Kees Cook wrote:
> >
> > > I'm digging through the macros to sort this out, but IIUC, an example of
> > > the problem is:
> > >
> >
> > > so the caller is expecting "unsigned int (*)(void)" but the prototype
> > > of __static_call_return0 is "long (*)(void)":
> > >
> > > long __static_call_return0(void);
> > >
> > > Could we simply declare a type-matched ret0 trampoline too?
> >
> > That'll work for this case, but the next case the function will have
> > arguments we'll need even more nonsense...
>
> Shouldn't the typeof() work there too, though? I.e. as long as the
> return value can hold a "0", it'd work.
>
> > And as stated in that other email, there's tb_stub_func() having the
> > exact same problem as well.
>
> Yeah, I'd need to go look at that again.
>
> > The x86_64 CFI patches had a work-around for this, that could trivially
> > be lifted I suppose.
>
> Yeah, I think it'd be similar. I haven't had a chance to go look at that
> again...
>
> --
> Kees Cook


Hi All,

I noticed that this thread kind of died out. Does anyone have any
action items that need to be followed up to help resolve this issue?
The offending patch is breaking the ARM64 Android Common Kernels
(Pixel 6 in particular) and I imagine it might also have an impact on
other ARM64 platforms upstream that just haven't hit this perf_trace
case yet.

If anyone needs help verifying any fixes, I'm happy to test it out.

Thanks,
Will
