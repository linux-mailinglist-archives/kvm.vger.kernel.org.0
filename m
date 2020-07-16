Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2718A2219CD
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 04:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgGPCUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 22:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgGPCUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 22:20:08 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BF6C061755;
        Wed, 15 Jul 2020 19:20:08 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id c16so4416029ioi.9;
        Wed, 15 Jul 2020 19:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=K/9/0SgT5wZwj9R1sUpghAh7g+m3fTsSEDjugLqxv8g=;
        b=AmaTntOhlM4JMpice0Mu6RueTbKa9PX+0i/1Y0wXYX3sQf4/ejGiVFod6jfAFwtznn
         114JAsWVBWEtd+7RHxF3gPeFFdZB+nUp1nq6pV45Ie6uGGTO7u9oPh/zstwy86v5HSgz
         FuzwLvhkYIMUn5Y/ruAar309gX3p1x+Iqk9TfRXNxT5d5vHTFy9vZp8ieyiimbWwgzdV
         RusncxjDRivjZF/2CVhAL5tJzyDKz3F87J+H8HpdJSDVtsgAbIEUYGOdEGSbdIYR7zI+
         6ncZtYnLw6o/4T5VJ7x75Wc9VIfYrTjneocgunyBQjeq4aFi5RG0gELTTHGkQJPsbkYN
         7DgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K/9/0SgT5wZwj9R1sUpghAh7g+m3fTsSEDjugLqxv8g=;
        b=oN2rzsxp2sVSw1gpc4FOd60sGodb3FsSc4rmXx4iOTdMdA94Q5wAKeQpx8N0QYvvAe
         PNt0RHFQtTkqng/zy3Np6B8nGM5Uw/VBaMr25akHyPph4JxNI15H42Tzi39+hx3A1ecm
         5AxN6A3DIYeOshwuFDhLCokdnKzM4f9XAeteO7O/aoW79DwacPBt21kzAVTW24kD5Ccn
         pseH7S1O3lGo+yoI6JA/aZWeBekJxEYe4uZOdqZG7R1RdgpA4AGQN4DEjhfhB2GvS3M+
         eB/UbhymNiAOMAsrXCGClGrj2O5Ju5mZAGUij4HjMYldDxaF4Ry5R4h11+skBdKlcXw/
         YrGA==
X-Gm-Message-State: AOAM532Zx1wlqeW+2hQZJAMojIEabD0SJaQ1x8cIHfh7jG+qHH3r/0G0
        MVazBrX6b50YG93yl73gRnSAbU0xNrCl0tKaIFs/8HGlNno=
X-Google-Smtp-Source: ABdhPJxd2FP6wrXSARjYJQs4NkI4C6Vi3SJiTATKbF/80/JnJaXB2T4OQeYu/4X4ob+oS3tvJy/DqPj0y8+T9cs7JMQ=
X-Received: by 2002:a05:6602:1685:: with SMTP id s5mr2237314iow.84.1594866008138;
 Wed, 15 Jul 2020 19:20:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200623131418.31473-1-tianjia.zhang@linux.alibaba.com>
 <20200623131418.31473-6-tianjia.zhang@linux.alibaba.com> <e447bb5c-8b83-dfb1-a293-f2e9e586c2ec@flygoat.com>
In-Reply-To: <e447bb5c-8b83-dfb1-a293-f2e9e586c2ec@flygoat.com>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Thu, 16 Jul 2020 10:19:56 +0800
Message-ID: <CAAhV-H53JLTtyi=3vvSw3xxR12YiJq-5SKRXZzVcFLt=r2iXgQ@mail.gmail.com>
Subject: Re: [PATCH v6 5/5] KVM: MIPS: clean up redundant kvm_run parameters
 in assembly
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, all,

On Thu, Jul 16, 2020 at 10:10 AM Jiaxun Yang <jiaxun.yang@flygoat.com> wrot=
e:
>
>
>
> =E5=9C=A8 2020/6/23 21:14, Tianjia Zhang =E5=86=99=E9=81=93:
> > In the current kvm version, 'kvm_run' has been included in the 'kvm_vcp=
u'
> > structure. For historical reasons, many kvm-related function parameters
> > retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time. This
> > patch does a unified cleanup of these remaining redundant parameters.
> >
> > Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> > Reviewed-by: Huacai Chen <chenhc@lemote.com>
>
> Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
>
> Can confirm it works on Loongson-3A4000.
I'm sorry for the late response, and thank Jiaxun for his tests.

Huacai
>
> Thanks!
>
> > ---
>
> --
> - Jiaxun
