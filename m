Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0738747E23E
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 12:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347937AbhLWL01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 06:26:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55353 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347908AbhLWL00 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Dec 2021 06:26:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640258784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NlRowIfIguXC2TEqB2btKL98MArEdkul8GC5+01CSq4=;
        b=bkbDN14lDMdJXwmqP1HF3aXzWgRrA00UC3RK2CsW/PQtAwyLWbaZyusPuTvXe82i1pfW/b
        H7shhEoKinohB/fh94GkiHKnwfvarmVGzSf1sL+XZOivRJ/b2iApkeHpbu2grb5S0Vo/74
        iz15TqyaYf75J1p1NMU7XzPaK5i9WzY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-GRTt8lbfN8yJpMooJgiIbw-1; Thu, 23 Dec 2021 06:26:23 -0500
X-MC-Unique: GRTt8lbfN8yJpMooJgiIbw-1
Received: by mail-ed1-f71.google.com with SMTP id x19-20020a05640226d300b003f8b80f5729so3113991edd.13
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 03:26:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NlRowIfIguXC2TEqB2btKL98MArEdkul8GC5+01CSq4=;
        b=0rQsJnT3NLlqURrpzsd0n47/zXzf++7RzreaTehqOYNdNsya0BwwzLIh8t2Axwi0U7
         xVDiNUs3d7X57ALluQz4iQLWgiCp9RM/VO1xcywX2/LWUoJqr/ibgbVVtSFTonhhKsg/
         bYnz2bToD8f24ThM3J5Tw6ZZgJk1nE08qX+e7prBrqZb9dlJ42IC2b3tRNX+BtTogQ3v
         r8Hs3N3tsZiqOBlJr+INnNp/wTwDI5eGw/AfvVOh73Ug8Ow/cRiptqA5o5SozXTqA2sL
         CESGa3jY/fw4N5K7sG1nuJICze91Zz5vmXsmvnlRcNeElJYnXC8OON73vMso6KOe5rUr
         QQ7A==
X-Gm-Message-State: AOAM533oN0eNleNgsPreBy0gEOpzG/kd0JRcj9IZmOa8o40k3/qKLvV+
        2ymGJU9ocnF67RZM0/V9IsakDLN+7ihCw2SQpxrNaI8QvE36HJEhLtgQmRkwmsCTXoNgp+8+7rG
        yX7YxPWehHsc0
X-Received: by 2002:a17:906:f890:: with SMTP id lg16mr1627202ejb.757.1640258781742;
        Thu, 23 Dec 2021 03:26:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBCmOYBCwb87L0gyQ1FpwKTz0kvssdbBAoZx5YSpZKCls0DqqJYAxnk8UbeM3Tnox3j+iyrA==
X-Received: by 2002:a17:906:f890:: with SMTP id lg16mr1627188ejb.757.1640258781441;
        Thu, 23 Dec 2021 03:26:21 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id nc14sm1680858ejc.44.2021.12.23.03.26.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Dec 2021 03:26:20 -0800 (PST)
Message-ID: <12e337c9-7d5a-514d-c27d-c953e8317f0b@redhat.com>
Date:   Thu, 23 Dec 2021 12:26:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 0/3] AMX KVM selftest
Content-Language: en-US
To:     Yang Zhong <yang.zhong@intel.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com
References: <20211223145322.2914028-1-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211223145322.2914028-1-yang.zhong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/23/21 15:53, Yang Zhong wrote:
> Hi Paolo,
> 
> Please help review this patchset, which is rebased on Jing's AMX v3.
> https://lore.kernel.org/all/20211222124052.644626-1-jing2.liu@intel.com/
> 
> About this selftest requirement, please check below link:
> https://lore.kernel.org/all/85401305-2c71-e57f-a01e-4850060d300a@redhat.com/
> 
> By the way, this amx_test.c file referenced some Chang's older test code:
> https://lore.kernel.org/lkml/20210221185637.19281-21-chang.seok.bae@intel.com/

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> 
> Thanks!
> 
> Yang
> 
> 
> Change history
> ==============
> v2-->v3:
>     - Removed the skip "regs->rip += 3", enable amx in #NM handler(Paolo).
> 
> v1-->v2
>     - Added more GUEST_SYNC() from guest code(Paolo).
>     - Added back save/restore code after GUEST_SYNC()
>       handles in the main()(Paolo).
> 
> 
> Paolo Bonzini (1):
>    selftest: kvm: Reorder vcpu_load_state steps for AMX
> 
> Yang Zhong (2):
>    selftest: kvm: Move struct kvm_x86_state to header
>    selftest: kvm: Support amx selftest
> 
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../selftests/kvm/include/x86_64/processor.h  |  16 +-
>   .../selftests/kvm/lib/x86_64/processor.c      |  32 +-
>   tools/testing/selftests/kvm/x86_64/amx_test.c | 448 ++++++++++++++++++
>   4 files changed, 473 insertions(+), 24 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/amx_test.c
> 

