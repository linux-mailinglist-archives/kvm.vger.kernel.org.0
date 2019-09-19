Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4086B867E
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 00:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406374AbfISWQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 18:16:51 -0400
Received: from mail-vk1-f195.google.com ([209.85.221.195]:43611 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403766AbfISWQu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 18:16:50 -0400
Received: by mail-vk1-f195.google.com with SMTP id p189so1174586vkf.10
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 15:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pOY7qTJC8x+roFNLZtag4EqxhRKX5WUTWhzkAKmmWx0=;
        b=nDOHhBt/NWsMcKSRBXQDL9GHtGvO6AyHB8/owKwcwzc972sg0PYNLH3yGRi1VWCl8v
         6RVhit00FDIIe/NeMt7APG3xuXZjvubSDMWpFFik5yoMmUBHYNsY1z4YgMhRJsW8BFiL
         PH9nGdfWOtzFAJZ3xiBTcuaO3riqS3KxhZJjFgHdgwgFM3vsAXlSSKcBBsXtpVt3wNz0
         orG0PKgBZ/rEJE1acTVZNjLP3fAf9P8+08+If7BDRi8wAvAFVKR4si64QEPsHYRpqh3j
         OSuWM4Sv0WCPKZJq85z2KAFTkjdF1XZtZB9OFn028f3wVZxdpJ1TCta4I+UvbdcI7O69
         fGxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pOY7qTJC8x+roFNLZtag4EqxhRKX5WUTWhzkAKmmWx0=;
        b=K2H3bpHHJ4NWJcK0ejRgc42U1GG9i3KLi4o4XJZm2a4EF4kwrz15CsbjWzQhLSBf5j
         RNDLwFIBbcJ7HzTjW0ZcLuH54KJrc2zjBsSTHSkcmh9O19yOlm7UN5g8BPSNtJmb3TRo
         u99wjfMPmM37htKaSCgwyUbXw65vAFGD5k6esnCbicDaPw8eFT3ihhmz0uopG5lsbxCr
         fxp7LSPsrGlKC0ueXK4qUTN8KRrMgMDWwLEROc5jhP4DGLgVTYE2meqHOyV5U6aLmXGu
         G1yrDqHafLe0QzBbbRZTTG008hmXq45CijXLAVUq6xSer9YQlSPwHYXQOHCwga5f7TUk
         b8ew==
X-Gm-Message-State: APjAAAVgYRmZ6AyncqZ7lGAqiTAkfDMacnat85vWsMSmVZSW47Wt/r6n
        8GOBK7fhCgjObgiKxiVoolemgts/mhXD4+dMqh5w8OxxSgbC
X-Google-Smtp-Source: APXvYqzJZXXJBMZqk4CiSuN1nGZNFkppKHLmOHvNINvLNkN9kA4l0igVJzkgZQErfAAo0LOfNbChA8DyK5dsvd3B3Ak=
X-Received: by 2002:a1f:5243:: with SMTP id g64mr5986366vkb.26.1568931408204;
 Thu, 19 Sep 2019 15:16:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190919203919.GF30495@linux.intel.com> <20190919221453.130213-1-morbo@google.com>
In-Reply-To: <20190919221453.130213-1-morbo@google.com>
From:   Bill Wendling <morbo@google.com>
Date:   Thu, 19 Sep 2019 15:16:37 -0700
Message-ID: <CAGG=3QXUcY19jxKkBB00sxAHx78=h7ckoXqWdsX4q+RPJuHz7Q@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 1/1] x86: setjmp: check expected value of
 "i" to give better feedback
To:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Orr <marcorr@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+ Paolo Bonzini, Radim Kr=C4=8Dm=C3=A1=C5=99, Marc Orr

On Thu, Sep 19, 2019 at 3:15 PM Bill Wendling <morbo@google.com> wrote:
>
> Use a list of expected values instead of printing out numbers, which
> aren't very meaningful. This prints only if the expected and actual
> values differ.
>
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  x86/setjmp.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
>
> diff --git a/x86/setjmp.c b/x86/setjmp.c
> index 976a632..1874944 100644
> --- a/x86/setjmp.c
> +++ b/x86/setjmp.c
> @@ -1,19 +1,26 @@
>  #include "libcflat.h"
>  #include "setjmp.h"
>
> +static const int expected[] =3D {
> +       0, 1, 2, 3, 4, 5, 6, 7, 8, 9
> +};
> +
> +#define NUM_LONGJMPS ARRAY_SIZE(expected)
> +
>  int main(void)
>  {
> -    volatile int i;
> +    volatile int index =3D 0;
>      jmp_buf j;
> +    int i;
>
> -    if (setjmp(j) =3D=3D 0) {
> -           i =3D 0;
> -    }
> -    printf("%d\n", i);
> -    if (++i < 10) {
> -           longjmp(j, 1);
> +    i =3D setjmp(j);
> +    if (expected[index] !=3D i) {
> +           printf("FAIL: actual %d / expected %d\n", i, expected[index])=
;
> +           return -1;
>      }
> +    index++;
> +    if (i + 1 < NUM_LONGJMPS)
> +           longjmp(j, i + 1);
>
> -    printf("done\n");
>      return 0;
>  }
> --
> 2.23.0.351.gc4317032e6-goog
>
