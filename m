Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38432F11D9
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 12:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730173AbhAKLsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 06:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729974AbhAKLsB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 06:48:01 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9BEC061794
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 03:47:21 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 30so12384128pgr.6
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 03:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=aF/Yu0x3hnsxoa1QDIoOTSGgFkDsUETWdFvZDHJc4Y4=;
        b=aJ9Zx37rav5ow0hfm+zvYA4YpChzO84DX+7RDFSNmP1ZychE9aEqjmVqn1HoUJ88wN
         Y+yXeuHsjDYTQd8sEkk3GWA3d4tdpLE+cFmMCJxHH7C+Bh8vr75Nf4iyCULTrtA48DoU
         k/UfHmv1ctA1mk/8GLcCffdEpkK7U1bay8eOgQ0dM7cpexlMnainYF5spW/a5JMnQsna
         9yDKLZ9f7LpdIzigvi6wvYTblo60JvbxLfljNjg6OOh0FKH0JMh2O21w5TbVrbk5+PGw
         99/haS8pBcE5vUojNaPcaGPWf51aqX6Kkyg7nXCaVnASWhQ+L6hEwYMmYTtRs5weuXZS
         GuEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=aF/Yu0x3hnsxoa1QDIoOTSGgFkDsUETWdFvZDHJc4Y4=;
        b=rZ7UTI5nahvAzBcx5eH2jIMMwbcKsOygh2j3BGNmxKZ+beIUhHRbTJLyiz+YflRvNb
         F3sKq+JlBFaBjXvmDAonchI9oxOgrBVReNqD/AVt96UTVyvxVfmu5a3hllWJKvP10fqJ
         G44RWZKP1HeNehk3UqVO9rcTLa3/LGeXm8HoR5dxELsD8LB2lhPW6OY8a4rOu4dfob5P
         /RKQ9/mOfzY/XEehu5GwQwvRVs+C+pyjmYlNERfAlMJcdVftyN/lwBDc+cMCFlQq7SGT
         QeVJSwGE0VkwokY5LKyDQSRbHa5ilUPmtQQSnnI4YhnfRah6Y6PRv6c/FAsmI4gwhTnP
         H24w==
X-Gm-Message-State: AOAM533bfVqbTg/7UwzyyAkSEqdr7tuxHsaWu+swsH00eWWs1kGeQxEm
        y4dvryLWEtmIyxETPpwHeS1a47Dm1ygmktUd4oo=
X-Google-Smtp-Source: ABdhPJwAp2ziJIgC4Tkmn5V7R3bpxEuVxFR25Bm+sHHEJ+cteL9IzBZA7PekvUFkOACe1BMjYXdxXGYtHYUR7wSc7ts=
X-Received: by 2002:a65:48cb:: with SMTP id o11mr18866858pgs.121.1610365641185;
 Mon, 11 Jan 2021 03:47:21 -0800 (PST)
MIME-Version: 1.0
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Mon, 11 Jan 2021 11:47:10 +0000
Message-ID: <CAJSP0QWWg__21otbMXAXWGD1FaHYLzZP7axZ47Unq6jtMvdfsA@mail.gmail.com>
Subject: Call for Google Summer of Code 2021 project ideas
To:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        rust-vmm@lists.opendev.org,
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

Dear QEMU, KVM, and rust-vmm community,
QEMU will apply for Google Summer of Code
(https://summerofcode.withgoogle.com/) again this year.  This internship
program offers paid, 10-week, remote work internships for
contributing to open source.  QEMU can act as an umbrella organization
for KVM kernel and rust-vmm projects too.

Please post project ideas on the QEMU wiki before February 14th:
https://wiki.qemu.org/Google_Summer_of_Code_2021

What's new this year:
 * The number of internship hours has been halved to 175 hours over
   10 weeks. Project ideas must be smaller to fit and students will have
   more flexibility with their working hours.
 * Eligibility has been expanded to include "licensed coding school or
   similar type of program".

Good project ideas are suitable for 175 hours (10 weeks half-day) work by a
competent programmer who is not yet familiar with the codebase.  In
addition, they are:
 * Well-defined - the scope is clear
 * Self-contained - there are few dependencies
 * Uncontroversial - they are acceptable to the community
 * Incremental - they produce deliverables along the way

Feel free to post ideas even if you are unable to mentor the project.
It doesn't hurt to share the idea!

I will review project ideas and keep you up-to-date on QEMU's
acceptance into GSoC.

For more background on QEMU internships, check out this video:
https://www.youtube.com/watch?v=xNVCX7YMUL8

Stefan
