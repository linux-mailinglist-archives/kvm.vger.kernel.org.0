Return-Path: <kvm+bounces-4215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F3EC80F3FE
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 18:05:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ECB821F217FE
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 17:05:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F8E07B3C7;
	Tue, 12 Dec 2023 17:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wrADt0vC"
X-Original-To: kvm@vger.kernel.org
X-Greylist: delayed 35993 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Dec 2023 09:05:40 PST
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [IPv6:2001:41d0:203:375::ab])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F11E8F
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 09:05:40 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702400735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ul4QCMX3zRBmaeSj7e153y54BDj6LkmaO6zi6VJEA/Y=;
	b=wrADt0vCWwcTpDluna3v9HiYIbV3KF9L5lBfyDpqZaNKbvuxsMPwGk2GQ+JttAvvY4Z6D1
	S8TVJiZtIlvXp2keeHri4Jon4KZ9ZsAfo76GwI4ImjSLUHK/e0WaNYS4nV0yt2XClJuFaQ
	lihnqacr/GFsrY8zYeb0MbWzOGJ0pao=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: broonie@kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Ensure sysreg-defs.h is generated at the expected path
Date: Tue, 12 Dec 2023 17:05:02 +0000
Message-ID: <170240034091.513070.15669155471561151239.b4-ty@linux.dev>
In-Reply-To: <20231212070431.145544-2-oliver.upton@linux.dev>
References: <20231212070431.145544-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 12 Dec 2023 07:04:32 +0000, Oliver Upton wrote:
> Building the KVM selftests from the main selftests Makefile (as opposed
> to the kvm subdirectory) doesn't work as OUTPUT is set, forcing the
> generated header to spill into the selftests directory. Additionally,
> relative paths do not work when building outside of the srctree, as the
> canonical selftests path is replaced with 'kselftest' in the output.
> 
> Work around both of these issues by explicitly overriding OUTPUT on the
> submake cmdline. Move the whole fragment below the point lib.mk gets
> included such that $(abs_objdir) is available.
> 
> [...]

Thanks folks for the quick review / testing. I'll get this out ASAP, the
VGIC RD changes from Marc need to go in for 6.7 anyway.

[1/1] KVM: selftests: Ensure sysreg-defs.h is generated at the expected path
      https://git.kernel.org/kvmarm/kvmarm/c/0c12e6c8267f

--
Best,
Oliver

