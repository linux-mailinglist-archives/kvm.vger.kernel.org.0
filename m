Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45DE32C6E4
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357340AbhCDAaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:30:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45427 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377748AbhCCS2g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:28:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614796023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d+d/MBqh7nLsyh5fOlU8/TcU9o+BUbPZsFEks8VNenw=;
        b=NErkYgPfzczbcuE1y7XjkI87fYTT44juaOZgSKTiXtyNz9diADv5SBliOSVsVvLt3SeDUC
        VlArwAYxBl8vxOIOsKNVt3+clSBXgp87WNcu+FzLPxIgxDA6wX6LqJqSAvEbn4ewUjeJfR
        Pp1Qvfo12bwC1kC9yX/1ly5KLtwlpjs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-NqsJ4t1RPk6bqDVuM0RadA-1; Wed, 03 Mar 2021 13:23:08 -0500
X-MC-Unique: NqsJ4t1RPk6bqDVuM0RadA-1
Received: by mail-wr1-f69.google.com with SMTP id n17so994080wrq.5
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:23:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d+d/MBqh7nLsyh5fOlU8/TcU9o+BUbPZsFEks8VNenw=;
        b=B1u+n1qoVg1KYj2k0/hHGw8NlI4KVRneQ+JLw7Nv4EccAQDb5L151U6afJ3oi2W7ej
         J726CTHkHh0I/ELRTLjk0fl7W8LghqrN2wNaq4w5SFb7oCmt6CFU6O8A42acmMnn5Mtj
         gZpMBdpZmzbjP+0uBkNx1JFiU/DK8M+MBlRFFuyTwrBG2TULdOhLUBmLQuL+sTg9FKrS
         LKEQ6P0YO0IG1o5ABYJVmMWJGo4zu6d8r4HB9nk9NKfDPunPcce+Z8XfMBgVvJOHnu0a
         agOorwUS60rqy2kzRWJIt2MRj/Y1n2z4i4mGA+Tw9vORLTjFdoVfIsfRUAMKlg+Y3gFC
         RXjQ==
X-Gm-Message-State: AOAM532t96WAuz/29ft8v1kYLVtz5xuA3NGFMIWGh3qeF+t6i5wtOY9h
        X++/yD3mrKiPXCtBAoGhLA4DfDsUvwuvZpDqPZn2/ZO2ZIuGJOdKn/rpnFxIPMpxong05LviKLa
        z/OOYC83hjLLB
X-Received: by 2002:adf:a2cf:: with SMTP id t15mr14834wra.250.1614795786884;
        Wed, 03 Mar 2021 10:23:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz6ujFjRNPggv7/ipzC5oDJujEI5QYZFdlngvKsuonznRYeYLKD8t2BL7D3qvATAQ4rzlY2SQ==
X-Received: by 2002:adf:a2cf:: with SMTP id t15mr14791wra.250.1614795786594;
        Wed, 03 Mar 2021 10:23:06 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id a3sm33245959wrt.68.2021.03.03.10.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:23:06 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Wenchao Wang <wenchao.wang@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-arm@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>, qemu-ppc@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, haxm-team@intel.com,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [RFC PATCH 07/19] accel/whpx: Rename struct whpx_vcpu -> AccelvCPUState
Date:   Wed,  3 Mar 2021 19:22:07 +0100
Message-Id: <20210303182219.1631042-8-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210303182219.1631042-1-philmd@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current 'struct whpx_vcpu' contains the vCPU fields
specific to the WHPX accelerator. Rename it as AccelvCPUState.
We keep the 'whpx_vcpu' typedef to reduce the amount of code
changed.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/whpx/whpx-all.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index 6469e388b6d..f0b3266114d 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -148,9 +148,9 @@ struct whpx_register_set {
     WHV_REGISTER_VALUE values[RTL_NUMBER_OF(whpx_register_names)];
 };
 
-typedef struct whpx_vcpu whpx_vcpu;
+typedef struct AccelvCPUState whpx_vcpu;
 
-struct whpx_vcpu {
+struct AccelvCPUState {
     WHV_EMULATOR_HANDLE emulator;
     bool window_registered;
     bool interruptable;
-- 
2.26.2

