Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDE01A4AF2
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 22:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgDJUPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 16:15:33 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:36508 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgDJUPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 16:15:33 -0400
Received: by mail-pf1-f171.google.com with SMTP id n10so1481218pff.3
        for <kvm@vger.kernel.org>; Fri, 10 Apr 2020 13:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f86muAw523OkMjYVGNBFovEm8ZGJUiBw+jgMVnhWcLU=;
        b=ZmtX0gYpXUxLadTK5ZaoZ8oFL8gDIFXNh8zscyM0r63jYevMqmK9ixQsH+ghklSqTH
         6XvhElypZck2XS58SazFsyxW5rqE4K/YAMHeJis/lIjRW4EGo5TDRiJ5I1HmQR+F65VH
         2xPK5hWh0VcRmXLiTxkuDEHk1nJTnqeInorLkCRTULntcPmhJcgoNEvAgZhwgpq33vkk
         hhX3DNPpGpX9VYA7OTvZNQ5BF73BMvl/6TyQARpnXZGdY0odYWcnG/w37pLOFuyx6z/m
         H0h/5hX4j1woSslXpI1d9ZYbqOFML50nZhrkBhqn+X2HLSuKIW50e3y+qB2lYhDcIw3o
         Y84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f86muAw523OkMjYVGNBFovEm8ZGJUiBw+jgMVnhWcLU=;
        b=tflSG0Li2QQDGYUIL/vf10VE64lNQSIqBAEg48yN5vAGdtayBwsffnRuYHFkoluu/F
         wxcOFB0IvW+wUEi7oJERTU7Vdwv6gIlwD8+jRr8xoTd/sbH1RKjdY3Mj+zgzg66Z+kjf
         tdU8ibVYipdmlwhau0P0NLwwGLtuBnNig5JFxH8+xwg+ph4a4n6jA0JLHTNrgKzDFufl
         89rKvd+zrZfLHR32e2x2MR3140Hz91Ai6/i2iRklnt2htrOVM5db9L+bd5ulSUdCCiGB
         cyWRkWXW/Ealf3Df56wVOaL21yG+KH4udBj+Wm1L3O0QQGxwZl2Jf2MLy64Cm9bNJZ8J
         wOow==
X-Gm-Message-State: AGi0Pub39EbcO986Tba4nODlOutuwNCYogu6GzAUymOLFPrqYcOceSiP
        13mOo50jWKg4GU57MN9AJgafhzD2gxsuYyq045J22Nn7GxQ=
X-Google-Smtp-Source: APiQypKWaC1TdYHchEl8FbsLPt1cgpKj+D5CVgAogHXMqDZKWBUHBcSDz+0rduEyiWoCFleHipDpDU9DXL0lsgdfAJw=
X-Received: by 2002:a63:ae04:: with SMTP id q4mr5900955pgf.373.1586549731699;
 Fri, 10 Apr 2020 13:15:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
 <548a7864dce9aaf132f90fbb67bd3f52@kernel.org>
In-Reply-To: <548a7864dce9aaf132f90fbb67bd3f52@kernel.org>
From:   Javier Romero <xavinux@gmail.com>
Date:   Fri, 10 Apr 2020 17:15:20 -0300
Message-ID: <CAEX+82LpZRVb2nnxyYBxgo3N6ZcwX_9dTU1RnZ_aPW7PRuB8vA@mail.gmail.com>
Subject: Re: Contribution to KVM.
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

Thank you very much for your answer.

Have decided to start contributing with testing on Intel platform,
have a Pixelbook with a Core i7 and 16 GB of RAM and will use Avocado
to have a local automated test-suite environment.

Regards,


Javier Romero

El vie., 10 abr. 2020 a las 4:49, Marc Zyngier (<maz@kernel.org>) escribi=
=C3=B3:
>
> Hi Javier,
>
> On 2020-04-09 22:29, Javier Romero wrote:
> > Hello,
> >
> >  My name is Javier, live in Argentina and work as a cloud engineer.
> >
> > Have been working with Linux servers for the ast 10 years in an
> > Internet Service Provider and I'm interested in contributing to KVM
> > maybe with testing as a start point.
> >
> > If it can be useful to test KVM on ARM, I have a Raspberry PI 3 at
> > disposal.
>
> Testing is great (although the RPi-3 isn't the most interesting platform
> due
> to its many hardware limitations). If you are familiar with the ARM
> architecture,
> helping with patch review is also much appreciated.
>
> Thanks,
>
>          M.
> --
> Jazz is not dead. It just smells funny...
