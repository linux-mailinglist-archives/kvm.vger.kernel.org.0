Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D9374C46
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 12:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390119AbfGYK5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 06:57:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58028 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389859AbfGYK5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 06:57:30 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2679A30821B3;
        Thu, 25 Jul 2019 10:57:30 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-190.ams2.redhat.com [10.36.117.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40A7C19C7F;
        Thu, 25 Jul 2019 10:57:27 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: [PULL 0/4] Migration patches
Date:   Thu, 25 Jul 2019 12:57:20 +0200
Message-Id: <20190725105724.2562-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 25 Jul 2019 10:57:30 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit bf8b024372bf8abf5a9f40bfa65eeefad23ff988:

  Update version for v4.1.0-rc2 release (2019-07-23 18:28:08 +0100)

are available in the Git repository at:

  https://github.com/juanquintela/qemu.git tags/migration-pull-request

for you to fetch changes up to f193bc0c5342496ce07355c0c30394560a7f4738:

  migration: fix migrate_cancel multifd migration leads destination hung forever (2019-07-24 14:47:21 +0200)

----------------------------------------------------------------
Migration pull request

This series fixes problems with migration-cancel while using multifd.
In some cases it can hang waiting in a semaphore.

Please apply.

----------------------------------------------------------------

Ivan Ren (3):
  migration: fix migrate_cancel leads live_migration thread endless loop
  migration: fix migrate_cancel leads live_migration thread hung forever
  migration: fix migrate_cancel multifd migration leads destination hung
    forever

Juan Quintela (1):
  migration: Make explicit that we are quitting multifd

 migration/ram.c | 66 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 57 insertions(+), 9 deletions(-)

-- 
2.21.0

