Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E25A47D428
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 16:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237912AbhLVPPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 10:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234907AbhLVPPF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 10:15:05 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF394C061574
        for <kvm@vger.kernel.org>; Wed, 22 Dec 2021 07:15:04 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id o20so9868205eds.10
        for <kvm@vger.kernel.org>; Wed, 22 Dec 2021 07:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zOnNqVFI3N4/pDKT2dBhxDSwZ5Y2lJhjrQG4AKkipec=;
        b=eJtIVMWrufsDNF78c1unuZmp3VEMTjess8O5Gf/t0+dO0pVXvyu+xCuA6pnM2TUWD/
         RvgK1/6YXA5YK9Ig/ulCwCWzDs+ynHOQUquz7WbZI1/ey0VQiKtLZ4yvLA3P9x00Y2hq
         KeY1avZnJbe4YiwcCKytsCmgj5cbL7zC7WN3R11ZN09oDCmYujBSG1KRxIT7rFjqNZCD
         zn48IBirNFFDeZukuqQ/UyZVy4t4qMnIXZ+55Pyfu6mr+VNVtd4k+V8/0MPlXXNS5jch
         lmPqMd/i61J9vGmirQ/LXg5N14wkfp+NgPkUH6YEjYKqerNy1jGJCH+xVugm+nV9LPCh
         Zh2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zOnNqVFI3N4/pDKT2dBhxDSwZ5Y2lJhjrQG4AKkipec=;
        b=4CgZBv6rpB9X5xvwcYaP19x4ot/Hrk/YzDwd7z4nYlkyteFRu26F5fPwTfIxySHcm2
         OzQvXu0df+h/DuXOFzgRRfBStO/RrsIvLS4+InJTWUbNnp1v3H36anNzeaw9a9FYKPOW
         SnPMPo4KqL5eIe8gBoDa4SMJwW6ljANQPaFOP5APRpDo5EZml/iSDe604kAQhFwoNuMh
         x6iQIdoYHb5GUxvY8yEWmYvepw+SNEpzR1iGavgVdfhD9ksRyPtTByrlLcYCxGG672n9
         Kusa5vftfy59nNRycPAABWO//uqVC5EdIE1Bt1kIfccPwwkd/J3ykgN5ZP9kkFSz4bLS
         3b+g==
X-Gm-Message-State: AOAM5307GrDfhSXhFUhuqQcUZIGl3yobSCBcmbhQTN5F49StkVGb9Lw7
        DG99EDGxDGVdYx6PY6yi55/ItOexVWk=
X-Google-Smtp-Source: ABdhPJw/vY8h1OMN9Q0zWNCORZfYnOJipbJ1deux8a6Cf4EyeVf1o2HPwcMQ8K8cD5IS9OhoEBYqWQ==
X-Received: by 2002:a17:906:4796:: with SMTP id cw22mr2902863ejc.594.1640186103499;
        Wed, 22 Dec 2021 07:15:03 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312::4fa? ([2001:b07:6468:f312::4fa])
        by smtp.googlemail.com with ESMTPSA id 12sm866945ejh.173.2021.12.22.07.15.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Dec 2021 07:15:03 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <2348d4e6-fb14-9c5b-5a6a-829d4ecd1839@redhat.com>
Date:   Wed, 22 Dec 2021 16:15:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 3/3] selftest: kvm: Support amx selftest
Content-Language: en-US
To:     Yang Zhong <yang.zhong@intel.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com
References: <20211222214731.2912361-1-yang.zhong@intel.com>
 <20211222214731.2912361-4-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211222214731.2912361-4-yang.zhong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/22/21 22:47, Yang Zhong wrote:
> +	/* Trigger #NM exception */
> +	__tileloadd(tiledata);
> +	GUEST_SYNC(10);
> +
> +	GUEST_DONE();
> +}
> +
> +void guest_nm_handler(struct ex_regs *regs)
> +{
> +	/* Check if #NM is triggered by XFEATURE_MASK_XTILEDATA */
> +	GUEST_SYNC(7);
> +	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILEDATA);
> +	GUEST_SYNC(8);
> +	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILEDATA);
> +	/* Clear xfd_err */
> +	wrmsr(MSR_IA32_XFD_ERR, 0);
> +	regs->rip += 3;
> +	GUEST_SYNC(9);
> +}

I don't understand why "regs->rip += 3" is needed though.

My idea was that, after GUEST_SYNC(9) and IRET, the guest would execute 
__tileloadd again; this time without generating #NM, so that after 
GUEST_SYNC(10) the host sees the loaded data in TMM0.

Thanks,

Paolo
