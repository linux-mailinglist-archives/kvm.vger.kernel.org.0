Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E486DD60F
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 10:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjDKI6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 04:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjDKI6Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 04:58:25 -0400
Received: from out-60.mta1.migadu.com (out-60.mta1.migadu.com [IPv6:2001:41d0:203:375::3c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4684A2D55
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 01:58:20 -0700 (PDT)
Date:   Tue, 11 Apr 2023 10:58:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681203497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tYQNARfOa8tbEcaqHz6ILgvSCbmZ1g80hA9Tr6Qv/7s=;
        b=neUyHC2H2EsgiXEob5Mtj9hBifKo5nO/AW+si/QiXgKpMGVBSXS6fKnfwNsh5oUKuyF78L
        DUFGK9EJGWKuLswoWD4ZB5wdvUzRTogHYq8CcRFcDPN4wjxdzuiDVukunMGou81d2jatm+
        +LQm1blIm0+lxk8up+SHqnX/vxRknY4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.linux.dev,
        qemu-arm@nongnu.org, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [kvm-unit-tests PATCH v10 4/7] arm/tlbflush-code: TLB flush
 during code execution
Message-ID: <cw7kze4l7nhttr74j6hkojkyr4nuidxryyzvvr7vcxtu3ihi34@sy6hcuphtlff>
References: <20230307112845.452053-1-alex.bennee@linaro.org>
 <20230307112845.452053-5-alex.bennee@linaro.org>
 <20230321150220.mfrvgxg3ebju5e6k@orel>
 <87ile2rffl.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ile2rffl.fsf@linaro.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 11, 2023 at 09:26:56AM +0100, Alex Bennée wrote:
> 
> Andrew Jones <andrew.jones@linux.dev> writes:
> 
> > On Tue, Mar 07, 2023 at 11:28:42AM +0000, Alex Bennée wrote:
> >> This adds a fairly brain dead torture test for TLB flushes intended
> >> for stressing the MTTCG QEMU build. It takes the usual -smp option for
> >> multiple CPUs.
> >> 
> <snip>
> >
> > BTW, have you tried running these tests as standalone? Since they're
> > 'nodefault' it'd be good if they work that way.
> 
> It works but I couldn't get it to skip pass the nodefault check
> automaticaly:
> 
>   env run_all_tests=1 QEMU=$HOME/lsrc/qemu.git/builds/arm.all/qemu-system-aarch64 ./tests/tcg.computed 
>   BUILD_HEAD=c9cf6e90
>   Test marked not to be run by default, are you sure (y/N)?
>

I think

 $ yes | tests/some-nodefault-test

should work.

Thanks,
drew
