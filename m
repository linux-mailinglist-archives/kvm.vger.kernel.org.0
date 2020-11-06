Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704E22A8B86
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 01:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732763AbgKFAjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 19:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731965AbgKFAjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 19:39:49 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C064C0613CF;
        Thu,  5 Nov 2020 16:39:49 -0800 (PST)
Received: from zn.tnic (p200300ec2f0ee50005b6d9c42d515134.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:e500:5b6:d9c4:2d51:5134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7EFA51EC03C1;
        Fri,  6 Nov 2020 01:39:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1604623186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=0szqA5V2pWQy1oA4esAc8Cd/+uPXvX7U+GvP5QW9eG0=;
        b=oy5kilDAaqW8D3fJeTgJuW3QylXyiVe5HYjaX0XPPDCel+XUQwGXzH6wjm1AGlYfxIs5no
        r4thFzHBCwhuHfpUfJa8XlGpAJRL7uq6QBovCno2DKVA2DD8a7HNrXRmIgMXeulu5FcMn0
        0235BOZ4bTQdtucU9xbEAGyFarjyBdQ=
Date:   Fri, 6 Nov 2020 01:39:32 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Juergen Gross <jgross@suse.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Mike Stunes <mstunes@vmware.com>,
        Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Cfir Cohen <cfir@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        virtualization@lists.linux-foundation.org,
        Martin Radev <martin.b.radev@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, hpa@zytor.com,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH v7 01/72] KVM: SVM: nested: Don't allocate VMCB
 structures on stack
Message-ID: <20201106003932.GQ25636@zn.tnic>
References: <20200907131613.12703-1-joro@8bytes.org>
 <20200907131613.12703-2-joro@8bytes.org>
 <160459347763.31546.3911053208379939674@vm0>
 <20201105163812.GE25636@zn.tnic>
 <20201106003153.wrr7zvjjl3hl2pec@vm0>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201106003153.wrr7zvjjl3hl2pec@vm0>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 05, 2020 at 06:31:53PM -0600, Michael Roth wrote:
> I can confirm that patch fixes the issue. It is indeed a 5.9.1 tree, but
> looks like the SEV-ES patches didn't go in until v5.10-rc1

Yes, they went into 5.10-rc1 during the merge window.

> (this tree had a backport of them), so stable trees shouldn't be
> affected.

Ah, ok, that makes sense.

Thanks for checking!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
