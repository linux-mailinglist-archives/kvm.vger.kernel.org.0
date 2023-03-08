Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5801C6AFBCF
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 02:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjCHBLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 20:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjCHBLq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 20:11:46 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E402A226F;
        Tue,  7 Mar 2023 17:11:45 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so716629pjh.0;
        Tue, 07 Mar 2023 17:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678237905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J8ONqigr/nW5tIGEdhR+R75AMkzFf0+8XY3jd4ywJU8=;
        b=CTurYiWZ1Reif4YElUxcDwN65AMotRsNZDFfJ2kkGI+x1H061rieocTa0gAfRwvoqD
         hi5o+VCD2ur3RVP9FCM70oWpMOXT6+Eg+csEgOzmqX+imPr9V3+UstRE4q33FyGHoOgV
         Ls5LfMps+bNLyousqRclhKwK9u/bgOBXqLS/xFk5ZnwVuoerlNIz8kCMzYRLmLQa+eGC
         cVcUvWBSvf972Qn4vL3I+687/RgYp0RkD2X7S2qCXE4cry2bHxDjg8zu4GtglLW+wYZi
         QLa79vj205bTcpGSx5iOPZdKi3mYBfIvDTmbW6Vj0TrM52JdhbEqMw0uDaBieR0wFCa6
         cDMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678237905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J8ONqigr/nW5tIGEdhR+R75AMkzFf0+8XY3jd4ywJU8=;
        b=Dm2jPbWzxgp3E09YnRjcmb0kix2dQjgXJqt3kRFhzaQ8ip1BFweBdjjpUlpvY12ySJ
         SFPVmhaufOBbM5kVkii5mhMd3jr6cvtzyt+DiBSCTIvfJ6hb4fTTdvXZ8PoWh4z3gDJS
         yN83LIRVgq0UMHVSawSNS47nOHTT1P/GQ2m0HMvNXtsIJVg/8GGRLGEcOGhAbBLnSGav
         eHICZZzCj1cQcmHo9amHhjdPOzhK9e4LZ9+3cljr/hQx8bc8iy54K5yg642Lf7DsNHmD
         w+8hAwhNeLFT69cu+wRtlUL5NMc4HzYExGgu9RTZuVcwOYH9MTExknmbjiPO/M5go1Cp
         RUUQ==
X-Gm-Message-State: AO0yUKV8KXgmm+1aLvZYrTR0Dw5JWzDMfwRCaYyX6CRl3Po9La6IPqWd
        Lqx0ELTj1KVST/VNVVS0Lqo=
X-Google-Smtp-Source: AK7set+ES0Hb20zvp5kC5ZcodaywSCanx9+95gQWDBrVrMkniBi+h2ZtoNgZCRC5UzA7EkKCq3HZfA==
X-Received: by 2002:a17:902:ebc4:b0:19d:461:9628 with SMTP id p4-20020a170902ebc400b0019d04619628mr18533027plg.34.1678237904581;
        Tue, 07 Mar 2023 17:11:44 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id q10-20020a63504a000000b004fcda0e59c3sm8153904pgl.69.2023.03.07.17.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 17:11:43 -0800 (PST)
Date:   Tue, 7 Mar 2023 17:11:42 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        david@redhat.com, bagasdotme@gmail.com, sagis@google.com,
        imammedo@redhat.com, isaku.yamahata@gmail.com
Subject: Re: [PATCH v10 00/16] TDX host kernel support
Message-ID: <20230308011142.GA2841114@ls.amr.corp.intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1678111292.git.kai.huang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 07, 2023 at 03:13:45AM +1300,
Kai Huang <kai.huang@intel.com> wrote:

> Intel Trusted Domain Extensions (TDX) protects guest VMs from malicious
> host and certain physical attacks.  TDX specs are available in [1].
> 
> This series is the initial support to enable TDX with minimal code to
> allow KVM to create and run TDX guests.  KVM support for TDX is being
> developed separately[2].  A new "userspace inaccessible memfd" approach
> to support TDX private memory is also being developed[3].  The KVM will
> only support the new "userspace inaccessible memfd" as TDX guest memory.
> 
> This series doesn't aim to support all functionalities, and doesn't aim
> to resolve all things perfectly.  For example, memory hotplug is handled
> in simple way (please refer to "Kernel policy on TDX memory" and "Memory
> hotplug" sections below).
> 
> (For memory hotplug, sorry for broadcasting widely but I cc'ed the
> linux-mm@kvack.org following Kirill's suggestion so MM experts can also
> help to provide comments.)
> 
> And TDX module metadata allocation just uses alloc_contig_pages() to
> allocate large chunk at runtime, thus it can fail.  It is imperfect now
> but _will_ be improved in the future.
> 
> Also, the patch to add the new kernel comline tdx="force" isn't included
> in this initial version, as Dave suggested it isn't mandatory.  But I
> _will_ add one once this initial version gets merged.
> 
> All other optimizations will be posted as follow-up once this initial
> TDX support is upstreamed.
> 
> Hi Dave, Peter, Thomas, Dan (and Intel reviewers),
> 
> The environment to test the new LP.INIT SEAMCALL behaviour hasn't been
> done yet, thus I haven't tested the new behaviour.  Instead, I tested
> with all cpus are online when initializing the TDX module.  CPU hotplug
> path isn't really tested although I did some basic test that I can
> offline some cpus after module initialization, online them again and the
> LP.INIT was skipped successfully for them.
> 
> However I believe there should be no issue when the new module is ready.
> I will test and report back when the new module is ready.
> 
> I would appreciate if folks could review this presumptive series anyway.
>    
> And I would appreciate reviewed-by or acked-by tags if the patches look
> good to you.
> 
> ----- Changelog history: ------
> 
> - v9 -> v10:
> 
>  - Changed the per-cpu initalization handling
>    - Gave up "ensuring all online cpus are TDX-runnable when TDX module
>      is initialized", but just provide two basic functions, tdx_enable()
>      and tdx_cpu_enable(), to let the user of TDX to make sure the
>      tdx_cpu_enable() has been done successfully when the user wants to
>      use particular cpu for TDX.
>    - Thus, moved per-cpu initialization out of tdx_enable().  Now
>      tdx_enable() just assumes VMXON and tdx_cpu_enable() has been done
>      on all online cpus before calling it.
>    - Merged the tdx_enable() skeleton patch and per-cpu initialization
>      patch together to tell better story.
>    - Moved "SEAMCALL infrastructure" patch before the tdx_enable() patch.
> 
>  v9: https://lore.kernel.org/lkml/cover.1676286526.git.kai.huang@intel.com/
> 
> - v8 -> v9:
> 
>  - Added patches to handle TDH.SYS.INIT and TDH.SYS.LP.INIT back.
>  - Other changes please refer to changelog histroy in individual patches.

I've rebased my TDX KVM patches to this patch series and updated initialization.
With all LPs online with the existing TDX module and I did cpu online/offline
while TD running.

Test-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
