Return-Path: <kvm+bounces-71353-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EIV3L54Fl2kWtwIAu9opvQ
	(envelope-from <kvm+bounces-71353-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 13:44:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A88515EA63
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 13:44:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 155F03039CB1
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 12:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B5233A03F;
	Thu, 19 Feb 2026 12:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y2XdxYxl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC7D1ADFE4
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 12:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771505040; cv=pass; b=NbAEMIOQ7gm8iCDaxVRWqe5c3NYcTPuDzyxa0L9NxC+qL0lBEBtHvXk79rFFYIRBqA868MTdTkT2IX8Ltbob5cb6iAMV0ONtnu6xaYqUBXwYjlPhepcbHAfKMH7h0GsCRxfv3jDcNV0Bcmfmv2WPeGCxub8OgeNhh8z45ol+Sb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771505040; c=relaxed/simple;
	bh=aes4AHs+AOWhWj2FYmgytAYSf1U9HD0Qri/K8EHmzMk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SznnjMUodRYHhNuhVk2kQ86DSr/elOAKpo5xTVcotcqvOFJVP+f0tKYtNHPeyyzh5GJiRyidWnT+R/tb/Obtek6YEUEEcIBE1fGsEDbVVgZnKXLzrFGnB/Qg+DUwwuKsb8dBE0Skm3qZL0dz7c+Azulq+h5TpLcloLYZTVuS/DE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y2XdxYxl; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5033b64256dso506431cf.0
        for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 04:43:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771505038; cv=none;
        d=google.com; s=arc-20240605;
        b=G46vLbZE4on5+GnhzLR8cEDKtyTBHYNyFui3NEZ6+pbnr2OiVt8SEhzLrN772G4REW
         WzEc+t1KQaHRxZJvDKXdyhCfOpXqZuDYs5URrJKp/HD7CCXhZ/thT+vszYMNoW3Out9a
         IYsNpNEMGRxHMMBdJQcRzfyVkp8p6K9FPkadUa0e9hAkUzamaNfssvWZPvscse1cshPg
         QfDXur+2VlDi2tpvphLxwJjIZN+/FdFmvtOMsWtaotc0d0vL4f9lqgV9+5yKtjlBYAlh
         99Ym0sZyvXwBdYLW9NkprC0jhxu4wx+xOKhc9wc0Nkig9Ahw/f3x9v/wvATCObdiuG5F
         ++8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=o9bs+Ht8G4EwUkix0oJqONw0G8EjLC3MyIbQ69wavOs=;
        fh=cgH2J4qMUFSDEBEMJ82QEUToduYCZ1EuMXfkPFhqlF8=;
        b=ACbeqlQflt1ACqC49awB9xN9niIV7T3tWGwLHSNzKTMLeMruyLQQTpBENBoCrTqwPa
         UHjihq6MkTIwC1Ww0JaUanc8lwNYGp41rMQjf893RVPJ9erkEASvzvAMaNJqiMGw+csW
         Ae4ythJCH4vd6csM1CN4IzhZsjO4tZm3AWK0JYOIL5T4af95P1k7cz8Eog4lCl3JMuj7
         1wHAOF3PJO7goU7gcTf3V4A8DNR8zO2zBhLLp+OUv+kjd2vXQ8sqaFF/AY9McE5EXt8P
         qNC4NF2ZyAw3mvHIdXHDFPqpIn51MV26fr6aswS/T/D4uSxjWbFJaxGjSdIqSlQKHsLW
         luvw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771505038; x=1772109838; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o9bs+Ht8G4EwUkix0oJqONw0G8EjLC3MyIbQ69wavOs=;
        b=y2XdxYxl5B3qEvIH/7EiyUej4zu02zEh9V+uDaCvJARejtyhqCZB8IMShpk9DVW4yg
         DTY+BbcwGWxPF5A4vAA3CZdXqDijVHjcjqmrzK45AiqlGN1BaKNePYguDXF6K9t/X9wI
         siW+NqVc+3yFrf5NvuIj3giYLezlvipPZWL53de5kU/mYRkiOEJX5yGiuvIUFAgjSrkJ
         DCYe77MNFT+sBHoglLREmJpBgpDHFrcfpTqkwuhBuUisth9R9C/dsWdbNnPB8QTh8+/B
         JAuqbx+v247CdBrVHzMIfB7U43HXT4ikfSJpeQ+wEzdYYmP7KAS5KmpLCz3Gc32hMh/q
         Fe9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771505038; x=1772109838;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o9bs+Ht8G4EwUkix0oJqONw0G8EjLC3MyIbQ69wavOs=;
        b=Xb6u0unqY3csUmrtmuF0yn3O8BqU7Ra+PDqJOqFA1QFmPNJ20Ahxxph3cPyMiIDodP
         aolX5ILUY9GGC5S/3unatEwi+IMpo3DuFlQHanGXCsHSmyUQVla8lYstFeCBChUng/2e
         /ayfhpzeYaTab5aIHjlSdJcW1ATcXFNZ/VjnpTOG+a3LB5Ic0xYTbWZEKjQny5Oe+JSZ
         x8tw3GuufqxUN4sy7oUmTjO/Vzw04rPBNXvFxsF/u3JqYMLWJSkpMFEuFdtj8CiMmmY4
         pLj4qbn5Sdv8O+nE4+CbkdVSFmkTyy/y5y+he2W6Pa6UsPd7KQDqpyUlytcPlx48/0l+
         xHvw==
X-Gm-Message-State: AOJu0YwtcB7VBQLKXNsRPhOfR7lXXeGMkEV6kjm+Txc1eqSNx8II9JuW
	1rMUvMXa+6bk8fjUV9Ppz/JnAruIRB6Sk48qNsz9K9g1RrQ5bTRsMaMGBV4q10p2VEyEtKPHBtT
	k6XzJIEVhbY4dxiMkS4lYF+Zg2fiijnCjAqCnH5TO05XCJBGpQUskZepoiy0=
X-Gm-Gg: AZuq6aITeySuujveFfZ2TLJw7o5hdZyC3i4ylKq3bhx/OuVpvcXvCqax1qnT1+pScid
	0gjBKOcvvE8GTuL8PnmfnGtSlbfBlz/PMU2vHC1htScH+umjSvZidaMI4ORXMxf2GEyefKaGB6m
	pCDx1ox1SBWqMcEA123rggtq4vsdcBZ3/t/ENbUlrnuvmWGJxBbQFy2SVmABvZQGLMV+tY9Wetr
	BMZJal/VHTqPXI+qXN7G2n0gVJbk3otYxV7qCHD/WmyavhIi5ZLT/pFwy9hBux7g+m+Z5tsPcMP
	jDwYsY/g
X-Received: by 2002:ac8:7f0c:0:b0:501:4539:c81 with SMTP id
 d75a77b69052e-506f1dbd2e8mr6722271cf.2.1771505037357; Thu, 19 Feb 2026
 04:43:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com> <86ad28b767524e1e654b9c960e39ca8bfb24c114.1770071243.git.ackerleytng@google.com>
 <CAEvNRgFMNywpDRr+WeNsVj=MnsbhZp9H3j0QRDo_eOP+kGCNJw@mail.gmail.com>
In-Reply-To: <CAEvNRgFMNywpDRr+WeNsVj=MnsbhZp9H3j0QRDo_eOP+kGCNJw@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 19 Feb 2026 12:43:20 +0000
X-Gm-Features: AaiRm52i2AVuoNuRooDCBFkBdqWWQyvSpL3Y8tHflFey7_du661FzMtD72y3RC4
Message-ID: <CA+EHjTwax_DW58a-hQ=TtsqbjTbBDBDeGvkL1fcDOnY4B-SjeQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 09/37] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chao.p.peng@linux.intel.com, 
	chenhuacai@kernel.org, corbet@lwn.net, dave.hansen@linux.intel.com, 
	david@kernel.org, hpa@zytor.com, ira.weiny@intel.com, jgg@nvidia.com, 
	jmattson@google.com, jroedel@suse.de, jthoughton@google.com, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, prsampat@amd.com, qperret@google.com, 
	ricarkol@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com, shuah@kernel.org, 
	steven.price@arm.com, tglx@linutronix.de, vannapurve@google.com, 
	vbabka@suse.cz, willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71353-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_GT_50(0.00)[50];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 2A88515EA63
