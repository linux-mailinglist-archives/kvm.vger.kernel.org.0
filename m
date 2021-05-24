Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E6938E5C7
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 13:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbhEXLtE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 07:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbhEXLtE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 07:49:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A463C061574;
        Mon, 24 May 2021 04:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UEO6EAq0B/BZq9m5Zu1X6wIqhfXCfA6vaV6yeUoFwnk=; b=Or7cMQ7Nzl98SOGOLDHWQs5AkK
        kd6QvgbIiLkHCNig8TZkoK4Qk6eNVlF8A1kPxiWTx3ZYBfDZPOecUnZcvWOhgRctNgCnWdwgB/Qkx
        vLz/kHulVD5Q6nuLTMUhcHWhdHOikWBkftygJrUaInoHHfJgHwqdSvdqSKR/pHk8CGtAnPw9D02tj
        DyDijYr5PtZjidf15hDW7+YrgdJ2t2IoCJ5Jbiw/8ca42BSrgNbBytwINWR8pyZ0gSJbhKsaUYEpa
        XRN2E5K6gLTLC74ituBPeZOM9HNyHtpT5HLvKmUofGtlt98U4zea5TdBHH9bPhlQAy+2O52rgjPuk
        bCEGnSFg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ll92Q-002KEc-QT; Mon, 24 May 2021 11:46:31 +0000
Date:   Mon, 24 May 2021 12:46:26 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Joe Richey <joerichey94@gmail.com>
Cc:     trivial@kernel.org, Joe Richey <joerichey@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Subject: Re: [PATCH 0/6] Don't use BIT() macro in UAPI headers
Message-ID: <YKuSEnfEbjpOOgLS@infradead.org>
References: <20210520104343.317119-1-joerichey94@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520104343.317119-1-joerichey94@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 03:43:37AM -0700, Joe Richey wrote:
> This patch series changes all UAPI uses of BIT() to just be open-coded.
> However, there really should be a check for this in checkpatch.pl
> Currently, the script actually _encourages_ users to use the BIT macro
> even if adding things to UAPI.

Yes.  In fact it should warn about BIT() in general.  It is totally
pointless obsfucation that doesn't even save any typing at all.
