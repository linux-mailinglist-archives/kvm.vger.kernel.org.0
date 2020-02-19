Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C783A1647E2
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 16:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgBSPJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 10:09:37 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:42731 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbgBSPJh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 10:09:37 -0500
Received: from mail-qv1-f48.google.com ([209.85.219.48]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MTzjI-1iw9Fs2pJC-00R2Ku for <kvm@vger.kernel.org>; Wed, 19 Feb 2020
 16:09:34 +0100
Received: by mail-qv1-f48.google.com with SMTP id s7so313411qvn.8
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2020 07:09:34 -0800 (PST)
X-Gm-Message-State: APjAAAWQ0lhfvi5ivesPn9VuES59E58AMWUlinbny/dFwGz8eNFE4dz+
        Mogfwq0L1Fr/C1yb+CrDxaE//hP91eBl1WA055g=
X-Google-Smtp-Source: APXvYqy3rlxWW3PibWcS7Utz29Jg0Z9gTgANCeAjjrXu+xhh/WzI1/Ni7Mlpywm71HMgkez+fQvQf5f2uWJlSlHGL2o=
X-Received: by 2002:ad4:52eb:: with SMTP id p11mr20046350qvu.211.1582124973474;
 Wed, 19 Feb 2020 07:09:33 -0800 (PST)
MIME-Version: 1.0
References: <20200210141324.21090-1-maz@kernel.org>
In-Reply-To: <20200210141324.21090-1-maz@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 19 Feb 2020 16:09:17 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3V=ur4AgLfat2cSyw8GrkCS2t06eqkzC-gXcc0xBpEPw@mail.gmail.com>
Message-ID: <CAK8P3a3V=ur4AgLfat2cSyw8GrkCS2t06eqkzC-gXcc0xBpEPw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
To:     Marc Zyngier <maz@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm list <kvm@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Anders Berg <anders.berg@lsi.com>,
        jailhouse-dev@googlegroups.com,
        Jan Kiszka <jan.kiszka@siemens.com>,
        jean-philippe.brucker@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:JZuBSotjduPUFlWHaC4/TSdefDxJpbTAReB0icnKydiH/6azOyz
 FUmmt3Ar2XNODFCnqHwz7KHMlTKfO2PD5Qe7NrwBaTD5T8+l+pnI5RL2vfuw2xROPA7RB/F
 dHD1NqQef+AOJ12KNyz9xv66MkMUfDFzvaI/S5DOd3iXLPgjKd67d+oHh4CPh5f7ZiuUvQy
 OIMrhdVwajZCh8XhV29bQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0lzEHvi1agc=:XC/OS3OUiWfugpq8A3gVU9
 9bcdZJxPC2wCLcfKRTmS5y0v+Sfn90Ubu744AsSkYA3eIS2OQhyXIJbNpf6+wNv/aY8Azzuuk
 66WIxApAWzZKvinlED90LtaDcVhA3GJvqaqnXPBrjicbxpwHfpKERE2yP/DJh53F5ZdqovkN5
 bdBJ+2pzJ2Dc3Jrew2JoDgIgU/+UUycmkKnG1KzSoc75zBVJUtOyjbdhck8zEca7LUJwoa5bl
 U1QHYLcU6+hcV1Y/xqvdZE/d475SqIHXZlUZ2zq+5N2fIXM+9eA3tw87tu1EF1eAmdApkuant
 VQ90zs4sPaxPRs8SAoPsqobxh59KySj5NwMIcSyE0nyVr6Sl3RWZ1oF+HOtsIAkQ/TDDvtIvc
 dyVIjLRa10XeUHO8rjN3ReE4v+VivZ6nvqWT8yt5NmypGCF32vmfq0eg6ebrU1IpZAQiV3/qZ
 rk0NyQWmIGi/BLIlVPix43Y0iDj4TeO1Lwhm4G57DHLsnxdDFdjsJL+Px5ZGG8IbhtVlnzmOG
 rc9a/qMNUm8D7nZbjGsLVWNkJ3AmTkgBoDo0thpJ50zrOHO7mbOnGYMDvyKJ7abHURVwInKDL
 O3WHsCUSVbR2/JjF7y2tSXuICzdtnaGtajlxmX26fsuHm6zAAdN/IolyDo7S33rw6lEGajP5G
 qKKB+cgpda7ob04RauxHN2UjEBfwGtiaL/2v09WzizR2m1HqEMinB3WuOFvBWeHrb93x727ib
 IvT5mcFEmmpcYBvZOXXgjn1Mlg2M49VTdlTJVKVSTk8Yn1S06hS9cFZ84+83h8n0RAQD/Z6/K
 0lay6lD4uwhd1fg5QjHsYrC/vecGMTsY0ysYywIpwlsroHdjK0=
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

Just one more thought before it's gone: is there any shared code
(header files?) that is used by the jailhouse hypervisor?

If there is, are there any plans to merge that into the mainline kernel
for arm32 in the near future?

I'm guessing the answer to at least one of those questions is 'no', so
we don't need to worry about it, but it seems better to ask.

      Arnd
