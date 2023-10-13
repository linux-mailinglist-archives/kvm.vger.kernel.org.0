Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8AC7C8848
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 17:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbjJMPGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 11:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjJMPGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 11:06:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C80195;
        Fri, 13 Oct 2023 08:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697209561; x=1728745561;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=I9ejgnkc4T1U17W9HiaslETujXXaw9iMHZTTGR4wj6g=;
  b=CpGBRA+/rCwc7WHWKUo5yeSoNPvXA7dAhVR/paN3eamEwe9rqz4owRZm
   FgzkUbNT9Poc1pCkxfAhl0287uQXeu7vjdB2y+X0Lj2/YJXnWuMym/3z4
   Xd8Hrq9NbJuLlsGNpNPRbb/sy9I/6SiOlVyFLwLwQ6YW/AM1PZrnlWiOe
   GXN/N4P6flvLFocaWa1tz+VEZ6zz5Xz2qCor4Cw/6tRp02vT2pBAO6XN8
   zMspGX1dobkQRFyIVV8dV4LdNQt1OW5Ha8A5juFGG0eKY703MEGYWhhxr
   xlihfYOBmtbU1AT2DAV/s5S7TBTT/2fGgEAB+tA3RbwhSn5wP16kAcXEe
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10862"; a="375552697"
X-IronPort-AV: E=Sophos;i="6.03,222,1694761200"; 
   d="scan'208";a="375552697"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 08:06:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10862"; a="704676500"
X-IronPort-AV: E=Sophos;i="6.03,222,1694761200"; 
   d="scan'208";a="704676500"
Received: from marinjul-mobl.amr.corp.intel.com (HELO [10.255.231.41]) ([10.255.231.41])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 08:06:00 -0700
Content-Type: multipart/mixed; boundary="------------4QAAwMnZ7myaM0IpTAN94Ja9"
Message-ID: <532fd5c3-dddb-4503-9b81-31c3d07a7119@intel.com>
Date:   Fri, 13 Oct 2023 08:05:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/12] x86/mce: Fix hw MCE injection feature detection
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
        Borislav Petkov <bp@suse.de>
References: <cover.1696926843.git.isaku.yamahata@intel.com>
 <23c6fa20777498bccd486aedc435eef9af174748.1696926843.git.isaku.yamahata@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <23c6fa20777498bccd486aedc435eef9af174748.1696926843.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a multi-part message in MIME format.
--------------4QAAwMnZ7myaM0IpTAN94Ja9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Isaku, when you report a bug, it would be great to include the folks who
authored and worked on the original patch that introduced the bug.  I've
gone ahead and done that for you here.

On 10/10/23 01:35, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> When initializing x86 MCE injection framework, it checks if hardware mce
> injection is available or not.  When it's not available on AMD, set the
> boolean variable to false to not use it.  The variable is on by default and
> the feature is AMD specific based on the code.
> 
> Because the variable is default on, it is true on Intel platform (probably
> on other non-AMD x86 platform).  It results in unchecked msr access of
> MSR_K7_HWCR=0xc0010015 when injecting MCE on Intel platform.  (Probably on
> other x86 platform.)
> 
> Make the variable of by default, and set the variable on when the hardware
> feature is usable.

Gah, I'm finding that changelog impenetrable.  Here's what's missing:

  * The entirety of check_hw_inj_possible() is for AMD hardware:
    X86_FEATURE_SMCA, the MSRs, hw_injection_possible, everything.
  * Only AMD systems with SMCA support hardware error injection
    (anything other than "echo sw > /sys/kernel/debug/mce-inject/flags")
  * That AMD-only restriction is enforced by 'hw_injection_possible'
  * 'hw_injection_possible' is true by default and only set to false in
    check_hw_inj_possible() ... the AMD-only code

The end result is that everyone except SMCA-enabled AMD systems (Intel
included) leaves hw_injection_possible=true.  They are free to try and
inject hardware errors.  If they do, they'll get errors when writing to
the MSRs.

To fix this, make disable hw_injection_possible by default.  Only enable
it on SMCA hardware that actually succeeds in ... whatever:

                wrmsrl_safe(mca_msr_reg(bank, MCA_STATUS), status);
                rdmsrl_safe(mca_msr_reg(bank, MCA_STATUS), &status);

is doing.

... and don't do it at the top of the function.  Why bother setting it
to true only to disable it a moment later?

Do something like the following instead.
--------------4QAAwMnZ7myaM0IpTAN94Ja9
Content-Type: text/x-patch; charset=UTF-8; name="amdmce.patch"
Content-Disposition: attachment; filename="amdmce.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvbWNlL2luamVjdC5jIGIvYXJjaC94
ODYva2VybmVsL2NwdS9tY2UvaW5qZWN0LmMKaW5kZXggNGQ4ZDRiY2Y5MTVkLi4wMWVlODg2
ZDg1NDAgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvbWNlL2luamVjdC5jCisr
KyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvbWNlL2luamVjdC5jCkBAIC0zMyw3ICszMyw3IEBA
CiAKICNpbmNsdWRlICJpbnRlcm5hbC5oIgogCi1zdGF0aWMgYm9vbCBod19pbmplY3Rpb25f
cG9zc2libGUgPSB0cnVlOworc3RhdGljIGJvb2wgaHdfaW5qZWN0aW9uX3Bvc3NpYmxlOwog
CiAvKgogICogQ29sbGVjdCBhbGwgdGhlIE1DaV9YWFggc2V0dGluZ3MKQEAgLTc0OCw5ICs3
NDgsMTAgQEAgc3RhdGljIHZvaWQgY2hlY2tfaHdfaW5qX3Bvc3NpYmxlKHZvaWQpCiAJCXJk
bXNybF9zYWZlKG1jYV9tc3JfcmVnKGJhbmssIE1DQV9TVEFUVVMpLCAmc3RhdHVzKTsKIAog
CQlpZiAoIXN0YXR1cykgewotCQkJaHdfaW5qZWN0aW9uX3Bvc3NpYmxlID0gZmFsc2U7CiAJ
CQlwcl93YXJuKCJQbGF0Zm9ybSBkb2VzIG5vdCBhbGxvdyAqaGFyZHdhcmUqIGVycm9yIGlu
amVjdGlvbi4iCiAJCQkJIlRyeSB1c2luZyBBUEVJIEVJTkogaW5zdGVhZC5cbiIpOworCQl9
IGVsc2UgeworCQkJaHdfaW5qZWN0aW9uX3Bvc3NpYmxlID0gdHJ1ZTsKIAkJfQogCiAJCXRv
Z2dsZV9od19tY2VfaW5qZWN0KGNwdSwgZmFsc2UpOwo=

--------------4QAAwMnZ7myaM0IpTAN94Ja9--
