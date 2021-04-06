Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342FF354FEB
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 11:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbhDFJcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 05:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbhDFJcZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 05:32:25 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5C1C06174A;
        Tue,  6 Apr 2021 02:32:17 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0a0d00691dbdb0de837383.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:d00:691d:bdb0:de83:7383])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 740C61EC01B5;
        Tue,  6 Apr 2021 11:32:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617701531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=EkBp7ILwvimd3C86prFra1WB8w/qMaSUVhYcMDdNl68=;
        b=N3vMBPppYmKzbzrswJa0ZU3bDrqSiKUleUIJPJsH55ucSLNdFuWCaENRrI8F/eynzDoEMv
        4OzcblD9/RpY40sVQz6tI1iyjeMtSeArJuW2P98XvBp5KP8W0DZIgjssIMI58PjWzGRy/W
        +jXJG3iTV9pmcKPKpdxh5XcajdsE3MM=
Date:   Tue, 6 Apr 2021 11:32:11 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 13/25] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-ID: <20210406093211.GI17806@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <20e09daf559aa5e9e680a0b4b5fba940f1bad86e.1616136308.git.kai.huang@intel.com>
 <20210405090759.GB19485@zn.tnic>
 <20210406094421.4fdfbb6c4c11e7ee64c3b0a3@intel.com>
 <20210406073917.GA17806@zn.tnic>
 <20210406205958.084147e365d04d066e4357c1@intel.com>
 <20210406090901.GH17806@zn.tnic>
 <20210406212424.86d6d4533b144d4621ecb385@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210406212424.86d6d4533b144d4621ecb385@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021 at 09:24:24PM +1200, Kai Huang wrote:
> Such invalid input has already been handled in handle_encls_xx() before calling
> the two helpers in this patch. KVM returns to Qemu and let it decide whether to
> kill or not. The access_ok()s here are trying to catch KVM bug.

Whatever they try to do, you cannot continue creating an enclave using
invalid input, no matter whether you've warned or not. People do not
stare at dmesg all the time.

> If so we'd better inject an exception to guest (and return 1) in KVM so guest
> can continue to run. Otherwise basically KVM will return to Qemu and let it
> decide (and basically it will kill guest).
>
> I think killing guest is also OK. KVM part patches needs to be updated, though,
> anyway.

Ok, I'll make the changes and you can redo the KVM rest ontop.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
