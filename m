Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C1D66A253
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 19:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjAMSpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 13:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjAMSpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 13:45:45 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A4D209;
        Fri, 13 Jan 2023 10:45:43 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7E2DC1EC04C1;
        Fri, 13 Jan 2023 19:45:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1673635542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=sc+QG3doHwqi0KguHc47jtnXuzD4N0xuhyE01g5Z5bg=;
        b=KkTKgtpXF0EoNPZdUlHiGJscFtirH/VYZkaDo+EFyCM016NeLitJyZPiqAZB+9dCR7thC+
        0cKvCiL13pgYtqZlUpt2N0IQmyUnd+Mfg7Wq7bnAHSo6NKJxjfwN1S/dxzuDKC/6rkacC9
        zo62ADSjb3WSAJtj+GuSNEB9wSoaC7E=
Date:   Fri, 13 Jan 2023 19:45:42 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com
Subject: Re: [PATCH RFC v7 04/64] KVM: x86: Add 'fault_is_private' x86 op
Message-ID: <Y8Gm1jrupT5Kuk+t@zn.tnic>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-5-michael.roth@amd.com>
 <Y628y6hQK38+IAev@zn.tnic>
 <20230105024256.ptujtjgzcdmpakoa@amd.com>
 <Y8Fr/F1RV0B8CHq5@zn.tnic>
 <Y8F9a2pmh13aIQZL@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y8F9a2pmh13aIQZL@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 13, 2023 at 03:48:59PM +0000, Sean Christopherson wrote:
> Ya.  Don't spend too much time trying to make this look super pretty though, there
> are subtle bugs inherited from the base UPM series that need to be sorted out and
> will impact this code.

Yeah, I'm simply trying to find my way around the code and no better way than
reviewing it. But thanks for the heads up.

> I'll circle back to this too when I give this series (and TDX) a proper look,
> there's got too be a better way to handle this.

Good.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
