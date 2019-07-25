Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF5B74D74
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 13:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404291AbfGYLtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 07:49:42 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36991 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404290AbfGYLtm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 07:49:42 -0400
Received: by mail-wm1-f65.google.com with SMTP id f17so44442719wme.2
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2019 04:49:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JwF4mpEiRa45bRWmG8LAm7NBwIkhh6yBccP7Pl5vh7Y=;
        b=MmPw2ul+YQChDj2OVt6w/tBI+CaWKSV3W1NMVgMR1Cea48U+ilqWt3f8B59ZcJCmDK
         Jh3e6XsMbwz2zwSiqlA8fbIaXzIgHlDTvPCZIMtbe+GbFEkQCdy5kzzUk2cGlqCVaiv+
         SycEPKSF43SNNJe9J7U4Lye/jA6+1zitAt+m3q8Y5MpnT8sKjiJz23xDx9RZDF9D5suL
         VV613tTMVjg2YP3L8du0fgfN9hZ0mvVPch/4BC6JakWd318f0c3QlJfQL4vNtj0wM8v2
         MQhwAn40nl9pAxDFT02mN4IR2OPLAUSADWHjtWTzW36rm+CSwJ8zkxsybNR1oFjPEApq
         sC/A==
X-Gm-Message-State: APjAAAUIgwaF5aBzw9v3yY7UMJIU8vQDMTUeaob4QN+zQTQlhV0AENhP
        kqnl/2NcGNqQYsNCTsHJA4zXtQ==
X-Google-Smtp-Source: APXvYqwHIAbuNzKH1sv37RyUICk9i11ATcpmEGDJP3UlsUFfAdbUyofZsSomxQmloUcfikdX/fDG7Q==
X-Received: by 2002:a05:600c:2245:: with SMTP id a5mr79165913wmm.121.1564055380779;
        Thu, 25 Jul 2019 04:49:40 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t140sm44784683wmt.0.2019.07.25.04.49.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 04:49:40 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH stable-5.1 0/3] KVM: x86: FPU and nested VMX guest reset fixes
Date:   Thu, 25 Jul 2019 13:49:35 +0200
Message-Id: <20190725114938.3976-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Few patches were recently marked for stable@ but commits are not
backportable as-is and require a few tweaks. Here is 5.1 stable backport.

[PATCH2 of the series applies as-is, I have it here for completeness]

Jan Kiszka (1):
  KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when leaving nested

Paolo Bonzini (2):
  KVM: nVMX: do not use dangling shadow VMCS after guest reset
  Revert "kvm: x86: Use task structs fpu field for user"

 arch/x86/include/asm/kvm_host.h |  7 ++++---
 arch/x86/kvm/vmx/nested.c       | 10 +++++++++-
 arch/x86/kvm/x86.c              |  4 ++--
 3 files changed, 15 insertions(+), 6 deletions(-)

-- 
2.20.1

