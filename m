Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E056D22C0
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 16:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbjCaOi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 10:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbjCaOiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 10:38:54 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1720AD308
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 07:38:53 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id x17so29202426lfu.5
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 07:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1680273531;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OSw02QdSNYs5iQZe8kVdqUeP5gxl8yJEkHqDoZqEb90=;
        b=UdGoddf5bXxD5gSKKZq5xbNf3lX6c0scs+3DExuWR1IkKuRV2OpGycyCufuzcrA7c0
         6KGfJpJXc3FkeuZKrWcDoA/rHcdS5f/pxrQn64xP+LpQrgRVRap1cMy+/FLEgoP92oCc
         4mdDYlp5aMhMgFuVrRpVUTbXZx4+irIvIZDVGYwtm/JnvIEn44OIrWP9z0SOvz426gZ0
         44wbNjL4qnBL/2sGfBruXGltCiPoyo/pTzgOCcu2Ejcqqo1KgU+A2fHE0hP5VzPExB6g
         wcElCE7LQasGv+7/bysxor0oo+O42M7d3JwI3YQJdQOtS1pvB6IFZ9qjkdFEDAqC4SCi
         QfjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680273531;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OSw02QdSNYs5iQZe8kVdqUeP5gxl8yJEkHqDoZqEb90=;
        b=wirhV8CewNpHzgc8g4ZeoZcNT2fs2rfyZC6JVgCi1+OlTiKt25FhvRWGMAdkB2dw5W
         wlYafxrHt4zK37JU7viNGnmmpZirJBYl4RzIZ0W/daNCVAu6pPw8olPvYOl/mfDt1HEH
         HVnGn9xEbhak/J9VSwVwBB8RLSoYISOwNFyFjXvqGsthIk3mMBvWao2JOKRBHg5FqxUG
         Sdc042WF8y6BWgD/B47Q2cqt7AhbJchJPyLoOQ1lPwSiwdgn3muC72f8MAOb4+OwyloS
         9BPiaaiFJckqSdjSHc8cBf9fGvPAwwzNb6JSwybvv3acjFJ3YxvSs5onzwFMS2hFphCG
         NtLA==
X-Gm-Message-State: AAQBX9cUYJeiiDfrRE89ghw7ognkCF6Hqwj3WJxQiqpd1/yqTrW2XLb+
        XXB6pTxDQnz7YbdU3JoUAvxdXBiamjtb2NUKLUj/AQ==
X-Google-Smtp-Source: AKy350aQ7Ed8xOev3qhnK3Z1+w6VORlZZ7zAZIucuWwPUVNpKjgScrPlpHU6JNq5KIJ0AE2M12TI3RWGPDoDx3fLtVI=
X-Received: by 2002:a05:6512:2182:b0:4dd:9931:c555 with SMTP id
 b2-20020a056512218200b004dd9931c555mr3121265lft.0.1680273531309; Fri, 31 Mar
 2023 07:38:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230327164941.20491-1-andy.chiu@sifive.com> <20230327164941.20491-11-andy.chiu@sifive.com>
 <3435e5c9-5969-4abc-b929-5a73806e3506@spud>
In-Reply-To: <3435e5c9-5969-4abc-b929-5a73806e3506@spud>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Fri, 31 Mar 2023 22:38:40 +0800
Message-ID: <CABgGipWEyhct3fQMjZ4+OL7WU-L_TZCDJsJq=GhsH0bn9Az_mA@mail.gmail.com>
Subject: Re: [PATCH -next v17 10/20] riscv: Allocate user's vector context in
 the first-use trap
To:     Conor Dooley <conor@kernel.org>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Liao Chang <liaochang1@huawei.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Mattias Nissler <mnissler@rivosinc.com>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 29, 2023 at 1:22=E2=80=AFAM Conor Dooley <conor@kernel.org> wro=
te:
>
> On Mon, Mar 27, 2023 at 04:49:30PM +0000, Andy Chiu wrote:
> > Vector unit is disabled by default for all user processes. Thus, a
> > process will take a trap (illegal instruction) into kernel at the first
> > time when it uses Vector. Only after then, the kernel allocates V
> > context and starts take care of the context for that user process.
> >
> > Suggested-by: Richard Henderson <richard.henderson@linaro.org>
> > Link: https://lore.kernel.org/r/3923eeee-e4dc-0911-40bf-84c34aee962d@li=
naro.org
> > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
>
> I see you dropped two R-b from this patch, what actually changed here?
> It's not immediately obvious to me (sorry!) and the cover doesn't mention
> why they were dropped.

Hi, the reason why I dropped R-b here is that there is a conflict in
trap.c because the API has changed after converting to generic entry.
And that change does not make v16's way work out of the box, so it
(trap.c @ v17) requires some more reviewing I suppose.

Thanks for asking! I should get better at describing these in the cover let=
ter.

Andy
