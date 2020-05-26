Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB491CF27C
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 12:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgELKco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 06:32:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51715 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726193AbgELKco (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 06:32:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589279563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=D3s9LSGcZEYro7u0ScBs6UfFzzI5QWTXiQteI6q/kVs=;
        b=gkdEYPljLbIXjZB/mHM/jy/VOCCrIIx+EQunKCKmz2TdOSbu8dEL9+AXfQzyXolUrghG0S
        OMybZTnygD1fbsDvdAG4imduq0BQZ2iE1kotqoaYxo95kkDgJCkrzE/EcBxdPv4uBKWIqB
        NpkIQu1P7/1SQorDUMIst6as8hCB5tM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-_f5wCXaaMPGSQyguSSqBaw-1; Tue, 12 May 2020 06:32:41 -0400
X-MC-Unique: _f5wCXaaMPGSQyguSSqBaw-1
Received: by mail-wr1-f70.google.com with SMTP id g10so6724412wrr.10
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 03:32:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D3s9LSGcZEYro7u0ScBs6UfFzzI5QWTXiQteI6q/kVs=;
        b=abYUbWCnqIslqqmg7vqBYEsTzyHpJwWuqU43X26li4H9rqXjoc9sDbOccCdUlu1BSR
         YrYAG9ynGxN0jSWSFw+S0F7J3OuTZ2+OdAsUeCB1SbihPOePAR7YSSVcLGXUqvaVAsz6
         LvtuYZ5RzHlnQgPFpYPTSc6pdz9OFQ7VUVQmeKDD0O7jGWYejLrmTPxj0NDB2AaRd/0e
         JrRicIndewGF85cFcv1o2EJ9QqwgMHCP64+RfZggpsMWqA303297gkNQWQiWMhKTYWpE
         lhIWOWNfdd/ZxkaFgjG24MocDleiPDvRKkE8WZBILwRtzn92IOzbF5NCBMCckmwzYAC8
         h8EA==
X-Gm-Message-State: AGi0PuYtSi50HsyvivLwT/guFV+jD3WWnb2yuzrOYH+NCVa6u5dvg6hx
        rEB2SrQSAxoo6asGf9Tn/cw8/OrDGEt1WTL3VPxUU3XD0qkPF6aA/5ysnEJDnmB90vilpOZSRt3
        oERfp60+QlulC
X-Received: by 2002:a7b:c4da:: with SMTP id g26mr20748001wmk.3.1589279560327;
        Tue, 12 May 2020 03:32:40 -0700 (PDT)
X-Google-Smtp-Source: APiQypI7UX/2eCYXEuygt24GZ0cIrBaT7G/B+iwW2cYEEuIZJysOnDbHZJBLcIIaLOSrWhvw7mpSHA==
X-Received: by 2002:a7b:c4da:: with SMTP id g26mr20747977wmk.3.1589279560089;
        Tue, 12 May 2020 03:32:40 -0700 (PDT)
Received: from x1w.redhat.com (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id x5sm23249077wro.12.2020.05.12.03.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 03:32:39 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        qemu-trivial@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Cleber Rosa <crosa@redhat.com>, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Fam Zheng <fam@euphon.net>
Subject: [PATCH v4 0/6] scripts: More Python fixes
Date:   Tue, 12 May 2020 12:32:32 +0200
Message-Id: <20200512103238.7078-1-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Trivial Python3 fixes, again...

Since v3:
- Fixed missing scripts/qemugdb/timers.py (kwolf)
- Cover more scripts
- Check for __main__ in few scripts

Since v2:
- Remove patch updating MAINTAINERS

Since v1:
- Added Alex Bennée A-b tags
- Addressed John Snow review comments
  - Use /usr/bin/env
  - Do not modify os.path (dropped last patch)

Philippe Mathieu-Daudé (6):
  scripts/qemugdb: Remove shebang header
  scripts/qemu-gdb: Use Python 3 interpreter
  scripts/qmp: Use Python 3 interpreter
  scripts/kvm/vmxcap: Use Python 3 interpreter and add pseudo-main()
  scripts/modules/module_block: Use Python 3 interpreter & add
    pseudo-main
  tests/migration/guestperf: Use Python 3 interpreter

 scripts/kvm/vmxcap                 |  7 ++++---
 scripts/modules/module_block.py    | 31 +++++++++++++++---------------
 scripts/qemu-gdb.py                |  4 ++--
 scripts/qemugdb/__init__.py        |  3 +--
 scripts/qemugdb/aio.py             |  3 +--
 scripts/qemugdb/coroutine.py       |  3 +--
 scripts/qemugdb/mtree.py           |  4 +---
 scripts/qemugdb/tcg.py             |  1 -
 scripts/qemugdb/timers.py          |  1 -
 scripts/qmp/qom-get                |  2 +-
 scripts/qmp/qom-list               |  2 +-
 scripts/qmp/qom-set                |  2 +-
 scripts/qmp/qom-tree               |  2 +-
 tests/migration/guestperf-batch.py |  2 +-
 tests/migration/guestperf-plot.py  |  2 +-
 tests/migration/guestperf.py       |  2 +-
 16 files changed, 33 insertions(+), 38 deletions(-)

-- 
2.21.3

