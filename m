Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812934C1407
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 14:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240877AbiBWNWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 08:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238995AbiBWNWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 08:22:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3B74EA34;
        Wed, 23 Feb 2022 05:21:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38746B81FB3;
        Wed, 23 Feb 2022 13:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B918C340F7;
        Wed, 23 Feb 2022 13:21:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="B1edNqIi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645622496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jNCqwRVwwnl2Hzkwee6ETCjLUlSGOZ/h+OLPPjOrc0Y=;
        b=B1edNqIi5b5HctHZNPAaowU88lVryawcFNGYjSp85vHovokqADjt+gCUWQtoL8L26HfDe3
        nl8aJAMIZYBIy8qi3ZYXwTdRr82nWHV60r4P2Uyim3JETbtJFhkxCHI+ueWTYKGJ0iBXol
        RuYemuRnCCuF1yTAFE6Dp8d6Oaed8fM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a513edf2 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 23 Feb 2022 13:21:36 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id p19so47897896ybc.6;
        Wed, 23 Feb 2022 05:21:34 -0800 (PST)
X-Gm-Message-State: AOAM531YdcEAtdHu9cUGecLEDyPn3C8xhmWF158beDmndhHqdGevvuli
        5wIWEU20p5eqUvigc/UxUAZ4sBdyTB7e+Z+1OLE=
X-Google-Smtp-Source: ABdhPJyPz4I/fVrE2hAwlxEjASOoJgctbxsl4Sw1b3At1gDlRAwGMq/v/jtx+mRgcRGA5d7YgSWANySbbRg9ZZzPO00=
X-Received: by 2002:a05:6902:693:b0:613:7f4f:2e63 with SMTP id
 i19-20020a056902069300b006137f4f2e63mr26519604ybt.271.1645622492226; Wed, 23
 Feb 2022 05:21:32 -0800 (PST)
MIME-Version: 1.0
References: <1614156452-17311-1-git-send-email-acatan@amazon.com>
 <1614156452-17311-3-git-send-email-acatan@amazon.com> <CAHmME9o6cjZT1Cj1g5w5WQE83YxJNqB7eUCWn74FA9Pbb3Y6nQ@mail.gmail.com>
 <CAHmME9poYgfoniexZ2dvpEEvnWGLQTOjOvB2bck-Whhy9h+Hjw@mail.gmail.com>
In-Reply-To: <CAHmME9poYgfoniexZ2dvpEEvnWGLQTOjOvB2bck-Whhy9h+Hjw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 23 Feb 2022 14:21:21 +0100
X-Gmail-Original-Message-ID: <CAHmME9pFZKtBP7R8St03544nHc=7ztFsK1q9fKPGKXZgjHckVw@mail.gmail.com>
Message-ID: <CAHmME9pFZKtBP7R8St03544nHc=7ztFsK1q9fKPGKXZgjHckVw@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] drivers/virt: vmgenid: add vm generation id driver
To:     adrian@parity.io
Cc:     "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>, linux-s390@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        graf@amazon.com, Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Rapoport <rppt@kernel.org>, 0x7f454c46@gmail.com,
        borntraeger@de.ibm.com, Jann Horn <jannh@google.com>,
        Willy Tarreau <w@1wt.eu>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Andrew Lutomirski <luto@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>, bonzini@gnu.org,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Michael Ellerman <mpe@ellerman.id.au>, areber@redhat.com,
        ovzxemul@gmail.com, avagin@gmail.com, ptikhomirov@virtuozzo.com,
        gil@azul.com, asmehra@redhat.com, dgunigun@redhat.com,
        vijaysun@ca.ibm.com, oridgar@gmail.com, ghammer@redhat.com,
        Adrian Catangiu <acatan@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 22, 2022 at 11:17 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Well I cleaned up this v7 and refactored it into something along the
> lines of what I'm thinking. I don't yet know enough about this general
> problem space to propose the patch and I haven't tested it either

A little further along, there's now this series:
https://lore.kernel.org/lkml/20220223131231.403386-1-Jason@zx2c4.com/T/
We can resume discussion there.

Jason
