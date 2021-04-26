Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D48136B08A
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 11:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhDZJ3W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 05:29:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20565 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232080AbhDZJ3R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 05:29:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619429315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OtWVNId0H4MlH7zGbJHW4vVmuaAH+xdS1wmcTWoY6w0=;
        b=PCHp0zeaHGtwJHoMpby4GBbSE/F82iu9OkpRePEF4S4vKJTUvWDxDDqOD0t3EYBKHfIIPG
        3aHo941jn3rBpP4b5GeCsef/XI8Q7POp8vVfk43ZldmOTkUI88tZjnzx1YclLAt5i4iVeX
        j6pM+Q4L5IAwIafsJ1KSQO2EBYmt3sI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-S_DT_NcuM2OzoTYIp54Iuw-1; Mon, 26 Apr 2021 05:28:33 -0400
X-MC-Unique: S_DT_NcuM2OzoTYIp54Iuw-1
Received: by mail-ed1-f69.google.com with SMTP id f1-20020a0564021941b02903850806bb32so16735899edz.9
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 02:28:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OtWVNId0H4MlH7zGbJHW4vVmuaAH+xdS1wmcTWoY6w0=;
        b=t57zsPmdZ85tfPNg9cyT83hZ6Y02ozNv0vlnYXZJNjhsvc03pD6Tno6lhVOBK+BJEo
         mBAORO/TXmW5b+a1oKJh0oZMRGFANhy8NMMyF0goV8iR+B/OqgGdn2rLO4Tvz3cGgEm6
         UKC7vfkcVJwFFZg9e3tdgZQZ1H5LmIWSXrnWA4lvevhRP0bcW61zD1nvAWLlWI4N5FUu
         gyR+ltm8PGm1zDEEVZlPhVWRVu+ZzsrbevTq8in/tZNA15Qw1709HzZeQmEU6wSIIJZ4
         2aQ+5FArYhxB1XVTQ/4l0YIZoYmnTwB9GPj9AkLrqLo7bS2T9qRRJsHFAGCS8GnB9l7H
         fNaA==
X-Gm-Message-State: AOAM533t9RVovBKawJsrh3qgMI1X3MGKAEC+Vo5FnvI18Xc49bzxX542
        gshapTjTmOXQ7aNpucKBxrkZ1Y/eWYfzZomEPCefIkynGmAE0/kuEFtaukz2qg+kylPOQDOcJcc
        iiHrsXVrXMj3e
X-Received: by 2002:aa7:c4c1:: with SMTP id p1mr19783009edr.133.1619429311948;
        Mon, 26 Apr 2021 02:28:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytAfyLKl2YKK7lKos9PhDPbKzINP26aWILO7ar4wTBgQ7gjsJ4KrtD/Mf8e0g7fXX2pHMNmA==
X-Received: by 2002:aa7:c4c1:: with SMTP id p1mr19783001edr.133.1619429311818;
        Mon, 26 Apr 2021 02:28:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id b8sm14195751edu.41.2021.04.26.02.28.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 02:28:31 -0700 (PDT)
Subject: Re: [PATCH] selftests: kvm: Fix the check of return value
To:     Zhenzhong Duan <zhenzhong.duan@intel.com>,
        linux-kernel@vger.kernel.org
Cc:     linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
        shuah@kernel.org
References: <20210426193138.118276-1-zhenzhong.duan@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0d23822d-1510-d615-c3bf-200b6636b766@redhat.com>
Date:   Mon, 26 Apr 2021 11:28:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210426193138.118276-1-zhenzhong.duan@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/04/21 21:31, Zhenzhong Duan wrote:
> In vm_vcpu_rm() and kvm_vm_release(), a stale return value is checked in
> TEST_ASSERT macro.
> 
> Fix it by assigning variable ret with correct return value.
> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> ---
>   tools/testing/selftests/kvm/lib/kvm_util.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index b8849a1aca79..53d3a7eb0d47 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -514,7 +514,7 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
>   	ret = munmap(vcpu->state, vcpu_mmap_sz());
>   	TEST_ASSERT(ret == 0, "munmap of VCPU fd failed, rc: %i "
>   		"errno: %i", ret, errno);
> -	close(vcpu->fd);
> +	ret = close(vcpu->fd);
>   	TEST_ASSERT(ret == 0, "Close of VCPU fd failed, rc: %i "
>   		"errno: %i", ret, errno);
>   
> @@ -534,7 +534,7 @@ void kvm_vm_release(struct kvm_vm *vmp)
>   	TEST_ASSERT(ret == 0, "Close of vm fd failed,\n"
>   		"  vmp->fd: %i rc: %i errno: %i", vmp->fd, ret, errno);
>   
> -	close(vmp->kvm_fd);
> +	ret = close(vmp->kvm_fd);
>   	TEST_ASSERT(ret == 0, "Close of /dev/kvm fd failed,\n"
>   		"  vmp->kvm_fd: %i rc: %i errno: %i", vmp->kvm_fd, ret, errno);
>   }
> 

Queued, thanks.

Paolo

