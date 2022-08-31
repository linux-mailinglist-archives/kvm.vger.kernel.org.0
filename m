Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7ECA5A7E1F
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 14:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiHaM6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 08:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiHaM6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 08:58:30 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65928A6AD2
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 05:58:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1021022174;
        Wed, 31 Aug 2022 12:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661950708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2mjNhewGnOLtMkaFkgtnBNwwmDcmxf9E7Dpi742RpEk=;
        b=sRN1Y2mWk0MKUUjKuKtokwj/XnE+9DoqPpH6dL4WPf/MwmzuDM0ZnMzMZWtky97jdd0ph0
        x9qVCZcPJGb5n/RstvU7Uc9rT1JgCeA6g7R/L2UuBJ73tk3itSiLYjktwo1aT0EcLItsLC
        HwHFyiUlOlU4O+42KaTV9W5ANFhJBkk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661950708;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2mjNhewGnOLtMkaFkgtnBNwwmDcmxf9E7Dpi742RpEk=;
        b=2k5DOfcfBbJceyzib6rUJ1MX6vs2evdJK3Q8YIyOl6iReNINGeAqUxOO9Wtt9CczyMQ3kv
        wYk1qbpM2x4C17Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5891413A7C;
        Wed, 31 Aug 2022 12:58:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hw8qFPJaD2MHKgAAMHmgww
        (envelope-from <cfontana@suse.de>); Wed, 31 Aug 2022 12:58:26 +0000
Message-ID: <922ed8ba-a069-20c9-78d1-6a4ea3ab623a@suse.de>
Date:   Wed, 31 Aug 2022 14:58:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 2/2] [RfC] expose host-phys-bits to guest
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>, MaLin <lma@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>,
        Charles Arnold <carnold@suse.com>,
        Jim Fehlig <jfehlig@suse.com>
References: <20220831125059.170032-1-kraxel@redhat.com>
 <20220831125059.170032-3-kraxel@redhat.com>
From:   Claudio Fontana <cfontana@suse.de>
In-Reply-To: <20220831125059.170032-3-kraxel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ccing some folks, since we are just now adding host bits awareness through the higher level tools.

On 8/31/22 14:50, Gerd Hoffmann wrote:
> Move "host-phys-bits" property from cpu->host_phys_bits to
> cpu->env.features[FEAT_KVM_HINTS] (KVM_HINTS_HOST_PHYS_BITS).
> 
> This has the effect that the guest can see whenever host-phys-bits
> is turned on or not and act accordingly.
> 
> Current mode of operation for firmware is to be conservative with
> address space usage because is impossible to figure how much is
> actually available.  This patch allows the firmware to use the full
> physical address space available (with host-phys-bits=on).
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  target/i386/cpu.h      | 3 ---
>  hw/i386/microvm.c      | 6 +++++-
>  target/i386/cpu.c      | 3 +--
>  target/i386/host-cpu.c | 4 +++-
>  target/i386/kvm/kvm.c  | 1 +
>  5 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 82004b65b944..b9c6d3d9cac6 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1898,9 +1898,6 @@ struct ArchCPU {
>      /* if true fill the top bits of the MTRR_PHYSMASKn variable range */
>      bool fill_mtrr_mask;
>  
> -    /* if true override the phys_bits value with a value read from the host */
> -    bool host_phys_bits;
> -
>      /* if set, limit maximum value for phys_bits when host_phys_bits is true */
>      uint8_t host_phys_bits_limit;
>  
> diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
> index 7fe8cce03e92..edb1d4cbcbc1 100644
> --- a/hw/i386/microvm.c
> +++ b/hw/i386/microvm.c
> @@ -54,6 +54,8 @@
>  #include "kvm/kvm_i386.h"
>  #include "hw/xen/start_info.h"
>  
> +#include "standard-headers/asm-x86/kvm_para.h"
> +
>  #define MICROVM_QBOOT_FILENAME "qboot.rom"
>  #define MICROVM_BIOS_FILENAME  "bios-microvm.bin"
>  
> @@ -424,7 +426,9 @@ static void microvm_device_pre_plug_cb(HotplugHandler *hotplug_dev,
>  {
>      X86CPU *cpu = X86_CPU(dev);
>  
> -    cpu->host_phys_bits = true; /* need reliable phys-bits */
> +    /* need reliable phys-bits */
> +    cpu->env.features[FEAT_KVM_HINTS] |= (1 << KVM_HINTS_HOST_PHYS_BITS);
> +
>      x86_cpu_pre_plug(hotplug_dev, dev, errp);
>  }
>  
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 1db1278a599b..d60f4498a3c3 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -778,7 +778,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>      [FEAT_KVM_HINTS] = {
>          .type = CPUID_FEATURE_WORD,
>          .feat_names = {
> -            "kvm-hint-dedicated", NULL, NULL, NULL,
> +            "kvm-hint-dedicated", "host-phys-bits", NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,
> @@ -7016,7 +7016,6 @@ static Property x86_cpu_properties[] = {
>      DEFINE_PROP_BOOL("x-force-features", X86CPU, force_features, false),
>      DEFINE_PROP_BOOL("kvm", X86CPU, expose_kvm, true),
>      DEFINE_PROP_UINT32("phys-bits", X86CPU, phys_bits, 0),
> -    DEFINE_PROP_BOOL("host-phys-bits", X86CPU, host_phys_bits, false),
>      DEFINE_PROP_UINT8("host-phys-bits-limit", X86CPU, host_phys_bits_limit, 0),
>      DEFINE_PROP_BOOL("fill-mtrr-mask", X86CPU, fill_mtrr_mask, true),
>      DEFINE_PROP_UINT32("level-func7", X86CPU, env.cpuid_level_func7,
> diff --git a/target/i386/host-cpu.c b/target/i386/host-cpu.c
> index 10f8aba86e53..30e9dd9f66f1 100644
> --- a/target/i386/host-cpu.c
> +++ b/target/i386/host-cpu.c
> @@ -13,6 +13,8 @@
>  #include "qapi/error.h"
>  #include "sysemu/sysemu.h"
>  
> +#include "standard-headers/asm-x86/kvm_para.h"
> +
>  /* Note: Only safe for use on x86(-64) hosts */
>  static uint32_t host_cpu_phys_bits(void)
>  {
> @@ -68,7 +70,7 @@ static uint32_t host_cpu_adjust_phys_bits(X86CPU *cpu)
>          warned = true;
>      }
>  
> -    if (cpu->host_phys_bits) {
> +    if (cpu->env.features[FEAT_KVM_HINTS] & (1 << KVM_HINTS_HOST_PHYS_BITS)) {
>          /* The user asked for us to use the host physical bits */
>          phys_bits = host_phys_bits;
>          if (cpu->host_phys_bits_limit &&
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index f148a6d52fa4..182a70c98d35 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -459,6 +459,7 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
>          }
>      } else if (function == KVM_CPUID_FEATURES && reg == R_EDX) {
>          ret |= 1U << KVM_HINTS_REALTIME;
> +        ret |= 1U << KVM_HINTS_HOST_PHYS_BITS;
>      }
>  
>      return ret;

