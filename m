Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3FB2FBC6E
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 17:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730728AbhASQVn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 11:21:43 -0500
Received: from mail.skyhub.de ([5.9.137.197]:41090 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729250AbhASQUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 11:20:39 -0500
Received: from zn.tnic (p200300ec2f0bca005ed5ab9a356b3c50.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:ca00:5ed5:ab9a:356b:3c50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8449E1EC0616;
        Tue, 19 Jan 2021 17:19:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1611073171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=g91v3AormRjgNHaLNy5s628V6v7OFuRy7Wn9OU4Id3Y=;
        b=nIwueg5gv38y6ks4MXfhLuqmbaCsZ5EsS0CIkWP8uy8WL5citig5d+R8ORjFZ1K3PfCAIM
        3sKutPylJKUjQMih++LYZoqEpK84gMzKDju3HBGWSTMk7NAf2JmmoI7OcyADYph0BKu40E
        DKhyTYdX0+rbtFne0RuTAt3KajTWBf0=
Date:   Tue, 19 Jan 2021 17:19:25 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 01/26] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-ID: <20210119161925.GN27433@zn.tnic>
References: <cover.1610935432.git.kai.huang@intel.com>
 <87385f646120a3b5b34dc20480dbce77b8005acd.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87385f646120a3b5b34dc20480dbce77b8005acd.1610935432.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 04:26:49PM +1300, Kai Huang wrote:
> diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
> index 3b1b01f2b248..7937a315f8cf 100644
> --- a/arch/x86/kernel/cpu/feat_ctl.c
> +++ b/arch/x86/kernel/cpu/feat_ctl.c
> @@ -96,7 +96,6 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
>  static void clear_sgx_caps(void)
>  {
>  	setup_clear_cpu_cap(X86_FEATURE_SGX);
> -	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);

Why is that line being removed here?

Shouldn't this add SGX1 and SGX2 here instead as this function is
supposed to, well, *clear* sgx caps on feat_ctl setup failures or
"nosgx" cmdline?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
