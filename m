Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33AD8107559
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 17:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfKVQCj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 11:02:39 -0500
Received: from mail.skyhub.de ([5.9.137.197]:48650 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbfKVQCi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 11:02:38 -0500
Received: from zn.tnic (p200300EC2F0E9700617A286416B6740E.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:9700:617a:2864:16b6:740e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4B35C1EC0D02;
        Fri, 22 Nov 2019 17:02:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1574438557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=h4hPZVDGhlJ/nVahWCNAYi0rixY8BxMyl5rH5OiLiT8=;
        b=klUjxbevxiSgkfiTyTD/bZ/K+Cywo2jaMwkNJWrueBGvXxKeqgxub19AJk5N/Ihhiw0Ooi
        hqGIquKBvf7lD2VmnVaMjbQ5HZc9itIwfYBeiHxEdNdXIX1sH9CtPA6GfNP0Rt2EF81P7w
        X6BxRgSCuiHiOIuL63ufRfGaMzgzlxU=
Date:   Fri, 22 Nov 2019 17:02:30 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>,
        Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-edac@vger.kernel.org,
        "linux-kselftest@vger.kernel.org, Jarkko Sakkinen" 
        <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3 09/19] x86/cpu: Clear VMX feature flag if VMX is not
 fully enabled
Message-ID: <20191122160229.GI6289@zn.tnic>
References: <20191119031240.7779-1-sean.j.christopherson@intel.com>
 <20191119031240.7779-10-sean.j.christopherson@intel.com>
 <20191121162452.GJ6540@zn.tnic>
 <20191121210714.GB16617@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191121210714.GB16617@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 21, 2019 at 01:07:14PM -0800, Sean Christopherson wrote:
> I'm also ok dropping it altogether, though from a KVM developer
> perspective I wouldn't mind the extra sanity check :-)

Right, I think we should keep it in the bag and only take it out when it
really happens. Because if we really wanna be overly cautious in every
possible case where stuff may fail, we won't see the actual code from
all the error handling. :-)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
