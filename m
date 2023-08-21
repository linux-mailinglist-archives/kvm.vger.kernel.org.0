Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA49782364
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 08:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbjHUGFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 02:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbjHUGFH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 02:05:07 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2561A2
        for <kvm@vger.kernel.org>; Sun, 20 Aug 2023 23:04:48 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1bdf4752c3cso14513935ad.2
        for <kvm@vger.kernel.org>; Sun, 20 Aug 2023 23:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692597888; x=1693202688;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J6e+KFmlViVRALS7A8SFOlBSk++WRO42PaKjjl6oN4E=;
        b=VhHH//3xvIyA3AGhGQ9l+WuK+mik82Hw4yhdxSmzZfM65Ao0dBO8wEht7HOhftS6Fv
         oD+r5wGyFi/XGv52+Zc9MHQnO0k0pSEFSpCOhDPgcm97H4LCjWYS5ZD3Dpg0xDbq9rSL
         MXA3uFCg0W5HE6Q7lxRB2pbhbbIZWglRJw38VNOxbt23ob8uUzqJ57sBeu6Pk+LSrTde
         3K53ISFtcV/XxLA6b05p8IdJZzigSQR5y3tEVGQ8ii6K0y7VwG8uKw0UqLam3CIvC+Yh
         /jLOQ9GlUKauFxqiWEQVMEX1JyLITEFSTPgD3dZjERgBkCpqApQ+QkluwJSrQgMZYJFJ
         TNmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692597888; x=1693202688;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J6e+KFmlViVRALS7A8SFOlBSk++WRO42PaKjjl6oN4E=;
        b=ZkI97+WXP0MhZ97LNwSygMD28ox6JJmsYu39CvKVf51+C+SgI4IFjXJp7ZZ+IiZjaR
         24IxjFmjLAIF+AIUFJC0VAuBvmTCJqFhxkB7vjmXFKsobq76/TfjIERSMw7opsjfF9e1
         MRMLsE8WZ4ajBxxxJgnBy+aUeQ6WZCiM4aJGDhV0faCnYBr0CkEdpWyz9RjHDRCu/1gx
         Lq7KWgU4ZJH8sZvwizGVNsadaiWC4S7UNeQHgWvSz3VflavRNeM8HgsKviw/YSecbbj4
         2RFT2XiFF0QWk/tW/CGe4RKy3sUfvw/VC+h3WTmqzdBwCOstf9lmv6KKhQ6lQ/7gCri5
         e0wg==
X-Gm-Message-State: AOJu0YwQ28fKfYLs+04Rm1ykas7+6KRYVCQ6izFne/Rr5XtzdaGoKVCa
        3h9YXpx4DJ2Rgn5esPU9k2Q=
X-Google-Smtp-Source: AGHT+IEhSJlgW192BSOsTrr3Oi2NkF++/qZjp0NE9Pxc+EKYbGsxWUYlS8dtabDAUT2KlQzoL+4stw==
X-Received: by 2002:a17:902:e74b:b0:1b8:aef2:773e with SMTP id p11-20020a170902e74b00b001b8aef2773emr4145595plf.46.1692597888364;
        Sun, 20 Aug 2023 23:04:48 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id o12-20020a170902d4cc00b001b8a00d4f7asm6134591plg.9.2023.08.20.23.04.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Aug 2023 23:04:47 -0700 (PDT)
Message-ID: <0dcbe9ca-cf44-8bb8-ddaa-99f66b0146d3@gmail.com>
Date:   Mon, 21 Aug 2023 14:04:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v3] Documentation: KVM: Add vPMU implementaion and gap
 document
Content-Language: en-US
To:     Xiong Zhang <xiong.y.zhang@intel.com>
Cc:     seanjc@google.com, weijiang.yang@intel.com,
        dapeng1.mi@linux.intel.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        kvm list <kvm@vger.kernel.org>
References: <20230810054518.329117-1-xiong.y.zhang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230810054518.329117-1-xiong.y.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/8/2023 1:45 pm, Xiong Zhang wrote:
> +1. Overview
> +===========
> +
> +KVM has supported PMU virtualization on x86 for many years and provides

"logical core level PMU virtualization"

> +MSR based Arch PMU interface to the guest. The major features include

Drop the "MSR based Arch PMU interface" statement, considering RDPMC.

> +Arch PMU v2, LBR and PEBS. Users have the same operation to profile

include (Arch for Intel) pmu versions up to 2, basic counters, Intel LBR and 
PEBS, etc.

> +performance in guest and host.

Any pmu profiler that works on host based on core pmu (e.g. Linux perl tool) can
be expected to work on guest.

On linux host and guest, the perf subsystem manages pmu hardware resources.

> +KVM is a normal perf subsystem user as other perf subsystem users. When

, but in the kernel space like nmi_watchdog and some ebpf programs that use pmu.

> +the guest access vPMU MSRs, KVM traps it and creates a perf event for it.

This is inaccurate.

KVM emulates the different guest's PMU capabilities as accurately as
possible via creating the appropriate perf_event(s) in the kernel space
to occupy the corresponding PMU resources from the host.

> +This perf event takes part in perf scheduler to request PMU resources
> +and let the guest use these resources.

 From the host perf-core perspective, these KVM-created perf events
take part in perf scheduler, just like any other perf_events.

> +
> +This document describes the X86 PMU virtualization architecture design

Intel PMU only or add more AMD stuff.

> +and opens. It is organized as follows: Next section describes more
> +details of Linux perf scheduler as it takes a key role in vPMU
> +implementation and allocates PMU resources for guest usage. Then Arch
> +PMU virtualization and LBR virtualization are introduced, each feature
> +has sections to introduce implementation overview,  the expectation and
> +gaps when host and guest perf events coexist.
