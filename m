Return-Path: <kvm+bounces-19388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67F699048A3
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 03:58:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8A6428560E
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 01:58:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91D968F72;
	Wed, 12 Jun 2024 01:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lZBjx/gT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC388E566;
	Wed, 12 Jun 2024 01:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718157492; cv=none; b=h3O6thv2YYoEV32LcAzRwAOBIDvHc+BYwoAnZnQpKlEtnzTHCRTOUuYbhQWZy/PkDvhSOk2uRH4SfJNxyoLGoJE7cvn8ubR7K9Y0jsxfvUbjjFy+pIO6MewbZFJb2PIkrvFs0akaBsnb77YYEY7W0hd6ANvOzTZJbOWnR07ZDhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718157492; c=relaxed/simple;
	bh=2bnaKdaynOx054pD82xWQVJDxU3JbEDxOintaWbN69s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I7lVTl+3cB7SVH+H3nwLAM0Df2A2jMENf8DbbGAb3WmQnkKnNLjxR8zPLqiyLta7xHRqF1dCteb92cJosWjd+2/qALQ9EYYwRIbaXhckcqL2aZr6YngfajUJWjqPLErYX6uWT5GhItFBUUZRbIdJNmYqU4tpBWLuUoWkwYmxm28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lZBjx/gT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA76CC2BD10;
	Wed, 12 Jun 2024 01:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718157492;
	bh=2bnaKdaynOx054pD82xWQVJDxU3JbEDxOintaWbN69s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lZBjx/gTHx9YKarrC8CvdwhFfBSzSxbGQip/VEVCmFRnPMWL635PuFcqkRgZJA9o6
	 xZt7O0tH6JvN+axGo9BD/RG9hdsVMnU4LIFc4+xp7Ya8f0w1c0nBs8uZKeBw1hO/KQ
	 vZBW6OXTQJRrdu460dZ/Y962uISetM+gYupq07A1+LUPoknCQpDPfUVzf2Ox9wrJQw
	 rDpj0uFoREv52sd8+/s+OuX/fhgl06Hz5XPS8pqM2wBb4jUAtvtwn5wuRNQS66+L1Z
	 cce51eJM25kJNW3YFSk/LpEy+Unmn9KR3ouo4JZK4MdCTgyrvb/JL2gFXBVx6jdpaK
	 Gb6qbKG2XLlRg==
Date: Tue, 11 Jun 2024 18:58:10 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Cindy Lu <lulu@redhat.com>
Cc: dtatulea@nvidia.com, mst@redhat.com, jasowang@redhat.com,
 virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] vdpa: support set mac address from vdpa tool
Message-ID: <20240611185810.14b63d7d@kernel.org>
In-Reply-To: <20240611053239.516996-1-lulu@redhat.com>
References: <20240611053239.516996-1-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 11 Jun 2024 13:32:32 +0800 Cindy Lu wrote:
> Add new UAPI to support the mac address from vdpa tool
> Function vdpa_nl_cmd_dev_config_set_doit() will get the
> MAC address from the vdpa tool and then set it to the device.
> 
> The usage is: vdpa dev set name vdpa_name mac **:**:**:**:**:**

Why don't you use devlink?

