Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B8223CED0
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgHETGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:06:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57717 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728620AbgHETFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 15:05:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596654310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1viLuxk0GnKxOO/7G5IzuBwzJlJ/DytRi5gaw1nJvSY=;
        b=BydiCj0uD/vBVBGpwWHBPnOL6PNCLsFCPI235/x0ueJ6YLfqEkHX0cDqQsNzlZjT4cLoyN
        cTu3d6lWybJrUyDF9kFZOCjoMJ+/d/pGNaXdpPVXjC5bmAS6xgW6K4S9FEM1Ko93jxj4Y+
        g0c+/mXXBnXqi5uTM5DwUJ2SyXJCvfM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-_He98q9xNDSwZFaXybxmPg-1; Wed, 05 Aug 2020 14:46:39 -0400
X-MC-Unique: _He98q9xNDSwZFaXybxmPg-1
Received: by mail-wm1-f72.google.com with SMTP id d22so3064088wmd.2
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 11:46:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1viLuxk0GnKxOO/7G5IzuBwzJlJ/DytRi5gaw1nJvSY=;
        b=LY09ws+5N88qIoE9L0pjVTDAimOU+TKMCzKdDFjQsl40ZVoUp6AMmbHDfO3RsLDDj7
         bOuvzYvKO8YLBzQFr1Is8fRO+LVc+Re5ARFycTGFuEk6GOlWj1/YUB678yIQJ64GWe/2
         MvpI7hwL/kmFtDkAv/7Jnc1tAOShMIJfkau8Z/vbg5glQtCIppBFsk1CRLGfh7z9wjvZ
         KrS8CM70xbi0o2yHq85JupHR6SlURmsP1xHgxmsyobLYLeHxmTyt62KyTN11Os8bk5DW
         W4MeYpcA9j7POlqbcq9niCT7ngFkYLNG119NGCp535pQ86cR4d6qmDSRLMBSM80QjP93
         uq1A==
X-Gm-Message-State: AOAM53249rZha6eqpxDpMDv31kJJbOYwxLVgCCMcxk4nu934+pTwCbsO
        BVzd0AtbQynBAGNaTvgmLeWp7BqyiHZrsT/P7nv96PfWXM5/2VVROnTAF3cQR+7+EeF44vxxk2+
        Vp52T6Dtgb7CV
X-Received: by 2002:a5d:4d0b:: with SMTP id z11mr3826253wrt.315.1596653198139;
        Wed, 05 Aug 2020 11:46:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaAeXoKsSwOUZMEw07tBo8VvI2fkmNgSisJmlbmRr9iXf9WJAIdSTTTuGW23BkEZhLRqtbOQ==
X-Received: by 2002:a5d:4d0b:: with SMTP id z11mr3826236wrt.315.1596653197850;
        Wed, 05 Aug 2020 11:46:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7841:78cc:18c6:1e20? ([2001:b07:6468:f312:7841:78cc:18c6:1e20])
        by smtp.gmail.com with ESMTPSA id c10sm3668988wro.84.2020.08.05.11.46.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 11:46:37 -0700 (PDT)
Subject: Re: [PATCH v3 0/5] KVM_{GET,SET}_TSC_OFFSET ioctls
To:     Oliver Upton <oupton@google.com>, kvm list <kvm@vger.kernel.org>
Cc:     Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>
References: <20200722032629.3687068-1-oupton@google.com>
 <CAOQ_QsgeN4DCghH6ibb68C+P0ETr77s2s7Us+uxF6E6LFx62tw@mail.gmail.com>
 <CAOQ_QshUE_OQmAuWd6SzdfXvn7Y6SVukcC1669Re0TRGCoeEgg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f97789f6-43b4-a607-5af8-4f522f753761@redhat.com>
