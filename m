Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB9AA186FD9
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732036AbgCPQSk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:18:40 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:33408 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731864AbgCPQSk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:18:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q9pxkDoDUc80lR6q2sbnb9Lu1UrGguk51WkG66GGoIk=;
        b=E43LbxCRHuyvwwMDzDB/qkKFpNpj+FRhE2xXMnH2NYXwJKWle3Uu2rEXVakix4aevfSl2z
        VRrhqHj0uf+5HVt8nwx1/nm15MY01eElE207N3lqNrr16RXWoibqFj8vi7oJ+/79pweEUp
        YWy/EQx5SCMf7JM/eWoCM0Ct0skEClU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-19tdrR8MPKKS0_ipBoRQOg-1; Mon, 16 Mar 2020 12:08:19 -0400
X-MC-Unique: 19tdrR8MPKKS0_ipBoRQOg-1
Received: by mail-ed1-f70.google.com with SMTP id w23so4879103edu.18
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:08:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q9pxkDoDUc80lR6q2sbnb9Lu1UrGguk51WkG66GGoIk=;
        b=s2Ahc0re6+PiCYMryeviKn0p1kAjdh3P0b3n6+Ubs/qVrNK04LSY+gACIk0fNl3Low
         CCngmrT+w/2ftTSCfNwwqeEPdGFy5Q0gnEiiD2bHyzdsSrGzYDCdVdpTFL0VUoE7I5Lh
         jZ2Ilq/klZBqKszDPhaIswefEx8P08Zo8CBevfn3VRLU9qpT0Wet56md0CZoqpzdYEIO
         W90LGe35eO7uc/ihEOKXcpYpryO5XI8GVe1V552UMenCGpyWvX3m5NtMswtBuFq4Pl7H
         viUlE0bTkk8XLc5aGTDffgjm8R+lunP5iR9QJuYeBGecVjxKFeFNcax77/sxiEXfYt0D
         ze4w==
X-Gm-Message-State: ANhLgQ1wOnbRTHWuGacynidecgO3JSoSYsoD+V4n4xIsSk6Qi+CeDUK+
        3dgu6FQ/hKfU8kG8bfHjUA8d1+61HJTUMpv0ZT5IxPur46jmG6//oL/9jRhsfAurDk66j/YytS8
        5iF4hBXTs+Yt4
X-Received: by 2002:aa7:c716:: with SMTP id i22mr639023edq.205.1584374897542;
        Mon, 16 Mar 2020 09:08:17 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtucDPtYCUUmNKo1v786732XgsbrhpkRJ66ECnTqKEicI6pa/tNzUTcvXKFSS8tLcL/QhoQsA==
X-Received: by 2002:adf:b3d6:: with SMTP id x22mr99071wrd.242.1584374896425;
        Mon, 16 Mar 2020 09:08:16 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id x13sm268246wmj.5.2020.03.16.09.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:08:15 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>, xen-devel@lists.xenproject.org
Subject: [PATCH v3 18/19] hw/arm: Do not build to 'virt' machine on Xen
Date:   Mon, 16 Mar 2020 17:06:33 +0100
Message-Id: <20200316160634.3386-19-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200316160634.3386-1-philmd@redhat.com>
References: <20200316160634.3386-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xen on ARM does not use QEMU machines [*]. Disable the 'virt'
machine there to avoid odd errors such:

    CC      i386-softmmu/hw/cpu/a15mpcore.o
  hw/cpu/a15mpcore.c:28:10: fatal error: kvm_arm.h: No such file or directory

[*] https://wiki.xenproject.org/wiki/Xen_ARM_with_Virtualization_Extensions#Use_of_qemu-system-i386_on_ARM

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Anthony Perard <anthony.perard@citrix.com>
Cc: Paul Durrant <paul@xen.org>
Cc: xen-devel@lists.xenproject.org
---
 hw/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index 8e801cd15f..69a8e30125 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -1,5 +1,6 @@
 config ARM_VIRT
     bool
+    depends on !XEN
     default y if KVM
     imply PCI_DEVICES
     imply TEST_DEVICES
-- 
2.21.1

