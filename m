Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFB8223BB5
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 14:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgGQMww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 08:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgGQMwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 08:52:51 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43D2C061755
        for <kvm@vger.kernel.org>; Fri, 17 Jul 2020 05:52:51 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id c80so14655441wme.0
        for <kvm@vger.kernel.org>; Fri, 17 Jul 2020 05:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j9uK5iW2gxdUCw+ZyRXugfIrp0K9oX6FsRLPbqZGRqQ=;
        b=Q5XzwZ0HCl7Xb8okB3FDL/Oii6D8txYaepRLF1YCYG1vlIL7h5tSOvtuGWrsaACmZC
         qt+e0fPwtx3GeLx4jHNtziCQJy0T2Vj1P3LnLgm47w+gv0itiPoZaM6mjbmS5X2lF5i4
         6jjzXL/DT3T3zPQtcX497PxAhxv9hyA2UE9OHEupFlggHcRmWGq5Sljez1qcpltit6c1
         PTDrzYpCeGwl8i9E4WfQFZxGaLjOTMk6PHfvtrXNbq2Zor9XK4G5Stu/yGsSasxL6Dwz
         4Q/KA3KLoxIJ4mhodDJxCvHmzQ5AxdelkODQ/rRmLkXkhBI+xFHkCgeuwJiKMH2ssH2V
         mp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j9uK5iW2gxdUCw+ZyRXugfIrp0K9oX6FsRLPbqZGRqQ=;
        b=sl2Df/lPx50qbie0UPNMLX0RvLOw/YG0fdP97olK7NhQgH52je5+CW6dOPVAQ7V+X7
         yKHZ4teY/EiMKOTXmdHVJdoDo9q16PbLNox+UKICbB5nA3bfFCBJC83s4tebn22U7uSp
         cbH5mLOhJdc4mN6YOFZ/6rzv69e1s2FlGwbX4oxU3pxr7sPEzqH4vbpUyNDOXadUC/gM
         UBwTqnC8/Biyx1EeBCTOtLnrrTbysLqmNydBbDlTph+r5rhJKStZebXZoRu7FeAHXWIY
         Qp1dhM1RXaHwDz0RRgW8b5GWSaxJfFxD1JAVXGjs7W51Fjlfp7JQOuUVIcpeJyo9qCup
         BNQA==
X-Gm-Message-State: AOAM5336qiECC32L4mww24MH589bHKmdXQTiX8OlsFg38mhyGipD8RLM
        a4lkJ0S0zCBDCQQy1EL/vsflOdZw
X-Google-Smtp-Source: ABdhPJw2htQYvpk7kOZtx39k6Ngrgu7QOJYaVdN49bEZ2rM7FBrvRaeOhqfUODdX9SRiOtcykjYLAQ==
X-Received: by 2002:a05:600c:2144:: with SMTP id v4mr9788581wml.128.1594990370262;
        Fri, 17 Jul 2020 05:52:50 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-64.inter.net.il. [84.229.155.64])
        by smtp.gmail.com with ESMTPSA id z132sm15160699wmb.21.2020.07.17.05.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 05:52:49 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, pbonzini@redhat.com, rvkagan@yandex-team.ru,
        Jon Doron <arilou@gmail.com>
Subject: [PATCH v1 0/1] Synic default SCONTROL MSR needs to be enabled
Date:   Fri, 17 Jul 2020 15:52:37 +0300
Message-Id: <20200717125238.1103096-1-arilou@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Based on an analysis of the HyperV firmwares (Gen1 and Gen2) it seems
like the SCONTROL is not being set to the ENABLED state as like we have
thought.

Also from a test done by Vitaly Kuznetsov, running a nested HyperV it
was concluded that the first access to the SCONTROL MSR with a read
resulted with the value of 0x1, aka HV_SYNIC_CONTROL_ENABLE.

It's important to note that this diverges from the value states in the
HyperV TLFS of 0.

Jon Doron (1):
  x86/kvm/hyper-v: Synic default SCONTROL MSR needs to be enabled

 arch/x86/kvm/hyperv.c | 1 +
 1 file changed, 1 insertion(+)

-- 
2.24.1

