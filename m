Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B9E4B00BA
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 23:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236567AbiBIWzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 17:55:16 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236561AbiBIWzB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 17:55:01 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDC4E04FF0C
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 14:55:04 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id h14-20020a17090a130e00b001b88991a305so6670699pja.3
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 14:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5OgBvBtD/pqZyY1Wyl2wDigiqIzipvE7VvYdDX53RaU=;
        b=lr8JBDfah6TBBfm+fcfoKKyOkr4qRbOpNZKNSz0jmz/yX6P+3I80Gf127D2r/XjQUA
         3Ks3cAXBSu53tT9w1ibvn5Il5wp07oxQoNqoZM1zcxtyyxZQIfHHyMuH9Wu320T/VBSm
         k21jxvs3Wk0sFwnWQ/apaH2I3G85S6jN0k4LlkwrlkW2AKh84OQTIFYY2tRdMAOHMMV/
         dfkRftgcaKD3gXqcUskLTUJDhSvmru45c+ZrJg5RDsasia1xMO8axDk51mSdiBvv5IkB
         8wNBRxeXfiFuT4lbyXRgU8v4Qw+Z4RiFePK00zyExo7XeCKjmjW2zkmocLU63lo4OBBP
         x8lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5OgBvBtD/pqZyY1Wyl2wDigiqIzipvE7VvYdDX53RaU=;
        b=OgdwMz89HXplpfWbYIZEgfx9zLBHc70nEAsRbjlyFkPunf7YjSmNLJBfGkwZEG4wts
         TbDZUtTZUsIy4SlYkX3sDP+gVQlZswGb3xMm7Y8K/VbQWOlBjYXAaPuMJszbmtB21IES
         2WdyLKUJ5YRucbPcPFq6wX3ce3ZtLJO2I5DHZmAelnbbynd79AhSB3dd4QPazjcrnHht
         Qd170BuE6HBVK6/OH1H1SchNOuKFPNphE6Pb6wN8+miF0P6DGi51ffZ7oFhQt4POyX1h
         MEP4NapV5KS4yV3+QTeFbFieu24IPkgcbUi0FskOMXSkCIROd00Rx8wPHFZut4r1OKH1
         HnHA==
X-Gm-Message-State: AOAM530zo45KtHoAl7d2wTPJ/SpOCTD+gUT2hKW1zHGG5IqNCKR4ZqQ9
        zKQOGK5lM5Y1XnXksV4nPz/IZA==
X-Google-Smtp-Source: ABdhPJx3fRoFf3m1YrhBm9bwMf/KNqL/k72G8kAET9jEP4tr4GMXepaIFbIEk883VTIOOZ9EPhHXZg==
X-Received: by 2002:a17:90b:4f8f:: with SMTP id qe15mr5110563pjb.94.1644447303388;
        Wed, 09 Feb 2022 14:55:03 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id nl7sm7362138pjb.5.2022.02.09.14.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 14:55:02 -0800 (PST)
Date:   Wed, 9 Feb 2022 22:54:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 03/23] KVM: MMU: remove valid from extended role
Message-ID: <YgRGQ1HiB2jSTr5M@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-4-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204115718.14934-4-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022, Paolo Bonzini wrote:
> The level field of the MMU role can act as a marker for validity
> instead: it is guaranteed to be nonzero so a zero value means the role
> is invalid and the MMU properties will be computed again.

Nope, it's not guaranteed to be non-zero:

static int role_regs_to_root_level(struct kvm_mmu_role_regs *regs)
{
	if (!____is_cr0_pg(regs))
		return 0; <=============================================
	else if (____is_efer_lma(regs))
		return ____is_cr4_la57(regs) ? PT64_ROOT_5LEVEL :
					       PT64_ROOT_4LEVEL;
	else if (____is_cr4_pae(regs))
		return PT32E_ROOT_LEVEL;
	else
		return PT32_ROOT_LEVEL;
}


static union kvm_mmu_role
kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, struct kvm_mmu_role_regs *regs)
{
	union kvm_mmu_role role;

	role = kvm_calc_shadow_root_page_role_common(vcpu, regs, false);

	/*
	 * Nested MMUs are used only for walking L2's gva->gpa, they never have
	 * shadow pages of their own and so "direct" has no meaning.   Set it
	 * to "true" to try to detect bogus usage of the nested MMU.
	 */
	role.base.direct = true;
	role.base.level = role_regs_to_root_level(regs);
	return role;
}


static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
{
	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
	union kvm_mmu_role new_role = kvm_calc_nested_mmu_role(vcpu, &regs);
	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;

	if (new_role.as_u64 == g_context->mmu_role.as_u64) <== theoretically can get a false positive
		return;
