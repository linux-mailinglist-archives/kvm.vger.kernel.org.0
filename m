Return-Path: <kvm+bounces-3858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 05977808831
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 13:44:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A53111F22584
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 12:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5400F3D0DF;
	Thu,  7 Dec 2023 12:44:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A979811F;
	Thu,  7 Dec 2023 04:44:33 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4SmDVl4Jpgz4xKl;
	Thu,  7 Dec 2023 23:44:31 +1100 (AEDT)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: npiggin@gmail.com, christophe.leroy@csgroup.eu, fbarrat@linux.ibm.com, ajd@linux.ibm.com, arnd@arndb.de, gregkh@linuxfoundation.org, Zhao Ke <ke.zhao@shingroup.cn>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, shenghui.qu@shingroup.cn, luming.yu@shingroup.cn, dawei.li@shingroup.cn
In-Reply-To: <20231129075845.57976-1-ke.zhao@shingroup.cn>
References: <20231129075845.57976-1-ke.zhao@shingroup.cn>
Subject: Re: [PATCH v2] powerpc: Add PVN support for HeXin C2000 processor
Message-Id: <170195271167.2310221.14120518840277202418.b4-ty@ellerman.id.au>
Date: Thu, 07 Dec 2023 23:38:31 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Wed, 29 Nov 2023 15:58:45 +0800, Zhao Ke wrote:
> HeXin Tech Co. has applied for a new PVN from the OpenPower Community
> for its new processor C2000. The OpenPower has assigned a new PVN
> and this newly assigned PVN is 0x0066, add pvr register related
> support for this PVN.
> 
> 

Applied to powerpc/next.

[1/1] powerpc: Add PVN support for HeXin C2000 processor
      https://git.kernel.org/powerpc/c/e12d8e2602d2bcd26022eff3e2519d25925e760c

cheers

