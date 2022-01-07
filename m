Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42924487D38
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 20:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbiAGTnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 14:43:40 -0500
Received: from mail.skyhub.de ([5.9.137.197]:44004 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbiAGTnj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 14:43:39 -0500
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 538241EC0464;
        Fri,  7 Jan 2022 20:43:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1641584613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xT/Hp49EdTICk3VFgL8D3ISi+kG8cMrFjEZK0ltQXdI=;
        b=b9mPYxy9efXiFExVz4Yp2WD82+Z3Dx8X3Kiye9rqZ4uUufJ4+4ZgTCaAuFBCYUHQGWrxCo
        3l9QyG28YStnz5fmfNs8saMnE3vUp2TbWNf2oinDCWFED+7vnGViiKo7jf33L5W3yHHfo/
        KzyOKpEV39+sf0dvpdoaKiSdIR9bivk=
Date:   Fri, 7 Jan 2022 20:43:35 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        guang.zeng@intel.com, jing2.liu@intel.com, kevin.tian@intel.com,
        seanjc@google.com, tglx@linutronix.de, wei.w.wang@intel.com,
        yang.zhong@intel.com
Subject: Re: [PATCH v6 05/21] x86/fpu: Make XFD initialization in
 __fpstate_reset() a function argument
Message-ID: <YdiX5y4KxQ7GY7xn@zn.tnic>
References: <20220107185512.25321-1-pbonzini@redhat.com>
 <20220107185512.25321-6-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220107185512.25321-6-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 07, 2022 at 01:54:56PM -0500, Paolo Bonzini wrote:
> From: Jing Liu <jing2.liu@intel.com>
> 
> vCPU threads are different from native tasks regarding to the initial XFD
> value. While all native tasks follow a fixed value (init_fpstate::xfd)
> established by the FPU core at boot, vCPU threads need to obey the reset
> value (i.e. ZERO) defined by the specification, to meet the expectation of
> the guest.
> 
> Let the caller supply an argument and adjust the host and guest related
> invocations accordingly.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

If Jing is author, then tglx's SOB should come after Jing's to mean,
tglx handled it further.

As it is now, it looks wrong.

Ditto for patches 10, 11, 12, 13.

Also, I wonder if all those Signed-off-by's do mean "handled" or
Co-developed-by but I haven't tracked that particular pile so...

> Signed-off-by: Jing Liu <jing2.liu@intel.com>
> Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> Message-Id: <20220105123532.12586-6-yang.zhong@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
