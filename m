Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F0675AAD0
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 11:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjGTJa0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 05:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbjGTJaL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 05:30:11 -0400
Received: from out-40.mta0.migadu.com (out-40.mta0.migadu.com [91.218.175.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF19524E
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 02:17:47 -0700 (PDT)
Message-ID: <5c91b8dd-5342-0eb2-aef4-dbb865d6dfda@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689844665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=twWOXbWYEQiWDLte803PU4TQyX4ZqCM5632vlvyl10U=;
        b=DB4eeuEjhTPCPJI9o1K6etLTAH2GlZQ2jKXZfEFtglosq8nta+hFXp6Q19BwC13rtbePUk
        4Xqaig9i/B8Qj2QmJCTE40PIJtYSpL9nzXN3Fq/R/yxGavRbtAQmKtatqPuKqCmNMKb0uF
        SIeyywuFj8e2ghKEwpEuU+vXBHjeWk8=
Date:   Thu, 20 Jul 2023 17:17:31 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/9] PCI/VGA: Improve the default VGA device selection
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     David Airlie <airlied@gmail.com>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        Sui Jingfeng <suijingfeng@loongson.cn>,
        linux-pci@vger.kernel.org
References: <20230719193241.GA510805@bhelgaas>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Sui Jingfeng <sui.jingfeng@linux.dev>
In-Reply-To: <20230719193241.GA510805@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2023/7/20 03:32, Bjorn Helgaas wrote:
>>    drm/amdgpu: Implement the is_primary_gpu callback of
>>      vga_client_register()
>>    drm/radeon: Add an implement for the is_primary_gpu function callback
>>    drm/i915: Add an implement for the is_primary_gpu hook
>>    drm/ast: Register as a vga client to vgaarb by calling
>>      vga_client_register()
>>    drm/loongson: Add an implement for the is_primary_gpu function
>>      callback
> There's unnecessary variation in the subject lines (and the commit
> logs) of these patches.  If they all do the same thing but in
> different drivers, it's useful if the patches all*look*  the same.
>
> You might be able to write these subjects as
> "Implement .is_primary_gpu() callback" for brevity.


This is a very good suggestion, I will adopt this.

Thanks, really.

