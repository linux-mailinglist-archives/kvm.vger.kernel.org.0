Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B619927C03C
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 10:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbgI2I6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 04:58:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58036 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727035AbgI2I6n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 04:58:43 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601369922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9jRT8eA9mpjJTYD9d7uu+BPwsbppj+9Qbebe40cVOSA=;
        b=cbwiVDoFvs50NQN4OYSQ+7GiXmdUy1V+/d6Sz/0DIvrvmB0Yg9N7gWcQNLd0AgqM1cOJvQ
        xEy/boYwzGA/bZkhExCBwa3hiTReMPmCW6shZcyFeTt74VM5xl79SPS4M2Jo45wvuGhKRc
        XkLmL2HW/U1wSfTBFw1t/4aKnjz5wbw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-GP81xXMZN_-p7PHZ8IcjPw-1; Tue, 29 Sep 2020 04:58:40 -0400
X-MC-Unique: GP81xXMZN_-p7PHZ8IcjPw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05B751054F92;
        Tue, 29 Sep 2020 08:58:39 +0000 (UTC)
Received: from thuth.remote.csb (unknown [10.40.193.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 127A47881E;
        Tue, 29 Sep 2020 08:58:37 +0000 (UTC)
Subject: Re: [kvm-unit-tests PULL 00/11] s390x and generic script updates
To:     Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20200928174958.26690-1-thuth@redhat.com>
 <fa187ed1-0e02-62e5-ba27-4f64782b3cfd@redhat.com>
 <b143b9d8-6c5f-b850-ba96-34b9bb337d22@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <7cc4071f-60da-7699-685e-b108c58dff79@redhat.com>
Date:   Tue, 29 Sep 2020 10:58:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <b143b9d8-6c5f-b850-ba96-34b9bb337d22@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/09/2020 10.49, Janosch Frank wrote:
> On 9/29/20 10:38 AM, Paolo Bonzini wrote:
>> On 28/09/20 19:49, Thomas Huth wrote:
>>>  Hi Paolo,
>>>
>>> the following changes since commit 58c94d57a51a6927a68e3f09627b2d85e3404c0f:
>>>
>>>   travis.yml: Use TRAVIS_BUILD_DIR to refer to the top directory (2020-09-25 10:00:36 +0200)
>>>
>>> are available in the Git repository at:
>>>
>>>   https://gitlab.com/huth/kvm-unit-tests.git tags/pull-request-2020-09-28
>>>
>>> for you to fetch changes up to b508e1147055255ecce93a95916363bda8c8f299:
>>>
>>>   scripts/arch-run: use ncat rather than nc. (2020-09-28 15:03:50 +0200)
>>>
>>> ----------------------------------------------------------------
>>> - s390x protected VM support
>>> - Some other small s390x improvements
>>> - Generic improvements in the scripts (better TAP13 names, nc -> ncat, ...)
>>> ----------------------------------------------------------------
>>>
>>> Jamie Iles (1):
>>>       scripts/arch-run: use ncat rather than nc.
>>>
>>> Marc Hartmayer (6):
>>>       runtime.bash: remove outdated comment
>>>       Use same test names in the default and the TAP13 output format
>>>       common.bash: run `cmd` only if a test case was found
>>>       scripts: add support for architecture dependent functions
>>>       run_tests/mkstandalone: add arch_cmd hook
>>>       s390x: add Protected VM support
>>>
>>> Thomas Huth (4):
>>>       configure: Add a check for the bash version
>>>       travis.yml: Update from Bionic to Focal
>>>       travis.yml: Update the list of s390x tests
>>>       s390x/selftest: Fix constraint of inline assembly
>>>
>>>  .travis.yml             |  7 ++++---
>>>  README.md               |  3 ++-
>>>  configure               | 14 ++++++++++++++
>>>  run_tests.sh            | 18 +++++++++---------
>>>  s390x/Makefile          | 15 ++++++++++++++-
>>>  s390x/selftest.c        |  2 +-
>>>  s390x/selftest.parmfile |  1 +
>>>  s390x/unittests.cfg     |  1 +
>>>  scripts/arch-run.bash   |  6 +++---
>>>  scripts/common.bash     | 21 +++++++++++++++++++--
>>>  scripts/mkstandalone.sh |  4 ----
>>>  scripts/runtime.bash    |  9 +++------
>>>  scripts/s390x/func.bash | 35 +++++++++++++++++++++++++++++++++++
>>>  13 files changed, 106 insertions(+), 30 deletions(-)
>>>  create mode 100644 s390x/selftest.parmfile
>>>  create mode 100644 scripts/s390x/func.bash
>>>
>>
>> Pulled, thanks (for now to my clone; waiting for CI to complete).
>> Should we switch to Gitlab merge requests for pull requests only (i.e.
>> patches still go on the mailing list)?
>>
>> Paolo
>>
> 
> Hrm, that would force everyone to use Gitlab and I see some value in
> having pull request mails on the lists. You just opened the Pandora's
> box of discussions :-)
> 
> If it's easier for you I'd be open to open a marge request and send out
> pull mails at the same time so people can comment without login to Gitlab.

... or maybe the people who already have a gitlab account could simply
include the URL to their CI run in their pull request cover letter...?

 Thomas

