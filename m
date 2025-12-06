Return-Path: <kvm+bounces-65458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C5F0CA9FC6
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 04:39:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B78383162C47
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 03:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC50729DB6E;
	Sat,  6 Dec 2025 03:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="coIeJHot"
X-Original-To: kvm@vger.kernel.org
Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9F221E087
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 03:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764992334; cv=none; b=J7CQxp0w5XXgXeH+YZcHSodSSagp2p1qe/h0bcv3GKbiZ0+hAdD7F1OvxapZzQepLSacSZCOH/7VSafzLYP6YPjZJRVO6dJo2QcFUkAWCTlkrdLWWcJpw4BbHhF4IEmpDxzYhjDMxUYgTzJNo250vfIs+BcqlFltIkyGQsqbycA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764992334; c=relaxed/simple;
	bh=RPIuaxf//AbFhM1/mGaCmgPDo6nxo24jyaZnDA6G0ic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JNAhcwVrHO0BHIPQH8m8GAU+3i0+LfVapay87pPAN7+uRE0hisILpUsGnPYJwwcj6E5UXcrTTd2n3C0cLxXptzu2qA7zsddeO3YyFAKcEeI4TU63JE6h5WgaxDzUi9uQvTUGhWakcTvffAHoEsrOPmzMm9c/oEQS/eJvyzMq+yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=coIeJHot; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Received: from eig-obgw-5003b.ext.cloudfilter.net ([10.0.29.155])
	by cmsmtp with ESMTPS
	id RakavG0gvipkCRj8AvFagj; Sat, 06 Dec 2025 03:38:46 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id Rj89vThIp2l0kRj89v4wgo; Sat, 06 Dec 2025 03:38:45 +0000
X-Authority-Analysis: v=2.4 cv=UfRRSLSN c=1 sm=1 tr=0 ts=6933a545
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=ujWNxKVE5dX343uAl30YYw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=1XWaLZrsAAAA:8 a=_lKBnUPEwlkEFLTacEwA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=KoD1NRD0QaV+f74bc5iSUT0wwYVNJpat/RcP0vQRNuI=; b=coIeJHotksEB6dU0JU8LIyi2+L
	uaDb55h2Mt1UuG3h/KfXxkyCM9kNkUWFXfKhHQ4o8JDSD7EQAoRXlQNhy2MPsqj9G6CEDFz/Atw+9
	ZgQjnWppwz+a1nyxKyA8oa3XON37XtoLsHEsqBF7NciO4/cTYHyJsaGDdkZ1q96dXAR3vN+Ajgd8E
	26oVQjWOBLooorvXiIFmWbm5h0W8vYG/Im+2W7ub8NiQ1hVB5GfsOo4OHyrJbTvh1tDzKIt53tiIR
	QYbVpumaH0gvsFCV4zcXTBdq2yPsnMuu7hmsfqp+jYwJ4mvpvuF9UPJnj4fcmmFTX5nHWOJenYOGa
	9yhq7lSQ==;
Received: from i118-18-233-1.s41.a027.ap.plala.or.jp ([118.18.233.1]:61266 helo=[10.83.24.44])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1vRj86-00000002EOT-2JGv;
	Fri, 05 Dec 2025 21:38:43 -0600
Message-ID: <0018d1c0-58ec-4b31-b016-472795990923@embeddedor.com>
Date: Sat, 6 Dec 2025 12:38:14 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: Remove subtle "struct kvm_stats_desc" pseudo-overlay
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 "Gustavo A . R . Silva" <gustavoars@kernel.org>
References: <20251205232655.445294-1-seanjc@google.com>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20251205232655.445294-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 118.18.233.1
X-Source-L: No
X-Exim-ID: 1vRj86-00000002EOT-2JGv
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: i118-18-233-1.s41.a027.ap.plala.or.jp ([10.83.24.44]) [118.18.233.1]:61266
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 8
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHfLOnlcxCEYApwGQdBJ0d4v8CCQyIH/+8v58rRDzefqYRRRo78XOFltvz3JBCdw5nlqI8dnhz/OtaP0KKh7v+mlRhOczqkZsv8yJuJdh5NMzUuAO4Aj
 5+24oF7tusjn5Qz7FJZW/iNn5VMIoEtun6z4++8z1vzoQ2k1HwWCDRT02e5RXG9z1kZ3me3u+J0uF7CMf5Hgsq0CSp9vm+jvX/M=



On 12/6/25 08:26, Sean Christopherson wrote:
> Remove KVM's internal pseudo-overlay of kvm_stats_desc, which subtly
> aliases the flexible name[] in the uAPI definition with a fixed-size array
> of the same name.  The unusual embedded structure results in compiler
> warnings due to -Wflex-array-member-not-at-end, and also necessitates an
> extra level of dereferencing in KVM.  To avoid the "overlay", define the
> uAPI structure to have a fixed-size name when building for the kernel.

Nice. Thanks for this.

> 
> Opportunistically clean up the indentation for the stats macros, and
> replace spaces with tabs.
> 
> No functional change intended.
> 
> Reported-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Closes: https://lore.kernel.org/all/aPfNKRpLfhmhYqfP@kspp
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Acked-by: Gustavo A. R. Silva <gustavoars@kernel.org>

-Gustavo

