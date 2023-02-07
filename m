Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D38968CB99
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 02:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjBGBBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 20:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjBGBBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 20:01:01 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDE22ED45
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 17:00:54 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id i2so13404073ybt.2
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 17:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PzNcsW8Hrl9l8KBKQzAZFcbFKkmOsrZjBk1wjPQHcEo=;
        b=BoZzkC/W4ciY44+B9zgXN3T71rr8TEjOxVb3EoQhy3wacA4e05IMlKqC9jA0zGjWMc
         qMf1kjForSwZpv3ZNmGVOFZhdmgKLAzZXjkQRV5mulqj6AyCtpCX4+uW5vG0jD0OEQUQ
         8Ozp4Y0zb19QH9JlQc0+meWyZpLkOcP0ZzHbzbEzILOuMTmcj6b3NsBZM8HhALTfozpr
         8HKZ66hyYdWAm7EqsrO8W64rt28Y8QYMW0Bu1pgJd6BBtrsLEFAFGk4aXDJ0f2i1yj6D
         pcgetaxLQupIn1oiVDEiwD5YbeehlSEprRBBhVyMIsFo0yFGsfLJFEMD9itK6jk5iovU
         59Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PzNcsW8Hrl9l8KBKQzAZFcbFKkmOsrZjBk1wjPQHcEo=;
        b=oxnL++FcMfJAIbiVCj6t0rAQjjn5NLLCTO2Hsb0Lru0dlaoI49K/9BwdpeKywhqb1Z
         oFXT2pAahY8FNtOki3W9BV2SsEaODB6kG5Hg3O76lJoDCKPFUBM7x2GpsXMtATfA0vl0
         kDNSKJWQKSWr7mNsY8fsrSqi8DukSxsscIoQtO0kfur5dOlwhpSgExe+LgNdoGXPkgzS
         dQqA+lqMKV0gRM8j3l+M+VZBv1n1ShU6QzlHqpJ5atnhqWhiP5OVordrN4HLYLOktg9l
         ///cuSy9XFALCEJKGPa9/bMWEx9KuHf5yHh9vcKfbD2qA3dFJ+WBqJ4/gsEYNEuD3I/C
         rR7g==
X-Gm-Message-State: AO0yUKXXcjApvb9sQ2D81Zo4suXGs65UX4Qch6uafb+u3p0roCxHls33
        /tO27T7rE5NENnGmKXLbG6fBqoUAh98wJWZn2EA=
X-Google-Smtp-Source: AK7set/CL+ULWvMubc53ftoGDLBY5BEaWXiCB0xjXYoQvo2L7HQ26E5d5w/pbEPWGcJ4uhzWMBPzPNLGZSDOt+WySoQ=
X-Received: by 2002:a5b:ec4:0:b0:880:9ae0:2728 with SMTP id
 a4-20020a5b0ec4000000b008809ae02728mr164743ybs.366.1675731653914; Mon, 06 Feb
 2023 17:00:53 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QUuuZLC0DJNEfZ7amyd3XnRhRNr1k+1OgLfDeF77X1ZDQ@mail.gmail.com>
 <CAJaqyWd+g5fso6AEGKwj0ByxFVc8EpCS9+ezoMpnjyMo5tbj8Q@mail.gmail.com>
 <CAJSP0QXyO4qXJseMzbgsVdXK-4-W4U9DxPcxr6wX45d6VBTeWQ@mail.gmail.com>
 <CAJaqyWczFwbxNWrZ8dcFHvYrV2=tH7Tv0Apf=qORT+gzDpBN4Q@mail.gmail.com>
 <CAJSP0QX+mpmdVE-13L9p=02_XbmPFT-mFAbz-JJjqB5V-2ON6Q@mail.gmail.com>
 <CAJaqyWd8EhfDmTtmLNzuoVDoF641Tq3LL1jvvdXK+DDbAfjccQ@mail.gmail.com>
 <CAJSP0QUFR_Nhd2dDkXJ_NjSo=+GNHFswztuGLLJ1QuokqOMUqA@mail.gmail.com> <CAJaqyWcBLOi5dggqVwhbNTFRRV24SOcHMUEDa6UDwN0RqXVMSA@mail.gmail.com>
In-Reply-To: <CAJaqyWcBLOi5dggqVwhbNTFRRV24SOcHMUEDa6UDwN0RqXVMSA@mail.gmail.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Mon, 6 Feb 2023 20:00:42 -0500
Message-ID: <CAJSP0QU5eu+9_0gSamE_TvgN6roRzCWMprtiQ2GQnumXi1iskw@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2023
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Thomas Huth <thuth@redhat.com>, John Snow <jsnow@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Damien <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Alberto Faria <afaria@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Bernhard Beschow <shentey@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, gmaglione@redhat.com,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 6 Feb 2023 at 13:48, Eugenio Perez Martin <eperezma@redhat.com> wrote:>
> Thanks for all the feedback, it makes the proposal way clearer. I add
> the updated proposals here, please let me know if you think they need
> further modifications.

Thanks, I have added them to the wiki:
https://wiki.qemu.org/Google_Summer_of_Code_2023

I edited them more (e.g. specifically mentioned vhost_svq_kick() and
vhost_vdpa_host_notifier_init() so it's clear which functions need to
be tweaked for the mmap Queue Notify address support). Please feel
free to make changes.

Stefan
