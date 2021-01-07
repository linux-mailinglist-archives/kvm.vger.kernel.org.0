Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7902ECA9F
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 07:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbhAGGmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 01:42:04 -0500
Received: from mail.skyhub.de ([5.9.137.197]:55376 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbhAGGmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 01:42:04 -0500
Received: from zn.tnic (p200300ec2f0e340040aa7c2c4e2416a1.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:3400:40aa:7c2c:4e24:16a1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2E9161EC0505;
        Thu,  7 Jan 2021 07:41:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1610001683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=XB4JFyczu3lcx+8DZsoZDDq3Pa2F9TJKHzaTfdAUuJ8=;
        b=JNzzUQ9YudD5b9FeXAs+q0vSDKWGhITM+LNk+bEWwRiluFvIv3XNFDu2s4xxmRH0tGuWN0
        w9K2WlMbB7pJMNmaygYc29bo0CfODGiMaJPCMBVHOWst1ggAL1t6MjYdZrDTFdu+f3JYZ2
        GoxE9iKybtoHK9f4LzVz7+BL6pBwdJs=
Date:   Thu, 7 Jan 2021 07:41:25 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <20210107064125.GB14697@zn.tnic>
References: <cover.1609890536.git.kai.huang@intel.com>
 <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
 <20210106221527.GB24607@zn.tnic>
 <20210107120946.ef5bae4961d0be91eff56d6b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210107120946.ef5bae4961d0be91eff56d6b@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 07, 2021 at 12:09:46PM +1300, Kai Huang wrote:
> There's no urgent request to support them for now (and given basic SGX
> virtualization is not in upstream), but I don't know whether they need to be
> supported in the future.

If that is the case, then wasting a whole leaf for two bits doesn't make
too much sense. And it looks like the kvm reverse lookup can be taught
to deal with composing that leaf dynamically when needed instead.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
