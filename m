Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3092674BD
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 19:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfGLRy2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 13:54:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33360 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbfGLRy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 13:54:28 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1884A3E2CD;
        Fri, 12 Jul 2019 17:54:28 +0000 (UTC)
Received: from work-vm (ovpn-117-214.ams2.redhat.com [10.36.117.214])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A3DCF601B7;
        Fri, 12 Jul 2019 17:54:22 +0000 (UTC)
Date:   Fri, 12 Jul 2019 18:54:20 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Juan Quintela <quintela@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [Qemu-devel] [PULL 00/19] Migration patches
Message-ID: <20190712175420.GO2730@work-vm>
References: <20190712143207.4214-1-quintela@redhat.com>
 <CAFEAcA-ydNS072OH7CyGNq2+sESgonW-8QSJdNYJq6zW-rYjUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA-ydNS072OH7CyGNq2+sESgonW-8QSJdNYJq6zW-rYjUQ@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 12 Jul 2019 17:54:28 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Peter Maydell (peter.maydell@linaro.org) wrote:
> On Fri, 12 Jul 2019 at 15:32, Juan Quintela <quintela@redhat.com> wrote:
> >
> > The following changes since commit a2a9d4adabe340617a24eb73a8b2a116d28a6b38:
> >
> >   Merge remote-tracking branch 'remotes/dgibson/tags/ppc-for-4.1-20190712' into staging (2019-07-12 11:06:48 +0100)
> >
> > are available in the Git repository at:
> >
> >   https://github.com/juanquintela/qemu.git tags/migration-pull-request
> >
> > for you to fetch changes up to a48ad5602f496236b4e1955d9e2e8228a7d0ad56:
> >
> >   migration: allow private destination ram with x-ignore-shared (2019-07-12 16:25:59 +0200)
> >
> > ----------------------------------------------------------------
> > Migration pull request
> >
> > Fix the issues with the previous pull request and 32 bits.
> >
> > Please apply.
> >
> 
> Still fails on aarch32 host, I'm afraid:
> 
> MALLOC_PERTURB_=${MALLOC_PERTURB_:-$(( ${RANDOM:-0} % 255 + 1))}
> QTEST_QEMU_BINARY=aarch64-softmmu/qemu-system-aarch64
> QTEST_QEMU_IMG=qemu-img tests/migration-test -m=quick -k --tap <
> /dev/null | ./scripts/tap-driver.pl --test-name="migration-test"
> PASS 1 migration-test /aarch64/migration/deprecated
> PASS 2 migration-test /aarch64/migration/bad_dest
> PASS 3 migration-test /aarch64/migration/fd_proto
> PASS 4 migration-test /aarch64/migration/postcopy/unix
> PASS 5 migration-test /aarch64/migration/postcopy/recovery
> PASS 6 migration-test /aarch64/migration/precopy/unix
> PASS 7 migration-test /aarch64/migration/precopy/tcp
> PASS 8 migration-test /aarch64/migration/xbzrle/unix
> malloc(): memory corruption
> Broken pipe
> qemu-system-aarch64: load of migration failed: Invalid argument
> /home/peter.maydell/qemu/tests/libqtest.c:137: kill_qemu() tried to
> terminate QEMU process but encountered exit status 1
> Aborted
> ERROR - too few tests run (expected 9, got 8)
> /home/peter.maydell/qemu/tests/Makefile.include:899: recipe for target
> 'check-qtest-aarch64' failed

Hmm, I think the only one to go near xbzrle specifically is
'migration/xbzrle: update cache and current_data in one place'

it did look right to me; but that is a subtle function so hmmmm.

Dave

> 
> thanks
> -- PMM
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
