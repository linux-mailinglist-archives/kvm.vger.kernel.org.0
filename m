Return-Path: <kvm+bounces-62772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C978DC4E7AE
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 15:30:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54AE2189DE5D
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 14:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF0262FE075;
	Tue, 11 Nov 2025 14:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pku.edu.cn header.i=@pku.edu.cn header.b="Y0+IlpUQ"
X-Original-To: kvm@vger.kernel.org
Received: from pku.edu.cn (mx17.pku.edu.cn [162.105.129.180])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37EFB223339;
	Tue, 11 Nov 2025 14:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.105.129.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762871062; cv=none; b=gEK4UAbFNvyUCCuMKzhm6ZMx0898VdtAMNV9ZV2Rj6PZg7IKPwnvcl0m8iWsa61DM8D9Jof8S456YOMC35gfjCtlYaACqRWWazYkbPiQDOv842lggV2LgLWNdIxAV4Axj5uxT4lfTs+PK3aa1JAhqA7qkhjsQvRPGJh7bxNdcMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762871062; c=relaxed/simple;
	bh=KtJPbDIPEl/rz5R8SUnGKevXYf9vv50bphD4NuKaYS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TC6cgG2Z2xdRJg4qF1mdH5tY2FaysyIuj7dIinFMClpW3NvvT+WpAbZvVEijF00+LJrOywI+gS2tMMaatLzJX1agqeaGeulHGOcR3q6BmyYPKskyAUGxA/8gpPledhS5jj+yiOkxEuDU5pjl/r/hJST5EWF6wIVzf5tTo98Wwic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pku.edu.cn; spf=pass smtp.mailfrom=pku.edu.cn; dkim=pass (1024-bit key) header.d=pku.edu.cn header.i=@pku.edu.cn header.b=Y0+IlpUQ; arc=none smtp.client-ip=162.105.129.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pku.edu.cn
Received: from pku.edu.cn (unknown [10.4.225.83])
	by mtasvr (Coremail) with SMTP id _____7DwgckGRxNpjCgZAA--.5377S3;
	Tue, 11 Nov 2025 22:24:07 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=pku.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
	Message-ID:References:MIME-Version:Content-Type:
	Content-Disposition:In-Reply-To; bh=lDdGvZ5o+5U7n9Bxx/uxM4VJSAxZ
	i7exu28/Im4HNYU=; b=Y0+IlpUQ9xhZVfZPg52RJAHSvE6b7cd52DuEhQWQVtTL
	rPj6NjTfNsQGftSNwWha5EJhK94EKIrkOJw7IaKH+DJjcztN9gAJHZ582VnFPwuS
	yNmDCm3gwnB4tDEJ9Qu9ar/0UAPbukzQ4b3Opfiga5OC+35xAvU4dIPDqtQjr2Y=
Received: from localhost (unknown [10.4.225.83])
	by front02 (Coremail) with SMTP id 54FpogB3kOECRxNpn7ZfAQ--.57615S2;
	Tue, 11 Nov 2025 22:24:05 +0800 (CST)
Date: Tue, 11 Nov 2025 22:24:02 +0800
From: Ruihan Li <lrh2000@pku.edu.cn>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, lei4.wang@intel.com, 
	Sean Christopherson <seanjc@google.com>, Jim Mattson <jmattson@google.com>, 
	Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>, 
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Ruihan Li <lrh2000@pku.edu.cn>
Subject: Re: The current status of PKS virtualization
Message-ID: <hrfy7h7oob5qimip6midrmuy53vqgbdfgnmwc5avi2zdsd3l36@ts43lrmct5r3>
References: <20220424101557.134102-1-lei4.wang@intel.com>
 <20251110162900.354698-1-lrh2000@pku.edu.cn>
 <CABgObfZc4FQa9sj=FK5Q-tQxr2yQ-9Ez69R5z=5_R0x5MS1d0A@mail.gmail.com>
 <dh77d4uo3riuf3d7dbtkbz3k5ubeucnaq4yjdqdbo6uqyplggg@pesxsx2jbkac>
 <2701ea93-48a6-492a-9d4a-17da31d953c2@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2701ea93-48a6-492a-9d4a-17da31d953c2@intel.com>
X-CM-TRANSID:54FpogB3kOECRxNpn7ZfAQ--.57615S2
X-CM-SenderInfo: yssqiiarrvmko6sn3hxhgxhubq/1tbiAgEKBWkA6EEIawAfsw
X-CM-DELIVERINFO: =?B?E2et+6aAH6dYjNjDbLdWX9VB7ttaQFyXTaecYZzOeDisy/krtsX5TsLkpeAzENeCPc
	0+BGeASIntztwfi8J9JaFaT+eTd2Q/Bpqsg/wTLQBzPC17ZCqxguZlOu2ljLHdfYWYua/C
	bc0GU4Zb5Gp81/W9RZoAN1ACIG6siYdp3Q1ll8QdX4CLyLyxmcvXZyx6L6rQag==
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

On Tue, Nov 11, 2025 at 01:40:08PM +0800, Chenyi Qiang wrote:
> Lei has left Intel so the mail address in unreachable.
> 
> And as you found, we dropped the PKS KVM upstream along with the base PKS support
> due to no valid use case in Linux. You can feel free to continue the upstream work.

Thanks for the reply and for the information!

By the way, I'm just curious (feel free to ignore this question): Is
there an on-list discussion that rejects the originally proposed PKS use
cases?

I found that pmem stray write protection was rejected [1], but there is
no reason given nor any reference provided. After searching the list, I
found the latest patch series that attempts to add pmem stray protection
[2]. However, I didn't find any discussion rejecting the use case. Maybe
the discussion happened off the list? Or did I miss something?

 [1]: https://lore.kernel.org/lkml/3b3c941f1fb69d67706457a30cecc96bfde57353.camel@intel.com/
 [2]: https://lore.kernel.org/lkml/20220419170649.1022246-1-ira.weiny@intel.com/

> But I'm not sure if your use case is compelling enough to be accepted by maintainers.

Yeah, I have the same concern. So, I asked about the current status
first. So far, Paolo's reply seems positive, so maybe I can try it out
if I can find enough time.

Thanks,
Ruihan Li


