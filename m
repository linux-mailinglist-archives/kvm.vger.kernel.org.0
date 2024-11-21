Return-Path: <kvm+bounces-32268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90B629D4EB8
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 15:34:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0250DB2587B
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 14:34:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 807971D959B;
	Thu, 21 Nov 2024 14:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GPP6hrRA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC8C1AAE37;
	Thu, 21 Nov 2024 14:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732199669; cv=none; b=u33tFxSeW7j50aF2uMvH30oP5DNqVR+EtfQFo9N7IX+syD2q+sZYZJMQxxk/Q32skMQHACgHicFnqMpDUZDWoWP4+TijMrQevjcVVLs+9jC5dQY5TWYRZPqA5UD+DYApMSGXkmTkTNyG4/PO00HJsVtpaTLBYsKxRtcfcRoeJ2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732199669; c=relaxed/simple;
	bh=TsAFbujU4fB8QUxdKHjvksqjOhJcoSHX6zf/LFgOQpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WtMY9UFJ2MNQoU/JPh1FPDp5WueLVJdjkNzGzpGR7a3HbwTRdHCAsG1wyKMSzz3Tl3XEHSJKSvKAbWW58p5ZbjD9ibzfRMymvBCKojQ3j7daVUE9RYiT0ku1tA/5HBoS5rWMqUwiZJImYg6rDYzaf9Lrp75mgInu682RXR59jpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GPP6hrRA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D493EC4CECC;
	Thu, 21 Nov 2024 14:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732199668;
	bh=TsAFbujU4fB8QUxdKHjvksqjOhJcoSHX6zf/LFgOQpg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GPP6hrRAtBVDZzIvhFOK0SDftzPs+zHOUfD7IBmpWwhqjzyG1yvfGvApDqGYJ4ytp
	 7n6rZJJ5j2o2lOfDM4AvEXFIjfy7+DAeG/yICdA8fWVZFM+N/F0c8INA/9TFur5TUQ
	 W4kLeeDvf7DvKLAjcsJmIzlqiH1obMGPuX89rwVErDAjPSQs16TE34Q9MRpAk4RTJs
	 My0eAhoZswjDpO+mCIfF9SW0VAHpRiqHqup8u+ZxpXJtMhedUNS+tw8NOWooOqhZ9x
	 /TEP53Y8VS32rsbXdx0LPeO8mLQznpoIeb8t1yjtxLBfiYJoQ7BxLPddtVLf4AiqVx
	 VoS8+xESnTfjA==
Date: Thu, 21 Nov 2024 09:34:26 -0500
From: Sasha Levin <sashal@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Nathan Chancellor <nathan@kernel.org>, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 6.13 merge window
Message-ID: <Zz9E8lYTsfrMjROi@sashalap>
References: <20241120135842.79625-1-pbonzini@redhat.com>
 <Zz8t95SNFqOjFEHe@sashalap>
 <20241121132608.GA4113699@thelio-3990X>
 <901c7d58-9ca2-491b-8884-c78c8fb75b37@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <901c7d58-9ca2-491b-8884-c78c8fb75b37@redhat.com>

On Thu, Nov 21, 2024 at 03:07:03PM +0100, Paolo Bonzini wrote:
>On 11/21/24 14:26, Nathan Chancellor wrote:
>>On Thu, Nov 21, 2024 at 07:56:23AM -0500, Sasha Levin wrote:
>>>Hi Paolo,
>>>
>>>On Wed, Nov 20, 2024 at 08:58:42AM -0500, Paolo Bonzini wrote:
>>>>      riscv: perf: add guest vs host distinction
>>>
>>>When merging this PR into linus-next, I've started seeing build errors:
>>>
>>>Looks like this is due to 2c47e7a74f44 ("perf/core: Correct perf
>>>sampling with guest VMs") which went in couple of days ago through
>>>Ingo's perf tree and changed the number of parameters for
>>>perf_misc_flags().
>
>Thanks Sasha. :(  Looks like Stephen does not build for risc-v.

He does :)

This issue was reported[1] about a week ago in linux-next and a fix was
sent out (the one you linked to be used for conflict resolution), but it
looks like it wasn't picked up by either the perf tree or the KVM tree.


[1] https://lore.kernel.org/all/CA+G9fYv=qPeZKkF+ntWxUXbAKjz4gXnBM8y60C4F=YHv+jgZZw@mail.gmail.com/

-- 
Thanks,
Sasha

