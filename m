Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B8C3D596C
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 14:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbhGZLpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 07:45:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36510 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233713AbhGZLpy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 07:45:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627302382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yAG0xqQccUP+f+kw+pTAihdi2ZzJSxeVDJcF4UMu+5c=;
        b=Ke/1WfuGPErjN/1nva5iAsneIbXOGnBiVOSKuunwyFSvKT4b4F5EoCDyb+tSAuQucZ13Sz
        faKnGuRprNQML/fsHoS7AwCuxOUzGfgVEEMphjrkhHGy6i9gwx/sPbNj6pBngqSgrFhozA
        F7vQbBwwEIWflZkYPBPze5Z4FN4ut4Q=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-600-g9XsMZ4oM46ZxEPJEnMJuQ-1; Mon, 26 Jul 2021 08:26:21 -0400
X-MC-Unique: g9XsMZ4oM46ZxEPJEnMJuQ-1
Received: by mail-ej1-f72.google.com with SMTP id c18-20020a1709067632b02905478dfedcafso1965425ejn.21
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 05:26:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yAG0xqQccUP+f+kw+pTAihdi2ZzJSxeVDJcF4UMu+5c=;
        b=g26/bCj5RM5gt2IG7LVRhvCaaKm7iWknmibzoMywAActz8PVGhus53n5/jUi2m2OXS
         SQQtHbYyGkmQ53ZzrBhCBaXWZsIBEH3Oebw1B4G/Kx36l3JXxlCltlUOmiSviluZnNJc
         10SNnLcHAC1DiddL9qSMbGhKvm5DuVvW+pCf+ENZCOGzBmhDr+nGbe5mZqtNT/2QiRXY
         5fa1qghyKfNsI2nk3Uf4LkiguryNUpGzLdD2qMkz5HoyYZi6hl7em619RfOIbw6F4yND
         u6kr1VwIUaEKJI6OCu6PmeVqzkMnGhG5tIQDWz65QppUarcwSGN/zfjy2rO0AEgXWCBn
         dzDA==
X-Gm-Message-State: AOAM533jk+9bHtYcR7tADxpiqY1k0yJUW4rjXvR1EA5/Ih5P7pHibQh+
        4THHfegkdUJi/cg59m9NuE2/G8YEd/fCWsANLJ68En/6Umns+nYUfmQnOp0n41FnsuAYPGUCoGy
        2uOeU7dmE3xiS
X-Received: by 2002:a05:6402:424e:: with SMTP id g14mr21291847edb.364.1627302380127;
        Mon, 26 Jul 2021 05:26:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqkwdPnaViy67oIjfnoktBLJlDQUHjdW1FLT6+T736sxyjwJBwk4dpFQzX7c9cnngwMutAlQ==
X-Received: by 2002:a05:6402:424e:: with SMTP id g14mr21291836edb.364.1627302379979;
        Mon, 26 Jul 2021 05:26:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g23sm18681156edp.90.2021.07.26.05.26.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 05:26:19 -0700 (PDT)
Subject: Re: [PATCH 3/3] docs: virt: kvm: api.rst: replace some characters
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1626947264.git.mchehab+huawei@kernel.org>
 <ff70cb42d63f3a1da66af1b21b8d038418ed5189.1626947264.git.mchehab+huawei@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <33d0dd04-15ba-9d32-c73f-9d086cd3e458@redhat.com>
Date:   Mon, 26 Jul 2021 14:26:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ff70cb42d63f3a1da66af1b21b8d038418ed5189.1626947264.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/07/21 11:50, Mauro Carvalho Chehab wrote:
> The conversion tools used during DocBook/LaTeX/html/Markdown->ReST
> conversion and some cut-and-pasted text contain some characters that
> aren't easily reachable on standard keyboards and/or could cause
> troubles when parsed by the documentation build system.
> 
> Replace the occurences of the following characters:
> 
> 	- U+00a0 (' '): NO-BREAK SPACE
> 	  as it can cause lines being truncated on PDF output
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>   Documentation/virt/kvm/api.rst | 28 ++++++++++++++--------------
>   1 file changed, 14 insertions(+), 14 deletions(-)

Queued, thanks.

Paolo

> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index c7b165ca70b6..3a6118540747 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -855,7 +855,7 @@ in-kernel irqchip (GIC), and for in-kernel irqchip can tell the GIC to
>   use PPIs designated for specific cpus.  The irq field is interpreted
>   like this::
>   
> -  bits:  |  31 ... 28  | 27 ... 24 | 23  ... 16 | 15 ... 0 |
> +  bits:  |  31 ... 28  | 27 ... 24 | 23  ... 16 | 15 ... 0 |
>     field: | vcpu2_index | irq_type  | vcpu_index |  irq_id  |
>   
>   The irq_type field has the following values:
> @@ -2149,10 +2149,10 @@ prior to calling the KVM_RUN ioctl.
>   Errors:
>   
>     ======   ============================================================
> -  ENOENT   no such register
> -  EINVAL   invalid register ID, or no such register or used with VMs in
> +  ENOENT   no such register
> +  EINVAL   invalid register ID, or no such register or used with VMs in
>              protected virtualization mode on s390
> -  EPERM    (arm64) register access not allowed before vcpu finalization
> +  EPERM    (arm64) register access not allowed before vcpu finalization
>     ======   ============================================================
>   
>   (These error codes are indicative only: do not rely on a specific error
> @@ -2590,10 +2590,10 @@ following id bit patterns::
>   Errors include:
>   
>     ======== ============================================================
> -  ENOENT   no such register
> -  EINVAL   invalid register ID, or no such register or used with VMs in
> +  ENOENT   no such register
> +  EINVAL   invalid register ID, or no such register or used with VMs in
>              protected virtualization mode on s390
> -  EPERM    (arm64) register access not allowed before vcpu finalization
> +  EPERM    (arm64) register access not allowed before vcpu finalization
>     ======== ============================================================
>   
>   (These error codes are indicative only: do not rely on a specific error
> @@ -3112,13 +3112,13 @@ current state.  "addr" is ignored.
>   Errors:
>   
>     ======     =================================================================
> -  EINVAL     the target is unknown, or the combination of features is invalid.
> -  ENOENT     a features bit specified is unknown.
> +  EINVAL     the target is unknown, or the combination of features is invalid.
> +  ENOENT     a features bit specified is unknown.
>     ======     =================================================================
>   
>   This tells KVM what type of CPU to present to the guest, and what
> -optional features it should have.  This will cause a reset of the cpu
> -registers to their initial values.  If this is not called, KVM_RUN will
> +optional features it should have.  This will cause a reset of the cpu
> +registers to their initial values.  If this is not called, KVM_RUN will
>   return ENOEXEC for that vcpu.
>   
>   The initial values are defined as:
> @@ -3239,8 +3239,8 @@ VCPU matching underlying host.
>   Errors:
>   
>     =====      ==============================================================
> -  E2BIG      the reg index list is too big to fit in the array specified by
> -             the user (the number required will be written into n).
> +  E2BIG      the reg index list is too big to fit in the array specified by
> +             the user (the number required will be written into n).
>     =====      ==============================================================
>   
>   ::
> @@ -3288,7 +3288,7 @@ specific device.
>   ARM/arm64 divides the id field into two parts, a device id and an
>   address type id specific to the individual device::
>   
> -  bits:  | 63        ...       32 | 31    ...    16 | 15    ...    0 |
> +  bits:  | 63        ...       32 | 31    ...    16 | 15    ...    0 |
>     field: |        0x00000000      |     device id   |  addr type id  |
>   
>   ARM/arm64 currently only require this when using the in-kernel GIC
> 

