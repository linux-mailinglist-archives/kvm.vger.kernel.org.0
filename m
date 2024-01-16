Return-Path: <kvm+bounces-6338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C45682F0E4
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 15:57:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 49388B22A17
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 14:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D238D1BF4D;
	Tue, 16 Jan 2024 14:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mbnDxN89"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0B31BF2D;
	Tue, 16 Jan 2024 14:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE64C433C7;
	Tue, 16 Jan 2024 14:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705417052;
	bh=IDiQ8RIHrZHljn3Kz8/zVIVVFgI/X5qySiqO/mihRjc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mbnDxN89NnCKQf3N0/D0rX5XdcrPa4BtvSdaX+9/WXDUz6pSK2UUUIqVsaBVw/RAl
	 d2ryEtDo1F+Cjd/LTfUHsgIJhwBYm2/cpvyqyQlJqsOXMpDu5UacXvqOyX5dX3x5tR
	 ONsoIzei1KU+nW829AfT5Ba+1S3YjCZRgrVCdu+GT5DSWy2chjTRwux4XKLCucm7EI
	 f18VfUqmq8Ja36FjBeVNwm30PUp9sgEvW+/zokcEkMfB9aHFjZX+Gp75Qpj+wubPbf
	 SHkBEjXv3k0RJHGP9oG7B1rh1HXPxM6rullISIiqYSlw16YIdbtmgQ0ghDmANDFZVJ
	 hn9QrUAOzEEsA==
Date: Tue, 16 Jan 2024 14:57:27 +0000
From: Simon Horman <horms@kernel.org>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: Remove usage of the deprecated
 ida_simple_xx() API
Message-ID: <20240116145727.GT392144@kernel.org>
References: <bd27d4066f7749997a75cf4111fbf51e11d5898d.1705350942.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd27d4066f7749997a75cf4111fbf51e11d5898d.1705350942.git.christophe.jaillet@wanadoo.fr>

On Mon, Jan 15, 2024 at 09:35:50PM +0100, Christophe JAILLET wrote:
> ida_alloc() and ida_free() should be preferred to the deprecated
> ida_simple_get() and ida_simple_remove().
> 
> Note that the upper limit of ida_simple_get() is exclusive, buInputt the one of
> ida_alloc_max() is inclusive. So a -1 has been added when needed.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Simon Horman <horms@kernel.org>


