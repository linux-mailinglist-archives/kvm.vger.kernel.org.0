Return-Path: <kvm+bounces-69356-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EBCnC6lGemkp5AEAu9opvQ
	(envelope-from <kvm+bounces-69356-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:26:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AF26DA6D26
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:26:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4CCF63055110
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 17:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E54AC322C73;
	Wed, 28 Jan 2026 17:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JS6heE0f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171A732142B
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769620029; cv=pass; b=E0E3JWY7mYryFSL68E296HF4sMDKDVPs4KcdfDmIXKLX//aya78T68y1Cr/lkWM9loP/gURG1FM1hJ6axfAvB1jiB2dVl7NbSd13P6AGh2Ak68crQwGMLi2BcWODKEtin5C7PTlCK5YDK8XGnVieybKCb79WCQSNp12/mB9TTQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769620029; c=relaxed/simple;
	bh=gWij/TH8QPr+IwLvH0/2/fUh1RCAU2KJ3dVcD1USFIU=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uY7gw4oGKQQhScaSIqvcHTJnkbRLE8mDiy9DEOZMJVAGN2fyjjeMsMnB46Lgglu0rlgeVSyhNtg/12IHeqsVTqt14gLVdWoXkuqjkjeVFZkgJUZBa+BHv6CkbKv+BHtlAmg4rtg0zktXeC7NDoFi9+TGHA1Yp7LeBAf6D1aYGB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JS6heE0f; arc=pass smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5663724e4daso20095e0c.3
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 09:07:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769620026; cv=none;
        d=google.com; s=arc-20240605;
        b=U5CxsFxaoM/Mrsw9pmyd/ZApy7PoFX3G6qzutpV7Ce6C9Z0BUv18qe10lYh27PG+MS
         o9umhDzQLlX8RjbmIHXglsLQ4C4LXMkbcYMhNvUgc4V+sU/x+dTE5Z/YGu2t4oNeaaVZ
         wO64wOEQBQ/MfWjTu3bx6uptOtLua4PgiXop6b/mvf8ADyrb42FUDle34RmwNa5tN9pg
         nbWeo0MapOxNcVmXNucC/WpWWKwV/RhSjmBwQGWfPx3bUAtXVibLidVdTAfxep0mJx65
         /ofPeytI8XjeJREstH+c3NPMfvjHzgPU8sdlnkS3DTUqsuExAnlupbrunowlVVfh5qPW
         p4gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=hQ2ByvmYGALpHjwu0udZOzYr4BMUegwRg7Tc5bSaMn8=;
        fh=L3tuqOUQBsIBClAsm0jbRNCcpWyrPRHtqEqbeahyvew=;
        b=Tkq9A5nfBQNdmnwZeKWJaKb5cF0cWB27HQ3p7lpRuM8J1O8asXeQBXwh7TYQgMSfl4
         IBvdBsFGeHqN12nZqLxjpRCvcT+jFWGPIl3tWRAMZVAzI7Ofo7CnF+hnFPCWqr4QybO+
         m2gif4hkFNIqhyTt9L38HJn6QTOHRIa8RLzKisqN6wWjEA4Gn0FzVWISbt6Nc9eqCDkr
         6XwZnY5ywEX/dROtWcbuRIrgGNATDN6GrC43hUNBE6SDSTdy5ouXzJBRbPFKqww20CIq
         XgIwrjkOC2dgQZSb+DTOdAss3vmvWH8En+UKdMiGcgNkbZ2hqbheGy/xTkBHIz29dXYf
         T3FQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769620026; x=1770224826; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hQ2ByvmYGALpHjwu0udZOzYr4BMUegwRg7Tc5bSaMn8=;
        b=JS6heE0f4DJMjmBufL78cbbgFc3tXStJhNFZSB7w4D9RdPaRft+59kETp8NXqy5eUt
         yyFGbrPcnCIu3T8hdoXRzuOcfjZkVPjeFrWbcvcFDog9qna8n7ZOYof0xtFYSrPFoTXn
         E57qAMjQVF/kXr6sC18641QtVgsvERg7ITeS7cJEoCvRUbyfuyONLK5OEtiU/w5Z4/ji
         q5HHLFaqIXmT7ti9vqgri4WtDeIor8DY1O1Vb2NJ8rLb8RYbfhTAo1n4Y3g8gDMxQ1m3
         BU/xtpMdz0FfsuubtAJHCoPo+wFYo5VJ/FUR8l0E+RAot+qNqZKUOUEZni16PEhrbaYS
         EcAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769620026; x=1770224826;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hQ2ByvmYGALpHjwu0udZOzYr4BMUegwRg7Tc5bSaMn8=;
        b=n2FqyWJLzHhXIDEvYC8tLETFOf9q/XAY6OHUX0alL1lt66kvIApP5fVhsGLogdRQU5
         Q0yEh+QGsiUrw2hVICrDWSSkh3JUVDL+934X9Ieji74uBVCtbJ6aDUH8WuQm5RXtpY38
         7xW5Wqb/wtuUNnkRljAaKnACk46Lqz+/p4xxqXVIpNY+4bJmMYxs7IOcu1w7VsGuIvUS
         JYy2q8wvAfakp0bSZtPs/uNJeD7L/bP+5MhmVb6YFxPg4IpybYF2yUHYHgZgb1DsFGPK
         d9uTtdylOw+8T51jsf2GRiJOJQDd/8YilFkOAiG9EHJ4f7PgW9va8KXuq13q5Op9r/5B
         Vn+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWKjcSLknVmxQSNUXmWs/xrEvnkjztsaglaXGBUgXZTF8xTXrXudGlJpIT4Ltd+WmuJheA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLQNlzZpg6RjfI+7tfFMyJzC1w4fNfCLfI+N/7866loxLhNNJ7
	MxYKGbyUb/Ia9XkIV5k1aX9EwNoz28jbyZU1vS+rNdCOrAZBrZo5Sf98o83wFcoh3Gs9YuOQzFT
	Swko62T2xwNMVY3FVf2Z2ZJhJAFT7eEZFP1L/ZOcP
X-Gm-Gg: AZuq6aIk4a6v8Z5L7+3XpKsztQXkuG/OXehb+utoB6oMek6DSsoTe3vhglygk6EtAlj
	CcjLZiLsB9ISTaM251MBurFNv0ZqoW3wQyn0e7pe0I9kBtDYJD4cOwLDMnXBbjCE+ICuSveVFkN
	xbND1ubaJmFMDgnY2LBZe8fjtR78QqoBgTwiYBo96O3GtqkCkmcBkDaqrT13WjVlK+70RRJr7Y/
	3VWsa36aVVPh0kziVO9jHS8mLSfLpV9iM3eRf5w1Vo3Ottd9xxOJUzizyR/g87rnKT4NaSqBe7A
	eYwD5dA3xdKvfHmvvA0dijOks26fkQqLHLrl
X-Received: by 2002:a05:6122:ca5:b0:54a:992c:815e with SMTP id
 71dfb90a1353d-56679502f80mr1751301e0c.8.1769620025275; Wed, 28 Jan 2026
 09:07:05 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 28 Jan 2026 09:07:04 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 28 Jan 2026 09:07:04 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ab3f297e-44d5-4f42-aa17-f2e7c135580e@linux.intel.com>
References: <cover.1760731772.git.ackerleytng@google.com> <638600e19c6e23959bad60cf61582f387dff6445.1760731772.git.ackerleytng@google.com>
 <ab3f297e-44d5-4f42-aa17-f2e7c135580e@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 28 Jan 2026 09:07:04 -0800
X-Gm-Features: AZwV_QhaOE_wJlLL_hX7tpT0otF_GVqIj23tN-vGGdhqYGAPjKuSGPxvod54AXo
Message-ID: <CAEvNRgEo2UZ63uv0F7Pv8VfeJipyu82b=Rgiz2gnttdRu9aEPQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 01/37] KVM: guest_memfd: Introduce per-gmem
 attributes, use to guard user mappings
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org, akpm@linux-foundation.org, 
	bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chenhuacai@kernel.org, corbet@lwn.net, dave.hansen@intel.com, 
	dave.hansen@linux.intel.com, david@redhat.com, dmatlack@google.com, 
	erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, 
	hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, hughd@google.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kvack.org,kernel.org,linux-foundation.org,alien8.de,intel.com,lwn.net,linux.intel.com,redhat.com,google.com,cmpxchg.org,infradead.org,zytor.com,suse.cz,arm.com,ziepe.ca,amazon.com,nvidia.com,suse.de,linux.dev,oracle.com,maciej.szmigiero.name,loongson.cn,efficios.com,digikod.net,amd.com,ellerman.id.au,amazon.es,dabbelt.com,sifive.com,gmail.com,goodmis.org,amazon.co.uk,linutronix.de,zeniv.linux.org.uk,huawei.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69356-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_GT_50(0.00)[96];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,intel.com:email]
