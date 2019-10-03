Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDD7C9F57
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 15:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730386AbfJCNX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 09:23:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbfJCNX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 09:23:26 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 238833C919;
        Thu,  3 Oct 2019 13:23:26 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 093B510013A7;
        Thu,  3 Oct 2019 13:23:23 +0000 (UTC)
Date:   Thu, 3 Oct 2019 15:23:21 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5 06/10] KVM: Allow kvm_device_ops to be const
Message-ID: <20191003132321.jd7wtkbcdmyx7gnv@kamzik.brq.redhat.com>
References: <20191002145037.51630-1-steven.price@arm.com>
 <20191002145037.51630-7-steven.price@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002145037.51630-7-steven.price@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 03 Oct 2019 13:23:26 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 02, 2019 at 03:50:33PM +0100, Steven Price wrote:
> Currently a kvm_device_ops structure cannot be const without triggering
> compiler warnings. However the structure doesn't need to be written to
> and, by marking it const, it can be read-only in memory. Add some more
> const keywords to allow this.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  include/linux/kvm_host.h | 4 ++--
>  virt/kvm/kvm_main.c      | 6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
