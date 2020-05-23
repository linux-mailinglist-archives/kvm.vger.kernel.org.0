Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266921DF432
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 04:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387499AbgEWCfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 22:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387427AbgEWCfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 22:35:53 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DACC061A0E;
        Fri, 22 May 2020 19:35:53 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k18so13668907ion.0;
        Fri, 22 May 2020 19:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yoavjLz8ZYW0caPNIPk0tO3OFSaSDat3hbRdT6Td5HM=;
        b=Ap4dosat8YlOmGYij9ZKXf5Nqonojf6VBX3lrnX0Ww8+pqWIaqkpWZlC0WmDkG5Ogb
         Pm/HL885RZQ0/W5V+uhjV29qC51Mm+y0kAExfbTTHzeUvBvisaf73Cw8zttwxJ8RB68f
         OZGZXm236Oo5dUNFhxQPstQbfyonUsXIR2jJb9wR8m45pq10y4IEABrCMkOboBYRXWQA
         8e8ovPOyFnYRf01Hkjhw4fpYcQPaaySc5fURRKuphSbehkgR4JDqN261TskESaTAV6hi
         bFdTWEBw468NtDeg8QRnGXHv2IELhhN7nK9qt9bRs9DeAVzBYMlMtQkWTpH2W3YlCNCg
         Uv6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yoavjLz8ZYW0caPNIPk0tO3OFSaSDat3hbRdT6Td5HM=;
        b=JK/w+HcwoWXBTq6ENgnwHVNxZqnH0hHEIfuzXJcSDVoRulufbEvedpaLoGXrqcHrId
         Ouc8tFQ4u0UgR0EX6d2n6DL4tnMDXkWbomvhb4GfDadA51pzRmC4YDq5Y2L1yLqL+W8j
         hfl72oj2wCa9pMwxiyNUzewwkXDfzuWrBacW/i9fJG1p2I1UeB19jV7RH1acOclXkJ+l
         Y+4elr3Jd7ErKiilRIKGxW6N2b3ejxIJ02nz28TlWm2y2UsIowRoUvrId/sF/Xgg+Bgt
         JKClW4pxy/V1rGe7B46JB16nazvWxoYYqvhUcTn+YsveIlFueC6tof7LYHKLfYEIGyLO
         uzhQ==
X-Gm-Message-State: AOAM532UU10PY2dR8ZFPpKeUVWFnL1+aB5LSeMclUIKlpN6JgEPztlPK
        iwq7CZ9rtEbH+H81OupJpXkr+yNUjjFfeS3kVrU=
X-Google-Smtp-Source: ABdhPJy4qaSjmqfwmwYF7Vy+jL8m1bX2/bePJlWhT62ZlcN4Py3kfr4abz3p5wHNs1yfOsyaXQYnC5hYjw2MT6cQVGM=
X-Received: by 2002:a05:6602:13c6:: with SMTP id o6mr5439871iov.84.1590201352161;
 Fri, 22 May 2020 19:35:52 -0700 (PDT)
MIME-Version: 1.0
References: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
 <1589688372-3098-16-git-send-email-chenhc@lemote.com> <20200517082242.GA3939@alpha.franken.de>
 <CAHiYmc5m+UhWv__F_FKqhiTkJxgqErmFn5K_DAW2y5Pp6_4dyA@mail.gmail.com>
 <CAHiYmc4m7uxYU0coRGJS8ou=KyjC=DYs506NyXyw_-eKmPVJRQ@mail.gmail.com>
 <CAAhV-H4SspEUMLDTSZH3YmNbd+cRx3JK+mtsGo6cJ2NLKHPkKQ@mail.gmail.com>
 <CAHiYmc7ykeeF_w25785yiDjJf3AwOzfJybiS=LxfjYizn_2zEQ@mail.gmail.com>
 <23cbe8a9-21a9-93a3-79aa-8ab17818a585@redhat.com> <CAAhV-H6aGkxV41ymu+HPxiSBq9uw-QhmaxFxnZYJTfUay946cg@mail.gmail.com>
 <3269366b-7239-bb06-0bc6-cb661b9e5206@redhat.com> <36c31c9.f74c.1723c504640.Coremail.maobibo@loongson.cn>
In-Reply-To: <36c31c9.f74c.1723c504640.Coremail.maobibo@loongson.cn>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Sat, 23 May 2020 10:35:40 +0800
Message-ID: <CAAhV-H6-HxksTmM5S+wDknBCh-gF-duuwyY6tAg7ov7GSUteiQ@mail.gmail.com>
Subject: Re: Re: [PATCH V6 15/15] MAINTAINERS: Update KVM/MIPS maintainers
To:     =?UTF-8?B?5q+b56Kn5rOi?= <maobibo@loongson.cn>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Bibo,

On Fri, May 22, 2020 at 8:16 PM =E6=AF=9B=E7=A2=A7=E6=B3=A2 <maobibo@loongs=
on.cn> wrote:
>
> thank huacai for the efforts, kvm mips is coming back :)
I also need to thank you and Li Xing for your help.

Btw: As Xuerui and Jiaxun said, please fix your email client,
otherwise you are killing the maillist.

>
>
> &gt; -----=E5=8E=9F=E5=A7=8B=E9=82=AE=E4=BB=B6-----
> &gt; =E5=8F=91=E4=BB=B6=E4=BA=BA: "Paolo Bonzini" <pbonzini@redhat.com>
> &gt; =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2020-05-22 15:24:42 (=E6=98=9F=
=E6=9C=9F=E4=BA=94)
> &gt; =E6=94=B6=E4=BB=B6=E4=BA=BA: "Huacai Chen" <chenhuacai@gmail.com>
> &gt; =E6=8A=84=E9=80=81: "Aleksandar Markovic" <aleksandar.qemu.devel@gma=
il.com>, "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>, kvm <kvm@vger.k=
ernel.org>, "open list:MIPS" <linux-mips@vger.kernel.org>, "Fuxin Zhang" <z=
hangfx@lemote.com>, "Jiaxun Yang" <jiaxun.yang@flygoat.com>
> &gt; =E4=B8=BB=E9=A2=98: Re: [PATCH V6 15/15] MAINTAINERS: Update KVM/MIP=
S maintainers
> &gt;
> &gt; On 22/05/20 07:34, Huacai Chen wrote:
> &gt; &gt;&gt; I am going to queue them for 5.8.
> &gt; &gt; Thank you for your help. But this series depends on an early pa=
tch
> &gt; &gt; from Jiaxun Yang ("MIPS: Loongson64: Probe CPU features via CPU=
CFG")
> &gt; &gt; which seems only in MIPS tree now. So, maybe this series is bet=
ter be
> &gt; &gt; queued in Thomas's tree?
> &gt; &gt;
> &gt;
> &gt; That's not a problem, I can handle it during the merge window.  In t=
he
> &gt; future I'd ask for a topic branch or something like that.
> &gt;
> &gt; Thanks for bringing KVM/MIPS back to life. :)
> &gt;
> &gt; Paolo
> </jiaxun.yang@flygoat.com></zhangfx@lemote.com></linux-mips@vger.kernel.o=
rg></kvm@vger.kernel.org></tsbogend@alpha.franken.de></aleksandar.qemu.deve=
l@gmail.com></chenhuacai@gmail.com></pbonzini@redhat.com>
