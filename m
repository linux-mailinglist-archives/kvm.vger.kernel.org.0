Return-Path: <kvm+bounces-4607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04423815968
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:43:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF6B42855F5
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03EE02CCBF;
	Sat, 16 Dec 2023 13:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UQ1eU7hH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92372C69C
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6d2350636d6so1519263b3a.2
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734199; x=1703338999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B+7l4pOYsT3CaviTaqKN9x/Myq8yxFLM9fmkQeR06OU=;
        b=UQ1eU7hH4fw0vEmIEHtEarDqd2RJzwDVix2JFK/42BTbDmm6pB1UOYkVs9UrMbbVZ/
         3srjf20K4EVkqpUQXr0n05yZUOMgEwHrqT56N7vlK3Ulmi3gehgx+ZjgqAv+7YJt+8eS
         /QG6M5JQFA8rnwA9r+nRgTYgfERjswQcOCXysWeUR3Czwx5xnt6NMUOdvSX1NInMuzIF
         a0Gj8eMwVhjSf0SWjHZ8Dnn1GR6kY7dHz/Tcro+wa00F6IzFx3EGxo2ElQXOioc5TH4x
         d8QVF5Dsl0nMZei+Az/+grXH+Ps997h7Dy8a3ttbFIWY8DBIftUiRHjOX1qWdTPXuSDs
         vmuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734199; x=1703338999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B+7l4pOYsT3CaviTaqKN9x/Myq8yxFLM9fmkQeR06OU=;
        b=G4D5xxt3uGhnFI4HeB28B3v3yKtvpXfVk1UO+qqL6C8GfAhaq0adI2e+WPK1Z+dycu
         XDa949GjysiB5ImG6z5h5e8nNNQonpuWIV3WRhNgUIy5AW8n6ra/DMRS4lmEOjtTDut2
         fhFW2JOJJgxcoyB2tojFVArJizU6Ah0WuvGPcLm79E+RScMXBGdNbkkC/BkE/QgGqa2D
         D5yr+xJUeMmC/N+NYikVH4jzxlpDO55BaaHmQfgchrRfyDCrTanabAKPnC5JM/wVxYrX
         TdhAuKz8X7tcPouUJMZ7t4NGiT9Ea8Z3HzjNUOcvicNenGHhgMZ5gd6/xMh9jmqqRZ5i
         896A==
X-Gm-Message-State: AOJu0Yy6y1M+fk8NrMeqlyWkioHHN/mkUrwvii7PKFmjh/gnw79/0ohf
	ds1gbjaeBN1HQc5bQme8yV7uwhP0GWI=
X-Google-Smtp-Source: AGHT+IFImnuuEZM7gUszelAmMNRJPwf8qvl5oixScMR+P/AjXJJp1B60/5PKOvLofHshAeJQxpUrqg==
X-Received: by 2002:aa7:8390:0:b0:6d2:7294:96e7 with SMTP id u16-20020aa78390000000b006d2729496e7mr3378119pfm.62.1702734198831;
        Sat, 16 Dec 2023 05:43:18 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:43:18 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 00/29] powerpc: updates, P10, PNV support
Date: Sat, 16 Dec 2023 23:42:27 +1000
Message-ID: <20231216134257.1743345-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This has taken quite a while to get right, but I think is getting
much better now.

There are several semi-related things here: multi-migration support,
bugfixing, adding powernv machine, expanding and adding test cases.
But I found it easiest to leave it as one series. Multi-migration I
added when testing and debugging time migration issues in QEMU, and
that has grown to quite a size, I can try to split that out if
preferred.

Since v4:
- Multi migration now seems quite solid, I haven't broken it. Arm64
  migration regression reported by Shaoqin is fixed, it was due to an exit
  status getting lost.
- Several other small migration fixes and cleanups that poppedup in
  testing.
- More complete SMP support including IPI for pseries and powernv.
- Made powernv a first-class citizen that can do run_tests.sh unit
  tests (with machine option).
- More polished, quiet warnings, skip unsupported tests, etc.
- Fix several powerpc bugs that got exposed (.got, stack backtrace,
  stack alignment).
- Added a bunch more tests I've been accumulating, atomics, smp,
  timebase, interrupts.

Note the arm64 psci cpu-on test is flakey with/without this series.

Thanks,
Nick


