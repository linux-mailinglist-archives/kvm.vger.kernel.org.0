Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 106A914D35E
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgA2XOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:14:23 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34721 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726618AbgA2XOX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Jan 2020 18:14:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580339660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Mhg3VSz4wWW1QtCbVzRa6h8LKr6U3LR5/uzOvBT52V0=;
        b=Zw+BOV2hfotsCz9UJjxZVXiU+SLG6kTG2Ve9ejWWu1/Kp0drg/VSZZ4lywB+zpA9f75/23
        UqGtumVyoCD7YDLy9Ewn2ObQT5vMxyH81g0TlHcFOhvyvyozBlaoPdgpcXqrOKu0eCAtOc
        /0xbrbfm7YjDIaT69AA5xjhED1WsZ2c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-MnuQyI4UOVCxI4O02kjjow-1; Wed, 29 Jan 2020 18:14:16 -0500
X-MC-Unique: MnuQyI4UOVCxI4O02kjjow-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E962477;
        Wed, 29 Jan 2020 23:14:15 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-184.brq.redhat.com [10.40.205.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 949B85DA7E;
        Wed, 29 Jan 2020 23:14:04 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        Kevin Wolf <kwolf@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Max Reitz <mreitz@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        qemu-block@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH 00/10] python: Explicit usage of Python 3
Date:   Thu, 30 Jan 2020 00:13:52 +0100
Message-Id: <20200129231402.23384-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

These are mechanical sed patches used to convert the
code base to Python 3, as suggested on this thread:
https://www.mail-archive.com/qemu-devel@nongnu.org/msg675024.html

Regards,

Phil.

