Return-Path: <kvm+bounces-52055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DFD5B00C17
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 21:20:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A316C1CA1B66
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 19:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B98442FCFD5;
	Thu, 10 Jul 2025 19:20:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from pegase1.c-s.fr (pegase1.c-s.fr [93.17.236.30])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590B921E0B2;
	Thu, 10 Jul 2025 19:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.236.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752175240; cv=none; b=ZOCXIAqEQx3BDHHpZzCbGQcrEWH7OU9fKtLXSCZS0HpYL0eWin0iNQOI6T74OQ1DTWICAvh63C9WIF5wiPprYUmkD4Vq3tbsZoAnL+5wMKMcZ3VBi8jJUA5NcjrPoddNxKa5q4Foru5b4gk+CumcmqZGRo16/P2gts/R6fTnSXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752175240; c=relaxed/simple;
	bh=E8OVQZLpK4Tea0M0z1prclRGXJhvDwhAOdcbPZ8W0qQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N8uSEXNDHGDNWre3KJKrUzgFTL0BVnpRF/dKDWzuFJ2ZbOi/cu2Sx1toRbavTeRStqFvC0YSkSwOkoQ9ao1ectFXrwKSBFtzBfb2stvmWLh7g9Q5tQu1dI5P27b0CAMEO+0FUvBnR56LY/1LQ9+gHeQu1xLbaFit5sZluzKsLXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.236.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
	by localhost (Postfix) with ESMTP id 4bdP4J04BXz9sy4;
	Thu, 10 Jul 2025 20:48:16 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
	by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R1HCylfEBLNv; Thu, 10 Jul 2025 20:48:15 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase1.c-s.fr (Postfix) with ESMTP id 4bdP4H68w9z9sx4;
	Thu, 10 Jul 2025 20:48:15 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id C419C8B76E;
	Thu, 10 Jul 2025 20:48:15 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id dC-o8g2953Tg; Thu, 10 Jul 2025 20:48:15 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 5444E8B763;
	Thu, 10 Jul 2025 20:48:15 +0200 (CEST)
Message-ID: <e5de8010-5663-47f4-a2f0-87fd88230925@csgroup.eu>
Date: Thu, 10 Jul 2025 20:48:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] powerpc: Replace the obsolete address of the FSF
To: Thomas Huth <thuth@redhat.com>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <20250710121657.169969-1-thuth@redhat.com>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <20250710121657.169969-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 10/07/2025 à 14:16, Thomas Huth a écrit :
> From: Thomas Huth <thuth@redhat.com>

As far as I know, licensing related stuff have to be copied to 
linux-spdx@vger.kernel.org

There is an entry for it in the MAINTAINERS file:

LICENSES and SPDX stuff
M:	Thomas Gleixner <tglx@linutronix.de>
M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
L:	linux-spdx@vger.kernel.org
S:	Maintained
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/spdx.git
F:	COPYING
F:	Documentation/process/license-rules.rst
F:	LICENSES/
F:	scripts/spdxcheck-test.sh
F:	scripts/spdxcheck.py
F:	scripts/spdxexclude

Christophe


