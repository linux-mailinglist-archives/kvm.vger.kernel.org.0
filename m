Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E444B36DB
	for <lists+kvm@lfdr.de>; Sat, 12 Feb 2022 18:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiBLRnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 12:43:02 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiBLRnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 12:43:01 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F962FFCC
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 09:42:57 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id o128-20020a4a4486000000b003181707ed40so14180998ooa.11
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 09:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=25tKNj6BxPPW25GtLcw/c+Az2XNOgeJmbC0MaW6QQUs=;
        b=CEc02q+8XOEnH0Al0Tc9e/TK37reBz09RNr02FXqiXvrYcd0wp740EB43qbPAyu+pU
         YWC68s6QrtLiMK9KAZpopTu1CyyeeuIlBM5IreReXioJRmJ4zdLekNGLn3qxVCX5dbxv
         cHHUAmoxA0449TMhgb/JsvQAfTqBz6Dc4un98pWuBE8W1ALSF7Htsa5sGg4fbeRCGMvw
         IisvupdQlu1EX5U0H3duddqlIn5R/wd1R58N/xTDlhWq/txgQMqihbxsG24ovhCGEHXx
         8D3xZilVAzTxsz2huJA4bTcRLrcsuyLmunF4rYciNIYp3wUF5N0O6GXOpNnnaLClkyUu
         DFXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=25tKNj6BxPPW25GtLcw/c+Az2XNOgeJmbC0MaW6QQUs=;
        b=U/9UzWe590pAOQYUcM0+J9bc9TQ0Y3tGuRC2QPwxIqrmbQbG3QzTH6tfc+J2dHbjNC
         QzjF0QKS9Q8P67UTKCncsZ+Aus64j6A7kmjiE31lVy7dXMRZtOOZoeQ2NvBM+5iXvQ50
         Z9UCZsvinQ+L2ooBgAOuDGxYaDStXQ7Bp69ImM8hQoDtbegdRocf29dQqbLacUjzi3la
         hL5rVVf56zEMEYrgFMHBGoDy/XP/5koydqHMJXrBkgdOVPo/qQZKyf0G2z6CMUjK9oKY
         be1ybGZ+zSX3OmhSw0oIJCswE5Kr4/Xfd5uCsWXPZ9wTbtqmeewomr4RDitKNP5CRIjo
         qesQ==
X-Gm-Message-State: AOAM530LHGAFIkzqMyGlEcO2qOeasqGkIn7+4jkAsuwudBTvgSJGaacu
        /RSVaWCucpOI0TkGZUF9mVIR7UNstFQsz8755Q4ztA==
X-Google-Smtp-Source: ABdhPJy8UcuVMhrH8fGHFrMX2E1bRxUsBcfX6UZkujfwzo9thT90q7rcLleSRvdKEH777WA+RkunYctmgY8fXSHeXQM=
X-Received: by 2002:a05:6870:6186:: with SMTP id a6mr1839795oah.153.1644687776891;
 Sat, 12 Feb 2022 09:42:56 -0800 (PST)
MIME-Version: 1.0
References: <20220209164420.8894-1-varad.gautam@suse.com> <20220209164420.8894-4-varad.gautam@suse.com>
In-Reply-To: <20220209164420.8894-4-varad.gautam@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Sat, 12 Feb 2022 09:42:45 -0800
Message-ID: <CAA03e5HGyxUFQqp0BhiN6c7zEZc4qcAjb=FEpNo1XX1L_3Aa1w@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 03/10] lib: x86: Import insn decoder
 from Linux
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 9, 2022 at 8:44 AM Varad Gautam <varad.gautam@suse.com> wrote:
>
> Processing #VC exceptions on AMD SEV-ES requires instruction decoding
> logic to set up the right GHCB state before exiting to the host.
>
> Pull in the instruction decoder from Linux for this purpose.
>
> Origin: Linux 64222515138e43da1fcf288f0289ef1020427b87
>
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  lib/x86/insn/inat-tables.c | 1566 ++++++++++++++++++++++++++++++++++++
>  lib/x86/insn/inat.c        |   86 ++
>  lib/x86/insn/inat.h        |  233 ++++++
>  lib/x86/insn/inat_types.h  |   18 +
>  lib/x86/insn/insn.c        |  778 ++++++++++++++++++
>  lib/x86/insn/insn.h        |  280 +++++++
>  x86/Makefile.common        |    2 +
>  7 files changed, 2963 insertions(+)
>  create mode 100644 lib/x86/insn/inat-tables.c

In Linux, this file is generated. Why not take the scripts to generate
it -- rather than the generated file?

>  create mode 100644 lib/x86/insn/inat.c
>  create mode 100644 lib/x86/insn/inat.h
>  create mode 100644 lib/x86/insn/inat_types.h
>  create mode 100644 lib/x86/insn/insn.c
>  create mode 100644 lib/x86/insn/insn.h

I diffed all of these files against their counterparts in Linus' tree
at SHA1 64222515138e. I saw differences for insn.c and insn.h. Is that
intended?

Also, should we add a README to this directory to explain that the
code was obtained from upstream, how this was done, and when/how to
update it?
