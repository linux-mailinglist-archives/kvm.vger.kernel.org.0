Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8FE308AE
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 08:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfEaGiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 02:38:01 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:60963 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727012AbfEaGiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 02:38:01 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45FZWp3WqVz9sNC; Fri, 31 May 2019 16:37:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1559284678; bh=uJogy/o2tF0TG72tKa16V0bqu3a3ZtarOxHHq6VhHA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J/6tHkKiN4NOMaDJTkaIlj0wO9yzK+TDi5XQGRqa2YHENarDUDwqm3Fn0cetaX4QL
         YEN3Is/gygUKwjVQUR+AqArWDvyqmzQ6Ox+cW09PXU1BaxAiFmR4o5d5WbCCjogS/5
         fzIFWpAiH+Y9l5HxPOksKfo1UhwxghhHRmM/iBDGIWdyjW6xHcuTHmXx21vglvqHSw
         zP+03ilUjpAs6aLdBdP9nTo8cW9wfjuje/YKAX/Cyc1E14DWIQB+4Cf1w46TEn1bv6
         fnhMQ+apuLQzPXfxQ/AcfRH0WzP5sFQ/y8n1oVOACucoEPJ1w5hAb93nmDEmqMorAx
         ZxyJJPAQD//sQ==
Date:   Fri, 31 May 2019 16:36:52 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: XIVE: fix page offset when clearing
 ESB pages
Message-ID: <20190531063652.GF26651@blackberry>
References: <20190528211324.18656-1-clg@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190528211324.18656-1-clg@kaod.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 28, 2019 at 11:13:24PM +0200, Cédric Le Goater wrote:
> Under XIVE, the ESB pages of an interrupt are used for interrupt
> management (EOI) and triggering. They are made available to guests
> through a mapping of the XIVE KVM device.
> 
> When a device is passed-through, the passthru_irq helpers,
> kvmppc_xive_set_mapped() and kvmppc_xive_clr_mapped(), clear the ESB
> pages of the guest IRQ number being mapped and let the VM fault
> handler repopulate with the correct page.
> 
> The ESB pages are mapped at offset 4 (KVM_XIVE_ESB_PAGE_OFFSET) in the
> KVM device mapping. Unfortunately, this offset was not taken into
> account when clearing the pages. This lead to issues with the
> passthrough devices for which the interrupts were not functional under
> some guest configuration (tg3 and single CPU) or in any configuration
> (e1000e adapter).
> 
> Signed-off-by: Cédric Le Goater <clg@kaod.org>

Thanks, patch applied to my kvm-ppc-fixes branch.

Paul.
