Return-Path: <kvm+bounces-68633-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gEgEBiPkb2lhUQAAu9opvQ
	(envelope-from <kvm+bounces-68633-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 21:22:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9458C4B3A3
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 21:22:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0544E7CE61D
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 17:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ECBB44105A;
	Tue, 20 Jan 2026 17:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XJ8QG3Hf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8C943CED7
	for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 17:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768931867; cv=pass; b=MMxPDq2Tiy1VXMc5wA6MmwG8KtBOasTFPEj4p7CMzQUtDj1RP7Bp/O4Wxt0gNFuI/mTL3KeawhrRkpIO5PvjxYIekwMWK0TToM/FbN1gC5PlA6ZAZ7K0+yGer2n0cj6sQdRc3fpmUgsz+JVSsX1hGVmdR1fVWqrcjdCvJWm+VrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768931867; c=relaxed/simple;
	bh=NXMDwBrH68EEQhabhud/Kc3K0VxmDfwum7Xuf2wmBoI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aMn+JvrtNBIexEzMraeAjkKZcPIPRhcXboEYuDzGCc5tb1sFf+uMJNBsgOKyXEjPO++M+UiRstzHzDjCjEEXlQMmUA2SnOEzmCCq9JvK0KeqxZFm75icAQ2D/80m+0ToD3PHoEejNRP/Uoee087BpJkhAVwu33HxMgJbkSwPaXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XJ8QG3Hf; arc=pass smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-124643b5b18so626c88.0
        for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 09:57:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768931865; cv=none;
        d=google.com; s=arc-20240605;
        b=iByvAFxWpa+GG5lgy7484VKyLo6mU+H9k/oDtZHrthP7KD71sYzHl7NVykBJ1/dGD6
         fOPgzA/zYgerBhnIda+HVgB+GHoNRzhODJUYwwkLx3q54lEP8szMMxd2AmcfK2pz7UzK
         uKXZzXYWFsJLZK+KA9Hqx937pRQ3hoLCEbAtXl7FnspDEZUoAP5vWAaH6XmXVdEwLpme
         RDlJWfvV8ZbXbeyBiJ7NuQlsBbwAECNMOKh7o6nK23pwzaIWOiNiC3uL2eTwhefWizYe
         13dVpTsg6OLNjGOIgRDwczMEwXXF3dey3u3+XqzGC3AKXwqLfvtqesnMh98/TtyVwH5G
         +Fkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1iXhGiKDPUB5tolgim9pOTSSBQ25N8rGsEdEESlfaGk=;
        fh=gybeT4F0VF46BhChRNNhuacHU83Rns4aTzQ5cWo9KFE=;
        b=JFWI/hRgAhKlY8tBnOWCMC5sBaaczPMAgmZYUDXoVl6sYIWuyFBElVtPzPD6V73LAd
         04Fl04bDnA/lKCAK+xjEx5Q7MFPhy0rAnc5MGFiVYPnnecwHARcXW3L6rgUTnRGqcIni
         NO7YC3qph5LawUekD8MaXTlluM/rIPzQBJvQ20D+KzSKHatGiC7FdYVcDW5+04iaqFGw
         aQS+qrmPFhwWRAvhqZlQ3JL/4/RybmPjNlMOBW+nKE4PuhnpGAD2ryGv85xdCG8kfp3g
         zKgN1r8X+vPxzo7Z9E4uC8ZPxFVghCpAoX38XW5jnjBDRuWSBoC6EMee/b7XbqU+RLAn
         TB8A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768931865; x=1769536665; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1iXhGiKDPUB5tolgim9pOTSSBQ25N8rGsEdEESlfaGk=;
        b=XJ8QG3HfN3O7yIuUa8EYE3cc9zeEVoF9jwF/roLNlsBNfyRwvlAo7eCQQLMco6ye+5
         Ff1C+j/qVyMnv+Cvur+a7iDOQuQsHhv+bMitbG7uHSI+bnnY3fgOIo40dh3Y6R2F9n8J
         s8o53A0xsbcGKm4GWS9e+RfzBovRu4QB0V0Etj/QKIxZud1zcNQsUPeipYI/aSR+8B4z
         bpamZZPh45El3Zl1hrBxTvTqlazt/Mxfd12Zni+d4Vo1BVcvW41xe5bIfAG/9FZ5vRcs
         m+xfHVQMApwp9jng5l2cgsJUaQfNoONt2fYoJFy2sMCX7HPxvgUoCSjdyuyGHL954DYv
         YzPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768931865; x=1769536665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1iXhGiKDPUB5tolgim9pOTSSBQ25N8rGsEdEESlfaGk=;
        b=WT+PRwiW3c5KKsb60k9sVXkLJM9j3UNWXZl5jmOrh28Q/P7FlQiH298FM8p9ny7loi
         vwdfozBFZZVDbQyt+j1DNr9cIbdjZ3MwpmVdLwbzxmz27bp7iBN6lMDZWOCnq6NpJl/j
         5E4gtKTLSSlYIeD1JY22+PLKUZ1h6BBACP6wm6nUHq6s7ZAQg6Kt2RrM4KtwYe9ZjwNd
         bO5qjFOuIASNE4rN/vW/fAo5sNaEpS5XenKeiElvyeigjYiDXRqUXaiS13tYEUVYdKdY
         LAKEXn/elWywtOf4vtRvvBD/kHoughSvpUPIIusBzsC/qKZWD2nszikbzbfkOE2dbSxW
         QR4g==
X-Forwarded-Encrypted: i=1; AJvYcCUhaxLzhYs0304rzX4/u8qmuchlmO3QXn9PhcwlrQ0tpTyyHZPp5cqQRxzucAIUKhqYtD4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSBvcs+szHaDOwBizS9wCrqQJgpY/WQQM2pS2Pr1udxQV07SQl
	HscgccOG+WsDAdOknd3W1mHKj7EVfC4iWX8K07ZKqXee2FZbGK2a80ga8vknZukAqOznubvqB3h
	f0XMVn9zn4wgiQxtLHFjVwiwwFf8iKV78mSjrgGJm
X-Gm-Gg: AY/fxX7lWSjktcvzH5gbznt5zGHvi2xoyPmmfUOfgU9iYZkrNQBzg4d6jIHDYpYN8L5
	+xqpkJDT9bOyEKWGuvL2miEu4mRA86yVARv+3gZ0iov4ivTitXnwCohcSq6iqXCYLMtJpUrQ3r2
	3k3F2/gm2vJ05SNwPGek21FkXHpKkdvthV9ObtenUPqZFsZ72wSSAiuCLw/GY58AzZF4r/Y3X5B
	QZQBRHEoIRVtVba4qPzSeYl3LtADxIm/tzR8SBFqGRTEb8dhzqAgKmBYmAF3FBa921buezR6tx8
	hdn6uSaHrO7sHjIVJVMEvK5hhAZz
X-Received: by 2002:a05:7022:1581:b0:120:5719:624b with SMTP id
 a92af1059eb24-12453d71f45mr375564c88.18.1768931864907; Tue, 20 Jan 2026
 09:57:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <20260106102136.25108-1-yan.y.zhao@intel.com>
 <2906b4d3b789985917a063d095c4063ee6ab7b72.camel@intel.com> <aWrMIeCw2eaTbK5Z@google.com>
In-Reply-To: <aWrMIeCw2eaTbK5Z@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 20 Jan 2026 09:57:32 -0800
X-Gm-Features: AZwV_QhSaRVEQEBxN7hEUUX-nhtYVkYAE_TtQWJWs_dX2f1VSEWmANBDjmRr-XY
Message-ID: <CAGtprH9OWFJc=_T=rChSjhJ3utPNcV_L_+-zq5uqtmXm-ffgNQ@mail.gmail.com>
Subject: Re: [PATCH v3 11/24] KVM: x86/mmu: Introduce kvm_split_cross_boundary_leafs()
To: Sean Christopherson <seanjc@google.com>
Cc: Kai Huang <kai.huang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Fan Du <fan.du@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Dave Hansen <dave.hansen@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "david@kernel.org" <david@kernel.org>, 
	"kas@kernel.org" <kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Chao P Peng <chao.p.peng@intel.com>, 
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>, "sagis@google.com" <sagis@google.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Jun Miao <jun.miao@intel.com>, 
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.46 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68633-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[29];
	FREEMAIL_CC(0.00)[intel.com,redhat.com,vger.kernel.org,amd.com,suse.cz,google.com,kernel.org,linux.intel.com,suse.com,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[vannapurve@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 9458C4B3A3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Jan 16, 2026 at 3:39=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Jan 15, 2026, Kai Huang wrote:
> > static int __kvm_tdp_mmu_split_huge_pages(struct kvm *kvm,
> >                                         struct kvm_gfn_range *range,
> >                                         int target_level,
> >                                         bool shared,
> >                                         bool cross_boundary_only)
> > {
> >       ...
> > }
> >
> > And by using this helper, I found the name of the two wrapper functions
> > are not ideal:
> >
> > kvm_tdp_mmu_try_split_huge_pages() is only for log dirty, and it should
> > not be reachable for TD (VM with mirrored PT).  But currently it uses
> > KVM_VALID_ROOTS for root filter thus mirrored PT is also included.  I
> > think it's better to rename it, e.g., at least with "log_dirty" in the
> > name so it's more clear this function is only for dealing log dirty (at
> > least currently).  We can also add a WARN() if it's called for VM with
> > mirrored PT but it's a different topic.
> >
> > kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs() doesn't have
> > "huge_pages", which isn't consistent with the other.  And it is a bit
> > long.  If we don't have "gfn_range" in __kvm_tdp_mmu_split_huge_pages()=
,
> > then I think we can remove "gfn_range" from
> > kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs() too to make it short=
er.
> >
> > So how about:
> >
> > Rename kvm_tdp_mmu_try_split_huge_pages() to
> > kvm_tdp_mmu_split_huge_pages_log_dirty(), and rename
> > kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs() to
> > kvm_tdp_mmu_split_huge_pages_cross_boundary()
> >
> > ?
>
> I find the "cross_boundary" termininology extremely confusing.  I also di=
slike
> the concept itself, in the sense that it shoves a weird, specific concept=
 into
> the guts of the TDP MMU.
>
> The other wart is that it's inefficient when punching a large hole.  E.g.=
 say
> there's a 16TiB guest_memfd instance (no idea if that's even possible), a=
nd then
> userpace punches a 12TiB hole.  Walking all ~12TiB just to _maybe_ split =
the head
> and tail pages is asinine.
>
> And once kvm_arch_pre_set_memory_attributes() is dropped, I'm pretty sure=
 the
> _only_ usage is for guest_memfd PUNCH_HOLE, because unless I'm misreading=
 the
> code, the usage in tdx_honor_guest_accept_level() is superfluous and conf=
using.
>
> For the EPT violation case, the guest is accepting a page.  Just split to=
 the
> guest's accepted level, I don't see any reason to make things more compli=
cated
> than that.
>
> And then for the PUNCH_HOLE case, do the math to determine which, if any,=
 head
> and tail pages need to be split, and use the existing APIs to make that h=
appen.

Just a note: Through guest_memfd upstream syncs, we agreed that
guest_memfd will only allow the punch_hole operation for huge page
size-aligned ranges for hugetlb and thp backing. i.e. the PUNCH_HOLE
operation doesn't need to split any EPT mappings for foreseeable
future.

