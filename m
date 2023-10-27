Return-Path: <kvm+bounces-8-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 187D47DA403
	for <lists+kvm@lfdr.de>; Sat, 28 Oct 2023 01:23:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A97EB2173A
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 23:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF4E41223;
	Fri, 27 Oct 2023 23:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m3BBIsHR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0106334CD1;
	Fri, 27 Oct 2023 23:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE46C433C7;
	Fri, 27 Oct 2023 23:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698448979;
	bh=euoi0gsHk/0YPq55clyHDu+jm37VY6jlna/C0hrDMTs=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=m3BBIsHR/VPcsd5spaOT2brsOBwRM/T6t45o/xQOFCoHp6uRoEuZlXzP5yxodmhG6
	 fop/7YVrQ3CrisYfNO0SoI2fSbUHc0/Stxnh2jB06DIm37toRNIuzIVjRp4fL8O7tE
	 aSymxaFR/1XVwVYlkLlig+sIOx7x7CFilpVjsTh4=
Date: Fri, 27 Oct 2023 19:22:57 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: dccp@vger.kernel.org, dmaengine@vger.kernel.org, 
	ecryptfs@vger.kernel.org, fio@vger.kernel.org, fstests@vger.kernel.org, 
	initramfs@vger.kernel.org, io-uring@vger.kernel.org, kernel-janitors@vger.kernel.org, 
	keyrings@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: This list is being migrated to the new vger infra (no action
 required)
Message-ID: <20231027-vagabond-quail-of-efficiency-dd3dd5@meerkat>
References: <20231027-strange-debonair-basilisk-cecdab@meerkat>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231027-strange-debonair-basilisk-cecdab@meerkat>

On Fri, Oct 27, 2023 at 06:56:49PM -0400, Konstantin Ryabitsev wrote:
> This list is being migrated to the new vger infrastructure. This should be a
> fully transparent process and you don't need to change anything about how you
> participate with the list or how you receive mail.
> 
> There will be a brief delay with archives on lore.kernel.org. I will follow up
> once the archive migration has been completed.

This work is now complete. If anything isn't working correctly, please report
it to helpdesk@kernel.org.

Best wishes,
-K

