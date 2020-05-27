Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7401E370D
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 06:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgE0EVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 00:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728770AbgE0EVD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 00:21:03 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483AEC061A0F;
        Tue, 26 May 2020 21:21:03 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 49WyLj24ZLz9sSk; Wed, 27 May 2020 14:21:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1590553261; bh=G+QgS0qcNXOLEKAmCyU//vqicLF4pKGtu1284W9SPQ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HacLDlq4cEW9mRq5Epu7LBXDTYHh562uIVB4NcCHS72K7f+p0nPG30FusxcRsi/rP
         ZrpLNbsFpBUoa5fBK/q9q1Ph+3l+diJxt7YNSN9ZO5kEStK1cOex/aVl+63iIAnAV6
         81zfOTK5liGI/8ROoI1BoWkHGtFBDjekFaoiCBAiBA/TOT8TPmMStZdjmsocz8M+z1
         e7G3jn4kiPnysiktau650QdENmiy7zwC0Om0O6Uxzi7dWPY38pc1wIJDU0++O+x2xz
         jrq1yr6CfwonY8LwvuxPRV7SME6th0pqavPWBDnyBf57CggTButADyikorWWJ4GTDt
         HaCvipkquX5yw==
Date:   Wed, 27 May 2020 14:20:55 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     pbonzini@redhat.com, tsbogend@alpha.franken.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com,
        chenhuacai@gmail.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/7] KVM: PPC: Remove redundant kvm_run from vcpu_arch
Message-ID: <20200527042055.GG293451@thinks.paulus.ozlabs.org>
References: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
 <20200427043514.16144-4-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427043514.16144-4-tianjia.zhang@linux.alibaba.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 27, 2020 at 12:35:10PM +0800, Tianjia Zhang wrote:
> The 'kvm_run' field already exists in the 'vcpu' structure, which
> is the same structure as the 'kvm_run' in the 'vcpu_arch' and
> should be deleted.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

Thanks, patches 3 and 4 of this series applied to my kvm-ppc-next branch.

Paul.
