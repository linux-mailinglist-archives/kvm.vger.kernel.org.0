Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2433C850D
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 15:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbhGNNO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 09:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbhGNNO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 09:14:57 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089EDC06175F
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 06:12:05 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id qb4so3197475ejc.11
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 06:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ZFMVImXUets2jfkQNpUykIw5epHF00Q0CGPGB40lqk=;
        b=f6E7QV4UHzrIMrq2Y/A19eU2haE8coCU5FMcmWlV1rMADTvMUq2L+wDsVPArWsvvfL
         2YpUwkOkhE0JZIZiaTUdEU8Zbnnjai3HRY31N9MFW+EbiHnUXsO6RCZR1vSMpSQjtEac
         6Q2fPjI8aUoBhpq2eWpn/nkzNpEr9G7Y00rpaWE9cw8FFxCXGzvtJAIYK+09hQ6a7HQZ
         Cx5V8n6PE+JQzL/FgdoPRW4YHVOR/2cE3AcpqA4ZAmP+yDsTKlVzz5OGyI23VKm7rwrl
         7vqhGDPQgsXELfMdwZsKZ42Phrd+DVWKS+kektkSG1CmSIBFzWWnUVL9L141NCtFGqui
         iJmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ZFMVImXUets2jfkQNpUykIw5epHF00Q0CGPGB40lqk=;
        b=P/0eCapwe0jn8Yf+dsvKS22r6cXjmovbqdNFSgtsZVjE+niH6oYzqrQX6HoTFV+glj
         DU/DOPZBH+CNGlj36pJC78yXaLKc3VhZpxGpJgUq+b0qGcp4lYPzPZBkIJ8aryzDooxS
         7vRJfVBqpM/tGAjq4LDvgmgDkMFSzrZo+bCHmny3v8SpBF12d07AAcNjxR+IDAxIeqrm
         B7PY9B/mDphjx6iEXFeOuciApgusZAPj+JD2ntugoQgbV5eWkMNFc9VCYXWd2LnAuttB
         23RYvGKaV8SZWNlKSiACFL3Kxy9xEdOmn4+GXqNWR3zBTEEwE+BMslizCy8hlyxzGuHp
         Dltw==
X-Gm-Message-State: AOAM5338AgEhgENB8c4YT9x8e/JqDZ1fO05XL8yEQB8tnqCeQ9ao84mA
        EYyYfDljy00bif9ybzH7DavGhZ6dB0y09KqM6ODaPnXNiBuYJA==
X-Google-Smtp-Source: ABdhPJw72RsfyTaf3kKynf7M94y0DW+oktJ25QvL7Xw/0UBdCNATum5+4bDe+DUFQI0iCCcpxOZzEFxaEjy4B6sRIJE=
X-Received: by 2002:a17:906:924a:: with SMTP id c10mr12422891ejx.85.1626268323559;
 Wed, 14 Jul 2021 06:12:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210713160957.3269017-1-ehabkost@redhat.com>
In-Reply-To: <20210713160957.3269017-1-ehabkost@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Wed, 14 Jul 2021 14:11:23 +0100
Message-ID: <CAFEAcA-9gi4KyLUU307UfE_NP+L9ujzrp-8ogL9OUBQGi7fXhg@mail.gmail.com>
Subject: Re: [PULL 00/11] x86 queue, 2021-07-13
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Jul 2021 at 17:19, Eduardo Habkost <ehabkost@redhat.com> wrote:
>
> Sorry for submitting this so late.  I had to deal with build
> issues caused by other patches (now removed from the queue).
>
> The following changes since commit eca73713358f7abb18f15c026ff4267b51746992:
>
>   Merge remote-tracking branch 'remotes/philmd/tags/sdmmc-20210712' into staging (2021-07-12 21:22:27 +0100)
>
> are available in the Git repository at:
>
>   https://gitlab.com/ehabkost/qemu.git tags/x86-next-pull-request
>
> for you to fetch changes up to 294aa0437b7f6a3e94653ef661310ef621859c87:
>
>   numa: Parse initiator= attribute before cpus= attribute (2021-07-13 09:21:01 -0400)
>
> ----------------------------------------------------------------
> x86 queue, 2021-07-13
>
> Bug fixes:
> * numa: Parse initiator= attribute before cpus= attribute
>   (Michal Privoznik)
> * Fix CPUID level for AMD (Zhenwei Pi)
> * Suppress CPUID leaves not defined by the CPU vendor
>   (Michael Roth)
>
> Cleanup:
> * Hyper-V feature handling cleanup (Vitaly Kuznetsov)
>


Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/6.1
for any user-visible changes.

-- PMM
