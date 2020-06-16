Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FA81FB34D
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 16:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729239AbgFPOCb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 10:02:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39379 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728763AbgFPOC3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 10:02:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592316148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SYTcvkoSR+GgCeHrjkkUyuowgDhZZpEASxlgk7YKRKU=;
        b=L2eFn/itFa/ybU0dnHGS5hRZR36tgeD6T73J/TLR+bevktzYq0+YH2oxxzWnOmgYkUa+u+
        LSokipAn/EiDn1T8OvNQi1LNyIgIgRyqmik6+W9zBZSFkAMPwwxr+zTA/uznBYtSQuYK3A
        vo9K7QV5hNbnR5Ft95KNAYBCyLBtO2o=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-G5gibuxSM8G-cdxeqOBmjA-1; Tue, 16 Jun 2020 10:02:26 -0400
X-MC-Unique: G5gibuxSM8G-cdxeqOBmjA-1
Received: by mail-wr1-f72.google.com with SMTP id f5so242615wrv.22
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 07:02:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SYTcvkoSR+GgCeHrjkkUyuowgDhZZpEASxlgk7YKRKU=;
        b=QYKrKcGY2CfiKJHaLqa7kLwJyIrDktzIqRa+PxjkcMPbfbVyKo9zbfc/vJKesA7WDq
         EJtFZQ306BW5k/03gB+Vx72RxEUYTrovG3ZWnB4XqB5PGS6Uw1KJO2DAzTZSWJdeI8GI
         iJCPcj3+wM1GfCyu0S6eioBZwJvXdOge5uq/oe+GBOZlLn2/Malx4xaLTIthm6lellHi
         uzmDMbdtXzJAAXRqDwriY5F1INGZjqPeaA/12M7jlBsvC1HCsg7qM/dq1sgIJSubAw6e
         7FIDjbtlOE9rKOWzSbEkReGkLVQOJzSHu4PxptNihofNegCdHPu4geRGit92AmJYk8Gk
         vDFw==
X-Gm-Message-State: AOAM531FepLpeJTc1z8lzuZP0BOSafwBN5tmpmPPcxEKtU75aozKDM9o
        vwWZG4rUCaL97OaX5cP2XhyU/eXvOVG/z1p3tS13tmDgJUHjYp2kxPqZu9ceqXxRhClTSvE1hjn
        6qE8NzuU7HcNv
X-Received: by 2002:adf:ce8d:: with SMTP id r13mr3451004wrn.178.1592316143774;
        Tue, 16 Jun 2020 07:02:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxA6CCgovsdvnFswRP3123xIZpFwVEs8d4czktNzB95vI77kF+8KqL52e29XiKDXB1/Xt0kDg==
X-Received: by 2002:adf:ce8d:: with SMTP id r13mr3450973wrn.178.1592316143562;
        Tue, 16 Jun 2020 07:02:23 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.88.161])
        by smtp.gmail.com with ESMTPSA id n19sm4040533wmi.33.2020.06.16.07.02.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2020 07:02:23 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] x86: always set up SMP
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     cavery@redhat.com
References: <20200608160033.392059-1-pbonzini@redhat.com>
 <630b9d53-bac2-378f-aa0a-99f45a0e80d5@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <af2c5e61-3448-0869-22a2-7be5f11e72eb@redhat.com>
Date:   Tue, 16 Jun 2020 16:02:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <630b9d53-bac2-378f-aa0a-99f45a0e80d5@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/06/20 15:02, Thomas Huth wrote:
> On 08/06/2020 18.00, Paolo Bonzini wrote:
>> Currently setup_vm cannot assume that it can invoke IPIs, and therefore
>> only initializes CR0/CR3/CR4 on the CPU it runs on.  In order to keep the
>> initialization code clean, let's just call smp_init (and therefore
>> setup_idt) unconditionally.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  x86/access.c              | 2 --
>>  x86/apic.c                | 1 -
>>  x86/asyncpf.c             | 1 -
>>  x86/cmpxchg8b.c           | 1 -
>>  x86/cstart.S              | 6 +++---
>>  x86/cstart64.S            | 6 +++---
>>  x86/debug.c               | 1 -
>>  x86/emulator.c            | 1 -
>>  x86/eventinj.c            | 1 -
> 
>  Hi Paolo,
> 
> this patch broke the eventinj test on i386 on gitlab:
> 
>  https://gitlab.com/huth/kvm-unit-tests/-/jobs/597447047#L1933
> 
> if I revert the patch, the test works again:
> 
>  https://gitlab.com/huth/kvm-unit-tests/-/jobs/597455720#L1934
> 
> Any ideas how to fix that?

I'm not sure why it starts failing now, the bug is unrelated and I see
the same compiler output even before.

Paolo

