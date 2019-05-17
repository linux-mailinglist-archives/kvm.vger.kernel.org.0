Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C427218C4
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 15:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbfEQNDI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 09:03:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43632 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728664AbfEQNDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 09:03:08 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 351EE75724;
        Fri, 17 May 2019 13:03:08 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.40.205.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 548C86C35A;
        Fri, 17 May 2019 13:03:06 +0000 (UTC)
From:   Laurent Vivier <lvivier@redhat.com>
To:     =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Subject: [kvm-unit-tests PULL 0/2] Ppc next patches
Date:   Fri, 17 May 2019 15:03:03 +0200
Message-Id: <20190517130305.32123-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 17 May 2019 13:03:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 14bc602f3479d3f5c5e11034daa1070c61bd5640:

  Merge tag 'pull-request-2019-04-19' of https://gitlab.com/huth/kvm-unit-tests (2019-05-03 10:53:30 -0600)

are available in the Git repository at:

  https://github.com/vivier/kvm-unit-tests.git tags/ppc-next-pull-request

for you to fetch changes up to aa3a3a9e6654fce23a78141c8cfadcd6ba871af1:

  powerpc: Make h_cede_tm test run by default (2019-05-17 13:50:47 +0200)

----------------------------------------------------------------
Fix h_cede_tm timeout

----------------------------------------------------------------

Suraj Jitindar Singh (2):
  powerpc: Allow for a custom decr value to be specified to load on decr
    excp
  powerpc: Make h_cede_tm test run by default

 lib/powerpc/handlers.c | 7 ++++---
 powerpc/sprs.c         | 3 ++-
 powerpc/tm.c           | 4 +++-
 powerpc/unittests.cfg  | 2 +-
 4 files changed, 10 insertions(+), 6 deletions(-)

-- 
2.20.1

