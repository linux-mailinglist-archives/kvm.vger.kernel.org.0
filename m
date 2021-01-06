Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F2E2EC613
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 23:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbhAFWQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 17:16:13 -0500
Received: from mail.skyhub.de ([5.9.137.197]:36148 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbhAFWQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 17:16:13 -0500
Received: from zn.tnic (p200300ec2f0969000c9608407819d21e.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:6900:c96:840:7819:d21e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E7BE61EC04EE;
        Wed,  6 Jan 2021 23:15:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1609971331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=W0U8usJzih0juiazb3M3hkDhk8oDReLRTV2GpTPwlqY=;
        b=mSjUdvtEqVO0xwIdI15W6h3jM7e1+VdOfIf85LXiNceOiJcJ4UO9Dg5151nFCshAcpU2co
        j+DFn1PshSMtiqKL90n1yA5YHjCnCKtrdetH0iHb+gNmXcau2HUQn5syHCPJPy13vd/8H2
        tahYneKaA6BZtHv0sn9TE+x5RIiaICs=
Date:   Wed, 6 Jan 2021 23:15:27 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <20210106221527.GB24607@zn.tnic>
References: <cover.1609890536.git.kai.huang@intel.com>
 <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 06, 2021 at 02:55:21PM +1300, Kai Huang wrote:
> +/* Intel-defined SGX features, CPUID level 0x00000012:0 (EAX), word 19 */
> +#define X86_FEATURE_SGX1		(19*32+ 0) /* SGX1 leaf functions */
> +#define X86_FEATURE_SGX2		(19*32+ 1) /* SGX2 leaf functions */

Is anything else from that leaf going to be added later? Bit 5 is
"supports ENCLV instruction leaves", 6 is ENCLS insn leaves... are those
going to be used in the kernel too eventually?

Rest of them is reserved in the SDM which probably means internal only
for now.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
