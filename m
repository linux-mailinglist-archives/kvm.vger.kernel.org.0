Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85F0B1869A3
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 12:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbgCPLBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 07:01:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41831 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730694AbgCPLBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 07:01:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584356501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=N1jC2/AWjvaBo55ZEMscSwgEbXB+R/Dg9FugHDbXi9g=;
        b=biZ+sRUpDPl+n5Qne85dgB6wHy0cFQg+Fcp7q6q6PW321Ia0uHqrno/hlf4CC4UHAsBK+7
        EIHCmQneoNb/qKy3l6Tb+ykN23ki8+PkzzbVi5YE/W2aePbqJvPqCDCuYS+/1PTeIBC/lA
        QZtSXPpOyEw4tJWAeicYVhuN9y9h/5A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-DsIelGcpMkSRR6--wvCuwA-1; Mon, 16 Mar 2020 07:01:39 -0400
X-MC-Unique: DsIelGcpMkSRR6--wvCuwA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5BB2107B119
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 11:01:38 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-204-240.brq.redhat.com [10.40.204.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E59C95E240;
        Mon, 16 Mar 2020 11:01:37 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 0/2] KVM: selftests: steal_time cleanups and timespec rework
Date:   Mon, 16 Mar 2020 12:01:34 +0100
Message-Id: <20200316110136.31326-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first patch is a couple changes to steal_time that came to mind
after posting. The second one reworks the timespec functions and
their use. It then applies them to the fixing of the stop condition
of steal_time:do_steal_time

Andrew Jones (2):
  fixup! KVM: selftests: Introduce steal-time test
  KVM: selftests: Rework timespec functions and usage

 .../selftests/kvm/demand_paging_test.c        | 37 +++++++---------
 .../testing/selftests/kvm/include/test_util.h |  3 +-
 tools/testing/selftests/kvm/lib/test_util.c   | 42 +++++++++++--------
 tools/testing/selftests/kvm/steal_time.c      | 39 ++++++++---------
 4 files changed, 60 insertions(+), 61 deletions(-)

--=20
2.21.1

