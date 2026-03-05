Return-Path: <kvm+bounces-72962-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uHcpC40EqmliJgEAu9opvQ
	(envelope-from <kvm+bounces-72962-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 23:32:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C9F80218EE2
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 23:32:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9BAFA309B09D
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 22:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3176A364054;
	Thu,  5 Mar 2026 22:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fWHZzlQ8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB5123C516
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 22:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772749846; cv=pass; b=Sx20e3+q8/J7ocPl+ptWRYwFV5GeXWwF5aew+ABWCAb126j8BkH4mz72nEhb+VtgzkrRcpIXk9n58nVUq0wJ2Wn9GB0LHjBcjZh8z/QyTXGtRUrgHcFY89r21TvWn8LSOzGAG7xDfhRSCiBZ0D2BXMVUwE44QHmtikcGng0qAFI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772749846; c=relaxed/simple;
	bh=hGZ9iSCiQXqfmITrvyrOee2hXh3veHJd7rWOfEPMp7o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iZCHKCs7WTHM1WVSmvcM9B31WG5z7ZsvEQ61i4WvhdTOq9XcTqsKThpaeXLDB8DB5Bwlsu5JesB1aQWsOi6ldLSzUbrdVoyhglFUwaZyTgVyGEFgy+5IsnGsFIEkB/CZlPXKsuare7LIvKc5T7Z/l6s/Y6cSaYXniLfrpQVKJ8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fWHZzlQ8; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6614615fde6so1776a12.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 14:30:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772749843; cv=none;
        d=google.com; s=arc-20240605;
        b=A5HD/NfaYG9Ce/cyboEZ4WGYR5JXsLATFjjM7wpmiH9dq5PdNpBkVPAcea7g306MX0
         BPqH1IC3/mkw0NTa9OGgc5MxeDc9MR8O06sayjSiG3h0WC8Cz47HfrbzdAcP3qdfAlH5
         iGLBICJk8tiDx1r6bOmzpQYZNcj2r5iPdc0qcgDtcV3ILfbhl91D2NNBt+nYIH1xx3m2
         XH1OHHu5TtfCbprp0NSF+UUBi9eSwgs7X7l87qXK1Ju3Tb7rS1S+s54daDwKIzDn6fEl
         MJJ9ltjNvCf2+HRxM2asInkE8BDxbm6R4bIZaDqVOEFaxIn8d15vxuXJOkx6DnfouBkT
         PUsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=REKwqu+YZznLvXOpxEfD8znxXd8x89wuTrIuRHIuZVU=;
        fh=1eNPo8kb8gJE2/P9agVi33dMHxsZYYYofXUvJ0ukwU8=;
        b=iTR75bDwevforgCY4oiTbijdZeDkgRVO57mCLD90uEMsb5jNjBTn+s7771pb/gUuMm
         IxK0bOtcGYp/wiclnsSi8uqDw0imxqSxeGKhLBFYVfV9hOindTMZIUqLC0DAITEvRLsL
         hsF/7d3TbNAuBmQp5xc4mesbyIN9631GHwMyvcUyrpVMXqWB0SkcXzH7fCWe2CrcIFwd
         qjdim5r8Wd6CKpsquXwk50cv/wxRHKEBGZ7bbGcqTC3ZLPAXHacAEqTaHg7wypcHLdFn
         TmUiz85Vjuyt6xW2xj4obZLqdJhFrxzxFovJCopdfxzOz4ZKDMEBvvHz8LWSkyDbj9NJ
         83fA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772749843; x=1773354643; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=REKwqu+YZznLvXOpxEfD8znxXd8x89wuTrIuRHIuZVU=;
        b=fWHZzlQ8Gik7slOLeecqfPBEmg9e8UYYPAWOmI5C/jOU7qAPAx5GGjS1dgoNhqBObA
         IdSbCr9eXkIk3uQD02wfHbr9L8xVN14CLmE0GqtwjUm6QbW462AoHX3uh1PBRKFduPgI
         dQjoIVFuwQBMmdedqQf5whoK+YGf4Q1Gaq6xSLfpurDy9GJUKmzckAeTtJOWXHlbdN5D
         ztCIyUG7bPGmkzzLwHTIOW29yCl9pmcOzFpcAXkl1b1CXfSW6qpRynDYs5TBqkXmt9fK
         4g6IfqZFQBfLqXvOtRg0Tid1fi0uRVeu70yfYFL0OUW5NPaTZNOq1Q9rfXowwqy1ejOv
         MrXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772749843; x=1773354643;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=REKwqu+YZznLvXOpxEfD8znxXd8x89wuTrIuRHIuZVU=;
        b=GgqrzWTIBgpqQ9cn06IgbZJ18bDSrK2a3C4hqfzFI5X1Bwb35zggkPNpPn8uO2CuQy
         F3JNb1AXFXl9i1rbAZgwOtCsURUbjtpiBTGAHFRtROHlSpikzKKAZMbSgfJ916YTs44C
         zoxpxBNlBqzwLsvlF/4k6qo12gLzfNxwZhZ+R4FZFtlENiqNjuQ8MwEn3JT/YxW7Tgfc
         6dO1fByX+e5sw8Wo2sw6ggJv0+lpZ9EKCVE4Dmlo8yZuqddFN8RyFokj2JMsg0qwzYqk
         +XcH5B/YmpeblLUc54Aj5OMz7VY7Lk1EHVhYUqzpgUHmuI+2KrWGywDYbiie91bQRfAv
         5kXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmAiYouI2NW9yA8grm8IqXh19G7AQklHAJS/ZHrlB2PnaF55jekMQseHj0V50GS5i0XDM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxJ4waxflbSjrvdHM5oF6/XW8A9kapsdo+HjuVf3WAK60gfrzo
	mdvBGDvEmRb6wOPLnb83a2xPjjrhRtdeBrxTjduqfq16LIper3US26WMhIB3R+XFIsg8JYwejVD
	4EireJ0QBSavX0KpXuvn6oN5Q3WQpdNrTfLO2qJ6X
X-Gm-Gg: ATEYQzxhjrL0wcEFTaQ0cbCGr1dxDzp6O1gp/PbyuyPUIz94jtb+pHNl7H8uv3pi/Xk
	0yGo4U9lQxRFhaxgufhsKoT7vBPFyqWVHYdfLMV2SNHrrQx1olRcC7oP69sScZzVNkRxSQxgWry
	JmN1olKfoeSv+GbjGNHRpgSX5ra5ZD3cGAhKB0Wbiln7oZGADH7F595DnyzhLHuyCwEagmSngpa
	iEd20RbQCvNgkysCxaaUOiVtFsBOy40VBvtYKCbxc98L76GKRe/UnnmQmS9hdpsMXYVqkU21SRL
	LQ2pu/sXRDg1GKL9QA==
X-Received: by 2002:aa7:c686:0:b0:660:f90b:a19b with SMTP id
 4fb4d7f45d1cf-6618db518c7mr13996a12.8.1772749843068; Thu, 05 Mar 2026
 14:30:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303003421.2185681-1-yosry@kernel.org> <20260303003421.2185681-27-yosry@kernel.org>
In-Reply-To: <20260303003421.2185681-27-yosry@kernel.org>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 5 Mar 2026 14:30:30 -0800
X-Gm-Features: AaiRm538b03chwllMwxglI-m0-GkljGOUWEF9yv_DduXXgi6KTvJOzlgz2JRUUY
Message-ID: <CALMp9eSMtzDJn7tGtbj=zLYpcU7Tc7XjcWBRZH7Aa5YihSmN7g@mail.gmail.com>
Subject: Re: [PATCH v7 26/26] KVM: selftest: Add a selftest for VMRUN/#VMEXIT
 with unmappable vmcb12
To: Yosry Ahmed <yosry@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C9F80218EE2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72962-lists,kvm=lfdr.de];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[google.com:+]
X-Rspamd-Action: no action

On Mon, Mar 2, 2026 at 4:43=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> Add a test that verifies that KVM correctly injects a #GP for nested
> VMRUN and a shutdown for nested #VMEXIT, if the GPA of vmcb12 cannot be
> mapped.
>
> Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> ...
> +       /*
> +        * Find the max legal GPA that is not backed by a memslot (i.e. c=
annot
> +        * be mapped by KVM).
> +        */
> +       maxphyaddr =3D kvm_cpuid_property(vcpu->cpuid, X86_PROPERTY_MAX_P=
HY_ADDR);
> +       max_legal_gpa =3D BIT_ULL(maxphyaddr) - PAGE_SIZE;
> +       vcpu_alloc_svm(vm, &nested_gva);
> +       vcpu_args_set(vcpu, 2, nested_gva, max_legal_gpa);
> +
> +       /* VMRUN with max_legal_gpa, KVM injects a #GP */
> +       vcpu_run(vcpu);
> +       TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> +       TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
> +       TEST_ASSERT_EQ(uc.args[1], SYNC_GP);

Why would this raise #GP? That isn't architected behavior.

