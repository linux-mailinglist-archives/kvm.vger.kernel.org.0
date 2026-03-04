Return-Path: <kvm+bounces-72753-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id v6CIHQK4qGnLwgAAu9opvQ
	(envelope-from <kvm+bounces-72753-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 23:53:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E670F208C82
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 23:53:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4032A302F68A
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 22:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F085394470;
	Wed,  4 Mar 2026 22:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LeBdyAXW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575083016E9
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 22:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772664829; cv=none; b=Tfj1tstGy0IsfwYraJNvD73ebwdxazS8u2IEhWJn99iEyfbi0gHmWRiK5G9KnVtlbihG1zWaVnb4AcNJ68oRZ4yOFfXvMWVgiAptM4AO7CUMRkWZiagxTIL2EGz4SnxhD/nclsN012jSaHaIe7wbzW1hvrfgYD4O+6Lg4tmIZHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772664829; c=relaxed/simple;
	bh=gY2oHabocgLq7QIu9wm2Y3e+Ox74lNNlJ1IsKxSE+Qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K+AN8V6+wAXUmhoy9qiQjYQ9KEVxNF+zS/OpOgoGwXU/QwDd1AM6n9vD+bDvF0AJVRFoGjiD8UaVcWnmZzx8+R3qDAbUeL6/rdWBUYVxjjXPp8Lecdn06y3Z5MhfRshvQMZZY1oAm9eSMG2yd6DzrQZ7EkARWUUaySo9XM4s7wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LeBdyAXW; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82976220e97so644943b3a.3
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 14:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772664828; x=1773269628; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L8eHM5aNTjyRJDFKy4QnyVedRObL8RR8aOfAsHzSyPQ=;
        b=LeBdyAXWhiW0qtYOjl3/U7Blk2PAYpwA9gRnaRsXe/XXaPfcl0MxvGGzmPvZMXDLQH
         n39cr/pTsPKTNT4tTSLW+0t/QzYZDPWLq47TDw+yMh8xKHWECAXCtHJd079bkM/WsXu5
         /6ImTgZ+5KIrn2uY5kp7nZcglx1U0gNVINN2+uVYoteYP06U48B1xp6bWDHTSR7BZp3J
         OAQx9nc66mCp3lA5hhzuzHWY+VNCTxBehY2RHE0zTKAraba7j0uHUXrNAi1EQMknf0JA
         4j7HUEAL0CnGrUx9EqKGhbaOXGNPe4rKVFAHKbZ6iqWtgJPuBBNOP6pqdjbIEfZoDQ7Z
         BxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772664828; x=1773269628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L8eHM5aNTjyRJDFKy4QnyVedRObL8RR8aOfAsHzSyPQ=;
        b=tfiN6FZagUS9zb7Czzlu+r7aCC4brP/HIg8aP8RKp8uZn3/4Xpo9kEXbEAgbnbfAEp
         3GumrH/bakBch7bJ/HqYMF+SeOS43jFAAm3LVCU0uovkg7zSO0mJafFq0sUMLsK6Su8B
         A/7bBsDl85PbKeYYVvFGobhWzIjAn5XJaHAKofuUS3YqvaJb3STHiNyK1+dXgUciC5He
         27ApUrYWFgV727M32vydmJTQtrYctLEF5aSAQz/fcC+fuwyEV+JsqGADpPwAdCQJO1AX
         IDrEhXgFK17U3Yu7f0eDYOYLObPGEdkwqAr9rnGLMIKQbrHMoEDZeKcfXhK6zfDBowWW
         6XWA==
X-Forwarded-Encrypted: i=1; AJvYcCWzRr9hhciCTSTEfmYOP64jZ7Bt1/lkUEmkQLNJ6j3PYpYc5A7NFt1NWJ+YQX0j0qzrN84=@vger.kernel.org
X-Gm-Message-State: AOJu0YycCV1l2hXJqrzAmqrOY4cbLy3CsF5hK7RiqO9sqo2/KzVWO9D5
	qctc1QUbldX0cxEH0rZt80oSt+cZdpyl0Wwwu0/RQGmrMrGTIWuMx7+YGjZVgtmJHg==
X-Gm-Gg: ATEYQzybeyfGKEeELLh/upM76fsmLq9Er1fSeTkDVmmwRuJIUdvWsWatCNdoom2RjJG
	MbI2cnT0ODuaJ76BoGu+Hro+VrB60GQFow+lC8ztTjCp8gcNbMv94n2iW8OqZnn0bkZuAog/4Jt
	umfMY6n88VvvlossAs5qVCrWq7/XOaugV/99lIX1YUxWDit8k93IMmSPFFC2ZoSzVxEfyof5d8s
	v+VdUPXIjWp2NJnFhrHxelciTU3/GXtBnOsiSTGMdMvL39CY6MtHaJCqnObfZO3/1+0Itkv02Sd
	D0WzgfRlwSESrAwuorEnGDJTBDda4cRLCIq6K90ahrE6yWcooBE6uOcujabolY6qHESjLexcdR7
	s68OfdyBqzIEh7flT6jYtVAPeSpkxAl3epqO2R1JIvbnxV9cMlk2OmDy3Wx1DCWF6gU/Aikt1jL
	nudJCdRVRuNA766e01cXGF8KPc0qbRt56D6OFMqV7b42ML3vyrGeoIOZ0dmacAGQ==
X-Received: by 2002:a17:90b:2b4d:b0:359:8de8:121a with SMTP id 98e67ed59e1d1-359a6a4a45fmr4051852a91.17.1772664827371;
        Wed, 04 Mar 2026 14:53:47 -0800 (PST)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359a8f3c23bsm1216444a91.1.2026.03.04.14.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 14:53:45 -0800 (PST)
Date: Wed, 4 Mar 2026 22:53:41 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Vipin Sharma <vipinsh@google.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/8] vfio: selftests: Introduce a sysfs lib
Message-ID: <aai39e81lFkxCBMp@google.com>
References: <20260303193822.2526335-1-rananta@google.com>
 <20260303193822.2526335-4-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303193822.2526335-4-rananta@google.com>
X-Rspamd-Queue-Id: E670F208C82
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72753-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 2026-03-03 07:38 PM, Raghavendra Rao Ananta wrote:

> +	ret = readlink(path, vf_path, PATH_MAX);
> +	VFIO_ASSERT_NE(ret, -1);
> +	vf_path[ret] = '\0';

...

> +	ret = readlink(path, dev_iommu_group_path, sizeof(dev_iommu_group_path));
> +	VFIO_ASSERT_NE(ret, -1, "Failed to get the IOMMU group for device: %s\n", bdf);
> +	dev_iommu_group_path[ret] = '\0';

...

> +	ret = readlink(path, driver_path, PATH_MAX);
> +	if (ret == -1) {
> +		free(out_driver);
> +
> +		if (errno == ENOENT)
> +			return NULL;
> +
> +		VFIO_FAIL("Failed to read %s\n", path);
> +	}
> +	driver_path[ret] = '\0';

These can all write off the end of the buffer if ret == PATH_MAX.

Also there is an inconsistency in these calls. 2 use hard-coded PATH_MAX
while the other uses sizeof().

Perhaps add a wrapper to handle all the details?

#define readlink_safe(path, buf) ({                           \
	int __ret = readlink(_path, _buf, sizeof(_buf) - 1);  \
	if (__ret != -1)                                      \
		_buf[__ret] = 0;                              \
	__ret;
})

