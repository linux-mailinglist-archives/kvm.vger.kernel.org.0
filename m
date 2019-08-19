Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5344992483
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 15:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfHSNQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 09:16:56 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38709 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbfHSNQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 09:16:56 -0400
Received: by mail-pg1-f193.google.com with SMTP id e11so1217949pga.5
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 06:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G3QrTp7p7joYbJCkRsXIJddWfOp/eioksMTpigV+wkM=;
        b=M2vK+xZVjtXBYjUxUUk1iMNbxYwjUd+W6togCQiYPc7Vu+BGQx7l3hXcn4ECMLvDWt
         DlIAvUe8ekFSnxnofy3VvCNWLct8LZOpiNSM+v1WhYFyPJDwu5gZzaBjspAETr+32sje
         Xh1peTR5yYmEcUyhpwKV8rR/zI3wE7krkn5mWhAZXsBdSmKIExx6Aai/02AtaqBWuiMJ
         rwdLtwVmt2z/BiSdji1RT9OqjhuC+NoRsQcrlELRw7LuJbnkQsJhQDfS2T7BkdRszDtd
         SsGJHm5kXWMKbJ6caWbq9raXqyHYkwoMk/qLwvz6vTD2dWWbREUV34BsqN2ExAzlW+sj
         Ywjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G3QrTp7p7joYbJCkRsXIJddWfOp/eioksMTpigV+wkM=;
        b=GRuaiGH4t2h87+UzmeJQoCda1yBeSjcmPsGLR10Hwj/A9WSWedT82yO/iFr5ew9zb1
         n0vhhtJOuQqSaZkqDeg2vKMOk5GUV2zKurd9bNva9/+w/Azbu+OiszEQsmy9YL5i2xeQ
         yssjITy9jvakrHnRrMoDHfJKzeJLWG9Jx967FN4weqDMwZeiiO9uG1Z7Rc9nxUDL8Pf5
         If0oEmc8R2jYXa+8s0N/4OlHLfS1dbydoTAJYQbyA3ugfuBNlTCX+n+qVHI26g5twn6R
         l40v043jvRIa6pLc4qMAStUsI8Aiv2IeTWxlKW1ydRPj1AaYXqc2RFF5fsQjQKcwIObe
         zcEg==
X-Gm-Message-State: APjAAAVMFuMBf4Pl3PoB9a+/vp8EY+3SdTHNDjHYFbDOJFGVWLflRP/N
        2TPRj3R/wk1jPcdRkD+2SamVUWTQxSrOgftEzPcp3w==
X-Google-Smtp-Source: APXvYqyVpOFailHQYDN6SGrqGiLu77ISHhF0UzRLkKGS0q9bNLzKJCagc2Nkkti9u80AQyBrYjiyPqa9PxLeXB9+mf8=
X-Received: by 2002:aa7:9e0a:: with SMTP id y10mr23727599pfq.93.1566220614754;
 Mon, 19 Aug 2019 06:16:54 -0700 (PDT)
MIME-Version: 1.0
References: <00eb8ba84205c59cac01b1b47615116a461c302c.1566220355.git.andreyknvl@google.com>
In-Reply-To: <00eb8ba84205c59cac01b1b47615116a461c302c.1566220355.git.andreyknvl@google.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Mon, 19 Aug 2019 15:16:43 +0200
Message-ID: <CAAeHK+xBKrS0LZX+d3psaynznU4tQGfz4wQ9oFanxjjPv1ytVQ@mail.gmail.com>
Subject: Re: [PATCH ARM] selftests, arm64: fix uninitialized symbol in tags_test.c
To:     Will Deacon <will.deacon@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Christian Koenig <Christian.Koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Khalid Aziz <khalid.aziz@oracle.com>, enh <enh@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christoph Hellwig <hch@infradead.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Lee Smith <Lee.Smith@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Jacob Bramley <Jacob.Bramley@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        kvm@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 19, 2019 at 3:14 PM Andrey Konovalov <andreyknvl@google.com> wrote:
>
> Fix tagged_ptr not being initialized when TBI is not enabled.
>
> Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> ---
>  tools/testing/selftests/arm64/tags_test.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/arm64/tags_test.c b/tools/testing/selftests/arm64/tags_test.c
> index 22a1b266e373..5701163460ef 100644
> --- a/tools/testing/selftests/arm64/tags_test.c
> +++ b/tools/testing/selftests/arm64/tags_test.c
> @@ -14,15 +14,17 @@
>  int main(void)
>  {
>         static int tbi_enabled = 0;
> -       struct utsname *ptr, *tagged_ptr;
> +       unsigned long tag = 0;
> +       struct utsname *ptr;
>         int err;
>
>         if (prctl(PR_SET_TAGGED_ADDR_CTRL, PR_TAGGED_ADDR_ENABLE, 0, 0, 0) == 0)
>                 tbi_enabled = 1;
>         ptr = (struct utsname *)malloc(sizeof(*ptr));
>         if (tbi_enabled)
> -               tagged_ptr = (struct utsname *)SET_TAG(ptr, 0x42);
> -       err = uname(tagged_ptr);
> +               tag = 0x42;
> +       ptr = (struct utsname *)SET_TAG(ptr, tag);
> +       err = uname(ptr);
>         free(ptr);
>
>         return err;
> --
> 2.23.0.rc1.153.gdeed80330f-goog
>

Hi Will,

This is supposed to go on top of the TBI related patches that you have
added to the arm tree.

Thanks!
