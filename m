Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE5747044A
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 16:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243316AbhLJPrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 10:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243209AbhLJPrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 10:47:49 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AD8C0617A1;
        Fri, 10 Dec 2021 07:44:13 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id y12so30520089eda.12;
        Fri, 10 Dec 2021 07:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bK1VD0gen1dAiRNyR52OpmGL8xOMlgZr26qy9Imxjfs=;
        b=Cz+2BdcGcb6VF3pMoUXw1meC1Xn9ak2DWyd2qU6R7A90ZOaf/CqxXwToEOb7pS23Rr
         JUUaKObtVv8Y5ypMyt4yxGZzFusEJCXfbO4YxlmJ2nUAoNMxtbniOeSKgFzRq0S35kSk
         O87yA8vzRMhmsbbXbYwY+g8CsivFUpu8MVLOCjdJZp/vQJVFW8uLSwT3zpKUjP7DJDOo
         463OolYySGqiePLYhA0KgyJIXOEtgC5a2qlqFUxF6sxhzv2rTCMEw7PREzib4Nzq2tO6
         KAw3F6KfvCEnb5VvqpuoNgqR6y5AxJP0r/wO/L//y/5lde5eMuEqsbnNf7nmwXjEq+dK
         Rkmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bK1VD0gen1dAiRNyR52OpmGL8xOMlgZr26qy9Imxjfs=;
        b=nZl3KJo1M3IU7sMMi7IZHR/8avw2L4a/d9C6JbZFc9c/sTWzw0ihmGTfKGEoPSBrqK
         AXp9An5cT0EHkWb9SiON8rEiZrAwsfWG+hLtjMN8Bf6PHTJolgA1neN/n0C0t8ZgRhrW
         MfMub2SBSs37WAKeDNoFwJ4TxpA5urzKTN8/ntYQCnhz5UD4wwr2ZIM7p9Rx5Ldg/aJL
         DeEq4qWfhqZn7Owu/x7pJXDS8ySMBVx/RUlfGtv9inl8k8bUMW+hdqWgsXWIoG4j/cK6
         u+p2VvGRIUv2Rp9J9GPknj9M/kGEnhrzyN4LClfoQyfmIv5uKDLrGgcXsm8VdkyUTJwI
         n4ZQ==
X-Gm-Message-State: AOAM530VEj9ydS+qEA7mOXFUXrtlcwfbQpvh32+bjnPrpWGOMi/gvvoy
        g7KzdJpp+gJqXHCDdtK9zk4=
X-Google-Smtp-Source: ABdhPJyQNSDcWmsXwdbrTTQLu9YGNpmQuNAlLo9qcRrVmtW1Q+70q9fdp8LdzuU8x3vS9gfMAxzhKg==
X-Received: by 2002:a17:906:8a62:: with SMTP id hy2mr24247267ejc.347.1639151049794;
        Fri, 10 Dec 2021 07:44:09 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id d23sm1712750edq.51.2021.12.10.07.44.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 07:44:09 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <da30ea02-aec6-ae2c-24ad-9e20f741d0fe@redhat.com>
Date:   Fri, 10 Dec 2021 16:44:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 07/19] kvm: x86: Propagate fpstate reallocation error to
 userspace
Content-Language: en-US
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-8-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211208000359.2853257-8-yang.zhong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 01:03, Yang Zhong wrote:
>   out:
> -	kvm_put_guest_fpu(vcpu);
> +	ret = kvm_put_guest_fpu(vcpu);
> +	if ((r >= 0) && (ret < 0))
> +		r = ret;
> +

No extra parentheses.

Paolo
