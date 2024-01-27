Return-Path: <kvm+bounces-7261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5709383E8DC
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 02:08:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B311228A893
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 01:08:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3E384C7A;
	Sat, 27 Jan 2024 01:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xiXWcK+X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71BF5665;
	Sat, 27 Jan 2024 01:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706317691; cv=none; b=n1cP74M6M7sgxxlYupmjWT7eA/Dw4SeP3cUAs2FyIKjJQVtyLLdvHCsLNnlAomzFKdiKRRY/ivuKu5zGck9EdvLVOCbfX+Vzd+dH72JDONTao8Nfj8tJwwq7At74h1c5cOT5kUomYSOeuQS4hEH0avnjx6gBMsqd17mTSbaGk9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706317691; c=relaxed/simple;
	bh=JHt7EUzZPndp4RZLrfdpBfC6Ln5c9VflGIEWML9+wZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kQso0AYf6G1Y5FOzZL5vNIl/M6aBOduIjlv+3ZAzyveKgL3egiAsXDwhH1SZs/YMTOa6C/FfzRn9LseYCv1hzZTXCzk6WdoOWl+Z4zy0ASlPEEqBfYpl+8kwPnV0TcPNYGzXhJaslYoelwQvdB+MVKHyTyJqesGTqzcJltfhIzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xiXWcK+X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B811C433F1;
	Sat, 27 Jan 2024 01:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706317690;
	bh=JHt7EUzZPndp4RZLrfdpBfC6Ln5c9VflGIEWML9+wZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xiXWcK+XTEm6xMIyGpsgxrk4PCV+ezh0S60vxE1Y8fMNFDjPnNlfOUXRR6LTaEzKW
	 zbju9R8pFp5J3YJYreFQ//UtbsP5DmgkItbdbm6DAbLAMz/bUBJlmf4/7ayy7dTyVk
	 t0BKpUZbwyfZf98yz3gPgfacaU0pvpOFpboYYgQI=
Date: Fri, 26 Jan 2024 17:08:08 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: mlevitsk@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	stable@vger.kernel.org, joe.jin@oracle.com
Subject: Re: Stable bugfix backport request of "KVM: x86: smm: preserve
 interrupt shadow in SMRAM"?
Message-ID: <2024012639-parsnip-quill-2352@gregkh>
References: <20240127002016.95369-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240127002016.95369-1-dongli.zhang@oracle.com>

On Fri, Jan 26, 2024 at 04:20:16PM -0800, Dongli Zhang wrote:
> Hi Maxim and Paolo, 
> 
> This is the linux-stable backport request regarding the below patch.

For what tree(s)?

And you forgot to sign off on the patch :(

thanks,

greg k-h

