Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE46EA5093
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2019 10:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729916AbfIBIA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Sep 2019 04:00:57 -0400
Received: from foss.arm.com ([217.140.110.172]:49626 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729535AbfIBIA5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Sep 2019 04:00:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E19D728;
        Mon,  2 Sep 2019 01:00:56 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 73D583F71A;
        Mon,  2 Sep 2019 01:00:56 -0700 (PDT)
Date:   Mon, 2 Sep 2019 10:00:55 +0200
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 0/3] arm64: KVM: Kiss hyp_alternate_select() goodbye
Message-ID: <20190902080055.GA4320@e113682-lin.lund.arm.com>
References: <20190901211237.11673-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190901211237.11673-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 01, 2019 at 10:12:34PM +0100, Marc Zyngier wrote:
> hyp_alternate_select() is a leftover from the my second attempt at
> supporting VHE (the first one was never merged, thankfully), and is
> now an irrelevant relic. It was a way to patch function pointers
> without having to dereference memory, a bit like static keys for
> function calls.
> 
> Lovely idea, but since Christoffer mostly separated the VHE and !VHE
> hypervisor paths, most of the uses of hyp_alternate_select() are
> gone. What is left is two instances that are better replaced by
> already existing static keys. One of the instances becomes
> cpus_have_const_cap(), and the rest is a light sprinkling of
> has_vhe().
> 
> So off it goes.

I'm not sure I want to kiss hyp_alternate_select() at all, but away it
must go!

Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
