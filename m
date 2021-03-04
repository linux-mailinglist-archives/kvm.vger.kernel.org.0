Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246BA32D422
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 14:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241041AbhCDN1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 08:27:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43674 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238063AbhCDN1e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 08:27:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614864369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=epVabmFghWRYjAezRywLsA7F665VoAppwPqPKAd51DQ=;
        b=JPoyeanjHqcVvRt2/EWloUuhJBXTmfQ+b9q02rV2osAmwf0qc6JG8K2lfkC1MByVjYx4/d
        nkDD4y1XDhL5KbyWWUupWBW3JI7EibDliKwNwnzN1jeh46st64n8jrj/7R+iR671Kh/Ler
        EWIaEFr2tblpGywZV7q7yVltk0/7d20=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-DxVe1JwfOWaj7ph7S9Osew-1; Thu, 04 Mar 2021 08:26:07 -0500
X-MC-Unique: DxVe1JwfOWaj7ph7S9Osew-1
Received: by mail-wr1-f70.google.com with SMTP id l10so14402291wry.16
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 05:26:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=epVabmFghWRYjAezRywLsA7F665VoAppwPqPKAd51DQ=;
        b=A4FwsIXoV9n7hv6lrCuayLivFZbR6J4HjZlJTEhI/2HYXxEpltAG+mJ5lMZp+jjro2
         wRMkwY8X0SbbWROw54PYB5guuhXJ38bzVb1RI9dD7dWxM7ORXvdnxp0RhBuriCAE7QvE
         RCZveVZ8nJfu/0zxPy0Bb1HJxJShMTbtAtdy7dzUAe2eXq+BXHf3k35W0U9gfv3dM+VX
         3h0mto5azs7kxbSWmxlgU9Po8uq8Wlca8kJ87ygYomiA1nQODniEoghR934jbugFtUzN
         X6s8taKLAWRbJHbkU+BRgAVO35oR9rVC8Z5MQKUAMoSKQZXkxbuer0FGWKWssHON3kA+
         8xWg==
X-Gm-Message-State: AOAM5316bDsa2eaPismHewq689eZY6FfOvw3lkQGaHwsFsjAHM2R7s5s
        UuE+v/iWtfbwcKuJwzMyIA38ib8KizhbdB1sGOX/o/ApusW3sn5gM3zQbCme2CKtu+0h6YRDJWl
        /mLF2hK1LThGq
X-Received: by 2002:adf:9148:: with SMTP id j66mr4187970wrj.124.1614864366652;
        Thu, 04 Mar 2021 05:26:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy6E/KhoVFWABDvp7oRh4xY4g/xgOk4pjLukA9kWhjiqDC3l2ucy7xQysr1rX+UMEREr0a4CA==
X-Received: by 2002:adf:9148:: with SMTP id j66mr4187941wrj.124.1614864366510;
        Thu, 04 Mar 2021 05:26:06 -0800 (PST)
Received: from [192.168.1.36] (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id g11sm24741248wrw.89.2021.03.04.05.26.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 05:26:06 -0800 (PST)
Subject: Re: [PATCH 04/19] cpu: Croup accelerator-specific fields altogether
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Wenchao Wang <wenchao.wang@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-arm@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>, qemu-ppc@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, haxm-team@intel.com
References: <20210303182219.1631042-1-philmd@redhat.com>
 <20210303182219.1631042-5-philmd@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <be8823b0-3d58-e7d1-d2a9-447d78bdb50e@redhat.com>
Date:   Thu, 4 Mar 2021 14:26:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210303182219.1631042-5-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/3/21 7:22 PM, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  include/hw/core/cpu.h | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)

Typo in patch subject "Group" ;)

> 
> diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
> index c005d3dc2d8..074199ce73c 100644
> --- a/include/hw/core/cpu.h
> +++ b/include/hw/core/cpu.h
> @@ -393,10 +393,6 @@ struct CPUState {
>       */
>      uintptr_t mem_io_pc;
>  
> -    int kvm_fd;
> -    struct KVMState *kvm_state;
> -    struct kvm_run *kvm_run;
> -
>      /* Used for events with 'vcpu' and *without* the 'disabled' properties */
>      DECLARE_BITMAP(trace_dstate_delayed, CPU_TRACE_DSTATE_MAX_EVENTS);
>      DECLARE_BITMAP(trace_dstate, CPU_TRACE_DSTATE_MAX_EVENTS);
> @@ -416,6 +412,12 @@ struct CPUState {
>      uint32_t can_do_io;
>      int32_t exception_index;
>  
> +    /* Accelerator-specific fields. */
> +    int kvm_fd;
> +    struct KVMState *kvm_state;
> +    struct kvm_run *kvm_run;
> +    struct hax_vcpu_state *hax_vcpu;
> +    int hvf_fd;
>      /* shared by kvm, hax and hvf */
>      bool vcpu_dirty;
>  
> @@ -426,10 +428,6 @@ struct CPUState {
>  
>      bool ignore_memory_transaction_failures;
>  
> -    struct hax_vcpu_state *hax_vcpu;
> -
> -    int hvf_fd;
> -
>      /* track IOMMUs whose translations we've cached in the TCG TLB */
>      GArray *iommu_notifiers;
>  };
> 

