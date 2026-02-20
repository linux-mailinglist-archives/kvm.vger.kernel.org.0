Return-Path: <kvm+bounces-71398-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kBPLGLokmGkJBwMAu9opvQ
	(envelope-from <kvm+bounces-71398-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 10:09:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E9EF516605C
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 10:09:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 84A3D30101DE
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 09:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 911DB31B119;
	Fri, 20 Feb 2026 09:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hKgbwYs7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2ACF31A556
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 09:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771578547; cv=none; b=cZMAD4ZkaRCePvNVt7f8vOJZuCOAm1rpW30uL+1jE57X3WAbGAu4RiPx/Aojfm3avYyhxy4Cr4s5qol1FR/YuuoateVtCVB/0mqv0uRFOQvU/LU1EcYrSzatcz4d0iX15x7l/UF+Q6fuRvnurHU57tRhq+IVf4IYhaZj5Dmh+Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771578547; c=relaxed/simple;
	bh=W/uz2T87r9U3hpaetbdjaYKd/rLTOIiMqSbbCdADBng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mlf1IgqWXs78crP2rzbsff8iLfWuRogGYNcM6ngUAaqYhJ4oeQLJQ2AEqOFQpQQtoMVO6nrud3JdnueHuda0XyEHqjXQCVuscNRgfBifj1N8vGI6L/NPOPha6kQQVBruzI1RgiQ5aVvy2CWtxirhHQaSweduZtTzH4UY0vTWPaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hKgbwYs7; arc=none smtp.client-ip=209.85.214.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-2a76b39587aso73305ad.0
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 01:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771578546; x=1772183346; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7F8WxQjk8Orm8VMuPYwxSvcxytWiyPGbiUS8y914NAU=;
        b=hKgbwYs7MM+uFJzdVuXDs+POHN2edZJITtcmrLqYrhASgH55zat3aLJSefUn+b8flK
         MNWVDa1KwjMkksq6G+AAaq5a+cprpu/SbikcPajEo4UybAtNNtsaSQnpW2QIXgdGOsEA
         +fsqNj62tUUlQ8PVOM8w+eBP9DNEuuu8TEkJi53QPVCYKx7oozRQPp1NNMvJ497gurs8
         Rm+00NX5CG2G/EyPj+PdFV65YHF0FV54H/33pyi/5faYD6UaTUmv6SgwFWX4DGOEBQCx
         K7SeGU73qO8DQEDHs3SOX47cacY4zDzXgHLDYbsbW/+ko6il4FBQ0wIWiu7hcpqCSM0T
         1Ukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771578546; x=1772183346;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7F8WxQjk8Orm8VMuPYwxSvcxytWiyPGbiUS8y914NAU=;
        b=ZN0xaqMDSl8qg8C1iK4cmIG3lJvl9gE01nvbnkTgiu/XSIAE2L1Lt9lBtmFOpiehwE
         HWHlJ7QK1UU429eQ2iqorcq4Wr58FIH1IYRkhpQm2HSzBoIGQ9nfKZ4OmPSr4is0wqDR
         rfcFtAdCQ8bjWsi4/UwkCE3wul4rcE74gyS59AeDnILdOQQHJ9cbmkROxWvp/MZxhbbO
         P5+CtOr7/ybQXOGiZ1lafZP9HkSeVit7kUisnnGB15BHyjI9nMu4oDMK6I0dIjsPjmTm
         NJdNaj0ev8/6H7795RxvAs/re06diiPzNNLKA0qVgQH5BUhh4Sr6N0BXZ0pAlxgrxYzh
         E6Tg==
X-Gm-Message-State: AOJu0YwkHuFaHuhQzEBOvmrV9ei4ilqSX8IvQXpmJVSpe9TsPhtSm+mf
	UPKlZLHDXN51ODifGaKHNoV7MZwAby6Zuwcsvt7D8Ly9SXnGMLFy3e1i318mPFUVSA==
X-Gm-Gg: AZuq6aLLYISC1X5xzCsl5YJ1hwpmTbL/CiqZSkdqLy0eKSABx9DJ9BS1ILo35xgg0sb
	eko65eF8cxa/J6N140VcXI55urpn5khisNdqrZ8aem9rb0/nh/x8UCr6PE+ziDKpL7ifemOrLUs
	qrTlrNrOfH8OSsoKHtbxI3+aWY+2Gv9e/B4S6z1RvulprY4L7PKqOUlBCq74EYfPYjWBlPZ7vl1
	QUzabjhb8QGpgltAdwsmOo6hp2Y/buh62BMegXLd69OF1ImML4VKUrnKTQZF+ck3YY85fQ+vL3P
	wHjKNryKylZul/StPfORvfIF4Mucz6XKXiGLgQGWaYb+hjRiQ5GU8OjjbULGd55lZhq/zcUkBJt
	xVp+0DmahghJ6ImhUZrGSB/DqCCOkM42RoMRmGiA6YsvDNbrpk6TnSKfO1d9OePRjLZv+aHe7OI
	r9c41leI+mnvqc2Jg+oW4xt5jEjmpqD2xDEIfoqXemJ7kdpYRvlaMcXsceHo0=
X-Received: by 2002:a17:902:d584:b0:294:d42c:ca0f with SMTP id d9443c01a7336-2ad69e114ddmr1743575ad.2.1771578545548;
        Fri, 20 Feb 2026 01:09:05 -0800 (PST)
Received: from google.com (249.53.168.34.bc.googleusercontent.com. [34.168.53.249])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6a3e145sm20081108b3a.16.2026.02.20.01.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 01:09:04 -0800 (PST)
Date: Fri, 20 Feb 2026 09:09:00 +0000
From: Lisa Wang <wyihan@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, x86@kernel.org, aik@amd.com,
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, bp@alien8.de,
	brauner@kernel.org, chao.p.peng@intel.com,
	chao.p.peng@linux.intel.com, chenhuacai@kernel.org, corbet@lwn.net,
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com,
	ira.weiny@intel.com, jgg@nvidia.com, jmattson@google.com,
	jroedel@suse.de, jthoughton@google.com, maobibo@loongson.cn,
	mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org,
	michael.roth@amd.com, mingo@redhat.com, mlevitsk@redhat.com,
	oupton@kernel.org, pankaj.gupta@amd.com, pbonzini@redhat.com,
	prsampat@amd.com, qperret@google.com, ricarkol@google.com,
	rick.p.edgecombe@intel.com, rientjes@google.com,
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com,
	shuah@kernel.org, steven.price@arm.com, tabba@google.com,
	tglx@linutronix.de, vannapurve@google.com, vbabka@suse.cz,
	willy@infradead.org, yan.y.zhao@intel.com
Subject: Re: [RFC PATCH v2 00/37] guest_memfd: In-place conversion support
Message-ID: <aZgkrJv3FeQCZ2DG@google.com>
References: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71398-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[wyihan@google.com,kvm@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_GT_50(0.00)[50];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: E9EF516605C
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 02:36:37PM -0800, Ackerley Tng wrote:
> (resending to fix Message-ID)
> 
> Here's a second revision of guest_memfd In-place conversion support.
> 
> In this version, other than addressing comments from RFCv1 [1], the largest
> change is that guest_memfd now does not avoid participation in LRU; it
> participates in LRU by joining the unevictable list (no change from before this
> series).
> 
> While checking for elevated refcounts during shared to private conversions,
> guest_memfd will now do an lru_add_drain_all() if elevated refcounts were found,
> before concluding that there are true users of the shared folio and erroring
> out.
> 
> I'd still like feedback on these points, if any:
> 
> 1. Having private/shared status stored in a maple tree (Thanks Michael for your
>    support of using maple trees over xarrays for performance! [5]).
> 2. Having a new guest_memfd ioctl (not a vm ioctl) that performs conversions.
> 3. Using ioctls/structs/input attribute similar to the existing vm ioctl
>    KVM_SET_MEMORY_ATTRIBUTES to perform conversions.
> 4. Storing requested attributes directly in the maple tree.
> 5. Using a KVM module-wide param to toggle between setting memory attributes via
>    vm and guest_memfd ioctls (making them mututally exclusive - a single loaded
>    KVM module can only do one of the two.).
> 
> [...snip...]
>
> 
> --
> 2.53.0.rc1.225.gd81095ad13-goog

I’ve tested memory failure handling after applying this series and here’s what
memory_failure() does:

Shared memory: In line with other in-memory filesystems, the memory_failure()
handler unmaps the page if it is currently mapped, and issues a SIGBUS
  - if memory failure was injected with MF_ACTION_REQUIRED or
  - if the test process’s memory corruption kill policy is PR_MCE_KILL_EARLY

Here’s the above, in table form:

| MF_ACTION_REQUIRED | Kill Policy         | Mapped | Dirty | Result: SIGBUS |
|--------------------|---------------------|--------|-------|----------------|
| false              | PR_MCE_KILL_EARLY   | true   | true  | true           |
| false              | PR_MCE_KILL_EARLY   | true   | false | false          |
| false              | PR_MCE_KILL_EARLY   | false  | true  | false          |
| false              | PR_MCE_KILL_EARLY   | false  | false | false          |
| false              | PR_MCE_KILL_LATE    | true   | true  | false          |
| false              | PR_MCE_KILL_LATE    | true   | false | false          |
| false              | PR_MCE_KILL_LATE    | false  | true  | false          |
| false              | PR_MCE_KILL_LATE    | false  | false | false          |
| true               | Any Policy          | true   | true  | true           |
| true               | Any Policy          | true   | false | false          |

(I used MADV_HWPOISON to inject memory failures with MF_ACTION_REQUIRED set, and
there was no way to use MADV_HWPOISON without first mapping the page in. To
inject memory failures without MF_ACTION_REQUIRED set, I used debugfs’
hwpoison/corrupt-pfn.)

Private memory: The handler unmaps the page for the stage 2 page table and does
not issue a SIGBUS - the page is never mapped to the host, since it is private
to the guest.

| MF_ACTION_REQUIRED | Kill Policy         | Mapped | Dirty | Result: SIGBUS |
|--------------------|---------------------|--------|-------|----------------|
| false              | PR_MCE_KILL_EARLY   | false  | true  | false          |
| false              | PR_MCE_KILL_EARLY   | false  | false | false          |
| false              | PR_MCE_KILL_LATE    | false  | true  | false          |
| false              | PR_MCE_KILL_LATE    | false  | false | false          |

(I couldn’t use MADV_HWPOISON since private memory could not be mapped and hence
will not have a userspace address)

I’ll post updated memory failure tests together with the next revision of this
series [1] to fix MF_DELAYED handling on memory failure.

[1] https://lore.kernel.org/all/cover.1760551864.git.wyihan@google.com/T/