Date:   Wed, 5 Aug 2020 20:46:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAOQ_QshUE_OQmAuWd6SzdfXvn7Y6SVukcC1669Re0TRGCoeEgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/08/20 18:06, Oliver Upton wrote:
> On Tue, Jul 28, 2020 at 11:33 AM Oliver Upton <oupton@google.com> wrote:
>>
>> On Tue, Jul 21, 2020 at 8:26 PM Oliver Upton <oupton@google.com> wrote:
>>>
>>> To date, VMMs have typically restored the guest's TSCs by value using
>>> the KVM_SET_MSRS ioctl for each vCPU. However, restoring the TSCs by
>>> value introduces some challenges with synchronization as the TSCs
>>> continue to tick throughout the restoration process. As such, KVM has
>>> some heuristics around TSC writes to infer whether or not the guest or
>>> host is attempting to synchronize the TSCs.
>>>
>>> Instead of guessing at the intentions of a VMM, it'd be better to
>>> provide an interface that allows for explicit synchronization of the
>>> guest's TSCs. To that end, this series introduces the
>>> KVM_{GET,SET}_TSC_OFFSET ioctls, yielding control of the TSC offset to
>>> userspace.
>>>
>>> v2 => v3:
>>>  - Mark kvm_write_tsc_offset() as static (whoops)
>>>
>>> v1 => v2:
>>>  - Added clarification to the documentation of KVM_SET_TSC_OFFSET to
>>>    indicate that it can be used instead of an IA32_TSC MSR restore
>>>    through KVM_SET_MSRS
>>>  - Fixed KVM_SET_TSC_OFFSET to participate in the existing TSC
>>>    synchronization heuristics, thereby enabling the KVM masterclock when
>>>    all vCPUs are in phase.
>>>
>>> Oliver Upton (4):
>>>   kvm: x86: refactor masterclock sync heuristics out of kvm_write_tsc
>>>   kvm: vmx: check tsc offsetting with nested_cpu_has()
>>>   selftests: kvm: use a helper function for reading cpuid
>>>   selftests: kvm: introduce tsc_offset_test
>>>
>>> Peter Hornyack (1):
>>>   kvm: x86: add KVM_{GET,SET}_TSC_OFFSET ioctls
>>>
>>>  Documentation/virt/kvm/api.rst                |  31 ++
>>>  arch/x86/include/asm/kvm_host.h               |   1 +
>>>  arch/x86/kvm/vmx/vmx.c                        |   2 +-
>>>  arch/x86/kvm/x86.c                            | 147 ++++---
>>>  include/uapi/linux/kvm.h                      |   5 +
>>>  tools/testing/selftests/kvm/.gitignore        |   1 +
>>>  tools/testing/selftests/kvm/Makefile          |   1 +
>>>  .../testing/selftests/kvm/include/test_util.h |   3 +
>>>  .../selftests/kvm/include/x86_64/processor.h  |  15 +
>>>  .../selftests/kvm/include/x86_64/svm_util.h   |  10 +-
>>>  .../selftests/kvm/include/x86_64/vmx.h        |   9 +
>>>  tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
>>>  tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  11 +
>>>  .../selftests/kvm/x86_64/tsc_offset_test.c    | 362 ++++++++++++++++++
>>>  14 files changed, 550 insertions(+), 49 deletions(-)
>>>  create mode 100644 tools/testing/selftests/kvm/x86_64/tsc_offset_test.c
>>>
>>> --
>>> 2.28.0.rc0.142.g3c755180ce-goog
>>>
>>
>> Ping :)
> 
> Ping

Hi Oliver,

I saw these on vacation and decided I would delay them to 5.10.  However
they are definitely on my list.

I have one possibly very stupid question just by looking at the cover
letter: now that you've "fixed KVM_SET_TSC_OFFSET to participate in the
existing TSC synchronization heuristics" what makes it still not
"guessing the intentions of a VMM"?  (No snark intended, just quoting
the parts that puzzled me a bit).

My immediate reaction was that we should just migrate the heuristics
state somehow, but perhaps I'm missing something obvious.

Paolo

