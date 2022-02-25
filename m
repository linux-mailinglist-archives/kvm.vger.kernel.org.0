Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0134C4505
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 13:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240748AbiBYMzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 07:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbiBYMzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 07:55:44 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8543021D0A0
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 04:55:12 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id e6so3187788pgn.2
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 04:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gIPLQIBAtfhj/PZ2de8eGc+4Cx/G/kGBx8Jr9LqiBb0=;
        b=fDAP+Nwn9ciayx9KZfqwqui1pYhSQpGSJlSxvgT1Yzb3tLAl4sMb9trsQ6OqwCUnFx
         RrDmtLtj4uvzuqE01e7MEXa/2kD0tObOPHSzpE5z89pDd9DDypKUCny+9/LJi9g+kTHr
         vcBIw/hN7hbgrRhtG+vacrPzeGn9racfx6pgy0RLowrgQq+jgzMp9P3sywd4KTaA7XY2
         dWQzDkfvVvRnBB2jwWg87y/9dYTJ3+WUQzhmuThLT/YyDNK1qWqI1bE3vDaJInCdG+8c
         5d1yGzMKqMl8FNaJdls3hBivGrbIf8mBxsfzq/0cGFK8WUWTO6ueKZ8kLKREupt2YRiK
         TO5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gIPLQIBAtfhj/PZ2de8eGc+4Cx/G/kGBx8Jr9LqiBb0=;
        b=aPONQ6vYxqFt7Vkvehxady8aRWAy8HI4jsLJarN2zhwi0SSyh6mmRUS8Ymebxc3LhX
         1ZWn1uIh5NY2jKBRrad1KDSHtMvZymzh3ymoCRjSE2+7i66YR4LSNBAh7ePl/PxmFxK3
         kSlR1d9inP0jTw6Kxxtp/k97CwhExv219/DDiDUVMhPjl11ThuvyqBzEWSlKkfWt3vGO
         uWNn/qPp0P54g/vX5R19JYHSj9iDO35GmYhufZhyPlZYk91CUv3kflVBlolRSpL9enEA
         5qctGUtjHKWrnMINa9iqwSAPFPdxaeezkc3ZU9ubEd8HdzDtqPJzWyahisS5Ng1R/Zi2
         5nCA==
X-Gm-Message-State: AOAM530YZao4+jg3lnhNZNwhULifSt6g1RegU/p24JvtTBNKZe0bA7Ql
        we3lZLuMx5VXXgPKxThN6Tt55jeiL1IQ/2LYU7I=
X-Google-Smtp-Source: ABdhPJytViQsMNRFajL/A67mJyN7GKsWPE3xuJF8dakK0vzIBlv9S1hHUNGamdEqiOi+6exCZoyGDLhLZyy9qUVz4yA=
X-Received: by 2002:a63:a84f:0:b0:374:3bb7:6d7d with SMTP id
 i15-20020a63a84f000000b003743bb76d7dmr6145096pgp.608.1645793712110; Fri, 25
 Feb 2022 04:55:12 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <54dddcf5-85d7-5170-899e-589dd79a34fb@amazon.com>
In-Reply-To: <54dddcf5-85d7-5170-899e-589dd79a34fb@amazon.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Fri, 25 Feb 2022 12:55:01 +0000
Message-ID: <CAJSP0QXknCnbF-NmPM-dqKfs7M15L8S+ejTrWfe+9c4pVznaSA@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     Andreea Florescu <fandree@amazon.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        John Snow <jsnow@redhat.com>, Sergio Lopez <slp@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alex Agache <aagch@amazon.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>, gsserge@amazon.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Feb 2022 at 08:48, Andreea Florescu <fandree@amazon.com> wrote:
> On 1/28/22 17:47, Stefan Hajnoczi wrote:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> >
> >
> >
> > Dear QEMU, KVM, and rust-vmm communities,
> > QEMU will apply for Google Summer of Code 2022
> > (https://summerofcode.withgoogle.com/) and has been accepted into
> > Outreachy May-August 2022 (https://www.outreachy.org/). You can now
> > submit internship project ideas for QEMU, KVM, and rust-vmm!
> >
> > If you have experience contributing to QEMU, KVM, or rust-vmm you can
> > be a mentor. It's a great way to give back and you get to work with
> > people who are just starting out in open source.
> >
> > Please reply to this email by February 21st with your project ideas.
> Hey, I am a bit late here, but in case it is still possible, I would
> like to also propose a project.
>
> Title: Extend the aarch64 support for rust-vmm/vmm-reference

Great project idea. I have added it to the list!

Please take a look and let me know if you want to change anything:
https://wiki.qemu.org/Google_Summer_of_Code_2022#Extend_aarch64_support_in_rust-vmm.2Fvmm-reference

Stefan
