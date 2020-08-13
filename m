Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0296A2438E9
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 12:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgHMKtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 06:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgHMKtE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 06:49:04 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60095C061757
        for <kvm@vger.kernel.org>; Thu, 13 Aug 2020 03:49:04 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mt12so2593090pjb.4
        for <kvm@vger.kernel.org>; Thu, 13 Aug 2020 03:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=HL0h/BRBdcQnrsrQO3+8yLqL/frPagkEHltCq+CfuMU=;
        b=cAAc3b51a+iKS6mtB3UtS12jAwSL4Tj9DF2Awc54aj0D6QP4fmMmtMdLT3QMFM+I8+
         nKhuqvpGzJrmUQgzndd/S5HyhffhV6oAnVrVb/tZngG1n5uWxL9cANomqUb+7vE50aCz
         KhAPknHNTdsgxwvUPdxCusNIwU98Z59yK9vLDDYJ04prBF7XNfySTOSihasEY/wQbRqN
         d3RoJJ6du/XbAGeDZArMDKGE6spUkk+H2gxJq3XqdS3uwZn658e72pfMBLKkqURfjYgX
         IYmaRnT+11ZqnsH35DCdIiBraUu/9CjQ4HqYTE6AciIVqP3BHDoYyj/fMTQ52aSprYT1
         t7xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=HL0h/BRBdcQnrsrQO3+8yLqL/frPagkEHltCq+CfuMU=;
        b=ZycD+6V52s07z1L62Wy4jgBT3EwouNapjLTw6Hz5Sq8rYg4Srs8zNyUBWhAyBq4NDL
         GhMBHg8XRdSg0T2+3tyDcwD6j5Zjx+NffI5IGEFngHigqsvUQvkdiO82+K1sEZyg4+2U
         MXYmW9cZ1x2rQQ/NcYpUx+GYq1Ix2q981BDx3K+tauAoguKnz0eRo3cn/R8J3Zm7YEKp
         pHkPJbAMQF2qSVF3P5CbfPjKS3ayJgOL7t9TO0COv2mRJnYIsYqsyOYwKPUUQXG/rfrE
         igkdMCkYNf1iuG990pv7gCZwgVBqW9+exF8leOfXTK+vK3LoNGz3k+gVW7J6/QtWVoVY
         TVrg==
X-Gm-Message-State: AOAM531mePcxLZ5WX+wc+L8XVzX3zX98wEKOw5KqxfCRa06gx9BGOtKY
        qWsySu4vXPycRDo4zck+WNW3ghpMJC4z4g5KFiEdTSeJpHs=
X-Google-Smtp-Source: ABdhPJzGDEeKcUPXuPrhGyxq4yrxBAPaFzBnCshuoHdy6hyDRxF/Xg/O+0mf9KpdqKIQyyFP6W6icD8XRQzXr7QjF68=
X-Received: by 2002:a17:90a:748:: with SMTP id s8mr4256843pje.112.1597315742847;
 Thu, 13 Aug 2020 03:49:02 -0700 (PDT)
MIME-Version: 1.0
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Thu, 13 Aug 2020 11:48:51 +0100
Message-ID: <CAJSP0QUPUSefLvHLe3+32a4EYNgsNmvzKdVBY6rXA-kA-oEA2A@mail.gmail.com>
Subject: Call for Outreachy Mentors (December 2020 - March 2021)
To:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Aleksandar Markovic <Aleksandar.Markovic@rt-rk.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Pavel Dovgalyuk <Pavel.Dovgaluk@ispras.ru>,
        Denis Dmitriev <Denis.Dmitriev@ispras.ru>,
        Anton Yakovlev <anton.yakovlev@opensynergy.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Oleinik, Alexander" <alxndr@bu.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear QEMU & KVM community,
QEMU will apply to participate in the Outreachy December 2020 - March
2021 internship program this year. Outreachy
(https://www.outreachy.org/) offers full-time, paid, 12-week, remote
work internships for contributing to QEMU for anyone who faces
under-representation, systemic bias, or discrimination in the
technology industry of their country.

I am currently working on securing funding for this round of internships.
Let's aim for 2-3 project ideas and I will send out an update if this changes.

Please post your project ideas on the QEMU wiki before February 1st:
https://wiki.qemu.org/Outreachy_2020_DecemberMarch

Project ideas must be suitable for 12 weeks of full-time work by a
competent programmer who is not yet familiar with the codebase. In
addition, the project idea should be:
 * Well-defined - the scope is clear
 * Self-contained - there are few dependencies
 * Uncontroversial - acceptable to the community
 * Incremental - deliverables can be produced along the way

Feel free to post ideas even if you are unable to mentor the project.
It doesn't hurt to share the idea!

I will review project ideas and keep you up-to-date on QEMU's
acceptance into Outreachy.

For more background on QEMU internships, check out this video:
https://www.youtube.com/watch?v=xNVCX7YMUL8

Stefan
