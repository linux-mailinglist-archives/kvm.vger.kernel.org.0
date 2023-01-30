Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A72D6806B7
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 08:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235471AbjA3Hqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 02:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbjA3Hqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 02:46:45 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B6E166E9
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 23:46:44 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id h5so12920376ybj.8
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 23:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TJknPwaLq9rnEYcTZh5lLSNm0HI7FpaAywxMPndbjks=;
        b=D07tZiVjzQIfHrc5CxGPzdmv/5hKD3mGUI4DyOVB+x+ifsND+QYFjOTgy6KrOgFahw
         a7XZJeYupy/uPRdyZ3XsfQcgOFnehies5fWq2PevguImeiki+AefMcMFSTNlBkEHCdes
         E0pqxwRnOz5WTmMx5lhGp/8vuJutJsBiQbVewDjJuXrPqSKRBiaVQjvASKN3s8aae0Op
         avQtbHZfwm/e8WYfhl2fDJ2jsI2idpwEgNsbkANuEOCYMInto0M20LB6B7kvYJ04RQYf
         4i1JnjWEtt3PlLw5xlqluQJG5a1HZQhppalc8/ql/xAbkB3zJMtWCSvIqfhMc7BAtheK
         Cigw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TJknPwaLq9rnEYcTZh5lLSNm0HI7FpaAywxMPndbjks=;
        b=amawkXss8F18p4SwkkRqOE+KAWsBk2CRoJ2nCfyz+LlD/40xteL2vk2DBH8XMhSfMC
         xA5EPc354WrkAyWGcweKcFcP2T19BwYsuRbxm4dQCNxnQyPzeg+9PV8T66poRxC/1jf3
         io31U+0V9zLIqX1e40Hf8+EnXOKpZG+uI6+SRojwAlWd1mrNejv0p/FK75r9QfaMyF45
         xHUzRE45cz9/QIXhx37RQLUS+nc59m0+a/63vocCOWc5Rv0sMPDBasthKEgXU09TgBEo
         WGPlDyRRrofUCdcRzDw1W8pwWCEUwWtmZ05y+w735GQvDfg0Z2PejGEohRilepe3SsO8
         rZvg==
X-Gm-Message-State: AO0yUKUvw05XAfNqyNpp2ydI5MTzdvIYdITBw//nzzY+pnedoaewLoD3
        i7iEcQyPVbAIZDedqkr9IOsVl0ZRNy1ar4H/scbQNNGbokSHmdfy
X-Google-Smtp-Source: AK7set8qP1iaWhPj5PzCd2uPrhhxv+P4DFONg3Z1SUnzaPE/rUb0iYdTAhRykzDEs3VFzSE2FrQhTRjYzjwBIKiyw50=
X-Received: by 2002:a25:ac23:0:b0:80e:e950:29fc with SMTP id
 w35-20020a25ac23000000b0080ee95029fcmr1093475ybi.345.1675064803660; Sun, 29
 Jan 2023 23:46:43 -0800 (PST)
MIME-Version: 1.0
References: <20230125142056.18356-1-andy.chiu@sifive.com> <20230125142056.18356-20-andy.chiu@sifive.com>
 <Y9GZbVrZxEZAraVu@spud>
In-Reply-To: <Y9GZbVrZxEZAraVu@spud>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Mon, 30 Jan 2023 15:46:32 +0800
Message-ID: <CABgGipW430Cs0OgYO94RqfwrBFJOPV3HeS24Rv3nHgr4yOVaPQ@mail.gmail.com>
Subject: Re: [PATCH -next v13 19/19] riscv: Enable Vector code to be built
To:     Conor Dooley <conor@kernel.org>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 26, 2023 at 5:04 AM Conor Dooley <conor@kernel.org> wrote:
> Firstly, no-implicit-float is a CFLAG, so why add it to march?
I placed it in march because I thought we need the flag in vdso. And,
KBUILD_CFLAGS is not enough for vdso. However, I think we don't need
this flag in vdso since it is run in user space anyway.
> There is an existing patch on the list for enabling this flag, but I
> recall Palmer saying that it was not actually needed?
The flag is needed for clang builds to prevent auto-vectorization from
using V in the kernel code [1].

> Palmer, do you remember why that was?
The discussion[2] suggested that we need this flag, IIUC. But somehow
the patch did make it into the tree.
>
[1]https://lore.kernel.org/all/CAOnJCULtT-y9vo6YhW7bW9XyKRdod-hvFfr02jHVamR_LcsKdA@mail.gmail.com/
[2]https://lore.kernel.org/all/20221216185012.2342675-1-abdulras@google.com/
