Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18E41DF62B
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 11:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387685AbgEWJBi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 05:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387498AbgEWJBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 05:01:38 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEBFC061A0E;
        Sat, 23 May 2020 02:01:37 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id w7so12521431wre.13;
        Sat, 23 May 2020 02:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pZ01GP0+F+OmC5W2+OwHLapIsiwAnLhZHgV74f6Iy3Y=;
        b=Iau7D+7L//jXW5msJ2ETmLaPxSIds1SSBU7UiBfeKBoTGVEp5b2Ar9E/aU2AfP5s2d
         yPdUuCtBUUB9Nl9Jnedkk6nWBKMYUZ8Vjo3RnuhWLy2x2+zyF8O9zMYK63MyPLY+npBz
         oO9dkcZCTs1wjMACCUNvBYgWfH2AdBVq0Uz7vvdr1vAGofentbFZN59+dSmnCck3DoAh
         brz5pERvlEP7CkIhbrCGOzWFawNcTQ6bC164G1nlPOcUjiHEGLsdHjL4J/t/q3G+h4Kc
         Ov3Bv8bunM0n/K0jqpeTGiHJk9a+Nw1UhD1S8TErf+TY5zlB/1m/3LcMlj2siN7tvt68
         9g1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pZ01GP0+F+OmC5W2+OwHLapIsiwAnLhZHgV74f6Iy3Y=;
        b=ZNsN7PmoNj1mDf89Gm0Bp7lsF5V/EMNqZ8OmCXu8JUdQWZauKfK2wogJ06pe66lg1R
         ruR8YW1kTlkErMDbF1tZD0LUxyv82TulXaqd8Q0Qra3KaTcZ2wQFwQ59AXzWZ7qrqXJI
         L/QjhdCCkAtCZwg+eNzgRdzU/3uVwqrTbpomqpRG/+KqbJrnOQW+BqAgdNOieXvRY+v4
         dUvaV7ZtGn1pyc7HxHG62crgP5pLlhFkIwjQansqdp33AFZBVUGG3tNPl31cvUG7pjdF
         XpOAEeM5EDusPT3ipqt64qGmsDmRN/fv2iTAzJSwNpMeYLfLkzwe92uojlQeh6Uw8zmv
         uvGA==
X-Gm-Message-State: AOAM532InU/zh/KAmyCEGuCpSfJSZhOwFfhNcrV6YVhgz5LWA6FhK1Yt
        M6mSnJwDVTCkj76s+5ILAK2Gexh4FSZMbEtjcnc=
X-Google-Smtp-Source: ABdhPJxVb1XnQg6jIQ33hanw9Cn3QzSWkEW8wZjziVpHL0zPpdM6SMpB1sZ4u840eJGKUZQ8wu4ZWUGX37n3Jk1YZkQ=
X-Received: by 2002:a5d:4385:: with SMTP id i5mr259462wrq.420.1590224496535;
 Sat, 23 May 2020 02:01:36 -0700 (PDT)
MIME-Version: 1.0
References: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
In-Reply-To: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Sat, 23 May 2020 11:01:12 +0200
Message-ID: <CAHiYmc6DZ5Fpwc6YS1xFHc3Vrvc3LiSyboSD7+Gw3+phQxZteQ@mail.gmail.com>
Subject: Re: [PATCH V7 00/15] KVM: MIPS: Add Loongson-3 support (Host Side)
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> V6 -> V7:
> 1, Rebase on latest mips-next (Config6 feature bits definition updated).
>

Hi, Paolo, Huacai

I am not entirely familiar with KVM/kernel workflow, but my strong
impression is that Huacai should provide Paolo with the series that
apply problemless to linux master (including all possible patches that
should precede the series, like the mentioned Jiaxun=s patch), not to
mips-next.

Paolo could probably deal with the current situation by applying
separately Jiaxun;s patch from mips-next, but it seems to me that this
is not the optimal approach for the future, and that it complicates
the workflow - Huacai (or any other person involved in KVM/MIPS
development for that matter) should base his KVM patches on linux
master.

Am I right, or am I wrong?

Yours,
Aleksandar
