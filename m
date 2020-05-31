Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34301E98E0
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgEaQi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:38:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45869 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725912AbgEaQi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 May 2020 12:38:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Cqps2Xy/wDwgHeQZtBDDKwWdymxWmUMf4khG6NEjU0s=;
        b=BYGVmiRaOznuTKgWAzaUi/N+rvV/HJj9JneDb++DVfHDn/XJYR7PDQNRq3UjJ+VfpmxqOl
        MhwU6WhVmSBx6p/8E0BCsjO7WDvnqpKyS+mMTDPfeIAcvW34IfQSuphirbOXaG7XIBvdFw
        ugmjBx9JhizzM8/on7WHvXkMtChf2Hk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-7C79Y5gHPS-YWEvMvNYdaA-1; Sun, 31 May 2020 12:38:51 -0400
X-MC-Unique: 7C79Y5gHPS-YWEvMvNYdaA-1
Received: by mail-wr1-f72.google.com with SMTP id e7so3138812wrp.14
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:38:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cqps2Xy/wDwgHeQZtBDDKwWdymxWmUMf4khG6NEjU0s=;
        b=MqJzkbsKGNv2mB7rUJbEvm6nEQtZECklFeer2hpXxk5iLdoSrMc4Et8VwSHO2IV2tN
         7Qs7ExGcDoVBHMpj6mVnQ1RoXgsYMZKN35jwSVcOLmAwrxMk0EtXB/obblegplh0urK2
         p8XZx64whRJohf7y3Z8Dx9ardrBOhAII7azgTZBkj9D4hohRwNH4fB7uwAE/FrDLvAap
         GwWusIKCGMRlw6CELvdnhPitwmCt4wAUy0nS8zavCfmLMyN4ShCCfeBIGetb7uwd76f7
         e7Z57SlAvnksT3RcFBeMheXjmMWrTeue01tM/OizVKTtdemhyqt32e//3nYnoPc7Zg3w
         mm2g==
X-Gm-Message-State: AOAM533lSneiIa7/KSe0G1VLAY9M0frrXOheeC6FJXfv2OTH03NPzLdj
        EIhp7JcixBglzpsIcjPu8YQF6ghQSCKbqDwRp2d5KH+v2fC8C8K3HcfqrQNocL9Gx8x+fW4H3Kl
        yKkl2dKUpJvp6
X-Received: by 2002:a1c:e914:: with SMTP id q20mr3019033wmc.145.1590943129756;
        Sun, 31 May 2020 09:38:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyD/VAdm6bALQItTxdHOkN9cmdqlhgWpmq4GftYVKQFfyiuufz0LwlGo+Qn5wNF96G2siY3sg==
X-Received: by 2002:a1c:e914:: with SMTP id q20mr3019016wmc.145.1590943129519;
        Sun, 31 May 2020 09:38:49 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id 5sm8192953wmd.19.2020.05.31.09.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:38:48 -0700 (PDT)
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
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org
Subject: [PULL 00/25] python-next patches for 2020-05-31
Date:   Sun, 31 May 2020 18:38:21 +0200
Message-Id: <20200531163846.25363-1-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit c86274bc2e34295764fb44c2aef3cf29623f9b4b:

  Merge remote-tracking branch 'remotes/stsquad/tags/pull-testing-tcg-plugins=
-270520-1' into staging (2020-05-29 17:41:45 +0100)

are available in the Git repository at:

  https://gitlab.com/philmd/qemu.git tags/python-next-20200531

for you to fetch changes up to 1c80c87c8c2489e4318c93c844aa29bc1d014146:

  tests/acceptance: refactor boot_linux to allow code reuse (2020-05-31 18:25=
:31 +0200)

----------------------------------------------------------------
Python queue:

* migration acceptance test fix
* introduce pylintrc & flake8 config
* various cleanups (Python3, style)
* vm-test can set QEMU_LOCAL=3D1 to use locally built binaries
* refactored BootLinuxBase & LinuxKernelTest acceptance classes

