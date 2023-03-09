Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9BC6B326B
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 00:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjCIXxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 18:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjCIXxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 18:53:50 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E175ADF4
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 15:53:49 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id fr5-20020a17090ae2c500b0023af8a036d2so7207128pjb.5
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 15:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678406029;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/B2yLiGeFDGVh+t6RbXU5CzGX5dV3zO3e2nniLJhd38=;
        b=o/5aWfB4irgyF4/g2aXzQjyWUkO6bB9wgIQoZ5SMykPvTJ+pMxuxXq9q4ZoYxYATaA
         +GRXOPZYaOcOaJaMdYCRLApGu9ks9SWAmTl/vhSjE+ZeNtDnAfQCT1vhLC1d+ichFWhx
         iaEes2RvW0+OX2B/LHe3/68egvG24Vb5MmFCIMXHXmC7dW80+b2fFUF8GW/U/GDLvG8C
         e8tAmxegZF8Q6K/vwHfBuVuCkZrk4XmBs2l14HOOh0T67sy7+GximF4ggEAe7j+DThY1
         N0u9BKwg4vUwYN9sgaaNiSqcH9+xbi3ufMsF7XI7akOOziybYFjnItssWp5AcHuR7p8U
         GNVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678406029;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/B2yLiGeFDGVh+t6RbXU5CzGX5dV3zO3e2nniLJhd38=;
        b=hSS4A2p1sDLlo2NcIJeA0H6SsXHJCRbVvkbASz4PXx0/1jupBAnu+pgdrnYinhlHrx
         kl4T5xVFYQTRMq4Snj5pRnUeVK1od9Sggqvbqq1mughXdGRVLCYS4yjjGuRy8dw1dTfd
         1t9TsgX1cwifrox4s7/628GeGjxiVp0K+Kgy6fTsl16zvwTJJXjWbO88EHS/Ffz8oJo7
         i0Kzo4JO7W7rgJxml4caUBpKOtlB05IGM5AvdfHwQ3VU5/8RfmAPrlQqRJx/+B0SiTM4
         QrPEK4V8JQNmeFOYrsKWJXZoINCeKz/mq5p7UMRHULsm5MZnXALyZzmGq6BGFjSPrYpo
         8U0w==
X-Gm-Message-State: AO0yUKXLKy891xwkpilzPnBARS6rJ36wgzPcn5LAk740Fm1/udqutLUJ
        Iz8gaZfB3PucMQ9l1eNH39znaQ==
X-Google-Smtp-Source: AK7set+XQad+rlik254MTP1MVfd/TT90vMsn7uqie0O+bd2RtGV5RLgMDJAF0Blyl0x61OqFu+meeg==
X-Received: by 2002:a17:90b:33d1:b0:238:13cb:7d4d with SMTP id lk17-20020a17090b33d100b0023813cb7d4dmr23854130pjb.16.1678406028632;
        Thu, 09 Mar 2023 15:53:48 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id gq22-20020a17090b105600b002376d85844dsm116873pjb.51.2023.03.09.15.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 15:53:47 -0800 (PST)
Date:   Thu, 9 Mar 2023 15:53:43 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 03/18] KVM: x86/mmu: Track count of pages in KVM MMU
 page caches globally
Message-ID: <ZApxh/GYfqev7sHA@google.com>
References: <20230306224127.1689967-1-vipinsh@google.com>
 <20230306224127.1689967-4-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306224127.1689967-4-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 06, 2023 at 02:41:12PM -0800, Vipin Sharma wrote:
> Create a global counter for total number of pages available
> in MMU page caches across all VMs. Add mmu_shadow_page_cache
> pages to this counter.

I think I prefer counting the objects on-demand in mmu_shrink_count(),
instead of keeping track of the count. Keeping track of the count adds
complexity to the topup/alloc paths for the sole benefit of the
shrinker. I'd rather contain that complexity to the shrinker code unless
there is a compelling reason to optimize mmu_shrink_count().

IIRC we discussed this at one point. Was there a reason to take this
approach that I'm just forgetting?
