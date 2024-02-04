Return-Path: <kvm+bounces-7943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D743848BBE
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 08:08:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49702284D37
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 07:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9C118827;
	Sun,  4 Feb 2024 07:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ASaMiiWh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE2C749C;
	Sun,  4 Feb 2024 07:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707030514; cv=none; b=B09DTstIsIYb/yR62CNLyonkLUg76U8H5j4Frn9hoGumLSgutwnwOurY2tr0U32BNLiCp6sP2C59tAT6ZiAkPo35wZJ5DNQXPA0XEQYjBQM/BZU/5nCT8rEpX/ukfqOBR24p73jqTR2hTiovOI9k8wKTChMLzM8oG1zECmpfFTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707030514; c=relaxed/simple;
	bh=mqmUJhwMC+hGcCJ5oR07vsws9DjOZ4c7Y8U7ECmQp/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kjFLajfv4fk/548Zxarpq7Lq358ysJVj1hC1GPksuGaDSVlWxi/YTJAMw2lyTvuytQ2IOlbr35LMGiXPHCOuEVN2RP/b9Qmp4Vaxf4MX2kaSbXnawXCFsN8z2qXlhrmtAqilvooysWDu1M+wpMcac55/2aFegjriE4257w+cWEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ASaMiiWh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252B1C433C7;
	Sun,  4 Feb 2024 07:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707030513;
	bh=mqmUJhwMC+hGcCJ5oR07vsws9DjOZ4c7Y8U7ECmQp/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ASaMiiWhSgJ2CqyvHxc9ihtjwFqfRghZNAxwiJDRhCqFqhM5Y4XxX+pSM55YgHRPU
	 gjmi4ZnMtGXLjiIfLw2/V0TyCGdMOlMVXbunn7zQzEVZibyORaJ7ZSW2SFZMrpMsto
	 TLQT7N8KZSY9MhNWZAkvjv2G/Kh/T7oKqDz3uaBbtnEVUpa6jPhr4bqxNBtajSnitY
	 gSienoP7Rj6HOpU4BWsoJhWdHrE3gOO/qZJoabUG8y2APql/Z3lQXBPBnkUuzNeO5A
	 1d5j3KXJs+RQnST33R/H+JvNbTYp3FBB7e3Z57dH2jPTa1Ic7aGqaSqZUg15DMyliz
	 RIgl3uhPFui0A==
Date: Sun, 4 Feb 2024 00:08:31 -0700
From: Keith Busch <kbusch@kernel.org>
To: Emily Deng <Emily.Deng@amd.com>
Cc: amd-gfx@lists.freedesktop.org, bhelgaas@google.com,
	alex.williamson@redhat.com, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] PCI: Add vf reset notification for pf
Message-ID: <Zb8371oj6Xju_2gU@kbusch-mbp.mynextlight.net>
References: <20240204061257.1408243-1-Emily.Deng@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240204061257.1408243-1-Emily.Deng@amd.com>

On Sun, Feb 04, 2024 at 02:12:57PM +0800, Emily Deng wrote:
> @@ -926,6 +926,7 @@ struct pci_driver {
>  	int  (*sriov_configure)(struct pci_dev *dev, int num_vfs); /* On PF */
>  	int  (*sriov_set_msix_vec_count)(struct pci_dev *vf, int msix_vec_count); /* On PF */
>  	u32  (*sriov_get_vf_total_msix)(struct pci_dev *pf);
> +	void  (*sriov_vf_reset_notification)(struct pci_dev *pf, struct pci_dev *vf);

You've created a new callback, but there is no user. Could you resubmit
this with an in-kernel use case?

