Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEB0D67357
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 18:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfGLQeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 12:34:06 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35584 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbfGLQeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 12:34:05 -0400
Received: by mail-ot1-f68.google.com with SMTP id j19so10058565otq.2
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2019 09:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8M9k3vaoESH9FTV02BiV6DPoDuMicpuNdRGJ4JunVi0=;
        b=VRH0PzxukwZZ+q7SG4lesnPsEkQYk3CxXfe3harpH8lzCZeXV4gpRliZeLYOdw+y28
         Z8Gua50+IjaG8uj2/pLHEnhV9e3p6nx40gaM/MrFsZiyLuwQmJlAdOLzDyMpLpaOx5ao
         ZpXO0NWHcVj7dNxXrERHhuAPH6syIYeBFyWhnO+GC8JFsynMwVIWMxMkktdWGfEYekGM
         eLfaaOEYa3l8kovhYifwOmZ6pEXu4I7wEUUx5HIfSWpEw8/dSa1iNgctZAkVxjUeTCh2
         cYVhchpkObSqe+ZwpY/ncQ3sqRBRVoipy+b2RMrg53EDCnNqPcu+kVVCVkZR5COIpF5k
         y7uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8M9k3vaoESH9FTV02BiV6DPoDuMicpuNdRGJ4JunVi0=;
        b=Y+Lsnt5gZv+ge2BaSlR2DsX7p0vIFnUFWnJV7VWZ4RhAbzxLD8Qr1TTkjbL2kFYmMv
         /0QodyoAYV4Uk8v63b8LAGzmRlKsND08Ap7KgjF45Id4cThKeHqMtmSEvffqEICA1KgF
         TvE8HowE5MfcnYQRKJlGJyWffCBmV9STJ7C7DTPS2t/51bRH4rc5kRH/O22YZ2SCF821
         IFWGZXzfOOkwsFOxg19zzPedBaiBhtqymPN+qks4s6UgxwofaNcT7iPH57uZbccmmuBT
         6/0Hng+HGi8WfVbMtqGIFXgliz50kWsEvuP+60qcapDIJbSax1b041ExPkx5eqxtz6BS
         jV2w==
X-Gm-Message-State: APjAAAV99XjmAjx+yK/7jjL1OVTlAcvQQtQQ2eTrdhOoX1jXBntBWgI4
        NwYRoMw7BZU1wctTM489b/v26NANDwS+ULQhpLhcxQ==
X-Google-Smtp-Source: APXvYqylwE8qWDgRFiXH/TgR4x9jB931lqPFqDQHpf/AJqOkaw45guOK47bJolGjBLdqpPmh1AtBjSlVnMIlz4mVlfI=
X-Received: by 2002:a9d:711e:: with SMTP id n30mr8725936otj.97.1562949245064;
 Fri, 12 Jul 2019 09:34:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190712143207.4214-1-quintela@redhat.com>
In-Reply-To: <20190712143207.4214-1-quintela@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 12 Jul 2019 17:33:54 +0100
Message-ID: <CAFEAcA-ydNS072OH7CyGNq2+sESgonW-8QSJdNYJq6zW-rYjUQ@mail.gmail.com>
Subject: Re: [Qemu-devel] [PULL 00/19] Migration patches
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

On Fri, 12 Jul 2019 at 15:32, Juan Quintela <quintela@redhat.com> wrote:
>
> The following changes since commit a2a9d4adabe340617a24eb73a8b2a116d28a6b38:
>
>   Merge remote-tracking branch 'remotes/dgibson/tags/ppc-for-4.1-20190712' into staging (2019-07-12 11:06:48 +0100)
>
> are available in the Git repository at:
>
>   https://github.com/juanquintela/qemu.git tags/migration-pull-request
>
> for you to fetch changes up to a48ad5602f496236b4e1955d9e2e8228a7d0ad56:
>
>   migration: allow private destination ram with x-ignore-shared (2019-07-12 16:25:59 +0200)
>
> ----------------------------------------------------------------
> Migration pull request
>
> Fix the issues with the previous pull request and 32 bits.
>
> Please apply.
>

Still fails on aarch32 host, I'm afraid:

MALLOC_PERTURB_=${MALLOC_PERTURB_:-$(( ${RANDOM:-0} % 255 + 1))}
QTEST_QEMU_BINARY=aarch64-softmmu/qemu-system-aarch64
QTEST_QEMU_IMG=qemu-img tests/migration-test -m=quick -k --tap <
/dev/null | ./scripts/tap-driver.pl --test-name="migration-test"
PASS 1 migration-test /aarch64/migration/deprecated
PASS 2 migration-test /aarch64/migration/bad_dest
PASS 3 migration-test /aarch64/migration/fd_proto
PASS 4 migration-test /aarch64/migration/postcopy/unix
PASS 5 migration-test /aarch64/migration/postcopy/recovery
PASS 6 migration-test /aarch64/migration/precopy/unix
PASS 7 migration-test /aarch64/migration/precopy/tcp
PASS 8 migration-test /aarch64/migration/xbzrle/unix
malloc(): memory corruption
Broken pipe
qemu-system-aarch64: load of migration failed: Invalid argument
/home/peter.maydell/qemu/tests/libqtest.c:137: kill_qemu() tried to
terminate QEMU process but encountered exit status 1
Aborted
ERROR - too few tests run (expected 9, got 8)
/home/peter.maydell/qemu/tests/Makefile.include:899: recipe for target
'check-qtest-aarch64' failed


thanks
-- PMM
