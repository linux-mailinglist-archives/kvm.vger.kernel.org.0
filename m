Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925616BBB60
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbjCORuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbjCORtk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:49:40 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E23DDBC0
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:27 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id bi20so3217989wmb.2
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sjLPfMQH5X3r4H7gOQMwsuYoqZ/Fp9APWUTkT22J5Kc=;
        b=Xn6Uh6N9KANITQUFkWWaXVfNGpDkDSWJmMDeI0j3hUDYdOqWVJeSLrWsKACn7pLt0Y
         djbRQd3kQDsZBzMcrJ5DvwSdQVoY88RpewKmQAJ9/zJbCvMEknQjMJR3zekfKPkBWVYc
         7jG4rN1DEkz+yP99pyFMG8Z3opR0bM39i1rjmNAhxv8eyVkAvvfL4tp7tc6nvs1ucSLY
         bK11JRChCFSuqvOYsaXTwW881kER9KiDaN40KzeZ86h/cLZE0f8qL6gm+hjvmcJh5+e7
         OSIQPCNoCFmoYclJNUglofHfTvBiFee/OP4871e9ZbRSkVFiucp3qoxhPbNiE+T2ByOM
         kqfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sjLPfMQH5X3r4H7gOQMwsuYoqZ/Fp9APWUTkT22J5Kc=;
        b=GRILmZ8hRFs2HxRwrTVLj4JJ6zYV1ms2vZVjZcPidCedgNNE5TENR8pBw8yTDe4p0t
         LHP3yiT2Kt4bo4nS+86ZbnCBMYSAXqa9w/coFwHQVLqU1XXEx3S/5F1I5pvfpQefVqTf
         3/TJbK7G/5jvg/dHzEseJj9B1sgx0NOz3AuFwjv1u7VX+HrmoqSJb5KPcQ5k51Tabs6t
         I7rOmaywnP+k4Kc3vlmxt7cpygB+7lZiKnPttbyqJv2O3QGizQb5J10KzpFbFQEC1Gcf
         CNXyaDjI0R8EL/I50DKcwed+YbwQoC83uDBYmx/0RzciMPuZOODblIpaqvciixZGvFKI
         VNfg==
X-Gm-Message-State: AO0yUKV9pmcucPYU6NfqjHuLo4x+AsCsDWAQNdkegQEzZb8y9ecnzoKm
        t070NrWsHFwnNp0+yy2ZBhJKYQ==
X-Google-Smtp-Source: AK7set9CqdrMF4wn7yEyTG7cEBJqnvRlyc1KKWzAwPET8JjYPLWgo8FvLCSR7+FzI+N3YC1EiujqFA==
X-Received: by 2002:a05:600c:35cd:b0:3ed:320a:3736 with SMTP id r13-20020a05600c35cd00b003ed320a3736mr3152344wmq.35.1678902565725;
        Wed, 15 Mar 2023 10:49:25 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id n22-20020a7bcbd6000000b003eb395a8280sm2634653wmi.37.2023.03.15.10.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:49:25 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 2A1221FFBD;
        Wed, 15 Mar 2023 17:43:44 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Akihiko Odaki <akihiko.odaki@gmail.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        qemu-riscv@nongnu.org, Riku Voipio <riku.voipio@iki.fi>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Thomas Huth <thuth@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Hao Wu <wuhaotsh@google.com>, Cleber Rosa <crosa@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        Aurelien Jarno <aurelien@aurel32.net>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, qemu-ppc@nongnu.org,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Darren Kenny <darren.kenny@oracle.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stafford Horne <shorne@gmail.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Thomas Huth <huth@tuxfamily.org>,
        Vijai Kumar K <vijai@behindbytes.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Song Gao <gaosong@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Niek Linnenbank <nieklinnenbank@gmail.com>,
        Greg Kurz <groug@kaod.org>, Laurent Vivier <laurent@vivier.eu>,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Alexander Bulekov <alxndr@bu.edu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-block@nongnu.org,
        Yanan Wang <wangyanan55@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>, qemu-s390x@nongnu.org,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Bandan Das <bsd@redhat.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Beraldo Leal <bleal@redhat.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Paul Durrant <paul@xen.org>, Bin Meng <bin.meng@windriver.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Hanna Reitz <hreitz@redhat.com>, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Subject: [PATCH v2 22/32] iotests: connect stdin to /dev/null when running tests
Date:   Wed, 15 Mar 2023 17:43:21 +0000
Message-Id: <20230315174331.2959-23-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315174331.2959-1-alex.bennee@linaro.org>
References: <20230315174331.2959-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Daniel P. Berrangé <berrange@redhat.com>

Currently the tests have their stdin inherited from the test harness,
meaning they are connected to a TTY. The QEMU processes spawned by
certain tests, however, modify TTY settings and if the test exits
abnormally the settings might not be restored.

The python test harness thus has some logic which will capture the
initial TTY settings and restore them once all tests are finished.

This does not, however, take into account the possibility of many
copies of the 'check' program running in parallel. With parallel
execution, a later invokation may save the TTY state that QEMU has
already modified, and thus restore bad state leaving the TTY
non-functional.

None of the I/O tests shnould actually be interactive requiring
user input and so they should not require a TTY at all. To avoid
this while TTY save/restore complexity we can connect the test
stdin to /dev/null instead.

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Acked-by: Hanna Czenczek <hreitz@redhat.com>
Tested-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20230303160727.3977246-6-berrange@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qemu-iotests/testrunner.py | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/tests/qemu-iotests/testrunner.py b/tests/qemu-iotests/testrunner.py
index e734800b3d..81519ed6e2 100644
--- a/tests/qemu-iotests/testrunner.py
+++ b/tests/qemu-iotests/testrunner.py
@@ -24,12 +24,10 @@
 import subprocess
 import contextlib
 import json
-import termios
 import shutil
 import sys
 from multiprocessing import Pool
-from contextlib import contextmanager
-from typing import List, Optional, Iterator, Any, Sequence, Dict, \
+from typing import List, Optional, Any, Sequence, Dict, \
         ContextManager
 
 from testenv import TestEnv
@@ -56,22 +54,6 @@ def file_diff(file1: str, file2: str) -> List[str]:
         return res
 
 
-# We want to save current tty settings during test run,
-# since an aborting qemu call may leave things screwed up.
-@contextmanager
-def savetty() -> Iterator[None]:
-    isterm = sys.stdin.isatty()
-    if isterm:
-        fd = sys.stdin.fileno()
-        attr = termios.tcgetattr(fd)
-
-    try:
-        yield
-    finally:
-        if isterm:
-            termios.tcsetattr(fd, termios.TCSADRAIN, attr)
-
-
 class LastElapsedTime(ContextManager['LastElapsedTime']):
     """ Cache for elapsed time for tests, to show it during new test run
 
@@ -169,7 +151,6 @@ def __enter__(self) -> 'TestRunner':
         self._stack = contextlib.ExitStack()
         self._stack.enter_context(self.env)
         self._stack.enter_context(self.last_elapsed)
-        self._stack.enter_context(savetty())
         return self
 
     def __exit__(self, exc_type: Any, exc_value: Any, traceback: Any) -> None:
@@ -294,6 +275,7 @@ def do_run_test(self, test: str, mp: bool) -> TestResult:
         t0 = time.time()
         with f_bad.open('w', encoding="utf-8") as f:
             with subprocess.Popen(args, cwd=str(f_test.parent), env=env,
+                                  stdin=subprocess.DEVNULL,
                                   stdout=f, stderr=subprocess.STDOUT) as proc:
                 try:
                     proc.wait()
-- 
2.39.2

