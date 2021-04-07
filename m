Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5598735765D
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 22:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbhDGU5S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 16:57:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhDGU5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 16:57:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2258661131;
        Wed,  7 Apr 2021 20:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617829027;
        bh=1Q2oOXUjRJwdCV+qOUNBymw/y9FGIdzI1jb6hvbjuZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jJg/YWZzVoLd0kBX/rSjkyXLycEWYmylXQ1cHt7V/whjGUBXNxjAc3sv9P5XuEiwm
         ZBGB2LMPwY8/fh4rqU6SuG8gck+wGF6mabpwZ38fKlVyQp6aZTL5+u4uSQwjP3m4l/
         GJaJFuEWSt6jJcXQtwFv45OT1478G3MES4y6mB1C6tdYBH3NJAUaO82M89AFI6yZ4u
         KkMH3yVUQqvV3vNWuYg3SzLN4uu0ISzfxEzctlSDWUjwA/Y+htRSGkeKoEkdxRTN5R
         SqLk3D1uLeLFmRwDIXyZMtCEL0h3U2jv3OZT9cGnMFG+YNR2kqWcP5Pw4Jw4szZKes
         WmJiDe4QKNKqg==
Date:   Wed, 7 Apr 2021 21:57:02 +0100
From:   Will Deacon <will@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Yanan Wang <wangyanan55@huawei.com>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>,
        Quentin Perret <qperret@google.com>,
        wanghaibin.wang@huawei.com, zhukeqian1@huawei.com,
        yuzenghui@huawei.com
Subject: Re: [RFC PATCH v3 1/2] KVM: arm64: Move CMOs from user_mem_abort to
 the fault handlers
Message-ID: <20210407205701.GA16198@willie-the-truck>
References: <20210326031654.3716-1-wangyanan55@huawei.com>
 <20210326031654.3716-2-wangyanan55@huawei.com>
 <cd6c8a86-b7b2-3d3e-121a-c9d1cb23c4b3@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd6c8a86-b7b2-3d3e-121a-c9d1cb23c4b3@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 07, 2021 at 04:31:31PM +0100, Alexandru Elisei wrote:
> On 3/26/21 3:16 AM, Yanan Wang wrote:
> > We currently uniformly permorm CMOs of D-cache and I-cache in function
> > user_mem_abort before calling the fault handlers. If we get concurrent
> > guest faults(e.g. translation faults, permission faults) or some really
> > unnecessary guest faults caused by BBM, CMOs for the first vcpu are
> 
> I can't figure out what BBM means.

Oh, I know that one! BBM means "Break Before Make". Not to be confused with
DBM (Dirty Bit Management) or BFM (Bit Field Move).

Will
