Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED5A7308B5
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 08:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfEaGiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 02:38:03 -0400
Received: from ozlabs.org ([203.11.71.1]:48897 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727015AbfEaGiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 02:38:02 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45FZWq43dbz9sNl; Fri, 31 May 2019 16:37:58 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1559284679; bh=rtaJK5c2pAdk4R/QIEKygQvNwObHOLrAeLHdUZ/G7yg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fp425+7sU1U0uPqoYUMQGM0zkElV/jX9BC7aqkvWrd/ICEsqLaaZ9KadtYP+8D3Y8
         HkCVvJVgUYLqf6Yj8NWkEjaMXZsUouKMkqV9NyO3mnCKFbUeVSLAu69bHMOn2UYIRH
         D59UOuYTS+1IIkXklUW9UONVda+XvvH4T5fgv+ZgpwV1TVgKf1MMeutsX65z3aHUvi
         3lezsedmV/go+xqe7RQj25AUywHVXMlM4gOx+l9WmfuI3XAERqlCaRL6pfAIwcMZR5
         EkA91S0Cd/WQFDpKW9qA04C4MIgVGBJnM7SJkXBHMrJ6Oa1mBdd2Yd+6qRPcu5HSDe
         N98e2umWk91Sw==
Date:   Fri, 31 May 2019 16:36:15 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: PPC: Book3S HV: XIVE: fixes for the KVM devices
Message-ID: <20190531063615.GE26651@blackberry>
References: <20190528121716.18419-1-clg@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190528121716.18419-1-clg@kaod.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 28, 2019 at 02:17:14PM +0200, Cédric Le Goater wrote:
> Hello,
> 
> First patch fixes a host crash in PCI passthrough when using the
> XICS-on-XIVE or the XIVE native KVM device. Second patch fixes locking
> in code accessing the KVM memslots.
> 
> Thanks,
> 
> C.
> 
> Cédric Le Goater (2):
>   KVM: PPC: Book3S HV: XIVE: do not clear IRQ data of passthrough
>     interrupts
>   KVM: PPC: Book3S HV: XIVE: take the srcu read lock when accessing
>     memslots

Thanks, series applied to my kvm-ppc-fixes branch.

Paul.
