Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078C960406F
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 11:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbiJSJ4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 05:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234265AbiJSJzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 05:55:45 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A18107CE2;
        Wed, 19 Oct 2022 02:31:32 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e7c5329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7c5:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 768331EC04F0;
        Wed, 19 Oct 2022 10:52:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1666169529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=WoVEor/EW/IMAStsHP6wco6fwF+6cNmnvu3IP5y5jsM=;
        b=WSfxYmrCgLe+qf16Madn3H3qBZZ6S0vUtjLyBFBO7/4CXxZd2WmWn2PA3uCHWLEt3pjijq
        n4TqjTNHgPs5T28I3AC9T8VW89N+7x+iT9d/SplAvJ6TFsboS4B/2xH3nsSAFGQc5JsWoL
        82tKG+tQZ9iL/Uf0x79krIRZZThEIm8=
Date:   Wed, 19 Oct 2022 10:52:04 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jiaxi Chen <jiaxi.chen@linux.intel.com>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, jane.malalane@citrix.com, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] x86: KVM: Enable AVX-VNNI-INT8 CPUID and expose it
 to guest
Message-ID: <Y0+6tJ7MiZWbYK5l@zn.tnic>
References: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
 <20221019084734.3590760-5-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221019084734.3590760-5-jiaxi.chen@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 19, 2022 at 04:47:32PM +0800, Jiaxi Chen wrote:
> AVX-VNNI-INT8 is a new set of instructions in the latest Intel platform
> Sierra Forest. It multiplies the individual bytes of two unsigned or
> unsigned source operands, then add and accumulate the results into the
> destination dword element size operand. This instruction allows for the
> platform to have superior AI capabilities.
> 
> The bit definition:
> CPUID.(EAX=7,ECX=1):EDX[bit 4]
> 
> This patch enables this CPUID in the kernel feature bits and expose it to
> guest OS. Since the CPUID involves a bit of EDX (EAX=7,ECX=1) which has not
> been enumerated yet, this patch adds CPUID_7_1_EDX to CPUID subleaves. At
> the same time, word 20 is newly-defined in CPU features for CPUID level

For all your commit messages:

Avoid having "This patch" or "This commit" in the commit message. It is
tautologically useless.

Also, do

$ git grep 'This patch' Documentation/process

for more details.

For this particular one, use scattered.c instead of adding a new leaf.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
