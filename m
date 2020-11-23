Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD312C0E17
	for <lists+kvm@lfdr.de>; Mon, 23 Nov 2020 15:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbgKWOsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 09:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728745AbgKWOsN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Nov 2020 09:48:13 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA30C0613CF
        for <kvm@vger.kernel.org>; Mon, 23 Nov 2020 06:48:12 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id v22so17353603edt.9
        for <kvm@vger.kernel.org>; Mon, 23 Nov 2020 06:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G03zfpBJ1gx2z+xZPEk8uNItFGz1G7uc7ZApPGaDo+A=;
        b=dXxy73XhjfMCTJ1gT50nce5qWrZ7jyx3x5xAFeLvmEsLRKY+iNZ8FdpCgSnUMbtNRl
         v5S3fftvgB3FUxggK9PIqK3302xKyLmyEXu0j68IyRb6Kyxz3sheAy9TdJ7KP0uicoJ4
         oLYIqd4yT1ZuEK2ykuq+yb4wS1cUbakqc158KiMTW8p/eO97CbQFNrLrODEZyVs3FJaw
         0o+ycTCOJ/IUyo2+fmUiBknLYWGWWIqVtTb6PhoK55/UiHS2ta+Vo9Zuk+fIwZOLXs16
         3qqpG12/w98WeewWOkzcb2vc4Izfab39g57mI11ZWPPX5Q4rBn/1axMnIYpypgSPWRiD
         UweQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G03zfpBJ1gx2z+xZPEk8uNItFGz1G7uc7ZApPGaDo+A=;
        b=i0jjmfDjAHhg1WxS92qTAZdGdpY52kPP7NiSsP6cdF4DjlvULCMFdUkLECv2DD570D
         8yGmGTHl8J5Z/RLofQuOcmL9DCZ1aZhECzWAjZR0QwIMQwicQdE2bex/0QkUHRE6iiaR
         Tdpcz2qwx3sDLF7jAelTK2scJD3GTXbrCg/evlnukgZFmuKS9EeIkO6i4ad4cvxv5OkH
         Fdx48/Lwfo+ShG6nGs7oblyTOCyZzy229AKFAtMQYXJYrvUHYanCIRH3lSH39q9ioaBX
         7Mri9mmWF6HjCyP0XrSv7A+mCBa47aICAfi9yAO6ND1y8pUNdNMDoaWqGE2PdhUwVvr7
         8YSQ==
X-Gm-Message-State: AOAM532Y6BIem34EYmUkNp5h2BVgQPse9wEp1yjVLgsZUtVfUo0m5W4/
        /+f0bWTd1C11RODxsOtN8hxp7u+J5SJZclV9j546CQ==
X-Google-Smtp-Source: ABdhPJxHSokrMhPmnqp59fFO2f7Jpk5malGe0HxhSjfAHz3qIiAekqJLFgsZtN9uwOk3aufb0yILcABboltzaIPakYI=
X-Received: by 2002:a50:fa92:: with SMTP id w18mr11334726edr.44.1606142891408;
 Mon, 23 Nov 2020 06:48:11 -0800 (PST)
MIME-Version: 1.0
References: <20201104151828.405824-1-stefanha@redhat.com> <CAFEAcA_fer-r6tJLRgQwQ+X1bAe0ODSA5UNWxZbSCtS1VHDO9A@mail.gmail.com>
 <753aef6b-128d-e1af-b959-e83481749120@redhat.com>
In-Reply-To: <753aef6b-128d-e1af-b959-e83481749120@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 23 Nov 2020 14:47:59 +0000
Message-ID: <CAFEAcA_eh_0w5jkU+DOnMU5+ynvqB74kxEC09V__tTsqrhxXaQ@mail.gmail.com>
Subject: Re: [PULL 00/33] Block patches
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, Fam Zheng <fam@euphon.net>,
        Kevin Wolf <kwolf@redhat.com>,
        Qemu-block <qemu-block@nongnu.org>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Markus Armbruster <armbru@redhat.com>,
        Coiby Xu <Coiby.Xu@gmail.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Klaus Jensen <its@irrelevant.dk>,
        Keith Busch <kbusch@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Nov 2020 at 12:55, Philippe Mathieu-Daud=C3=A9 <philmd@redhat.co=
m> wrote:
>
> On 11/4/20 9:59 PM, Peter Maydell wrote:
> > On Wed, 4 Nov 2020 at 15:18, Stefan Hajnoczi <stefanha@redhat.com> wrot=
e:
> >>
> >> The following changes since commit 8507c9d5c9a62de2a0e281b640f995e26ea=
c46af:
> >>
> >>   Merge remote-tracking branch 'remotes/kevin/tags/for-upstream' into =
staging (2020-11-03 15:59:44 +0000)
> >>
> >> are available in the Git repository at:
> >>
> >>   https://gitlab.com/stefanha/qemu.git tags/block-pull-request
> >>
> >> for you to fetch changes up to fc107d86840b3364e922c26cf7631b7fd38ce52=
3:
> >>
> >>   util/vfio-helpers: Assert offset is aligned to page size (2020-11-03=
 19:06:23 +0000)
> >>
> >> ----------------------------------------------------------------
> >> Pull request for 5.2
> >>
> >> NVMe fixes to solve IOMMU issues on non-x86 and error message/tracing
> >> improvements. Elena Afanasova's ioeventfd fixes are also included.
>
> There is a problem with this pull request, the fix hasn't
> been merged...

Sorry, this must have been a slip-up on my end. I have
now merged and pushed this pullreq to master.

-- PMM
