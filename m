Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8C13ABA44
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 19:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbhFQRJZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 13:09:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21799 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231840AbhFQRJQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Jun 2021 13:09:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623949628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P+a31S7my7GZ/Y4MvDMd+Xgr66kYGwopRSGlVKuP0z8=;
        b=jLgWeGWJwOAyozNUDuUNzJKWOKPedAspOITB9A9gCSw/OiP5iNgd1qsbhw1MtNEwI1epUk
        RLCqWXLgBn/si/Og60IHRC/nAimmXHOZtsTRgZ/rPl0HF5gAO2Pd1M41ESfOo46GsgbgdI
        ZoZwRrl1+tKjDlIpZiEvO/srFe+4pbM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-ADdwNc1GOh-62SIe3-LO-A-1; Thu, 17 Jun 2021 13:07:06 -0400
X-MC-Unique: ADdwNc1GOh-62SIe3-LO-A-1
Received: by mail-ed1-f71.google.com with SMTP id z5-20020a05640235c5b0290393974bcf7eso2044480edc.2
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 10:07:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P+a31S7my7GZ/Y4MvDMd+Xgr66kYGwopRSGlVKuP0z8=;
        b=Cs5XIMQPFKJEP3ZLLfhvDVhXIlbe7jIJSZ5ZYQZmjbQsMtmj8KUTHIJdT/K9G066GN
         u8fdBUETZh+pP/ne0f8Ly1gzWnxNuGQ7ijWQKNYFWZNoUcNHlnWMYrXMAopj5j3wGTmw
         6/zxJE3Tw2wSxaIdei+N0Rafux/0r45OsBaT93sQB4yPoLA0iAvNdl+n+VfN4Os6vb+m
         qPqcSo5OTn10fIFM9HQ4wb75NnQCUZ4ToX2FFhBHTaCrCC4+CNkO1coKw9yjmmQw6sBu
         izmvnuRYHOClweGBsFlw3xj2ctAHoTZGaeCy+eBVsPFt211iUjxl9Ao89hz0GKg2uOhx
         Nsiw==
X-Gm-Message-State: AOAM531njB62Zu5OQWvrNa1/2PGTQi7NgeCgYtH3gS8zR0VXynVt6mYH
        5wU9ZpuVzinNHl/fpJeRfApi7rlofqDR3LFyS+0bsPr9A+/vraAAAbWH2g7DUgLW6Sv5sZB9N14
        1Hl+ZypqplLJl
X-Received: by 2002:a17:906:6b8a:: with SMTP id l10mr6272319ejr.125.1623949625731;
        Thu, 17 Jun 2021 10:07:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBQ1+tAZt7E3DGh3fI4tCCNq459QgOUf9lYOQCSk9FJgn1gHp6lSQqv0kJCv0hc/2D7vtieQ==
X-Received: by 2002:a17:906:6b8a:: with SMTP id l10mr6272298ejr.125.1623949625560;
        Thu, 17 Jun 2021 10:07:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id de24sm4121343ejc.78.2021.06.17.10.07.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 10:07:04 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: Fix kvm_check_cap() assertion
To:     Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org
Cc:     linux-kselftest@vger.kernel.org, shuah@kernel.org
References: <20210615150443.1183365-1-tabba@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ea3ed990-5af2-6f1b-1e6f-eb45824b342b@redhat.com>
Date:   Thu, 17 Jun 2021 19:07:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210615150443.1183365-1-tabba@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/06/21 17:04, Fuad Tabba wrote:
> KVM_CHECK_EXTENSION ioctl can return any negative value on error,
> and not necessarily -1. Change the assertion to reflect that.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   tools/testing/selftests/kvm/lib/kvm_util.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 5c70596dd1b9..a2b732cf96ea 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -82,7 +82,7 @@ int kvm_check_cap(long cap)
>   
>   	kvm_fd = open_kvm_dev_path_or_exit();
>   	ret = ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
> -	TEST_ASSERT(ret != -1, "KVM_CHECK_EXTENSION IOCTL failed,\n"
> +	TEST_ASSERT(ret >= 0, "KVM_CHECK_EXTENSION IOCTL failed,\n"
>   		"  rc: %i errno: %i", ret, errno);
>   
>   	close(kvm_fd);
> 

Queued, thanks.

Paolo

