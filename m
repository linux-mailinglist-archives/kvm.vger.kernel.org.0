Return-Path: <kvm+bounces-72654-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oN6pJzCcp2ksigAAu9opvQ
	(envelope-from <kvm+bounces-72654-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 03:42:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 464751F9F54
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 03:42:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 77FFB3043DD4
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 02:42:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 886763195EA;
	Wed,  4 Mar 2026 02:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IPhOHuwC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCA131327D
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 02:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772592169; cv=none; b=RvrZ0zY1mlYadJrW7m/+bCkCtFrib7X272BBLxBQV46Fe1lMzY0L4lEeNxJtTkjlpS3ebhgLk2hrN9Ed0Q39ynBtlGQr3mJrz+WbEmGD6Q8Rdq4OsSLVGyEH+3LXgvpQQlUzrKpHXsKH1a/H69q0hzbEW3JiqXMI6uf01D4xJMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772592169; c=relaxed/simple;
	bh=/XWSBClgiVO9Y8DcC9EFb3ReAwqS4B91iVSCE58gCGI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EFgWXejhRUPVtTic+UaI2RIeutxNZg68uFbxiK7HtqnSlmVj5qDJ+6nTJFPMFgK+D0Qa1qio4mcKbSFs3+Cs98B/EJkjqclj/NUmUOBjprMUhUSAgzoGc+jneov3annsABFCGDfKAB5YHIxQyqYG6WAv+B26LpGw61oRz9kdzx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IPhOHuwC; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7d4c12ff3d5so6592658a34.2
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 18:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772592167; x=1773196967; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W7dycZCW1i0wVXbu5i6p68JSQ3h2ubeTDMrk86ISU5M=;
        b=IPhOHuwCkLxyO4EpVYKpsls/Zk3bTYDr5gDNc4xJLUJDrnHiuJvGo0QgTRDd2+azUI
         pBX7Ba63Ei2YcOW2FGUGqlAj8LqqRwSa//bkEQLtCRavpeOADrrPKjCBZNutxytn4MZ5
         OZEpxGLp1B6KtkZNUZgXw8tl5CEfC5T8MQ7w+9SpgfhFxpzLj3eoi8hJc1EkkoeFRy0L
         2ezE9sDKG9Hh/wv3ayonBYBOaDXBydfLvmECeCULO8nl3pjIka6h2HJdWvpcyBtlmr4X
         mtMWK8GukJd0X04q7jCU4Zap+hsdXVcvrtEXCg3weUaV9cy6+EK1O5kAbAwQ5Nk2xVkc
         c6RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772592167; x=1773196967;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W7dycZCW1i0wVXbu5i6p68JSQ3h2ubeTDMrk86ISU5M=;
        b=h0QHqC3+zr9ripfTB8JPSLhEY+YxqXagQtNFmXPo9YOwEo9xlRJVhRa5uHYF30q1ZZ
         sP1/4k1MnehVz/o/vIgpd4G0/QQ6RAiBDLtut8OcGyYkaKvhoIb0K8K6DEwD6knpFrKs
         /7AmfaFC0eGhq+pS54C7Snb1TxV442sEYmmZAcT5lMnK6bF21PWQHD5b3FTZM2+Ke3KG
         9VAS/Yb7KKXBOEA2pgPXVVY0Kx9R/2UXQ3u1y5ElPmty8GgnzDq4P5lvrbNmdxyCVG6e
         r1L9yKsnlE5yOtu0bfRmdgsTPGo9PqPbhfmJZQr/YatIanX4zzh8Ifgx3DauXD6bquhY
         728Q==
X-Forwarded-Encrypted: i=1; AJvYcCWsvrjEfof8HixgispQbZv0zdP83PKts40HD92DAU8d0HoQ5F94JeW/R18LQ1J2dAEQOSY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7BLo9XRPJ0MW3fIa1nXjkUAQ62gzfn4sAGCV48erhx2CqRh9n
	jNf0neCCFjQlzL1dLAQ8EB0D/v8l4UDz/0a26PfNsWNWlstCqr6QFvod0L7HBmK/EEI=
X-Gm-Gg: ATEYQzxTGA6+URP9nyre4dwt0AlfIThAn1Yj7/zdWawihq1WjdNiykLS2af0CSXNJCs
	HObIlmlFTculBar4EOVyvRSydNUqrUUH8pbwwwPgSLF5UaV2zTtcQ4DmsaGzHZdXrAaoRqTKDcO
	Ad34C8neeLv9o1B0pDYlr0JjRGvih3V74Wo8JSto/G9s964EFRwQpCpMQw4ajK4ahRtVxZDekZV
	7kSO/P9VFHVWvobFq5ok9FEM21NRe4NZRwsDpxlChg9R57hwlWtKS3wxnRNaynYLzVzLG5IZXU5
	uTU60/JehFrtdq+Q50yJkNG/s5YtWyKiAGUw4CYJLnI8asJoL1kC7hOXIqKeE1zPQpFWdoIgOyA
	9QnYeFeb2CB7tbSC9zvbnxfLk3kiLvBgXLVvWSGAVoxRq4wdLNMLaybJTW7qpJLBepG6vV0OKpN
	Oi5TR+T4etDVddsJ1cOwjJHbvM4pviDqF1mpef8PZuWaPvCo6ogWxaXo13sRrQtx6gp+zlXyOsg
	g5c4+1J5Q==
X-Received: by 2002:a05:6820:4a8e:b0:66a:1886:e4bf with SMTP id 006d021491bc7-67b17703546mr346906eaf.22.1772592166871;
        Tue, 03 Mar 2026 18:42:46 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679f2bfee3csm12574800eaf.7.2026.03.03.18.42.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2026 18:42:45 -0800 (PST)
Message-ID: <f8d86743-6231-414d-a5e8-65e867123fea@kernel.dk>
Date: Tue, 3 Mar 2026 19:42:40 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] mm: globalize rest_of_page() macro
To: Jakub Kicinski <kuba@kernel.org>, Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>, "Michael S. Tsirkin"
 <mst@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexander Duyck <alexanderduyck@fb.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Alexandra Winter <wintera@linux.ibm.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Anna Schumaker <anna@kernel.org>,
 Anton Yakovlev <anton.yakovlev@opensynergy.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Aswin Karuvally <aswin@linux.ibm.com>, Borislav Petkov <bp@alien8.de>,
 Carlos Maiolino <cem@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Yu <chao@kernel.org>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Christian Brauner <brauner@kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, David Airlie <airlied@gmail.com>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Dongsheng Yang <dongsheng.yang@linux.dev>, Eric Dumazet
 <edumazet@google.com>, Eric Van Hensbergen <ericvh@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@redhat.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Jani Nikula <jani.nikula@linux.intel.com>,
 Janosch Frank <frankja@linux.ibm.com>, Jaroslav Kysela <perex@perex.cz>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Latchesar Ionkov <lucho@ionkov.net>, Linus Walleij <linusw@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Mark Brown <broonie@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Miklos Szeredi <miklos@szeredi.hu>,
 Namhyung Kim <namhyung@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paolo Abeni <pabeni@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Sean Christopherson <seanjc@google.com>, Simona Vetter <simona@ffwll.ch>,
 Takashi Iwai <tiwai@suse.com>, Thomas Gleixner <tglx@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Tvrtko Ursulin <tursulin@ursulin.net>,
 Vasily Gorbik <gor@linux.ibm.com>, Will Deacon <will@kernel.org>,
 Yury Norov <yury.norov@gmail.com>, Zheng Gu <cengku@gmail.com>,
 linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 dm-devel@lists.linux.dev, netdev@vger.kernel.org, linux-spi@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-crypto@vger.kernel.org, linux-mm@kvack.org,
 linux-perf-users@vger.kernel.org, v9fs@lists.linux.dev,
 virtualization@lists.linux.dev, linux-sound@vger.kernel.org
