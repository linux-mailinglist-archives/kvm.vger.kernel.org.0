Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAAAF72BD4
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 11:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfGXJzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 05:55:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfGXJzg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 05:55:36 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5B00B30C1341;
        Wed, 24 Jul 2019 09:55:36 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-189.ams2.redhat.com [10.36.116.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28BEB60BEC;
        Wed, 24 Jul 2019 09:55:32 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: [PATCH 0/4] migration: fix migrate_cancel problems of multifd
Date:   Wed, 24 Jul 2019 11:55:19 +0200
Message-Id: <20190724095523.1527-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 24 Jul 2019 09:55:36 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Just simplify patch 2 from Ivan
- Add patch 3 to cover everything.

Please review.

My plan is send the three of them for the update

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

