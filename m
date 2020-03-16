Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1371871C6
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 18:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732232AbgCPR7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 13:59:49 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:34836 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730437AbgCPR7t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 13:59:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584381588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0YiQO4coq/kq6AWRYGg1EQj7mM3S8BzHCJuadCYG5Uw=;
        b=UCS0cKYGRkGak/RiBcTo1ZKvhCEBhPbwY3E6Xi6SiEh5MpM2N6zJOuvS0SGdqs7awnelBs
        kQAaUIqtOGcYZU8ET+LWMbq0l1idLTQsN2cjRcdAISzotD6ninMy4Ze/KBaOwcplHye8Mf
        fxxI7P/sxGzyzHITZMN0pyAtaaWP8Eg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-ysGXlS5BMFK639s8Fde17A-1; Mon, 16 Mar 2020 13:59:47 -0400
X-MC-Unique: ysGXlS5BMFK639s8Fde17A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 697A4921923
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 17:37:12 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-204-240.brq.redhat.com [10.40.204.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AC797E304;
        Mon, 16 Mar 2020 17:37:11 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH v2 0/2] KVM: selftests: steal_time cleanups and timespec rework
Date:   Mon, 16 Mar 2020 18:37:01 +0100
Message-Id: <20200316173703.12785-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first patch is a couple changes to steal_time that came to mind
after posting. The second one reworks the timespec functions and
their use. It then applies them to the fixing of the stop condition
of steal_time:do_steal_time

v2:
 - Drank a cup of coffee and discovered division... Use division instead
   of loop in timespec_add_ns.

Andrew Jones (2):
  fixup! KVM: selftests: Introduce steal-time test
  KVM: selftests: Rework timespec functions and usage

 .../selftests/kvm/demand_paging_test.c        | 37 ++++++++----------
 .../testing/selftests/kvm/include/test_util.h |  3 +-
 tools/testing/selftests/kvm/lib/test_util.c   | 37 ++++++++----------
 tools/testing/selftests/kvm/steal_time.c      | 39 +++++++++----------
 4 files changed, 52 insertions(+), 64 deletions(-)

--=20
2.21.1

