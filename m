Return-Path: <kvm+bounces-51817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 237D1AFDAC9
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 00:17:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 074FE1AA51D3
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 22:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9E025A355;
	Tue,  8 Jul 2025 22:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L1dDNcpH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B613258CE5;
	Tue,  8 Jul 2025 22:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752013065; cv=none; b=A1bDerasWNiVnhGqnRlGQj5Gwpxnx21Qw18crhdQIQdzcmSIj5TQV+L6laaGsncitVsRAuVGYJuBQCUantz1v+hqxS68irNKlo3Wik+V19JOyI40maROxfeyrQAR3wmkCqhNYbrEwWpE6O/IIdPvdXp89PMFmiCWkzY6vGk7LEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752013065; c=relaxed/simple;
	bh=UnhukZ2YtMp4btbXj3uJao6sn+kZTAOJccb/Lr/x/nY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l1RKcoDTm31Qeg48wubIuezYaUDk6Vlyqf/jsLIt/ZKFk+CP1oWmwOPSr+Ok1gV1OoDnIjBNCqsV/ztLIa926VOI7gsMu6XPtTfLDY0Wo5S4JDuDEqo8HY7CwYFcPZCCEXkZs3UzRq2tq6slvW3070Bl88HT+U7/PNClNi08nSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L1dDNcpH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842E6C4CEED;
	Tue,  8 Jul 2025 22:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752013064;
	bh=UnhukZ2YtMp4btbXj3uJao6sn+kZTAOJccb/Lr/x/nY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L1dDNcpHDcp4F8/mto6moccsYo9Xlh2jxhB9b5sbCf2GmlRISDjVMejqGqz7guwlA
	 m5xnBVzQ5Fa3ZDkl0LSBPlp/5HSHaSpI1ZVkTRtSv+cBPDsR2/B2O467dDRutGn7lz
	 w5R+P0wKtTp+R8h6jQEgn3SFC38FuUl9DgWo6hA9sd43x9PnJVB71EHdmreIAFzcit
	 Jg3wjJ8lqrf5oWnTH8ucrLrfVvHEAkdKjeJSN06YmzqxWnIxqc0NbMX467yNS58col
	 kNuHwxV7UaiyceGzeV4kX4L/ii7LjCRErmLX3YpZ3fkoegZyl2lrlTQxF0yP9mprF6
	 ARHEXTfl5ybEg==
Date: Tue, 8 Jul 2025 16:17:42 -0600
From: Keith Busch <kbusch@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Lei Yang <leiyang@redhat.com>,
	Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, x86@kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCHv3 0/2]
Message-ID: <aG2ZBrRIpGMZFB6R@kbusch-mbp>
References: <20250227230631.303431-1-kbusch@meta.com>
 <CAPpAL=zmMXRLDSqe6cPSHoe51=R5GdY0vLJHHuXLarcFqsUHMQ@mail.gmail.com>
 <Z8HE-Ou-_9dTlGqf@google.com>
 <Z8HJD3m6YyCPrFMR@google.com>
 <Z8HPENTMF5xZikVd@kbusch-mbp>
 <Z8HWab5J5O29xsJj@google.com>
 <Z8HYAtCxKD8-tfAP@kbusch-mbp>
 <3b1046fb-962c-4c15-9c4e-9356171532a0@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b1046fb-962c-4c15-9c4e-9356171532a0@redhat.com>

On Fri, Feb 28, 2025 at 05:43:43PM +0100, Paolo Bonzini wrote:
> (Keith, I haven't forgotten about AVX by the way).

Hey, how's that going by the way? :) Just checking in as I'm still
having to carrying this part out of tree.

