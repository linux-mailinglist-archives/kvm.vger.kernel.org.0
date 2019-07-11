Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D33556550B
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 13:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfGKLTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 07:19:48 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36425 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbfGKLTs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 07:19:48 -0400
Received: by mail-wm1-f65.google.com with SMTP id g67so1201060wme.1
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 04:19:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pvvl2KFZw3Bgffir1oDtkHVfWW/qFKlBFNsSp/JHeUA=;
        b=kzvDhirChG9OTr6YwAeJDZYvCNjzk+cpwdiAh9qQYEX/J1PXsLn3Bz34l5NqtKGhhc
         qA+x3vGbjSG31bcs9hClm2X9NHewpAXqBQuBzV6aVKY43jJ16fPH+ZOyBuCOVOe0wj0Z
         simQrCGEmolW+tZoUVkQwOyNdv8TXdI0DgfC7XWYpr/Xpzndcr+4SfQQ5iqNV5zEd4zd
         cRa2IuV2aHLfHAwAjB+x2gen7fHLXv1s9+EVc3eTBV4zXrX14PQ3q8N2sLhIXi0Nymlh
         9QDL73kqst0JOeyFb6R6FidxTWrmbn1miyiac1eurdpB2SXMMCHOUQ/hmrZdODnpJquu
         5lpQ==
X-Gm-Message-State: APjAAAW2dWijDdpZQwj48kDIOTZCy/YoCTluvQ0TrnGIgA9OPaaazr6k
        DPoJ6eTZ2ZZwv+UsLnzH91b0Vw==
X-Google-Smtp-Source: APXvYqyjd7ZrSwYYmw978V8fjgofoBdAe7oUaU3LEfGBuDO/2NMl98HOIH2vayVmNwq0aY4meeWBNw==
X-Received: by 2002:a7b:c95a:: with SMTP id i26mr3998130wml.175.1562843986138;
        Thu, 11 Jul 2019 04:19:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id o24sm10071088wmh.2.2019.07.11.04.19.45
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 04:19:45 -0700 (PDT)
Subject: Re: [PULL 00/19] Migration patches
To:     Juan Quintela <quintela@redhat.com>, qemu-devel@nongnu.org
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20190711104412.31233-1-quintela@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c2bfa537-8a5a-86a1-495c-a6c1d0f85dc5@redhat.com>
Date:   Thu, 11 Jul 2019 13:19:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190711104412.31233-1-quintela@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/07/19 12:43, Juan Quintela wrote:
> The following changes since commit 6df2cdf44a82426f7a59dcb03f0dd2181ed7fdfa:
> 
>   Update version for v4.1.0-rc0 release (2019-07-09 17:21:53 +0100)
> 
> are available in the Git repository at:
> 
>   https://github.com/juanquintela/qemu.git tags/migration-pull-request
> 
> for you to fetch changes up to 0b47e79b3d04f500b6f3490628905ec5884133df:
> 
>   migration: allow private destination ram with x-ignore-shared (2019-07-11 12:30:40 +0200)

Aren't we in hard freeze already?

Paolo

> ----------------------------------------------------------------
> Migration pull request
> 
> ----------------------------------------------------------------
> 
> Juan Quintela (3):
>   migration: fix multifd_recv event typo
>   migration-test: rename parameter to parameter_int
>   migration-test: Add migration multifd test
> 
> Peng Tao (1):
>   migration: allow private destination ram with x-ignore-shared
> 
> Peter Xu (10):
>   migration: No need to take rcu during sync_dirty_bitmap
>   memory: Don't set migration bitmap when without migration
>   bitmap: Add bitmap_copy_with_{src|dst}_offset()
>   memory: Pass mr into snapshot_and_clear_dirty
>   memory: Introduce memory listener hook log_clear()
>   kvm: Update comments for sync_dirty_bitmap
>   kvm: Persistent per kvmslot dirty bitmap
>   kvm: Introduce slots lock for memory listener
>   kvm: Support KVM_CLEAR_DIRTY_LOG
>   migration: Split log_clear() into smaller chunks
> 
> Wei Yang (5):
>   migration/multifd: call multifd_send_sync_main when sending
>     RAM_SAVE_FLAG_EOS
>   migration/xbzrle: update cache and current_data in one place
>   cutils: remove one unnecessary pointer operation
>   migration/multifd: sync packet_num after all thread are done
>   migratioin/ram.c: reset complete_round when we gets a queued page
> 
>  accel/kvm/kvm-all.c          |  260 +-
>  accel/kvm/trace-events       |    1 +
>  exec.c                       |   15 +-
>  include/exec/memory.h        |   19 +
>  include/exec/memory.h.rej    |   26 +
>  include/exec/ram_addr.h      |   92 +-
>  include/exec/ram_addr.h.orig |  488 ++++
>  include/qemu/bitmap.h        |    9 +
>  include/sysemu/kvm_int.h     |    4 +
>  memory.c                     |   56 +-
>  memory.c.rej                 |   17 +
>  migration/migration.c        |    4 +
>  migration/migration.h        |   27 +
>  migration/migration.h.orig   |  315 +++
>  migration/ram.c              |   93 +-
>  migration/ram.c.orig         | 4599 ++++++++++++++++++++++++++++++++++
>  migration/ram.c.rej          |   33 +
>  migration/trace-events       |    3 +-
>  migration/trace-events.orig  |  297 +++
>  tests/Makefile.include       |    2 +
>  tests/migration-test.c       |  103 +-
>  tests/test-bitmap.c          |   72 +
>  util/bitmap.c                |   85 +
>  util/cutils.c                |    8 +-
>  24 files changed, 6545 insertions(+), 83 deletions(-)
>  create mode 100644 include/exec/memory.h.rej
>  create mode 100644 include/exec/ram_addr.h.orig
>  create mode 100644 memory.c.rej
>  create mode 100644 migration/migration.h.orig
>  create mode 100644 migration/ram.c.orig
>  create mode 100644 migration/ram.c.rej
>  create mode 100644 migration/trace-events.orig
>  create mode 100644 tests/test-bitmap.c
> 