X-Rspamd-Queue-Id: AF26DA6D26
X-Rspamd-Action: no action

Binbin Wu <binbin.wu@linux.intel.com> writes:

> On 10/18/2025 4:11 AM, Ackerley Tng wrote:
> [...]
>>
>> +static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 fl=
ags)
>> +{
>> +	struct gmem_inode *gi =3D GMEM_I(inode);
>> +	MA_STATE(mas, &gi->attributes, 0, (size >> PAGE_SHIFT) - 1);
>> +	u64 attrs;
>> +	int r;
>> +
>> +	inode->i_op =3D &kvm_gmem_iops;
>> +	inode->i_mapping->a_ops =3D &kvm_gmem_aops;
>> +	inode->i_mode |=3D S_IFREG;
>> +	inode->i_size =3D size;
>> +	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
>> +	mapping_set_inaccessible(inode->i_mapping);
>> +	/* Unmovable mappings are supposed to be marked unevictable as well. *=
/
> AS_UNMOVABLE has been removed and got merged into AS_INACCESSIBLE, not su=
re if
> it's better to use "Inaccessible" instead of "Unmovable"
>

Thanks, will update comment as follows:

	/*
	 * guest_memfd memory is not migratable or swappable - set
         * inaccessible to gate off both.
	 */
	mapping_set_inaccessible(inode->i_mapping);
	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));

