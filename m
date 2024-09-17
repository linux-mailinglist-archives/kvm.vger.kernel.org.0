Return-Path: <kvm+bounces-27032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 61F9797ADA8
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 11:13:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94ECB1C215BA
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 09:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5359115D5A6;
	Tue, 17 Sep 2024 09:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KzCwKrHv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C18A15B55D;
	Tue, 17 Sep 2024 09:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726564415; cv=none; b=kdN2pwqyh5qPIMfBkOvxjIvQ+SJD4I0AnP+JuTPJG6vcqdC3clWNiYEOIb2n2h2PxEl9VPZCJwQAkDxTwrpfTC0agsPvcK8FDaVEjpwf3LBTQID8Us3l9v+f8RZOBrJVBU3+Y82VwClBcrZEVIkHyVZ9ftF9p4XmRzcxxtHAXrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726564415; c=relaxed/simple;
	bh=/L4+uQPnFgXF7YEaXU7zuEQSj/reGUPTS4KRAMrcMSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kDBy//FQcPrlhiefZolBlHqNInMU6XPmr6zvqF1Z3D8A6S/RK8llr8FYsjkX1tj9+oyS9StZO0qynEyW4r1xvNKKY1x2SEGeIEtWgiZOMlZINo8ieyDBCjIbj4IW38Pcoex8pUHOPrwigQFB4yLBhjDiwUJ1I9OxYo8nWIBwy6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KzCwKrHv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7ECC4CEC6;
	Tue, 17 Sep 2024 09:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726564414;
	bh=/L4+uQPnFgXF7YEaXU7zuEQSj/reGUPTS4KRAMrcMSU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KzCwKrHvUABGPfqU8wlFuc3YKeQR+MWUuLiJRw5MH0UFp/qwjWTnS/Bw+rMlyUnMw
	 z/J9aGwno2px3YJM6vGTTTDqPAYRkDX96O57HNTlaHiuugZIRPFVo/85+taxP5I7Yv
	 uzNUdkXcw6FtBdvNgqkA+69jyJDqrdqGOHAFjmqk=
Date: Tue, 17 Sep 2024 11:13:28 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: WangYuli <wangyuli@uniontech.com>
Cc: stable@vger.kernel.org, sashal@kernel.org, maobibo@loongson.cn,
	guanwentao@uniontech.com, zhangdandan@uniontech.com,
	chenhuacai@loongson.cn, zhaotianrui@loongson.cn, kernel@xen0n.name,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6.10] LoongArch: KVM: Remove undefined a6 argument
 comment for kvm_hypercall()
Message-ID: <2024091757-demanding-plenty-3eb0@gregkh>
References: <5B13B2AF7C2779A7+20240916092857.433334-1-wangyuli@uniontech.com>
 <2024091647-absolve-wharf-f271@gregkh>
 <3E9630B3C9FBF09F+32098b9e-b18a-4252-b8c6-a766f3de84b4@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3E9630B3C9FBF09F+32098b9e-b18a-4252-b8c6-a766f3de84b4@uniontech.com>

On Tue, Sep 17, 2024 at 04:49:04PM +0800, WangYuli wrote:
> 
> On 2024/9/16 19:39, Greg KH wrote:
> > Again, why is this needed?
> > 
> Hmm...
> 
> Just a mini 'fix'.
> 
> The reason of
> 'https://lore.kernel.org/all/2024091628-gigantic-filth-b7b7@gregkh' is same.

It does not "fix" anything, please read the rules for what is allowed in
a stable kernel in the documentation directory before submitting changes
in the future.

thanks,

greg k-h

