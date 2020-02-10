Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F349D157EC5
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 16:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbgBJPcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 10:32:00 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:37796 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727363AbgBJPcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 10:32:00 -0500
Received: by mail-il1-f194.google.com with SMTP id v13so559836iln.4
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 07:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lixom-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rJKu0curXNDiIv07BXA7ZVrF2bICC0+Hs2nUqvpWWBE=;
        b=CAXc09ubXS9ZFxUmd/SbvlfA3zsu6fw84nPAia6Y37IBnkkixzVnQQ1DvPc4gVvSDy
         W6Uq5WrNvmHIM9pR9ez7FYUhIv6XdEX9GEwY2rJl2vY33gTufoWhbjwUcACu+BIPxG5G
         bAgK1f8xNqN/VhPHCmGFF+SDEbTzUji36h+YGdbhQmDJdX3HrBJ3fQ7RFH6TSmczTUaI
         l8Lh7ZdUVtAyloybvuqg1r1VSaZqNUt/8vLmi/SyTQGmfdOyC29Tgxf2X4u9kYNOUF8c
         D8wdvnGGssR7+hgN4BP19DR9Am1ylWfvoMD4pA/mEq3/e3yQTNmVwZHuB6JEdy2D62Br
         iXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rJKu0curXNDiIv07BXA7ZVrF2bICC0+Hs2nUqvpWWBE=;
        b=Ccch2cHJgZRVjt1nrc4/VWF7YU5wBfgvvPNmwSxowhhCZTXXUhlTwok/BlOdGZ/Kg7
         JJJYJBeBLiUARjaKAJ4N4RaKlMynUNZzNyAbeSRKCIeKkOcW4xau2bAiWL/KJKHByjQt
         QErf1f8L2PVlfpS5SmKQIDR4kLM3lOgQKuRbXlOx//KoH8Ta9P53DahF4MA4wAJ1C4zJ
         FmpxbiGLJMK6M0aZsn6yjeEKSMVRbpOnG6SkcODpzTsH6Igk6FWXnusslqdt9Mc6pkFl
         QMrNn1XrCSi04I3NdFl4WpiGqdDzU7ExWUmIRjqxFyxCLttc9h7eLfgpQYQkvXDyAg9X
         n/8g==
X-Gm-Message-State: APjAAAUvpMKcMqjLQOqS1VT11RsFhP4mUd8+J73//MnOoidYX9/nZw3Y
        oFJ4OLto0DwtW3zV6nSwvNelW7qdykSlZlffMirytQ==
X-Google-Smtp-Source: APXvYqxYx29kgSFceIBbFGWRItTIbjo6m8Fbpp5JsPt65w5bFXVn9ceiixXHhUS3KHfAZHhdKoQKoj4ONXPF4oZheGk=
X-Received: by 2002:a92:9f1a:: with SMTP id u26mr1986348ili.72.1581348719752;
 Mon, 10 Feb 2020 07:31:59 -0800 (PST)
MIME-Version: 1.0
References: <20200210141324.21090-1-maz@kernel.org>
In-Reply-To: <20200210141324.21090-1-maz@kernel.org>
From:   Olof Johansson <olof@lixom.net>
Date:   Mon, 10 Feb 2020 16:21:42 +0100
Message-ID: <CAOesGMhHkez-5vxwWuzXc2Rm=dYYWjMX9C8AewVy9GDWuZcwMw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
To:     Marc Zyngier <maz@kernel.org>
Cc:     Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Anders Berg <anders.berg@lsi.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Quentin Perret <qperret@google.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 10, 2020 at 3:13 PM Marc Zyngier <maz@kernel.org> wrote:
>
> KVM/arm was merged just over 7 years ago, and has lived a very quiet
> life so far. It mostly works if you're prepared to deal with its
> limitations, it has been a good prototype for the arm64 version,
> but it suffers a few problems:
>
> - It is incomplete (no debug support, no PMU)
> - It hasn't followed any of the architectural evolutions
> - It has zero users (I don't count myself here)
> - It is more and more getting in the way of new arm64 developments
>
> So here it is: unless someone screams and shows that they rely on
> KVM/arm to be maintained upsteam, I'll remove 32bit host support
> form the tree. One of the reasons that makes me confident nobody is
> using it is that I never receive *any* bug report. Yes, it is perfect.
> But if you depend on KVM/arm being available in mainline, please shout.
>
> To reiterate: 32bit guest support for arm64 stays, of course. Only
> 32bit host goes. Once this is merged, I plan to move virt/kvm/arm to
> arm64, and cleanup all the now unnecessary abstractions.
>
> The patches have been generated with the -D option to avoid spamming
> everyone with huge diffs, and there is a kvm-arm/goodbye branch in
> my kernel.org repository.
>
> Marc Zyngier (5):
>   arm: Unplug KVM from the build system
>   arm: Remove KVM from config files
>   arm: Remove 32bit KVM host support
>   arm: Remove HYP/Stage-2 page-table support
>   arm: Remove GICv3 vgic compatibility macros

Since I'm generally happy to drop legacy code that has no users, with
the "if there are any significant users that speak up, I'll revoke my
support" caveat:

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
