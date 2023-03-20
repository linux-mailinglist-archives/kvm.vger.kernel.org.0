Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301B46C157A
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 15:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbjCTOtj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 10:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbjCTOtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 10:49:21 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7A62596B
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 07:47:33 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id j11so15180139lfg.13
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 07:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679323629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kc414cxHJJ4Rs2Usfe1VLFadO893WdMMNYN/EzyjUGE=;
        b=l8nxmBq097o2mhqhQ32r2xzlCnOSVT51U6HhjTroWn1KW8CwnaGjZToUmrbA3ygIiD
         wEbFFZq8rYty6ZsLpDzfxRfnMfOxLzlsFbNhCTVpOo7sqXGfIED+dFdczJIWXETCKyzy
         KsjhEi6gMhYqziNZMZM123Lf9S29yCT6P7r5uu5l/7Nzf2i+oKXEFIjCG3pE+npkznDb
         alvORS2ND+E9oxRPhsnKqT+bm1MuhsUdn4R1Ka38xB5HzJJwrd5mj8N8bt/02MJlJP8T
         2iUvU963YsF6T/0G43vWpqyv2jSUQj9EIaQLN1SQ7F610bkWhPqX3La127WVUJcs0yIP
         Qx/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679323629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kc414cxHJJ4Rs2Usfe1VLFadO893WdMMNYN/EzyjUGE=;
        b=gWJ94ehvRQVZBrMJmTHksx1ePrWJ+tlhHg/BkpePdmjVpFl5mg73fYZ0cYfL7sP3uR
         2V27uh2ndiNffx6dJU41Scc18C6X2THymGg4y/HIJMN+gTLLEHJH6oZG4r2DLJAoFMVa
         Kxej7zq+r5cf1AuCK5RxCmZeY0NLLyfcSC0QMEsM+Q4aEgroMxYNEkrP4rxc6w17D4tw
         RITG0VJR/NFwM2hvWdR+VmoRJRsY1IQJDFXm+sSZrfUhMO7pkM1p8Xz83gq4inuKWe8T
         J70omGOyfG3PGpOf5bb0PLo8ZOnrJsezqJR7kFfWQOCFRvS3AwsLp3lmoXzy4vBt0DQn
         uF/A==
X-Gm-Message-State: AO0yUKXLtmaS6JP1l5/qPHSgNncIdrDUD5QT/hXswp0SLzqX9hB2wgAJ
        H8oemdjqH/RAHGGnf+PmFunxwjc6vDi5Zg28P2xeBw==
X-Google-Smtp-Source: AK7set+DvUj3j8tjxdsk6XcnxH+SLGzT+Hu5S0QmM1Yr26jly9HIRPsvYCs6G1aS8U70PrI2cUHaBIhI7pFyTRhHrkw=
X-Received: by 2002:a05:6512:3084:b0:4e8:cfbf:d6f1 with SMTP id
 z4-20020a056512308400b004e8cfbfd6f1mr156529lfd.0.1679323629226; Mon, 20 Mar
 2023 07:47:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230317113538.10878-1-andy.chiu@sifive.com> <20230317113538.10878-9-andy.chiu@sifive.com>
 <456a8e61-c6b7-46d5-a25c-c466820912d7@spud>
In-Reply-To: <456a8e61-c6b7-46d5-a25c-c466820912d7@spud>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Mon, 20 Mar 2023 22:46:57 +0800
Message-ID: <CABgGipVf3eTc9pj58wMYQr7NBcic+-m3fECEttqvPcn9Zu3qJw@mail.gmail.com>
Subject: Re: [PATCH -next v15 08/19] riscv: Introduce struct/helpers to
 save/restore per-task Vector state
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 20, 2023 at 9:05=E2=80=AFPM Conor Dooley <conor.dooley@microchi=
p.com> wrote:
>
> On Fri, Mar 17, 2023 at 11:35:27AM +0000, Andy Chiu wrote:
> > From: Greentime Hu <greentime.hu@sifive.com>
> >
> > Add vector state context struct to be added later in thread_struct. And
> > prepare low-level helper functions to save/restore vector contexts.
> >
> > This include Vector Regfile and CSRs holding dynamic configuration stat=
e
> > (vstart, vl, vtype, vcsr). The Vec Register width could be implementati=
on
> > defined, but same for all processes, so that is saved separately.
> >
> > This is not yet wired into final thread_struct - will be done when
> > __switch_to actually starts doing this in later patches.
> >
> > Given the variable (and potentially large) size of regfile, they are
> > saved in dynamically allocated memory, pointed to by datap pointer in
> > __riscv_v_ext_state.
> >
> > Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> > Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> > Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> > Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
>
> I think you missed a:
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
>
> Thanks,
> Conor.
>

Yes, removed it on purpose because I changed some inline assembly in
this submission. So I think you may want to take a look in case I did
something silly.

Thanks,
Andy.
