Return-Path: <kvm+bounces-70325-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GPQMBbynhGmI3wMAu9opvQ
	(envelope-from <kvm+bounces-70325-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 15:22:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 61704F3E7D
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 15:22:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 23E19303A6CB
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 14:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 663ED3F0752;
	Thu,  5 Feb 2026 14:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="dBYGQPPv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f66.google.com (mail-qv1-f66.google.com [209.85.219.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586F53D903C
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 14:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770301274; cv=none; b=Vc3eXP7elKfgPkDFTWj8uoVPAf+8QxQZ7cyyW+QAp5xGCYPf42qtJxg3qzmofVc3yQiLKXgflzc6NcaAnzH2kPMnibb4y7Ko7h1mR5Wh8zv30vnibEHVIk74t53A2NOjJq0MQIvdNvGi1/0t/1Fb8jFrXy4oSgDRJdp21A5YQzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770301274; c=relaxed/simple;
	bh=2XDmVAyyw3kHSva2SZjpEPftSjaLFto+qTX6dWpgwkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B+S9sbQNCMk4PN2s/KYhWZIAXnjxmg43l9quQczuryFNlRNo8tLldX3Zwuxcll5mbrFbrRW7razE8PlnI+K9Ip3vBIivZHiGfJie8oJOtUwnYfAwtfrs4MYE1CmVfjDQYA2emn1We3hRTBNUMh2bKPZn1aWGjts7Cg5NCMPhZNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=dBYGQPPv; arc=none smtp.client-ip=209.85.219.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f66.google.com with SMTP id 6a1803df08f44-89505dd3e24so13863626d6.1
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 06:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1770301273; x=1770906073; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MSUoQMJoCCNydU2DcwMWqdKRWnt0MqAVvIGN6ESmMGo=;
        b=dBYGQPPvUly5VvEqhvl2u7nK0k0qRi4RMkSn5JaxEDU2nUWmV8/KnZlR4swFyjFACU
         4LTMGns51pld42g426iHpFALujuMgFaW6Dmzu1qZzxekH0GxRDte3EoDkhGRtYD0dqwN
         9aResQfBpcjtt7jkIB1l1DJS0yS+k9v17AT4s4+TB5BUpbvADfxAumefJFkmMFluAg/D
         H2yovYYLsqxkNa9DeEp5HRmuiPqDFmfxnIC5He88AYqfjdb7tdBceXzby7SF7J35qG3B
         xpD2/m2gMonD/zuUz99DDpkKhlpEEB8TU5O5FLSbNZ1MWKvdvaByduuDaOgoCLIMRJdH
         nDSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770301273; x=1770906073;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MSUoQMJoCCNydU2DcwMWqdKRWnt0MqAVvIGN6ESmMGo=;
        b=Nw23L1GcaxmcJWe05qSMe0vX3FKSRgOkeyJhiR1KNvgveo12JHYv4BlDXD1tD6x/WH
         32ZUg9sFEXYB5pypaDeq/JdikWP8diB1kfiqG7Gqj0bX0aBhGpCEnV1qIXC41cQNZ5PF
         ysBaeVJ4Ug3lX+/xHuI0nRB4B/mETL1MD6SIhWLzXQm3ZPPZEuxFo+1PT2/0d6vf9reC
         btOnybLv+YIX7cpN/0jl7ENgOxAGPj6disNPj36ywM5FvpF68EZsnpScvGGQULz9DXRV
         WoyFvfOfV+DoeJNEgSFfNyKoqRiTRFChBLI4AaoJRcZAZ7OIsvHve2ENFuz37/zESkB3
         1P6w==
X-Forwarded-Encrypted: i=1; AJvYcCWJvrlhqu96STZwG8k1zvCcizgqtyAZXw1Jv8fJqHgGjTP8HWyTVWkMftCFsuV1+aTCgpk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFpKSuQQ7qTGaNCSky+d6XUB+4OgK0apTEmUGJ/loqwiQIPHkv
	YDDIdzzN8l03Vc8svkrvU1w0g7+r0idgpAtI0trJGxfFfYrKStmw73BTZsGJZRFlKqI=
X-Gm-Gg: AZuq6aLNY4D5qlsNrYz2xbanYoTOcCwoO7g0dNb+jGT3T7uEFoo9RmUu2GHFqfWF9Be
	d7fRA+mrCKsoiVycT++EhloiEPiNNt7RfSZ3E10CT/btpyjLtCHPpVsoXt/RpOAm4NDdiKVwV/C
	lIQue81VcX1RatlaUPVh6+qCps8Q0JrYGUfo6+xShrGmVpST02/7KiPmEto0y5/IHDzP5lPQKk1
	sJjJD3ndKQAKsLZM6QBlK2GSex3w1p2PX5RPs5AHnD9fAJWm2cWWrS7CZyceWu9S95xWsRunMAt
	U0jNr6nEXXyhaWTCL1dudeHgpeV1rD38FS6NViDxYGiWWo0FKtu15NfmiqqeuYMFf7HrrG0stNP
	moUf1uDIbOokaT5PSsg6otkLKZ6RUV7vn4+yqy+Hj2KAzN+xJKykS6sK638WhOf3kbb3EvuWzqv
	AC8z3hRWj43K3ScK4EoKI1t8SdzwJG5dLYb2AhbOlX/tRPT9Tt+zmULr1NCDqrd0GX7Zs=
X-Received: by 2002:ad4:5cc6:0:b0:88f:ca72:6ae8 with SMTP id 6a1803df08f44-89522189787mr84672066d6.45.1770301272999;
        Thu, 05 Feb 2026 06:21:12 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89521bff53esm42252276d6.8.2026.02.05.06.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 06:21:12 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vo0EJ-00000000kPY-3gpa;
	Thu, 05 Feb 2026 10:21:11 -0400
Date: Thu, 5 Feb 2026 10:21:11 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>, Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>, Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v7 7/8] vfio: Permit VFIO to work with pinned importers
Message-ID: <20260205142111.GK2328995@ziepe.ca>
References: <20260131-dmabuf-revoke-v7-0-463d956bd527@nvidia.com>
 <20260131-dmabuf-revoke-v7-7-463d956bd527@nvidia.com>
 <fb9bf53a-7962-451a-bac2-c61eb52c7a0f@amd.com>
 <20260204095659.5a983af2@shazbot.org>
 <ac33ad1a-330c-4ab5-bb98-4a4dedccf0da@amd.com>
 <20260205121945.GC12824@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205121945.GC12824@unreal>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[amd.com,shazbot.org,ffwll.ch,intel.com,linaro.org,gmail.com,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,8bytes.org,arm.com,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	TAGGED_FROM(0.00)[bounces-70325-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[ziepe.ca];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[ziepe.ca:+];
	RCPT_COUNT_TWELVE(0.00)[35];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@ziepe.ca,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,anongit.freedesktop.org:url,kaspersky.com:email,ziepe.ca:mid,ziepe.ca:dkim]
X-Rspamd-Queue-Id: 61704F3E7D
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 02:19:45PM +0200, Leon Romanovsky wrote:
> You don't need any backmerge, SHA-1 version of vfio-v6.19-rc8 tag is the
> same as in Linus's tree, so the flow is:

I'm confused what is the problem here?

From https://anongit.freedesktop.org/git/drm/drm-misc
 * branch                          drm-misc-next -> FETCH_HEAD

$ git show FETCH_HEAD
commit 779ec12c85c9e4547519e3903a371a3b26a289de
Author: Alexander Konyukhov <Alexander.Konyukhov@kaspersky.com>
Date:   Tue Feb 3 16:48:46 2026 +0300

    drm/komeda: fix integer overflow in AFBC framebuffer size check

$ git merge-base  FETCH_HEAD 61ceaf236115f20f4fdd7cf60f883ada1063349a
24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
$ git describe --contains 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
v6.19-rc6^0

$ git log --oneline 61ceaf236115f20f4fdd7cf60f883ada1063349a ^FETCH_HEAD
61ceaf236115f2 vfio: Prevent from pinned DMABUF importers to attach to VFIO DMABUF

Just pull Alex's tree, the drm-misc-next tree already has v6.19-rc6,
so all they will see is one extra patch from Alex in your PR.

No need to backmerge, this is normal git stuff and there won't be
conflicts when they merge a later Linus tag.

Jason

