Return-Path: <kvm+bounces-69294-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oLWuD3NOeWnFwQEAu9opvQ
	(envelope-from <kvm+bounces-69294-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 00:46:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E96749B7D0
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 00:46:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CF54F302F6B3
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 23:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE4112F617D;
	Tue, 27 Jan 2026 23:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q0aMp+cV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B654B2F3C13
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 23:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769557604; cv=pass; b=iyrIrgJ4YD2ETRyu9Czkgk+rWOVp865rmDHaXu4ViMk53Or4Y7ce2AFZLf/tQFqFVWWs7JJmRp1xSKP+gmfhgQNHf4VeRWTae5hgslbWcqRHAwT6UGsSJRbhB6lRYHW2FAZtJMhyioKpAGog2ok3Y/fuIsfIpXpkoNW7BfjBRhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769557604; c=relaxed/simple;
	bh=vst6t4peh/JV4Zuhoe6fbMyUDr/jcG7JxMjC1bUj/HY=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a9K2DgfCXwlKD3wCeUK2o/FFJS0em9GEtk81rU4p8Ol2AyuaeVJgUIRHhKm+D77kXRU7+mOkHlYYGiAuvf9d/VQalhDcCliZmXlQcEbQX6jvx3bWGg47jjU83L0YWMelmaKdNdqZcAhHrX1ELuJ3hNsuF7TuRuz8RvYX3/AD6vc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q0aMp+cV; arc=pass smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-56636dc53a6so1308794e0c.2
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 15:46:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769557600; cv=none;
        d=google.com; s=arc-20240605;
        b=SIEyRKs6sPsxB2VdtVPyZZDR/tm2+jN72arrTVdaPlJOCAJWCayowdPOvD7Ud5D5HG
         YyaQFbI+sl14wkG7b6jNx3GX/5L+VwmlZOAnQDLzaJ3PxxeYn1PBhE7W67QqHTL7GU1A
         zSqHlUhEiaHevikL+lEB6N4NlkJhumiSj4cPE4mhYXpO221vCQQSFBlZ16XrnD8Ub1sD
         kDrNU9vbCy9fryR6n3yUCogrs5APbqbJZoevLnLHeB/ZLCpsB36xwaamk9J2WwxLcIOS
         banSZKC8QTTDirPwfCJDX5Xldb6KrsSepYxmAv2X3bppz5WnOv0VwwrZk7SWxBkLiMEl
         tRlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=3+EqNzQT9TNRk9U4Wm8Lp51VnBAV17bgK1qxop8j5Is=;
        fh=6ItGIrbuvluW1b9G+WNb+WNU4pF9AiXMBcoEuFgdF4Y=;
        b=Ml91uo8F0kQ2DIpQCXFGtsVMShtflMLATck5ATXLmvzd/uEkbLXxFRKyk9+qaYx0BU
         w1z0ek1hQvDr0ZeUZxFgTTOlpJOqakQIBK0ry9ZumTGYBemM8BIN3F+uEd3K13Uf/ABY
         I+cEtzbYS66ZwWxtdkxPL9G7aTy4Rdlj2NY6ao8mLja+eA8zBkIA8Y3BZkurRBrHMXQB
         LwMtyq23P7H6BRaPanqp3hS7z5T20fisNmH1xFxupvAKS3jPqDH2BmUd1+F9kwsw/QyS
         o94YF7tgNH70wlGNFiXGOccWn34pmEYlkR9jdoScoWPkHjXpPyGE1urNS+F6HX1ct3j9
         kl5g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769557600; x=1770162400; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=3+EqNzQT9TNRk9U4Wm8Lp51VnBAV17bgK1qxop8j5Is=;
        b=q0aMp+cVQgIaUs+GKsnXsbB8/OBQGmUP7zTFWK6YuIMa/8RpGMvXMR/6bZPWJUz+Ax
         u/t64RKqMcpebPRbhQ1M6biN4IVbKs9gzGNSNkMp1uOAxFoKkJ3J2aIai8hAjHoef+oO
         yGAQYLHOusadvqilAz8Cq8+gSfOtTAksoE5xOrb8XOmbpk7FoWeBVa3hH5MKs834fYOA
         CLJ/rTfq30ymSa+kz+gatTy0HfxXCxyYv7Eitpa5Lcrq6+NC0vv4ZfQJ6bRsUKrik2+u
         PKDb6B/ERV/ZDxO60V/G5dT8DoTygTVKTspVy7XBm6gYY5wd3EUNYV8jaV8k+Y2+l26V
         yrdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769557600; x=1770162400;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3+EqNzQT9TNRk9U4Wm8Lp51VnBAV17bgK1qxop8j5Is=;
        b=t7Y4PegjyjMhhcnmrlK19+H1bBhKjAoHbIWKH5LMuUQKMtTLH7oX7DDAHHV5GtnmT/
         V4PMk8ijc6RAVmj6UJT0jZk9BnImI+evgH8BCsu0HDZUd5l2kOpvZmByEISoB/VNd1CS
         g7br5zXySisslLppsu44aPPV9oQzaWZDtLD0maoDnKlKwXKKCBKEV8DYODemqVtv3Znw
         xsi2oF2Q2VVOuS9gL2qAmq+rlxIAG299JqDl3OGs1RQeH0xrrVn9+pMq8DIOw1q5oUPK
         +0XHrRaXdfK7AZCQr/VOkdqu8NjjxEKil5/fHYs9FtD85OzxKMYu956hYbSdc2yWnab+
         nj0A==
X-Forwarded-Encrypted: i=1; AJvYcCUCsen13zAXP2hGqQYBVkZ9e7crDg9MxyXiKwPcQs7b1rYGOs02PE0oyxK8ZLjYrp6l5co=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2a3D+PJMlJWVJkXlGm0Ge76D6IsOM48vl+bDjhQ0MibReS1dd
	puYzvJ/EoKEn2/Iz2krrJ4frlX0FxDD74GOKnziRH7VYhpMno/kT3S5hL9jguSl+W8nefVmXbe1
	0ve2z17ztbxRh6pWPACTM9dhR3h7KINubb6LCCOME
X-Gm-Gg: AZuq6aIQ5sJczx3xOMwN2TvIOp1bZCO8YMhP91NHqpvrPq4gM910TN+HazYfbwt1Ny7
	4bpB5XpE0nXS+sxmZV74dvbmsTkJ6CzOGCoqxhmKrptN3arqH6mhvXkgOzmcHMIj4IJzKikTnCl
	ZdXkUcPOjCD0Qa0in7QAIphMw9+5CbkvSG7dKLlNA41wGwMt1u3eU0e2RKoTI+wv6wSoRcI+FyY
	odO4kNKzBF1l+yWjJY36+eGWk9kv92APIsfOTxyZgR5EFodv4EpyQLpfyHBrKjsV0BWx/CafSK2
	h1FjGsZyBPJXwRv3SSrh1AUzNQ==
X-Received: by 2002:a05:6122:488a:b0:566:36e7:8934 with SMTP id
 71dfb90a1353d-566795c5856mr1161633e0c.16.1769557600050; Tue, 27 Jan 2026
 15:46:40 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 27 Jan 2026 15:46:39 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 27 Jan 2026 15:46:39 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ce78da49-2525-44af-9cb8-301bf6a4658a@suse.cz>
References: <cover.1760731772.git.ackerleytng@google.com> <02aad35b728f4918e62dc6eb1d1d5546487b099e.1760731772.git.ackerleytng@google.com>
 <ce78da49-2525-44af-9cb8-301bf6a4658a@suse.cz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 27 Jan 2026 15:46:39 -0800
X-Gm-Features: AZwV_QjMPyTn9KuYIeoCwzon32JStKYHl7N-mpSbapwuTdPZlfrcWu1xEKHINOw
Message-ID: <CAEvNRgE07d_TaSVpkWO8gMfGgPsP9sBzrqMPCte8PET0THF=QA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 09/37] KVM: guest_memfd: Skip LRU for guest_memfd folios
To: Vlastimil Babka <vbabka@suse.cz>, cgroups@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com, 
	mail@maciej.szmigiero.name, maobibo@loongson.cn, 
	mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org, 
	mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, mpe@ellerman.id.au, muchun.song@linux.dev, 
	nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev, palmer@dabbelt.com, 
	pankaj.gupta@amd.com, paul.walmsley@sifive.com, pbonzini@redhat.com, 
	peterx@redhat.com, pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, 
	qperret@google.com, richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, rostedt@goodmis.org, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shakeel.butt@linux.dev, shuah@kernel.org, 
	steven.price@arm.com, steven.sistare@oracle.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@linutronix.de, thomas.lendacky@amd.com, 
	vannapurve@google.com, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,linux.intel.com,alien8.de,kernel.org,intel.com,lwn.net,redhat.com,google.com,cmpxchg.org,infradead.org,zytor.com,suse.cz,arm.com,ziepe.ca,amazon.com,nvidia.com,suse.de,linux.dev,oracle.com,maciej.szmigiero.name,loongson.cn,efficios.com,digikod.net,amd.com,ellerman.id.au,amazon.es,dabbelt.com,sifive.com,gmail.com,goodmis.org,amazon.co.uk,linutronix.de,zeniv.linux.org.uk,huawei.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69294-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_GT_50(0.00)[96];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: E96749B7D0
