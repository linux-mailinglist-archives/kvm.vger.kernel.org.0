Return-Path: <kvm+bounces-73257-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YPYIKM1hrmlbCwIAu9opvQ
	(envelope-from <kvm+bounces-73257-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 06:59:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 27F592340DA
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 06:59:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A714C300B991
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 05:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 254E434D4EA;
	Mon,  9 Mar 2026 05:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+HDOVMn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595341E834E;
	Mon,  9 Mar 2026 05:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773035975; cv=none; b=U02au9VjelJLrfU6x1o42r5I/zEQiJdyVyaxqNYtK1AJk/Ju/hqnIDDrz9ETWDSr1jX6R3wwXPU5ETlKjsSAuSPKptpAtJhSxjwN6yPkcUHBJUaLZ1z0mkc3YsphDsV06nqr5K6gtHCKvzAhNWfBcrlrUElVW1R+i1O81CZpIpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773035975; c=relaxed/simple;
	bh=591fDBtSEemZkhlIfx1YWUCN1GHAxbffpObsBvtPrss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BW+aM1/YlIKJJoip4JJduhwUmuAbfhc36Z8cx8KWuc6+ee+CnuKXtjqqt8shsLOF77wBz356DWKi1ggBLEVL0m/pFmHLnFUKUPWhUPQOZR0zCp+gmTfuxbsuZxh4OQNmbQOn1dfPigLobfHNt4brJ8/WxNNLLmvmN2trXchZB/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+HDOVMn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B33C4CEF7;
	Mon,  9 Mar 2026 05:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773035975;
	bh=591fDBtSEemZkhlIfx1YWUCN1GHAxbffpObsBvtPrss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H+HDOVMnTPGqVKmt7i+gwH9l4qUnKtxFeTdQZ9sMFOo7ZmvILIuBv67ThOz8hVVd7
	 scpO5+RmJotQmsi4bLFtok0UcYr02lVd7sDA3Lrg0iyWSSDeVIbqiTel+HmSfw/rvf
	 3mZny9+eCFTT4V+cdYCwtAh+7Lwa8uC7nEp2z3mo=
Date: Mon, 9 Mar 2026 06:59:19 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Kirti Wankhede <kwankhede@nvidia.com>,
	"open list:VFIO MEDIATED DEVICE DRIVERS" <kvm@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] vfio: mdev: replace mtty_dev->vd_class with a const
 struct class
Message-ID: <2026030913-oblong-dress-e34b@gregkh>
References: <20260308214939.1215682-1-jkoolstra@xs4all.nl>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260308214939.1215682-1-jkoolstra@xs4all.nl>
X-Rspamd-Queue-Id: 27F592340DA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-73257-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[xs4all.nl];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	NEURAL_SPAM(0.00)[0.256];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,linuxfoundation.org:dkim,linuxfoundation.org:email]
X-Rspamd-Action: no action

On Sun, Mar 08, 2026 at 10:49:39PM +0100, Jori Koolstra wrote:
> The class_create() call has been deprecated in favor of class_register()
> as the driver core now allows for a struct class to be in read-only
> memory. Replace mtty_dev->vd_class with a const struct class and drop the
> class_create() call.
> 
> Compile tested and found no errors/warns in dmesg after enabling
> CONFIG_VFIO and CONFIG_SAMPLE_VFIO_MDEV_MTTY.
> 
> Link: https://lore.kernel.org/all/2023040244-duffel-pushpin-f738@gregkh/
> 
> Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
> ---
> v2: undo whitespace reformating of struct mtty_dev

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

