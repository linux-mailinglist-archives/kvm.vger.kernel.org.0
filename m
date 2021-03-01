Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF49327C30
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 11:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbhCAKbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 05:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234472AbhCAKb2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 05:31:28 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4F7C06174A;
        Mon,  1 Mar 2021 02:30:47 -0800 (PST)
Received: from zn.tnic (p200300ec2f03de00f5cdc1114f0af8a0.dip0.t-ipconnect.de [IPv6:2003:ec:2f03:de00:f5cd:c111:4f0a:f8a0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6389D1EC01B5;
        Mon,  1 Mar 2021 11:30:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1614594646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=AmZSRL81gw/hv9fycuhQ8SlStNnw3X6voozuQ3yg7Bc=;
        b=mhu2N7nhOQo7ia3+7+31kd6Z97+jsuL04dmdMWuy6qWhiUqu0EFFKb5g3DsAba270ZZvWy
        vO49simRXEZD9ZWLUX+h1qLlwJLtU6GUGbbKunjyOP4Jgc2OVakEBncTKlgY6JWsjTzIwq
        XZb8YpV+B+7H7QL0iCpAyZ3/qBB56/k=
Date:   Mon, 1 Mar 2021 11:30:43 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <20210301103043.GB6699@zn.tnic>
References: <cover.1614590788.git.kai.huang@intel.com>
 <bbfc8c833a62e4b55220834320829df1e17aff41.1614590788.git.kai.huang@intel.com>
 <20210301100037.GA6699@zn.tnic>
 <3fce1dd2abd42597bde7ae9496bde7b9596b2797.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3fce1dd2abd42597bde7ae9496bde7b9596b2797.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 01, 2021 at 11:19:15PM +1300, Kai Huang wrote:
> "sgx2" is useful because it adds additional functionality.

Useful for what?

People have got to start explaining "why" something is useful and put
that "why" in the commit message.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
