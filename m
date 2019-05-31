Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2061F308AB
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 08:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfEaGiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 02:38:00 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:55093 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726634AbfEaGh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 02:37:59 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45FZWm6NNtz9s00; Fri, 31 May 2019 16:37:55 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1559284676; bh=kPRTv22CCICOdVYYV+J/6Z6NMyU94ZniwB2riHgoA2Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qq80S9M+JlpdQOUK3COgmkD2Z7PEZ1+fJFqp6/hv6gz1hmhFctUH+g14Z1A10RjJI
         TODM8POY5CCkw46ZASWWggaIs4s1mpVgjz6Ofb1DHdzCXVpf/tMzaLa8FdiM291hI/
         LvYqLfFfkp6bfhcP2zEOL4xNaWvqoGL9b8Q1Sclh9jTP8A2fTrRF5VGl1R1xxg+MWI
         E5Q/I9jo3CcYDLuFZFI2lfEHYOTlh98p3DQhaevfM7ghwJj2WvGYbzwr+K1lqh0ZIQ
         yiRekwlJzIVPdv2ubKSI4UkfltCoXjah94wRwUK8S+RsRC/92ycIu+b9VE18W1Gqe5
         wljTe6ccStLfg==
Date:   Fri, 31 May 2019 16:35:43 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: XIVE: introduce a KVM device lock
Message-ID: <20190531063543.GD26651@blackberry>
References: <20190524132030.6349-1-clg@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190524132030.6349-1-clg@kaod.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 24, 2019 at 03:20:30PM +0200, Cédric Le Goater wrote:
> The XICS-on-XIVE KVM device needs to allocate XIVE event queues when a
> priority is used by the OS. This is referred as EQ provisioning and it
> is done under the hood when :
> 
>   1. a CPU is hot-plugged in the VM
>   2. the "set-xive" is called at VM startup
>   3. sources are restored at VM restore
> 
> The kvm->lock mutex is used to protect the different XIVE structures
> being modified but in some contextes, kvm->lock is taken under the
> vcpu->mutex which is a forbidden sequence by KVM.
> 
> Introduce a new mutex 'lock' for the KVM devices for them to
> synchronize accesses to the XIVE device structures.
> 
> Signed-off-by: Cédric Le Goater <clg@kaod.org>

Thanks, patch applied to my kvm-ppc-fixes branch (with the headline
"KVM: PPC: Book3S HV: XIVE: Introduce a new mutex for the XIVE
device").

Paul.
