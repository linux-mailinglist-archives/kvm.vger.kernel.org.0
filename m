Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87ECA27FC5C
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 11:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731663AbgJAJWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 05:22:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730862AbgJAJWJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 05:22:09 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601544128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZR3XgJhF9FNC9FEpS6LlX59CkslLhgyzV5YJh9Pwrew=;
        b=a1l3kCN9Vbn5XXMO4dv4Jk4e9hmOFALAth1QIi7CHWNlJFx561O46g0No81ibIHcXqc5Q8
        imUXliiq+BqAYa1hzSDZNLKtLlzl8PaLWEYAlKN++cMwEA+rBPjasZSWIykpAFUamBbCT2
        PK8Zv26XYJrfIpm2tJk12VBd4ZQ/kjs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-TtslkUn8N2GOdUCey7oqSw-1; Thu, 01 Oct 2020 05:22:01 -0400
X-MC-Unique: TtslkUn8N2GOdUCey7oqSw-1
Received: by mail-wm1-f69.google.com with SMTP id x6so985979wmi.1
        for <kvm@vger.kernel.org>; Thu, 01 Oct 2020 02:22:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZR3XgJhF9FNC9FEpS6LlX59CkslLhgyzV5YJh9Pwrew=;
        b=nBOwPqgjlFTGTEGdDkbnXceT3a8savNLlC+grIdvNWmiK719EiSodRiJK/vUSynnUU
         vbZyqiuPrR4++n9gFC6bvmU7jvxXl65KBvAHosNutCYcHpaHwjubLcWAFBkEQv0qVz4B
         ik0EAM1uW0dhWL/Ro7dG0P1asWFCdzL4XJt2eJOqYsiX0n2XEKMSSqxeM4f2s6pbXWWM
         Ko6X9cY0sKzD36Y8jcxjF7t7u9caojdHseGaje3CNUL0IWuVaC73BjS4JM49ueNGNLx6
         WtpYYzVBbxdHY129Qv0/U+9le0NKeQXbNqOvbkcYRpLtCr4YzjaW1gSpf0owrIoZGnyP
         Fm9A==
X-Gm-Message-State: AOAM5318w1kCAt5+13ahuwAjnvMkw+p0R+kPQIp5JiPfLKQ0VQFJnPVw
        fo1ORHBAQBXgdhhtNh8OguNsceECR8ymuL/wTot/XOG/2A5lTG74ABckB2ecMW6Fi+jSt/5CvN/
        0Yj/31E7gHuk1
X-Received: by 2002:adf:f084:: with SMTP id n4mr7717392wro.26.1601544120530;
        Thu, 01 Oct 2020 02:22:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHAglboNLAKB8yzKkKKKoqPM7iLa5bjG05l3bKO4t+eJQe0qkvv6vZOK/4n4O0nj1+zWyXew==
X-Received: by 2002:adf:f084:: with SMTP id n4mr7717363wro.26.1601544120211;
        Thu, 01 Oct 2020 02:22:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f44:4e79:488f:33b3? ([2001:b07:6468:f312:f44:4e79:488f:33b3])
        by smtp.gmail.com with ESMTPSA id d5sm8573630wrb.28.2020.10.01.02.21.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2020 02:21:59 -0700 (PDT)
Subject: Re: [kvm-unit-tests PULL 00/11] s390x and generic script updates
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>
References: <20200928174958.26690-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e8804b50-a2b7-bab1-8245-232a7d584322@redhat.com>
Date:   Thu, 1 Oct 2020 11:21:59 +0200
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

Pulled, thanks.

Paolo

