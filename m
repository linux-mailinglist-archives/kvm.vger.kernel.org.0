Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9941C2A9696
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 14:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbgKFNBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 08:01:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40915 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727209AbgKFNBU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 08:01:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604667678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C6JSXY/MmF+pAWBPILzq77dsC/lcfN8QzPGDztLP/ZE=;
        b=XV1qYC1ewXGlkkOXt+ahlKKmO/njAsaIGpeiVmTtY17Jv0IYi1AwAsUiXj9vnqzqE5zQtU
        5PcR3/iz09KqjWUSy4/sXXrZH+mghsveTimlOlx6y5mOepSCrxa/xiJ/qo4u/tvXE5HFi3
        0NH26WphbfWvsUU/c3odKFkHDzBXPbQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-xFsj4Z7tO8ixdXjb5ADlnA-1; Fri, 06 Nov 2020 08:01:17 -0500
X-MC-Unique: xFsj4Z7tO8ixdXjb5ADlnA-1
Received: by mail-wr1-f69.google.com with SMTP id q15so445498wrw.8
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 05:01:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C6JSXY/MmF+pAWBPILzq77dsC/lcfN8QzPGDztLP/ZE=;
        b=AAEdOj8g69C5zS8ci4u0WoYVal80LKjj6moQNJYFIFWDEJ9oMcf1Pz/kSQ4ZEL46oW
         pRZq3Ri42/f8RVdMtdHQoopyzDRlUXMeq2VwTVq4FF0kNnIjwyKTSdJpN2qkphuc5Osv
         9N37q40eA2WiaKAQ0JtQb6Srcn5WBooKSHLeFk0ypzgMkHqRhnebZSfOgo2fDRxuIFRP
         azGpSD4LJo4VcD1KsO68vbv5+ixxXp3B8bKIGMegPVo9JRHVRZ6i03d9xGpCaScOLsI4
         c0C7BjYnSZNzmfpwaDWrWqbCFsfk5Ekj1btRBjzzLodtaJ6jfFejw65yiRGpBBP+xPNh
         gFZg==
X-Gm-Message-State: AOAM533ojcbviVJ1fjRhmOushBUwFbRrBmNIIGORT6PK1YQPixTIhb11
        50pp2xPkAx7UFlfGHvUAMNd8q55PTvk+6+MgeVcF8ycryToAxFjCNNaSPDGFNORCFrjmmDKaAgi
        iN97KJ4KcspmR
X-Received: by 2002:a5d:62cf:: with SMTP id o15mr2477854wrv.49.1604667675053;
        Fri, 06 Nov 2020 05:01:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy52XHN4u/uSbUXzcodIK/a3JMVVtek62+m3Eyj+zfcjU/y3aFwxM31TE1/xxKMTWwVtEbJDA==
X-Received: by 2002:a5d:62cf:: with SMTP id o15mr2477834wrv.49.1604667674877;
        Fri, 06 Nov 2020 05:01:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id u81sm2473132wmb.27.2020.11.06.05.01.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 05:01:14 -0800 (PST)
Subject: Re: [PATCH 00/11] KVM: selftests: Cleanups
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, bgardon@google.com,
        peterx@redhat.com
References: <20201104212357.171559-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3975bb56-3af2-6387-3b45-a3cac4787829@redhat.com>
Date:   Fri, 6 Nov 2020 14:01:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201104212357.171559-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/11/20 22:23, Andrew Jones wrote:
> This series attempts to clean up demand_paging_test and dirty_log_test
> by factoring out common code, creating some new API along the way. It's
> main goal is to prepare for even more factoring that Ben and Peter want
> to do. The series would have a nice negative diff stat, but it also
> picks up a few of Peter's patches for his new dirty log test. So, the
> +/- diff stat is close to equal. It's not as close as an electoral vote
> count, but it's close.
> 
> I've tested on x86 and AArch64 (one config each), but not s390x.
> 
> Thanks,
> drew
> 
> 
> Andrew Jones (8):
>    KVM: selftests: Add x86_64/tsc_msrs_test to .gitignore
>    KVM: selftests: Drop pointless vm_create wrapper
>    KVM: selftests: Make the per vcpu memory size global
>    KVM: selftests: Make the number of vcpus global
>    KVM: selftests: Factor out guest mode code
>    KVM: selftests: Make vm_create_default common
>    KVM: selftests: Introduce vm_create_[default_]vcpus
>    KVM: selftests: Remove create_vm
> 
> Peter Xu (3):
>    KVM: selftests: Always clear dirty bitmap after iteration
>    KVM: selftests: Use a single binary for dirty/clear log test
>    KVM: selftests: Introduce after_vcpu_run hook for dirty log test
> 
>   tools/testing/selftests/kvm/.gitignore        |   2 +-
>   tools/testing/selftests/kvm/Makefile          |   4 +-
>   .../selftests/kvm/clear_dirty_log_test.c      |   6 -
>   .../selftests/kvm/demand_paging_test.c        | 213 +++-------
>   tools/testing/selftests/kvm/dirty_log_test.c  | 372 ++++++++++--------
>   .../selftests/kvm/include/aarch64/processor.h |   3 +
>   .../selftests/kvm/include/guest_modes.h       |  21 +
>   .../testing/selftests/kvm/include/kvm_util.h  |  20 +-
>   .../selftests/kvm/include/s390x/processor.h   |   4 +
>   .../selftests/kvm/include/x86_64/processor.h  |   4 +
>   .../selftests/kvm/lib/aarch64/processor.c     |  17 -
>   tools/testing/selftests/kvm/lib/guest_modes.c |  70 ++++
>   tools/testing/selftests/kvm/lib/kvm_util.c    |  62 ++-
>   .../selftests/kvm/lib/s390x/processor.c       |  22 --
>   .../selftests/kvm/lib/x86_64/processor.c      |  32 --
>   15 files changed, 445 insertions(+), 407 deletions(-)
>   delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c
>   create mode 100644 tools/testing/selftests/kvm/include/guest_modes.h
>   create mode 100644 tools/testing/selftests/kvm/lib/guest_modes.c
> 

Queued (or overridden by patches already in queue) patches 1-8, thanks.

