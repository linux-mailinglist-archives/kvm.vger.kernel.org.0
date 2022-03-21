Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7834E2B35
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 15:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349601AbiCUOuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 10:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349608AbiCUOuJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 10:50:09 -0400
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBC8BEE;
        Mon, 21 Mar 2022 07:48:43 -0700 (PDT)
Received: by mail-qv1-f45.google.com with SMTP id k7so6124309qvc.4;
        Mon, 21 Mar 2022 07:48:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5DZRqsc/WV1yIwtHhKy6Su/O4u6fIrVwk8MROJjz5EA=;
        b=xzhPc0jDqxPb/ugXhzgijaZKaiGPmCplTXq0YQ10GWkOYv2fpyhxCKbN8nDdtj6WmJ
         bz2v5NiY0HhUnkaFx3C98Ao8m2jPD9TmQPByUnl/wCeSgdmzYIwGw8R1/GL0GMNpEmuO
         fe+l09Ds4YZN+tNVpGmtz08X/4rfVudP4qXU0lwNn1ttn/X2BVbwzrUxQAPSafpTTRzz
         ZKdn+m592NkRMfK4wEfDZNJKGyMz/T+xsCIkUwwEa8LSbCpR7jqZr8Bz8RGQ1RDBNjB2
         6Oq79W0Hknt22VZPVLgmWDnkK43HQWaFB8Npj0nuTsNR665Ve/G1Sa+RfkXN3yqrSYdd
         Mr/g==
X-Gm-Message-State: AOAM531zdvPtU3W/P1ofx6Q6/nPuPCfbUX3PWLzNoq6F8W7h6aIGG8uQ
        PFK3ux2EY2Z4M511GCs15UOTFR3PwjY5UQ==
X-Google-Smtp-Source: ABdhPJykIqMPSLKFMBD6DlgpbN01fruI6HzMZgctrIJgpEAwWz7zpgEmVrtJHnNjPzI/UDB4+9c67g==
X-Received: by 2002:a05:6214:21e2:b0:441:a5d:59fa with SMTP id p2-20020a05621421e200b004410a5d59famr9111313qvj.5.1647874121933;
        Mon, 21 Mar 2022 07:48:41 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id a36-20020a05620a43a400b0067e95f1248asm1786823qkp.45.2022.03.21.07.48.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 07:48:41 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id u103so28444281ybi.9;
        Mon, 21 Mar 2022 07:48:41 -0700 (PDT)
X-Received: by 2002:a25:45:0:b0:633:96e2:2179 with SMTP id 66-20020a250045000000b0063396e22179mr23066319yba.393.1647874121306;
 Mon, 21 Mar 2022 07:48:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wj4fFjx2pgbGNBM4wJs3=eReZ05EQyprzgT2Jv8qJ2vJg@mail.gmail.com>
 <20220321101654.3570822-1-geert@linux-m68k.org>
In-Reply-To: <20220321101654.3570822-1-geert@linux-m68k.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 21 Mar 2022 15:48:30 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWsrW0WFB+B6wGg2k4wo1qk1xi2s2sbaw44=uVvVpopHw@mail.gmail.com>
Message-ID: <CAMuHMdWsrW0WFB+B6wGg2k4wo1qk1xi2s2sbaw44=uVvVpopHw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v5.17
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     sparclinux <sparclinux@vger.kernel.org>,
        linux-um <linux-um@lists.infradead.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 21, 2022 at 3:00 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> JFYI, when comparing v5.17[1] to v5.17-rc8[3], the summaries are:
>   - build errors: +5/-0

  + /kisskb/src/crypto/blake2b_generic.c: error: the frame size of
2288 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]:  =>
109:1

sparc64-gcc11/sparc-allmodconfig

  + /kisskb/src/drivers/vfio/pci/vfio_pci_rdwr.c: error: assignment
makes pointer from integer without a cast [-Werror=int-conversion]:
=> 324:9, 317:9
  + /kisskb/src/drivers/vfio/pci/vfio_pci_rdwr.c: error: implicit
declaration of function 'ioport_map'
[-Werror=implicit-function-declaration]:  => 317:11
  + /kisskb/src/drivers/vfio/pci/vfio_pci_rdwr.c: error: implicit
declaration of function 'ioport_unmap'
[-Werror=implicit-function-declaration]:  => 338:15

um-x86_64/um-all{mod,yes}config

  + error: arch/powerpc/kvm/book3s_64_entry.o: relocation truncated to
fit: R_PPC64_REL14 (stub) against symbol `machine_check_common'
defined in .text section in arch/powerpc/kernel/head_64.o:  =>
(.text+0x3e4)

powerpc-gcc5/powerpc-allyesconfig

> [1] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/f443e374ae131c168a065ea1748feac6b2e76613/ (96 out of 98 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/09688c0166e76ce2fb85e86b9d99be8b0084cdf9/ (96 out of 98 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
