Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D245207A2
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 00:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbiEIWdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 18:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiEIWdU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 18:33:20 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7495526FA2E
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 15:29:25 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id x8so15293084vsg.11
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 15:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to;
        bh=VSSUIwdzgxQxnEkB7+u7pnweyPajIQMP3nQqWYs8VX0=;
        b=oUhM6zs0oZht7dla3Q1UNCZ6yWM7pC2SIDervYNx2QasrUJQklXskeQFx5gtConc0i
         o/fvzAHAKqsE4r6BBTqLjqaOKSMZ1cpZabelNgvNBIt1zKPp0pGpu96PSwgotkJKz8PF
         zE1SLmdBF4b2w8EusJdYLSkYS9YHYr/a+9mtuVpuH1CgNP2omGCpf4jbwDAt7ZNiiBZ/
         6vVn6u78ige61vX9RjE5FJ0ljOq3/mex7Yn+2SaxYQbz4YKuaSSnOczC0RbCsobGyY7p
         bVAT742vKE3Wo6WNVSG6DGMqS5Z9S8tlh2GVtjXLcMVANlMpn4hk8ZKb2reCFNlq0g3c
         POqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to;
        bh=VSSUIwdzgxQxnEkB7+u7pnweyPajIQMP3nQqWYs8VX0=;
        b=0rFSOcJWnghciNkFeiUkozzmFf/v6SQ8Mddw59jmHRfAylHYm/mTdyndkv8mcR0c7u
         SC9g4pVUlZHhgUe+a77czrw65AFmbz8IxRWBkECRIuZSQ7ryntqDcZWKz58/TZu7l5q/
         QRTyOZ140BtpFbJ1rDzRV9xu0XY2+XGsYJVOUlimP5chb841gRm+ebaTyVnPFJYyCXHe
         UAvMZ2JiMeaYaJUQQjpHlBK0emMnF6Yh3J8PWIv4Sm3B18P3eHegw1od93IJMYfWihNa
         NUZpbTfpUzpvsF1QXwPa9I2eWdSvdjZ/ruXTxIYFMxstChjK+ZaTrwTAF1mFhdWtV4zm
         tPyg==
X-Gm-Message-State: AOAM532HaBVa7Ib0FsagLYMvgEk5CSnEvc7rlcQkDoHe30CUw7EHWk0x
        g6s8cSXsGYSgj9baDYhyznYCDtkEpNEn7vgIxjw=
X-Google-Smtp-Source: ABdhPJzuKUqZjdlzL6MwjzrsjJP0n/LD0gmTSFesDWJGlp/3HcjxhcHboW5vMV6rTrvX/nBsvtOF6OKthA/GP2qDZeY=
X-Received: by 2002:a05:6102:c13:b0:32d:518f:feaf with SMTP id
 x19-20020a0561020c1300b0032d518ffeafmr10161206vss.84.1652135364199; Mon, 09
 May 2022 15:29:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:612c:221e:b0:2a9:aa30:c488 with HTTP; Mon, 9 May 2022
 15:29:23 -0700 (PDT)
Reply-To: warren001buffett@gmail.com
In-Reply-To: <CAGcnDd3WYU+d6hSM8_NtEcyVwVbg+X6rF8VQdbcqq5MgUOj74w@mail.gmail.com>
References: <CAGcnDd28kPHzw1L4gL4a0Fe2Q854ALK6NHQYw-=htSkBmDPBTA@mail.gmail.com>
 <CAGcnDd1fkiaxCzKsGYj21JnoTVxWvFDBD7dEAneDp3FwV1akKA@mail.gmail.com>
 <CAGcnDd1KwaVY91kgvREMANyzhtVK+_oU=s1qYx7rKLWzb1GZMw@mail.gmail.com> <CAGcnDd3WYU+d6hSM8_NtEcyVwVbg+X6rF8VQdbcqq5MgUOj74w@mail.gmail.com>
From:   Warren Buffett <koamididiera@gmail.com>
Date:   Mon, 9 May 2022 22:29:23 +0000
Message-ID: <CAGcnDd1KtcZwhvvmwT42yoAki7JfX+zmXVekC8T5Ay0mWYibcA@mail.gmail.com>
Subject: Fwd: Mr. Warren Buffett from America USA
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e36 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [koamididiera[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

My name is Warren Buffett, an American businessman and investor I have
something important to discuss with you.

Mr. Warren Buffett
warren001buffett@gmail.com
Chief Executive Officer: Berkshire Hathaway
aphy/Warren-Edward-Buffett
