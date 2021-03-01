Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7B6327D5B
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 12:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbhCALeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 06:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233878AbhCALdq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 06:33:46 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943DCC061756;
        Mon,  1 Mar 2021 03:33:06 -0800 (PST)
Received: from zn.tnic (p200300ec2f03de00f5cdc1114f0af8a0.dip0.t-ipconnect.de [IPv6:2003:ec:2f03:de00:f5cd:c111:4f0a:f8a0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DA7131EC01E0;
        Mon,  1 Mar 2021 12:33:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1614598385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Ex2jBIPC6CpQMVpuVkJ1Y5sqWWNvI9IoAzUaBJ9gOg=;
        b=TjwtdaW+7gUkCNoK21mKvXWP6HlwRe63ik5k5y7tlq6Y/+4mDuiRbe8uywxAePqGLfbb0F
        AjhsVQCACH0LlLNeTu68pwMqXfXUrLTXj9fUWa/OGPCf5XwJbTX8DQApnlwyF74NjeoiD0
        WKNcncbvhwAB2XgTGrBHnXAx+sPUBAc=
Date:   Mon, 1 Mar 2021 12:32:57 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <20210301113257.GD6699@zn.tnic>
References: <cover.1614590788.git.kai.huang@intel.com>
 <bbfc8c833a62e4b55220834320829df1e17aff41.1614590788.git.kai.huang@intel.com>
 <20210301100037.GA6699@zn.tnic>
 <3fce1dd2abd42597bde7ae9496bde7b9596b2797.camel@intel.com>
 <20210301103043.GB6699@zn.tnic>
 <7603ef673997b6674f785d333a4f263c749d2cf3.camel@intel.com>
 <20210301105346.GC6699@zn.tnic>
 <e509c6c1e3644861edafb18e4045b813f9f344b3.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e509c6c1e3644861edafb18e4045b813f9f344b3.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 02, 2021 at 12:28:27AM +1300, Kai Huang wrote:
> I think some script can utilize /proc/cpuinfo. For instance, admin can have
> automation tool/script to deploy enclave (with sgx2) apps, and that script can check
> whether platform supports sgx2 or not, before it can deploy those enclave apps. Or
> enclave author may just want to check /proc/cpuinfo to know whether the machine can
> be used for testing sgx2 enclave or not.

This doesn't sound like a concrete use of this. So you can hide it
initially with "" until you guys have a use case. Exposing it later is
always easy vs exposing it now and then not being able to change it
anymore.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
