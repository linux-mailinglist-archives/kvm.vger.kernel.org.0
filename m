Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C851EA367
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 14:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgFAMEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 08:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgFAMEI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 08:04:08 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7554AC061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 05:04:08 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id r67so8687303oih.0
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 05:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AXs9RDvYZOb6XSpask3boPtXtH6HO/N7WLt9rl/CamI=;
        b=t0OtP0X1UQe1exueUEcox5bx7nUhQnMzQ5sYM35h/z8zTeihC5klvO6IF6aykFUMXJ
         rlfk17vc8einJAm9RThSh49JPU3JxL1URj7X7b50RQ8+Ncz6LEsbvjLeLlcb3nSR6luK
         NZMJHRlLfIl3yGzfe1+pOaoWEJPR2hazKJrCpwx/InBEkTlp1uHcm9BcOMfwrCV34e+l
         e+QDvmAzGeC7xgcr3yuoZCPSbLmXZTDMkeaZF+W9ly8mn7/VCLNZtp84lGRzoWO2IjVX
         Jo2mZ+jZ5uHaN/MX8Ca//d5Kc9MUz1PT9fXVnIoxarlOBmyZzYwhlqIMG2oq2QLzbYPA
         eFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AXs9RDvYZOb6XSpask3boPtXtH6HO/N7WLt9rl/CamI=;
        b=nnHzis4LJqTjbNo201oDSokniSsFAVGK775qJVpz6rvEtfq0JTiTIBai7smBEsyKQu
         mudwVNknHBf/JUYJBiHQgBmR51Ph+bTaeDCepHPB+JSzzjEnvJSqWrhjUVlzsyNVbhp+
         0sRZxE5ZivLKHzTUNyY7t1u9ozgUOCB3Ac9B5Hcn+5KoBYxp/4p7IEDxH0wOlYQ6Rl/B
         drtifGZb1gpuijA9tlnXH2jThZ/cqlam87DmGK06JhnorwsHDdcEHqg8a2N9wm8sELZb
         lEk59Z5ubx2hVoXQaWHAGrpbrX+BP+GbX58K8bs9n+i1JkuOkbXaIwDlwCYKT/Rsz+Av
         I1lQ==
X-Gm-Message-State: AOAM533KZxldjM40mPIOHucTegb3CH5aH/EP6OPu/ScTVE+FDvxV5gfF
        Ix+rXb5OiuMJOksJ55wkwuyoHbt9rUvkyURW/hCYCw==
X-Google-Smtp-Source: ABdhPJxQP/k6yo6IIg3zSMu4UaKpgWz3nSyfk4MtDnFQ/2y+KbUX0KOofjQ6iBSwBVA4lnaAjzeYK7K9ZFPA69Qc164=
X-Received: by 2002:aca:5152:: with SMTP id f79mr3595258oib.146.1591013046956;
 Mon, 01 Jun 2020 05:04:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200531163846.25363-1-philmd@redhat.com>
In-Reply-To: <20200531163846.25363-1-philmd@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 1 Jun 2020 13:03:55 +0100
Message-ID: <CAFEAcA88=x_mecmN98LdQ_3Gag_QRNqj_y2K0KQheAK=NMVMow@mail.gmail.com>
Subject: Re: [PULL 00/25] python-next patches for 2020-05-31
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Kevin Wolf <kwolf@redhat.com>, Fam Zheng <fam@euphon.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Qemu-block <qemu-block@nongnu.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 31 May 2020 at 17:40, Philippe Mathieu-Daud=C3=A9 <philmd@redhat.co=
m> wrote:
>
> The following changes since commit c86274bc2e34295764fb44c2aef3cf29623f9b=
4b:
>
>   Merge remote-tracking branch 'remotes/stsquad/tags/pull-testing-tcg-plu=
gins=3D
> -270520-1' into staging (2020-05-29 17:41:45 +0100)
>
> are available in the Git repository at:
>
>   https://gitlab.com/philmd/qemu.git tags/python-next-20200531
>
> for you to fetch changes up to 1c80c87c8c2489e4318c93c844aa29bc1d014146:
>
>   tests/acceptance: refactor boot_linux to allow code reuse (2020-05-31 1=
8:25=3D
> :31 +0200)
>
> ----------------------------------------------------------------
> Python queue:
>
> * migration acceptance test fix
> * introduce pylintrc & flake8 config
> * various cleanups (Python3, style)
> * vm-test can set QEMU_LOCAL=3D3D1 to use locally built binaries
> * refactored BootLinuxBase & LinuxKernelTest acceptance classes
>
> https://gitlab.com/philmd/qemu/pipelines/151323210
> https://travis-ci.org/github/philmd/qemu/builds/693157969
>


Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/5.1
for any user-visible changes.

-- PMM
