Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C617240B4A8
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhINQbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:31:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229751AbhINQba (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 12:31:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631637012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ag6KQNj4Lbg/wmQWX818YyRR8lgEhCW5xp5AZuTE9fo=;
        b=i8qhuqHEPNamrPJqV4LYHhVj6H+fEXhINOHSI0WlOxmw4m3Mj9MMCGKb0j5WkFgWIRsOfi
        LIKTje2rOfLI6aIH/LALSldbJHu7zn4IoRtq4c0I/aiQ45P3zpe28kpdwQnph+YVnkl3ET
        VnHHP8O/72quxn2CZA7EXA4r/immH28=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-mJ-WG0wVMUuv0dj1Zvqizg-1; Tue, 14 Sep 2021 12:30:11 -0400
X-MC-Unique: mJ-WG0wVMUuv0dj1Zvqizg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 559EC800FF4
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 16:30:10 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79AC01972E;
        Tue, 14 Sep 2021 16:30:09 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/4] AMD's LBR test for nesting and few more fixes
Date:   Tue, 14 Sep 2021 19:30:04 +0300
Message-Id: <20210914163008.309356-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series adds a test for nested LBR usage=0D
on AMD, and few more things.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (4):=0D
  svm: add SVM_BARE_VMRUN=0D
  svm: intercept shutdown in all svm tests by default=0D
  few fixes for pmu_lbr test=0D
  svm: add tests for LBR virtualization=0D
=0D
 lib/x86/processor.h |   1 +=0D
 x86/pmu_lbr.c       |   8 ++=0D
 x86/svm.c           |  41 ++------=0D
 x86/svm.h           |  52 +++++++++-=0D
 x86/svm_tests.c     | 239 ++++++++++++++++++++++++++++++++++++++++++++=0D
 x86/unittests.cfg   |   1 +=0D
 6 files changed, 308 insertions(+), 34 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

