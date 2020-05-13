Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4447E1D210E
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 23:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgEMV3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 17:29:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728718AbgEMV3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 17:29:30 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBA29205ED;
        Wed, 13 May 2020 21:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589405370;
        bh=82keoslIP27mEcCwIYl6UmWhou7iCdqwqR319WJP/24=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J2pFC/rvtEq2MhEL7dK4dX8n/tVIAE+9YOl4lPE+v3YOqeTkTGzvdiPEY3sdO4+s4
         vn1aOGHij4CaEpfJWipmxe7Jr1chdQlwkRyixK+Q8VSbCrfwDeGbDYzFloSnhJ0ScE
         DmYN9QAjWI85lkM7RZRbO+2CEL0D/Wc64Uc3WuH4=
Date:   Wed, 13 May 2020 22:29:25 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] KVM: arm64: Move virt/kvm/arm to arch/arm64
Message-ID: <20200513212925.GD28594@willie-the-truck>
References: <20200513104034.74741-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513104034.74741-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 13, 2020 at 11:40:34AM +0100, Marc Zyngier wrote:
> Now that the 32bit KVM/arm host is a distant memory, let's move the
> whole of the KVM/arm64 code into the arm64 tree.
> 
> As they said in the song: Welcome Home (Sanitarium).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Will Deacon <will@kernel.org>

Will
