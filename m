Return-Path: <kvm+bounces-50421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8856DAE5323
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 23:50:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4168118953E7
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 21:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DC71224244;
	Mon, 23 Jun 2025 21:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mw5zu5+A"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1FB1EEA3C;
	Mon, 23 Jun 2025 21:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715414; cv=none; b=lBdYdUhqeviSgNHPvg6fJw1lPyhIxFxOXhelLWaDc/nLD2ImN7Z8l6Igg4HAwmtFvx2/1EZAINMJJ6A5DJ7rNeeeg/iP7PkgSe479Xft2I1CD4vVIjuzXPR4v0nwlkBRo0BQ8T+VLGo51AqTmOs+mz0PcpKHl/Oiljk4enczGpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715414; c=relaxed/simple;
	bh=5eVqVme+e7aQ3gVGvjfN7rOHnf5VdX+dnTkswS9KJc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q3Jo5i0geHbhum9hZafykYtg31SebeeCvovzNHyCL7ZvArxEi6rrIDzHrBGmUZxjGrQk7FxzLW7kmvqLh4kPufoSXz4L9PTd11t6P+xrEcBQASkipC0RyMa9EnYwkeiWpKfygM9O6yJtM8V0LaSZHNDMM6mkbSJCFUqfSx8Y2Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mw5zu5+A; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A860C4CEEA;
	Mon, 23 Jun 2025 21:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750715414;
	bh=5eVqVme+e7aQ3gVGvjfN7rOHnf5VdX+dnTkswS9KJc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mw5zu5+AnwGUyKoKbxqsnqeqPxB5wtO6DTy+QD6HjwraTFOF+c3nhTKFes5J6rWxK
	 cU7ZuqKB4Ui3spYQ4UzGDGkV6rMmnFaQezYzAkN0ST+8MbrLyMPNP/Ww4AjKz4bcDB
	 rnh7aXUsgYNdKOI3i0ijOkL4wLanHRlyQVfys4EYAE3W3/1M5seS7eNRNLIcjtdKvh
	 wGpDDhhAk3BWsiBQmFpLGhxGJWJGHVmFlu3jxpGnqSgMJc/LpSemANGb0Z6a6hIWCo
	 SQpTD4opKNpQFRu5Q/4b3l3m39i7BhJNkOan+5g7Axhg+5o5DMmw8YxefnnPzpzUvZ
	 pAx+Lf9D5YStA==
Date: Mon, 23 Jun 2025 15:50:12 -0600
From: Keith Busch <kbusch@kernel.org>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, peterx@redhat.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] vfio/pci: print vfio-device name to fdinfo
Message-ID: <aFnMFHsfi41M2siu@kbusch-mbp>
References: <20250623-vfio-fdinfo-v1-1-c9cec65a2922@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250623-vfio-fdinfo-v1-1-c9cec65a2922@fb.com>

On Mon, Jun 23, 2025 at 02:02:38PM -0700, Alex Mastro wrote:
> Print the PCI device name to a vfio device's fdinfo. This enables tools
> to query which device is associated with a given vfio device fd. It's
> inspired by eventfd's printing of "eventfd-id" (fs/eventfd.c), which
> lsof uses to format the NAME column (e.g. "[eventfd:7278]").
> 
> This results in output like below:
> 
> $ cat /proc/"$process_using_vfio"/fdinfo/"$vfio_device_fd" | grep vfio
> vfio-device-name: 0000:c6:00.0

procfs' fdinfo sounds like the right interface to append this attribute,
so looks looks good to me!

Reviewed-by: Keith Busch <kbusch@kernel.org>

