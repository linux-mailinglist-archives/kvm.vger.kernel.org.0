Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA106AD0BF
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 22:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjCFVo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 16:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjCFVo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 16:44:27 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57D03646A;
        Mon,  6 Mar 2023 13:44:25 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3AC311EC047F;
        Mon,  6 Mar 2023 22:44:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1678139064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=0HeI4VxHb2kpy6AbEpTvPXmKqIQ88zlLdiD7EACayjI=;
        b=gGBnfccbJsXE/UiV8pRk2G9wBHJEh2fTjQ4AqRqC3HC0HKm3E0dUkxbPsEDczxDJVKcwxg
        HiaR7a0ZfCy+uVemg32TgbJJNJT4ZMDTUHjNm1fFH0dO3G+bZ3I2eaHgQfcAvSaYsgMHpb
        ydpZMja936bdfocqFv9s3CHnc7RSMoc=
Date:   Mon, 6 Mar 2023 22:44:19 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Takahiro Itazuri <itazur@amazon.com>, dave.hansen@linux.intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        x86@kernel.org, zulinx86@gmail.com
Subject: Re: [PATCH 0/2] KVM: x86: Propagate AMD-specific IBRS bits to guests
Message-ID: <20230306214419.GDZAZes941k+4NPgDL@fat_crate.local>
References: <Y/5oBKi6vjZe83ac@zn.tnic>
 <20230228222416.61484-1-itazur@amazon.com>
 <Y/6FIeJ5KCOfKEPN@zn.tnic>
 <ZAZYKe4L8jhMG4An@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZAZYKe4L8jhMG4An@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 06, 2023 at 01:16:25PM -0800, Sean Christopherson wrote:
> I thought that the consensus was that adding unused-by-the-kernel flags to
> cpufeatures.h is ok so long as the feature is hidden from /proc/cpuinfo and the
> kernel already dedicates a word to the CPUID leaf?

I guess we should finally write it down in Documentation/x86/cpuinfo.rst

And in case there's no dedicated word, it should be resorted to KVM-only
feature flags.

In any case, I'd like for baremetal CPUID stuff to be decoupled from
KVM's machinery as far as possible as both have different goals wrt
feature flags.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
