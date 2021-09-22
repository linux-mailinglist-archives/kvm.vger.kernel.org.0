Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFB2414B29
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 15:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbhIVNzo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 09:55:44 -0400
Received: from mail.skyhub.de ([5.9.137.197]:41376 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233479AbhIVNzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 09:55:44 -0400
Received: from zn.tnic (p200300ec2f0efa00329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:fa00:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6F8851EC0537;
        Wed, 22 Sep 2021 15:54:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632318848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=AiNJ05ptDQZvBWlLVMY8+uuVH6308VUGaXejpuvkXds=;
        b=G3aT8PSdyMqfAojp8ManX9HaECqAU15N6iJXV2Vg/CpSgwC7gfx4j5B8F5eR5jeJ/NRoJg
        PQTJj7yRJ2GDrAjjQfW9Sf40asscQ+YiYYq8tK8SQCkVnwft0UC34hVVPYZOuoMC2dpMWW
        Z7AZPT6WKxZVXa+/4Nesnrc1Gy/Nzdg=
Date:   Wed, 22 Sep 2021 15:54:02 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Steve Rutherford <srutherford@google.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        brijesh.singh@amd.com, dovmurik@linux.ibm.com, tobin@linux.ibm.com,
        jejb@linux.ibm.com, dgilbert@redhat.com
Subject: Re: [PATCH v6 1/5] x86/kvm: Add AMD SEV specific Hypercall3
Message-ID: <YUs1ejsDB4W4wKGF@zn.tnic>
References: <cover.1629726117.git.ashish.kalra@amd.com>
 <6fd25c749205dd0b1eb492c60d41b124760cc6ae.1629726117.git.ashish.kalra@amd.com>
 <CABayD+fnZ+Ho4qoUjB6YfWW+tFGUuftpsVBF3d=-kcU0-CEu0g@mail.gmail.com>
 <YUixqL+SRVaVNF07@google.com>
 <20210921095838.GA17357@ashkalra_ubuntu_server>
 <YUnjEU+1icuihmbR@google.com>
 <YUnxa2gy4DzEI2uY@zn.tnic>
 <YUoDJxfNZgNjY8zh@google.com>
 <YUr5gCgNe7tT0U/+@zn.tnic>
 <20210922121008.GA18744@ashkalra_ubuntu_server>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210922121008.GA18744@ashkalra_ubuntu_server>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 12:10:08PM +0000, Ashish Kalra wrote:
> Then isn't it cleaner to simply do it via the paravirt_ops interface,
> i.e, pv_ops.mmu.notify_page_enc_status_changed() where the callback
> is only set when SEV and live migration feature are supported and
> invoked through early_set_memory_decrypted()/encrypted().
> 
> Another memory encryption platform can set it's callback accordingly.

Yeah, that sounds even cleaner to me.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
