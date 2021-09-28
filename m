Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C7641B2FB
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 17:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241646AbhI1PdY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 11:33:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44777 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241586AbhI1PdX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 11:33:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632843103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v6GpwnFNLFoD/5DAOAzBRJuz7HI+snzdDzW1fJFOZpA=;
        b=FRgwHT+cpUSlJizIHJ3ovkdnYeKb8Rk2rVA7uuAKKkxn4mRb0U9XLU0DuLFqisoTeRQBK8
        tbyDR0iU+gX0N2dTbH0Z4unnlJvi+QjxPT3xXqc9peYidZ+CXaW3k3ZF0HvPRC7kewjKdN
        vZrObspzmg7lbW3KH7vu56UgU5MGrAA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-QECT4Y0VPeyq5K_MAgkO8w-1; Tue, 28 Sep 2021 11:31:42 -0400
X-MC-Unique: QECT4Y0VPeyq5K_MAgkO8w-1
Received: by mail-ed1-f69.google.com with SMTP id c7-20020a05640227c700b003d27f41f1d4so22194316ede.16
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 08:31:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v6GpwnFNLFoD/5DAOAzBRJuz7HI+snzdDzW1fJFOZpA=;
        b=mwXQoaiCYDz8YFLhxEoUhUw6K+Aiu7N0+oKwqruRMk8w8oiKTlBeo5/lie/cclePd+
         7p8dzYd7wVe4L77ZyW51UkeQQEW0cd48TQ3Y0y5u545WZHjfOr+sSKO+OFwZ/oMOib+P
         DDvNouDOhf672P5om7nWxDlbnbyN52Q2Z6GIawWFRLTlbyYvJlILcJ6X6bnK2XVrgsw5
         aQWnaW9BKwlv3R+VayjC2R97pKEqKinqoYU/QZPJlU26/DpjFdP9REVGfds8L/gy2X9g
         y/XfY+Gpv86baYtRDjoluQZebdTSAn6lKeLarJBp6K36cXyU4B7+Bu1oLvYPUqpJHin5
         LtIw==
X-Gm-Message-State: AOAM532g/8gPbQa2G4TJUthPxMP3l3VIdpBsUX1ZIlYxywoeI3bmkh/S
        +gD7GQqJAsVPyVhsF0xqQljijzu9C1//M+x4UVWh7YQbGvM+a+/pS/LOlgyuZAXscvBQ8jj7+dA
        JUWQ4SAhEx5+x
X-Received: by 2002:a50:9d02:: with SMTP id v2mr8200897ede.105.1632843099897;
        Tue, 28 Sep 2021 08:31:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9KEORJgv+1NyVVMLSqvL2/ehNZdI6YThiqtoox6E3tp0WoD24Otglwc/6aXjwnUOmCuRNEA==
X-Received: by 2002:a50:9d02:: with SMTP id v2mr8200876ede.105.1632843099667;
        Tue, 28 Sep 2021 08:31:39 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ca4sm10664105ejb.1.2021.09.28.08.31.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 08:31:38 -0700 (PDT)
Message-ID: <c67b60f1-f96c-2d78-295f-6f1e17e5b152@redhat.com>
Date:   Tue, 28 Sep 2021 17:31:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] selftests: KVM: Don't clobber XMM register when read
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210927223621.50178-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210927223621.50178-1-oupton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/09/21 00:36, Oliver Upton wrote:
> There is no need to clobber a register that is only being read from.
> Oops. Drop the XMM register from the clobbers list.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>   tools/testing/selftests/kvm/include/x86_64/processor.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index eba8bd08293e..05e65ca1c30c 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -315,7 +315,7 @@ static inline void set_xmm(int n, unsigned long val)
>   #define GET_XMM(__xmm)							\
>   ({									\
>   	unsigned long __val;						\
> -	asm volatile("movq %%"#__xmm", %0" : "=r"(__val) : : #__xmm);	\
> +	asm volatile("movq %%"#__xmm", %0" : "=r"(__val));		\
>   	__val;								\
>   })
>   
> 

Queued, thnaks.

Paolo

