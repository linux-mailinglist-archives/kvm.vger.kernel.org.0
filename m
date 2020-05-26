Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63C21A8C01
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 22:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731089AbgDNULl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 16:11:41 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54399 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2632743AbgDNULR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 16:11:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586895076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xeep/J8xI+LK6UPyUtnwUk8kuNhohlFBWm/FMlc2jnk=;
        b=dz/boa2knLQWYLytWrVwWQubQVYsEJPHnRRHZx1yc+r00n7yA5Hy2H9knvbD8SF2Jayon2
        RQzRiMCm/4TQhmtQ6fxYzYsaKtcMe2a7WGawYhP34a8yw41fwh0XLGjTI8GuhO9WBt9Qva
        wp9iIi9prRTtc20Vb7ehimL9JK5vMDw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-SJqVODYlPQ-l1RXsl6frEg-1; Tue, 14 Apr 2020 16:11:12 -0400
X-MC-Unique: SJqVODYlPQ-l1RXsl6frEg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6395D18C8C0F;
        Tue, 14 Apr 2020 20:11:11 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-113-69.rdu2.redhat.com [10.10.113.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDC3C5DA66;
        Tue, 14 Apr 2020 20:11:07 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     vkuznets@redhat.com, wei.huang2@amd.com
Subject: [PATCH 0/2] KVM: SVM: Implement check_nested_events for NMI 
Date:   Tue, 14 Apr 2020 16:11:05 -0400
Message-Id: <20200414201107.22952-1-cavery@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Moved nested NMI exit to new check_nested_events.
The second patch fixes the NMI pending race condition that now occurs.

Cathy Avery (2):
  KVM: SVM: Implement check_nested_events for NMI
  KVM: x86: check_nested_events if there is an injectable NMI

 arch/x86/kvm/svm/nested.c | 21 +++++++++++++++++++++
 arch/x86/kvm/svm/svm.c    |  2 +-
 arch/x86/kvm/svm/svm.h    | 15 ---------------
 arch/x86/kvm/x86.c        | 15 +++++++++++----
 4 files changed, 33 insertions(+), 20 deletions(-)

--=20
2.20.1