X-Rspamd-Action: no action

Vlastimil Babka <vbabka@suse.cz> writes:

> On 10/17/25 22:11, Ackerley Tng wrote:
>> filemap_add_folio(), called from filemap_grab_folio(), adds folios to
>> an LRU list. This is unnecessary for guest_memfd, which does not
>> participate in swapping.
>
> IIRC guest_memfd mappings are unevictable. That should mean they are not
> ultimately added to a list (see lruvec_add_folio()).
>
>> In addition, the LRU list takes a reference count on the folio. With
>
> IIUC the refcount is temporary while being on the percpu
> &cpu_fbatches.lru_add, added by __folio_batch_add_and_move().

Thanks for pointing this out. You're right about this, I misunderstood
this refcounting earlier.

> When flushed
> via folio_batch_move_lru(), the refcount is removed and there's only the LRU
> folio flag that remains. The fbatch flushing can be triggered if you see an
> unexpected refcount increase.

The new plan is, to update kvm_gmem_is_safe_for_conversion() to drain
the fbatch if it some elevated refcount is found:

static bool kvm_gmem_is_safe_for_conversion(struct inode *inode,
					    pgoff_t start, size_t nr_pages,
					    pgoff_t *err_index)
{
	struct address_space *mapping = inode->i_mapping;
	const int filemap_get_folios_refcount = 1;
	pgoff_t last = start + nr_pages - 1;
	struct folio_batch fbatch;
	bool lru_drained = false;
	bool safe = true;
	int i;

	folio_batch_init(&fbatch);
	while (safe && filemap_get_folios(mapping, &start, last, &fbatch)) {

		for (i = 0; i < folio_batch_count(&fbatch);) {
			struct folio *folio = fbatch.folios[i];

			safe = (folio_ref_count(folio) ==
				folio_nr_pages(folio) +
				filemap_get_folios_refcount);

			if (safe) {
				++i;
			} else if (!lru_drained) {
				lru_add_drain_all();
				lru_drained = true;
			} else {
				*err_index = folio->index;
				break;
			}
		}

		folio_batch_release(&fbatch);
	}

	return safe;
}

I hope this is what you meant!

> So it might be feasible to do without this
> patch (maybe it was already tried and there were substantial issues, in
> which case should be mentioned).
>

The patch "KVM: guest_memfd: Skip LRU for guest_memfd folios" will be
dropped from the next revision, and "KVM: guest_memfd: Don't set
FGP_ACCESSED when getting folios" is no longer a requirement for this
patch series.

>> shared-to-private memory conversions for KVM guests dependent on folio
>> refcounts, this extra reference can cause conversions to fail due to
>> unexpected refcounts.
>>
>>
>> [...snip...]
>>

