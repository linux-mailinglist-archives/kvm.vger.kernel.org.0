Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85B21E98F8
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgEaQkd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:40:33 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43991 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728272AbgEaQkc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 May 2020 12:40:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s8Rk2ct1SwmXVJV/wHXYbsX6rV3XnYQXBZW0Chu6BIg=;
        b=Jb0LfEkkq9eiO+yU4qKLQlMcO4ex3YedAd2UGOZnBu4KdNP76CulXyEd6Hm54sJ6Md2hFf
        VhzGFSaa+cAVObZo9m4+sRgm4OPyySAWlJrbdu/q4+Vvqb5lK0VEEvODtH5RTtNgUSSieX
        BaiR3BgIMDK5VQtWOUpmVQVSt0IzIWc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-BTHn_8R_PRi-Ibc2G8Ljcg-1; Sun, 31 May 2020 12:40:27 -0400
X-MC-Unique: BTHn_8R_PRi-Ibc2G8Ljcg-1
Received: by mail-wr1-f69.google.com with SMTP id s17so3599641wrt.7
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:40:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s8Rk2ct1SwmXVJV/wHXYbsX6rV3XnYQXBZW0Chu6BIg=;
        b=SVta4PabPKe2dw/yFOc8uPJl/6zVFKtIIe7ET4wImX4nW4DiVlbnYqrFbjTc+Ourmb
         0XwVn2NqnX89/2737Y12jhqyZRp1jpAdqluhmpNYOn2e+nEs24NCGZ1FiUdZBqoKlUjR
         tL9cV2FBNUxqEvrzql2U0B9RlQoIzJSh4h2HYWar7w3ttDtvCUv9i3VpzURR4iwCh8k4
         Y8A6Yh0TV6Tu0ZJjfnsWqddbX5aUfUcRRrSv7Dl+AZXfgl900jBDunipYrLSuoYHYU7g
         bJS0xCdHLy6eWHa62LeeNaAwxCIwKwyIGDMUXAd9QWOX2pz+O2NaPCfN7iZeG2vOmKpq
         fqQQ==
X-Gm-Message-State: AOAM530ufTf31Jl/TkqKJOOIwxmTHvpnnghwNXODJkXmRPJv7gbGopEy
        RZ1+PShuPZitrN40msWpkxgMvadqrl48kXXaFgpKQdHOJuh2eOhWIJqbZYOjAa3WtTfqr4aQf7K
        tB+DIcKEB5ck6
X-Received: by 2002:adf:fb0f:: with SMTP id c15mr19211126wrr.410.1590943226362;
        Sun, 31 May 2020 09:40:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJze0FR0rffg96Z21CHxAOunsqXM7ThaI5OCZlRFyIOIHJ0snfCaqtZZHfecy2V9OYUxse0UKA==
X-Received: by 2002:adf:fb0f:: with SMTP id c15mr19211104wrr.410.1590943226147;
        Sun, 31 May 2020 09:40:26 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id y25sm9023876wmi.2.2020.05.31.09.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:40:25 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Cleber Rosa <crosa@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        kvm@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        Robert Foley <robert.foley@linaro.org>,
        Peter Puhov <peter.puhov@linaro.org>
Subject: [PULL 19/25] tests/vm: Add ability to select QEMU from current build
Date:   Sun, 31 May 2020 18:38:40 +0200
Message-Id: <20200531163846.25363-20-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200531163846.25363-1-philmd@redhat.com>
References: <20200531163846.25363-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Foley <robert.foley@linaro.org>

Added a new special variable QEMU_LOCAL=1, which
will indicate to take the QEMU binary from the current
build.

Signed-off-by: Robert Foley <robert.foley@linaro.org>
Reviewed-by: Peter Puhov <peter.puhov@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Tested-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <20200529203458.1038-6-robert.foley@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 tests/vm/Makefile.include |  4 ++++
 tests/vm/basevm.py        | 28 +++++++++++++++++++++++-----
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/tests/vm/Makefile.include b/tests/vm/Makefile.include
index 80f7f6bdee..a253aba457 100644
--- a/tests/vm/Makefile.include
+++ b/tests/vm/Makefile.include
@@ -41,6 +41,7 @@ endif
 	@echo "    J=[0..9]*            	 - Override the -jN parameter for make commands"
 	@echo "    DEBUG=1              	 - Enable verbose output on host and interactive debugging"
 	@echo "    V=1				 - Enable verbose ouput on host and guest commands"
+	@echo "    QEMU_LOCAL=1                 - Use QEMU binary local to this build."
 	@echo "    QEMU=/path/to/qemu		 - Change path to QEMU binary"
 	@echo "    QEMU_IMG=/path/to/qemu-img	 - Change path to qemu-img tool"
 
