Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24C7169783
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 17:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732531AbfGOPLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 11:11:25 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43270 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732083AbfGOPLX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 11:11:23 -0400
Received: by mail-ot1-f68.google.com with SMTP id h59so13463933otb.10
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 08:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jA1oz0CnIFFH9xIt5PnRhMeufX8puveWqu8COvjsHCo=;
        b=R4vyIkSezVQxMUSIdsbh9Ar8bkUfVen2xIOApJ3xSiMMOpj9vexHV+77++swXwkWCw
         zInN6JHyJOheTi86ty30fH2IbYVbfa3XDghQWHFJCjs/E36588kMSU0pESphlaQ/aEZ+
         V0qeFpJpSx0Tbe7nHcvElC4s6vqb2HE0f54c18BWNLOUqlE8+DQFxKByir0OMIisI6oM
         jNW5v9pqffzFuLYdgUBT05gUVC3H/Vb2s9iSHLiFewsXsXavRqgqQ+no9oKJuYvvuMai
         BqRaVRQl3fneT2zGbUs5a2UiV/lF3xll1mlg8OVmRv+3G3m46PG+j/RYnf5fJ03ICpqa
         cOwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jA1oz0CnIFFH9xIt5PnRhMeufX8puveWqu8COvjsHCo=;
        b=NgaOn6qUVOa4cZJGCTpgbEyhpP+9ncmVSDfU9d46RXWzfSFs+3P08FgRs7C8z4UrbX
         UduRgDeGFxaT1B5VsccZSKUOy3cdB6TwVAecPiX4Op9mK80SvSCTUyHa/yAhFd6ymE9H
         +nH3iUEbAqXIXTUPgRrsnSCxcpT/YBMRoP71/C2RekHTQKj8vxgVsdNfDX8WJR6kSSx+
         Cn1c02nud0/15SJpB7WvJNjmtPKzji/JtnFyaNGqDwpAQ2/eCdCBo9V7HSho78QHFVzK
         o4SOhdLL5/k0x9yVu4zwe0C4JRtc3MU6OSBy8pg1uztT6BrgDF/ezaIYS94QAYhaqw/o
         JwMA==
X-Gm-Message-State: APjAAAUKwYCyxEXDMn8NkBg0nMvTG55eiZ01J2T9R4oOtRmqsu+s9DS8
        hkFuifgg3yVjFMboh4Go9mLuHESX/XmEQRm8ABivqA==
X-Google-Smtp-Source: APXvYqzfMbsXYOABV/Vi4r1uvVUtWsNdAMij2znhlmM7zPm1OegLzBDUpgPTFcEdT4qWYlw9zjboUF6ssw1sl+2FbdI=
X-Received: by 2002:a9d:5f1a:: with SMTP id f26mr21003288oti.91.1563203482714;
 Mon, 15 Jul 2019 08:11:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190715135125.17770-1-quintela@redhat.com>
In-Reply-To: <20190715135125.17770-1-quintela@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 15 Jul 2019 16:11:11 +0100
Message-ID: <CAFEAcA94NybRjhDhsmKjB0iT4Zw27LA_t4pqdMArGmqEvAVZRA@mail.gmail.com>
Subject: Re: [Qemu-devel] [PULL 00/21] Migration pull request
To:     Juan Quintela <quintela@redhat.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Jul 2019 at 14:51, Juan Quintela <quintela@redhat.com> wrote:
>
> The following changes since commit b9404bf592e7ba74180e1a54ed7a266ec6ee67f2:
>
>   Merge remote-tracking branch 'remotes/dgilbert/tags/pull-hmp-20190715' into staging (2019-07-15 12:22:07 +0100)
>
> are available in the Git repository at:
>
>   https://github.com/juanquintela/qemu.git tags/migration-pull-request
>
> for you to fetch changes up to 40c4d4a835453452a262f32450a0449886aa19ce:
>
>   migration: always initial RAMBlock.bmap to 1 for new migration (2019-07-15 15:47:47 +0200)
>
> ----------------------------------------------------------------
> Pull request:
> - update last pull requset
> - drop multifd test: For some reason, 32bit and a packed struct are
>   giving me too much trouble.  Still investigating.
> - New fixes from upstream.
>


Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/4.1
for any user-visible changes.

-- PMM
