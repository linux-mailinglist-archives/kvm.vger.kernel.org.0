Return-Path: <kvm+bounces-57717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F329AB595E2
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 14:17:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A68A4E5DD8
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 12:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E803D30C37E;
	Tue, 16 Sep 2025 12:17:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94EDA30BF71
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 12:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758025058; cv=none; b=hL/keIniLN/mmReydvfUHIvIYKWVMjTo2BplNhNzDUelhOavKAn4eIioVkeGZmtSX73/zKIqZbp8Ve0xzc9CjX1aF1MAzG/+HHR4sarCy4JPvd7vNm11vKfrCYsH5KsE8d1dEOKHIOgyApGMkPojvRw2e/TgA2oDbrM+67zlPLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758025058; c=relaxed/simple;
	bh=+Rt1OQ5f0XIuXvWrYdebVWJbfK3U2I/naiin5OO7UHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gfIP4S6t2is7h3yHm2/iR2gKBj6+fzz/UfNYDe2qQEjSS2Zw+f/MCv2eSnsattps1OFuE2efnkcek1rMoqLpU4FpbyoV+/y0b07FsPrPwUGc3j0xZ7oVSXhtp28XHobzUu+IE4Z0VZ6Bd+qt4cE10RnBluf+6rmhwBwjqwwYcZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA73512FC;
	Tue, 16 Sep 2025 05:17:27 -0700 (PDT)
Received: from donnerap (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EEA753F673;
	Tue, 16 Sep 2025 05:17:34 -0700 (PDT)
Date: Tue, 16 Sep 2025 13:17:32 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Will Deacon <will@kernel.org>, Julien Thierry
 <julien.thierry.kdev@gmail.com>, Marc Zyngier <maz@kernel.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>
Subject: Re: [PATCH kvmtool v3 4/6] arm64: add counter offset control
Message-ID: <20250916131732.499ffe22@donnerap>
In-Reply-To: <aJDHbClG5MagCCy5@raptor>
References: <20250729095745.3148294-1-andre.przywara@arm.com>
	<20250729095745.3148294-5-andre.przywara@arm.com>
	<aJDHbClG5MagCCy5@raptor>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 4 Aug 2025 15:45:00 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi Alex,

> You might want to capitalize the first letter of the subject line (add->Add).
> 
> On Tue, Jul 29, 2025 at 10:57:43AM +0100, Andre Przywara wrote:
> > From: Marc Zyngier <maz@kernel.org>
> > 
> > KVM allows the offsetting of the global counter in order to help with
> > migration of a VM. This offset applies cumulatively with the offsets
> > provided by the architecture.
> > 
> > Although kvmtool doesn't provide a way to migrate a VM, controlling
> > this offset is useful to test the timer subsystem.
> > 
> > Add the command line option --counter-offset to allow setting this value
> > when creating a VM.  
> 
> Out of curiosity, how is this related to nested virtualization?
> 
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  arm64/include/kvm/kvm-config-arch.h |  3 +++
> >  arm64/kvm.c                         | 17 +++++++++++++++++
> >  2 files changed, 20 insertions(+)
> > 
> > diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
> > index a1dac28e6..44c43367b 100644
> > --- a/arm64/include/kvm/kvm-config-arch.h
> > +++ b/arm64/include/kvm/kvm-config-arch.h
> > @@ -14,6 +14,7 @@ struct kvm_config_arch {
> >  	u64		kaslr_seed;
> >  	enum irqchip_type irqchip;
> >  	u64		fw_addr;
> > +	u64		counter_offset;
> >  	unsigned int	sve_max_vq;
> >  	bool		no_pvtime;
> >  };
> > @@ -59,6 +60,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
> >  		     irqchip_parser, NULL),					\
> >  	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
> >  		"Address where firmware should be loaded"),			\
> > +	OPT_U64('\0', "counter-offset", &(cfg)->counter_offset,			\
> > +		"Specify the counter offset, defaulting to 0"),			\  
> 
> I'm having a hard time parsing this - if it's zero, then kvmtool leaves it
> unset, how is the default value 0? Maybe you want to say that if left unset,
> the counters behaves as if the global offset is zero.

That's a much longer wording for something meant to be a very concise
description of the option, with the same meaning. So while "defaulting to
0" might not be 100% correct when it comes to how it's *implemented*, from
the user's point of view the effect is the same. And this is a user facing
message.

> >  	OPT_BOOLEAN('\0', "nested", &(cfg)->nested_virt,			\
> >  		    "Start VCPUs in EL2 (for nested virt)"),
> >  
> > diff --git a/arm64/kvm.c b/arm64/kvm.c
> > index 23b4dab1f..6e971dd78 100644
> > --- a/arm64/kvm.c
> > +++ b/arm64/kvm.c
> > @@ -119,6 +119,22 @@ static void kvm__arch_enable_mte(struct kvm *kvm)
> >  	pr_debug("MTE capability enabled");
> >  }
> >  
> > +static void kvm__arch_set_counter_offset(struct kvm *kvm)
> > +{
> > +	struct kvm_arm_counter_offset offset = {
> > +		.counter_offset = kvm->cfg.arch.counter_offset,
> > +	};
> > +
> > +	if (!kvm->cfg.arch.counter_offset)
> > +		return;
> > +
> > +	if (!kvm__supports_extension(kvm, KVM_CAP_COUNTER_OFFSET))
> > +		die("No support for global counter offset");  
> 
> What happens when the user sets --counter-offset 0 and KVM doesn't support
> the capability? Looks to me like instead of getting an error, kvmtool is happy
> to proceed without actually setting the counter offset to 0. User might then be
> fooled into thinking that KVM supports KVM_CAP_COUNTER_OFFSET, and when the same
> user does --counter-offset x, they will get an error saying that there's no
> support for it in KVM. I would be extremely confused by that.

On the other hand rejecting "--counter-offset 0" even when it's the
default behaviour and would work is even more cumbersome, I'd say. And I'd
argue that in general "offset 0" being a special case is well understood,
so I wouldn't be too confused about that.

If you really feel that needs detailed explanation, maybe we should add
that to the documentation?

Cheers,
Andre

> If this is something that you want to address, you can do it similar to
> ram_addr: initialize the offset to something unreasonable before parsing the
> command line parameters, and then bail early in kvm__arch_set_counter_offset().
> 
> Thanks,
> Alex
> 
> > +
> > +	if (ioctl(kvm->vm_fd, KVM_ARM_SET_COUNTER_OFFSET, &offset))
> > +		die_perror("KVM_ARM_SET_COUNTER_OFFSET");
> > +}
> > +
> >  void kvm__arch_init(struct kvm *kvm)
> >  {
> >  	/* Create the virtual GIC. */
> > @@ -126,6 +142,7 @@ void kvm__arch_init(struct kvm *kvm)
> >  		die("Failed to create virtual GIC");
> >  
> >  	kvm__arch_enable_mte(kvm);
> > +	kvm__arch_set_counter_offset(kvm);
> >  }
> >  
> >  static u64 kvm__arch_get_payload_region_size(struct kvm *kvm)
> > -- 
> > 2.25.1
> >   


