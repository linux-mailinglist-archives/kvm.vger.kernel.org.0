Return-Path: <kvm+bounces-5572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C60F82338E
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:40:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F6E21C228B1
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF42D1CFB7;
	Wed,  3 Jan 2024 17:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LHYQRu3m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E921CAB0
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-33674f60184so10729590f8f.1
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704303554; x=1704908354; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ciRl9sFGERSf23eviyCL0uKOJ2+yOOkqWUqo8JImKW0=;
        b=LHYQRu3mGG0B8IzRJOVOuwlKvWXy7mPNgxS/NBHFM2JMw6cOvuBJWhgHc/Hf7h67MJ
         tCvKsa1Y5xAq0FMb3lD3UNDJhevUCkVLoM9z7p1vHH4NHy4egK09ZZ+qyvAQb9bgA2zK
         dgC+bpgSlz3jbi+RbTknLf6iKqxaUSxCXk1WBtZCz/ynTXmP8WDSITt3p1p6PAp0+0VY
         V+3+FK91UC3YukKbdXXkSDE4zkHGo+o01wP07DbJ6sm5+WVInMyzPeXeMpyPEXsb7kmT
         7AnnCAd5ezK5mM+5dHlXUBdSzU3B45QsD4IAQiL5/8M3bBAJKPYXk9RaSG98SnN8Ykyn
         YS0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704303554; x=1704908354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ciRl9sFGERSf23eviyCL0uKOJ2+yOOkqWUqo8JImKW0=;
        b=Q3t0qo1Ua2L4H26LLVeqG8+aEOvjLc6M7YM4NeXaOnHIqNDBBwn6AZVFBNlf+AcUrv
         lh047SoPtISU8PDsCUJRmkdhTgN8Q1M0t8URLbYJ+cBSja/peyb6ksEk2P3uWWr3H8C7
         S3qM3wTSP1avXjQfyNz+AEaFC8bS9mLpRS4sdy10O751rWxr2YrlXmKUhBuy9f5DFxR4
         7DuHpgWIbRaHzaprz0Sm/w66fZVdT83+5UfMX0nXD+osLCq9X3Xs6uHa4VSbnlso3qrD
         YNT+ukDCaZJPH6UenFc5sTO7L6kHOr9SeUhHDZmCPwvVmWctmYhlM3+2es/C999Ch+/N
         SXtg==
X-Gm-Message-State: AOJu0YyejFDEZkqg1egwgq5NViUfl0cZYYIXIEOigcoToSv/9Tyon85Z
	TqOPs3NdDeUbZFQvfL+JzrN4R+OGWL7lbw==
X-Google-Smtp-Source: AGHT+IFDLpxCZNS1nZaWXFfbL0Qz+KalAUozXFnUwdorNdWC3gGHXn5UNlLNInmNypjXhCCaw7+rvA==
X-Received: by 2002:a5d:4849:0:b0:336:8f9f:c69c with SMTP id n9-20020a5d4849000000b003368f9fc69cmr10597659wrs.40.1704303554593;
        Wed, 03 Jan 2024 09:39:14 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id x18-20020adff0d2000000b003365aa39d30sm30989513wro.11.2024.01.03.09.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 09:39:13 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 3FDAA5F951;
	Wed,  3 Jan 2024 17:33:51 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Song Gao <gaosong@loongson.cn>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Yanan Wang <wangyanan55@huawei.com>,
	Bin Meng <bin.meng@windriver.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Laurent Vivier <laurent@vivier.eu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Brian Cain <bcain@quicinc.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Beraldo Leal <bleal@redhat.com>,
	Paul Durrant <paul@xen.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	qemu-arm@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	John Snow <jsnow@redhat.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	qemu-riscv@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-stable@nongnu.org
Subject: [PATCH v2 21/43] readthodocs: fully specify a build environment
Date: Wed,  3 Jan 2024 17:33:27 +0000
Message-Id: <20240103173349.398526-22-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240103173349.398526-1-alex.bennee@linaro.org>
References: <20240103173349.398526-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is now expected by rtd so I've expanded using their example as
22.04 is one of our supported platforms. I tried to work out if there
was an easy way to re-generate a requirements.txt from our
pythondeps.toml but in the end went for the easier solution.

Cc:  <qemu-stable@nongnu.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20231221174200.2693694-1-alex.bennee@linaro.org>
---
 docs/requirements.txt |  2 ++
 .readthedocs.yml      | 19 ++++++++++++-------
 2 files changed, 14 insertions(+), 7 deletions(-)
 create mode 100644 docs/requirements.txt

diff --git a/docs/requirements.txt b/docs/requirements.txt
new file mode 100644
index 00000000000..691e5218ec7
--- /dev/null
+++ b/docs/requirements.txt
@@ -0,0 +1,2 @@
+sphinx==5.3.0
+sphinx_rtd_theme==1.1.1
diff --git a/.readthedocs.yml b/.readthedocs.yml
index 7fb7b8dd61a..0b262469ce6 100644
--- a/.readthedocs.yml
+++ b/.readthedocs.yml
@@ -5,16 +5,21 @@
 # Required
 version: 2
 
+# Set the version of Python and other tools you might need
+build:
+  os: ubuntu-22.04
+  tools:
+    python: "3.11"
+
 # Build documentation in the docs/ directory with Sphinx
 sphinx:
   configuration: docs/conf.py
 
+# We recommend specifying your dependencies to enable reproducible builds:
+# https://docs.readthedocs.io/en/stable/guides/reproducible-builds.html
+python:
+  install:
+    - requirements: docs/requirements.txt
+
 # We want all the document formats
 formats: all
-
-# For consistency, we require that QEMU's Sphinx extensions
-# run with at least the same minimum version of Python that
-# we require for other Python in our codebase (our conf.py
-# enforces this, and some code needs it.)
-python:
-  version: 3.6
-- 
2.39.2


