Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FF16A4D6D
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjB0Vkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjB0Vkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:40:37 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE95D1C32B;
        Mon, 27 Feb 2023 13:40:28 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 97B5F1EC0662;
        Mon, 27 Feb 2023 22:40:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677534026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=4/vQLeIDxE7bzYfVEHXOzNAymHoiUgj8mZwhdk5DScc=;
        b=S7OiMOVcgV47AMOPOxlW33i/QIJC6wSmMzNIqDEPJFPyvDqkmUcGiSrgbhgy7V58rXKpiQ
        JItGOXOYngc6ou0nISkYnXLuT1rERZfZN0uIFhraSiKW2kcDf1Q2rszBVRDh96VrVjcG6H
        3+Fwrl7ISl8N2HfSNJY2cfF/D6TtCgI=
Date:   Mon, 27 Feb 2023 22:40:21 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Takahiro Itazuri <itazur@amazon.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, Takahiro Itazuri <zulinx86@gmail.com>
Subject: Re: [PATCH 0/2] KVM: x86: Propagate AMD-specific IBRS bits to guests
Message-ID: <Y/0jRXzbcbxTjqSS@zn.tnic>
References: <20230227210526.83182-1-itazur@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230227210526.83182-1-itazur@amazon.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 09:05:24PM +0000, Takahiro Itazuri wrote:
> VMMs retrieve supported CPUID features via KVM_GET_SUPPORTED_CPUID to
> construct CPUID information to be passed to KVM_SET_CPUID2. Most CPUID
> feature bits related to speculative attacks are propagated from host
> CPUID. But AMD processors have AMD-specific IBRS related bits in CPUID
> Fn8000_0008_EBX (ref: AMD64 Architecture Programmer's Manual Volume 3:
> General-Purpose and System Instructions) and some bits are not
> propagated to guests.
> 
> Enable propagation of these bits to guests, so that VMMs don't have to
> enable them explicitly based on host CPUID.

How hard is it for the VMMs to enable them?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
