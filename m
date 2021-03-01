Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE900327CA4
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 11:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbhCAKyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 05:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234843AbhCAKyg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 05:54:36 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51908C06174A;
        Mon,  1 Mar 2021 02:53:56 -0800 (PST)
Received: from zn.tnic (p200300ec2f03de00f5cdc1114f0af8a0.dip0.t-ipconnect.de [IPv6:2003:ec:2f03:de00:f5cd:c111:4f0a:f8a0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D974B1EC01B5;
        Mon,  1 Mar 2021 11:53:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1614596035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=l+z6EvWHUXr8TrpNEnVhvv8ICFE3RUbm0QatMsj9WVs=;
        b=lmIDrifrG9J9CWn1hfPJbaNUZgjQJaOhEJ2IuaLUcXDJZp91e214VJ70yBCAN1OZ2JnG7c
        ovje2ihhqKrLTYsJ53QB0CIfk304Q99vow/f9p0Yow6kkQf/Mp3xQa3RS3BlNISEmDaC6B
        f64RmSKbMwyT+wbq5TCkVkZc0+f1e5k=
Date:   Mon, 1 Mar 2021 11:53:46 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <20210301105346.GC6699@zn.tnic>
References: <cover.1614590788.git.kai.huang@intel.com>
 <bbfc8c833a62e4b55220834320829df1e17aff41.1614590788.git.kai.huang@intel.com>
 <20210301100037.GA6699@zn.tnic>
 <3fce1dd2abd42597bde7ae9496bde7b9596b2797.camel@intel.com>
 <20210301103043.GB6699@zn.tnic>
 <7603ef673997b6674f785d333a4f263c749d2cf3.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7603ef673997b6674f785d333a4f263c749d2cf3.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 01, 2021 at 11:40:02PM +1300, Kai Huang wrote:
> SGX2 means "Enclave Dynamic Memory Management", which supports dynamically
> adding/removing EPC pages, plus changing page permission, after enclave is
> initialized. So it allows enclave author to write enclave in more flexible way, and
> also utilize EPC resource more efficiently.

So how is the enclave author going to use "sgx2" in /proc/cpuinfo? Query
it to know whether it can start adding/removing EPC pages or is this
going to be used by scripts?

> Yes I can add "why" into commit message, but isn't the comment after X86_FEATURE_SGX2
> enough? I think people who are interested in SGX will know what SGX2 is and why SGX2
> is useful.

The point is, the commit message should say how this flag in
/proc/cpuinfo is going to be used - not what people interested in sgx
might and might not know.

/proc/cpuinfo is user-visible ABI - you can't add stuff to it just because.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