References: <20260304012717.201797-1-ynorov@nvidia.com>
 <20260303182845.250bb2de@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260303182845.250bb2de@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 464751F9F54
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[linux-foundation.org,davemloft.net,redhat.com,mit.edu,eecs.berkeley.edu,fb.com,linux.ibm.com,zeniv.linux.org.uk,dilger.ca,lunn.ch,kernel.org,opensynergy.com,alien8.de,arm.com,linux.intel.com,gmail.com,codewreck.org,linux.dev,google.com,gondor.apana.org.au,perex.cz,ionkov.net,ellerman.id.au,szeredi.hu,dabbelt.com,infradead.org,intel.com,ffwll.ch,suse.com,ursulin.net,vger.kernel.org,lists.infradead.org,lists.ozlabs.org,lists.freedesktop.org,lists.linux.dev,lists.sourceforge.net,kvack.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72654-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_GT_50(0.00)[85];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm,netdev];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On 3/3/26 7:28 PM, Jakub Kicinski wrote:
> On Tue,  3 Mar 2026 20:27:08 -0500 Yury Norov wrote:
>> The net/9p networking driver has a handy macro to calculate the
>> amount of bytes from a given pointer to the end of page. Move it
>> to core/mm, and apply tree-wide. No functional changes intended.
>>
>> This series was originally introduced as a single patch #07/12 in:
>>
>> https://lore.kernel.org/all/20260219181407.290201-1-ynorov@nvidia.com/
>>
>> Split it for better granularity and submit separately.
> 
> I don't get what the motivation is here. Another helper developers
> and readers of the code will need to know about just to replace 
> obvious and easy to comprehend math.

I fully agree, I had the same thought reading this.

-- 
Jens Axboe

