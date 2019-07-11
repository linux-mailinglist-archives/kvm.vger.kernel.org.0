Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1E35655CA
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 13:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbfGKLeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 07:34:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728026AbfGKLeJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 07:34:09 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9B882308FC23;
        Thu, 11 Jul 2019 11:34:08 +0000 (UTC)
Received: from work-vm (unknown [10.36.118.40])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2195219C69;
        Thu, 11 Jul 2019 11:34:06 +0000 (UTC)
Date:   Thu, 11 Jul 2019 12:34:04 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Juan Quintela <quintela@redhat.com>, qemu-devel@nongnu.org,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PULL 00/19] Migration patches
Message-ID: <20190711113404.GK3971@work-vm>
References: <20190711104412.31233-1-quintela@redhat.com>
 <c2bfa537-8a5a-86a1-495c-a6c1d0f85dc5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2bfa537-8a5a-86a1-495c-a6c1d0f85dc5@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 11 Jul 2019 11:34:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Paolo Bonzini (pbonzini@redhat.com) wrote:
> On 11/07/19 12:43, Juan Quintela wrote:
> > The following changes since commit 6df2cdf44a82426f7a59dcb03f0dd2181ed7fdfa:
> > 
> >   Update version for v4.1.0-rc0 release (2019-07-09 17:21:53 +0100)
> > 
> > are available in the Git repository at:
> > 
> >   https://github.com/juanquintela/qemu.git tags/migration-pull-request
> > 
> > for you to fetch changes up to 0b47e79b3d04f500b6f3490628905ec5884133df:
> > 
> >   migration: allow private destination ram with x-ignore-shared (2019-07-11 12:30:40 +0200)
> 
> Aren't we in hard freeze already?

They were all sent and review-by long before the freeze.
This pull got stuck though; the original version of the pull was also
sent before the freeze but some stuff has got added.

Dave

> Paolo
> 
> > ----------------------------------------------------------------
> > Migration pull request
> > 
> > ----------------------------------------------------------------
> > 
> > Juan Quintela (3):
> >   migration: fix multifd_recv event typo
> >   migration-test: rename parameter to parameter_int
> >   migration-test: Add migration multifd test
> > 
> > Peng Tao (1):
> >   migration: allow private destination ram with x-ignore-shared
> > 
> > Peter Xu (10):
> >   migration: No need to take rcu during sync_dirty_bitmap
> >   memory: Don't set migration bitmap when without migration
> >   bitmap: Add bitmap_copy_with_{src|dst}_offset()
> >   memory: Pass mr into snapshot_and_clear_dirty
> >   memory: Introduce memory listener hook log_clear()
> >   kvm: Update comments for sync_dirty_bitmap
> >   kvm: Persistent per kvmslot dirty bitmap
> >   kvm: Introduce slots lock for memory listener
> >   kvm: Support KVM_CLEAR_DIRTY_LOG
> >   migration: Split log_clear() into smaller chunks
> > 
> > Wei Yang (5):
> >   migration/multifd: call multifd_send_sync_main when sending
> >     RAM_SAVE_FLAG_EOS
> >   migration/xbzrle: update cache and current_data in one place
> >   cutils: remove one unnecessary pointer operation
> >   migration/multifd: sync packet_num after all thread are done
> >   migratioin/ram.c: reset complete_round when we gets a queued page
> > 
> >  accel/kvm/kvm-all.c          |  260 +-
> >  accel/kvm/trace-events       |    1 +
> >  exec.c                       |   15 +-
> >  include/exec/memory.h        |   19 +
> >  include/exec/memory.h.rej    |   26 +
> >  include/exec/ram_addr.h      |   92 +-
> >  include/exec/ram_addr.h.orig |  488 ++++
> >  include/qemu/bitmap.h        |    9 +
> >  include/sysemu/kvm_int.h     |    4 +
> >  memory.c                     |   56 +-
> >  memory.c.rej                 |   17 +
> >  migration/migration.c        |    4 +
> >  migration/migration.h        |   27 +
> >  migration/migration.h.orig   |  315 +++
> >  migration/ram.c              |   93 +-
> >  migration/ram.c.orig         | 4599 ++++++++++++++++++++++++++++++++++
> >  migration/ram.c.rej          |   33 +
> >  migration/trace-events       |    3 +-
> >  migration/trace-events.orig  |  297 +++
> >  tests/Makefile.include       |    2 +
> >  tests/migration-test.c       |  103 +-
> >  tests/test-bitmap.c          |   72 +
> >  util/bitmap.c                |   85 +
> >  util/cutils.c                |    8 +-
> >  24 files changed, 6545 insertions(+), 83 deletions(-)
> >  create mode 100644 include/exec/memory.h.rej
> >  create mode 100644 include/exec/ram_addr.h.orig
> >  create mode 100644 memory.c.rej
> >  create mode 100644 migration/migration.h.orig
> >  create mode 100644 migration/ram.c.orig
> >  create mode 100644 migration/ram.c.rej
> >  create mode 100644 migration/trace-events.orig
> >  create mode 100644 tests/test-bitmap.c
> > 
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
