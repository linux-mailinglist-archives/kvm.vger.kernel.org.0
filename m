Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688AB3610AA
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 19:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhDORCh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 13:02:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31814 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232642AbhDORCg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Apr 2021 13:02:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618506133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AIlH6DRtZdL/gylZHFTBxupHs9tLwWR10HxDB9jv7qE=;
        b=UriBdJzoTfSUf15V2Mc+hTDfItVxWWm56r/CRd0hHxsAEJrpCRAgC0/CV5dr9cSXeAVnfh
        jqj7wxpO3oHcuZzrmU1jaCfG87dikJ6J7U38Y3gLSK+JC1zFlsMR+EkiMUfAyjrN71Fikz
        y9Irzb5Z5Jp5Gv2o53OP5KdOFBAUtzk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-6lyGUWldP7eYC3d3bYu6YQ-1; Thu, 15 Apr 2021 13:02:11 -0400
X-MC-Unique: 6lyGUWldP7eYC3d3bYu6YQ-1
Received: by mail-ej1-f70.google.com with SMTP id ho12-20020a1709070e8cb029037000abbb92so1174102ejc.2
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 10:02:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AIlH6DRtZdL/gylZHFTBxupHs9tLwWR10HxDB9jv7qE=;
        b=WF18PbdEeXgpZWizTI7/ShD9FhdmR4LnVzJeLS8s+HUHmq7cFB5FCqwNxuwqdCqtR8
         ZX3pvXtxYuwawC6AY+2tFKvmPBzD51EZwGLREeI0xWEgRsCvlakRAMZTrDGZ1rgYN2bX
         tBkiYzK8jqsizF+D2aRpkQhiXHi+BvVNrShcqds15YIJfYFs0/31SyaQmYkTq2uvJvc2
         D2+2qQgFQ4UdbIlL+9iL7ZYFTNWgNmlcq2IslMmeNJJyyekVzvsmDbdAAK168yQ+iso5
         vjRRP6CDWbHq5XOYYk+F/46fQHbb9ukFJBWIDhpst1QtHz441K5BzC2VsYwRjoO6ePZg
         tSYw==
X-Gm-Message-State: AOAM533AqPFMrCH7zrE/W3zF5fUCvHUaHvg9Ol7Lm3SBj2323o4kqT3X
        fWHUnlp+kWsSsGgd+Ab4KnWtjiprg4MqCv9+MBBF5Rvbs1tv0XWu5OKUCYCkwjhncJ/AhrSnR5+
        vYmHUVNjA/a3n
X-Received: by 2002:a17:907:1b19:: with SMTP id mp25mr4414614ejc.154.1618506129740;
        Thu, 15 Apr 2021 10:02:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzaLY+S5UfPKwgq5AlO7kOuZeMWTVzztYtvhjEBlh08rIyDB4KoToQjdGbkf5ur3ACfS3WLTw==
X-Received: by 2002:a17:907:1b19:: with SMTP id mp25mr4414587ejc.154.1618506129522;
        Thu, 15 Apr 2021 10:02:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id w1sm3023226edt.89.2021.04.15.10.02.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 10:02:08 -0700 (PDT)
Subject: Re: [GIT PULL 0/7] KVM: s390: Updates for 5.13
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <20210412160545.231194-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <76f5ce85-8e03-ac31-200b-d0bd92cdb9df@redhat.com>
Date:   Thu, 15 Apr 2021 19:02:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210412160545.231194-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/04/21 18:05, Christian Borntraeger wrote:
> Paolo,
> 
> only small things for 5.13, one is a fix (with cc stable) consisting of
> multiple patches. I had it running in next for a while since this is
> a pretty complicated area of the architecture but its now good to go.
> 
> The following changes since commit a38fd8748464831584a19438cbb3082b5a2dab15:
> 
>    Linux 5.12-rc2 (2021-03-05 17:33:41 -0800)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.13-1
> 
> for you to fetch changes up to c3171e94cc1cdcc3229565244112e869f052b8d9:
> 
>    KVM: s390: VSIE: fix MVPG handling for prefixing and MSO (2021-03-24 10:31:55 +0100)
> 
> ----------------------------------------------------------------
> KVM: s390: Updates for 5.13
> 
> - properly handle MVPG in nesting KVM (vsie)
> - allow to forward the yield_to hypercall (diagnose 9c)
> - fixes
> 
> ----------------------------------------------------------------
> Bhaskar Chowdhury (1):
>        KVM: s390: Fix comment spelling in kvm_s390_vcpu_start()
> 
> Claudio Imbrenda (5):
>        KVM: s390: split kvm_s390_logical_to_effective
>        KVM: s390: extend kvm_s390_shadow_fault to return entry pointer
>        KVM: s390: VSIE: correctly handle MVPG when in VSIE
>        KVM: s390: split kvm_s390_real_to_abs
>        KVM: s390: VSIE: fix MVPG handling for prefixing and MSO
> 
> Pierre Morel (1):
>        KVM: s390: diag9c (directed yield) forwarding
> 
>   Documentation/virt/kvm/s390-diag.rst |  33 +++++++++++
>   arch/s390/include/asm/kvm_host.h     |   1 +
>   arch/s390/include/asm/smp.h          |   1 +
>   arch/s390/kernel/smp.c               |   1 +
>   arch/s390/kvm/diag.c                 |  31 +++++++++-
>   arch/s390/kvm/gaccess.c              |  30 ++++++++--
>   arch/s390/kvm/gaccess.h              |  60 ++++++++++++++-----
>   arch/s390/kvm/kvm-s390.c             |   8 ++-
>   arch/s390/kvm/kvm-s390.h             |   8 +++
>   arch/s390/kvm/vsie.c                 | 109 ++++++++++++++++++++++++++++++++---
>   10 files changed, 250 insertions(+), 32 deletions(-)
> 

Pulled, thanks.

Paolo

