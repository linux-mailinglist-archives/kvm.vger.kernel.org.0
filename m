Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DE539FB3A
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 17:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhFHPzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 11:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhFHPzz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 11:55:55 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E233C061787
        for <kvm@vger.kernel.org>; Tue,  8 Jun 2021 08:54:02 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id t4-20020a1c77040000b029019d22d84ebdso2303914wmi.3
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 08:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C1jCjSpZgNu1sKbBk9Z8ZrCdwYEpbza43XiihxyO/yE=;
        b=YVCJA0HAF6zcoQljEQXQ/+8Srt82oR65IyobeNyeO5y/m18Qqi4RIsm9oHDlODF9lS
         zu431MizjTDk9b2k3KaWWZoMvurqIXeQ0yR7fLtsexQHacAro307b4uZxXhKi/IArmsq
         wTVrqQD/MbY5QxGYp0Fut2zcaGFZ7CSTo02UvhWH+/ycUqxdTXL5VV1Hu78y+peQagbJ
         R5JulGFyoqhJYf09regXQGYwJev0/OSPbKIWBlJ3anSzPJ8SKdvGWB/qkgJeyXmF6LBt
         iNWz/38JdJLNRutIJ+qJE6hcE6aTVlRun55KTHvLG8pyT1add9uAtshT44k/Yt635hEU
         9q8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C1jCjSpZgNu1sKbBk9Z8ZrCdwYEpbza43XiihxyO/yE=;
        b=HVqsctJgnstBDjkrJojYVmqw1kFWx2SRoZB5mYNopJfSBD7vafgPZ9uqTUgJwXeWye
         Wj6N0vOKYZUIYOb841avfrD/Ttf9YIcy3S8XMfuBtiPoVCaH06qzDLm3DyzPLpwD4jm4
         i/uHbxI3xOLYK+FdGOP5WQYzChZdvL//+2lmNAuIQt9i4i6AOXcdDo6r2Ocb+Jm8+TaD
         jHSNzjeP8/vo8+S/uPWseSrBMwrvLKOA/NpWKCOFsuQlQr04qABnCBEDp4HdE0HQ03c+
         Mup75plSxW0rnGsGmaAj5YE5O5Zjdisscw77OQTsAgSuS1mt5T8mHgYYgTCE/mT9Qljg
         4wbw==
X-Gm-Message-State: AOAM533mapWmUGAsW/qDhoc39L/h+UnB+/Zz02Kx5uOWbAYRJOm8Z8P4
        6cN5coJr4z6sBK+RalD/d5FWgw==
X-Google-Smtp-Source: ABdhPJzTKoQW6pZDrNtOKklfr6CHm5YnfNTU7QG7RonorQflw6aGjQRnHqaXJN0uACO8uwvZsD+KAw==
X-Received: by 2002:a1c:cc17:: with SMTP id h23mr22321567wmb.129.1623167640560;
        Tue, 08 Jun 2021 08:54:00 -0700 (PDT)
Received: from localhost.localdomain (adsl-84-226-111-173.adslplus.ch. [84.226.111.173])
        by smtp.gmail.com with ESMTPSA id l31sm3314180wms.16.2021.06.08.08.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 08:53:59 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     maz@kernel.org
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        catalin.marinas@arm.com, will@kernel.org,
        lorenzo.pieralisi@arm.com, salil.mehta@huawei.com,
        shameerali.kolothum.thodi@huawei.com, jonathan.cameron@huawei.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 0/5] KVM: arm64: Pass PSCI to userspace
Date:   Tue,  8 Jun 2021 17:48:01 +0200
Message-Id: <20210608154805.216869-1-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow userspace to request handling PSCI calls from guests. Our goal is
to enable a vCPU hot-add solution for Arm where the VMM presents
possible resources to the guest at boot, and controls which vCPUs can be
brought up by allowing or denying PSCI CPU_ON calls. Passing HVC and
PSCI to userspace has been discussed on the list in the context of vCPU
hot-add [1,2] but it can also be useful for implementing other SMCCC and
vendor hypercalls [3,4,5].

Patches 1-3 allow userspace to request WFI to be executed in KVM. That
way the VMM can easily implement the PSCI CPU_SUSPEND function, which is
mandatory from PSCI v0.2 onwards (even if it doesn't have a more useful
implementation than WFI, natively available to the guest).

Patch 4 lets userspace request any HVC that isn't handled by KVM, and
patch 5 lets userspace request PSCI calls, disabling in-kernel PSCI
handling.

I'm focusing on the PSCI bits, but a complete prototype of vCPU hot-add
for arm64 on Linux and QEMU, most of it from Salil and James, is
available at [6].

[1] https://lore.kernel.org/kvmarm/82879258-46a7-a6e9-ee54-fc3692c1cdc3@arm.com/
[2] https://lore.kernel.org/linux-arm-kernel/20200625133757.22332-1-salil.mehta@huawei.com/
    (Followed by KVM forum and Linaro Open discussions)
[3] https://lore.kernel.org/linux-arm-kernel/f56cf420-affc-35f0-2355-801a924b8a35@arm.com/
[4] https://lore.kernel.org/kvm/bf7e83f1-c58e-8d65-edd0-d08f27b8b766@arm.com/
[5] https://lore.kernel.org/kvm/1569338454-26202-2-git-send-email-guoheyi@huawei.com/
[6] https://jpbrucker.net/git/linux/log/?h=cpuhp/devel
    https://jpbrucker.net/git/qemu/log/?h=cpuhp/devel    

Jean-Philippe Brucker (5):
  KVM: arm64: Replace power_off with mp_state in struct kvm_vcpu_arch
  KVM: arm64: Move WFI execution to check_vcpu_requests()
  KVM: arm64: Allow userspace to request WFI
  KVM: arm64: Pass hypercalls to userspace
  KVM: arm64: Pass PSCI calls to userspace

 Documentation/virt/kvm/api.rst      | 46 +++++++++++++++----
 Documentation/virt/kvm/arm/psci.rst |  1 +
 arch/arm64/include/asm/kvm_host.h   | 10 +++-
 include/kvm/arm_hypercalls.h        |  1 +
 include/kvm/arm_psci.h              |  4 ++
 include/uapi/linux/kvm.h            |  3 ++
 arch/arm64/kvm/arm.c                | 71 +++++++++++++++++++++--------
 arch/arm64/kvm/handle_exit.c        |  3 +-
 arch/arm64/kvm/hypercalls.c         | 28 +++++++++++-
 arch/arm64/kvm/psci.c               | 69 ++++++++++++++--------------
 10 files changed, 170 insertions(+), 66 deletions(-)

-- 
2.31.1

