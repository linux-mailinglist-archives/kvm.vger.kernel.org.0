Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3B81A093C
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 10:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgDGIVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 04:21:41 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33589 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725883AbgDGIVl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 04:21:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586247698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KGjexata8cgoUC9UiyFJjrVjQvLuNHhkxnZiiQMvC7E=;
        b=Im5yTjy/MEABPhHS1qLRjdNU/8dWk7Iut3cT3Ft6lZneNDwQX0/UA0UZNoU1TyzeeI2sFa
        3Ug6FuR9DrnHXsOJbkiSYv9hGMHp/BTXdXPRnJTaWmO+hpIQYahUpaU6a+npR/eYzoQHIZ
        cWWPftvP99XPEf3ZgKxrp2IBPQ9oj8M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-C-lcOv-PPaKx-AxVcHAUFg-1; Tue, 07 Apr 2020 04:21:36 -0400
X-MC-Unique: C-lcOv-PPaKx-AxVcHAUFg-1
Received: by mail-wm1-f70.google.com with SMTP id i15so2002wmb.1
        for <kvm@vger.kernel.org>; Tue, 07 Apr 2020 01:21:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KGjexata8cgoUC9UiyFJjrVjQvLuNHhkxnZiiQMvC7E=;
        b=YpUkWlvePqi4acJJmmihcc4saj6KMhU1oBjlWYTLjzYFH/2ebiVbMJZHpw+AdWYJzs
         sMMjFSyGwWtReCfxiPd1pMLuKCKgVCxgmMRjK51DpA5zQxxtgkAV5JpbJbsH2acH30YZ
         pk4oZu58Y3yYuEL6h12xE81xvxrdCJ7EW9MzCvIaLkD8lXvs+oR4u/0FKjqgg+vEjVqw
         wqjRH1OqmjUbaKbbupFKP7FT49DwBItxrI9YcfljZGx8acXFxXI0XyI41vU61P+6oq49
         9NRMszkxu5d8KOtU1HjEOrXJHcgFgzyqlfht732idVY9MNc+oriuxkA9O/xDTlxlC/P3
         C7RA==
X-Gm-Message-State: AGi0PuZ20YDnmW+VDS0S7dperBNPsl9bJ7kv5mgvWoWx0q3M2tRgwPg9
        XjHmuKj2j+uSFk04wxA5ny3MirA6rvnFgl09COQryVSgyYZOD/vH53NtPj8K0gmwPa0tDOl9/1E
        xw0KCf0LN8Mnh
X-Received: by 2002:a1c:2cc6:: with SMTP id s189mr1203981wms.137.1586247695593;
        Tue, 07 Apr 2020 01:21:35 -0700 (PDT)
X-Google-Smtp-Source: APiQypIA9Q+eC0RiW5iVlbpMeMyuZpUveBHNLb62+NerZ2oMFQU0aIPg1yHbLtf4Lfj7TZlv8rslhA==
X-Received: by 2002:a1c:2cc6:: with SMTP id s189mr1203962wms.137.1586247695328;
        Tue, 07 Apr 2020 01:21:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:98c9:e86f:5fe7:54a5? ([2001:b07:6468:f312:98c9:e86f:5fe7:54a5])
        by smtp.gmail.com with ESMTPSA id f62sm1295295wmf.44.2020.04.07.01.21.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 01:21:34 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: VMX: Remove unnecessary exception trampoline in
 vmx_vmenter
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200406202108.74300-1-ubizjak@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ae555942-b2a1-be6c-e695-5c02bff554bd@redhat.com>
Date:   Tue, 7 Apr 2020 10:21:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200406202108.74300-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/04/20 22:21, Uros Bizjak wrote:
> The exception trampoline in .fixup section is not needed, the exception
> handling code can jump directly to the label in the .text section.
> 
> Changes since v1:
> - Fix commit message.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/vmx/vmenter.S | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 81ada2ce99e7..56d701db8734 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -58,12 +58,8 @@ SYM_FUNC_START(vmx_vmenter)
>  	ret
>  4:	ud2
>  
> -	.pushsection .fixup, "ax"
> -5:	jmp 3b
> -	.popsection
> -
> -	_ASM_EXTABLE(1b, 5b)
> -	_ASM_EXTABLE(2b, 5b)
> +	_ASM_EXTABLE(1b, 3b)
> +	_ASM_EXTABLE(2b, 3b)
>  
>  SYM_FUNC_END(vmx_vmenter)
>  
> 

Queued, thanks.

Paolo

