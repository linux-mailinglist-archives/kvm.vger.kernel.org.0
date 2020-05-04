Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F161A1C381B
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 13:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgEDLa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 07:30:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbgEDLa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 07:30:57 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44F3D2073E;
        Mon,  4 May 2020 11:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588591857;
        bh=VZLtzlcQTt1eJsb0z5+z2NjKOOqUX3h5X2JO4zv9pDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2OhI4xd+rijq0aBcmEM/iBxzF5t4ZID7LjsEROOxJ3U+rl8zzzZODfvwMGpGOIVOU
         hyTIJfu0kwTZZqy5wn/cm2xQcjZSwI8zFeAX/Cml8tlVeHtrwun8MrVVhu0ozgFYpj
         OhL5v6lGFQghRa1mpUK69u+KkaktGLi9EQgJ7HiM=
Date:   Mon, 4 May 2020 12:30:52 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com
Cc:     Andrew Jones <drjones@redhat.com>,
        Fangrui Song <maskray@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] KVM/arm fixes for 5.7, take #2
Message-ID: <20200504113051.GB1326@willie-the-truck>
References: <20200501101204.364798-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501101204.364798-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc, Paolo,

On Fri, May 01, 2020 at 11:12:00AM +0100, Marc Zyngier wrote:
> This is the second batch of KVM/arm fixes for 5.7. A compilation fix,
> a GICv4.1 fix, plus a couple of sanity checks (SP_EL0 save/restore,
> and the sanitising of AArch32 registers).
> 
> Note that the pull request I sent a week ago[1] is still valid, and
> that this new series is built on top of the previous one.
> 
> Please pull,

I don't see this queued up in the kvm tree, which appears to have been
sitting dormant for 10 days. Consequently, there are fixes sitting in
limbo and we /still/ don't have a sensible base for arm64/kvm patches
targetting 5.8.

Paolo -- how can I help get this stuff moving again? I'm more than happy
to send this lot up to Linus via arm64 if you're busy atm. Please just
let me know.

Cheers,

Will