Nicholas Piggin (29):
  arch-run: Clean up temporary files properly
  arch-run: Clean up initrd cleanup
  migration: use a more robust way to wait for background job
  migration: Support multiple migrations
  arch-run: rename migration variables
  powerpc: Quiet QEMU TCG pseries capability warnings
  powerpc: Add a migration stress tester
  powerpc: Require KVM for the TM test
  powerpc: Fix interrupt stack alignment
  powerpc/sprs: Specify SPRs with data rather than code
  powerpc/sprs: Don't fail changed SPRs that are used by the test
    harness
  powerpc/sprs: Avoid taking async interrupts caused by register fuzzing
  powerpc: Make interrupt handler error more readable
  powerpc: Expand exception handler vector granularity
  powerpc: Add support for more interrupts including HV interrupts
  powerpc: Set .got section alignment to 256 bytes
  powerpc: Discover runtime load address dynamically
  powerpc: Fix stack backtrace termination
  scripts: allow machine option to be specified in unittests.cfg
  scripts: Accommodate powerpc powernv machine differences
  powerpc: Support powernv machine with QEMU TCG
  powerpc: Fix emulator illegal instruction test for powernv
  powerpc/sprs: Test hypervisor registers on powernv machine
  powerpc: interrupt tests
  powerpc: Add rtas stop-self support
  powerpc: add SMP and IPI support
  powerpc: Avoid using larx/stcx. in spinlocks when only one CPU is
    running
  powerpc: Add atomics tests
  powerpc: Add timebase tests

 lib/migrate.c               |   8 +-
 lib/migrate.h               |   1 +
 lib/powerpc/asm/ppc_asm.h   |  25 ++
 lib/powerpc/asm/processor.h |  41 +++
 lib/powerpc/asm/rtas.h      |   2 +
 lib/powerpc/asm/setup.h     |   3 +-
 lib/powerpc/asm/smp.h       |  24 +-
 lib/powerpc/hcall.c         |   4 +-
 lib/powerpc/io.c            |  27 +-
 lib/powerpc/io.h            |   6 +
 lib/powerpc/processor.c     |  55 ++-
 lib/powerpc/rtas.c          |  78 ++++-
 lib/powerpc/setup.c         |  50 ++-
 lib/powerpc/smp.c           | 270 +++++++++++++--
 lib/powerpc/spinlock.c      |  28 ++
 lib/ppc64/asm/atomic.h      |   6 +
 lib/ppc64/asm/opal.h        |  20 ++
 lib/ppc64/asm/ptrace.h      |   1 +
 lib/ppc64/asm/spinlock.h    |   7 +-
 lib/ppc64/opal-calls.S      |  46 +++
 lib/ppc64/opal.c            |  76 +++++
 powerpc/Makefile.common     |   8 +-
 powerpc/Makefile.ppc64      |   2 +
 powerpc/atomics.c           | 190 +++++++++++
 powerpc/cstart64.S          | 163 +++++++--
 powerpc/emulator.c          |  19 +-
 powerpc/flat.lds            |   3 +-
 powerpc/interrupts.c        | 412 +++++++++++++++++++++++
 powerpc/migrate.c           |  64 ++++
 powerpc/run                 |  39 ++-
 powerpc/smp.c               | 199 +++++++++++
 powerpc/sprs.c              | 642 +++++++++++++++++++++++++-----------
 powerpc/timebase.c          | 328 ++++++++++++++++++
 powerpc/tm.c                |   2 +-
 powerpc/unittests.cfg       |  37 +++
 scripts/arch-run.bash       | 181 +++++++---
 scripts/common.bash         |   8 +-
 scripts/runtime.bash        |  20 +-
 38 files changed, 2736 insertions(+), 359 deletions(-)
 create mode 100644 lib/powerpc/spinlock.c
 create mode 100644 lib/ppc64/asm/atomic.h
 create mode 100644 lib/ppc64/asm/opal.h
 create mode 100644 lib/ppc64/opal-calls.S
 create mode 100644 lib/ppc64/opal.c
 create mode 100644 powerpc/atomics.c
 create mode 100644 powerpc/interrupts.c
 create mode 100644 powerpc/migrate.c
 create mode 100644 powerpc/smp.c
 create mode 100644 powerpc/timebase.c

-- 
2.42.0