X-Rspamd-Action: no action

Hi Ackerley,

Sorry, but I completely missed this!

[...snip...]

> 4. guest_memfd ioctl flag
>    SET_MEMORY_ATTRIBUTES2_FLAG_PRESERVE_CONTENTS. -EINVAL if kernel and
>    vendor don't support content preservation
>
> Specifying a flag to choose whether content should be preserved at
> conversion-time is the current best suggestion.
>
> What does the rest of the community think of a conversion ioctl flag to
> choose whether to preserve memory contents on conversion?
>
> Fuad, I think you also made a related comment on an earlier internal
> version we were working on. What do you/pKVM think?

Introducing PRESERVE_CONTENTS seems like the correct architectural
approach to me. pKVM fully supports requiring the PRESERVE_CONTENTS
flag on every conversion where data retention is expected. As you
know, pKVM operates at EL2 with control over Stage-2 page tables, so
we intrinsically support in-place state transitions. Requiring the VMM
to explicitly pass this flag when injecting payloads ensures we have
explicit userspace intent without artificially restricting pKVM's
capabilities.

If userspace omits the PRESERVE_CONTENTS flag, KVM must zero the page
contents in software and proceed. Returning -EINVAL would be incorrect
because it would make the flag mandatory, eliminating userspace's
ability to request clean-slate, destructive conversions when needed.
Additionally, software zeroing ensures deterministic behavior across
pKVM, TDX, and SNP. The guest is guaranteed a clean page, isolating
the KVM uAPI from micro-architectural data destruction nuances.

Cheers,
/fuad

