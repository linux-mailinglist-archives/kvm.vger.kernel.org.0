Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A02E716F97F
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 09:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgBZIVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 03:21:18 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35357 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgBZIVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 03:21:18 -0500
Received: by mail-lj1-f194.google.com with SMTP id q8so2032610ljb.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 00:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jSjURLaS/+gejnaV+s6JMCa1M/guabksEUi/7ALpnvE=;
        b=UOcJxFFp6XLFIE5MHcfhDgv/vFvMF23rCmt9+sLcEpPNmkVpQ3hsPKy/Fte9625IFR
         NLIpemovHPyBvDJElisUPALlWlX+YmxbBBKB42eFQlNeTm9U/289/tMD46phura9JsWo
         uX7Ad96CSThE7GQaOPaRQL+tVqespvZjr3huv55gBs1lqnHfrf2KcyCs1yOx/RSLG2cU
         OUQN7esyUDMfvKhkcLOmEYyR9grbKv4M7oCqbQmCCJvlGIDMznUmYdF+c4wZb03EV3Uy
         OYHpPPh0bErhSen7QdNHrMElUw7UGVLObPAn+8KNdGaY/M1Mx9fp/kIcXdB7ASTpd+i2
         0/ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jSjURLaS/+gejnaV+s6JMCa1M/guabksEUi/7ALpnvE=;
        b=ozXmEmCCpxsD2RC0SulZvn72aADqmQpEoXmMczS1YyOutaf8VYVzF6Kw9zNiJEq8/x
         d0jjY3dGiZ7jSFfkfewhWXaylhjV9x6i0aQOtcoEuwjnYeBc970awNyATyQRZIdPgFGw
         b3j/f262YG10+DNXKbeMx3Bpn6w9ap3zoeYvpzhgAGRvv/RKD8sLncwIJVJIUfN7Z2W5
         gdG26Ry8q3Uo9SXtH4QjSZWO6mCY0s1MP3iOe2LOmnX1izfGmHNEZk5Hjatz+572E3CT
         8WQh05fdRfgpdqp9rj4HTCp0W2F52tq+h1/BbxpoPQzH/bKxnJ0QR2yxgJkC/8SHaKjk
         4mrQ==
X-Gm-Message-State: APjAAAWAhMBLF5PVBLxghJLNmAihmmVl3/txCbiTBbo4meAxKT4gG5fl
        PoEKHon8fsd46jgL3W2l7Q+jdp/YHpmCpi1I7NylTQ==
X-Google-Smtp-Source: ADFU+vsk1BNNSx9yqh8UC5hWzdH0bop3Esm4i6Q/pjplIbXnnO1LA5XSCX/nX+ahaiazONYDV04xLsgneqR7ipxM1HE=
X-Received: by 2002:a05:651c:555:: with SMTP id q21mr2138091ljp.241.1582705276568;
 Wed, 26 Feb 2020 00:21:16 -0800 (PST)
MIME-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226074427.169684-8-morbo@google.com>
In-Reply-To: <20200226074427.169684-8-morbo@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 26 Feb 2020 00:21:05 -0800
Message-ID: <CAOQ_Qsj-7KB46SR0++iJseOABW=R6WWi4Km-Q0gM5EnSiMMGjw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 7/7] x86: VMX: the "noclone" attribute is gcc-specific
To:     Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 25, 2020 at 11:45 PM <morbo@google.com> wrote:
>
> From: Bill Wendling <morbo@google.com>
>
> Don't use the "noclone" attribute for clang as it's not supported.
>
> Signed-off-by: Bill Wendling <morbo@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  x86/vmx_tests.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index ad8c002..ec88016 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -4976,7 +4976,10 @@ extern unsigned char test_mtf1;
>  extern unsigned char test_mtf2;
>  extern unsigned char test_mtf3;
>
> -__attribute__((noclone)) static void test_mtf_guest(void)
> +#ifndef __clang__
> +__attribute__((noclone))
> +#endif
> +static void test_mtf_guest(void)
>  {
>         asm ("vmcall;\n\t"
>              "out %al, $0x80;\n\t"
> --
> 2.25.0.265.gbab2e86ba0-goog
>
