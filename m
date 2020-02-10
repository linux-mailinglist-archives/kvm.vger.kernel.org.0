Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32097157F1F
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 16:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbgBJPqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 10:46:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726991AbgBJPqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 10:46:15 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53B6620733;
        Mon, 10 Feb 2020 15:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581349574;
        bh=TTGiUvb9RHz3hdhmJfOzp0KIapqFPLU42O9zSWvHhOE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nbgh66A2RBEWvXx6MerEIUd9giZyvTUtyT0g89HKzIxi8UAO5FFSC3DotkWGBZgWh
         8VmqH2A4GRYx8VmqwMzWPYlvCHE9g4TRJiKoqXV66JFgqs70vggQKyGjqiH94fc6A/
         x27HEPnRKKPuNUTsEcUCTryiOPmjdOg06CwR+Wdo=
Date:   Mon, 10 Feb 2020 15:46:08 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Quentin Perret <qperret@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Anders Berg <anders.berg@lsi.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
Message-ID: <20200210154608.GA21086@willie-the-truck>
References: <20200210141324.21090-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210141324.21090-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 10, 2020 at 02:13:19PM +0000, Marc Zyngier wrote:
> KVM/arm was merged just over 7 years ago, and has lived a very quiet
> life so far. It mostly works if you're prepared to deal with its
> limitations, it has been a good prototype for the arm64 version,
> but it suffers a few problems:
> 
> - It is incomplete (no debug support, no PMU)
> - It hasn't followed any of the architectural evolutions
> - It has zero users (I don't count myself here)

I tend to use it to test that it still works, but that's it.

> - It is more and more getting in the way of new arm64 developments

To echo this last point, we're currently looking at the possibility of
using KVM to isolate VMs from the host in Android. The scope of the
changes we think we'll have to make would mean effectively duplicating
the existing code for 32-bit or implementing a whole load of unused and
untested functionality to keep the current structure. Neither of these
options are particularly satisfactory from a maintainance point of view,
so removing the 32-bit code if it doesn't have any significant use would
be welcomed:

Acked-by: Will Deacon <will@kernel.org>

Will
