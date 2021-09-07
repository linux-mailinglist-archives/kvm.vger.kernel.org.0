Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457DB402939
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 14:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344511AbhIGMxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 08:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbhIGMxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 08:53:10 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F37AC061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 05:52:04 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id c8-20020a7bc008000000b002e6e462e95fso1751703wmb.2
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 05:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wovuk/YJ4ZzxTgEM/WTOLuXvX25Yjntehj+QQBKkeck=;
        b=K76J8SyL+1jOA8UfApaeCDLxztO+LZ8h4Nx9PbBNYsr+paYOiEqK9OIn2ldFs+7jzC
         YEttCcgHMvN3u1/0AVrT+pgr4UyIN1fY0TWDjPrCpijQjVadGHS6qCJxNRMRydMpbkpe
         vklWQApsPXT85SJjEbrr4whDc3f1MVpzfNFQ7ks6sAhOJgokRCkk4axYWPqo9Gq8UOEF
         jTjR2dGFy5N5XLZ6yElzSZACsjQFOUeQqAW9Htb6vbipQslVAql4L3mbDnFLy8aIY//W
         PjA+HrI7kjxQ45KDdftoS1ecm4AaCZ37azSPgx8Nz0Y44zMdL0lD1CCofVVAd3cPXEKz
         fYsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wovuk/YJ4ZzxTgEM/WTOLuXvX25Yjntehj+QQBKkeck=;
        b=s09m8162lysf2dMi2graipTo2psQGi9nlWCS9nDaAJt3AHoulTwe+KFGkmRXQ1cgMf
         vseQ7nUc0PGvNSysysnFDwFTWafG5lbYdmqmJPXPa8OxeY7kdXruylCAB38cAcpDtNYk
         cgCf7Y70GRSyyTkLANBf9EkjxsVQKcrn8nhtVu8ZSsPCcQ0ny56eXsKEtTKdgyS41SeV
         ZE6+BYpWr+d1/yDgWajM5LGziBE4tijRD0gyzybxsAsc/FQHLpTpWwdPG9WdRXrn6lI6
         QjHglmztHym2m/4VOVzwEZ2w0OyMR6FrMMjxgWSzTVg2ZAT+rqDAf4fRB1PBj7cZIax+
         Hp2Q==
X-Gm-Message-State: AOAM530Fbf7fahEWM1btiKTuZcgr8lTjw31nQjoN5J5ciXvOHbT0dK7X
        BVPQJb6GjqirU1hK4X+TAfOc8edgLbsbkIL8Q4rgU6jdbXc=
X-Google-Smtp-Source: ABdhPJzN1k5vdacf8pXMz+PcUOlliO8oElhlm9+Wxx2tO4deEucQ0q5nA8yws4gRRyTPG0HwiEfKkeMxeGbJ78NSUUM=
X-Received: by 2002:a05:600c:4fcd:: with SMTP id o13mr3850083wmq.32.1631019122955;
 Tue, 07 Sep 2021 05:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210822144441.1290891-1-maz@kernel.org> <20210822144441.1290891-4-maz@kernel.org>
In-Reply-To: <20210822144441.1290891-4-maz@kernel.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 7 Sep 2021 13:51:13 +0100
Message-ID: <CAFEAcA_J5W6kaaZ-oYtcRcQ5=z5nFv6bOVVu5n_ad0N8-NGzpg@mail.gmail.com>
Subject: Re: [PATCH 3/3] docs/system/arm/virt: Fix documentation for the
 'highmem' option
To:     Marc Zyngier <maz@kernel.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        kvmarm <kvmarm@lists.cs.columbia.edu>,
        kvm-devel <kvm@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 22 Aug 2021 at 15:45, Marc Zyngier <maz@kernel.org> wrote:
>
> The documentation for the 'highmem' option indicates that it controls
> the placement of both devices and RAM. The actual behaviour of QEMU
> seems to be that RAM is allowed to go beyond the 4GiB limit, and
> that only devices are constraint by this option.
>
> Align the documentation with the actual behaviour.

I think it would be better to align the behaviour with the documentation.

The intent of 'highmem' is to allow a configuration for use with guests
that can't address more than 32 bits (originally, 32-bit guests without
LPAE support compiled in). It seems like a bug that we allow the user
to specify more RAM than will fit into that 32-bit range. We should
instead make QEMU exit with an error if the user tries to specify
both highmem=off and a memory size that's too big to fit.

thanks
-- PMM
