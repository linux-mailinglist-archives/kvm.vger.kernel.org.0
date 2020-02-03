Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC641502FA
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 10:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgBCJJY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 04:09:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45398 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726853AbgBCJJX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 04:09:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580720962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=r9fxWWlEahNQ22mhQNSmY7IQqFx4Ff6A7HJS7S6T+SQ=;
        b=AU6oMYsIs0o6tkMN36SnSguHx5DQdEhQzcqFbMVuSQkBUnf2Edgfn3qGuPi05xpto8y0bQ
        9JBmiDQV8XzHHs29qFXqO6KmcF2cUAymmlDHEMgXL8pkvwlAezg0/1WlayBJfS70/u5u35
        rjqSuaaahnAnmimvTQ4oPPsFiCAWX64=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-kETJaCAZP4eWE84Y6UxxdA-1; Mon, 03 Feb 2020 04:09:21 -0500
X-MC-Unique: kETJaCAZP4eWE84Y6UxxdA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D1B21882CD2;
        Mon,  3 Feb 2020 09:09:20 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AED40165F7;
        Mon,  3 Feb 2020 09:09:13 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com
Subject: [PATCH v2 0/2] selftests: KVM: AMD Nested SVM test infrastructure
Date:   Mon,  3 Feb 2020 10:08:49 +0100
Message-Id: <20200203090851.19938-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the basic infrastructure needed to test AMD nested SVM.
Also add a first basic vmcall test.

Best regards

Eric

This series can be found at:
https://github.com/eauger/linux/tree/v5.5-amd-svm-v2

History:
v1 -> v2:
- split into 2 patches
- remove the infrastructure to run low-level sub-tests and only
  keep vmmcall's one.
- move struct regs into processor.h
- force vmcb_gpa into rax in run_guest()

Eric Auger (2):
  selftests: KVM: AMD Nested test infrastructure
  selftests: KVM: SVM: Add vmcall test

 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/include/x86_64/processor.h  |  20 +
 .../selftests/kvm/include/x86_64/svm.h        | 355 ++++++++++++++++++
 tools/testing/selftests/kvm/lib/x86_64/svm.c  | 211 +++++++++++
 .../selftests/kvm/x86_64/svm_vmcall_test.c    |  86 +++++
 5 files changed, 674 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/svm.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/svm.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c

--=20
2.20.1