>> +	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>> +
>> +	gi->flags =3D flags;
>> +
>> +	mt_set_external_lock(&gi->attributes,
>> +			     &inode->i_mapping->invalidate_lock);
>> +
>> +	/*
>> +	 * Store default attributes for the entire gmem instance. Ensuring eve=
ry
>> +	 * index is represented in the maple tree at all times simplifies the
>> +	 * conversion and merging logic.
>> +	 */
>> +	attrs =3D gi->flags & GUEST_MEMFD_FLAG_INIT_SHARED ? 0 : KVM_MEMORY_AT=
TRIBUTE_PRIVATE;
>> +
>> +	/*
>> +	 * Acquire the invalidation lock purely to make lockdep happy. There
>> +	 * should be no races at this time since the inode hasn't yet been ful=
ly
>> +	 * created.
>> +	 */
>> +	filemap_invalidate_lock(inode->i_mapping);
>> +	r =3D mas_store_gfp(&mas, xa_mk_value(attrs), GFP_KERNEL);
>> +	filemap_invalidate_unlock(inode->i_mapping);
>> +
>> +	return r;
>> +}
>> +
> [...]
>> @@ -925,13 +986,39 @@ static struct inode *kvm_gmem_alloc_inode(struct s=
uper_block *sb)
>>
>>   	mpol_shared_policy_init(&gi->policy, NULL);
>>
>> +	/*
>> +	 * Memory attributes are protected the filemap invalidation lock, but
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 protected by

Thanks!

>> +	 * the lock structure isn't available at this time.  Immediately mark
>> +	 * maple tree as using external locking so that accessing the tree
>> +	 * before its fully initialized results in NULL pointer dereferences
>> +	 * and not more subtle bugs.
>> +	 */
>> +	mt_init_flags(&gi->attributes, MT_FLAGS_LOCK_EXTERN);
>> +
>>   	gi->flags =3D 0;
>>   	return &gi->vfs_inode;
>>   }
>>
>>   static void kvm_gmem_destroy_inode(struct inode *inode)
>>   {
>> -	mpol_free_shared_policy(&GMEM_I(inode)->policy);
>> +	struct gmem_inode *gi =3D GMEM_I(inode);
>> +
>> +	mpol_free_shared_policy(&gi->policy);
>> +
>> +	/*
>> +	 * Note!  Checking for an empty tree is functionally necessary to avoi=
d
>> +	 * explosions if the tree hasn't been initialized, i.e. if the inode i=
s
>
> It makes sense to skip __mt_destroy() when mtree is empty.
> But what explosions it could trigger if mtree is empty?
> It seems __mt_destroy() can handle the case if the external lock is not s=
et.
>
>

Hope this updated comment clarify the explosion:

	/*
	 * Note!  Checking for an empty tree is functionally necessary
	 * to avoid explosions if the tree hasn't been fully
	 * initialized, i.e. if the inode is being destroyed before
	 * guest_memfd can set the external lock, lockdep would find
	 * that the tree's internal ma_lock was not held.
	 */

>> +	 * being destroyed before guest_memfd can set the external lock.
>> +	 */
>> +	if (!mtree_empty(&gi->attributes)) {
>> +		/*
>> +		 * Acquire the invalidation lock purely to make lockdep happy,
>> +		 * the inode is unreachable at this point.
>> +		 */
>> +		filemap_invalidate_lock(inode->i_mapping);
>> +		__mt_destroy(&gi->attributes);
>> +		filemap_invalidate_unlock(inode->i_mapping);
>> +	}
>>   }
>>
>>   static void kvm_gmem_free_inode(struct inode *inode)
>> --
>> 2.51.0.858.gf9c4a03a3a-goog

