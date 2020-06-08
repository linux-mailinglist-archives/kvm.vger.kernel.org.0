Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413311F18BC
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 14:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbgFHM2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 08:28:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60701 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729752AbgFHM2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 08:28:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591619293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ClBDHBDktbLIW5J/z+Ht3YsS2xmoHHnGoFvx6CMwhtw=;
        b=CGmjLXtFwDoYABl2dcAvyD11d3SqPlnYPHOdf/BA+XuuqM86yyRVBWbaFm1D1F1kvO5QZ5
        XtpxItbXlo2rUuW/js/8FKLYMWPvx/2h486sEcOlxlMy1ima48qcrWx2RflriaASmfFJiq
        +Nx11HKWNi740WA9fxsb6AvKCowzq6M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-WOF0bhi7OyuMdL1nq3ePNg-1; Mon, 08 Jun 2020 08:28:04 -0400
X-MC-Unique: WOF0bhi7OyuMdL1nq3ePNg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74999107ACF2;
        Mon,  8 Jun 2020 12:28:02 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C69E57BFE3;
        Mon,  8 Jun 2020 12:28:01 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests 0/2] svm: INIT test and test_run on selected vcpu
Date:   Mon,  8 Jun 2020 08:27:58 -0400
Message-Id: <20200608122800.6315-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

INIT intercept test and the ability to execute test_run
on a selected vcpu.

Cathy Avery (2):
  svm: Add ability to execute test via test_run on a vcpu other than
    vcpu 0
  svm: INIT intercept test

 x86/svm.c       | 49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 x86/svm.h       | 13 +++++++++++++
 x86/svm_tests.c | 40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+), 1 deletion(-)

-- 
2.20.1

