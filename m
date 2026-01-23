Return-Path: <kvm+bounces-68943-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OIyNOp3AcmmxpAAAu9opvQ
	(envelope-from <kvm+bounces-68943-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 01:28:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 462556EC5F
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 01:28:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F3705300953A
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 00:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 837003115BC;
	Fri, 23 Jan 2026 00:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FT0gGuZ3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931B1322A2A
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 00:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769128077; cv=none; b=ACo2dY0rK9YIaJGrb7OUH6kIGjorLik+8cSgY2bf5+EP3BQXke12CsBYCVsx0JguWSC9v3+46392U/nM4EHXFCC//L6aysn5gJRjSj4FVJY5QqdelOTBJpVF1AXJ7vhyx42y20n2Tm03C/G93FwqfMJy1cMjbNpt/lYzuODg4M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769128077; c=relaxed/simple;
	bh=CX/Mi64QO8J8pI3rVoDB4cSZ0vo5OgmB89Hew8LDtWc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hcYM7B2PWuvcITF+KSfWTBQhI0S3/qQnlusNhrrUh89RdwflLQpGEYCBPW5QnU/+CNNWdlC5YVhyEdemXuiq9ecB3Svo5UkJ0M7nzZpeaubUAm42bfzbd1uQ34RzgogVUXIgEuaQ6pfvc2bQZzMHWHycGwoPx2lPmp3/VQuwQOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FT0gGuZ3; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a08cbeb87eso16719095ad.3
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 16:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769128064; x=1769732864; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OVtIIEz/2p/DaoNzout/fwLsF254wkNGmXV6Fgcz1ww=;
        b=FT0gGuZ3R1xfXG9o8Xv7Hcbc9pR91LVqy12TcUzs6EDJ5//gNSK4Xgcg0caYNMM80+
         5FXp4T6kQlVZTVqkXl2Zxf8+bWuIjcgqC4isTXh2vobFPjUerEdxGYj58LPnFWh2jT63
         ORS6RlUWLfPUo0A5kVAiJsPU21BqAuhC5QSxgOWIs5LmTGNPVrlUCKGCZuLVzRG4HCMG
         AwyhATGCV6LRsMIUqYuUIK21bWC4xGOELEfa74BKpjsegJuZU4Hq/dLrrLoq5lVej2ta
         z4r+j4ViL6/yHFgpDk5pmnm3J4CBtnnsJ7LmM1Vtf4BCJ6poVfSfCRN/LpTyNdzxImp0
         wYLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769128064; x=1769732864;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OVtIIEz/2p/DaoNzout/fwLsF254wkNGmXV6Fgcz1ww=;
        b=LaUhgD4fL8tWfiHP6srL7h9tHe5bm5xM5ml2qo4N2CXrMnZtJbwp94KVTbMXNN5sch
         eFCGZ1QHhr9h0DmmKfmkXjoKLDjOdsA3kQpkn42EiBVlHWK64l/4AoORNGUTzKjFBzSo
         wyskYth5GkJYgH/ZM+QByNa6Y4pOawyn+/zpNDK6V97FOCciqt/jM6KinKv9QWbxZvR+
         k6RNGBvYhsR8BiV/k69Y5IIfhtdUpOrQ5uUEECERomO8fAjpzLWmWafW4CkYIEJIQ4zw
         /AqPwHX3u0NNWNDjda8CXLtKoZfEGcjW/EL9YmFEFRCrW9QW/L7alahhSzM9+yjxqJCa
         eAEQ==
X-Gm-Message-State: AOJu0YwkaqTB8mt0exA1EocLOPnP/rgESXyNofpvhE63IeAy/HdfeoaH
	m3wkATbrur2khTRzkgL91pHs0hrv63hHhWVf2tlkfxatC3DlNmNhNIlWJB6o0feD8up/PzesxAt
	7YtWONg==
X-Received: from pjbss8.prod.google.com ([2002:a17:90b:2ec8:b0:34c:2ca6:ff3e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1602:b0:38b:e430:156f
 with SMTP id adf61e73a8af0-38e6f714396mr1115096637.20.1769128064100; Thu, 22
 Jan 2026 16:27:44 -0800 (PST)
Date: Thu, 22 Jan 2026 16:27:42 -0800
In-Reply-To: <20260120234115.546590-1-someguy@effective-light.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260120234115.546590-1-someguy@effective-light.com>
Message-ID: <aXLAfjpWwNLNv7pP@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: move reused pages to the top of active_mmu_pages
From: Sean Christopherson <seanjc@google.com>
To: Hamza Mahfooz <someguy@effective-light.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
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
	TAGGED_FROM(0.00)[bounces-68943-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[effective-light.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 462556EC5F
X-Rspamd-Action: no action

On Tue, Jan 20, 2026, Hamza Mahfooz wrote:
> Move reused shadow pages to the head of active_mmu_pages in
> __kvm_mmu_get_shadow_page(). This will allow us to move towards more of
> a LRU approximation eviction strategy instead of just straight FIFO.

Does this actually have a (positive) impact on real-world workloads?  It seems
like an obvious improvment, but there's enough subtlely around active_mmu_pages
that I don't want to make any changes without a strong benefit.

Specifically, kvm_zap_obsolete_pages() has a hard dependency on the list being
FIFO.  We _might_ be ok if we make sure to filter out obsolete pages, but only
because of KVM's behavior of (a) only allowing two memslot generations at any
given time and (b) zapping all shadow pages from the old/obsolete generation
prior to kvm_zap_obsolete_pages() exiting.

But it most definitely makes me nervous.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3911ac9bddfd..929085d46dd7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2327,6 +2327,16 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 
        if (collisions > kvm->stat.max_mmu_page_hash_collisions)
                kvm->stat.max_mmu_page_hash_collisions = collisions;
+
+       /*
+        * If a shadow page was found, move it to the head of the active pages
+        * as a rudimentary form of LRU-reclaim (KVM reclaims shadow pages from
+        * tail=>head if the VM hits the limit on the number of MMU pages).
+        * */
+       if (sp && !WARN_ON_ONCE(is_obsolete_sp(kvm, sp)) &&
+           !list_is_head(&sp->link, &kvm->arch.active_mmu_pages))
+               list_move(&sp->link, &kvm->arch.active_mmu_pages);
+
        return sp;
 }

> Signed-off-by: Hamza Mahfooz <someguy@effective-light.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 02c450686b4a..2fe04e01863d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2395,7 +2395,8 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
>  	if (!sp) {
>  		created = true;
>  		sp = kvm_mmu_alloc_shadow_page(kvm, caches, gfn, sp_list, role);
> -	}
> +	} else if (!list_is_head(&sp->link, &kvm->arch.active_mmu_pages))
> +		list_move(&sp->link, &kvm->arch.active_mmu_pages);

As alluded to above, I think I'd prefer to put this in kvm_mmu_find_shadow_page()?
Largely a moot point, but it seems like we'd want to move a page to the head of
the list if we look it up for any reason.

