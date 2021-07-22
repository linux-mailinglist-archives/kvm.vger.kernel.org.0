Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63213D2B7F
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 19:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhGVRND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 13:13:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50189 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230136AbhGVRND (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 13:13:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626976417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/K4rltyqsAb7Ub8Q4FT9diwQD1UYRp71oj8U7qgcR0k=;
        b=DwSJoiqUXo6QZrhc1dNQUucL8ABshQalBnf0nuYXmmDk/5wMvBO50+f+NCSswaT4h8ayhR
        CM+gl8v5vSGRxxWw7nRlC72f7IApm06KOVytQEU9K04m3JA22+M/H+SGjcpHg50IYoXeXG
        xt/zg+NkUfHcqVkJTlc4ZHBGvOJ3+40=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-1wryjH19NxShHw3rhPEiqQ-1; Thu, 22 Jul 2021 13:53:36 -0400
X-MC-Unique: 1wryjH19NxShHw3rhPEiqQ-1
Received: by mail-ot1-f69.google.com with SMTP id f13-20020a9d038d0000b02904d1011b3b03so4158966otf.10
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 10:53:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/K4rltyqsAb7Ub8Q4FT9diwQD1UYRp71oj8U7qgcR0k=;
        b=GX3uxt9Co/DMco4AaPCQKtsSIiR1shPWCNQcE9pwbG7oXEjZO2lpU309BOschzBfeg
         kcUfbTxzWA4MJIFkOqAqwKn57D+NqnCKhRCNBHgrHmBn3GoXFkFWHMqQF2bZQj0/cdW8
         Ih6b6eBrOPOZRGs88ma690bbQ68EAD1QZQouD/cKijfU9S9P/vYzYrro7TLQHM9z36jr
         SBAfyl7IXwRXtQFjk3u2S67xe4O/smKg7Rxm0b5gIDSIOhoZHkw1J33BzJio42JV4GF/
         0SPhhfTv0Nr+FS+ikfJUrqNs4zpXboI3Igwg0oyVajiJqir548SkEtiHquO0SpOBtqSD
         m3VA==
X-Gm-Message-State: AOAM530n02DNexspxlgCyT3ajh3I0pzUWyqge/yAzjHOA5yvGzA45InZ
        b9SW4WqJ4WiSP2GoryDgpzpyZ4PCKRUWKPnsPObpINYeJpw/x88jjo5GTiSEba9uSKObT/MA+/o
        zKMsMxIpq9A7rmQC219+zU6W5gdw/4xN0+zP8JUNbK+fDN0FOtQBpU8hzci6M0g==
X-Received: by 2002:a9d:4f09:: with SMTP id d9mr623323otl.265.1626976415846;
        Thu, 22 Jul 2021 10:53:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyeN9sQzyGrVPsk4cXiWBn35sZe9ThQAZ000dk8B7mgbgiS7OPXMDXEn3ZeJAkmnI4XqnBRhw==
X-Received: by 2002:a9d:4f09:: with SMTP id d9mr623298otl.265.1626976415641;
        Thu, 22 Jul 2021 10:53:35 -0700 (PDT)
Received: from [192.168.0.173] (ip68-102-25-176.ks.ok.cox.net. [68.102.25.176])
        by smtp.gmail.com with ESMTPSA id v203sm5686243oib.37.2021.07.22.10.53.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 10:53:35 -0700 (PDT)
From:   Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v2 32/44] tdx: add kvm_tdx_enabled() accessor for
 later use
To:     isaku.yamahata@gmail.com, qemu-devel@nongnu.org,
        pbonzini@redhat.com, alistair@alistair23.me, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, mst@redhat.com, cohuck@redhat.com,
        mtosatti@redhat.com, xiaoyao.li@intel.com, seanjc@google.com,
        erdemaktas@google.com
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <26d88e7618038c1fed501352a04144745abd12ae.1625704981.git.isaku.yamahata@intel.com>
Message-ID: <43a81d27-56da-07e8-b3d7-9800b6ed8da1@redhat.com>
Date:   Thu, 22 Jul 2021 12:53:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <26d88e7618038c1fed501352a04144745abd12ae.1625704981.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/7/21 7:55 PM, isaku.yamahata@gmail.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   include/sysemu/tdx.h  | 1 +
>   target/i386/kvm/kvm.c | 5 +++++
>   2 files changed, 6 insertions(+)
> 
> diff --git a/include/sysemu/tdx.h b/include/sysemu/tdx.h
> index 70eb01348f..f3eced10f9 100644
> --- a/include/sysemu/tdx.h
> +++ b/include/sysemu/tdx.h
> @@ -6,6 +6,7 @@
>   #include "hw/i386/pc.h"
>   
>   bool kvm_has_tdx(KVMState *s);
> +bool kvm_tdx_enabled(void);
>   int tdx_system_firmware_init(PCMachineState *pcms, MemoryRegion *rom_memory);
>   #endif
>   
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index af6b5f350e..76c3ea9fac 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -152,6 +152,11 @@ int kvm_set_vm_type(MachineState *ms, int kvm_type)
>       return -ENOTSUP;
>   }
>   
> +bool kvm_tdx_enabled(void)
> +{
> +    return vm_type == KVM_X86_TDX_VM;
> +}
> +

Is this the whole story? Does this guarantee that the VM QEMU is
responsible to bring up is a successfully initialized TD?

 From my reading of the series as it unfolded, this looks like the
function proves that KVM can support TDs and that the user requested
a TDX kvm-type, not that we have a fully-formed TD.

Is it possible to associate this with a more verifiable metric that
the TD has been or will be created successfully? I.e., once the VM
has successfully called the TDX INIT ioctl or has finalized setup?

My question mainly comes from a later patch in the series, where the
"query-tdx-capabilities" and "query-tdx" QMP commands are added.

Forgive me if I am misinterpreting the semantics of each of these
commands:

"query-tdx-capabilities" sounds like it answers the question of
"can it run a TD?"

and "query-tdx" sounds like it answers the question of "is it a TD?"

Is the assumption with "query-tdx" that anything that's gone wrong
with developing a TD will have resulted in the QEMU process exiting
and therefore if we get to a point where we can run "query-tdx" then
we know the TD was successfully formed?

