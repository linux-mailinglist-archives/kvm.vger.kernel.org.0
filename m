Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9FC209FD0
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 15:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405000AbgFYN0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 09:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404888AbgFYN0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 09:26:18 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADF6C08C5C1;
        Thu, 25 Jun 2020 06:26:18 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0ed10074d8a868b8f3cf92.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:d100:74d8:a868:b8f3:cf92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CFE0C1EC03F0;
        Thu, 25 Jun 2020 15:26:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1593091577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=8nllPNkefZLtge6T1+fl0TvxIAEHeAqYDppxTpvHcOQ=;
        b=DozaLm20n98Ezq6eqr0ypoKyVBmALyjCP2oB1ZgFm5fcMbETYgS52lX85HRJP1duth2cPu
        AqgVvBoe2jPWmP1ghlFhSERaxbWyBmrErnQW8YQW0a93S9XjJz8vS/VzaXj81y2uHjnRve
        AKekWCCk1d/Jr2ASG885uF15Ku2Z+0I=
Date:   Thu, 25 Jun 2020 15:26:10 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Brad Campbell <lists2009@fnarfbargle.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] x86/cpu: Reinitialize IA32_FEAT_CTL MSR on BSP during
 wakeup
Message-ID: <20200625132610.GD20319@zn.tnic>
References: <20200608174134.11157-1-sean.j.christopherson@intel.com>
 <CAJZ5v0inhpW1vbYJYPqWgkekK7hKhgO_fE5JmemT+p2qh7RFaw@mail.gmail.com>
 <2a3976ac-242b-260a-ce7b-2080d8e9d0f8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2a3976ac-242b-260a-ce7b-2080d8e9d0f8@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 25, 2020 at 02:27:46PM +0200, Paolo Bonzini wrote:
> > Given the regression fix nature of this patch, is it being taken care
> > of by anyone (tip in particular) already?
> 
> I was waiting for tip to pick it up, but I can as well with an Acked-by
> (KVM is broken by the patch but there's nothing KVM specific in it).

https://git.kernel.org/tip/5d5103595e9e53048bb7e70ee2673c897ab38300

will be in -rc3, most likely.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
