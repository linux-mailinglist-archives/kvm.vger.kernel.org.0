Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693C047396F
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 01:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242994AbhLNAQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 19:16:24 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:38150 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235953AbhLNAQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 19:16:23 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639440981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=182CaLkrudOaR+9Ew+vQUAetN9cb/2MIYW1GXOWGjoA=;
        b=GWGVeMG40QTSveXTc3rkBeXKI9eyw46qJoI0vyBqATBJr0Joj1KiChZo/4Al3r2MWmsfN2
        gYHC62DzBeFBuY5O2DmfErLAudZ6q/UQECi77x6gKiHT0jOzJoLK+2yKxZEv5+jk2ngVyX
        yC8mRzY6O46VHB6YXUanElK3Jqq4GudVvqITfgMMsZYpK6nkboDLMiCx628tf0BgYmjHaZ
        ypr/JDdsNH7BRSCqp93BKSKYtw6AoX0vSfrL/ZaCzFbJPhySP5KPQOB+tFa8MeHl29ydPs
        cKQ2DsG1aTCtnz0NCKEacMIJ7dQ7/H4FixMidKjuDKzNVoYSroa2C0BI461lvQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639440981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=182CaLkrudOaR+9Ew+vQUAetN9cb/2MIYW1GXOWGjoA=;
        b=E2MPYqC0sxflE2h/d1TtY1INi1+74QLWTnDPqAEILIHKj70bQt+hRlXlsgZT3Y6XVPwuE/
        H0yWaQk3jqbWwlDw==
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: Re: [PATCH 01/19] x86/fpu: Extend prctl() with guest permissions
In-Reply-To: <20211208000359.2853257-2-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-2-yang.zhong@intel.com>
Date:   Tue, 14 Dec 2021 01:16:21 +0100
Message-ID: <87lf0ot50q.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07 2021 at 19:03, Yang Zhong wrote:
> Similar to native permissions this doesn't actually enable the
> permitted feature. KVM is expected to install a larger kernel buffer
> and enable the feature when detecting the intention from the guest.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Jing Liu <jing2.liu@intel.com>
> Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> ---
> (To Thomas) We change the definition of xstate_get_guest_group_perm()
> from xstate.h to api.h since this will be called by KVM.

No.

There is absolutely no need for that. After creating a vCPU the
permissions are frozen and readily available via
vcpu->arch.guest_fpu.perm.

Thanks,

        tglx