https://gitlab.com/philmd/qemu/pipelines/151323210
https://travis-ci.org/github/philmd/qemu/builds/693157969

----------------------------------------------------------------

Dr. David Alan Gilbert (1):
  tests/acceptance/migration.py: Wait for both sides

John Snow (11):
  scripts/qmp: Fix shebang and imports
  python: remove more instances of sys.version_info
  python/qemu/machine: remove logging configuration
  python/qemu: delint and add pylintrc
  python/qemu: delint; add flake8 config
  python/qemu: remove Python2 style super() calls
  python/qemu: fix socket.makefile() typing
  python/qemu: Adjust traceback typing
  python/qemu/qmp: use True/False for non/blocking modes
  python/qemu/qmp: assert sockfile is not None
  python/qemu/qtest: Check before accessing _qtest

Pavel Dovgaluk (3):
  tests/acceptance: allow console interaction with specific VMs
  tests/acceptance: refactor boot_linux_console test to allow code reuse
  tests/acceptance: refactor boot_linux to allow code reuse

Philippe Mathieu-Daud=C3=A9 (6):
  scripts/qemugdb: Remove shebang header
  scripts/qemu-gdb: Use Python 3 interpreter
  scripts/qmp: Use Python 3 interpreter
  scripts/kvm/vmxcap: Use Python 3 interpreter and add pseudo-main()
  scripts/modules/module_block: Use Python 3 interpreter & add
    pseudo-main
  tests/migration/guestperf: Use Python 3 interpreter

Robert Foley (3):
  tests/vm: Pass --debug through for vm-boot-ssh
  tests/vm: Add ability to select QEMU from current build
  tests/vm: allow wait_ssh() to specify command

Vladimir Sementsov-Ogievskiy (1):
  python/qemu/machine: add kill() method

 python/qemu/.flake8                       |  2 +
 python/qemu/accel.py                      |  9 ++-
 python/qemu/machine.py                    | 44 +++++++-----
 python/qemu/pylintrc                      | 58 ++++++++++++++++
 python/qemu/qmp.py                        | 29 +++++---
 python/qemu/qtest.py                      | 83 +++++++++++++++--------
 scripts/analyze-migration.py              |  5 --
 scripts/decodetree.py                     | 25 +++----
 scripts/kvm/vmxcap                        |  7 +-
 scripts/modules/module_block.py           | 29 ++++----
 scripts/qemu-gdb.py                       |  4 +-
 scripts/qemugdb/__init__.py               |  3 +-
 scripts/qemugdb/aio.py                    |  3 +-
 scripts/qemugdb/coroutine.py              |  3 +-
 scripts/qemugdb/mtree.py                  |  4 +-
 scripts/qemugdb/tcg.py                    |  1 -
 scripts/qemugdb/timers.py                 |  1 -
 scripts/qmp/qmp                           |  4 +-
 scripts/qmp/qmp-shell                     |  3 -
 scripts/qmp/qom-fuse                      |  4 +-
 scripts/qmp/qom-get                       |  6 +-
 scripts/qmp/qom-list                      |  6 +-
 scripts/qmp/qom-set                       |  6 +-
 scripts/qmp/qom-tree                      |  6 +-
 tests/acceptance/avocado_qemu/__init__.py | 13 ++--
 tests/acceptance/boot_linux.py            | 49 +++++++------
 tests/acceptance/boot_linux_console.py    | 21 +++---
 tests/acceptance/migration.py             |  4 ++
 tests/docker/docker.py                    |  5 +-
 tests/migration/guestperf-batch.py        |  2 +-
 tests/migration/guestperf-plot.py         |  2 +-
 tests/migration/guestperf.py              |  2 +-
 tests/qemu-iotests/nbd-fault-injector.py  |  5 +-
 tests/vm/Makefile.include                 |  5 ++
 tests/vm/basevm.py                        | 42 ++++++++----
 35 files changed, 317 insertions(+), 178 deletions(-)
 create mode 100644 python/qemu/.flake8
 create mode 100644 python/qemu/pylintrc

--=20
2.21.3

