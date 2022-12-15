Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88BF64E2FE
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 22:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiLOVU5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 16:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiLOVUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 16:20:30 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBBA56D66
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 13:20:29 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id a16so886339qtw.10
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 13:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WXDb+EX2ESKhrLmNgSh5O2/NUh9lzJ+wI1bqpoxRmT0=;
        b=YMDPnqtxIuxI1neTIAkMie4TAPfpOyhgO1ssJYOURo7uBlTUQR92WuobhFc/uthRdy
         45pE4mHMxHqBiXQzVmrHddcoOG8L2BzwD/hQUxgy4PgIMWsZTDFSbiZSDydig7xY6yOL
         azBFjJ9fV0w25rmhw3v2L9GT2ieCPa5C09LGE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WXDb+EX2ESKhrLmNgSh5O2/NUh9lzJ+wI1bqpoxRmT0=;
        b=nuE4UW2xshwA63+mmiFZxEl5ko52KiAMqrt3f6qN6loYzwOML4dASn8w9KgYAdEWZw
         ZCn9fdNRnD84J0b02ZMBfqEb7/3Ti3VMCHnGCkm4G+HNBYMwppvSPk9+P+cgBOM2jZRM
         QTNmPmhG5JygVQlsCUqy1TE0K9kj8NzET/tuN2LbhHB7b//exaVGFQzXel+GO9ML0gz2
         RW1nyt2l+8PeP6phjI3394gV149Jpiv1UtQiH3vAPgOq8ohD1OIP96v4A5XTBhuK0dQw
         3sN0IxnLjT1efM8+pnr07KwOAEOvuZxijK8RN2IXWAnFy6LiOuYx1zC/bW1vnEz6i589
         nGFQ==
X-Gm-Message-State: AFqh2korr4ktDLf1Xdq9t0HNLTqrUlfLRx3v5Dmp9RLytN/bd/DQPP9U
        hXEoDYVSlZgGKYEgvendaoiiGukzPA7FfB1d
X-Google-Smtp-Source: AMrXdXvPz9RO1doYXITy9qcz78v1sVmscdZI19zGIPMdtG8utb5sOuGz1POoz7qiFzIPh7Uh2hUViQ==
X-Received: by 2002:ac8:6bda:0:b0:3a9:7037:841a with SMTP id b26-20020ac86bda000000b003a97037841amr1273526qtt.29.1671139228274;
        Thu, 15 Dec 2022 13:20:28 -0800 (PST)
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com. [209.85.222.171])
        by smtp.gmail.com with ESMTPSA id y21-20020ac85255000000b00398313f286dsm56052qtn.40.2022.12.15.13.20.27
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 13:20:27 -0800 (PST)
Received: by mail-qk1-f171.google.com with SMTP id pj1so125357qkn.3
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 13:20:27 -0800 (PST)
X-Received: by 2002:ae9:ef48:0:b0:6fe:d4a6:dcef with SMTP id
 d69-20020ae9ef48000000b006fed4a6dcefmr11108076qkg.594.1671139226956; Thu, 15
 Dec 2022 13:20:26 -0800 (PST)
MIME-Version: 1.0
References: <20221215132415.07f82cda.alex.williamson@redhat.com>
In-Reply-To: <20221215132415.07f82cda.alex.williamson@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 15 Dec 2022 13:20:11 -0800
X-Gmail-Original-Message-ID: <CAHk-=whQ48-RsU85vM+Kwi=pRNU9fX8JXmooqx4=c1QYOjv2uw@mail.gmail.com>
Message-ID: <CAHk-=whQ48-RsU85vM+Kwi=pRNU9fX8JXmooqx4=c1QYOjv2uw@mail.gmail.com>
Subject: Re: [GIT PULL] VFIO updates for v6.2-rc1
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022 at 12:24 PM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> I've provided resolution of the conflict chunks here below
> the diffstat.

Ok, mine is slightly different, but the differences seem to be either
irrelevant ordering differences (in the Makefile), and due to Jason
apparently renaming the goto targets which I didn't do.

But hey,. maybe I messed up, so please do check out it and test. I
verified that it all builds cleanly for me, but that's all the testing
it has gotten.

            Linus
