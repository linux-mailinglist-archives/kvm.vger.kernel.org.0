Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0003371EA
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 13:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbhCKMBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 07:01:12 -0500
Received: from foss.arm.com ([217.140.110.172]:33920 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232579AbhCKMAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 07:00:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5931031B;
        Thu, 11 Mar 2021 04:00:47 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.54.221])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 245CE3F793;
        Thu, 11 Mar 2021 04:00:45 -0800 (PST)
Date:   Thu, 11 Mar 2021 12:00:43 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] KVM: arm64: Rename SCTLR_ELx_FLAGS to SCTLR_EL2_FLAGS
Message-ID: <20210311120043.GE37303@C02TD0UTHF1T.local>
References: <20210310152656.3821253-1-maz@kernel.org>
 <20210310152656.3821253-4-maz@kernel.org>
 <20210310154625.GA29738@willie-the-truck>
 <874khjxade.wl-maz@kernel.org>
 <20210310161546.GC29834@willie-the-truck>
 <87zgzagaqq.wl-maz@kernel.org>
 <20210310182022.GA29969@willie-the-truck>
 <20210311113529.GD37303@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311113529.GD37303@C02TD0UTHF1T.local>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021 at 11:35:29AM +0000, Mark Rutland wrote:
> Acked-by: Mark Rutland <nark.rutland@arm.com>

Upon reflection, maybe I should spell my own name correctly:

Acked-by: Mark Rutland <mark.rutland@arm.com>

... lest you decide to add a Mocked-by tag instead ;)

Mark.
