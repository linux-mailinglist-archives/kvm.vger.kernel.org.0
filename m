Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64F7497D3F
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 11:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbiAXKgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 05:36:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37634 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229780AbiAXKgc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 05:36:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643020591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UKn93GIriBykyDUhEngP6ygHxuNZ7nluHC+n+0s/MB0=;
        b=RD5MLZMALFzakAsYXtyEySSBqjv4P6NthQKQLpMm7nK2J5DLB8fGOENILfyelijOFoztFz
        4e73LWyco0LJKSR+LGlUaj3N746lOtp/LghfsK+5YNmPU8/5J7tyHsUuYEd2HP0kTrfNo4
        yxjT8BzLlu0E1AMmUGaJvm+6W43m8Ss=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-4wujMb-rPhSX6JX37bz25g-1; Mon, 24 Jan 2022 05:36:28 -0500
X-MC-Unique: 4wujMb-rPhSX6JX37bz25g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFE5A1006AA9;
        Mon, 24 Jan 2022 10:36:25 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BD061F319;
        Mon, 24 Jan 2022 10:36:07 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: x86: Partially allow KVM_SET_CPUID{,2} follow-up
Date:   Mon, 24 Jan 2022 11:36:04 +0100
Message-Id: <20220124103606.2630588-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"[PATCH v3 0/4] KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN
 for CPU hotplug" got merged but v4 had some important improvements:
- Fix for SGX enabled CPUs
- Also check .flags in kvm_cpuid_check_equal().
Sending these out separately.

Vitaly Kuznetsov (2):
  KVM: x86: Move CPUID.(EAX=0x12,ECX=1) mangling to
    __kvm_update_cpuid_runtime()
  KVM: x86: Use memcmp in kvm_cpuid_check_equal()

 arch/x86/kvm/cpuid.c | 67 +++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 32 deletions(-)

-- 
2.34.1

