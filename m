Return-Path: <kvm+bounces-4218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F021C80F46D
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 18:21:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABA2128282B
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 17:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 942647D891;
	Tue, 12 Dec 2023 17:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dS4NWFWM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBBD7B3CC;
	Tue, 12 Dec 2023 17:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6EFC433D9;
	Tue, 12 Dec 2023 17:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702401709;
	bh=6YhYaM20GOsMdc8Rc2Fzhf1uOeyj3UQk4B0AXX9Ihmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dS4NWFWMEHgzREWxWKBFj9rk19fcouhWvSkakRNe8hzRVRCBQuceUS5Up9m96KetH
	 WFKwF+0JemkvA2gEXJmwBNgrpJHq+fo0vCe4cCBSFdzg+atzZVkOkqaMy7TVq8XRTg
	 qB+n5IqGaHJDkNp/tX/Oru0HZpv9gUuJJLtlWFxJAuowjuz7NIhpH0BorrfpFpTD0q
	 DhQ1udij026w9OKig7NQJu4oDIJWfoY6wxgioMsq2QTWy7ZdTIKXy5gmI1scZ54ka9
	 QvW8B0r82vg7FWoRP2fhTq2ZH7BZfdKmzWmkJgfxvd3r2IPUVZPdZj0sjlzxviQ27F
	 Mb7QA48DmU0YA==
From: Will Deacon <will@kernel.org>
To: Zhangfei Gao <zhangfei.gao@linaro.org>,
	jean-philippe <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>,
	Jason Gunthorpe <jgg@nvidia.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	Wenkai Lin <linwenkai6@hisilicon.com>
Subject: Re: [PATCH] iommu/arm-smmu-v3: disable stall for quiet_cd
Date: Tue, 12 Dec 2023 17:21:01 +0000
Message-Id: <170238473311.3099166.16078152394414654471.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20231206005727.46150-1-zhangfei.gao@linaro.org>
References: <20231206005727.46150-1-zhangfei.gao@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 6 Dec 2023 08:57:27 +0800, Zhangfei Gao wrote:
> From: Wenkai Lin <linwenkai6@hisilicon.com>
> 
> In the stall model, invalid transactions were expected to be
> stalled and aborted by the IOPF handler.
> 
> However, when killing a test case with a huge amount of data, the
> accelerator streamline can not stop until all data is consumed
> even if the page fault handler reports errors. As a result, the
> kill may take a long time, about 10 seconds with numerous iopf
> interrupts.
> 
> [...]

Applied to will (for-joerg/arm-smmu/updates), thanks!

[1/1] iommu/arm-smmu-v3: disable stall for quiet_cd
      https://git.kernel.org/will/c/b41932f54458

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

