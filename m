Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58D6674FF0
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 15:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390329AbfGYNpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 09:45:41 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38426 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390322AbfGYNpk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 09:45:40 -0400
Received: by mail-ot1-f67.google.com with SMTP id d17so51722868oth.5
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2019 06:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r7oocFUrKIbamQKM5kMA/1c6NYGP8QAL4+tp5mejrdI=;
        b=pblBIhMpRoMn74WzYK6uXDZBHaBdabX9wuvaHBPSCHUAFLK5HuSlqzx47VtGJxATXF
         ce5cjbvNI3vus1WrSaybtJvXC0s/7mzbI3uANmQK6WWgB/WKzdoCZkxG5Z2/UhivRBph
         dv+QyaELLXSumzguNvEjzZy8tZeUAaZeYTvslxdvruESWp0euuRCRBuG0ps7+y0w8y7Z
         Dsl+gY3+8k6/5vkBUuVm5cv3LJrCOgL2wd9KOgetTRG2W8TyOuMc+jUNlTPHyI8Rd2SW
         7SDRnZDXj0lt6Iocj0URUUcgEXdwvD+auTbSTg20q3OQ0YQIyh1qTgJ2k7vBMAOxzqdT
         gviQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r7oocFUrKIbamQKM5kMA/1c6NYGP8QAL4+tp5mejrdI=;
        b=T/XSpbgwXu4GQcqR9eC1TRPgGpYiPLvNpL3nZ9IaSzmYgyxab7T9pOvRP9wmL86Z1o
         NATZrbweWcKYV4vrRESVfzPllIJmor5QnRdeVs4JTImzLoBCoNxLDIwb1t0ha8zLNN25
         hF65HYSuwZUmZMPhO5qjzgstqPXImypJNLPeF4cF7ooWXJDPlZUIxgcnTOf2TlwONqGO
         4VdOTCUXMAomHrL1nL8PLnQuPl7hVkB+fpNquMRj4FkK5NjxUlUh3k/iMHcsKJz1mAyk
         gpgH6w29GfOjB4dHBFiiiy7WMblrJW/DwCGUHgAbYSmgjm4GS01YZyP+XZoaSTG6Sv3+
         eYgg==
X-Gm-Message-State: APjAAAWRm8dcUUzG3fGZZTukFG1/gUWkoezsLQkZ86J+gRSNUgbeWPBW
        vnnQlY4t/+5zDZRDz+YVbRHJJPFcZ9xN/E1NTx+8FA==
X-Google-Smtp-Source: APXvYqydfdzIjCY1wt7lyjLiQN5TbYj5+eODt2s5C2j+oYe/o/lCCqP1J1OTFDO5tP03H9BvxLbU6IQt/XuMUzBnUFk=
X-Received: by 2002:a9d:6a0f:: with SMTP id g15mr35582299otn.135.1564062339731;
 Thu, 25 Jul 2019 06:45:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190725105724.2562-1-quintela@redhat.com>
In-Reply-To: <20190725105724.2562-1-quintela@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 25 Jul 2019 14:45:29 +0100
Message-ID: <CAFEAcA9ZMrRYKDAsVOoFuWhbt6kcMwfSHU6ZsMQHVoW-N8-mEA@mail.gmail.com>
Subject: Re: [Qemu-devel] [PULL 0/4] Migration patches
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

On Thu, 25 Jul 2019 at 11:57, Juan Quintela <quintela@redhat.com> wrote:
>
> The following changes since commit bf8b024372bf8abf5a9f40bfa65eeefad23ff988:
>
>   Update version for v4.1.0-rc2 release (2019-07-23 18:28:08 +0100)
>
> are available in the Git repository at:
>
>   https://github.com/juanquintela/qemu.git tags/migration-pull-request
>
> for you to fetch changes up to f193bc0c5342496ce07355c0c30394560a7f4738:
>
>   migration: fix migrate_cancel multifd migration leads destination hung forever (2019-07-24 14:47:21 +0200)
>
> ----------------------------------------------------------------
> Migration pull request
>
> This series fixes problems with migration-cancel while using multifd.
> In some cases it can hang waiting in a semaphore.
>
> Please apply.
>
> ----------------------------------------------------------------
>
> Ivan Ren (3):
>   migration: fix migrate_cancel leads live_migration thread endless loop
>   migration: fix migrate_cancel leads live_migration thread hung forever
>   migration: fix migrate_cancel multifd migration leads destination hung
>     forever
>
> Juan Quintela (1):
>   migration: Make explicit that we are quitting multifd
>
>  migration/ram.c | 66 ++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 57 insertions(+), 9 deletions(-)


Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/4.1
for any user-visible changes.

-- PMM
