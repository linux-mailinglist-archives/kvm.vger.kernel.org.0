Return-Path: <kvm+bounces-3848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EBDB780868C
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 12:20:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A95E5283D27
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 11:20:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC84B37D25;
	Thu,  7 Dec 2023 11:19:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C18FA
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 03:19:52 -0800 (PST)
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SmBXc19dHzrVTj;
	Thu,  7 Dec 2023 19:16:00 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Dec 2023 19:19:48 +0800
Subject: Re: [PATCH 2/5] KVM: selftests: aarch64: Remove redundant newlines
To: Andrew Jones <ajones@ventanamicro.com>
CC: <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
	<kvm-riscv@lists.infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<maz@kernel.org>, <oliver.upton@linux.dev>, <anup@brainfault.org>,
	<borntraeger@linux.ibm.com>, <frankja@linux.ibm.com>,
	<imbrenda@linux.ibm.com>
References: <20231206170241.82801-7-ajones@ventanamicro.com>
 <20231206170241.82801-9-ajones@ventanamicro.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <3af8d9f4-96f6-568b-32f7-114c8346b199@huawei.com>
Date: Thu, 7 Dec 2023 19:19:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20231206170241.82801-9-ajones@ventanamicro.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected

On 2023/12/7 1:02, Andrew Jones wrote:
> TEST_* functions append their own newline. Remove newlines from
> TEST_* callsites to avoid extra newlines in output.
> 
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>

Acked-by: Zenghui Yu <yuzenghui@huawei.com>

