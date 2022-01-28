Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BA949FD10
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 16:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349411AbiA1PrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 10:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348753AbiA1PrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 10:47:20 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0713DC061714
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 07:47:20 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o64so6813071pjo.2
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 07:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=/5GaBjAPDkft9rss8AjJbYiyeSgUzkGFpx6lcIFGalg=;
        b=CUgy2U8mNb65Wm9Bm4YduWGDpEY+TZoG9/0sL4d/O604sGT4RL3O6TIjRru2FGXGs2
         9Il9/O2yLeq3NB1QvqvZEP8Ptil3dVLRJt8GAfBYVZ3y5bwRrq9jTPobsjRQTKwdpvE0
         gXS5gtjgVw/ArFMnZ+dUpyVn8WZ4bINoQN6EwUPFuLZQDsA/114R9rkn3vJSLmNp+7rc
         yGZHDCx5TM0fZ5M4pQLci+d8sE4JT43D8ITyoXCzLoYrWQRilLZSr96pfcjR/lh+aORQ
         oupgzREQrEjwpmClDeb7UlpW+0WPAGIQgzu9GwgrNYIUIbIsTt5ruOGVu3Zv1m8AsWNy
         OcMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=/5GaBjAPDkft9rss8AjJbYiyeSgUzkGFpx6lcIFGalg=;
        b=BzEg8YUQYIr8ZBkPz1+B5zxSMLo9L/Y/97BCqJyN/7Zmpg/s9T9QdolBSVoIRUEOD2
         akEBolPAVzwqmASozHBZJHwmCV0ujlyC1/ldQjkvvsqpZ9Pm7fy/3B+4aJelkLqOBEpX
         oyuQAHmDaaNRlcUZUitoJ2XKK9YGcUVBigFO7S3DoJIMgGEI7ei63oYFBOVq2FIShJZU
         +ejbROxuE1eWEXDnWD6GhyL/dkHpa7Fra8td58lnKRt5s1EoUCXuhaweRLlWzM5HjDN1
         Rs3t9qffDtS5AOu/MU0xXExVK0RPlt3nhPA3sQ0DHowubCOIViRx4Yojrso9mSdfotsZ
         jzng==
X-Gm-Message-State: AOAM531IkrfnD+Og2PXbi+VILOVvrevyxkWKT646EHmWjwhd4xNYMAFQ
        TrHU6aSILd9kgV98vab3Dm5FLy86Z5Jrn13mRx8=
X-Google-Smtp-Source: ABdhPJz07lUVrIA488ClPtp8e7LOJ/LZf0rzcLMV7vdst+jqtEFW2z52dNVLNB298s5Bx3475Czb6PnszVa8e1+opYE=
X-Received: by 2002:a17:902:9303:: with SMTP id bc3mr8614449plb.145.1643384839415;
 Fri, 28 Jan 2022 07:47:19 -0800 (PST)
MIME-Version: 1.0
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Fri, 28 Jan 2022 15:47:08 +0000
Message-ID: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
Subject: Call for GSoC and Outreachy project ideas for summer 2022
To:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>
Cc:     =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        John Snow <jsnow@redhat.com>, Sergio Lopez <slp@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Alex Agache <aagch@amazon.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        hreitz@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear QEMU, KVM, and rust-vmm communities,
QEMU will apply for Google Summer of Code 2022
(https://summerofcode.withgoogle.com/) and has been accepted into
Outreachy May-August 2022 (https://www.outreachy.org/). You can now
submit internship project ideas for QEMU, KVM, and rust-vmm!

If you have experience contributing to QEMU, KVM, or rust-vmm you can
be a mentor. It's a great way to give back and you get to work with
people who are just starting out in open source.

Please reply to this email by February 21st with your project ideas.

Good project ideas are suitable for remote work by a competent
programmer who is not yet familiar with the codebase. In
addition, they are:
- Well-defined - the scope is clear
- Self-contained - there are few dependencies
- Uncontroversial - they are acceptable to the community
- Incremental - they produce deliverables along the way

Feel free to post ideas even if you are unable to mentor the project.
It doesn't hurt to share the idea!

I will review project ideas and keep you up-to-date on QEMU's
acceptance into GSoC.

Internship program details:
- Paid, remote work open source internships
- GSoC projects are 175 or 350 hours, Outreachy projects are 30
hrs/week for 12 weeks
- Mentored by volunteers from QEMU, KVM, and rust-vmm
- Mentors typically spend at least 5 hours per week during the coding period

Changes since last year: GSoC now has 175 or 350 hour project sizes
instead of 12 week full-time projects. GSoC will accept applicants who
are not students, before it was limited to students.

For more background on QEMU internships, check out this video:
https://www.youtube.com/watch?v=xNVCX7YMUL8

Please let me know if you have any questions!

Stefan
