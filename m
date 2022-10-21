Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7557A607F90
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 22:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiJUUOB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 16:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiJUUN6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 16:13:58 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3D62A040B
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:13:57 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id r3so4593679yba.5
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gWD5WqewnwnwH17FeN2kqNozNa4aisIqbTT9dm9FTog=;
        b=UMO1+TuyGR/vgDd8F/S6YNAIdGp2wj/kw1bryMrv/9kjiHtwteVpsVQkjnWDg8IX2X
         volBEQflw9mvpqAKJSEmbzijhKnPFSv4iMDaZcXj08SQPcunNA29xhVpq1QqcBSVtBTM
         iAriu6zi5i2u/zAfyyr8dPDc+4geHGKD3WjyIv18Nj9MNp0vBT6rW+fxnu6Al+wUYcXz
         KzVTEO9Ocod1C9WnXeRMwkOFAble7Ufgy0ehBgaF1ACdUKyf5ymoAKWgNzqDpwyL2/hN
         JTq6Q89PkKGxOo3aSecldbr9coa4KoSqgcnm21deRwdCkdM/KkzFpy96VF6k4NkMuoZT
         avdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gWD5WqewnwnwH17FeN2kqNozNa4aisIqbTT9dm9FTog=;
        b=SCP/i3W8LAvFYEsgI+mr9944/YRhevFYjjFVuPSt+kaxkitG3IH9H77ZzXy4vT4R7T
         t6FNkfTO3EJFIQCwHbXS2fybcPUeCJ+jH7ShshRT49gXodKJ97oymVPaIKnmxRvaj6jJ
         1aXHA/h3O7oy2QAkPLTonoaOVKrVOLDi6rlMivlbNCCLjOQC/NDZ5LlMQ2Lsybt7oi5A
         Qr0oXjxZYMVDagbfOLpXrNUuvUsJYJtLfr4Uk8VndoiNOJOPUC4IlqSBD03sVBdhDaYi
         be+WMyxpBDm3nvUmhRNWvGDnKNTjWX3wE604El/5CPcfNFzU0mF3weIUzbjwWTaSmZA4
         yHUA==
X-Gm-Message-State: ACrzQf3ZDqz8Z0tlrEliHS4wkEsmcJQvl0mlnZyq081uh+pLEJnw69Jj
        g5MbZc6iIIuag8iFtyMHL1by2hSUtqqodoPAGgp/NizJTSI=
X-Google-Smtp-Source: AMsMyM4i+WU4w3M0m4cgFN2pXOXSXvNbu+Rdz6ac47/tZGy2mt8WXdtIFEPU7IoifcmrJC3wyA1TFnPJG4JFlvewxZQ=
X-Received: by 2002:a25:4fc1:0:b0:6bc:c570:f99e with SMTP id
 d184-20020a254fc1000000b006bcc570f99emr18229491ybb.58.1666383236120; Fri, 21
 Oct 2022 13:13:56 -0700 (PDT)
MIME-Version: 1.0
References: <Y1LA2qoQEoQ+bNMG@invalid>
In-Reply-To: <Y1LA2qoQEoQ+bNMG@invalid>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Fri, 21 Oct 2022 16:13:44 -0400
Message-ID: <CAJSP0QUE_mQc0VnK6_GwbAwNLzEeHyYYwrxYWHaTrSCj120How@mail.gmail.com>
Subject: Re: QEMU Advent Calendar 2022 Call for Images
To:     Eldon Stegall <eldon-qemu@eldondev.com>
Cc:     qemu-discuss@nongnu.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, libvir-list@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Oct 2022 at 12:45, Eldon Stegall <eldon-qemu@eldondev.com> wrote:
> We are working to make QEMU Advent Calendar 2022 happen this year, and
> if you have had an interesting experience with QEMU recently, we would
> love for you to contribute!

Hi Eldon,
Count me in for 1 disk image. I will find something cool and check
with you to make sure it hasn't been done before.

Stefan
