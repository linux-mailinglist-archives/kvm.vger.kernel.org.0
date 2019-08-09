Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDAEA872E6
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 09:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405737AbfHIHYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 03:24:34 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45876 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405701AbfHIHYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 03:24:33 -0400
Received: by mail-wr1-f66.google.com with SMTP id q12so7006891wrj.12
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2019 00:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WA0xD70S4mvb/PQJqRGInCwCmljrweMt295QtIocBXo=;
        b=ECmtJohNEbHkaOvigVwh0bY5ueXewlnzoOQL3GT3J/vW0jaj8QP331qzTa6/eZe6ap
         FtgCKyWaI2sflGgqWmktF07KsIvaDVTZBEzGpnEFoqdjFHQJDHfA6TYzamqpL5yRiPdz
         uzOe419XsGH1DRGPvc6b1Wp8Z7lObTT7ntP5WtqGMZegXUN+mD85FpgToBqnZGaLapZj
         DjzTHVUT4HPBs4xXsvS1e4ie34ZZ7+rF/Et9jLybklI17im+xbwHvu4Hh3XmCSCbRa/f
         bFvlZ1E4nmQpCKjIJTF0SoLjYwmUZGLZp2NP/4mOtA88cRweUiVPLKMKKkVDkdHIRvC4
         1cSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WA0xD70S4mvb/PQJqRGInCwCmljrweMt295QtIocBXo=;
        b=I5VrjCWc4ntq4BG/HM18f2+1wfaTa5o58clIJNYV34GBDN9M1MzziK9xXtCRxaiHWq
         D7xRT8SK3foMCrXqb4TuYjqsNgDFQLuWIMtOIQxXg9PhnjE8FbEeFftdpATPMI2xLy4c
         2ISfiN1OcrUWPY2cC9rVNuKMq8HpVyazTrDNkBAqD3N098qocPf7LZw+dlTglRP6phF8
         RP0jT6QmacHYvWQUgPF2W5vtPZBwp5L34srlg4CzWH3HaMD94aqAj6zrGwfIUoJfem7t
         XRg++0/DosoBGVdNyFMd/hVzBhjmvtSauT1yuEzFI75wyk8ZzGJ85Js+P88MXULNHVDQ
         IDlg==
X-Gm-Message-State: APjAAAVqmUsn2SGuTTS2EWTf6RW2hGB6YnsPZY834SF2tYw6uUY7S9TP
        xj/V8GtJo6re7xXjgcGZVqUSmw==
X-Google-Smtp-Source: APXvYqzeCO+GY7pXqejgTG/gXxeki0mTFaAubI9/NXbDdkGSDD2/esm1gSsnUs44X+UO9i0yvJ2edQ==
X-Received: by 2002:a5d:4484:: with SMTP id j4mr22016063wrq.143.1565335471654;
        Fri, 09 Aug 2019 00:24:31 -0700 (PDT)
Received: from hackbox2.linaroharston ([81.128.185.34])
        by smtp.gmail.com with ESMTPSA id p13sm26232705wrw.90.2019.08.09.00.24.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 00:24:31 -0700 (PDT)
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
To:     naresh.kamboju@linaro.org, pbonzini@redhat.com, shuah@kernel.org
Cc:     linux-kernel@vger.kernel.org, drjones@redhat.com,
        sean.j.christopherson@intel.com, linux-kselftest@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v3 2/2] selftests: kvm: x86_64: Adding config fragments
Date:   Fri,  9 Aug 2019 08:24:15 +0100
Message-Id: <20190809072415.29305-2-naresh.kamboju@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190809072415.29305-1-naresh.kamboju@linaro.org>
References: <20190809072415.29305-1-naresh.kamboju@linaro.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

selftests kvm x86_64 test cases need pre-required kernel configs for the
tests to get pass when you are using Intel or AMD CPU.

CONFIG_KVM_INTEL=y
CONFIG_KVM_AMD=y

Signed-off-by: Naresh Kamboju <naresh.kamboju@linaro.org>
---
 tools/testing/selftests/kvm/x86_64/config | 2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/config

diff --git a/tools/testing/selftests/kvm/x86_64/config b/tools/testing/selftests/kvm/x86_64/config
new file mode 100644
index 000000000000..4df8c7f54885
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/config
@@ -0,0 +1,2 @@
+CONFIG_KVM_INTEL=y
+CONFIG_KVM_AMD=y
-- 
2.17.1

