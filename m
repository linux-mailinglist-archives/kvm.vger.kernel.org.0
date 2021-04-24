Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3018236A027
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 10:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbhDXI0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Apr 2021 04:26:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48541 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233104AbhDXIZN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 24 Apr 2021 04:25:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619252641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JG5lz1zucN+SOqKs9Q0DF5YgOmDD8WYIPbDEuaJ2ii4=;
        b=bK9sRkrwrQw+ab3PI3IwOchfeVMuTox5T+OhPx/Ks4XHSMTy5UR/GVH2FUXvZc75G9XYsE
        GPpBgUE+eLZS9zoeysdS0ybkTrVmEHB3zoVIaugesqCqleuNjNcow4S5qI+LVVZJdCT4jZ
        JsoFF3wWIZk9xTKfL/K86uec6D2t7tk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-7EKwWYWbO6GMl3EdSzzoag-1; Sat, 24 Apr 2021 04:21:12 -0400
X-MC-Unique: 7EKwWYWbO6GMl3EdSzzoag-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C061343A2;
        Sat, 24 Apr 2021 08:21:11 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0DC55D6DC;
        Sat, 24 Apr 2021 08:21:10 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fix for 5.12 final
Date:   Sat, 24 Apr 2021 04:21:10 -0400
Message-Id: <20210424082110.1773621-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit bf05bf16c76bb44ab5156223e1e58e26dfe30a88:

  Linux 5.12-rc8 (2021-04-18 14:45:32 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 9c1a07442c95f6e64dc8de099e9f35ea73db7852:

  KVM: x86/xen: Take srcu lock when accessing kvm_memslots() (2021-04-23 17:00:50 -0400)

----------------------------------------------------------------
SRCU bug introduced in the merge window

----------------------------------------------------------------
Wanpeng Li (1):
      KVM: x86/xen: Take srcu lock when accessing kvm_memslots()

 arch/x86/kvm/x86.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

