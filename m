Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DE32BA918
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 12:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgKTL0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 06:26:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727714AbgKTL0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Nov 2020 06:26:40 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D34CC22244;
        Fri, 20 Nov 2020 11:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605871600;
        bh=e4dU3Fcu0n1ACqjkCBWzLMlbjaNYmEYYOuJTREFTOyk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P4zweIOjwAsjb1amYtoKtfj/jkRrAFLkoeeYYASL4K06PAfVrCz8EBmM4MaS8UVpG
         6ofZjZ+zn163yCRFv6Cz2OShDj1yHal6yxrPgs6uM7NQao6/7mrJWVqWjqVRxnM3yI
         RzOntXJkFte54eXhHOWu4S2gBp3iTbL9cvXGVUuI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kg4Yn-00CEtr-Sh; Fri, 20 Nov 2020 11:26:37 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 20 Nov 2020 11:26:37 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     David Brazdil <dbrazdil@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, ndesaulniers@google.com,
        kernel-team@android.com
Subject: Re: [PATCH v2 3/5] KVM: arm64: Patch kimage_voffset instead of
 loading the EL1 value
In-Reply-To: <20201119111454.vrbogriragp7zukk@google.com>
References: <20201109175923.445945-1-maz@kernel.org>
 <20201109175923.445945-4-maz@kernel.org>
 <20201119111454.vrbogriragp7zukk@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <2c47608f4326c8251ebd940f8ecb99a9@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, ascull@google.com, will@kernel.org, qperret@google.com, ndesaulniers@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-11-19 11:14, David Brazdil wrote:
> Hey Marc,
> 
> Just noticed in kvmarm/queue that the whitespacing in this patch is 
> off.
> 
>> +.macro kimg_pa reg, tmp
>> +alternative_cb kvm_get_kimage_voffset
>> +       movz    \tmp, #0
>> +       movk    \tmp, #0, lsl #16
>> +       movk    \tmp, #0, lsl #32
>> +       movk    \tmp, #0, lsl #48
>> +alternative_cb_end
>> +
>> +       /* reg = __pa(reg) */
>> +       sub     \reg, \reg, \tmp
>> +.endm
> This uses spaces instead of tabs.
> 
>> +
>>  #else
> This added empty line actually has a tab in it.

Well spotted. Now fixed.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
