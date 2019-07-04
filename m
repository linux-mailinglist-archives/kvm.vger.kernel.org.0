Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4202A5F87A
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 14:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfGDMrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 08:47:15 -0400
Received: from foss.arm.com ([217.140.110.172]:40654 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbfGDMrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 08:47:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5368928;
        Thu,  4 Jul 2019 05:47:14 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 820843F718;
        Thu,  4 Jul 2019 05:47:12 -0700 (PDT)
Date:   Thu, 4 Jul 2019 13:47:10 +0100
From:   Dave Martin <Dave.Martin@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Okamoto Takayuki <tokamoto@jp.fujitsu.com>,
        Christoffer Dall <cdall@kernel.org>, kvm <kvm@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Zhang Lei <zhang.lei@jp.fujitsu.com>,
        Julien Grall <julien.grall@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] KVM: arm64/sve: Fix vq_present() macro to yield a bool
Message-ID: <20190704124709.GB2790@e103592.cambridge.arm.com>
References: <1562175770-10952-1-git-send-email-Dave.Martin@arm.com>
 <86wogynrbt.wl-marc.zyngier@arm.com>
 <1f39cc48-12d5-2e56-c218-b6b0dd05d8ce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f39cc48-12d5-2e56-c218-b6b0dd05d8ce@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 04, 2019 at 02:24:42PM +0200, Paolo Bonzini wrote:
> On 04/07/19 10:20, Marc Zyngier wrote:
> > +KVM, Paolo and Radim,
> > 
> > Guys, do you mind picking this single patch and sending it to Linus?
> > That's the only fix left for 5.2. Alternatively, I can send you a pull
> > request, but it feels overkill.
> 
> Sure, will do.
> 
> Paolo

Thanks all for the quick turnaround!

[...]

Cheers
---Dave
