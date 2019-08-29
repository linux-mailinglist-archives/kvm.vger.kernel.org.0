Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF9EFA15AF
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 12:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfH2KTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 06:19:51 -0400
Received: from foss.arm.com ([217.140.110.172]:41818 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727213AbfH2KTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 06:19:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D4B628;
        Thu, 29 Aug 2019 03:19:45 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 93D073F59C;
        Thu, 29 Aug 2019 03:19:44 -0700 (PDT)
Date:   Thu, 29 Aug 2019 11:19:42 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        andre.przywara@arm.com, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests RFC PATCH 04/16] arm/arm64: selftest: Add
 prefetch abort test
Message-ID: <20190829101942.GC44575@lakrids.cambridge.arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-5-git-send-email-alexandru.elisei@arm.com>
 <20190828140925.GC41023@lakrids.cambridge.arm.com>
 <e6b8a3c9-2e11-c806-da5b-8b66d8f63ce3@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6b8a3c9-2e11-c806-da5b-8b66d8f63ce3@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 09:18:35AM +0100, Alexandru Elisei wrote:
> On 8/28/19 3:09 PM, Mark Rutland wrote:
> > On Wed, Aug 28, 2019 at 02:38:19PM +0100, Alexandru Elisei wrote:
> >> +	/*
> >> +	 * AArch64 treats all regions writable at EL0 as PXN.
> > I didn't think that was the case, and I can't find wording to that
> > effect in the ARM ARM (looking at ARM DDI 0487E.a). Where is that
> > stated?
> 
> It's in ARM DDI 0487E.a, table D5-33, footnote c: "Not executable, because
> AArch64 execution treats all regions writable at EL0 as being PXN". I'll update
> the comment to include the quote.

Interesting; I was not aware of that particular behaviour. Thanks
for the pointer!

Mark.
