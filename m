Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA10656FA3
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 21:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbiL0Uxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 15:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiL0UxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 15:53:08 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC2514023
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 12:40:22 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id v2so7410219ioe.4
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 12:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rbatgyFiBgFH8qSS5LhReo4Viu8JCOR3w+2T79DxsFo=;
        b=C6azJII3KkGTNd9V3px0Gx0ex+kTISdAGmq7n3IgMDlm7KnkXr3NOQVaB3HKRGV2BW
         k0tLYKBXLdJ0N7YL1cb+nq6zD1oEhhbuP/BdrcfAeFb1mJUVZr+0fUpMvCNAsB2mpXZq
         5KBNFAHISURbaVu6DTe+NGFCB4xuaG7AJuBjhEg8r94RO9oJ0nJrBVdHInWbZ6ID+LYk
         iaGZSRbBiTP/8fg37H2EZOd5boOiexZ1s73ZPUmNuWM4K5w9mqoBWZ/y2EY3LRMw5e/O
         ZQUYSqB6+dGbOu5/IkXq0hrHG1JsKMxmPpTkbKHik9ifm3nS9faxSrDWYJvMgqbnJjC4
         eGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rbatgyFiBgFH8qSS5LhReo4Viu8JCOR3w+2T79DxsFo=;
        b=ays6X6pbu3yEkLUCV452BRMjFRyU0pCsSAQZTcu9B4ulfpxrllUgZg3c4gzgiB+MhW
         K3lxR8HssiAANM3W/ItouWoqkhJFouiDDckrAyvmXSSLwRS+aQJDNR26U9qmJInhLhDa
         lN22wMjyt8WomqarKnnM6qIiTsbKWi/ViNiLdLITznC7U5N0XI26TTkEUCGkGKBnMM2+
         1LjOTxghwVfT48t40wYnWmEklT3E+yQFgXf+LUQV5y6nMEDtkjBPt2SmaE5fvqfopZHP
         jayuDFILkmSLm2Y/jai7nN9MV8Xowil3eSi02dWwerbUDXaAYbnXiXmCNPePzJNrxJd0
         f6xA==
X-Gm-Message-State: AFqh2koSif21LCIxbSavsPnWpqMix6UsxVjkwNq+RFOnPlNP2B3euPoE
        L3c6KeRie7MyaXq09x+yIFMR4bKMPNbKClZ0O/KDfugI2mplGg==
X-Google-Smtp-Source: AMrXdXuyo07EqzZ6YmLNTL9/xoJde3y65M2Q48KihlUJOiKuhzQ40ITvTf/2c4x6bxWjPGD2OEjguAoZTo5Ug0WXyKs=
X-Received: by 2002:a5e:c31a:0:b0:6d6:5fe4:8212 with SMTP id
 a26-20020a5ec31a000000b006d65fe48212mr1736811iok.180.1672173621536; Tue, 27
 Dec 2022 12:40:21 -0800 (PST)
MIME-Version: 1.0
References: <20221227183713.29140-1-aaronlewis@google.com> <CALMp9eRe+8ypPXVvR5cwRT7YeuXFtT2HjiyGOU9a1U5WjoD0Pw@mail.gmail.com>
In-Reply-To: <CALMp9eRe+8ypPXVvR5cwRT7YeuXFtT2HjiyGOU9a1U5WjoD0Pw@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Tue, 27 Dec 2022 20:40:10 +0000
Message-ID: <CAAAPnDETsQ6F1JNtSCeMiupszmJ6aJnx1VmJ7WHN+GNRfhdi5w@mail.gmail.com>
Subject: Re: [PATCH 0/3] Clean up AMX cpuid bits XTILE_CFG and XTILE_DATA
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        like.xu.linux@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 27, 2022 at 8:01 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Tue, Dec 27, 2022 at 10:38 AM Aaron Lewis <aaronlewis@google.com> wrote:
> >
> > When running a SPR guest without AMX enabled
>
> Can you clarify what "without AMX enabled" means? Do you mean that
> userspace hasn't opted in to AMX via arch_prctl()?
>

Yes, exactly.  I'll clarify in the follow-up.
