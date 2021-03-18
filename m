Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBB834090E
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 16:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbhCRPkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 11:40:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28589 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231273AbhCRPkA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 11:40:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616081999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z6n174q6cXzDs/Hg1NtNa/fztkMIalwwlrv76GiJi+4=;
        b=CP3ijalE+05ebYIWW2hoPyOgTIFB8NIW8INR/gujNvdshLjT4Zvs96/Er4r+cUKjj+azeW
        9bNftFl2+StP78q4mRbBiRYehFV5nuIeUovwSwnC5sjRLDXy7hU4UNP2agdeHekGYH5CAB
        6ew0m2N6U802HJgZDcTSTxV+bstd0z0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-86wAUf3oMB6QBm04BqtPKw-1; Thu, 18 Mar 2021 11:39:57 -0400
X-MC-Unique: 86wAUf3oMB6QBm04BqtPKw-1
Received: by mail-wm1-f70.google.com with SMTP id r18so11953309wmq.5
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 08:39:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z6n174q6cXzDs/Hg1NtNa/fztkMIalwwlrv76GiJi+4=;
        b=ZSAMy42t9w9xkXp1j11oEcIUvMDvSWG7EE4Dzf8Z/e0PcYMi3FF9haBAr3U9deJvPD
         4eENwPOyzhMlE79P/IhLRQFcjJ7sfKElFgd44dY7soIHvF3qpHrfeM/BoSBYz4fh8D2Q
         92Ah1q1QRYj3v9H9NEtfd7J3cF5NONq5/Ubbn0X77A4UXlcTdcxdqYFt3LZ3WqQ7dkBN
         0X9BBH+af0IaoJ4hUCWxYRYGD+CQkrfLY42mli0DaTOlKfZHSC4TjbGJDOcreOZeY+KY
         62dXa1ZkC7za5GYP/33FkuPtY5940NJN85ApfFhJdD3aly85nU3PiB99vqoeBwseB2U6
         6BYQ==
X-Gm-Message-State: AOAM533N6XexfJCW8rfD9Iy3CEw1BLqZSebxaBNQfBvqlE4wfgLWDbNy
        eQWAF36Ino/1eVYYNaERTTFcp5Qn0sLEbGnTc05MHIMHaljEJg2g0BELomze8r9Y/5bHN2FIIte
        q2dwFxrN6qQ6m//IWIcqwUGrw67nmFMg70Vd4weKsb4tJ0nn08PxpgOY5Goxn62uY
X-Received: by 2002:a1c:6a12:: with SMTP id f18mr4304179wmc.31.1616081996491;
        Thu, 18 Mar 2021 08:39:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybgfAQG1Vp7DCkIhgHZxt6yWB7EsvxvHpIYhYjGgsBWmptisVOOyAnOQMvkZlUmz+20fqWDg==
X-Received: by 2002:a1c:6a12:: with SMTP id f18mr4304157wmc.31.1616081996238;
        Thu, 18 Mar 2021 08:39:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w6sm3457685wrl.49.2021.03.18.08.39.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 08:39:55 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] kvm/kvm_util: add _vm_ioctl
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-kselftest@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210318151624.490861-1-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f240b088-9595-67d8-fd04-9c7ffa8805f4@redhat.com>
Date:   Thu, 18 Mar 2021 16:39:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210318151624.490861-1-eesposit@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/03/21 16:16, Emanuele Giuseppe Esposito wrote:
> As in kvm_ioctl and _kvm_ioctl, add
> the respective _vm_ioctl for vm_ioctl.
> 
> _vm_ioctl invokes an ioctl using the vm fd,
> leaving the caller to test the result.

Slightly better subject: "selftests/kvm: add _vm_ioctl".

Queued both, but next time please include a cover letter too.

Thanks!

Paolo

> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>   tools/testing/selftests/kvm/include/kvm_util.h | 1 +
>   tools/testing/selftests/kvm/lib/kvm_util.c     | 7 ++++++-
>   2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 2d7eb6989e83..d53a5f7cad61 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -133,6 +133,7 @@ void vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
>   int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
>   		void *arg);
>   void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
> +int _vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg);
>   void kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
>   int _kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
>   void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index e5fbf16f725b..b8849a1aca79 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1697,11 +1697,16 @@ void vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
>   {
>   	int ret;
>   
> -	ret = ioctl(vm->fd, cmd, arg);
> +	ret = _vm_ioctl(vm, cmd, arg);
>   	TEST_ASSERT(ret == 0, "vm ioctl %lu failed, rc: %i errno: %i (%s)",
>   		cmd, ret, errno, strerror(errno));
>   }
>   
> +int _vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
> +{
> +	return ioctl(vm->fd, cmd, arg);
> +}
> +
>   /*
>    * KVM system ioctl
>    *
> 

