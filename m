Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758AB27BFB5
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 10:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbgI2Iik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 04:38:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727474AbgI2Iij (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 04:38:39 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601368718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZOcN8D8lplbSyngCMYSWkzRt4MxqDxAghoicRfiMun0=;
        b=dk3yjMjnxHywe2oveED5IC+VtnhgckqNz4/M/E2KQqf9/1HOuvbI5j5G9cgVwClwFvRQzP
        PkntTr8vnbYZQMI7OfnAnOCN68pwNxyg4JxCpZe4fhtMeFrCKxA+EdBbhkxUwvOI5VwuZv
        r8Iq0G+jlxEQ0Psia/yYyCttNKEM8Gw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-2o8zL5smORqfnF15qcUz1A-1; Tue, 29 Sep 2020 04:38:33 -0400
X-MC-Unique: 2o8zL5smORqfnF15qcUz1A-1
Received: by mail-wr1-f71.google.com with SMTP id v5so1470440wrr.0
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 01:38:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZOcN8D8lplbSyngCMYSWkzRt4MxqDxAghoicRfiMun0=;
        b=Z70HFDVRTk3/e7VNdW1z6UZSWffV25mRJxHSIm5hozLQK4ZD3XvczR0B9feNYfZcEe
         1NTl2WhkXWFh8KWKFiWGG5xVFv5dEQCZikNYMwEnvCPWZGmni3x/ZfJBQfbBuhp15O08
         ougPm93xfyOzJ1Icrto2ERx8ozHPs2rj/r7ojqLgZQMK8zIAgO8ysSqp8uwpm1m0UN+N
         Hk/hB4n3FSFaKz01iGPbfddFfnSXmRuSZqIitOGKeYHv0WaLVBYdGI8Nu21+zR8n27Yd
         sw6a6Vipn5ZYg2EAyuEYybVEQQ1Iui0PpZmEvXs8VrrG2IAMUTdZmAhsbYHeqYb6hBel
         BgnA==
X-Gm-Message-State: AOAM531oSOs7SjE9On6+KU2YSdmYemPHSxjMI39rASgPtzbGCBybiJZ4
        rNrQh6GwgtF7m9pqAVMMx5LWW8/G+e3ZO9SO52zYDG9oXjQ9LG+Y7F1sit0HjeaU9OzZgFb/xps
        iJwKZWKNQYe7o
X-Received: by 2002:adf:90a2:: with SMTP id i31mr3174270wri.276.1601368712046;
        Tue, 29 Sep 2020 01:38:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhLC11wiMgvdwG5borpsJw3UTu+mOIS1ClSfLvOv0d/LoYJ07zqZkrmAStdwGcApDNyfA2VA==
X-Received: by 2002:adf:90a2:: with SMTP id i31mr3174241wri.276.1601368711759;
        Tue, 29 Sep 2020 01:38:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9dbe:2c91:3d1b:58c6? ([2001:b07:6468:f312:9dbe:2c91:3d1b:58c6])
        by smtp.gmail.com with ESMTPSA id y207sm4450549wmc.17.2020.09.29.01.38.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 01:38:31 -0700 (PDT)
Subject: Re: [kvm-unit-tests PULL 00/11] s390x and generic script updates
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>
References: <20200928174958.26690-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fa187ed1-0e02-62e5-ba27-4f64782b3cfd@redhat.com>
Date:   Tue, 29 Sep 2020 10:38:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200928174958.26690-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/09/20 19:49, Thomas Huth wrote:
>  Hi Paolo,
> 
> the following changes since commit 58c94d57a51a6927a68e3f09627b2d85e3404c0f:
> 
>   travis.yml: Use TRAVIS_BUILD_DIR to refer to the top directory (2020-09-25 10:00:36 +0200)
> 
> are available in the Git repository at:
> 
>   https://gitlab.com/huth/kvm-unit-tests.git tags/pull-request-2020-09-28
> 
> for you to fetch changes up to b508e1147055255ecce93a95916363bda8c8f299:
> 
>   scripts/arch-run: use ncat rather than nc. (2020-09-28 15:03:50 +0200)
> 
> ----------------------------------------------------------------
> - s390x protected VM support
> - Some other small s390x improvements
> - Generic improvements in the scripts (better TAP13 names, nc -> ncat, ...)
> ----------------------------------------------------------------
> 
> Jamie Iles (1):
>       scripts/arch-run: use ncat rather than nc.
> 
> Marc Hartmayer (6):
>       runtime.bash: remove outdated comment
>       Use same test names in the default and the TAP13 output format
>       common.bash: run `cmd` only if a test case was found
>       scripts: add support for architecture dependent functions
>       run_tests/mkstandalone: add arch_cmd hook
>       s390x: add Protected VM support
> 
> Thomas Huth (4):
>       configure: Add a check for the bash version
>       travis.yml: Update from Bionic to Focal
>       travis.yml: Update the list of s390x tests
>       s390x/selftest: Fix constraint of inline assembly
> 
>  .travis.yml             |  7 ++++---
>  README.md               |  3 ++-
>  configure               | 14 ++++++++++++++
>  run_tests.sh            | 18 +++++++++---------
>  s390x/Makefile          | 15 ++++++++++++++-
>  s390x/selftest.c        |  2 +-
>  s390x/selftest.parmfile |  1 +
>  s390x/unittests.cfg     |  1 +
>  scripts/arch-run.bash   |  6 +++---
>  scripts/common.bash     | 21 +++++++++++++++++++--
>  scripts/mkstandalone.sh |  4 ----
>  scripts/runtime.bash    |  9 +++------
>  scripts/s390x/func.bash | 35 +++++++++++++++++++++++++++++++++++
>  13 files changed, 106 insertions(+), 30 deletions(-)
>  create mode 100644 s390x/selftest.parmfile
>  create mode 100644 scripts/s390x/func.bash
> 

Pulled, thanks (for now to my clone; waiting for CI to complete).
Should we switch to Gitlab merge requests for pull requests only (i.e.
patches still go on the mailing list)?

Paolo

