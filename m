Return-Path: <kvm+bounces-70342-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0NF+Fpm9hGnG4wMAu9opvQ
	(envelope-from <kvm+bounces-70342-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 16:56:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B36D8F4D3B
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 16:56:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8F29230490FF
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 15:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D0742B743;
	Thu,  5 Feb 2026 15:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H0mk3Tw1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BB6421F11
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 15:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770306790; cv=none; b=sLgG0JOru3+OSby7JNcSGTN52Va3oZgbM3AUpShDUxMJhWJ3DmXRYqnyyCN4OLvFji+u/FBVsEgLnYxqXk26WK1pbGvJVLizp9hJ5FDesAu3ML9OPvJ2cMb5EeBNuc0ib8oQTeGOyWRS7u9lLFjUBE7by0qq6Tt9WWAKOvtW2Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770306790; c=relaxed/simple;
	bh=YqRD+cKBfYWmS+ctu1ucUed79XYvh05hyJ19wxjDW/s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mhShub7VhLrKm6KMlYJDfPUZKgQTN7lkzmGu5JnZ2p2hrxcC5AKVfXL3gHMrR+CM5gFNb4qm1zZ06OvfuNshvuTW+4woLaQeEbZXxf52d/crw2I8+MYRVYeBM09fzNZSK47CeaymAZRGk/CQDuk8cVEe44VrRdM/M4MQlS7JYIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H0mk3Tw1; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a8c54bbe46so25795405ad.2
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 07:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770306790; x=1770911590; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xcx7wlzL60d1Aa7ekaPBgmgQ/lwDEM/p/AnSieBZ0xQ=;
        b=H0mk3Tw1u+QA7ErrOvMVvvQIyWu9tfC7YKiA+Fx/gcZ8WaHs4tvktlEz8bNkTUyryv
         elLpCrpft9+vsPY7APhwDsBKkmrEXGroWzYfNawexU+6ycvXLtLQh7INMG07P5PFqUtt
         ksMMRtwA1v9mZK3To4heabm7lW7icXlgYpW948e//5UHNIlq8eTj1fq/IfwugphebQlJ
         rhcdJOKww3bu3SoO2HnT7GcWSu+rIel0UIQf15T5sH7KWz6OrpcaZP1o5nFI8v/3R1Ew
         ZauSKHUVXp1fX4DfIV5NJBbnjxhYyRD+rEigjTwKv4ykXlDEPHDu9cmFghIqZ9xQExKp
         lN7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770306790; x=1770911590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xcx7wlzL60d1Aa7ekaPBgmgQ/lwDEM/p/AnSieBZ0xQ=;
        b=eU8OY79oJoaA2nJiGeUPNxupY001mIT7gBcmoTTWnrkKp2IQRkk/ppX+7n3dwAL7AM
         mDTOfHGv4+XG/cm/To+tl4jyRCFxOyMafN8Sj6hOLImZVApzNmt7/3jsMoqC/02PNIoy
         VkRmwYHcFWZS315Wh1TNBZvDe5kuL5fNvZ7zBywduAnsDJxg16IyOevON/YWKDmSFOJy
         wL0UdjaBFEyuLnYe7BaYjk8pDNeqyJBq1GIVdeBU4YhYjc9ay8tAR9A7/P/ZWFG0szAl
         Es/jMLcvkQr3EjtI9cDnoLTTqFEtEHVGka35Df8TeQV1JfTIWMy3x78eSInIC4dWFIIp
         u77w==
X-Forwarded-Encrypted: i=1; AJvYcCU+3vO7nqStjhhaCZFk46Eed0JuUcVqGZBVGygaUpmOcgK5m63I09DsQDijKHRjSbfUgIE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/T+a/QvzVjQ+bEEc4eZROcKN3ob3o1K2ThnviBFpcBPqfoQk0
	Hnt188FCqhPvJx2ALnNAP7vRstxMpp9v2DeBJQaSAYxKld8RUfpiq4TTXr6sPtWyk9kdItAv6tI
	qKxYg1g==
X-Received: from pgi124.prod.google.com ([2002:a63:882:0:b0:bc0:d9a9:8a8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7fa8:b0:358:dc7d:a2cc
 with SMTP id adf61e73a8af0-393720d9943mr8123776637.17.1770306790120; Thu, 05
 Feb 2026 07:53:10 -0800 (PST)
Date: Thu, 5 Feb 2026 07:53:08 -0800
In-Reply-To: <e60e0929-f3b0-463d-8c82-dc9170e401eb@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <aXuVR0kq_K1TYwlR@char.us.oracle.com>
 <aYNaA7Td23xKHoHK@google.com> <e60e0929-f3b0-463d-8c82-dc9170e401eb@intel.com>
Message-ID: <aYS85EsXu_xuQXSI@google.com>
Subject: Re: [RFC PATCH v5 00/45] TDX: Dynamic PAMT + S-EPT Hugepage
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Sagi Shahar <sagis@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70342-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[21];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: B36D8F4D3B
X-Rspamd-Action: no action

On Wed, Feb 04, 2026, Dave Hansen wrote:
> On 2/4/26 06:38, Sean Christopherson wrote:
> ...
> > We can and do have tests and VMM support, but it's all out-of-tree (for now).
> > All I'm saying here is that I'm ok landing the S-EPT hugepage code in advance of
> > guest_memfd hugepage support, e.g. so that we don't end up in a stalemate due to
> > cyclical dependecies, or one big megaseries.
> 
> Does "landing" mean having it sit in some topic branch, or pushing to Linus?

I was thinking pushing to Linus' tree, but a topic branch could likely provide
almost as much value?

> I'm all for getting these hellish dependency chains out of the way, but
> we usually try pretty hard to avoid having dead/unreachable code in
> mainline.
> 
> If it is something you want to do in mainline, we should probably do a
> bit of cross-x86/kvm brainstorming to make sure there's no other option.

I'm a-ok starting with a topic branch.  If maintaining that branch becomes too
costly, then we can always revisit things.  And that would probably be good
motiviation to beat guest_memfd hugepage into shape :-)

