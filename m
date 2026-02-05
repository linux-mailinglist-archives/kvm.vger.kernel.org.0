Return-Path: <kvm+bounces-70277-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KAg9AQ/og2n+vQMAu9opvQ
	(envelope-from <kvm+bounces-70277-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 01:45:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D211ED7A8
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 01:45:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8A60E3015A45
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 00:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC4D620B810;
	Thu,  5 Feb 2026 00:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Motz5LYa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B691F3D56
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 00:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770252289; cv=none; b=OvDplV7C/ckhZb7UyLLrM1pTxXk7CnEQ6U7im0pak6EoPG8SS7aynq2BwGTukqxGokqyfHYMt7bFqLcjTOuFxsH0RVEOzbr3GvLA8qxh0/dkte7BAw95DoUkyQI4lkaOa0u+qxD99WQwIRl4oVl6hcnc59A2X+kTTo1riGrA8Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770252289; c=relaxed/simple;
	bh=jO3Jwm2KiKdSu8Jv9EN/PwOxib3l+zG8Z4mHgFnEgL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gAVy8U1moMkDUchqkEJ1cK9IfBJbmH/4U1U5Nvl7cAFljlR4TgruJ3i1I832idNWMavZp2QPHzveFPHSTTozDpk9PyfVy1+iUQUM+1phHDwm+jDFj3uNIsa1YpMl/OBDeRESgXqr0AuS+2/mfelTeARJWJs4V23VhKF0MfCXW6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Motz5LYa; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-823f9f81da5so178335b3a.1
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 16:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770252288; x=1770857088; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NgWY2vdi8HpBdpkbmGT1z+sBzaTWvvRCihF3HMdUYOU=;
        b=Motz5LYa+guXCNEC74Qos8U7OAUXNyZXkvaweFeTyD/aQgoEkdeqo7jlz7o1bbO8ra
         cL2o5kYvNz+k5JV5fTcD5A5R9eVVjRc4QXgqKqUo4TjDldPl11/xc7mW9glAJhdZuFz7
         Sa8kqIR/6HUScv4DKljAwIwnJEqw4dewmhyqHEHqYz955Wub0/FJNx9Z9Ftn3CfrsAOb
         tOePn1IPlbUhu6UQMwY2g27DjWalm95GSHyGZGA77bS1i6nCDAY7/ce01ejjfgP56ayB
         Zn7hZenuN5fKPlTmCKl12h2v9MmpGYTyFxNF+JRtecv2+VPH4dSnOUJLTVLQvy3i3HOg
         ipyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770252288; x=1770857088;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NgWY2vdi8HpBdpkbmGT1z+sBzaTWvvRCihF3HMdUYOU=;
        b=muIGwZkMrN5+vkaP/hbmKtqtVTGorWzxSfBRhPegvMyTrvQ0NRKf/PuD+thXO3tfOR
         74gnDrevFsSOiaJ7ySEQQZc+JEIsCZN8P8PVPNKzNw1vxKT6xQ2KWBSpuEkq7+zLr9cg
         kGU0PTQQlHlEVp6lb6vOjU5dgJfaFJUcTf+OEg3LdfOWQjiTDKRcTRinZGL1v+osr2T8
         pGXBBOB9GyZyH7o/r/yaQWkGUX99pwOkMkGaPckMyxStH6W2VG/2iH5NQbzfbE1bL9Jp
         tIEwf3IL+iXGrORLfHHPT+2aRsWjluvL3XILRtmw0mPquZduhHOEu+vcdD4VgS6ll6mb
         GNKA==
X-Forwarded-Encrypted: i=1; AJvYcCXHrXKYMGg9VsSaVIWIWHjz7TSfV1hmHmpmILXZauQApd4t4hiAirJEFgx1EkKNIGwQz7w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgEccIcr5e1ng0uP7+2oSLhtuSHWXdy2eJp6d6mrZGohcA2L22
	vA4kirYK4WmKSj91HNx8qt1KoIPwGl+jf7ZW3MWA0OrMyVrr+o/PrfKMXhtpxNIGrA==
X-Gm-Gg: AZuq6aKK9sR6KVBw43+fSwxATgUrfGHqjkQuHBK1nYg70IkxF7TR7dOtb8jOQ3YcdK8
	DxrVhlj8EeYuaFtHhDTpAE/ggdIdS+FQC+7M+WfwL1lQjlRe9TS8C+XA3JGI/TPYx67n5c+qR2X
	745u1dvMjghVXXP5xzZ8gMQr8L4An4lOegLOh4DVU+fX7gPD1kwQI0tgPR1mJzViiw2sGPQGWIU
	SJeROXVG5vUYK2KGVMX+i04JTaibHBt8CTma0+PYvY2aRbwn5YkritNX0qHK4We+gox/WtHrYAf
	p3MH/Ni/IRzl3hAwOYzFgi3EuJS0Ka8mUX1QDIqVCbzt0KUL23qPEeM60wR+ouR7N3LnjKYW9FV
	a6SX/LcPuCmQuaHOSKvAYY6OxxBrSsJ+m8WPDgjjUKN2KidzuzeOYK+Hp8F0yGaH8ITJ3DvKVeb
	J8fI9xfxeKBosTzj1nlzdYMZF0eaA6NpcM4Z4+KcfqTkQmMYUOoA==
X-Received: by 2002:a05:6a20:748d:b0:38e:9d3b:4708 with SMTP id adf61e73a8af0-393723c22bamr4082497637.50.1770252288069;
        Wed, 04 Feb 2026 16:44:48 -0800 (PST)
Received: from google.com (79.217.168.34.bc.googleusercontent.com. [34.168.217.79])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6c8553e6b1sm3166303a12.32.2026.02.04.16.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 16:44:47 -0800 (PST)
Date: Thu, 5 Feb 2026 00:44:43 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/8] vfio: selftest: Add SR-IOV UAPI test
Message-ID: <aYPn-0GkAkYAr24P@google.com>
References: <20260204010057.1079647-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204010057.1079647-1-rananta@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70277-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6D211ED7A8
X-Rspamd-Action: no action

On 2026-02-04 01:00 AM, Raghavendra Rao Ananta wrote:

> Raghavendra Rao Ananta (8):
>   vfio: selftests: Add -Wall and -Werror to the Makefile
>   vfio: selftests: Introduce snprintf_assert()
>   vfio: selftests: Introduce a sysfs lib
>   vfio: selftests: Extend container/iommufd setup for passing vf_token
>   vfio: selftests: Expose more vfio_pci_device functions
>   vfio: selftests: Add helper to set/override a vf_token
>   vfio: selftests: Add helpers to alloc/free vfio_pci_device
>   vfio: selftests: Add tests to validate SR-IOV UAPI

Patch 7 is missing your Signed-off-by tag, but otherwise looks good.

Reviewed-by: David Matlack <dmatlack@google.com>

