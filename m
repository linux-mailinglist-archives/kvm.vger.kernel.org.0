Return-Path: <kvm+bounces-67370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 60081D024FA
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 12:11:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B19D43012DEA
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 10:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C97548C8BA;
	Thu,  8 Jan 2026 10:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SnjsIvyK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25303D3018;
	Thu,  8 Jan 2026 10:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767868922; cv=none; b=iF8Y5u2ZhuiIZlAr7IXVabBIvMX40UGgUJVbGSCeo84hyblioQAqGvkj2tLgeqzhPVkQRiLvVeukWZHaB6O6/T1lDIei3S3Q2upbmYGjMRfO//dShbE/B9DiuaEMFzIH89zGBHuumqK+AGR6r1kfXgzBQEqboH2UOhSU+xMSZ/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767868922; c=relaxed/simple;
	bh=b9Q24ss448Qe8rQYK9MJAYn92j93AH5V8VmZSRxpDUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uA640tf927y8HKyZWoFiR1YFplKQBjdq/N4QDTZLHvy9RbV62+4DmOcIAy/FSCgsyndTfdBT+tmjhy3yTqcC6xfpSQFfuRZcENsk8vkua7YxUu1+0mOAWi3HUFM+Czj34BhKzFY8HAOdNEZZGkhw4Zly/iiC70P/WJYD+8BclPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SnjsIvyK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31CDC16AAE;
	Thu,  8 Jan 2026 10:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767868921;
	bh=b9Q24ss448Qe8rQYK9MJAYn92j93AH5V8VmZSRxpDUo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SnjsIvyKELvX6Joqgrcod9oMCPCAJR2Vif+BJXdHg2X0tzy3OpiNibl1Wc6St7LBf
	 hqIV+gQqI1Meq9g6EgprBrqA617/yBv/B8c2jN8Zso+PyIYqA4e43HtiYboZ0zs+I5
	 NL2dC5LUPhtQW4EeN1mObp3k24qELawRqxXUrSkyrCQfv/S6WaKuZ5W1pZMJDlpgZR
	 2HOF72Hu6ZC0l8X/Xi18hBO6yrtiK4OG6PIKzOniGKE1RIFw18zOuDczQi4GMxub8j
	 z2t+6AkFhnUJgwrVx6lUssZsJV1wUgC+Y1qkQs9WUHj5fl62AliOf+fhMnNttp4w9M
	 jPMg9dRu2d7Cg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0662DF40068;
	Thu,  8 Jan 2026 05:42:00 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 08 Jan 2026 05:42:00 -0500
X-ME-Sender: <xms:94lfaQviWAZvDIFgTAKRY5BiJb-utnU0HH5HNawAZf8ZcNnrqi5n3A>
    <xme:94lfadkAGunxdeZA4EfL_d1i9l2Z_xoHjPctjQ-IUbDSvRf1w9eMeuCo8aXW_wsPf
    ojW4W3Q2b7HAvA7sVEEqTpb-0CAzmzK1gH7qREpjluWRAR2M0epMlw>
X-ME-Received: <xmr:94lfaZmwt41oeEeiidRbpjd9XRk6W8qOKE1MzMI-vgX9tx95aUd_gVLO0m1-9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddutdehjeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfeikeetleeludeghfffkeffgfejtdevvefggfejfeefgedvkeettedugeeggfek
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkh
    gvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    kedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepvhhishhhrghlrdhlrdhvvghrmh
    grsehinhhtvghlrdgtohhmpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgv
    rhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqtghotghosehlihhsth
    hsrdhlihhnuhigrdguvghvpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopegthh
    grohdrghgrohesihhnthgvlhdrtghomhdprhgtphhtthhopegurghnrdhjrdifihhllhhi
    rghmshesihhnthgvlhdrtghomhdprhgtphhtthhopehkrghirdhhuhgrnhhgsehinhhtvg
    hlrdgtohhmpdhrtghpthhtohepthhglhigsehlihhnuhhtrhhonhhigidruggv
