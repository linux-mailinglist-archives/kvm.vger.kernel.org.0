Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCAB170855
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 20:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgBZTCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 14:02:55 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46086 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgBZTCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 14:02:55 -0500
Received: by mail-lj1-f193.google.com with SMTP id w19so259092lje.13
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 11:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bHtZxZaC48SsJFUrs9U7pLaBkirBkP0iDzq9XDiKcWo=;
        b=bhnfEwsct5WR6Frm2Qh1DHWNrddM68uaH/808Vy7E1P12zbEt/ZtKh9oMB7XYCtfP1
         fVJkVcpgaTO9WFc5sIT9uPsTmgKJe2FVXidSat7OWyu2fHthTrZQECzJA9gd8jqboSId
         /+BVyRfto+ybIylQoVOUbsda7B+Af/psj2jEuRDsabJn7rUy+IeRkbKI/63A21jmgBt3
         4B1Du0H5r1rEaPA85Q9BCIwwJS4QvgrSSAr6VFB7xoipd9jTgJSOQ+iu0g+5YEU2dynX
         dLCUmZ2bYJnqhhkOsylMZJwtwZEWixWMWRlpf+UTABBzK1zB3DF2TfLhw/sCGY1FXyhS
         ZGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bHtZxZaC48SsJFUrs9U7pLaBkirBkP0iDzq9XDiKcWo=;
        b=be/FoWn0/PIUBVGdhWTHQ4uNunOzgC9VLH6UZxSL4PkkCFiR+Tly6sA6NQ4NOHCKkU
         Jum632ueErV1EkNAGqI93zdAR9lSzRXyuEav8mG/3g0DmsOFEMcdlp0LyWy5pb4lcf6z
         md3lspDzaGnGTaRSuTZZbEIxKI79+sLlF/ZKgJtx2A7vL5UIvlqsxeGqFlpW5Xniv7Wd
         ttiGlsXbGo5KLcu0KGsoW01kbm5nz1e10Xq03fEgdbZkq/QLKqfyGwS+dr6/GmCPjUGL
         3+iXRnZELlmckiE9zZTcwJP1Uir0QLRJnqpvzaRguvFP7LmAE7FH9+HWgKhCfw5ojIZZ
         N6RA==
X-Gm-Message-State: ANhLgQ1+TkBYNSbVbO1gZKmTLSIpZMrECg8rt8264MsltHCUuiEykhgQ
        kC9QIdqWrB2xBhf8QlEdEpSAxYhoUrsasxtCywbvkkKI
X-Google-Smtp-Source: ADFU+vsP2TiC8pdmByXe+/F7WPwKzGn+5oPnUeHYag/kD8SGcPNbqB0dmqt3/BUhCsjc/YZJUgvfE6O9mHIJxDGb568=
X-Received: by 2002:a2e:8711:: with SMTP id m17mr252282lji.284.1582743772653;
 Wed, 26 Feb 2020 11:02:52 -0800 (PST)
MIME-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226094433.210968-1-morbo@google.com>
In-Reply-To: <20200226094433.210968-1-morbo@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 26 Feb 2020 11:02:41 -0800
Message-ID: <CAOQ_QsgSP9JmO8m+r+C9JU0fiFfVbgUnXvarLsBFSrWbG6Fz5w@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/7] Fixes for clang builds
To:     Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, drjones@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bill,

On Wed, Feb 26, 2020 at 1:44 AM Bill Wendling <morbo@google.com> wrote:
>
> Changes to "pci: cast masks to uint32_t for unsigned long values" to
> cast the masks instead of changing the values in the header.
>
> Bill Wendling (2):
>   x86: emulator: use "SSE2" for the target
>   pci: cast masks to uint32_t for unsigned long values
>
> Eric Hankland (2):
>   x86: pmu: Test WRMSR on a running counter
>   x86: pmu: Test perfctr overflow after WRMSR on a running counter
>
> Oliver Upton (1):
>   x86: VMX: Add tests for monitor trap flag
>
> Paolo Bonzini (2):
>   x86: provide enabled and disabled variation of the PCID test
>   vmx: tweak XFAILS for #DB test
>

These patches have already been pushed. Was there any reason to squash
your v1 patches into the commits that introduced the clang issues?
Otherwise, I'd strongly suggest re-posting the v1 series with just the
clang fixes.

Thanks!

--
Best,
Oliver
