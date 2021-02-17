Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9773331D81C
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 12:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhBQLWG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 06:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbhBQLVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 06:21:45 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A659C061574
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 03:21:05 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id a4so6708157pgc.11
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 03:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i6f3GZ8jdDvgbs0AJK9wY2MdXfBUn9J76vvvhk6rUzQ=;
        b=BXfpnpf1tEDVdt0zSqhShr3IJ3HDd5f/dzBuXW/ga7x6DAq2pwJ8hMm0j7lOURobcY
         xLabBJ7qmv6NyW+Ib/mIP3usdLSoMTW5syXcJE2Cl3YD05vtSJPhNLdfGfmjwbcrYWUU
         8h71BUj6frkglDOXfnX1vy1eQoW+Rq3qxjIYacNMOYWIW/4ruZL4BgSdwEi7iIj+DZkD
         oz2RPudYZPBurvF+iHOTSWgq2rC5hPYL37LDttAPv4c5cJwwne763RTsAkbs+WesfJp7
         YpUeJzte+NK+DXmJqNVlASu9lnkk2miPhOEXFh/2Grc6whnN/FhwWCNZgBzZHoaFoUqN
         RM2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i6f3GZ8jdDvgbs0AJK9wY2MdXfBUn9J76vvvhk6rUzQ=;
        b=Rq/iDT9Yjpbz34cWn5QxnCAbyXsiMBgiCJNiz81IF8Qpauk/AsSIXL783eEyt8Fgy6
         ku8TjmL/V8EVfOCTNU9wpSCiEboWMmHi5WtuNPQb7euLSZPPuQc/Je2CRwdMD7bJFIIT
         JdMIeIOlOa4L67Us8BUVgAfjlm7iFiKujLUOEUAiZ2yepLUfcArCacxU4ySkARXm8Is2
         oUoOi0PLFcNHkLu90W5quHV4EefoLFOJR3e43CTheZ6wqRchE/d9reAktylJTCJeHNzD
         ETM2zhU1L7rZJ0WPNpVGHoUWtrB30G5bVT5mSMKW+bMeclBz6qxmJfbOctDYxSIqeBQ2
         7Twg==
X-Gm-Message-State: AOAM531tGLt24uyWuS47V7fMWcBEOp+wGaUM2YXQDwOfr89iFrn4nG5M
        1yy01DMH+nZbpcf+EEQCMnaqhdG+ma9lGAV0gPQ=
X-Google-Smtp-Source: ABdhPJxnMSdsOKBDhot8t2lbuadLZ52XpYW7Jies9d7/3O9VtW7EQGfaVeGbIyZOc5+Ue61YQUfvQ7XILuvqF+YQPh4=
X-Received: by 2002:a62:683:0:b029:1ec:c88c:8ea2 with SMTP id
 125-20020a6206830000b02901ecc88c8ea2mr6215189pfg.27.1613560864360; Wed, 17
 Feb 2021 03:21:04 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QWWg__21otbMXAXWGD1FaHYLzZP7axZ47Unq6jtMvdfsA@mail.gmail.com>
 <1613136163375.99584@amazon.com>
In-Reply-To: <1613136163375.99584@amazon.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Wed, 17 Feb 2021 11:20:53 +0000
Message-ID: <CAJSP0QXEvw6o7XFk9FXudr9PmorFHiOuNRg16DjJhBgj_qC-FQ@mail.gmail.com>
Subject: Re: [Rust-VMM] Call for Google Summer of Code 2021 project ideas
To:     "Florescu, Andreea" <fandree@amazon.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        "rust-vmm@lists.opendev.org" <rust-vmm@lists.opendev.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Alexander Graf <agraf@csgraf.de>,
        Alberto Garcia <berto@igalia.com>,
        David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Aleksandar Markovic <Aleksandar.Markovic@rt-rk.com>,
        Sergio Lopez <slp@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks, I have published the rust-vmm project ideas on the wiki:
https://wiki.qemu.org/Google_Summer_of_Code_2021

Please see Sergio's reply about virtio-consoile is libkrun. Maybe it
affects the project idea?

Stefan
