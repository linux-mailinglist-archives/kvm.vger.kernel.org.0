Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB4644CCF5
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 23:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbhKJWpW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 17:45:22 -0500
Received: from mail.skyhub.de ([5.9.137.197]:47542 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233583AbhKJWpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 17:45:22 -0500
Received: from zn.tnic (p200300ec2f111e005f5dc221d5c600aa.dip0.t-ipconnect.de [IPv6:2003:ec:2f11:1e00:5f5d:c221:d5c6:aa])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EAEF41EC0529;
        Wed, 10 Nov 2021 23:42:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1636584142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=D2rzfv73+DsKiXnmNgGMbn0C1HhuLO2H6J5kT58nhiA=;
        b=oY8s4xgeCWNqd29BBpixitniBiaoq4DfKnXPEBKB4NaXEd/1MqGm0jgZPrUy6OynjFUYed
        YiJjTR3PWEfLqsUEnz6hamMPBj/qughCKDhnHE7KT8BG3E5n209JVY/mrpQ6lBluISCavK
        b+h22Ryw1HF43bFiN2ih5Yrs7ueQX9E=
Date:   Wed, 10 Nov 2021 23:42:14 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@linux.ibm.com" <tobin@linux.ibm.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>
Subject: Re: [PATCH v6 1/5] x86/kvm: Add AMD SEV specific Hypercall3
Message-ID: <YYxKxvaJCktwugHx@zn.tnic>
References: <YUnxa2gy4DzEI2uY@zn.tnic>
 <YUoDJxfNZgNjY8zh@google.com>
 <YUr5gCgNe7tT0U/+@zn.tnic>
 <20210922121008.GA18744@ashkalra_ubuntu_server>
 <YUs1ejsDB4W4wKGF@zn.tnic>
 <CABayD+eFeu1mWG-UGXC0QZuYu68B9wJNWJhjUo=HHgc_jsfBag@mail.gmail.com>
 <2213EC9B-E3EC-4F23-BC1A-B11DF6288EE3@amd.com>
 <YVRRsEgjID4CbbRS@zn.tnic>
 <CABayD+dM8OafXkw6_Af17uvthnNG+k3majitc3uGwsm+Lr8DAQ@mail.gmail.com>
 <6f069301-f0c7-4eae-943b-3746a7350260@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6f069301-f0c7-4eae-943b-3746a7350260@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 10, 2021 at 11:11:41PM +0100, Paolo Bonzini wrote:
> can I just merge these patches via the KVM tree, since we're close to the
> end of the merge window and the cc_platform_has series has been merged?

Yes, please. All the pending tip stuff from the last round is already
upstream.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
