Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F2A65DB01
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 18:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbjADRNv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 12:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjADRNu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 12:13:50 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8CF6165
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 09:13:49 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id c6so3289233pls.4
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 09:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=73Eln868VcK/zvFu0uZkd/A2VFpfqwYRSaKsskcT6as=;
        b=kWbOLR/QUF3GoT2ZCaoFdUPy5T8Ek7121DYfuKdWq8hxW5xI3PRiCUYu/JBWLqsUEl
         9WN4azlBSFIyl0V3SVz46wVDFdpL6R5DshE2SalTxtkIgzuAucrMyz0KPmxuQs1BI09o
         y4ccdJEsWY3wCduQz2mnziNW8bC0mTZsSCJn0AC0Xxxptwc0STiDcZqaeLKpoquQkOfG
         YSNHh7Gw80KjLlGyWNtXF50HcTd7GcgON6BsVJsfAeU3Tz+kSi6wzS3bvO73mNoNx6P4
         LXVH0A10H3ykSNszsl2xFuc/AMruXbOJ50dZLGk7+WghcTIlacuAbN1x2YC6cO9LXBNr
         fTxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=73Eln868VcK/zvFu0uZkd/A2VFpfqwYRSaKsskcT6as=;
        b=6hRqhxkTjPk/v9FAO6OaZvoFgDX8M7ahw8P3G4RRp/SPrih1/+ygfomgLDATJw+wLL
         oh7B7LDql9UI7IQg4/NRF9aVTgwt0vS43scts3sRbuh0Xb55abINyBr5lPVjr667flIz
         +VfK6gG2FFVG6BL2lvvIJ+tEtfgK5ImK5yv0jCNQpmH9iybvOBH2pUS0rJwkCFIbx7YM
         QZaWFsF6wE0K4gxZrcM/hgZ9ld3r2ETAzhuInFOs2tKtltDmsrkLQE9GV1SE5Qd/PvLG
         cEFcYmoGARtgdJY5aoVoVDVAsBFwoEH3ZKyzKhpG5/UIyNli3DwNoCptyOJ++GRiViC9
         vyIQ==
X-Gm-Message-State: AFqh2kqx9+kAspwULeSSD1dTZfrwygxl6it9CZ5qEm9cT+crMuw1mfAh
        h9YoP5Ffmg9HchbdMfcL21TqGQ==
X-Google-Smtp-Source: AMrXdXt/NiETw/De0+ssB/fkL7CTlPMSvM9WOAHGWsrDnTIPNlq3wEevEI7gVvJT6lKW7mL4ljb3zA==
X-Received: by 2002:a17:902:b615:b0:191:4367:7fde with SMTP id b21-20020a170902b61500b0019143677fdemr4511520pls.0.1672852428566;
        Wed, 04 Jan 2023 09:13:48 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ne2-20020a17090b374200b001ef8ab65052sm20869294pjb.11.2023.01.04.09.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 09:13:47 -0800 (PST)
Date:   Wed, 4 Jan 2023 17:13:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v2 6/6] KVM: selftests: Add XCR0 Test
Message-ID: <Y7Wzx5qW1zMQJq88@google.com>
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-7-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230162442.3781098-7-aaronlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 30, 2022, Aaron Lewis wrote:
> +static uint64_t get_supported_user_xfeatures(void)

I would rather put this in processor.h too, with a "this_cpu" prefix.  Maybe
this_cpu_supported_xcr0() or this_cpu_supported_user_xfeatures()?

> +{
> +	uint32_t a, b, c, d;
> +
> +	cpuid(0xd, &a, &b, &c, &d);
> +
> +	return a | ((uint64_t)d << 32);
> +}
> +
> +static void guest_code(void)
> +{
> +	uint64_t xcr0_rest;

s/rest/reset ?

> +	uint64_t supported_xcr0;
> +	uint64_t xfeature_mask;
> +	uint64_t supported_state;
> +
> +	set_cr4(get_cr4() | X86_CR4_OSXSAVE);
> +
> +	xcr0_rest = xgetbv(0);
> +	supported_xcr0 = get_supported_user_xfeatures();
> +
> +	GUEST_ASSERT(xcr0_rest == 1ul);

XFEATURE_MASK_FP instead of 1ul.

> +
> +	/* Check AVX */
> +	xfeature_mask = XFEATURE_MASK_SSE | XFEATURE_MASK_YMM;
> +	supported_state = supported_xcr0 & xfeature_mask;
> +	GUEST_ASSERT(supported_state != XFEATURE_MASK_YMM);

Oof, this took me far too long to read correctly.  What about?

	/* AVX can be supported if and only if SSE is supported. */
	GUEST_ASSERT((supported_xcr0 & XFEATURE_MASK_SSE) ||
		     !(supported_xcr0 & XFEATURE_MASK_YMM));

Hmm or maybe add helpers?  Printing the info on failure would also make it easier
to debug.  E.g.

static void check_all_or_none_xfeature(uint64_t supported_xcr0, uint64_t mask)
{
	supported_xcr0 &= mask;

	GUEST_ASSERT_2(!supported_xcr0 || supported_xcr0 == mask,
		       supported_xcr0, mask);
}

static void check_xfeature_dependencies(uint64_t supported_xcr0, uint64_t mask,
					uint64_t dependencies)
{
	supported_xcr0 &= (mask | dependencies);

	GUEST_ASSERT_3(!(supported_xcr0 & mask) ||
		       supported_xcr0 == (mask | dependencies),
		       supported_xcr0, mask, dependencies);
}

would yield

	check_xfeature_dependencies(supported_xcr0, XFEATURE_MASK_YMM,
				    XFEATURE_MASK_SSE);

and then for AVX512:

	check_xfeature_dependencies(supported_xcr0, XFEATURE_MASK_AVX512,
				    XFEATURE_MASK_SSE | XFEATURE_MASK_YMM);
	check_all_or_none_xfeature(supported_xcr0, XFEATURE_MASK_AVX512);

That would more or less eliminate the need for comments, and IMO makes it more
obvious what is being checked.

> +	xsetbv(0, supported_xcr0);
> +
> +	GUEST_DONE();
> +}
> +
> +static void guest_gp_handler(struct ex_regs *regs)
> +{
> +	GUEST_ASSERT(!"Failed to set the supported xfeature bits in XCR0.");

I'd rather add an xsetbv_safe() variant than install a #GP handler.  That would
also make it super easy to add negative testing.  E.g. (completely untested)

static inline uint8_t xsetbv_safe(uint32_t index, uint64_t value)
{
	u32 eax = value;
	u32 edx = value >> 32;

	return kvm_asm_safe("xsetbv", "a" (eax), "d" (edx), "c" (index));
}

and
	vector = xsetbv_safe(0, supported_xcr0);
	GUEST_ASSERT_2(!vector, supported_xcr0, vector);

and rudimentary negative testing

	for (i = 0; i < 64; i++) {
		if (supported_xcr0 & BIT_ULL(i))
			continue;

		vector = xsetbv_safe(0, supported_xcr0 | BIT_ULL(i));
		GUEST_ASSERT_2(vector == GP_VECTOR, supported_xcr0, vector);
	}
