Return-Path: <kvm+bounces-27585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C3EB0987B20
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 00:24:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC2FFB2235F
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 22:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CAE318E77D;
	Thu, 26 Sep 2024 22:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="blVC2hR/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7895317C233
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 22:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727389447; cv=none; b=uFUgfR0tDjJVloAV2BMGC3vHXrx5HROz/zOeYmONBYC8AVCQgSg24yKhSXNmDXE8G2YfJvXdpIBZmAjnAGizZI8ztzXjIK0uiFUcEOpcBGafcfFrZcZwUhOsa5eLjZP3J49riYbu8zcMDsnroHj1Xg2ujh3L3BYC15eCpdRrM1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727389447; c=relaxed/simple;
	bh=/eUQ6wp4hCLmz1nesgA6s0H86049GZaM+MvfmprWBMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k+fejhJ9meehF2j64HnDJbc2cEyjUlqrOG9UhO9mHRRWuVvkR8sivfqwVMNpQ8LO8g5JcCgh0GGU3JLFOzukK2ECl6qLjjXOEffpCaoNHkQgUboZ30Y2mZw9Vm01XKhPBubxTlBa2TRWE5KwHUl5EYidAlRHd1uX48sX+H4fqN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=blVC2hR/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C875C4CEC5;
	Thu, 26 Sep 2024 22:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727389447;
	bh=/eUQ6wp4hCLmz1nesgA6s0H86049GZaM+MvfmprWBMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=blVC2hR/GHNA8z66+xJQ50937O5S1VNdYpfzTZTiXHphjJRtwJAOAPgse5veUWuK7
	 SRpgmwc38bYSEokg8QWqArmuHaU2LWFJv6V3+OD/+zlBOzpmXUe3nAfoOBfOuBNgbx
	 eVy7Mw+LtI0PARinlZjIWnRfLs/xs+R4uNUOfO6AchB+3sLT2U2ZATa0C8q4Jtf8r0
	 Bg11eUTdGv191kOWGZq075uHu6M7N34/mMqw6woE9TIbrcbd6UwBuoWDpLR4orijGu
	 ufToevV4bG7kFPNpW/lHVzq7cuxOBRsIEt+VRL/h/uyfCeHCAemOXy1O+/Ef7gctN6
	 A8x+8wvbLmjXg==
Date: Fri, 27 Sep 2024 00:23:59 +0200
From: Danilo Krummrich <dakr@kernel.org>
To: Andy Ritger <aritger@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Greg KH <gregkh@linuxfoundation.org>,
	Zhi Wang <zhiw@nvidia.com>, kvm@vger.kernel.org,
	nouveau@lists.freedesktop.org, alex.williamson@redhat.com,
	kevin.tian@intel.com, airlied@gmail.com, daniel@ffwll.ch,
	acurrid@nvidia.com, cjia@nvidia.com, smitra@nvidia.com,
	ankita@nvidia.com, aniketa@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <ZvXe_zOusb5do6q_@pollux.localdomain>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com>
 <2024092614-fossil-bagful-1d59@gregkh>
 <20240926124239.GX9417@nvidia.com>
 <2024092619-unglazed-actress-0a0f@gregkh>
 <20240926144057.GZ9417@nvidia.com>
 <ZvWi_NawH9zzznzi@bartok.localdomain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvWi_NawH9zzznzi@bartok.localdomain>

On Thu, Sep 26, 2024 at 11:07:56AM -0700, Andy Ritger wrote:
> 
> I hope and expect the nova and vgpu_mgr efforts to ultimately converge.
> 
> First, for the fw ABI debacle: yes, it is unfortunate that we still don't
> have a stable ABI from GSP.  We /are/ working on it, though there isn't
> anything to show, yet.  FWIW, I expect the end result will be a much
> simpler interface than what is there today, and a stable interface that
> NVIDIA can guarantee.
> 
> But, for now, we have a timing problem like Jason described:
> 
> - We have customers eager for upstream vfio support in the near term,
>   and that seems like something NVIDIA can develop/contribute/maintain in
>   the near term, as an incremental step forward.
> 
> - Nova is still early in its development, relative to nouveau/nvkm.
> 
> - From NVIDIA's perspective, we're nervous about the backportability of
>   rust-based components to enterprise kernels in the near term.
> 
> - The stable GSP ABI is not going to be ready in the near term.
> 
> 
> I agree with what Dave said in one of the forks of this thread, in the context of
> NV2080_CTRL_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK_PARAMS:
> 
> > The GSP firmware interfaces are not guaranteed stable. Exposing these
> > interfaces outside the nvkm core is unacceptable, as otherwise we
> > would have to adapt the whole kernel depending on the loaded firmware.
> >
> > You cannot use any nvidia sdk headers, these all have to be abstracted
> > behind things that have no bearing on the API.
> 
> Agreed.  Though not infinitely scalable, and not
> as clean as in rust, it seems possible to abstract
> NV2080_CTRL_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK_PARAMS behind
> a C-implemented abstraction layer in nvkm, at least for the short term.
> 
> Is there a potential compromise where vgpu_mgr starts its life with a
> dependency on nvkm, and as things mature we migrate it to instead depend
> on nova?
> 

Of course, I've always said that it's perfectly fine to go with Nouveau as long
as Nova is not ready yet.

But, and that's very central, the condition must be that we agree on the long
term goal and agree on working towards this goal *together*.

Having two competing upstream strategies is not acceptable.

The baseline for the long term goal that we have set so far is Nova. And this
must also be the baseline for a discussion.

Raising concerns about that is perfectly valid, we can discuss them and look for
solutions.

