Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0164D38E693
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 14:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbhEXMaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 08:30:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54843 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232476AbhEXMaX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 08:30:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621859335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P4X7Q6cOoCe0hTVDV5ljv+76y3e0rtVo1k13v34nVV8=;
        b=CwKhxLXcawjifn4n8xpdgSNV9X7cvY+l/4sTEooDyzzv7Aupct/tZUbNp73cKRQmzTXGlT
        5sz0LMhSqlNuoUzRvZx5NfIBt0Ocm2KN72z6l1tee0TMARSeB/AuFiEru/teIhZpfFtDsy
        u427oJ+gIO/PHXW+HYajuItwLo2b2H8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-QTxMNqi7OqSqrFETDfNmGw-1; Mon, 24 May 2021 08:28:48 -0400
X-MC-Unique: QTxMNqi7OqSqrFETDfNmGw-1
Received: by mail-ej1-f72.google.com with SMTP id la2-20020a170906ad82b02903d4bcc8de3bso7493026ejb.4
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 05:28:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P4X7Q6cOoCe0hTVDV5ljv+76y3e0rtVo1k13v34nVV8=;
        b=JVgK0jJUvPHqWYGemOhkS8wHP/MPdGNzcN+AH1t9Oj8XKMtS0AHp1hMvWz+lfhBh7C
         5Vc9Uly86annlGYuQ6W0hJlATOTx4BWndbW81HIdT3iabkEMpDk1zvMtOBbn7vxvlyBB
         I7TkhLPKlpfjdBDJjPMkxkk0jQVkksTJrAFkmMMX478NDpm4tpL1B+mmjzUTOV4nkBlq
         9XK70hOv0h76ou/5T0mjGXVoiZklkrnQzg6mg3ZoR5ZCSeVgQz6EzeS0M7OZPapsIBWZ
         2a2hLsIfs6lzBKTe8xBROLwb1hyn9de3z0k6nM0tpovgojaxZSAdGL/Ce9Zp7m3+zUcR
         DFfQ==
X-Gm-Message-State: AOAM531LJ/7ziG+52tlDpiEcgjNPvoGoiDcDZMvNdmxMcL+mSaBXy1tE
        aOrQSyDmxjgDxxG2/mnwIUz2i66lYq7B+p9PYVJNf2Ir6vUmW/Fbo2hH1ESyZKSp2YIebVnHe5B
        Yslm6bpyuvOnk
X-Received: by 2002:a17:906:6b96:: with SMTP id l22mr22720227ejr.456.1621859327381;
        Mon, 24 May 2021 05:28:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6VGkaZuxjCsNKEVJMf+xCBpZGuX4FX7erKeA5K1DM9WApJulSm4iVn6lzGshwE6t7/hh/NQ==
X-Received: by 2002:a17:906:6b96:: with SMTP id l22mr22720186ejr.456.1621859327222;
        Mon, 24 May 2021 05:28:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k11sm7899534ejc.94.2021.05.24.05.28.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 05:28:46 -0700 (PDT)
Subject: Re: [PATCH v2 2/7] KVM: X86: Use _BITUL() macro in UAPI headers
To:     Joe Richey <joerichey94@gmail.com>, trivial@kernel.org
Cc:     Joe Richey <joerichey@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Sasha Levin <sashal@kernel.org>, Peter Xu <peterx@redhat.com>,
        Lei Cao <lei.cao@stratus.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
References: <20210520104343.317119-1-joerichey94@gmail.com>
 <20210521085849.37676-1-joerichey94@gmail.com>
 <20210521085849.37676-3-joerichey94@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <59754ef1-c49d-11a6-30ba-8b938a6bb45d@redhat.com>
Date:   Mon, 24 May 2021 14:28:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210521085849.37676-3-joerichey94@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/21 10:58, Joe Richey wrote:
> From: Joe Richey <joerichey@google.com>
> 
> Replace BIT() in KVM's UPAI header with _BITUL(). BIT() is not defined
> in the UAPI headers and its usage may cause userspace build errors.
> 
> Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
> Signed-off-by: Joe Richey <joerichey@google.com>
> ---
>   include/uapi/linux/kvm.h       | 5 +++--
>   tools/include/uapi/linux/kvm.h | 5 +++--
>   2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 3fd9a7e9d90c..79d9c44d1ad7 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -8,6 +8,7 @@
>    * Note: you must update KVM_API_VERSION if you change this interface.
>    */
>   
> +#include <linux/const.h>
>   #include <linux/types.h>
>   #include <linux/compiler.h>
>   #include <linux/ioctl.h>
> @@ -1879,8 +1880,8 @@ struct kvm_hyperv_eventfd {
>    * conversion after harvesting an entry.  Also, it must not skip any
>    * dirty bits, so that dirty bits are always harvested in sequence.
>    */
> -#define KVM_DIRTY_GFN_F_DIRTY           BIT(0)
> -#define KVM_DIRTY_GFN_F_RESET           BIT(1)
> +#define KVM_DIRTY_GFN_F_DIRTY           _BITUL(0)
> +#define KVM_DIRTY_GFN_F_RESET           _BITUL(1)
>   #define KVM_DIRTY_GFN_F_MASK            0x3
>   
>   /*
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index 3fd9a7e9d90c..79d9c44d1ad7 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -8,6 +8,7 @@
>    * Note: you must update KVM_API_VERSION if you change this interface.
>    */
>   
> +#include <linux/const.h>
>   #include <linux/types.h>
>   #include <linux/compiler.h>
>   #include <linux/ioctl.h>
> @@ -1879,8 +1880,8 @@ struct kvm_hyperv_eventfd {
>    * conversion after harvesting an entry.  Also, it must not skip any
>    * dirty bits, so that dirty bits are always harvested in sequence.
>    */
> -#define KVM_DIRTY_GFN_F_DIRTY           BIT(0)
> -#define KVM_DIRTY_GFN_F_RESET           BIT(1)
> +#define KVM_DIRTY_GFN_F_DIRTY           _BITUL(0)
> +#define KVM_DIRTY_GFN_F_RESET           _BITUL(1)
>   #define KVM_DIRTY_GFN_F_MASK            0x3
>   
>   /*
> 

Queued thi sone, thanks.

Paolo

