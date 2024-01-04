Return-Path: <kvm+bounces-5623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 77C07823C07
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 07:07:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1AEC5B24DFD
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 06:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF68C1DFC7;
	Thu,  4 Jan 2024 06:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1QRK1wQ2"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2A01D68E;
	Thu,  4 Jan 2024 06:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=WHH7EjkqAp4gv4LEq1uUq0Aky/vKU/3Flfj3XeBndLY=; b=1QRK1wQ2+BzwBdOIALghzMO+ie
	k5F/PyUFVVzAw65jMQcC5zjWToU/ZB9UVwIw2fCLSsgZUxcPW18XhVJbps0TDRbq5GUEghbNHvc64
	wZ30HAw+sZOJ/0LeZr6qKFTLKlDaoiOGSZhSFx19eYBQy6MLrmyoy3LZQ8CGmjpUfUy6Lb3+VW7xE
	b8dRsuddWyeE/DUf9ugMzsaS5nm9GC4NvnL9ZdO7vR4CTfg2JMzBBbT1mvugm6RPmweAg/tfgeWDd
	ZFRRKETsb/guzT3SJcisYK+vnIsH8VxX+qLBr1Y8a52urV37Oc3llxre/gkEKQfDlfbeUxsufHZbM
	0Cw8TBFg==;
Received: from [50.53.46.231] (helo=[192.168.254.15])
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rLGsX-00Cwt8-0b;
	Thu, 04 Jan 2024 06:06:53 +0000
Message-ID: <1ab4ff24-4e67-43d7-90b7-0131182b7e1f@infradead.org>
Date: Wed, 3 Jan 2024 22:06:52 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: Tree for Jan 2 (riscv & KVM problem)
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
 Linux Next Mailing List <linux-next@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 KVM list <kvm@vger.kernel.org>, linux-riscv <linux-riscv@lists.infradead.org>
References: <20240102165725.6d18cc50@canb.auug.org.au>
 <44907c6b-c5bd-4e4a-a921-e4d3825539d8@infradead.org>
 <20240103-d2201c92e97755a4bb438bc3@orel>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20240103-d2201c92e97755a4bb438bc3@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/3/24 07:18, Andrew Jones wrote:
> On Tue, Jan 02, 2024 at 10:07:21AM -0800, Randy Dunlap wrote:
>>
>>
>> On 1/1/24 21:57, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20231222:
>>>
>>
>> It is possible for a riscv randconfig to create a .config file with
>> CONFIG_KVM enabled but CONFIG_HAVE_KVM is not set.
>> Is that expected?
>>
>> CONFIG_HAVE_KVM_IRQCHIP=y
>> CONFIG_HAVE_KVM_IRQ_ROUTING=y
>> CONFIG_KVM_MMIO=y
>> CONFIG_HAVE_KVM_MSI=y
>> CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
>> CONFIG_HAVE_KVM_VCPU_ASYNC_IOCTL=y
>> CONFIG_KVM_XFER_TO_GUEST_WORK=y
>> CONFIG_KVM_GENERIC_HARDWARE_ENABLING=y
>> CONFIG_KVM_GENERIC_MMU_NOTIFIER=y
>> CONFIG_VIRTUALIZATION=y
>> CONFIG_KVM=m
>>
>> Should arch/riscv/kvm/Kconfig: "config KVM" select HAVE_KVM
>> along with the other selects there or should that "config KVM"
>> depend on HAVE_KVM?
> 
> We probably should add a patch which makes RISCV select HAVE_KVM and
> KVM depend on HAVE_KVM in order for riscv kvm to be consistent with
> the other KVM supporting architectures.
> 

Yes, I agree.

>>
>>
>> The problem .config file causes build errors because EVENTFD
>> is not set:
>>
>> ../arch/riscv/kvm/../../../virt/kvm/eventfd.c: In function 'kvm_irqfd_assign':
>> ../arch/riscv/kvm/../../../virt/kvm/eventfd.c:335:19: error: implicit declaration of function 'eventfd_ctx_fileget'; did you mean 'eventfd_ctx_fdget'? [-Werror=implicit-function-declaration]
>>   335 |         eventfd = eventfd_ctx_fileget(f.file);
>>       |                   ^~~~~~~~~~~~~~~~~~~
>>       |                   eventfd_ctx_fdget
>> ../arch/riscv/kvm/../../../virt/kvm/eventfd.c:335:17: warning: assignment to 'struct eventfd_ctx *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
>>   335 |         eventfd = eventfd_ctx_fileget(f.file);
>>       |                 ^
>>
> 
> Hmm. riscv kvm selects HAVE_KVM_EVENTFD, which selects EVENTFD. I'm
> not sure how the lack of HAVE_KVM is leading to this.

The "select HAVE_KVM_EVENTFD" is gone in linux-next.

-- 
#Randy