@@ -57,6 +58,7 @@ $(IMAGES_DIR)/%.img:	$(SRC_PATH)/tests/vm/% \
 		$(PYTHON) $< \
 		$(if $(V)$(DEBUG), --debug) \
 		$(if $(GENISOIMAGE),--genisoimage $(GENISOIMAGE)) \
+		$(if $(QEMU_LOCAL),--build-path $(BUILD_DIR)) \
 		--image "$@" \
 		--force \
 		--build-image $@, \
@@ -71,6 +73,7 @@ vm-build-%: $(IMAGES_DIR)/%.img
 		$(if $(DEBUG), --interactive) \
 		$(if $(J),--jobs $(J)) \
 		$(if $(V),--verbose) \
+		$(if $(QEMU_LOCAL),--build-path $(BUILD_DIR)) \
 		--image "$<" \
 		$(if $(BUILD_TARGET),--build-target $(BUILD_TARGET)) \
 		--snapshot \
@@ -92,6 +95,7 @@ vm-boot-ssh-%: $(IMAGES_DIR)/%.img
 		$(PYTHON) $(SRC_PATH)/tests/vm/$* \
 		$(if $(J),--jobs $(J)) \
 		$(if $(V)$(DEBUG), --debug) \
+		$(if $(QEMU_LOCAL),--build-path $(BUILD_DIR)) \
 		--image "$<" \
 		--interactive \
 		false, \
diff --git a/tests/vm/basevm.py b/tests/vm/basevm.py
index a2d4054d72..5a3ce42281 100644
--- a/tests/vm/basevm.py
+++ b/tests/vm/basevm.py
@@ -61,9 +61,11 @@ class BaseVM(object):
     # 4 is arbitrary, but greater than 2,
     # since we found we need to wait more than twice as long.
     tcg_ssh_timeout_multiplier = 4
-    def __init__(self, debug=False, vcpus=None, genisoimage=None):
+    def __init__(self, debug=False, vcpus=None, genisoimage=None,
+                 build_path=None):
         self._guest = None
         self._genisoimage = genisoimage
+        self._build_path = build_path
         self._tmpdir = os.path.realpath(tempfile.mkdtemp(prefix="vm-test-",
                                                          suffix=".tmp",
                                                          dir="."))
@@ -184,15 +186,15 @@ def boot(self, img, extra_args=[]):
             "-device", "virtio-blk,drive=drive0,bootindex=0"]
         args += self._data_args + extra_args
         logging.debug("QEMU args: %s", " ".join(args))
-        qemu_bin = os.environ.get("QEMU", "qemu-system-" + self.arch)
-        guest = QEMUMachine(binary=qemu_bin, args=args)
+        qemu_path = get_qemu_path(self.arch, self._build_path)
+        guest = QEMUMachine(binary=qemu_path, args=args)
         guest.set_machine('pc')
         guest.set_console()
         try:
             guest.launch()
         except:
             logging.error("Failed to launch QEMU, command line:")
-            logging.error(" ".join([qemu_bin] + args))
+            logging.error(" ".join([qemu_path] + args))
             logging.error("Log:")
             logging.error(guest.get_log())
             logging.error("QEMU version >= 2.10 is required")
@@ -391,6 +393,19 @@ def gen_cloud_init_iso(self):
 
         return os.path.join(cidir, "cloud-init.iso")
 
+def get_qemu_path(arch, build_path=None):
+    """Fetch the path to the qemu binary."""
+    # If QEMU environment variable set, it takes precedence
+    if "QEMU" in os.environ:
+        qemu_path = os.environ["QEMU"]
+    elif build_path:
+        qemu_path = os.path.join(build_path, arch + "-softmmu")
+        qemu_path = os.path.join(qemu_path, "qemu-system-" + arch)
+    else:
+        # Default is to use system path for qemu.
+        qemu_path = "qemu-system-" + arch
+    return qemu_path
+
 def parse_args(vmcls):
 
     def get_default_jobs():
@@ -421,6 +436,9 @@ def get_default_jobs():
                       help="build QEMU from source in guest")
     parser.add_option("--build-target",
                       help="QEMU build target", default="check")
+    parser.add_option("--build-path", default=None,
+                      help="Path of build directory, "\
+                           "for using build tree QEMU binary. ")
     parser.add_option("--interactive", "-I", action="store_true",
                       help="Interactively run command")
     parser.add_option("--snapshot", "-s", action="store_true",
@@ -439,7 +457,7 @@ def main(vmcls):
         logging.basicConfig(level=(logging.DEBUG if args.debug
                                    else logging.WARN))
         vm = vmcls(debug=args.debug, vcpus=args.jobs,
-                   genisoimage=args.genisoimage)
+                   genisoimage=args.genisoimage, build_path=args.build_path)
         if args.build_image:
             if os.path.exists(args.image) and not args.force:
                 sys.stderr.writelines(["Image file exists: %s\n" % args.image,
-- 
2.21.3

