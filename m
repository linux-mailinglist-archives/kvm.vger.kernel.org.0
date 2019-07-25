Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1801174DBA
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 14:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbfGYMEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 08:04:40 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42949 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbfGYMEj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 08:04:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id x1so579233wrr.9
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2019 05:04:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vqKXeZ90q+N46puvA2cVZOXYv8qzvqZWEskJsjgVdVI=;
        b=MNUydoNMXiai9d3yfk9+zAt80V4Y7hVdaIgEnzPCveFxY6ktvaCbS2oAEAflW31qWf
         jjs+4hKzWJi0pnIu6wLJVPZ9Zrbrj7Sl63r5220h1EoTiLQaXg6PryWj/uIZs4pjOQkp
         rRtYJxQ6/66vr+KSXJ6SaORlsfLjdSCXmlQwV1wLGr4TK/urs/E982kwOgf33M1MY3nK
         luFiP31xheM7EQNfoLgjDO0vCFDEnT7xToDsbhsRvtP+Wo3XZvkNboRsZABqBAvfj53I
         X0HDWWXhc8pZu9/yc0MiiURMei3x1u8w/OSMDOMwUTwWjjZZRGjbxJPegXTYSaQReXIk
         OBlQ==
X-Gm-Message-State: APjAAAUcdf5VGSOga4A4bjX0Tw3rHvFlIwETUQbcT1N0kjth3dcYveHX
        6pHDMndVRlHBgOVkb8QscCt6lZFpzMA=
X-Google-Smtp-Source: APXvYqxgacEuljaodY+6UYjxTLGKv2jZYcIqdsid+YgNyuPREeL3/l39SCiPJgslt81tpsrt6sQXbw==
X-Received: by 2002:a5d:6a05:: with SMTP id m5mr20540812wru.305.1564056278267;
        Thu, 25 Jul 2019 05:04:38 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id j6sm73793424wrx.46.2019.07.25.05.04.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 05:04:37 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH stable-5.2 0/3] KVM: x86: FPU and nested VMX guest reset fixes
Date:   Thu, 25 Jul 2019 14:04:33 +0200
Message-Id: <20190725120436.5432-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Few patches were recently marked for stable@ but commits are not
backportable as-is and require a few tweaks. Here is 5.2 stable backport.

[PATCHes 2/3 of the series apply as-is, I have them here for completeness]

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

