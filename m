Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4271631C711
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 08:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhBPH6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 02:58:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50786 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229870AbhBPH6Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Feb 2021 02:58:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613462209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B6Lo5KZQJKmv7PdK2hrwhgZcqSAWi+dqk46gP3yNxBY=;
        b=KRA1fretenAv94dnaIKNUUsEJQoaJEKvTeBTkEmnthJoSxPhTexgx496ki7BjqM+u2jrLD
        EGA87bb6/7ng0lDQ4JBsfxd0qJz3rNMzo/uA3rIbinaS0fdSrh/wsucdRUByq9VzRFC+82
        dYH86ZGvSdGWWxhewZMWlH5+C1BPozg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-ZnYdmCZGNvedT1hVvyHa2Q-1; Tue, 16 Feb 2021 02:56:48 -0500
X-MC-Unique: ZnYdmCZGNvedT1hVvyHa2Q-1
Received: by mail-wr1-f69.google.com with SMTP id s18so12512633wrf.0
        for <kvm@vger.kernel.org>; Mon, 15 Feb 2021 23:56:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B6Lo5KZQJKmv7PdK2hrwhgZcqSAWi+dqk46gP3yNxBY=;
        b=HB3KezDR/a2EY4e+SKmZ3bI7qaHMDExrjX+loRwqNNVHNEjCn2N4AVEEIuIU06W1N5
         IC8FkdZmE/aKqI2FUwEWG7Ypm1BDvOPPmadaMx+nVuFr2PUpnCYVxg+/12Otl5zx2mSk
         2vPyZ+7UZ24p9nS/sKqrDZXKr2UNvAewPWi/kUN3COhN/hHN9ahaF96JBoF/JO2qpIB1
         H/82Cu1QEQJkzmZTJtB9vIRDFi+O7uYc+5MHytRT3Qbk5/NyQVN5peI/RypBEbxt7Wqg
         Tux+7j3W4o0QDv+QTDyrjGntfEh9bzMkfp1ErCi2ukv/eAejlwSpaOJt0QrNmX+CAzX9
         +D0Q==
X-Gm-Message-State: AOAM531Og7k6vDx/Ye4yjiaumja8ywGglW9cSvMSzG44BLHWmrYY5R4+
        d8P9i3F6AAHiomtTFUzDV/fNqc3jd5tQEUdHqAgVrKVMm+FFAlUFvji2cekAxB25bRtZw6hx8O5
        Zxv5lvZKp55cphg5ybdZiGRLgWowSKUlrNPc5JNa7slm0Dw1mtG9tQAiIBH/kaA==
X-Received: by 2002:adf:fdd0:: with SMTP id i16mr22546969wrs.215.1613462206787;
        Mon, 15 Feb 2021 23:56:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxJslf92Ds8rd9y8Jw2UvUX60j9VUrS+++rQDjqpnGFA418Hdp2+7AELqv7PVDOzwt3umSs0w==
X-Received: by 2002:adf:fdd0:: with SMTP id i16mr22546942wrs.215.1613462206651;
        Mon, 15 Feb 2021 23:56:46 -0800 (PST)
Received: from [192.168.1.36] (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id o124sm2475247wmo.41.2021.02.15.23.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Feb 2021 23:56:46 -0800 (PST)
Subject: Re: [RFC PATCH 02/23] kvm: Switch KVM_CAP_READONLY_MEM to a per-VM
 ioctl()
To:     Isaku Yamahata <isaku.yamahata@intel.com>, qemu-devel@nongnu.org,
        pbonzini@redhat.com, alistair@alistair23.me, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, mst@redhat.com, cohuck@redhat.com,
        mtosatti@redhat.com, xiaoyao.li@intel.com, seanjc@google.com
Cc:     isaku.yamahata@gmail.com, kvm@vger.kernel.org
References: <cover.1613188118.git.isaku.yamahata@intel.com>
 <1c93f5dabe2ef573302ff362c0c6c525bbe8af43.1613188118.git.isaku.yamahata@intel.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <0f29a789-9822-3dd8-b827-e5b86b933059@redhat.com>
Date:   Tue, 16 Feb 2021 08:56:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1c93f5dabe2ef573302ff362c0c6c525bbe8af43.1613188118.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Isaku,

On 2/16/21 3:12 AM, Isaku Yamahata wrote:
> Switch to making a VM ioctl() call for KVM_CAP_READONLY_MEM, which may
> be conditional on VM type in recent versions of KVM, e.g. when TDX is
> supported.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  accel/kvm/kvm-all.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 47516913b7..351c25a5cb 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2164,7 +2164,7 @@ static int kvm_init(MachineState *ms)
>      }
>  
>      kvm_readonly_mem_allowed =
> -        (kvm_check_extension(s, KVM_CAP_READONLY_MEM) > 0);
> +        (kvm_vm_check_extension(s, KVM_CAP_READONLY_MEM) > 0);

Can this check with "recent KVM" be a problem with older ones?

Maybe for backward compatibility we need:

          = (kvm_vm_check_extension(s, KVM_CAP_READONLY_MEM) > 0) ||
            (kvm_check_extension(s, KVM_CAP_READONLY_MEM) > 0);

>      kvm_eventfds_allowed =
>          (kvm_check_extension(s, KVM_CAP_IOEVENTFD) > 0);
> 

