Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25406327DC0
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 13:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbhCAL7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 06:59:47 -0500
Received: from mail.skyhub.de ([5.9.137.197]:36774 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234065AbhCAL7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 06:59:44 -0500
Received: from zn.tnic (p200300ec2f03de007faa2800bd33f191.dip0.t-ipconnect.de [IPv6:2003:ec:2f03:de00:7faa:2800:bd33:f191])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CA8801EC01E0;
        Mon,  1 Mar 2021 12:59:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1614599942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=9+LgblyYfLIgXAyx7H8SJ+o5wKr3vfOos7K1dku8iXc=;
        b=I0xGESE8bQh1HBVM+sjdOk72OIigwaXodn2wqO6ZpWSvBr6RdXwUeJ/IgAllqVSfiI9onS
        +hZ297OkqJjNqfnE7vvpBBDfn+zyqPqREFdQcD/5zoCdq/LUgjzfiEg2MTV2EgFKdz2OVT
        tH5C5z9A8+17jIIRPiUyJMWTbbNX0BI=
Date:   Mon, 1 Mar 2021 12:58:54 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <20210301115854.GE6699@zn.tnic>
References: <cover.1614590788.git.kai.huang@intel.com>
 <bbfc8c833a62e4b55220834320829df1e17aff41.1614590788.git.kai.huang@intel.com>
 <20210301100037.GA6699@zn.tnic>
 <3fce1dd2abd42597bde7ae9496bde7b9596b2797.camel@intel.com>
 <20210301103043.GB6699@zn.tnic>
 <7603ef673997b6674f785d333a4f263c749d2cf3.camel@intel.com>
 <20210301105346.GC6699@zn.tnic>
 <e509c6c1e3644861edafb18e4045b813f9f344b3.camel@intel.com>
 <20210301113257.GD6699@zn.tnic>
 <0adc41774945bf9d6e6a72a93b83c80aa8c59544.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0adc41774945bf9d6e6a72a93b83c80aa8c59544.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 02, 2021 at 12:43:06AM +1300, Kai Huang wrote:
> To confirm, if we suppress both "sgx1" and "sgx2" in /proc/cpuinfo, we
> don't need to add "why to suppress" in commit message, right?

You should always explain in a patch why you're doing the change. So
that a reviewer knows. And then people in the future can follow why
you've made that decision. Always.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
