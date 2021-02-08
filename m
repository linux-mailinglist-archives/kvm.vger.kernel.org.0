Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1BC3132E0
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 14:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhBHNBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 08:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhBHNB2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 08:01:28 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C88C06174A
        for <kvm@vger.kernel.org>; Mon,  8 Feb 2021 05:00:48 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id a9so24503798ejr.2
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 05:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZoanlxQLe4ZKiCr1+9Kb8ho+Q/7NBrIvc7EePg54NpU=;
        b=bt6VEuPPaaZ5BZtbHRtRpCfKashhk+7g0DcfgSG9l4ySvfh1OlnCAqofKWVT4jdi7k
         rYEKAEcyL8RAYp3LhVDnwXKO3bgRXMyhrq93ksoIeoRKe4hUyMwVt0tl11a2zpgIr50z
         omUP7iRr6JPLpikkjh6R0IdX8pmoNJEZHq4tj2TUmdWzXQuqN0WpUId2cIft4JtMKC9m
         0jjJSxgCjLF+yDIZioH0L8VuwN2PMWCdDCwqg1rqFZ4Ibx5t/RnF/wJURtDv+2cAMnCj
         GgUvL3G5aXlHZJBX5o7P2eOtL7cdKotsWfUIaZfoQhuvbZ+yHG6zhSkdkIWZsc3TAzg2
         LgmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZoanlxQLe4ZKiCr1+9Kb8ho+Q/7NBrIvc7EePg54NpU=;
        b=LLNZYfYTpTiyYpHPIMsuo+aG3kSFBPo1VnQVu0gcGZ1W34rsM1MMd5NJZgeD7glhzy
         4LmRL7MX7YTYIdo9VGJ7H/IZhuHNiPoGgsGi0nDPH/mbWB+HdZTIGGDiZbkKcqVqoqyd
         qiu5pCboHm9sM2wDEe3xbL1yE9htQKLwM1WhMUyoufqS3M/aIXjb1vvwNxXszel8Ko2O
         qcgnMAW0AoHGZDaeZAD2umu0JLG6RUbv8sz1qxnqFqFBEg+tWc5KJsH+ljJ6vj2flOoD
         kat5ebtnDOI1qlkl7SgxH8KZOOfsOmkAPEhXhsXwsHzNykAl6OWNXLE0osbc6P1iUo/K
         J9qw==
X-Gm-Message-State: AOAM530Uu2coPJT7sN/tt1KVnQy0lJ1gUXN5a3OESn97DkQslybWjMyU
        bk4qn183fbsQMCtaLReIBSFs/BK0x1NKo0xYYlgMfA==
X-Google-Smtp-Source: ABdhPJyRx4zlNtL65uNnanRCs/0JswwwTtORaIrdpPFQZwm+gy4qtm1pUNmy0THjA68AckAkbgJb7jzUJsn1B7V4Kbg=
X-Received: by 2002:a17:907:98c3:: with SMTP id kd3mr16908125ejc.482.1612789246831;
 Mon, 08 Feb 2021 05:00:46 -0800 (PST)
MIME-Version: 1.0
References: <20210208060538.39276-1-david@gibson.dropbear.id.au>
In-Reply-To: <20210208060538.39276-1-david@gibson.dropbear.id.au>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 8 Feb 2021 13:00:35 +0000
Message-ID: <CAFEAcA-wRzKJSqh1fVUUkcTsVZCnceoAoe5W+BaCOzcrJVH0YA@mail.gmail.com>
Subject: Re: [PULL v9 00/13] Cgs patches
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, pair@us.ibm.com,
        QEMU Developers <qemu-devel@nongnu.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x <qemu-s390x@nongnu.org>, Greg Kurz <groug@kaod.org>,
        qemu-ppc <qemu-ppc@nongnu.org>, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com, andi.kleen@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 8 Feb 2021 at 06:11, David Gibson <david@gibson.dropbear.id.au> wrote:
>
> The following changes since commit 5b19cb63d9dfda41b412373b8c9fe14641bcab60:
>
>   Merge remote-tracking branch 'remotes/rth-gitlab/tags/pull-tcg-20210205' in=
> to staging (2021-02-05 22:59:12 +0000)
>
> are available in the Git repository at:
>
>   https://gitlab.com/dgibson/qemu.git tags/cgs-pull-request
>
> for you to fetch changes up to 651615d92d244a6dfd7c81ab97bd3369fbe41d06:
>
>   s390: Recognize confidential-guest-support option (2021-02-08 16:57:38 +110=
> 0)
>
> ----------------------------------------------------------------
> Generalize memory encryption models


Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/6.0
for any user-visible changes.

-- PMM
