Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFE224D06F
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 10:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgHUIQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 04:16:43 -0400
Received: from mail.skyhub.de ([5.9.137.197]:60320 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgHUIQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 04:16:42 -0400
Received: from zn.tnic (p200300ec2f0eda00b4e1d8975031aaf0.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:da00:b4e1:d897:5031:aaf0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 149D81EC02B9;
        Fri, 21 Aug 2020 10:16:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1597997797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=kD3hyIqaY4rvqARoZXbDQgRT0FQcAV1g3bodMGGGRgI=;
        b=QteLqZZnrFR+uLNgDqcLl10Ws5SanoiYCyEKKN8xuVymJs+qot81ZM7mUHiuSBxHFkkAvN
        TkYIJ+ItbEUyyuk/LeuXu6YqdYfSL3EoQmYB5nQrIpoEsjaigm376cfFGrXi60+2RIvavu
        A7WUkPygQPzvMURb7ApWMuAUPphPm3I=
Date:   Fri, 21 Aug 2020 10:16:33 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] x86/entry/64: Disallow RDPID in paranoid entry if KVM is
 enabled
Message-ID: <20200821081633.GD12181@zn.tnic>
References: <20200821025050.32573-1-sean.j.christopherson@intel.com>
 <20200821074743.GB12181@zn.tnic>
 <3eb94913-662d-5423-21b1-eaf75635142a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3eb94913-662d-5423-21b1-eaf75635142a@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 21, 2020 at 10:09:01AM +0200, Paolo Bonzini wrote:
> One more MSR *is* a big deal: KVM's vmentry+vmexit cost is around 1000
> cycles, adding 100 clock cycles for 2 WRMSRs is a 10% increase.

The kernel uses TSC_AUX so we can't reserve it to KVM either.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