X-ME-Proxy: <xmx:94lfaXfm4G7dwInBCg9DFNNu4iOrj_ghqzSnQlVFGpHmEzlSl5MtcQ>
    <xmx:94lfafK4nkYh1vX-LJ5xCh40b7Xfi19v02g0GUqfQNhcO8PBsHYkXw>
    <xmx:94lfaa4eXLZwHYPEmwqiuzmcl0t04aZpsunCXrZ_UhyhQomVQLsbZA>
    <xmx:94lfaWSKo3g-5tw5DL0jFUKydQCmGg0UWUmQI7y_kP_svUg_Warr3A>
    <xmx:-IlfaSvGupEHXA3UoHQgRK5fD3fM70UhmRQ1dz6wkA6KEAbxkqohtUdW>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jan 2026 05:41:59 -0500 (EST)
Date: Thu, 8 Jan 2026 10:41:58 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, x86@kernel.org, Chao Gao <chao.gao@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 1/2] x86/virt/tdx: Retrieve TDX module version
Message-ID: <mv2jvrotj3ozkh32ug6fwzk5wufpbpphgtaazb3b753d2ypu2s@mbq5djpeqn4v>
References: <20260107-tdx_print_module_version-v1-0-822baa56762d@intel.com>
 <20260107-tdx_print_module_version-v1-1-822baa56762d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107-tdx_print_module_version-v1-1-822baa56762d@intel.com>

On Wed, Jan 07, 2026 at 05:31:28PM -0700, Vishal Verma wrote:
> From: Chao Gao <chao.gao@intel.com>
> 
> Each TDX module has several bits of metadata about which specific TDX
> module it is. The primary bit of info is the version, which has an x.y.z
> format, where x represents the major version, y the minor version, and z
> the update version. Knowing the running TDX Module version is valuable
> for bug reporting and debugging. Note that the module does expose other
> pieces of version-related metadata, such as build number and date. Those
> aren't retrieved for now, that can be added if needed in the future.
> 
> Retrieve the TDX Module version using the existing metadata reading
> interface. Later changes will expose this information. The metadata
> reading interfaces have existed for quite some time, so this will work
> with older versions of the TDX module as well - i.e. this isn't a new
> interface.
> 
> As a side note, the global metadata reading code was originally set up
> to be auto-generated from a JSON definition [1]. However, later [2] this
> was found to be unsustainable, and the autogeneration approach was
> dropped in favor of just manually adding fields as needed (e.g. as in
> this patch).
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Link: https://lore.kernel.org/kvm/CABgObfYXUxqQV_FoxKjC8U3t5DnyM45nz5DpTxYZv2x_uFK_Kw@mail.gmail.com/ # [1]
> Link: https://lore.kernel.org/all/1e7bcbad-eb26-44b7-97ca-88ab53467212@intel.com/ # [2]
> ---
>  arch/x86/include/asm/tdx_global_metadata.h  |  7 +++++++
>  arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 16 ++++++++++++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
> index 060a2ad744bff..40689c8dc67eb 100644
> --- a/arch/x86/include/asm/tdx_global_metadata.h
> +++ b/arch/x86/include/asm/tdx_global_metadata.h
> @@ -5,6 +5,12 @@
>  
>  #include <linux/types.h>
>  
> +struct tdx_sys_info_version {
> +	u16 minor_version;
> +	u16 major_version;
> +	u16 update_version;
> +};
> +
>  struct tdx_sys_info_features {
>  	u64 tdx_features0;
>  };
> @@ -35,6 +41,7 @@ struct tdx_sys_info_td_conf {
>  };
>  
>  struct tdx_sys_info {
> +	struct tdx_sys_info_version version;

Creates a 2 byte hole. Just enough to squeeze INTERNAL_VERSION there.
Just saying :P

But patch looks good to me:

Reviewed-by: Kiryl Shutsemau <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

