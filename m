Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BD32B4F01
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731942AbgKPSQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:16:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53744 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731241AbgKPSQ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 13:16:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605550616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LlH3UjmNamylT5Q+nF61tpNDy+5E9OgBm35jVziY94U=;
        b=TBa8unayLSWx19pUy+fcCbRLs++o86FUwOdpOkyzTfKScvipjRHAV7nfirERGG6RhYu4Kq
        t4TPai7EZ8ok3wu/aPojq++Lt2anp1faAgYiB868XZagewLbl0cuqYY/MkYvwiA1cIQ6hO
        CpJioYSL1rhe4fFyMsySeNCfxLZsM1Q=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-up2ldFyOPOKMJsXSJZu9mg-1; Mon, 16 Nov 2020 13:16:53 -0500
X-MC-Unique: up2ldFyOPOKMJsXSJZu9mg-1
Received: by mail-wr1-f70.google.com with SMTP id h11so11358759wrq.20
        for <kvm@vger.kernel.org>; Mon, 16 Nov 2020 10:16:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LlH3UjmNamylT5Q+nF61tpNDy+5E9OgBm35jVziY94U=;
        b=QR27FIf3ZmkN6AFvjO95cC6rfNM/d1NSUHG3qUhA2m5OMMbhJqbR9GvZgCopmQJ6Tw
         +huK9PKlrcxEszIYUcqnjO50APxJGB+ET0wf/Hm93iOCPMlQUjT/TT3M7jL061al1Dwf
         RBo/EM71sH1Jhb9PzuD2ABxq6AWOhZewBxfrRgZGjw6uPI6q7XZYxGprOiIxAMH6HPDQ
         8Ct/QPcPZNi7DQP8G6/JFyQx9rdw5MgF7UJMzJLhAEjD6FUhiNIQ4ZdK1jqIYEs/hjvt
         BlT9NM0/LE3pE0l3MyvurYkPxbsSo2MobHwcdWh2QXn1Zr6wzcGDXZLKoTIShFmoxGFB
         pzYg==
X-Gm-Message-State: AOAM533r0aPy8oZpSwCwI9qRjYwk837ALe5Fqq8RXob/ue5HIvE2gQ0g
        iR7ao0OYPQtCuXwT4SKAZQqCC4BEpcJVwfNlq8IMYVSbhi9nPdpCAfKf2B/xQIh0xD0qfy3ZDNU
        z523+tjorAyab
X-Received: by 2002:a1c:98cd:: with SMTP id a196mr190364wme.42.1605550612344;
        Mon, 16 Nov 2020 10:16:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwvEb+8Q7NBfnuNr3VVO9wYDcbPMxflAIM1/H15nQAAOv8HQ3UpiE1iIgsid7gqf9XbgA42WQ==
X-Received: by 2002:a1c:98cd:: with SMTP id a196mr190344wme.42.1605550612086;
        Mon, 16 Nov 2020 10:16:52 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a14sm105072wmj.40.2020.11.16.10.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 10:16:51 -0800 (PST)
Subject: Re: [PATCH v3 0/4] KVM: selftests: Cleanups, take 2
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, bgardon@google.com,
        peterx@redhat.com
References: <20201116121942.55031-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <902d4020-e295-b21f-cc7a-df5cdfc056ea@redhat.com>
Date:   Mon, 16 Nov 2020 19:16:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116121942.55031-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/11/20 13:19, Andrew Jones wrote:
> This series attempts to clean up demand_paging_test, dirty_log_perf_test,
> and dirty_log_test by factoring out common code, creating some new API
> along the way. It also splits include/perf_test_util.h into a more
> conventional header and source pair.
> 
> I've tested on x86 and AArch64 (one config each), but not s390x.
> 
> v3:
>   - Rebased remaining four patches from v2 onto kvm/queue
>   - Picked up r-b's from Peter and Ben
> 
> v2: https://www.spinics.net/lists/kvm/msg228711.html

Unfortunately patch 2 is still broken:

$ ./dirty_log_test -M dirty-ring
Setting log mode to: 'dirty-ring'
Test iterations: 32, interval: 10 (ms)
Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
==== Test Assertion Failure ====
   lib/kvm_util.c:85: ret == 0
   pid=2010122 tid=2010122 - Invalid argument
      1	0x0000000000402ee7: vm_enable_cap at kvm_util.c:84
      2	0x0000000000403004: vm_enable_dirty_ring at kvm_util.c:124
      3	0x00000000004021a5: log_mode_create_vm_done at dirty_log_test.c:453
      4	 (inlined by) run_test at dirty_log_test.c:683
      5	0x000000000040b643: for_each_guest_mode at guest_modes.c:37
      6	0x00000000004019c2: main at dirty_log_test.c:864
      7	0x00007fe3f48207b2: ?? ??:0
      8	0x0000000000401aad: _start at ??:?
   KVM_ENABLE_CAP IOCTL failed,
   rc: -1 errno: 22

(Also fails without -M).

Paolo

> 
> Thanks,
> drew
> 
> 
> Andrew Jones (4):
>    KVM: selftests: Factor out guest mode code
>    KVM: selftests: dirty_log_test: Remove create_vm
>    KVM: selftests: Use vm_create_with_vcpus in create_vm
>    KVM: selftests: Implement perf_test_util more conventionally
> 
>   tools/testing/selftests/kvm/Makefile          |   2 +-
>   .../selftests/kvm/demand_paging_test.c        | 118 ++++--------
>   .../selftests/kvm/dirty_log_perf_test.c       | 145 +++++---------
>   tools/testing/selftests/kvm/dirty_log_test.c  | 179 +++++-------------
>   .../selftests/kvm/include/guest_modes.h       |  21 ++
>   .../testing/selftests/kvm/include/kvm_util.h  |   9 +
>   .../selftests/kvm/include/perf_test_util.h    | 167 ++--------------
>   tools/testing/selftests/kvm/lib/guest_modes.c |  70 +++++++
>   tools/testing/selftests/kvm/lib/kvm_util.c    |   9 +-
>   .../selftests/kvm/lib/perf_test_util.c        | 134 +++++++++++++
>   10 files changed, 378 insertions(+), 476 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/include/guest_modes.h
>   create mode 100644 tools/testing/selftests/kvm/lib/guest_modes.c
>   create mode 100644 tools/testing/selftests/kvm/lib/perf_test_util.c
> 

