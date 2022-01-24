Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F734981DC
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 15:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbiAXORM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 09:17:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23322 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232833AbiAXORM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 09:17:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643033831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PgPesFIPZpVbm1r4iT3GHNIvFrM5MEduIacD8xbf/zk=;
        b=U5A9rqo5FGiBn5Z3bosxzQOyPFq8SsgwgXiJ0vVB6KZ0GzKNpxHCqJ94D32N2q4gg6EKi3
        dwMyI5TavT6uzQmb10EV5YDODTB/uoj5TAm1dU4sl/a/dqgEA708axG+pJpPBo/o+w4WrT
        JD2sprRS80O9k4mhdKob3kPguMKaNFw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-p3hCanbKOpyL1t3ZOUHthA-1; Mon, 24 Jan 2022 09:17:10 -0500
X-MC-Unique: p3hCanbKOpyL1t3ZOUHthA-1
Received: by mail-ed1-f72.google.com with SMTP id p17-20020aa7c891000000b004052d1936a5so8840230eds.7
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 06:17:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PgPesFIPZpVbm1r4iT3GHNIvFrM5MEduIacD8xbf/zk=;
        b=BmfAZ9q8P/KuErdH08ScdrfCJB+B94dfDAFCv5NE6RlSJIZPH66WlzNUbkU9bpklzR
         DpcFXn6AdKsd2COVvshwb8czuQVU1A1CVB81IBMgeVfFRa6qEj4uyrUgEE3lz/Nk4X+i
         4ZI3YWfUn8qEMc1LlmfwjVqBFpE9q9Jl9fYk/wp5BxGEyBL7wMOKtesu7XupaAeaCNwt
         0MidgVoaBOG6Gobm4H9+99UTo61gF7/ZCaOpd9Wz5MhTM4AGHZsNWHk4Ka6BOxjlnI9s
         +FXe0SfuuXSCBpv4TQd/LjfVveO5BHvYJ89Yms0B5PDj7zZV/9DaKyF1hfcHLm4BGl7j
         /q5A==
X-Gm-Message-State: AOAM53359GyAN4cJRA/RSq68+YlmSdl8AwLsFyVqEfR3lM6PScjza7wj
        Ta9OjSZn7zOCiMXDHwTL8iZ61JZY0Cg/Dg9biSP7hGc+LuLquODNiZkSf2mPtI3DGNyhltweyyB
        jtl/ObV4xzdlo
X-Received: by 2002:a17:906:4998:: with SMTP id p24mr12152729eju.131.1643033828918;
        Mon, 24 Jan 2022 06:17:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyhwNsgTZ2USW1iX8bosnoQZ3/4u8pFJIeddiWUSEwRxrecP8U6w/BQVK9hNyCQEwxZmawn5Q==
X-Received: by 2002:a17:906:4998:: with SMTP id p24mr12152713eju.131.1643033828716;
        Mon, 24 Jan 2022 06:17:08 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id c1sm4939088ejs.29.2022.01.24.06.17.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 06:17:08 -0800 (PST)
Message-ID: <30f5cd5b-65c8-1882-7fa7-6553e1bc292e@redhat.com>
Date:   Mon, 24 Jan 2022 15:17:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: selftests: Re-enable access_tracking_perf_test
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
References: <20220120003826.2805036-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220120003826.2805036-1-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/22 01:38, David Matlack wrote:
> This selftest was accidentally removed by commit 6a58150859fd
> ("selftest: KVM: Add intra host migration tests"). Add it back.
> 
> Fixes: 6a58150859fd ("selftest: KVM: Add intra host migration tests")
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   tools/testing/selftests/kvm/Makefile | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 81ebf99d6ff0..0e4926bc9a58 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -85,6 +85,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_pi_mmio_test
>   TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
>   TEST_GEN_PROGS_x86_64 += x86_64/amx_test
> +TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
>   TEST_GEN_PROGS_x86_64 += demand_paging_test
>   TEST_GEN_PROGS_x86_64 += dirty_log_test
>   TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
> 
> base-commit: edb9e50dbe18394d0fc9d0494f5b6046fc912d33

Queued, thanks.

Paolo

