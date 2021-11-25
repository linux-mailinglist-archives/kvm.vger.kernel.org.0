Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7960B45E137
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 20:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356795AbhKYUA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 15:00:29 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54292 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhKYT62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 14:58:28 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637870116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hSMowqhqzhm6IutQ/pfqymHz8EouPjwX/7DhgDwhw+A=;
        b=dOh0OK4juYj+bNo3uMlN4kTYNaWfz4LgLBB9tK74Z8CDGMty7xPey7hE0YeLI7t/DRcC3x
        cH7yfaf3qv76hgdYFxTsAv77Kk6IcOObjOaBrmodT1WZGjzP5tv/FS+I3J3+WYVnfn2DJZ
        McDaBGgRzbuo+c0zyBEt7QfRbcItYRwinb0bUHP+Wsd/PratbW/+0vF4RDSq/n9rzQlKAx
        iIDoayOrNGK+ed6RYEdx7u41hQb5sjVWzLDJ9/zTTXmDfbw1XZKIa+z2fkNYYHqd2oqnJb
        Jg/uq5SU0qv1I0EnipuI59O6PApZFTk/ycYvkwUE/r7d3HEt1AhUwzIK8kBiMA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637870116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hSMowqhqzhm6IutQ/pfqymHz8EouPjwX/7DhgDwhw+A=;
        b=Ql+VbgtR+/I72NyJMGgVKTZLTOjMGhdNBRtccauUMjyXhVdjqUPRldDHspj5I5QQI7Jkig
        /gjrnRoVDtEufRCQ==
To:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v3 30/59] KVM: x86: Add guest_supported_xss placholder
In-Reply-To: <79e3a44d6b7852b255520ef57b59ce1324695630.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <79e3a44d6b7852b255520ef57b59ce1324695630.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 20:55:15 +0100
Message-ID: <874k80j9i4.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:

> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Add a per-vcpu placeholder for the support XSS of the guest so that the
> TDX configuration code doesn't need to hack in manual computation of the
> supported XSS.  KVM XSS enabling is currently being upstreamed, i.e.
> guest_supported_xss will no longer be a placeholder by the time TDX is
> ready for upstreaming (hopefully).

Yes, hope dies last... Definitely technical useful information for a
changelog. There is a reason why notes should go below the --- separator
line.

Thanks,

        tglx