Philippe Mathieu-Daud=C3=A9 (10):
  scripts: Explicit usage of Python 3
  tests/qemu-iotests: Explicit usage of Python 3
  tests: Explicit usage of Python 3
  scripts/minikconf: Explicit usage of Python 3
  tests/acceptance: Remove shebang header
  scripts/tracetool: Remove shebang header
  tests/vm: Remove shebang header
  tests/qemu-iotests: Explicit usage of Python 3
  scripts: Explicit usage of Python 3
  tests/qemu-iotests/check: Update to match Python 3 interpreter

 scripts/analyse-9p-simpletrace.py                | 2 +-
 scripts/analyse-locks-simpletrace.py             | 2 +-
 scripts/decodetree.py                            | 2 +-
 scripts/device-crash-test                        | 2 +-
 scripts/kvm/kvm_flightrecorder                   | 2 +-
 scripts/minikconf.py                             | 1 +
 scripts/qapi-gen.py                              | 2 +-
 scripts/qmp/qemu-ga-client                       | 2 +-
 scripts/qmp/qmp                                  | 2 +-
 scripts/qmp/qmp-shell                            | 2 +-
 scripts/qmp/qom-fuse                             | 2 +-
 scripts/render_block_graph.py                    | 2 +-
 scripts/replay-dump.py                           | 2 +-
 scripts/simpletrace.py                           | 2 +-
 scripts/tracetool.py                             | 2 +-
 scripts/tracetool/__init__.py                    | 1 -
 scripts/tracetool/backend/__init__.py            | 1 -
 scripts/tracetool/backend/dtrace.py              | 1 -
 scripts/tracetool/backend/ftrace.py              | 1 -
 scripts/tracetool/backend/log.py                 | 1 -
 scripts/tracetool/backend/simple.py              | 1 -
 scripts/tracetool/backend/syslog.py              | 1 -
 scripts/tracetool/backend/ust.py                 | 1 -
 scripts/tracetool/format/__init__.py             | 1 -
 scripts/tracetool/format/c.py                    | 1 -
 scripts/tracetool/format/d.py                    | 1 -
 scripts/tracetool/format/h.py                    | 1 -
 scripts/tracetool/format/log_stap.py             | 1 -
 scripts/tracetool/format/simpletrace_stap.py     | 1 -
 scripts/tracetool/format/stap.py                 | 1 -
 scripts/tracetool/format/tcg_h.py                | 1 -
 scripts/tracetool/format/tcg_helper_c.py         | 1 -
 scripts/tracetool/format/tcg_helper_h.py         | 1 -
 scripts/tracetool/format/tcg_helper_wrapper_h.py | 1 -
 scripts/tracetool/format/ust_events_c.py         | 1 -
 scripts/tracetool/format/ust_events_h.py         | 1 -
 scripts/tracetool/transform.py                   | 1 -
 scripts/tracetool/vcpu.py                        | 1 -
 scripts/vmstate-static-checker.py                | 2 +-
 tests/acceptance/virtio_seg_max_adjust.py        | 1 -
 tests/acceptance/x86_cpu_model_versions.py       | 1 -
 tests/docker/travis.py                           | 2 +-
 tests/qapi-schema/test-qapi.py                   | 2 +-
 tests/qemu-iotests/030                           | 2 +-
 tests/qemu-iotests/040                           | 2 +-
 tests/qemu-iotests/041                           | 2 +-
 tests/qemu-iotests/044                           | 2 +-
 tests/qemu-iotests/045                           | 2 +-
 tests/qemu-iotests/055                           | 2 +-
 tests/qemu-iotests/056                           | 2 +-
 tests/qemu-iotests/057                           | 2 +-
 tests/qemu-iotests/065                           | 2 +-
 tests/qemu-iotests/093                           | 2 +-
 tests/qemu-iotests/096                           | 2 +-
 tests/qemu-iotests/118                           | 2 +-
 tests/qemu-iotests/124                           | 2 +-
 tests/qemu-iotests/129                           | 2 +-
 tests/qemu-iotests/132                           | 2 +-
 tests/qemu-iotests/136                           | 2 +-
 tests/qemu-iotests/139                           | 2 +-
 tests/qemu-iotests/147                           | 2 +-
 tests/qemu-iotests/148                           | 2 +-
 tests/qemu-iotests/149                           | 2 +-
 tests/qemu-iotests/151                           | 2 +-
 tests/qemu-iotests/152                           | 2 +-
 tests/qemu-iotests/155                           | 2 +-
 tests/qemu-iotests/163                           | 2 +-
 tests/qemu-iotests/165                           | 2 +-
 tests/qemu-iotests/169                           | 2 +-
 tests/qemu-iotests/194                           | 2 +-
 tests/qemu-iotests/196                           | 2 +-
 tests/qemu-iotests/199                           | 2 +-
 tests/qemu-iotests/202                           | 2 +-
 tests/qemu-iotests/203                           | 2 +-
 tests/qemu-iotests/205                           | 2 +-
 tests/qemu-iotests/206                           | 2 +-
 tests/qemu-iotests/207                           | 2 +-
 tests/qemu-iotests/208                           | 2 +-
 tests/qemu-iotests/209                           | 2 +-
 tests/qemu-iotests/210                           | 2 +-
 tests/qemu-iotests/211                           | 2 +-
 tests/qemu-iotests/212                           | 2 +-
 tests/qemu-iotests/213                           | 2 +-
 tests/qemu-iotests/216                           | 2 +-
 tests/qemu-iotests/218                           | 2 +-
 tests/qemu-iotests/219                           | 2 +-
 tests/qemu-iotests/222                           | 2 +-
 tests/qemu-iotests/224                           | 2 +-
 tests/qemu-iotests/228                           | 2 +-
 tests/qemu-iotests/234                           | 2 +-
 tests/qemu-iotests/235                           | 2 +-
 tests/qemu-iotests/236                           | 2 +-
 tests/qemu-iotests/237                           | 2 +-
 tests/qemu-iotests/238                           | 2 +-
 tests/qemu-iotests/242                           | 2 +-
 tests/qemu-iotests/245                           | 2 +-
 tests/qemu-iotests/246                           | 2 +-
 tests/qemu-iotests/248                           | 2 +-
 tests/qemu-iotests/254                           | 2 +-
 tests/qemu-iotests/255                           | 2 +-
 tests/qemu-iotests/256                           | 2 +-
 tests/qemu-iotests/257                           | 2 +-
 tests/qemu-iotests/258                           | 2 +-
 tests/qemu-iotests/260                           | 2 +-
 tests/qemu-iotests/262                           | 2 +-
 tests/qemu-iotests/264                           | 2 +-
 tests/qemu-iotests/266                           | 2 +-
 tests/qemu-iotests/277                           | 2 +-
 tests/qemu-iotests/280                           | 2 +-
 tests/qemu-iotests/281                           | 2 +-
 tests/qemu-iotests/check                         | 2 +-
 tests/qemu-iotests/nbd-fault-injector.py         | 2 +-
 tests/qemu-iotests/qcow2.py                      | 2 +-
 tests/qemu-iotests/qed.py                        | 2 +-
 tests/vm/basevm.py                               | 1 -
 tests/vm/centos                                  | 2 +-
 tests/vm/fedora                                  | 2 +-
 tests/vm/freebsd                                 | 2 +-
 tests/vm/netbsd                                  | 2 +-
 tests/vm/openbsd                                 | 2 +-
 tests/vm/ubuntu.i386                             | 2 +-
 121 files changed, 95 insertions(+), 120 deletions(-)
 mode change 100755 =3D> 100644 tests/acceptance/virtio_seg_max_adjust.py
 mode change 100755 =3D> 100644 tests/vm/basevm.py

--=20
2.21.1

