Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF7A26A1DD
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 11:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgIOJPN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 05:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgIOJPF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 05:15:05 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEA3C06174A;
        Tue, 15 Sep 2020 02:15:05 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0e42006449c187a2f3906a.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:4200:6449:c187:a2f3:906a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E63A61EC058B;
        Tue, 15 Sep 2020 11:15:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600161304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=FvaJmj45+hZz+9GgbNE3rwJ+H3JIoq7yGSJBBmV2IRo=;
        b=GkbqEKalSpf/Xzq/JASeaeWNQEP/8z0+XBeu/z41zpb/oajBRyQPsnmV9nPp5Cn3y/yHiq
        1wgTdXQD4bg9PC43lr17FKwI/WIpxk9jAXzkVJfgBCSaFflk0j7N85rv56YGokZtzHW34f
        Ol0BJNYiqpqVNIoiJogIv5ktGPF7RGk=
Date:   Tue, 15 Sep 2020 11:15:02 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SVM: nSVM: fix resource leak on error path
Message-ID: <20200915091502.GE14436@zn.tnic>
References: <20200914194557.10158-1-alex.dewar90@gmail.com>
 <922e825c090892f22d40a469fef229d62f40af5e.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <922e825c090892f22d40a469fef229d62f40af5e.camel@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 12:07:25PM +0300, Maxim Levitsky wrote:
> I think that this patch is based on unmerged patch, since I don't see
> any memory allocation in nested_svm_vmrun_msrpm, nor out_free label.
> in nether kvm/master, kvm/queue nor in upstream/master

Paolo and I need to figure out first how to share the SEV-ES enablement
work and the other patches touching that file and then pile more fixes
ontop.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
