Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A4B2DFFCF
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 19:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgLUSbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 13:31:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgLUSbs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Dec 2020 13:31:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608575421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3UVTO/qhRLhtgNyc/irufPfhTpwhxtmXnbdRXbag8H0=;
        b=TZXCMMqnEZVgsejpajy/nCZhMpGpjZD+EHtiYcRahCJtz0IJKDudSbptcGrwUjazXKiPzs
        ZMiCSZev6n66aHl+YDAKtcVL8tuq3joalBlLlxCBs0B2oc+iJlg49haKX/6zYxWOEqHFCa
        wGI3e+3Zm31SivNXJM+yAil4rS84V/w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-vqI1ESU6OZWy4JHpdpFyUQ-1; Mon, 21 Dec 2020 13:30:19 -0500
X-MC-Unique: vqI1ESU6OZWy4JHpdpFyUQ-1
Received: by mail-wr1-f72.google.com with SMTP id 88so9274835wrc.17
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 10:30:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3UVTO/qhRLhtgNyc/irufPfhTpwhxtmXnbdRXbag8H0=;
        b=hWb2pmivDAEZU2gEL0iBMFP+jPHaU9yU84Eh7v4Mdf9cyXzDSCKvsmqMPd8uKry3W4
         vsZnLtiBbri0houmwI0ubkLetu91Ljm5LJIK/7nUvRsqmMigR9uDk0SbounenE92cAPD
         WRySt+h2Wa+JYUG/WuPfMfSziVXSwW2q86CSrgXmELaHSJ6SfYPXUxHC01PMi9MrN2yl
         ZKv87VWW0B9dwfQv8kbyC+dNKJkfxQiqunxrTNXv4cq2eyEhfILN9KKETKWM7RCwaRIo
         5a+T/uQLicDG294PKXoNdNsAMbsk6yTEXnGFkuIxvc9ZgVszDbcn8jGehbFwqHWExWEH
         2Jdg==
X-Gm-Message-State: AOAM530r9hFsFXBISCl2mf3w1VElybOgNbvNk08i6fFfeXABbpURvIgT
        /1WnCc/qRvpjCiPNY9gwf/KaeVNcIhZUm///Yo++N87wMcrrDoo1I9FA0OXhdraLe//Jjj0rlei
        uTMUYL6riXhg7
X-Received: by 2002:a5d:4104:: with SMTP id l4mr20345985wrp.340.1608575418047;
        Mon, 21 Dec 2020 10:30:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzCEd9kYKJPXNWhVhnLlV93CI/86Bi8rzt4GxbksXttZMh/5joKt8CRJqIoOhP3/o0kuq4osg==
X-Received: by 2002:a5d:4104:: with SMTP id l4mr20345975wrp.340.1608575417884;
        Mon, 21 Dec 2020 10:30:17 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n11sm9439715wra.9.2020.12.21.10.30.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 10:30:17 -0800 (PST)
Subject: Re: [PATCH v4 0/3] KVM: selftests: Cleanups, take 2
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, bgardon@google.com,
        peterx@redhat.com
References: <20201218141734.54359-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bfcc184d-84f5-7760-df58-d22106935e76@redhat.com>
Date:   Mon, 21 Dec 2020 19:30:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201218141734.54359-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/12/20 15:17, Andrew Jones wrote:
> This series attempts to clean up demand_paging_test, dirty_log_perf_test,
> and dirty_log_test by factoring out common code, creating some new API
> along the way. It also splits include/perf_test_util.h into a more
> conventional header and source pair.
> 
> I've tested on x86 and AArch64 (one config each), but not s390x.
> 
> v4:
>   - dropped "KVM: selftests: dirty_log_test: Remove create_vm" patch
>   - Rebased on latest kvm/queue (patches applied cleanly)
>   - Ensured dirty-ring was enabled on x86 when testing
> 
> v3:
>   - Rebased remaining four patches from v2 onto kvm/queue
>   - Picked up r-b's from Peter and Ben
> 
> v2: https://www.spinics.net/lists/kvm/msg228711.html
> 
> Thanks,
> drew
> 
> 
> Andrew Jones (3):
>    KVM: selftests: Factor out guest mode code
>    KVM: selftests: Use vm_create_with_vcpus in create_vm
>    KVM: selftests: Implement perf_test_util more conventionally
> 
>   tools/testing/selftests/kvm/Makefile          |   2 +-
>   .../selftests/kvm/demand_paging_test.c        | 118 ++++---------
>   .../selftests/kvm/dirty_log_perf_test.c       | 145 +++++----------
>   tools/testing/selftests/kvm/dirty_log_test.c  | 125 ++++---------
>   .../selftests/kvm/include/guest_modes.h       |  21 +++
>   .../testing/selftests/kvm/include/kvm_util.h  |   9 +
>   .../selftests/kvm/include/perf_test_util.h    | 167 ++----------------
>   tools/testing/selftests/kvm/lib/guest_modes.c |  70 ++++++++
>   tools/testing/selftests/kvm/lib/kvm_util.c    |   9 +-
>   .../selftests/kvm/lib/perf_test_util.c        | 134 ++++++++++++++
>   10 files changed, 363 insertions(+), 437 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/include/guest_modes.h
>   create mode 100644 tools/testing/selftests/kvm/lib/guest_modes.c
>   create mode 100644 tools/testing/selftests/kvm/lib/perf_test_util.c
> 

Queued, thanks.

Paolo

