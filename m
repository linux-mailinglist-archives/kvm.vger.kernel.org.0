Return-Path: <kvm+bounces-5665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DB0E82481C
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 19:23:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81F331F22EEE
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 18:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF25728E14;
	Thu,  4 Jan 2024 18:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TcJTE8z4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BD42C683
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 18:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbeaf21e069so993883276.1
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 10:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704392558; x=1704997358; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bbDN6W21p6F1EYYykal14M3FBVWLwpCqqmiZbB/3IKE=;
        b=TcJTE8z4fFZw6YngnDvt/vBExHe+itRApJaM5qfV3Qs5OBOGkLb30/u0hMa4I3+m8y
         G5fVbAJG7J5ZehQUGVwpM8dc+23488atiBdfwQmI2SSCC9VVggunD3HYNJCD9V9bDrXp
         1t3v5HkIrN6Y6v6mHFhVhjCt59UlOpRlRWb3U3rW0nMljABwCuBlIO/FWYVYSYm1N2bs
         fNM9rMDOb4ZrVS8T7q73AWnKuUAlzNeA1J+YpW8BNeO8bTW9S8qIlS5y5d/q0vDvC9uZ
         7dvg0eW/EZTu+zWoXr1hLw+c8wDVBRtTI0Pkq8JoFdSN7FNQaUdvutWW7atkkSDGgOCx
         lpwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704392558; x=1704997358;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bbDN6W21p6F1EYYykal14M3FBVWLwpCqqmiZbB/3IKE=;
        b=LT31cOGBKSH7y1YNi45rtKgA4b9HQJA67kY82Vr/zZD5Mpgm+bXHJgrGk/H55qzzdJ
         jkF5t5gf160STo5EkmqCgRngIPL2HsS8oO03sXlWt48ilNFp9yn8Ew7mOhFoe/cP4kh1
         twvGAC+bH/AQmuhGPXRTEyDDk3517EjxImbnpLZd6gZIx9bxDxn/jKT9hn5lPyDzlRrI
         9A2KCzwaK5ZZZWYTUwphw2nz+LF9mmi3QnSbz0zUSbnTrR+SIVB0c9vznM2hgx8+Dj50
         YasU4zuE+bLyMFCsq3AEXIl3DoPLycVdz4TGvUTw1SimTzmT7uDrvZsnR9ccEygh2t1r
         f6jQ==
X-Gm-Message-State: AOJu0Yy7p+Kd/ypSDflpraLiyAeywdXWYf2n6IiImNH0MMIMsSZ4pmn+
	PCfyByT0Lu822grtvcMIkPo8LhKyY5wnfEuuVQ==
X-Google-Smtp-Source: AGHT+IEaMRCHGS38DtQMJCrRm/hEwM4m2ug9DEysF+4xs9/4bbCvrTyBUAjUQhP7cnYM4OHndFKWnJ2AyNQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:134e:b0:dbe:a220:68ee with SMTP id
 g14-20020a056902134e00b00dbea22068eemr30231ybu.0.1704392557745; Thu, 04 Jan
 2024 10:22:37 -0800 (PST)
Date: Thu, 4 Jan 2024 18:22:36 +0000
In-Reply-To: <a327286a-36a6-4cdc-92bd-777fb763d88a@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240104153939.129179-1-pbonzini@redhat.com> <a327286a-36a6-4cdc-92bd-777fb763d88a@linux.intel.com>
Message-ID: <ZZbuwU8ShrcXWdMY@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: fix masking logic for MSR_CORE_PERF_GLOBAL_CTRL
From: Sean Christopherson <seanjc@google.com>
To: Kan Liang <kan.liang@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	peterz@infradead.org, linux-perf-users@vger.kernel.org, leitao@debian.org, 
	acme@kernel.org, mingo@redhat.com, "Paul E . McKenney" <paulmck@kernel.org>, 
	stable@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 04, 2024, Liang, Kan wrote:
> 
> 
> On 2024-01-04 10:39 a.m., Paolo Bonzini wrote:
> > When commit c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE
> > MSR emulation for extended PEBS") switched the initialization of
> > cpuc->guest_switch_msrs to use compound literals, it screwed up
> > the boolean logic:
> > 
> > +	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
> > ...
> > -	arr[0].guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask;
> > -	arr[0].guest &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
> > +               .guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
> > 
> > Before the patch, the value of arr[0].guest would have been intel_ctrl &
> > ~cpuc->intel_ctrl_host_mask & ~pebs_mask.  The intent is to always treat
> > PEBS events as host-only because, while the guest runs, there is no way
> > to tell the processor about the virtual address where to put PEBS records
> > intended for the host.
> > 
> > Unfortunately, the new expression can be expanded to
> > 
> > 	(intel_ctrl & ~cpuc->intel_ctrl_host_mask) | (intel_ctrl & ~pebs_mask)
> > 
> > which makes no sense; it includes any bit that isn't *both* marked as
> > exclude_guest and using PEBS.  So, reinstate the old logic.  
> 
> I think the old logic will completely disable the PEBS in guest
> capability. Because the counter which is assigned to a guest PEBS event
> will also be set in the pebs_mask. The old logic disable the counter in
> GLOBAL_CTRL in guest. Nothing will be counted.
> 
> Like once proposed a fix in the intel_guest_get_msrs().
> https://lore.kernel.org/lkml/20231129095055.88060-1-likexu@tencent.com/
> It should work for the issue.

No, that patch only affects the path where hardware supports enabling PEBS in the
the guest, i.e. intel_guest_get_msrs() will bail before getting to that code due
to the lack of x86_pmu.pebs_ept support, which IIUC is all pre-Icelake Intel CPUs.

	if (!kvm_pmu || !x86_pmu.pebs_ept)
		return arr;

