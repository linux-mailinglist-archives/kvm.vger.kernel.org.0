Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 649D367E94A
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 16:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbjA0PSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 10:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234352AbjA0PSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 10:18:05 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EDD83D9
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 07:17:52 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-4c24993965eso70632027b3.12
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 07:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qtmOJn2ynTbarZpt4sn09eBK6F0W3nGga9MlPF8BeoM=;
        b=qMKuwTcsrrEKcPqZq+U1beo0zgEDd5gWpAx4YHRCBj5PaQbBtCA7AOLniz9QPhLuPP
         IU3SwCLJ+LBYNahQm8PhXyVKm4pEBhC907/ooMVoNgRYWoXKXWszX7urIj4bmxgX6kGW
         u0R6d/lQxpPfvjg/9+1GtXK5x8aZ1sH8A3a6nyZH9yp0McdnDU36Ro6aFfw0Gux9YF4Z
         EO2T/Y7/JnbmfkDtE7H7PNhA8NXh2F8ZMPFUXOS5u+F3qfHygfdoAGo1p6qgP21gdFR7
         ssDzCNggGchuK7SvJKsFjlaVEkNryccZC4MwUmxAD7If7IMvwgisvie2qfwhSD4RDfLz
         sb7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qtmOJn2ynTbarZpt4sn09eBK6F0W3nGga9MlPF8BeoM=;
        b=s4ISXSt61F8qCdVH1U2jrTuEaCy5f1nr7Fv0Ruyo9228+499UN9K7pz/9PpjBY5U5M
         Ew+4CvmNmvgReAOptwao+E4ZYZV1UbiiA6mXsmmffG+qS71h99TU+FvAIo7xTGETe2UC
         xAfVifpXajJQpUz7C0OOubovXefk4tWH2Oc9auIUB2oCr8vLb6F0Z++P7GuSKneXAAKU
         iHwUi+leLU4TtrScR+mYobvEXlM+vQGhtevRJYex7jIoFCMo6XuE7wLRzPxPkr6AzEZs
         GdKJLJNrIiuI5Ivk7bfBDhx9kFZQK1T+v0L5qDE9V35oZnP4MNhNwXot4cOTRkRZMHcj
         a4qw==
X-Gm-Message-State: AO0yUKUsKzNaVZAVGnqFmAeGqeGhSPk6qIeME4JSMvKClIaj3W3/sLtr
        rwUJ5/9XPmPhUX7u2m7hYjjlBJqqIT2+BgDf73w=
X-Google-Smtp-Source: AK7set9MQ4KitPLSUcDuN/or8feHGShMjiiAvNw02sa3lvN6wuzB2dBVneXGl+e7uNURvBEz+4OpxAlXHKKyHV8vlTE=
X-Received: by 2002:a81:4882:0:b0:50e:79ff:776e with SMTP id
 v124-20020a814882000000b0050e79ff776emr105761ywa.206.1674832671947; Fri, 27
 Jan 2023 07:17:51 -0800 (PST)
MIME-Version: 1.0
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Fri, 27 Jan 2023 10:17:40 -0500
Message-ID: <CAJSP0QUuuZLC0DJNEfZ7amyd3XnRhRNr1k+1OgLfDeF77X1ZDQ@mail.gmail.com>
Subject: Call for GSoC and Outreachy project ideas for summer 2023
To:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>
Cc:     =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Thomas Huth <thuth@redhat.com>, John Snow <jsnow@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Damien <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Alberto Faria <afaria@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Bernhard Beschow <shentey@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, gmaglione@redhat.com
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

Dear QEMU, KVM, and rust-vmm communities,
QEMU will apply for Google Summer of Code 2023
(https://summerofcode.withgoogle.com/) and has been accepted into
Outreachy May 2023 (https://www.outreachy.org/). You can now
submit internship project ideas for QEMU, KVM, and rust-vmm!

Please reply to this email by February 6th with your project ideas.

If you have experience contributing to QEMU, KVM, or rust-vmm you can
be a mentor. Mentors support interns as they work on their project. It's a
great way to give back and you get to work with people who are just
starting out in open source.

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

For more background on QEMU internships, check out this video:
https://www.youtube.com/watch?v=xNVCX7YMUL8

Please let me know if you have any questions!

Stefan
