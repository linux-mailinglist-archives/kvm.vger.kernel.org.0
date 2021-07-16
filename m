Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03383CB508
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 11:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhGPJKI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 05:10:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33974 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229833AbhGPJKH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Jul 2021 05:10:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626426431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8efeVFyZdlNBLrGCgMRLF1YfAz+xaqWIbhcMsGEkt7E=;
        b=gsSp1Z083f6y4rL5Msmn9u9c1/ww+/Zzvc5QEleeAxA7Eg8ILgOdSb5eqKFy3QjTOrio1y
        ApTTmJoxBiWxmpUHouVpwVMkzxDhQYkZYQRjzejegjOv1E4g44cn+Kw7vK+r0pIP2smGJs
        ya+veDMmv5kumcnTCmwId0a2yjXk1q4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-sK5xDGkRNxy77g-Rwy9f3w-1; Fri, 16 Jul 2021 05:07:10 -0400
X-MC-Unique: sK5xDGkRNxy77g-Rwy9f3w-1
Received: by mail-ej1-f72.google.com with SMTP id sd15-20020a170906ce2fb0290512261c5475so3343178ejb.13
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 02:07:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=8efeVFyZdlNBLrGCgMRLF1YfAz+xaqWIbhcMsGEkt7E=;
        b=VA15DEN80qJOe/C8XGdu+/r+SfFezjmmoof3Qs+xBxqSrKt7Q2tvDS49ls4QtSIZoD
         +9al7qwiOjMws3PniKvYpMsYzaW64O/IK/zwJvJATQBo6+FBEYGPQCzjlgcaOXKQidF0
         bQir5FSD36rcwxjq52qI/MGTxa+KVG1yPiHmacmN4+mq6LWDBO/Pw8aYk2Wu6l7cTiLZ
         gcFIBK/zTuewblGMLqznEpZpfyNtzGDMMnByBGgSFzJpXE93nVTV0FRFJmov0qF5RGKK
         Kbgy/dId/Aq7FqLKtHLKHy9Zbea+rUnyvVZI9PkOAz0Xjvs+SuSX9yWW/lhgufkzMy9Z
         ie+g==
X-Gm-Message-State: AOAM532xGFLXmLUxCR5HaQuB70dmK/DrvtNg92d0Fm3qosSx9+leM2mv
        25paMP2DDiCNPcKhPCammdZHG3F1VAore4OV7jZzM9WYGWrt0RWOrsuEtnFpRAih5yG7q8+xMFd
        PuzS/3YH7pE78
X-Received: by 2002:a17:906:fc6:: with SMTP id c6mr10595297ejk.65.1626426428697;
        Fri, 16 Jul 2021 02:07:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGogOZixuFoShn9FSPdi0P8CvjTCPptdWEx0iq0Redq8XXB+R55o/2MXJV/XcG/kpOY93ArQ==
X-Received: by 2002:a17:906:fc6:: with SMTP id c6mr10595286ejk.65.1626426428536;
        Fri, 16 Jul 2021 02:07:08 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f15sm2662703ejc.61.2021.07.16.02.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 02:07:08 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PULL 04/11] i386: expand Hyper-V features during CPU feature
 expansion time
In-Reply-To: <CAFEAcA-nif_Z0guHx4q4NUg=FEyhUz8kkAvfZ58916yp6TXT7Q@mail.gmail.com>
References: <20210713160957.3269017-1-ehabkost@redhat.com>
 <20210713160957.3269017-5-ehabkost@redhat.com>
 <CAFEAcA-nif_Z0guHx4q4NUg=FEyhUz8kkAvfZ58916yp6TXT7Q@mail.gmail.com>
Date:   Fri, 16 Jul 2021 11:07:06 +0200
Message-ID: <878s261vb9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Maydell <peter.maydell@linaro.org> writes:

> On Tue, 13 Jul 2021 at 17:19, Eduardo Habkost <ehabkost@redhat.com> wrote:
>>
>> From: Vitaly Kuznetsov <vkuznets@redhat.com>
>>
>> To make Hyper-V features appear in e.g. QMP query-cpu-model-expansion we
>> need to expand and set the corresponding CPUID leaves early. Modify
>> x86_cpu_get_supported_feature_word() to call newly intoduced Hyper-V
>> specific kvm_hv_get_supported_cpuid() instead of
>> kvm_arch_get_supported_cpuid(). We can't use kvm_arch_get_supported_cpuid()
>> as Hyper-V specific CPUID leaves intersect with KVM's.
>>
>> Note, early expansion will only happen when KVM supports system wide
>> KVM_GET_SUPPORTED_HV_CPUID ioctl (KVM_CAP_SYS_HYPERV_CPUID).
>>
>> Reviewed-by: Eduardo Habkost <ehabkost@redhat.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Message-Id: <20210608120817.1325125-6-vkuznets@redhat.com>
>> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
>
> Hi; Coverity reports an issue in this code (CID 1458243):
>
>> -static bool hyperv_expand_features(CPUState *cs, Error **errp)
>> +bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp)
>>  {
>> -    X86CPU *cpu = X86_CPU(cs);
>> +    CPUState *cs = CPU(cpu);
>>
>>      if (!hyperv_enabled(cpu))
>>          return true;
>>
>> +    /*
>> +     * When kvm_hyperv_expand_features is called at CPU feature expansion
>> +     * time per-CPU kvm_state is not available yet so we can only proceed
>> +     * when KVM_CAP_SYS_HYPERV_CPUID is supported.
>> +     */
>> +    if (!cs->kvm_state &&
>> +        !kvm_check_extension(kvm_state, KVM_CAP_SYS_HYPERV_CPUID))
>> +        return true;
>
> Here we check whether cs->kvm_state is NULL, but even if it is
> NULL we can still continue execution further through the function.
>
> Later in the function we call hv_cpuid_get_host(), which in turn
> can call get_supported_hv_cpuid_legacy(), which can dereference
> cs->kvm_state without checking it.

get_supported_hv_cpuid_legacy() is only called when KVM_CAP_HYPERV_CPUID
is not supported and this is not possible with
KVM_CAP_SYS_HYPERV_CPUID. Coverity, of course, can't know that.

>
> So either the check on cs->kvm_state above is unnecessary, or we
> need to handle it being NULL in some way other than falling through.

It seems an assert(cs) before calling get_supported_hv_cpuid_legacy()
(with a proper comment) should do the job.

>
> Side note: this change isn't in line with our coding style, which
> requires braces around the body of the if().

My bad, will fix.

-- 
Vitaly

