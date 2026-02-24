Return-Path: <kvm+bounces-71657-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aOIfJzz2nWlzSwQAu9opvQ
	(envelope-from <kvm+bounces-71657-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:04:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A8FE18BA58
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:04:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8DC2C31AEB9D
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB632E7635;
	Tue, 24 Feb 2026 19:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IphGT/xX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300291DED42
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771959651; cv=none; b=XPkwKcmSZi3dcNKESJ2DYNBnGCe8qvUsa9mad6pTE0e3avb7ULRSC36v29sSpJ4sy+RaCxTtvPRNnCd4mL118Rk6xSOM9QHx3hR54YkfBYCjdiFOroHXthI5SCMSAbbhvewv0StOdwz4FWULIwWD8kY4m/G+LRCVWMQbW7gNISo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771959651; c=relaxed/simple;
	bh=f6K9adyG5PCHsap7pglUiRa+hAvvTA7LkaSNMTsL84c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S/6MB8olsMdd1biOz1Fx5d49M4IweVx+oWg/2LeKkQe+wO22GaAajCQoEhagZSY6bBOd89NlYaUC7b9Y6bGYPQHuLpBLB/J2/LI5RzICDHfpvvGyGlljs1YMSwM8co+vwrv8bL36Xlhz16SkmICZ8vJyDrGQ6hpojKVERvmKG3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IphGT/xX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D116CC19423
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771959650;
	bh=f6K9adyG5PCHsap7pglUiRa+hAvvTA7LkaSNMTsL84c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IphGT/xXuq65qlgBxe91moBRGy0fGSthuH9uDH5//pTtRpSkGtwYGbexXKSWyA4Dm
	 qX2G9UiCsSAJnUQ5cXKmWX5ULjjKZ0rdpSZHTcLWlOT4x+JSfaigshqILkPnlHN8gs
	 25AzlZTFLaY8r+nymvYgzSjzJyDY3WyJCiupduihKZwPMHmoP3WSatwL3qJTLESBAY
	 z+pJPspYfWkwkm0roBHwWMVZ3yVrGTw8BguzlzNlgLVEOBg1l4WmmX0H+Iz3nFpX8K
	 4hbOeRd4lowrXjuvwqG5O7utGPrqjFnJ+8V41YBHMw1zW+0mzi4lo08TbN/tzoUIjQ
	 5DKcvGEkWLHYg==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b8fb6ad3243so824030966b.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 11:00:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVofGV4IM8fmMe6PEIPdEnVlb+Qu86brtRZwzhdYlEawsiKWALURv9hjiMDbESunJDGsJ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBKkZ+RqZEqv8OBHBk3ugcvS0nLHjyBHBBqP132poQX7jUnci1
	s2C5kpodu3Z1sN3vflTiwZY+IN5MLrJnc3ICtNpPwIPgKtwwtZ/Xy4oWnVUK9EkGk3qBnMNSufg
	ASl3Myd/kzCAC2bhj/zprlmEOBg9dH1A=
X-Received: by 2002:a17:907:747:b0:b8f:9f32:8be with SMTP id
 a640c23a62f3a-b9081b3b1a1mr734785966b.38.1771959649601; Tue, 24 Feb 2026
 11:00:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224071822.369326-1-chengkev@google.com> <20260224071822.369326-4-chengkev@google.com>
 <aZ3gg2VsrWGKrX4l@google.com>
In-Reply-To: <aZ3gg2VsrWGKrX4l@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 24 Feb 2026 11:00:37 -0800
X-Gmail-Original-Message-ID: <CAO9r8zNrQGKM0N345+KG=W72FyV1pp2EqOLcTMUZkz6bCA3MgQ@mail.gmail.com>
X-Gm-Features: AaiRm53PAIjsSjXLfdPYpF-zwBeFQig1cap7-aonE9Cdws9rtdYh6opPxWRFh5g
Message-ID: <CAO9r8zNrQGKM0N345+KG=W72FyV1pp2EqOLcTMUZkz6bCA3MgQ@mail.gmail.com>
Subject: Re: [PATCH V2 3/4] KVM: VMX: Don't consult original exit
 qualification for nested EPT violation injection
To: Sean Christopherson <seanjc@google.com>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71657-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: 3A8FE18BA58
X-Rspamd-Action: no action

> > @@ -496,7 +510,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
> >        * [2:0] - Derive from the access bits. The exit_qualification might be
> >        *         out of date if it is serving an EPT misconfiguration.
> >        * [5:3] - Calculated by the page walk of the guest EPT page tables
> > -      * [7:8] - Derived from [7:8] of real exit_qualification
> > +      * [7:8] - Set at the kvm_translate_gpa() call sites above
> >        *
> >        * The other bits are set to 0.
> >        */
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 248635da67661..6a167b1d51595 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -444,9 +444,6 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
> >                       exit_qualification = 0;
> >               } else {
> >                       exit_qualification = fault->exit_qualification;
> > -                     exit_qualification |= vmx_get_exit_qual(vcpu) &
> > -                                           (EPT_VIOLATION_GVA_IS_VALID |
> > -                                            EPT_VIOLATION_GVA_TRANSLATED);
>
> Hmm, this isn't quite correct.  If KVM injects an EPT Violation (or a #NPF) when
> handling an EPT Violation (or #NPF) from L2, then KVM _should_ follow hardware.
>
> Aha!  I think the easiest way to deal with that is to flag nested page faults
> that were the result of walking L1's TDP when handling an L2 TDP page fault, and
> then let vendor code extract the fault information out of hardaware.

Is it not possible that KVM gets an EPT Violation (or a #NPF) on an L2
memory access while the CPU is walking L2's page tables, then KVM
walks L1's TDP and finds mappings for the L2 page tables but not the
final translation? Or will KVM always just fixup the immediate EPT
Violation (or #NPF) by inserting a shadow mapping of L2's page tables
and retry the instruction immediately?

