Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6119C74C1B
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 12:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbfGYKqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 06:46:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33288 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfGYKqt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 06:46:49 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so50332322wru.0
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2019 03:46:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pjvXzHuYUakR2/Ani3ARG2fLWxvZAXWrrCuKN/oKrQA=;
        b=pUdccOP41mxTjVd9GEaQ12w42XzG686s8/JtkqoG1Ehq/6jxjGxm8IqXhEs0uQ1JU3
         Lmp7Pm5khv3cyBgPImTNuWBYkJe7I1OMFGkGGWxvm2AZQtCOoHBda8Wie8Tuzzc2l2PV
         E8tz1uy3pdm6THnEl0Pv678ZK8V0SUFQlGKP/ogSOZLqQFpEYfWjCz7se1YGkRWX+3Pr
         6JtmV0janJJYeqEqUqDIyXXlVRlI8C48QGsrjvtIAYbuWPVZleF1G2uQoIBJw5hU3SCq
         oOcFgXzbaborq8TAMrZFcSZIFKF+YI7e5A8Tq5YTmLsG2eCNMTslNwTtL7KviLENCp6o
         EMOg==
X-Gm-Message-State: APjAAAXzba/gTlmBTStONthzzLjbG4aqE01+J9DQGGb3mUhNx2e9ffRF
        yKm1XVkH5Vp0CGjbRt+xH218xA==
X-Google-Smtp-Source: APXvYqwoFxodO1E/5vAA3SDxtHGf23l+eqoIo+8ZfDDxQgcNNEAScxQXjmpGb4BGzRNs9hlgbhxRCQ==
X-Received: by 2002:a5d:65c5:: with SMTP id e5mr46038769wrw.266.1564051607733;
        Thu, 25 Jul 2019 03:46:47 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f204sm72042696wme.18.2019.07.25.03.46.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 03:46:47 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH stable-4.19 0/2] KVM: nVMX: guest reset fixes
Date:   Thu, 25 Jul 2019 12:46:43 +0200
Message-Id: <20190725104645.30642-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Few patches were recently marked for stable@ but commits are not
backportable as-is and require a few tweaks. Here is 4.19 stable backport.

Jan Kiszka (1):
  KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when leaving nested

Paolo Bonzini (1):
  KVM: nVMX: do not use dangling shadow VMCS after guest reset

 arch/x86/kvm/vmx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

-- 
2.20.1

