Return-Path: <kvm+bounces-40971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 640EEA5FD9E
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 18:22:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2A4A19C400E
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C2371684B0;
	Thu, 13 Mar 2025 17:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/jrhUYX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CA8153801
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 17:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741886453; cv=none; b=S21lUq0WG++VweYz19FDD+VdEhj409zve0cjxxMVQt+WaFYiGk5jTy095g9cBqFKdFxhECVebzHwmXFyP7iYYvos2P7FZ9y26F2VQ9txOlojGtgf+yEnnKSpBQdvBwSQQu4jMKFotVJQvjMxYE8qhktRgJ7mAkbPzT88v8PqQKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741886453; c=relaxed/simple;
	bh=cBbgyyBa850Qp01vBLPD5xwNXctix52gzE1qJrnZPKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LDp+y2+bU8welDQ7+fJ3eVDq4nEvh4qGW2Q7cdv47zr4j2rEemQjLC42A0P53OML4DsQ+3U5jr9mzhKZ1lcgDIXPU9O9u47kKlj6rYgjXLWfOcLZiG6AyhTRCz/YMrUnMmTmiBlZ4hug9ubnBMm2jN3ef0oqCkTCowkRcLJ85/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/jrhUYX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FDBC4CEE3;
	Thu, 13 Mar 2025 17:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741886453;
	bh=cBbgyyBa850Qp01vBLPD5xwNXctix52gzE1qJrnZPKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f/jrhUYXta2sBj/ckAfoA57+L65tutUS8B7dWw6+MkN2J2TlzExjftLcpobV0uQI1
	 6x/ngk4qV2e91a8iC1f4MLB39dy94awIri8vhy9qVpDKDn9ZQqCW6pcluBDKSneyFY
	 OYAYWVISEKbREWuAwjwD65oN/7NapByGHEoPyrLf1sjGYMeXhEDe138OKvA4vNLYhY
	 SCRKq47Dlm6ZcAcJdk7twAoNdvAocOcEw+bV2N/xgrR1rm73xy0j9aF55FG7cBMd1S
	 oA9iqQNu9GqJzdsawArqbfdpdJqE26qiEyvkS/7m1yxMXDUTK5lq09aUSSuXPMwvss
	 m8/S9KgO/WrFw==
Date: Thu, 13 Mar 2025 11:20:50 -0600
From: Keith Busch <kbusch@kernel.org>
To: Mike Christie <michael.christie@oracle.com>
Cc: chaitanyak@nvidia.com, hch@lst.de, sagi@grimberg.me,
	joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
	kvm@vger.kernel.org, kwankhede@nvidia.com,
	alex.williamson@redhat.com, mlevitsk@redhat.com
Subject: Re: [PATCH RFC 01/11] nvmet: Remove duplicate uuid_copy
Message-ID: <Z9MT8iYqHZjsmp8y@kbusch-mbp.dhcp.thefacebook.com>
References: <20250313052222.178524-1-michael.christie@oracle.com>
 <20250313052222.178524-2-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313052222.178524-2-michael.christie@oracle.com>

On Thu, Mar 13, 2025 at 12:18:02AM -0500, Mike Christie wrote:
> We do uuid_copy twice in nvmet_alloc_ctrl so this patch deletes one
> of the calls.

Thanks, applied patch 1 to nvme-6.15.

