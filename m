Return-Path: <kvm+bounces-39590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F636A482B1
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 16:16:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 729E116B6A0
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 15:09:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1049A26A0E9;
	Thu, 27 Feb 2025 15:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gLfBVzeJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF732309A1;
	Thu, 27 Feb 2025 15:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740668989; cv=none; b=F4FMtV8Epyoez5iIC65WXXkJM8c4EBcv0ShzPrCsckbOGxpk/1T9yTT4tcLnH2P4sIUuFW3wtNdBq+QlSwhfZus25TxAKuFnHjYDFJMp6wTp1eNXLJL/E7tV+icQYAsD45cm2ht5CVF2RP5FzMbInNApQtXUKE5VRR12fGFm/YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740668989; c=relaxed/simple;
	bh=IKveQp0TXWwuACZBcooQBA/ITay4t9n3XRYcOXujElo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pSW3ovYHxqKhGDgSuiv1KqR7A1R2pxsNs0YDw3hJNp+N8Wi7blAkjKZpRJ7XANeXWyQBugOzhZNiTApNwjQA+2TC32nsUlogvgennE0tIgJDxqAL6uKO0kiRfUH2HT9gAbtP9abXxFTILAm8rqIAo/GFepSxr7ThW8ApJTg+0Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gLfBVzeJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BECC4CEDD;
	Thu, 27 Feb 2025 15:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740668988;
	bh=IKveQp0TXWwuACZBcooQBA/ITay4t9n3XRYcOXujElo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gLfBVzeJQRcPN/vAyogRoXvxAOqZZD63SxRWakjS5neXEQTXmwh1jDc/xfM9bORCD
	 oQDLOv9ZJB+aviv1hwFHwbyi8vFwrinlZSl17abry/Y4fGWYb0QYDOu/NrFyB1hA+Z
	 VR8mfc0QCEbXn8uuyQSkP4RS+OBhbgNIxa4WWFOjFr8QtKZW8qZ6l/+vwi4JA11woh
	 9MTDROemC56x5+zqMZ8cF8N1AE76cHfXtWEuRPOO6Y2IqQxew6xniBy9EFTJP2NE/t
	 5RLXTdJGb+SjuOWRO2v3EKpwheGZh60x2Grkx9MjPPvLtTg76385bOTu8bt7zK4Y+H
	 pmV+Kvo0r2NNQ==
Date: Thu, 27 Feb 2025 08:09:45 -0700
From: Keith Busch <kbusch@kernel.org>
To: Lei Yang <leiyang@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, pbonzini@redhat.com, seanjc@google.com,
	kvm@vger.kernel.org, x86@kernel.org, virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 0/2] kvm/x86: vhost task creation failure handling
Message-ID: <Z8CAORHSFh5LnKNw@kbusch-mbp>
References: <20250226213844.3826821-1-kbusch@meta.com>
 <CAPpAL=yffyhUrdEJHtAw4BDpV-=Z5mZq0r1ZFcoj1v1OBLnp_g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPpAL=yffyhUrdEJHtAw4BDpV-=Z5mZq0r1ZFcoj1v1OBLnp_g@mail.gmail.com>

On Thu, Feb 27, 2025 at 06:21:34PM +0800, Lei Yang wrote:
> Hi Keith
> 
> There are some error messages from qemu output when I tested this
> series of patches with the virtio-net regression test. It can
> reproduced by boot up a guest with vhost device after applied your
> patches.
> Error messages:
> Qemu output:
> qemu-kvm: -netdev {"id": "idoejzv8", "type": "tap", "vhost": true,
> "vhostfd": "16", "fd": "10"}: vhost_set_owner failed: Cannot allocate
> memory
> qemu-kvm: -netdev {"id": "idoejzv8", "type": "tap", "vhost": true,
> "vhostfd": "16", "fd": "10"}: vhost-net requested but could not be
> initialized

*facepalm*

I accidently left the "!" in the condition:

@@ -666,7 +666,7 @@ static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
 
 	vtsk = vhost_task_create(vhost_run_work_list, vhost_worker_killed,
 				 worker, name);
-	if (!vtsk)
+	if (!IS_ERR(vtsk))
 		goto free_worker;

