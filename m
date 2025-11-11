Return-Path: <kvm+bounces-62697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D642DC4A890
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 02:31:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0971F1897194
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 01:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DCC7347FEE;
	Tue, 11 Nov 2025 01:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pku.edu.cn header.i=@pku.edu.cn header.b="ToXLWN4C"
X-Original-To: kvm@vger.kernel.org
Received: from pku.edu.cn (mx18.pku.edu.cn [162.105.129.181])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF972DECB0;
	Tue, 11 Nov 2025 01:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.105.129.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823762; cv=none; b=f+wYi51LrLrGHtoLx4Xq6JBde3AHimeVdWe/CTVbmHenrIKc1J+sV7QYE0yXG8eqmSCndd0+bS9rR+nzYk3zAWvV8NvCcjoCKmKvlhW5A5E1JgN43W0HNodu5DJIe3yyZO/oQ9lKXvoP26MNEUMvuOWGj7pzPOcB0bzzwdtlCwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823762; c=relaxed/simple;
	bh=DC6tzSRPvXCbfagUYrWGYoNPomr9BM0hpi9ENSOEaCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XeTkjq2LdJWm4r/o8M/HHEqxuQLZdZYu6poB3cmR8Ff5oa1ILQsZObZRdFVBeT6Fad5DCoxJ3svUZFYHayMWbVIEmBEynE4Vrbj+0Z8DqGtZYCDeacdxMiV6pSoXedZ3eM0vVPIA8oo8Uze6gJplJG8eXaJs/CmAZmsXg7ZCjf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pku.edu.cn; spf=pass smtp.mailfrom=pku.edu.cn; dkim=pass (1024-bit key) header.d=pku.edu.cn header.i=@pku.edu.cn header.b=ToXLWN4C; arc=none smtp.client-ip=162.105.129.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pku.edu.cn
Received: from pku.edu.cn (unknown [124.127.12.215])
	by mtasvr (Coremail) with SMTP id _____7DwvPbjjRJpg3pqAA--.10916S3;
	Tue, 11 Nov 2025 09:14:12 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=pku.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
	Message-ID:References:MIME-Version:Content-Type:
	Content-Disposition:In-Reply-To; bh=DC6tzSRPvXCbfagUYrWGYoNPomr9
	BM0hpi9ENSOEaCs=; b=ToXLWN4C0FAOhLb6uD2GGIsXc+YxDnnxoYr3f9R5DTdg
	RJ/nc5Rf6on8B7Znw0zt2FRta65fJhcrkzj5Zfs45S/LNIa1EPRwp8Qx6SgiIHxl
	Z0/3HKGeorLPvEWiAw18p0Moy3nSZOy2K0EyaNO0NQwF9lDUzSP+GwLO9DxW56Q=
Received: from localhost (unknown [124.127.12.215])
	by front01 (Coremail) with SMTP id 5oFpogD3aJXdjRJpMYNfAQ--.62886S2;
	Tue, 11 Nov 2025 09:14:11 +0800 (CST)
Date: Tue, 11 Nov 2025 09:14:05 +0800
From: Ruihan Li <lrh2000@pku.edu.cn>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: lei4.wang@intel.com, Sean Christopherson <seanjc@google.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>, Jim Mattson <jmattson@google.com>, 
	Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>, 
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Ruihan Li <lrh2000@pku.edu.cn>
Subject: Re: The current status of PKS virtualization
Message-ID: <dh77d4uo3riuf3d7dbtkbz3k5ubeucnaq4yjdqdbo6uqyplggg@pesxsx2jbkac>
References: <20220424101557.134102-1-lei4.wang@intel.com>
 <20251110162900.354698-1-lrh2000@pku.edu.cn>
 <CABgObfZc4FQa9sj=FK5Q-tQxr2yQ-9Ez69R5z=5_R0x5MS1d0A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgObfZc4FQa9sj=FK5Q-tQxr2yQ-9Ez69R5z=5_R0x5MS1d0A@mail.gmail.com>
X-CM-TRANSID:5oFpogD3aJXdjRJpMYNfAQ--.62886S2
X-CM-SenderInfo: yssqiiarrvmko6sn3hxhgxhubq/1tbiAgEKBWkA6EEIawAbs0
X-CM-DELIVERINFO: =?B?VGcNtKaAH6dYjNjDbLdWX9VB7ttaQFyXTaecYZzOeDisy/krtsX5TsLkpeAzENeCPc
	0+BGeASIntztwfi8J9JaFaT+dnICNqXH7EJCCnrbW1tLHsW52gv9uWjM1BYQgcLyLdTJq3
	BsEV3AmBFYi3CP5TLIOXQrZxuxYiJTIbLLQgA65VE16RpV3qlYCc+67qCfuTWQ==
X-Coremail-Antispam: 1Uk129KBj9xXoW7JrW7uF1kGw13Gr1rWw1kXrc_yoWfJFXEga
	y0kr4xJ340kay2yws5KFyrCr9Iga1xur9Fyw1kXr17G342gr4q9a4kCrykZryUX395GrsI
	vw15trW2k34xuosvyTuYvTs0mTUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbh8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s
	0DM7CIcVAFz4kK6r1j6r18M28lY4IE4IxF12IF4wA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJVWx
	Jr1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
	Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
	Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
	ACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOlksUUUUU

On Mon, Nov 10, 2025 at 09:44:36PM +0100, Paolo Bonzini wrote:
> No, there is none. In fact, the only dependency of the original series
> on host PKS was for functions to read/write the host PKRS MSR. Without
> host PKS support it could be loaded with all-ones, or technically it
> could even be left with the guest value. Since the host clears
> CR4.PKS, the actual value won't matter.

Thanks a lot for your quick and detailed reply! That's good news for me.
Then I plan to spend some time tidying up my rebased version to see if I
can get PKS virtualization upstreamed.

As a side note, I can no longer contact the original author of this
patch series. At least, my previous email was returned by Intel's
server. However, since more than three years have passed, I assume it's
okay for me to post a new version after I have the code ready.

Thanks,
Ruihan Li


