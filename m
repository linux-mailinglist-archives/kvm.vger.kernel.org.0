Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728C66068B5
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 21:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJTTOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 15:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiJTTOk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 15:14:40 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894EA1A3AB
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:14:30 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id l6so413927pgu.7
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V7lgVXABn+gPkNALjTnQM7af7FJAMG87D3zFDKbzEIo=;
        b=Iu1kueaovSbpAd5ca4oASjyI4SVZNbp74YboRPMoyGG/8pGQ8mw5ww0KL7jwnvWal8
         Qj8mOoXwBIw2nYZ1pIamxVN5RTV4lYf1gIq/Ht7HiJFHILktyaNxxPbylK1LZ5+foPoK
         peVTJvbJNjqMtw/LJje6MCEJ6x4aaXveQEgyFSDFEjJxNlDkK1CuE2a12oJ/VR+ObZkb
         3NCWwKjn1qZsaOhd8Om6ttpnr6qX5MzQc/G6Fn6T1kZcw/zFZm9edL2ucPzPF6Az17tk
         UGUPF1RW1/pgxa538G76C1Q0JfUrBkDwVqmlh1AVQMamlreIZ/Kpb1xiFKRZj7U44BPo
         Esfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V7lgVXABn+gPkNALjTnQM7af7FJAMG87D3zFDKbzEIo=;
        b=JfP/hgrBSRzQGR3u5vOU83TWuL95pb8SCOkyD+7+X9elwgbObYm2s4mDrhL5bnPzrF
         Uwf0SlXaTUD+vUJerItJoDPQiKVihcjSNaRaaBI5mPBqx28hinkB8pYQDUJvZoHG3zTN
         5BewLXy+Ch1Vph0YQfChyRbPhKsuH+uM4NxU7L//e7eHqXm8F8xE1aYOZMmju9xy8+i8
         zt4nyzJQ9N6q2azoMhYRqf/VLc7pNxxaYRf9NWLnbS+/JYOaqeIbAh8XfAWu4u9DmXZt
         fFwUs7lpK4i3bCQPlGPQN9JqglS7hEyZhMyNu8+57y+ufv2VrZHyJz+iMZpfiYl3TojV
         56FA==
X-Gm-Message-State: ACrzQf0N8gdD8PkRH++G0kTr0oOyySHqGPh7RxSNRJU1OQWHVP0kwm6K
        irZebqXtgeyhT27m4KkuCH/3Vw==
X-Google-Smtp-Source: AMsMyM6Qxjty96k2VsdSTDarhiB+z7Al+nuc3idq4B4jAFXa3/NWC0qNotMrQEyBBW2R5uWVmY6gZg==
X-Received: by 2002:a63:4507:0:b0:43c:9cf4:f1d6 with SMTP id s7-20020a634507000000b0043c9cf4f1d6mr13378695pga.316.1666293269936;
        Thu, 20 Oct 2022 12:14:29 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u13-20020a170903124d00b0017f80305239sm13333132plh.136.2022.10.20.12.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 12:14:29 -0700 (PDT)
Date:   Thu, 20 Oct 2022 19:14:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 02/16] x86: add few helper functions for
 apic local timer
Message-ID: <Y1GeEoC7qMz40QDc@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
 <20221020152404.283980-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020152404.283980-3-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> Add a few functions to apic.c to make it easier to enable and disable
> the local apic timer.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  lib/x86/apic.c | 37 +++++++++++++++++++++++++++++++++++++
>  lib/x86/apic.h |  6 ++++++
>  2 files changed, 43 insertions(+)
> 
> diff --git a/lib/x86/apic.c b/lib/x86/apic.c
> index 5131525a..dc6d3862 100644
> --- a/lib/x86/apic.c
> +++ b/lib/x86/apic.c
> @@ -256,3 +256,40 @@ void init_apic_map(void)
>  			id_map[j++] = i;
>  	}
>  }
> +
> +void apic_setup_timer(int vector, bool periodic)
> +{
> +	/* APIC runs with 'CPU core clock' divided by value in APIC_TDCR */
> +
> +	u32 lvtt = vector |
> +			(periodic ? APIC_LVT_TIMER_PERIODIC : APIC_LVT_TIMER_ONESHOT);

Rather than take @periodic, take the mode.  That way this funky ternary operator
goes away and the callers are self-tdocumenting, e.g. this

	apic_setup_timer(TIMER_VECTOR, APIC_LVT_TIMER_PERIODIC);

is more obvious than

	apic_setup_timer(TIMER_VECTOR, true);
	
> +
> +	apic_cleanup_timer();
> +	apic_write(APIC_TDCR, APIC_TDR_DIV_1);
> +	apic_write(APIC_LVTT, lvtt);
> +}
> +
> +void apic_start_timer(u32 counter)
> +{
> +	apic_write(APIC_TMICT, counter);
> +}
> +
> +void apic_stop_timer(void)
> +{
> +	apic_write(APIC_TMICT, 0);
> +}
> +
> +void apic_cleanup_timer(void)
> +{
> +	u32 lvtt = apic_read(APIC_LVTT);
> +
> +	// stop the counter
> +	apic_stop_timer();
> +
> +	// mask the timer interrupt
> +	apic_write(APIC_LVTT, lvtt | APIC_LVT_MASKED);
> +
> +	// ensure that a pending timer is serviced
> +	irq_enable();

Jumping back to the "nop" patch, I'm reinforcing my vote to add sti_nop().  I
actually starting typing a response to say this is broken before remembering that
a nop got added to irq_enable().

> +	irq_disable();
> +}
> diff --git a/lib/x86/apic.h b/lib/x86/apic.h
> index 6d27f047..db691e2a 100644
> --- a/lib/x86/apic.h
> +++ b/lib/x86/apic.h
> @@ -58,6 +58,12 @@ void disable_apic(void);
>  void reset_apic(void);
>  void init_apic_map(void);
>  
> +void apic_cleanup_timer(void);
> +void apic_setup_timer(int vector, bool periodic);
> +
> +void apic_start_timer(u32 counter);
> +void apic_stop_timer(void);
> +
>  /* Converts byte-addressable APIC register offset to 4-byte offset. */
>  static inline u32 apic_reg_index(u32 reg)
>  {
> -- 
> 2.26.3
> 
