Return-Path: <kvm+bounces-69551-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mMXxD8xwe2mMEgIAu9opvQ
	(envelope-from <kvm+bounces-69551-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 15:38:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9369DB10B7
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 15:38:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5C9CB304288A
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 14:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 930C11F9F70;
	Thu, 29 Jan 2026 14:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="02+0m23J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE422C3256
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 14:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769697406; cv=none; b=UDZi9me2BvVmaM3FUcKumGtTig3wmeNxA87NEdzMJyQ38DikIBBG+hUQk/88ZAZNQGlfpGv9vt2a9OTsHsUq2byoGV4RZ9rOoh2RvMJRlhKi8qxQOm6Be+67aN6N7hObAoBEJYYbuDL7L8r6bgOvvWCoGSKaqMtKP7d2aiT0MMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769697406; c=relaxed/simple;
	bh=znwZloF/bqh5zsvZiN44nSWQB16aALxNizfmVX+WlRw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DfQMGyLO5nupFMljeocqKB0IRC/RqDzuUrWUsd3H2cjzmXZ2x12CHV1Hy1tYZpdJIBgCwGNYJOnESh/rI2xj0pUMHTfDTla4MrKAsiMhHuOCXXJ11csFruHkcJxslSbcg7d/BKDMf1KOCWv3bcBokQikGz5BTUIGmtWDOTZFSg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=02+0m23J; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ab459c051so1863776a91.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 06:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769697403; x=1770302203; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fc8ELM/gTsPjpCHlht3R3Sj8sQv9T3iDgJmyY1+bv10=;
        b=02+0m23JQKEJTkyNwefQedtPAH4wx78VBGXTZBbL9HqFoF1xbClZwV/PxJ+vGTzwIw
         1n4e9XHXlVs0QDKo5nlord1ir4r6lUQOa7h0gKNDlSetoVwopoyxogrnUxcuCxPWR/mD
         wP1H0IQmWwnv9WB6J3FolwIjAJV9SDLlppOFakqTfEpdup5Vxs4ZrQTY3NDuV7tFlckt
         Gv4UGA/9Y4dL/7mH8LSc6uOY1cAuxFnlS2ZMIAu5w64FigkIyNZVunxtbix54WC6E9pn
         Jvj+71jwq36KpsD9tAHsXwsxmVguu7yJYSNu2PhIQJvjmxA1DwKgCYSSChKxaRN4EuL4
         3YAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769697403; x=1770302203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fc8ELM/gTsPjpCHlht3R3Sj8sQv9T3iDgJmyY1+bv10=;
        b=Fmf0NWj05B9vk2BCXXk7fhHvGc6MTqzOlpoCV6QH9+Ny81YiQ73Fccs3cbTwFhIqEW
         PMiiJQK5l/LIWyqoxF3Ebtf3H1abLE9GiOP1KyA+Jk3szZpFw8jNzgDUIDZe5t/7w/94
         pL9WD8Aj7TbZFTbx6xYB7tLHccrT5GBLGdv9ZzBOleoL0n1u1XIA4d1/7u7kmT3y4Erk
         yhd51BsaxtNMZyqAI86F241EpTk3JuNCX6WB/9apdviUVmXjV/Bt4/6XhT/YU7kF2V7j
         nKwji1oGdEQNyunODRZJno99wfSaxmXG4pUfFrROvKCLxFPqD61fYVQQC241HCbRx0I0
         H4lw==
X-Forwarded-Encrypted: i=1; AJvYcCXmCa+xvfQFDjOVp33qFXgRy1gTeuK/K8rI81hPulIXE2ZcksgEGhvwjjAcvFaTdwg5qus=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVwlCfwbgg7+590VPxhhrS6AQcnaydauJq9IKDbXs63lSic+Xi
	GK9LFe0oLjz/7/KAribPPMRJVYMWmmfW4/ozv1VwdBjwPXgF59nKU3c5ZI6XVRnv0hQQUKMwzsH
	zFkXiDQ==
X-Received: from pjbmp8.prod.google.com ([2002:a17:90b:1908:b0:353:2f4:eaf9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3901:b0:353:e91:9b2f
 with SMTP id 98e67ed59e1d1-353fedcc422mr8402350a91.37.1769697402792; Thu, 29
 Jan 2026 06:36:42 -0800 (PST)
Date: Thu, 29 Jan 2026 06:36:41 -0800
In-Reply-To: <aW4kd4nCjP+9Akva@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106102136.25108-1-yan.y.zhao@intel.com> <2906b4d3b789985917a063d095c4063ee6ab7b72.camel@intel.com>
 <aWrMIeCw2eaTbK5Z@google.com> <aW2Iwpuwoyod8eQc@yzhao56-desk.sh.intel.com>
 <3ef110f63cbbc65d6d4cbf737b26c09cb7b44e7c.camel@intel.com>
 <e69815db698474e113dec16bd33116e54cb21c2a.camel@intel.com>
 <aW4DXajAzC9nn3aJ@yzhao56-desk.sh.intel.com> <d9b677b4f4cbbf8a8c3dadb056077aa55feb5c30.camel@intel.com>
 <aW4QGYQ+qMytZ4Jq@yzhao56-desk.sh.intel.com> <aW4kd4nCjP+9Akva@yzhao56-desk.sh.intel.com>
Message-ID: <aXtweWFELioEZLzv@google.com>
Subject: Re: [PATCH v3 11/24] KVM: x86/mmu: Introduce kvm_split_cross_boundary_leafs()
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, Fan Du <fan.du@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Dave Hansen <dave.hansen@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"tabba@google.com" <tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "david@kernel.org" <david@kernel.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chao P Peng <chao.p.peng@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"kas@kernel.org" <kas@kernel.org>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"sagis@google.com" <sagis@google.com>, Chao Gao <chao.gao@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Jun Miao <jun.miao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, "jgross@suse.com" <jgross@suse.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69551-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,vger.kernel.org,amd.com,google.com,suse.cz,kernel.org,redhat.com,linux.intel.com,suse.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[29];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9369DB10B7
X-Rspamd-Action: no action

On Mon, Jan 19, 2026, Yan Zhao wrote:
> On Mon, Jan 19, 2026 at 07:06:01PM +0800, Yan Zhao wrote:
> > On Mon, Jan 19, 2026 at 06:40:50PM +0800, Huang, Kai wrote:
> > > Similar handling to 'end'.  An additional thing is if one to-be-split-
> > > range calculated from 'start' overlaps one calculated from 'end', the
> > > split is only needed once. 
> > > 
> > > Wouldn't this work?
> > It can work. But I don't think the calculations are necessary if the length
> > of [start, end) is less than 1G or 2MB.
> > 
> > e.g., if both start and end are just 4KB-aligned, of a length 8KB, the current
> > implementation can invoke a single tdp_mmu_split_huge_pages_root() to split
> > a 1GB mapping to 4KB directly. Why bother splitting twice for start or end?
> I think I get your point now.
> It's a good idea if introducing only_cross_boundary is undesirable.
> 
> So, the remaining question (as I asked at the bottom of [1]) is whether we could
> create a specific function for this split use case, rather than reusing
> tdp_mmu_split_huge_pages_root() which allocates pages outside of mmu_lock. 

Belatedly, yes.  What I want to avoid is modifying core MMU functionality to add
edge-case handling for TDX.  Inevitably, TDX will require invasive changes, but
in this case they're completely unjustified.

FWIW, if __for_each_tdp_mmu_root_yield_safe() were visible outside of tdp_mmu.c,
all of the x86 code guarded by CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT[*] could live in
tdx.c.

Hmm, actually, looking at that again, it's totally doable to bury the majority of
the logic in tdx.c, the TDP MMU just needs to expose an API to split hugepages in
mirror roots.  Which is effectively what tdx_handle_mismatched_accept() needs as
well, since there can only be one mirror root in practice.

Oof, and kvm_tdp_mmu_split_huge_pages() used by tdx_handle_mismatched_accept()
is wrong; it operates on the "normal" root, not the mirror root.

Let me respond to those patches.

[*] https://lore.kernel.org/all/20260129011517.3545883-45-seanjc@google.com

> This
> way, we don't need to introduce a spinlock to protect the page enqueuing/
> dequeueing of the per-VM external cache (see prealloc_split_cache_lock in patch
> 20 [2]).
> 
> Then we would disallow mirror_root for tdp_mmu_split_huge_pages_root(), which is
> currently called for dirty page tracking in upstream code. Would this be
> acceptable for TDX migration?

Honestly, I have no idea.  That's so far in the future.

> [1] https://lore.kernel.org/all/aW2Iwpuwoyod8eQc@yzhao56-desk.sh.intel.com/
> [2] https://lore.kernel.org/all/20260106102345.25261-1-yan.y.zhao@intel.com/

