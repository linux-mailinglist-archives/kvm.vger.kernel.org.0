Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B95668FF9
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 16:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389678AbfGOOSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 10:18:09 -0400
Received: from mail-ot1-f45.google.com ([209.85.210.45]:34960 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389291AbfGOOSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 10:18:09 -0400
Received: by mail-ot1-f45.google.com with SMTP id j19so17157464otq.2
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 07:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tLWQ9uN1hSLQn5cwzga0bawG7w0phykdKc+H8Eq7ClQ=;
        b=hJaSbIIHncdTxuDlGqZvrwmS3KOZO4+dO8qeCmVkCQJVmTXd1hJyOLZ4AkiiBxOreS
         eruUJTzcAz+CtDZllF8I2JZG+gsy4eYHMJ5hQO7c+rsBGmTW+QuP9f0gYiJWMfXGtdwx
         JiTfRVZR/YurlGSmYKGy9G23UiSXy4oVzRoJimM5p5H+hqTxoOSKHCJYTodri1ffj2jQ
         DcQxfjJxDWDjDs1SpNPThEYiFcm5apyJMTu0PQVDrdcfiBqcWG8dZJKgD1/j++wESxaz
         dJopXlyzRyYXcZKtpJPSZZcEIErvzvPlKjYEqwSrxZkNI59gfhxa9bg0107knaFWnTEx
         MFTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tLWQ9uN1hSLQn5cwzga0bawG7w0phykdKc+H8Eq7ClQ=;
        b=fheuJbbvSS857dchNg9G8ML/mSmonCYAZBajNmZmC3dgLrjbK8oEJ/7u+Ca+x3w7GE
         h4io/TzFVJKGfhv5A2qPGlrKJtEyIexQKcsonRcb2XC8UAZBD7VkkRMbxe22U36yHzrL
         Wg7U3sJ07kUGgHuoj1theT8idj+4gom7Nl9n2xI39P/T6eHmxOHomuxTPKcwGMqP17rT
         Y77BW8CHqwnXI2rJVmcHostYz7H/ULtjyFcF3FtWkYEV/2T1Kdsu0cBjhPBAWGm8cdkO
         hfTvLKOzjcU8hpJdhD9z9VxTy62/fx6QFERFMPGJrh5Bk6DgS/drFzCjGlpupRZSKT2l
         VNOQ==
X-Gm-Message-State: APjAAAUAc9m8ZWePt36kAc2kaxHnMC4KtFo3VDkbTgVInnsbPTLWL8qM
        Qm5Nqd9NRi0d6WNUeUidD6QkswT3uRKb6dl9qfepWg==
X-Google-Smtp-Source: APXvYqzWTHQAEim1DQq3KGPCl3sARZsaOEU15mjTM3NwYxhYPfWqCFD1g1Dm9FgbnWQXqvGTVOdY1D4YnwwSCCecvj4=
X-Received: by 2002:a05:6830:1653:: with SMTP id h19mr13034551otr.232.1563200288309;
 Mon, 15 Jul 2019 07:18:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190712143207.4214-1-quintela@redhat.com> <CAFEAcA-ydNS072OH7CyGNq2+sESgonW-8QSJdNYJq6zW-rYjUQ@mail.gmail.com>
 <CAFEAcA9ncjtGdc8CZOJBDBRtzEU8oL7YicVg5PtyiiO2O4z51w@mail.gmail.com> <20190715140441.GJ30298@redhat.com>
In-Reply-To: <20190715140441.GJ30298@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 15 Jul 2019 15:17:57 +0100
Message-ID: <CAFEAcA9kreC_VRddsC0WRuuCw2R3ohER0_+vaf_PeG43XPzYWw@mail.gmail.com>
Subject: Re: [Qemu-devel] [PULL 00/19] Migration patches
To:     =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc:     Juan Quintela <quintela@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Jul 2019 at 15:04, Daniel P. Berrang=C3=A9 <berrange@redhat.com>=
 wrote:
>     MultiFDInit_t msg =3D {0};
>
> should fix it.

A minor nit, but "=3D {}" is our standard struct-zero-initializer
so we should prefer that, I think. (I know it is not the C-spec
recommended version but some C compilers incorrectly warn about
"=3D {0}" whereas no compiler we care about warns about the
gnu-extension "=3D {}".)

thanks
-- PMM
