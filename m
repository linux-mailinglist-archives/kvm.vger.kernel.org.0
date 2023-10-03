Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF327B64B0
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 10:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbjJCIvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 04:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjJCIvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 04:51:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D44A9
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 01:51:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 54B4C1F38C;
        Tue,  3 Oct 2023 08:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696323068; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+e7xFM+HvvIW13K9+Rbko6Whp4xEt979IdWxH8bR46g=;
        b=1wWIT2RnhxDk8FmqK/qcanywIE6w2mnLE4FlmdYRYmRPgdrqnV7TOVMqcQB9r3laDbUGqo
        mQ37j1Q3wYDOOPOWfjCG8gf0xDjg6aZBeD5ucBYLrBi7Qby9BeEFFbAcTTFCn69PNTMRKL
        z5c21t6f9CTogb6mDxGHeyYqgwecoNw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696323068;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+e7xFM+HvvIW13K9+Rbko6Whp4xEt979IdWxH8bR46g=;
        b=A0hNpdIWf8CJzf7rS+Wt+brmkrDX5u7+WfzR18/xoybPYPH0JQZSsfIhW/zu737ox12s5A
        YmF+TzEotyy/+JAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F2A64139F9;
        Tue,  3 Oct 2023 08:51:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KWGtOfvVG2VwPAAAMHmgww
        (envelope-from <cfontana@suse.de>); Tue, 03 Oct 2023 08:51:07 +0000
Message-ID: <411e5aa7-5433-9c06-4571-bfcad565abec@suse.de>
Date:   Tue, 3 Oct 2023 10:51:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/5] accel: Rename accel_cpu_realizefn() ->
 accel_cpu_realize()
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Fabiano Rosas <farosas@suse.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>, kvm@vger.kernel.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
References: <20230915190009.68404-1-philmd@linaro.org>
 <20230915190009.68404-2-philmd@linaro.org>
From:   Claudio Fontana <cfontana@suse.de>
In-Reply-To: <20230915190009.68404-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Claudio Fontana <cfontana@suse.de>

On 9/15/23 21:00, Philippe Mathieu-Daudé wrote:
> We use the '*fn' suffix for handlers, this is a public method.
> Drop the suffix.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  include/qemu/accel.h      | 4 ++--
>  accel/accel-common.c      | 2 +-
>  cpu.c                     | 2 +-
>  target/i386/kvm/kvm-cpu.c | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/qemu/accel.h b/include/qemu/accel.h
> index e84db2e3e5..cb64a07b84 100644
> --- a/include/qemu/accel.h
> +++ b/include/qemu/accel.h
> @@ -90,11 +90,11 @@ void accel_setup_post(MachineState *ms);
>  void accel_cpu_instance_init(CPUState *cpu);
>  
>  /**
> - * accel_cpu_realizefn:
> + * accel_cpu_realize:
>   * @cpu: The CPU that needs to call accel-specific cpu realization.
>   * @errp: currently unused.
>   */
> -bool accel_cpu_realizefn(CPUState *cpu, Error **errp);
> +bool accel_cpu_realize(CPUState *cpu, Error **errp);
>  
>  /**
>   * accel_supported_gdbstub_sstep_flags:
> diff --git a/accel/accel-common.c b/accel/accel-common.c
> index df72cc989a..b953855e8b 100644
> --- a/accel/accel-common.c
> +++ b/accel/accel-common.c
> @@ -119,7 +119,7 @@ void accel_cpu_instance_init(CPUState *cpu)
>      }
>  }
>  
> -bool accel_cpu_realizefn(CPUState *cpu, Error **errp)
> +bool accel_cpu_realize(CPUState *cpu, Error **errp)
>  {
>      CPUClass *cc = CPU_GET_CLASS(cpu);
>  
> diff --git a/cpu.c b/cpu.c
> index 0769b0b153..61c9760e62 100644
> --- a/cpu.c
> +++ b/cpu.c
> @@ -136,7 +136,7 @@ void cpu_exec_realizefn(CPUState *cpu, Error **errp)
>      /* cache the cpu class for the hotpath */
>      cpu->cc = CPU_GET_CLASS(cpu);
>  
> -    if (!accel_cpu_realizefn(cpu, errp)) {
> +    if (!accel_cpu_realize(cpu, errp)) {
>          return;
>      }
>  
> diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
> index 7237378a7d..4474689f81 100644
> --- a/target/i386/kvm/kvm-cpu.c
> +++ b/target/i386/kvm/kvm-cpu.c
> @@ -35,7 +35,7 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
>       * x86_cpu_realize():
>       *  -> x86_cpu_expand_features()
>       *  -> cpu_exec_realizefn():
> -     *            -> accel_cpu_realizefn()
> +     *            -> accel_cpu_realize()
>       *               kvm_cpu_realizefn() -> host_cpu_realizefn()
>       *  -> check/update ucode_rev, phys_bits, mwait
>       */

