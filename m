Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356D92FCEF3
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 12:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388921AbhATLOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 06:14:04 -0500
Received: from mail.skyhub.de ([5.9.137.197]:60778 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731282AbhATK2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 05:28:54 -0500
Received: from zn.tnic (p200300ec2f0bb00025b63af061f9e1d5.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:b000:25b6:3af0:61f9:e1d5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0D1C01EC0662;
        Wed, 20 Jan 2021 11:28:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1611138493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=7AMjNx0G21mnisJn54Wa7NGBZtKsUxLseuvdR3AcL7I=;
        b=q7e6+cmuwnDjz0/VuxOynMlCVDvYH7+fEhUyfTkXdELP1jfY9SOKFdbQ4fEHcCeqP+ud/L
        ET/r5DWocgyc3BWoOR0pEuYNYhCtlJFW1grlDjpbhYb/gWvdWzokn/RPkSqZ3e6gsMiLH/
        M7+BJnL+lHtQ9H+HXwtx/fkcSoI2FWY=
Date:   Wed, 20 Jan 2021 11:28:12 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [RFC PATCH v2 01/26] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-ID: <20210120102812.GB825@zn.tnic>
References: <cover.1610935432.git.kai.huang@intel.com>
 <87385f646120a3b5b34dc20480dbce77b8005acd.1610935432.git.kai.huang@intel.com>
 <20210119161925.GN27433@zn.tnic>
 <YAce4r4QhGzJqd4y@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YAce4r4QhGzJqd4y@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 19, 2021 at 10:03:14AM -0800, Sean Christopherson wrote:
> Doesn't adding making the SGX sub-features depend on X86_FEATURE_SGX have the
> same net effect?  Or am I misreading do_clear_cpu_cap()?

No, you're correct - I missed that.

> Though if we use the cpuid_deps table, I'd vote to get rid of clear_sgx_caps()
> and call setup_clear_cpu_cap(X86_FEATURE_SGX) directly.  And probably change the
> existing SGX_LC behavior and drop clear_sgx_caps() in a separate patch instead
> of squeezing it into this one.

Yah, sounds good.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
