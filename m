Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26D6312803
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 08:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfECGuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 02:50:09 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:59743 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726985AbfECGuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 02:50:04 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 44wN6g1QrVz9sBb; Fri,  3 May 2019 16:50:03 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 88ec6b93c8e7d6d4ffaf6ad6395ceb3bf552de15
X-Patchwork-Hint: ignore
In-Reply-To: <20190410170448.3923-2-clg@kaod.org>
To:     =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        kvm-ppc@vger.kernel.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     kvm@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        =?utf-8?b?Q8Op?= =?utf-8?q?dric_Le_Goater?= <clg@kaod.org>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v5 01/16] powerpc/xive: add OPAL extensions for the XIVE native exploitation support
Message-Id: <44wN6g1QrVz9sBb@ozlabs.org>
Date:   Fri,  3 May 2019 16:50:03 +1000 (AEST)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2019-04-10 at 17:04:33 UTC, =?utf-8?q?C=C3=A9dric_Le_Goater?= wrote:
> The support for XIVE native exploitation mode in Linux/KVM needs a
> couple more OPAL calls to get and set the state of the XIVE internal
> structures being used by a sPAPR guest.
> 
> Signed-off-by: Céddric Le Goater <clg@kaod.org>
> Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

Applied to powerpc topic/ppc-kvm, thanks.

https://git.kernel.org/powerpc/c/88ec6b93c8e7d6d4ffaf6ad6395ceb3b

cheers
