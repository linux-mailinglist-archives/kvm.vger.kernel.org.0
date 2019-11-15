Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA757FE1A8
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 16:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfKOPjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 10:39:22 -0500
Received: from mail.skyhub.de ([5.9.137.197]:34036 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727443AbfKOPjW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 10:39:22 -0500
Received: from zn.tnic (p200300EC2F0CC30001F0870692D99427.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:c300:1f0:8706:92d9:9427])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CD9D01EC0D06;
        Fri, 15 Nov 2019 16:39:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1573832361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=K0EJnNjdm/SoccIE6QZhZj/UPZX4QJ55VyQTfT34pgY=;
        b=a4WYlR9LLQyOiDiXqYaq+EY+ULhIUXXBrobawZWM5pxrzIrfw88Bnwd6K3x002a7BneV2X
        +FM5xoA7XBR/Ziv0736RARpD7vtOSfaTLROb0I4Ia0JzHQxvQzOT9SFn5GaSPuLowqiZKT
        BGgZr1EJ6DsFBI9NzRzlXDzUyI7oFVM=
Date:   Fri, 15 Nov 2019 16:39:13 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 06/16] x86/cpu: Clear VMX feature flag if VMX is not
 fully enabled
Message-ID: <20191115153913.GL18929@zn.tnic>
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
 <20191022000836.1907-1-sean.j.christopherson@intel.com>
 <20191025163858.GF6483@zn.tnic>
 <20191114183238.GH24045@linux.intel.com>
 <5aacaba0-76e2-9824-ebd4-fa510bce712d@redhat.com>
 <20191115103434.GH18929@zn.tnic>
 <20191115153416.GA6055@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191115153416.GA6055@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 15, 2019 at 07:34:16AM -0800, Sean Christopherson wrote:
> On Fri, Nov 15, 2019 at 11:34:34AM +0100, Borislav Petkov wrote:
> > Btw, Sean, are you sending a new version of this ontop of latest
> > tip/master or linux-next or so? I'd like to look at the rest of the bits
> > in detail.
> 
> Sure, I'll rebase and get a new version sent out today.

Thanks!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
