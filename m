Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2281A4216
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 06:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgDJEnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 00:43:47 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34196 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgDJEnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 00:43:47 -0400
Received: by mail-pf1-f194.google.com with SMTP id v23so598793pfm.1
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 21:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rRpbgDANI8vDrTtjTJENSHjACfupvu/DpiY4PQxKbDI=;
        b=nIpqgyHbvMAMKy2VqyXmbM4uLzHVz6C/g9PZ9c1m/tpwLKwNlJb3ega6O39WQRQdK9
         pAWpux6ra2ePXgTVk9g67BthOpd9jgnA8+9mrG/lMIq1KkFEtM5uNeMnZlGDj/WWWP1m
         g1IvF9u5qL1fFaZokOOB/RFk92NAH64nxg906PqfXBPBjv5W+3OMZMhoDEZ1ScHCE0Ah
         NS+lH2lXeSLvQKjNjPgLUwrFW0iwIXGkvaLhYtXOLm1vYjaGGW1R/ZSbtVuXQZtjDaWx
         e1E9byWCc8FIyQ4SIcouIS0Sr/6WA/aC3oMRo5Sd9ObBa5vSDyQ4vgr8A41xf7n+tPOO
         IRGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rRpbgDANI8vDrTtjTJENSHjACfupvu/DpiY4PQxKbDI=;
        b=bDff5Sb5dmgWYLzoUWN0Fy5GXrkEmORzDmGChUA5CyEydA8AenTef7aEApxBYItiWa
         9ZS9Re9itjou7XY+hAcGA/uZ2jZYBq1aRhivOSB8+jQjw6iErcTNZNZ/cO1lXKkGVaIW
         ov0MU0rudVTyDVPj2WxoBMFJLnOqsML7mqQAi2MEdxHF+wc4G+VqhuzUri+41AGsqW4C
         XtMzFv89bcAlOv8h0xzxMz9IOnuaod0Uukn8wLPhW2kWtBiJsZl19S7F3S01f5OBRqIh
         GT3waLDFSZca+Tanz+jM2PmLGeFhynz/mYuaGY+Un435cvwINRrWp6edvgQ4TkE/9IZ0
         /kOA==
X-Gm-Message-State: AGi0PubBrtKL+W6yOBYyuHszycaFAjNeDhJaSnp+TRojwYgm7Yg5fwDf
        ParO/KQaYxcLnTt9qmQk87b9rLwIIoCPZWKlI0Q=
X-Google-Smtp-Source: APiQypKnPTbJEfArWAgzMfDQYIpR0U8LgpeRAwObfBfYM1F9/inERKEjnh80fZP3e7G857uo1syih/ToxJUnuVb7UVs=
X-Received: by 2002:a62:648f:: with SMTP id y137mr3358952pfb.199.1586493826879;
 Thu, 09 Apr 2020 21:43:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
 <c86002a6-d613-c0be-a672-cca8e9c83e1c@intel.com>
In-Reply-To: <c86002a6-d613-c0be-a672-cca8e9c83e1c@intel.com>
From:   Javier Romero <xavinux@gmail.com>
Date:   Fri, 10 Apr 2020 01:43:35 -0300
Message-ID: <CAEX+82J+xRA1B10ApcviZ04=ZZ+YNth83p428bHgOHmaV1iTuA@mail.gmail.com>
Subject: Re: Contribution to KVM.
To:     like.xu@intel.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Like Xu,

Thank you for your time to answer.

Of course I can also test KVM on an Intel Platform if this can be
useful, have a Pixelbook laptop with a Core i7 processor and 16 GB of
RAM at disposal :D

Thanks for your attention.

Regards,


Javier Romero


El vie., 10 abr. 2020 a las 0:34, Xu, Like (<like.xu@intel.com>) escribi=C3=
=B3:
>
> On 2020/4/10 5:29, Javier Romero wrote:
> > Hello,
> >
> >   My name is Javier, live in Argentina and work as a cloud engineer.
> >
> > Have been working with Linux servers for the last 10 years in an
> > Internet Service Provider and I'm interested in contributing to KVM
> Welcome, I'm a newbie as well.
> > maybe with testing as a start point.
> You may try the http://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
> and tools/testing/selftests/kvm in the kernel tree.
> >
> > If it can be useful to test KVM on ARM, I have a Raspberry PI 3 at disp=
osal.
> If you test KVM on Intel platforms, you will definitely get support from =
me :D.
>
> Thanks,
> Like Xu
> >
> > Thanks for your kind attention.
> >
> > Best Regards,
> >
> >
> >
> > Javier Romero
>
