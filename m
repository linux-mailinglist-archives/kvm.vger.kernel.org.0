Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2CA4D2130
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 20:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240768AbiCHTQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 14:16:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237986AbiCHTQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 14:16:41 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41984EA1B
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 11:15:44 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id w4so7584049ply.13
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 11:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5tlumRnUSQglQq/+mWE9RjiXVXWEbK2EvGGExgddWkc=;
        b=sCQ3di/YdCWVkNgx6JQrLP5gl311dT7UwNR1xAyphg/768Pa0fjac5O5dEC5kHD4iG
         /yGiyocomy/THvBBttTG+I2bmD4D7Gyc6fUKUMNvY43Ac++TzvofyASIImW6wgdpzoRP
         KtZtPvC0gKKeqwWpGG4wjfULoSWtVc3Tey/Hk92FOrwoxMDDIt1mmF+ztcRycO+yxCUZ
         viOMzvuSKKWeJjJk/UMOPlvNntcGvkJg/JGdYoN3edN2l7TwxURMoLgcZjyH6UQ7X71C
         xssYwmFSXiEtw4h9zESlNQ9g41Ca/JZ2oLV3pvStaQo+zKFwq7zprW2Om+n5bu8ELxs7
         HF7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5tlumRnUSQglQq/+mWE9RjiXVXWEbK2EvGGExgddWkc=;
        b=aLNWyKF4debZ+gD6ihjVnb5zlcZKvYOBsv9aEQaibafFe6g0fBxz386RI5TCHw/vIb
         gKck6HRpfIW+rGULHdf4VRB8rv31JhueqADLLZzFFaMniRzyP5uz3iTTDMQK/U8HF45K
         LC7ZtQIeRVoBgMZVYY1w4rOxz9YMrdP6AQcJL1nn3P1VG4qa4Gy2IPMErc7UYds23vBu
         6G4Gg/MFjgDpA0FsGkTeT2TayT1tAfN4yWtDGO5n6+rfLjLc2EmsJMo17rndYie7wxfY
         q5R9dgwMUTbOwmvTJMzAKUqBYmLrogeZ+3XR92808H5CqmcjYaoDV507KCcSgiNXf3Hn
         KX3g==
X-Gm-Message-State: AOAM5303mDdGzsubWpVBmMawNz89MuqrqeMdO0HyY8gS71JOVTEUFqwb
        QBGNVE73YcxtuZXVO3f1TqeSog==
X-Google-Smtp-Source: ABdhPJydNcfCwG0t9dztRqYGilmcV87Dl6j5Ro/inIEy5gYIF2PexhSqT1b9H/frSjYR1oh8Mj0sPQ==
X-Received: by 2002:a17:90b:3e8d:b0:1bf:4525:c834 with SMTP id rj13-20020a17090b3e8d00b001bf4525c834mr6294421pjb.63.1646766944234;
        Tue, 08 Mar 2022 11:15:44 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v10-20020a056a00148a00b004e0f420dd90sm21989018pfu.40.2022.03.08.11.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 11:15:43 -0800 (PST)
Date:   Tue, 8 Mar 2022 19:15:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 16/25] KVM: x86/mmu: rename kvm_mmu_role union
Message-ID: <YierXBEvTdp5aw+u@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-17-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221162243.683208-17-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 21, 2022, Paolo Bonzini wrote:
> It is quite confusing that the "full" union is called kvm_mmu_role
> but is used for the "cpu_mode" field of struct kvm_mmu.  Rename it
> to kvm_mmu_paging_mode.

My official vote is to use

	union kvm_mmu_cpu_role cpu_role

instead of

	union kvm_mmu_paging_mode cpu_mode

The latter has too many inconsistencies, e.g. helpers using "role" instead of "mode",
the union using "paging" but the field/params using "cpu".  The cpu instead of paging
thing isn't a coincidence as having the param be "paging_mode" would be really, really
confusing (ditto for kvm_calc_paging_mode()).

IMO this is consistent, if imperfect.

static union kvm_mmu_cpu_role kvm_calc_cpu_role(struct kvm_vcpu *vcpu,
						const struct kvm_mmu_role_regs *regs)
{
	union kvm_mmu_cpu_role role = {0};

	role.base.access = ACC_ALL;
	role.base.smm = is_smm(vcpu);
	role.base.guest_mode = is_guest_mode(vcpu);
	role.base.direct = !____is_cr0_pg(regs);

	role.ext.valid = 1;

	if (!____is_cr0_pg(regs))
		return role;

	...

	return role;
}

Whereas this is inconsistent, and also imperfect.

static union kvm_mmu_paging_mode kvm_calc_cpu_mode(struct kvm_vcpu *vcpu,
						   const struct kvm_mmu_role_regs *regs)
{
	union kvm_mmu_paging_mode role = {0};

	role.base.access = ACC_ALL;
	role.base.smm = is_smm(vcpu);
	role.base.guest_mode = is_guest_mode(vcpu);
	role.base.direct = !____is_cr0_pg(regs);

	role.ext.valid = 1;

	if (!____is_cr0_pg(regs))
		return role;

	...

	return role;
}
