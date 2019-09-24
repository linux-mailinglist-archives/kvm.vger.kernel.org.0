Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D65B9BC98E
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 15:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405520AbfIXN5Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 09:57:24 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36634 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729481AbfIXN5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 09:57:23 -0400
Received: by mail-oi1-f195.google.com with SMTP id k20so1708041oih.3
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 06:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vMmaji/RGvedZuk2RaAUa4vZZdlLr5fEGxEDI7CiFeE=;
        b=kqMZ+WtnkhbtzhvlhjXwwscfrRXT/w8p9CzN4cOMWKvu1omYxEUFGnwiU2zpMvcNof
         tqo8b9ZzusPkgOr4vPlOqEkOQCTGKUba1YjVfU41HNOdBPwflhfYjr2VCRGqg+D64tyt
         AVFqe3KQSLm/1rwq2Rit7zFsTuLfv8fOu8dHtGfBhE9z9iESI2eZZEEGfQ+A6TKZANzI
         5AFhZRTPxDmjaeN805mMEAVeqJ5iypxiHSzKzjMELgH6A7Egkj4/hTN3Fs8iQsOvXu0L
         5jEClyQpsguDnbqx3AXYQvG619RZmgUemA/a3EFpxBsqYkoGS/CsuBY7HrmjkZnWPwFw
         0weQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vMmaji/RGvedZuk2RaAUa4vZZdlLr5fEGxEDI7CiFeE=;
        b=IN78RQrE80uzVMYK3QzNra835fQxQ31UvbUYhkBHlbRBKrumIZ7zqIjvEZPdB6UIMk
         pbEathtFOi4iFw2rqwXCxd7mQTbSawhIwu11kPpXfH97vOpnZNRO78vXOHOXKsSVPc0i
         foAWue5ivmfPoa4LB+iOkvst99zTM+z8y1rxaDhSqH22CxNYhoDKELXlGMUyFBmG37/t
         41LGzKUKw4JjDH7pAJuu1CQqVzU4DNuxwKhXrlrx3yr6HPUiE5VUFx5xxt/OeGnrWs3v
         RDrb24PpKVB818P3rzRCHIO5/Dc3S6G8n18W2Sa/dbnjZYrlf3r9dzVG84UeEizFW9C8
         BrBg==
X-Gm-Message-State: APjAAAXrRdRprd/NRTwskV8xDNNUj4CTm0cSupsAKc7w28Q62PgU4l0w
        rvALggSizXtnuja/8aFwqU+JW5DHnCEFLvhUyTByTk2HIbc=
X-Google-Smtp-Source: APXvYqyk8uNERiTw5KlM/VZ2fU3MnQFHMG461Tkz+7/aVpoyCEKM5OREzdXY+E0Rc3W0AF6AZuwb9lcv6b1BpPLazyg=
X-Received: by 2002:aca:f54d:: with SMTP id t74mr151470oih.170.1569333442752;
 Tue, 24 Sep 2019 06:57:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190924124433.96810-1-slp@redhat.com>
In-Reply-To: <20190924124433.96810-1-slp@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 24 Sep 2019 14:57:11 +0100
Message-ID: <CAFEAcA_2-achqUpTk1fDGWXcWPvTTLPvEtL+owNSWuZ5L3p=XA@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] Introduce the microvm machine type
To:     Sergio Lopez <slp@redhat.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Sep 2019 at 14:25, Sergio Lopez <slp@redhat.com> wrote:
>
> Microvm is a machine type inspired by both NEMU and Firecracker, and
> constructed after the machine model implemented by the latter.
>
> It's main purpose is providing users a minimalist machine type free
> from the burden of legacy compatibility, serving as a stepping stone
> for future projects aiming at improving boot times, reducing the
> attack surface and slimming down QEMU's footprint.


>  docs/microvm.txt                 |  78 +++

I'm not sure how close to acceptance this patchset is at the
moment, so not necessarily something you need to do now,
but could new documentation in docs/ be in rst format, not
plain text, please? (Ideally also they should be in the right
manual subdirectory, but documentation of system emulation
machines at the moment is still in texinfo format, so we
don't have a subdir for it yet.)

thanks
-- PMM
