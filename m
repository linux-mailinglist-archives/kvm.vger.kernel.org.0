Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E3542A002
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 10:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235001AbhJLIg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 04:36:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234745AbhJLIg6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 04:36:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42FD960EE5;
        Tue, 12 Oct 2021 08:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634027697;
        bh=y5QPB6eE4ONXHXwst+TlRZCllr+CVcBJhudeYrw0nAg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nHBp43jRavp//RKwcQm+yNYLrR42l0Hh4Qe/WRHZBOYT1hkXOKj18QD51yHQ1CjIg
         QMZ6auZhKyAHqoO82wgLEL34+ZanJHw+3ojTwOpkTZeZN8fx8otx3e/6Lukv/4MrUz
         XLHT1hMOvNRt7+ntP45JWkEp4eeiR0t+PsKnfk6gLv5fu5idxW4LzY7bDXiPkC/hpW
         Hx3HOR5imm67w4rXrxFM6UOez+BquxVBpLw2TdQrekOWxOWzZJOMoSznz3i7U7Qb2D
         0e/21PjXzdfcYD9Yn46qhobqmU4uCpl7ZHY2R9sCk/mdGQL/KQWZQLxPoDqokMEJl5
         g0meDays/IlVA==
Date:   Tue, 12 Oct 2021 09:34:53 +0100
From:   Will Deacon <will@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
        christoffer.dall@arm.com, vivek.gautam@arm.com
Subject: Re: [PATCH kvmtool 08/10] Add --nocompat option to disable compat
 warnings
Message-ID: <20211012083452.GC5156@willie-the-truck>
References: <20210923144505.60776-1-alexandru.elisei@arm.com>
 <20210923144505.60776-9-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923144505.60776-9-alexandru.elisei@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 03:45:03PM +0100, Alexandru Elisei wrote:
> Commit e66942073035 ("kvm tools: Guest kernel compatability") added the
> functionality that enables devices to print a warning message if the device
> hasn't been initialized by the time the VM is destroyed. The purpose of
> these messages is to let the user know if the kernel hasn't been built with
> the correct Kconfig options to take advantage of the said devices (all
> using virtio).
> 
> Since then, kvmtool has evolved and now supports loading different payloads
> (like firmware images), and having those warnings even when it is entirely
> intentional for the payload not to touch the devices can be confusing for
> the user and makes the output unnecessarily verbose in those cases.
> 
> Add the --nocompat option to disable the warnings; the warnings are still
> enabled by default.
> 
> Reported-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  builtin-run.c            | 5 ++++-
>  guest_compat.c           | 1 +
>  include/kvm/kvm-config.h | 1 +
>  3 files changed, 6 insertions(+), 1 deletion(-)

Sorry, bikeshed moment here, but why don't we just have a '--quiet' option
that shuts everything up unless it's fatal?

Will
