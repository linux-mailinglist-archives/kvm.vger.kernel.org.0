Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8234F17079
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 07:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfEHFoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 01:44:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51706 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727194AbfEHFoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 01:44:08 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E349430833B5
        for <kvm@vger.kernel.org>; Wed,  8 May 2019 05:44:08 +0000 (UTC)
Received: from xz-x1.nay.redhat.com (dhcp-15-205.nay.redhat.com [10.66.15.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3240600D4;
        Wed,  8 May 2019 05:44:04 +0000 (UTC)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        peterx@redhat.com, "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH 0/2] kvm: Some more trivial fixes for clear dirty log
Date:   Wed,  8 May 2019 13:44:01 +0800
Message-Id: <20190508054403.7277-1-peterx@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 08 May 2019 05:44:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two issues I've noticed when I'm drafting the QEMU support of it.
With these two patches applied the QEMU binary (with the clear dirty
log supported [1]) can migrate correctly otherwise the migration can
stall forever if with/after heavy memory workload.

Please have a look, thanks.

[1] https://github.com/xzpeter/qemu/tree/kvm-clear-dirty-log

Peter Xu (2):
  kvm: Fix the bitmap range to copy during clear dirty
  kvm: Fix loop of clear dirty with off-by-one

 virt/kvm/kvm_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.17.1

