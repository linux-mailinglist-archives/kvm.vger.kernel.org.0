Return-Path: <kvm+bounces-1666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AB6037EB28E
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:39:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CE321F252D8
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A8C541749;
	Tue, 14 Nov 2023 14:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o3Npxwaz"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F6141750
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:39:52 +0000 (UTC)
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A773D5C
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:39:50 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-507cee17b00so7592768e87.2
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699972788; x=1700577588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x5X2FluBMHtEHwLVURbcbmArZUeMN34wqMB+9uG3SGg=;
        b=o3Npxwaz9s6hA78UQ/Qd8X+pBDW/IodaRz6FH7xFXGkVqEQ3S0d1cVY3ziEgOAQuR4
         ZHpXu+GQ1eZ8dKlD9yaS8tSaTpIZq3Rnm2HhkYOUosA3mOYk6gQN5GOBK5VHEHaeUR9f
         HDsBxctU3zVj67QDKkJ69C6ZE0d/Q5h65Zqm3mjVgk62ZmMQQFCakioM96W3uIoD7+vJ
         oBBF8liBPkwjtIASsIBMonsP7jcn7hFY/qqUTspzD07Q0f3Y4yDwdRPGzrIgGLZE2Ujk
         8uTbJOW+0agwHi/XbERwjeYKIerUG71YSmvKgbIXL95KEAG/ENWEp02cxx3bHc/xf22q
         zNzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699972788; x=1700577588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x5X2FluBMHtEHwLVURbcbmArZUeMN34wqMB+9uG3SGg=;
        b=jEYglzb/DlS9+omwWFHyUkC1BexdF8/TxbEyXsaoaqxIJLQDZQeVCh6RjCvw2KHGWq
         MN6q7dHFHfkNtmhyALqztCzCatVoNshGUX6KHJMdr7pzOrZTYJrmqH+TX8JYxRIfYrSR
         K2FrQEAQ1ixHv+1knyQZq2K6QTQLNu834smufHD8/EmB+lgriDlzF4AcA/w24rwgr4Ll
         pNZ2tRHRcsgyWoTkQKxvXP5h9goVPyokVyTviU4zKLCMrl/xf/4f69sAM2XgpTvmFZac
         aPXSU2mN/EJReQTbCmRQDD4UOHf/UyJzPOR6yJcwjHh920y6obYPlKadvLJNxvyRc3Jb
         V8+w==
X-Gm-Message-State: AOJu0Yyu7QLLiuHHlqUtgzbbItXzynvMIKjaWF5eHeRvDJyeMg9Rmq4n
	0nFTSaq6QXutKMJpThEPRL6yoA==
X-Google-Smtp-Source: AGHT+IEJ1DzMQPrVK6vmcQ1s/BHFe+ZR138ty+E3IEfmXhpEvhlt8hMy3AYRKnboRNNE1Pe2RYsE2w==
X-Received: by 2002:a05:6512:b14:b0:509:8e3d:7cb0 with SMTP id w20-20020a0565120b1400b005098e3d7cb0mr9400030lfu.41.1699972788532;
        Tue, 14 Nov 2023 06:39:48 -0800 (PST)
Received: from m1x-phil.lan (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id l18-20020a50d6d2000000b00542db304680sm5268842edj.63.2023.11.14.06.39.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Nov 2023 06:39:48 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: David Woodhouse <dwmw@amazon.co.uk>,
	qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paul Durrant <paul@xen.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	xen-devel@lists.xenproject.org,
	qemu-block@nongnu.org,
	Anthony Perard <anthony.perard@citrix.com>,
	kvm@vger.kernel.org,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [RFC PATCH-for-9.0 v2 13/19] hw/xen: Remove use of 'target_ulong' in handle_ioreq()
Date: Tue, 14 Nov 2023 15:38:09 +0100
Message-ID: <20231114143816.71079-14-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231114143816.71079-1-philmd@linaro.org>
References: <20231114143816.71079-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Per commit f17068c1c7 ("xen-hvm: reorganize xen-hvm and move common
function to xen-hvm-common"), handle_ioreq() is expected to be
target-agnostic. However it uses 'target_ulong', which is a target
specific definition.

Per xen/include/public/hvm/ioreq.h header:

  struct ioreq {
    uint64_t addr;          /* physical address */
    uint64_t data;          /* data (or paddr of data) */
    uint32_t count;         /* for rep prefixes */
    uint32_t size;          /* size in bytes */
    uint32_t vp_eport;      /* evtchn for notifications to/from device model */
    uint16_t _pad0;
    uint8_t state:4;
    uint8_t data_is_ptr:1;  /* if 1, data above is the guest paddr
                             * of the real data to use. */
    uint8_t dir:1;          /* 1=read, 0=write */
    uint8_t df:1;
    uint8_t _pad1:1;
    uint8_t type;           /* I/O type */
  };
  typedef struct ioreq ioreq_t;

If 'data' is not a pointer, it is a u64.

- In PIO / VMWARE_PORT modes, only 32-bit are used.

- In MMIO COPY mode, memory is accessed by chunks of 64-bit

- In PCI_CONFIG mode, access is u8 or u16 or u32.

- None of TIMEOFFSET / INVALIDATE use 'req'.

- Fallback is only used in x86 for VMWARE_PORT.

Masking the upper bits of 'data' to keep 'req->size' low bits
is irrelevant of the target word size. Remove the word size
check and always extract the relevant bits.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/xen/xen-hvm-common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/hw/xen/xen-hvm-common.c b/hw/xen/xen-hvm-common.c
index bb3cfb200c..fb81bd8fbc 100644
--- a/hw/xen/xen-hvm-common.c
+++ b/hw/xen/xen-hvm-common.c
@@ -1,5 +1,6 @@
 #include "qemu/osdep.h"
 #include "qemu/units.h"
+#include "qemu/bitops.h"
 #include "qapi/error.h"
 #include "trace.h"
 
@@ -426,9 +427,8 @@ static void handle_ioreq(XenIOState *state, ioreq_t *req)
     trace_handle_ioreq(req, req->type, req->dir, req->df, req->data_is_ptr,
                        req->addr, req->data, req->count, req->size);
 
-    if (!req->data_is_ptr && (req->dir == IOREQ_WRITE) &&
-            (req->size < sizeof (target_ulong))) {
-        req->data &= ((target_ulong) 1 << (8 * req->size)) - 1;
+    if (!req->data_is_ptr && (req->dir == IOREQ_WRITE)) {
+        req->data = extract64(req->data, 0, BITS_PER_BYTE * req->size);
     }
 
     if (req->dir == IOREQ_WRITE)
-- 
2.41.0


