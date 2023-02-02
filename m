Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99AB688613
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbjBBSHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbjBBSHo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:07:44 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A561DBAD
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:07:22 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id m8so2861022edd.10
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vrull.eu; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qS2IXYxp8yU8zvKrd59L5bRXHOVgB0wEsKEh/WWwjj4=;
        b=S47/9/P4x9bmIUSasETyhPLinKPj7tKchay7HobSJddp3jcPGgHmnWvLUyDJ6wl8R8
         iUQ7gskrbRrj12VFz2wbku0oL4LBlmMGEmm05mFTmR9MncGT1DFFtMFdbbmNhKyD88ef
         Gqt+W5KnpITJt65JryWBSQcxWcsa7Yp1raFGn+Wd4cGuouofNbhVtYEFukzIEJHC9NKW
         hbo5tuPTr9XAvGX2IKTvO9Ry4K6z//MJPAiOIA3zKm5Rp4oPlPueJ2AuuelmcDQ/m3hr
         AkQwjbzNI4bNkx2+Papb1YmyqOi8Ju7B5KO+MGwCZGE3+8cHOlFtRgKIm/hxrXK7O8Lw
         fjsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qS2IXYxp8yU8zvKrd59L5bRXHOVgB0wEsKEh/WWwjj4=;
        b=wbYMGfmpsc3iIQous5hq2clfWt4p87Km3TbzAra8MiJpgwUSF4Wx4EoLaBul7myoqX
         fpQRwE+uya2hF1Yx217NsG8mKVuTiXae73Wv1antRglUZDYkayJ2pXh66onKobQ8uc5j
         RbH/tioPugYjxupUz/sq4hx22B1iCMDbdaT4JXQt25dL1F+GvRthClSe6Uhf856NoEB/
         g/VH2fJ79TTSsemFU5fZMhY17aIS9fJb2HlwTqTv1mfUepGFM3Ycko7/Xb0SFvESr+hS
         HfT8V+nmL4eOdiCfq3PAWf2SdpYhU6RWRRXJFnmZhCkjPN15I410ZWF+n8PN5Ojq1cpo
         lSKQ==
X-Gm-Message-State: AO0yUKUdFf3+vwGPxOpyRY/O8zGgafybsaHjTHVWgjvZquN2LbSuBkcW
        nFHXp5Uk4YfJln9ttiaAnX44Ks2RhBaqyyqCQ+5kVw==
X-Google-Smtp-Source: AK7set9abVs8QP27sDKE03Be2o9JSJqJQIzqUKRGHiObcEDFP7l5580oyKW1rDuMB9yC3fb79giE5pDahovFPDM0NXM=
X-Received: by 2002:a05:6402:1f8e:b0:49c:9760:2def with SMTP id
 c14-20020a0564021f8e00b0049c97602defmr2466456edc.64.1675361241053; Thu, 02
 Feb 2023 10:07:21 -0800 (PST)
MIME-Version: 1.0
References: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk>
 <20230202124230.295997-7-lawrence.hunter@codethink.co.uk> <CAAeLtUA188Tdq4rROAWNqNkMSOXVT0BWQX669L6fyt5oM5knZg@mail.gmail.com>
 <CAAeLtUDcpyWkKgAo2Lk0ZoHcdyEeVARYkh05Ps27wbOzDF0sHA@mail.gmail.com> <16a6fadf-ca13-d3aa-7e4b-f950db982a21@linaro.org>
In-Reply-To: <16a6fadf-ca13-d3aa-7e4b-f950db982a21@linaro.org>
From:   Philipp Tomsich <philipp.tomsich@vrull.eu>
Date:   Thu, 2 Feb 2023 19:07:09 +0100
Message-ID: <CAAeLtUCTBASoGMMgzp_LxOiFkJq0wJFQUC4kDzCWA47iLR_N5Q@mail.gmail.com>
Subject: Re: [PATCH 06/39] target/riscv: Add vrol.[vv, vx] and vror.[vv, vx,
 vi] decoding, translation and execution support
To:     Richard Henderson <richard.henderson@linaro.org>
Cc:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>,
        qemu-devel@nongnu.org, dickon.hood@codethink.co.uk,
        nazar.kazakov@codethink.co.uk, kiran.ostrolenk@codethink.co.uk,
        frank.chang@sifive.com, palmer@dabbelt.com,
        alistair.francis@wdc.com, bin.meng@windriver.com,
        pbonzini@redhat.com, kvm@vger.kernel.org
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

On Thu, 2 Feb 2023 at 18:35, Richard Henderson
<richard.henderson@linaro.org> wrote:
>
> On 2/2/23 04:30, Philipp Tomsich wrote:
> > On the second pass over these patches, here's how we can use gvec
> > support for both vror and vrol:
> >
> > /* Synthesize a rotate-right from a negate(shift-amount) + rotate-left =
*/
> > static void tcg_gen_gvec_rotrs(unsigned vece, uint32_t dofs, uint32_t a=
ofs,
> >                         TCGv_i32 shift, uint32_t oprsz, uint32_t maxsz)
> > {
> >      TCGv_i32 tmp =3D tcg_temp_new_i32();
> >      tcg_gen_neg_i32(tmp, shift);
> >      tcg_gen_gvec_rotls(vece, dofs, aofs, tmp, oprsz, maxsz);
>
> We can add rotls generically.
> I hadn't done this so far because there were no users.

I read this such that your preference is to have a generic gvec rotrs?
If this is correct, I can drop a patch to that effect=E2=80=A6

Philipp.
