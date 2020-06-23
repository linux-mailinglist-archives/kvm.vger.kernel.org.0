Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DFB204F83
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 12:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732280AbgFWKvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 06:51:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32571 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732254AbgFWKvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 06:51:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592909464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1BS0abpdiPuVnJZzNFn28vzuVgg/Ij6oTCIsBYhyt1Y=;
        b=XrCKsBD+LoDsTLJRbqvQuZYl1EYwHPPLce51hEAIXLLa+mXwATtJvVq1naf5yfGu9PItPe
        yp3a4C8EQ9NwVQrCrJ3Nc8FldUhjj770YueN44AjuE+6iIMkyoSqV+LZPG0mkCJw/eHKn2
        jxHznudgGUZGfaVpxyPDrr2NUyr5S0E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-zzMZoXWTPB-iakWkIFsJrw-1; Tue, 23 Jun 2020 06:51:02 -0400
X-MC-Unique: zzMZoXWTPB-iakWkIFsJrw-1
Received: by mail-wr1-f70.google.com with SMTP id o12so12890972wrj.23
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 03:51:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1BS0abpdiPuVnJZzNFn28vzuVgg/Ij6oTCIsBYhyt1Y=;
        b=DInpBgyoL2TMelunCIzlM/VyEM+5TMGz24NYkIKudpi6uUGc05Thek+qm0qppi99z6
         wZpxj+rzg5YQ67tolhgs8y7fwWNyd6MoSlG+lorxc4Q5G3vRK5v/96Q1Cys35EGYmrio
         U2Vhyujp2J3x6WyDdOkwh67iL2rTa83NdU1DvVsxZrAW/kMMKGtGxqIjGMK3FTjHW4gN
         x8X6f5Ts4mqe5eZExc0yl5QQpMdV3k/5+5crY+3JnxC70ZXKL3GQlpUyoHSKVVJd5i1O
         JDg98i5jeft08zjciCuAUhN4VmK2dFntVkoBMq3Dvs/iNkkBIuuw8Y7Lsbt/oDrMCTBr
         k+Cw==
X-Gm-Message-State: AOAM533v2gzxyvdcMtzMUzDIMHqbsMFs+bT5ZoCOmNleejIsc6cMIFuI
        yqNGyVMbMK/woUDdjDFVbCz256fKDnqtfoPH/1Is2W8XUT3uiJ13thiofPHJ8tQlwlwjJJscBr8
        B70dLPXKhPBXm
X-Received: by 2002:adf:9205:: with SMTP id 5mr23264884wrj.232.1592909461398;
        Tue, 23 Jun 2020 03:51:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjdMOkGSgtWFKbLjB8FzK+2Ae35wW4M/EhzLYOTVgI1sklv0ksqtYAGkGa8RRoxTc2DMk/SA==
X-Received: by 2002:adf:9205:: with SMTP id 5mr23264860wrj.232.1592909461243;
        Tue, 23 Jun 2020 03:51:01 -0700 (PDT)
Received: from localhost.localdomain (1.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.1])
        by smtp.gmail.com with ESMTPSA id 104sm22641857wrl.25.2020.06.23.03.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 03:51:00 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Richard Henderson <rth@twiddle.net>, qemu-s390x@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-arm@nongnu.org,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 1/7] accel/kvm: Let kvm_check_extension use global KVM state
Date:   Tue, 23 Jun 2020 12:50:46 +0200
Message-Id: <20200623105052.1700-2-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200623105052.1700-1-philmd@redhat.com>
References: <20200623105052.1700-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As KVM supported extentions those should be the same for
all VMs, it is safe to directly use the global kvm_state
in kvm_check_extension().

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 accel/kvm/kvm-all.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f24d7da783..934a7d6b24 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -913,7 +913,7 @@ int kvm_check_extension(KVMState *s, unsigned int extension)
 {
     int ret;
 
-    ret = kvm_ioctl(s, KVM_CHECK_EXTENSION, extension);
+    ret = kvm_ioctl(kvm_state, KVM_CHECK_EXTENSION, extension);
     if (ret < 0) {
         ret = 0;
     }
-- 
2.21.3

