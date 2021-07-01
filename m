Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEFE3B91D8
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 14:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236501AbhGAM6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 08:58:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236464AbhGAM6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 08:58:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDA2761402;
        Thu,  1 Jul 2021 12:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625144164;
        bh=2F2NkJoy0oC8PHuVSSObVqxbVRioQcbYvBDlNtzhQUg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=scI6StJMAeja2JMW7wsaNAzjL6k4BJUEBXroLKiuOp9x+YKh/N6CBQmg9UEH6vTgd
         AXNjSsGNnqR0FrU9zPwDyGra9FClBhvaXgqH/FyD6j3aAdPXq/iP4N7VHMtsp4lcuj
         Myd2zKbaak1DSeVRzluoLbpNEkEt8i8GtDCL7GeAxWquuc3gLk5RTbqu0ImGCdv5tk
         zTRKpzMGUvL4YhZU0oXBI0O9ZeA44vjViN8qNHnITrmzu45Y9cg1SxU1HLUFKQJ7Eg
         SuzF8EeKAEnaXog8KiWmFgQsC+E57EnSkJj+Q2qYfCGnWE7veKZwh5v8ji+sEIgfZc
         mwAAF91T7p1bw==
Date:   Thu, 1 Jul 2021 13:55:58 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v2 01/13] KVM: arm64: Remove trailing whitespace in
 comments
Message-ID: <20210701125558.GB9757@willie-the-truck>
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-2-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615133950.693489-2-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 02:39:38PM +0100, Fuad Tabba wrote:
> Editing this file later, and my editor always cleans up trailing
> whitespace. Removing it earler for clearer future patches.

s/earler/earlier/

Although the commit message is probably better as:

  "Remove trailing whitespace from comment in trap_dbgauthstatus_el1()."

Will
