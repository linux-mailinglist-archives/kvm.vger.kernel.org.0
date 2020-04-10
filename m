Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 407F41A421B
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 06:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgDJEtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 00:49:24 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35786 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgDJEtY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 00:49:24 -0400
Received: by mail-pg1-f194.google.com with SMTP id k5so536329pga.2
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 21:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mgQP5fmEp3MLJlgjlz6jaeSibt5vSyFPfuJ0XoZcVIE=;
        b=YTCccdodR7/n1FEyARWl3Q04RpXd2xuQdfe6IsTM12uKGt3usSyb2eI5D/mUXyhg+C
         xuGZYqPVKMhumQ92IfZVyl92N4kyqYQfGA3a91Wg3UaISaKEKqMCoZeKJjDY9wRafAE6
         PkbaMayND2HOLKolooArZg6Mq2xIo0mfnSbXvwYLzgzPN9IiFqgjfjT8foeD2QzjbX5Y
         v2lrgetZH/0qCp+TuiaFSKpAowRrruA7Te0oBpmMf1XmmJsLb9m98HA+h5hnguqYbzgR
         xCI0zpEBq2WE4tNV8g/dhJpyIFjCOeENUnGHlWUuXCRLYK3FxdG7SaPXHQg+C4swiXuU
         Muqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mgQP5fmEp3MLJlgjlz6jaeSibt5vSyFPfuJ0XoZcVIE=;
        b=WZ8nQ7u9iaocUnsPHAUBYtYPtZX7EEKQqXmKvxk+loVvtoEtSlpM5Ed36O1n+VeNnA
         8JYdIhuK2CUmgcfFLiXQH2Z8yun8MXhyVoOe/AU68CQxR3YQQrX1TM0qj1HInxwfG3kO
         chHI5lFQW9NQ1hhEML5ngpM7LaNoVRXRQjpDv421LRIsEX6ZCnJ5EhBiBHzx+w1SZ6NR
         QdWm+hS3K9jSMowQvgi5KkHN4+7c3CxIvw1XwJYvsBru7wx1Rn18j/QWVPFMCy/buU/f
         aLrx8A0LCaM79bHmGE09I6mEGH7EHzHL2leX97VvQTVdtYARiLyOmb1vkdGJsQrJL5Dh
         sYTw==
X-Gm-Message-State: AGi0Pubkc7/jzgGT6j3IEBdByRnHhDJdazY0nBxm9mXkRASuSh2eNRrh
        bNGZVzWuA/gfxaxTpOx9XNMLfgrw0l5egUrybQg=
X-Google-Smtp-Source: APiQypLgdOSROqVPX4hxkv96w6ogMSeFmpGa0LlYofDEikdwsEdgCSZlL+LUYeyIdfrENnWxg8/peU7nWNBv4uzIIm0=
X-Received: by 2002:a63:8e44:: with SMTP id k65mr2728717pge.452.1586494161789;
 Thu, 09 Apr 2020 21:49:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
 <c86002a6-d613-c0be-a672-cca8e9c83e1c@intel.com> <2E118FCA-7AB1-480F-8F49-3EFD77CC2992@gmail.com>
In-Reply-To: <2E118FCA-7AB1-480F-8F49-3EFD77CC2992@gmail.com>
From:   Javier Romero <xavinux@gmail.com>
Date:   Fri, 10 Apr 2020 01:49:10 -0300
Message-ID: <CAEX+82L-Kc6W1KOgPGo3JTxvjnOGsjDWm0Z3-c59EDdL4jO+Yw@mail.gmail.com>
Subject: Re: Contribution to KVM.
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        Liran Alon <liran.alon@oracle.com>, like.xu@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nadav,

Thank you for your answer,

Will also take a look at the test bug you suggested.

Regards,


Javier Romero



El vie., 10 abr. 2020 a las 0:53, Nadav Amit (<nadav.amit@gmail.com>) escri=
bi=C3=B3:
>
> > On Apr 9, 2020, at 8:34 PM, Xu, Like <like.xu@intel.com> wrote:
> >
> > On 2020/4/10 5:29, Javier Romero wrote:
> >> Hello,
> >>
> >>  My name is Javier, live in Argentina and work as a cloud engineer.
> >>
> >> Have been working with Linux servers for the last 10 years in an
> >> Internet Service Provider and I'm interested in contributing to KVM
> > Welcome, I'm a newbie as well.
> >> maybe with testing as a start point.
> > You may try the http://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.g=
it
> > and tools/testing/selftests/kvm in the kernel tree.
> >> If it can be useful to test KVM on ARM, I have a Raspberry PI 3 at dis=
posal.
> > If you test KVM on Intel platforms, you will definitely get support fro=
m me :D.
>
> If you are looking for something specific, here are two issues with
> relatively limited scope, which AFAIK were not resolved:
>
> 1. Shadow VMCS bug, which is also a test bug [1]. You can start by fixing
>    the test and then fix KVM.
>
> 2. Try to run the tests with more than 4GB of memory. The last time I tri=
ed
>    (actually by running the test on bare metal), the INIT test that Liran
>    wrote failed.
>
> Regards,
> Nadav
>
> [1] https://lore.kernel.org/kvm/3235DBB0-0DC0-418C-BC45-A4B78612E273@gmai=
l.com/T/#u
