Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9367E4D2EE5
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 13:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiCIMSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 07:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiCIMSU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 07:18:20 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD45172E78;
        Wed,  9 Mar 2022 04:17:21 -0800 (PST)
Received: from zn.tnic (p200300ea971938596e73e4c94fe320f4.dip0.t-ipconnect.de [IPv6:2003:ea:9719:3859:6e73:e4c9:4fe3:20f4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6BC571EC03AD;
        Wed,  9 Mar 2022 13:17:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1646828235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=7MY4HXqj5XqaNgJLI88QF2HIbx0/gisjpXBmuJzwj2E=;
        b=ACUyalTi2pM4J8TSgiV8b0CRxVbxWxF+h264ye4VfLffWR2XKGJZ9TmFhfhN5pTYmHyecJ
        hyV8Yuxv3xBBpy8nFlutFfW2T+Xxla8SpGTSZQBPs6mjAdG6SIIhh7+JRgVTpy9WUdOOfG
        ZYdWbMoUues6/t32QN8itpEmL36BhiU=
Date:   Wed, 9 Mar 2022 13:17:21 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     wang.yi59@zte.com.cn
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        up2wing@gmail.com, wang.liang82@zte.com.cn, liu.yi24@zte.com.cn
Subject: Re: [PATCH] KVM: SVM: fix panic on out-of-bounds guest IRQ
Message-ID: <Yiia0S+pDNHlAhSE@zn.tnic>
References: <2bd92846-381b-f083-754a-89dfcdccc90c@redhat.com>
 <202203091827565144689@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202203091827565144689@zte.com.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 09, 2022 at 06:27:56PM +0800, wang.yi59@zte.com.cn wrote:
> The Signed-off-by chain is not wrong, I (Yi Wang) wrote this patch and Yi Liu
> co-developed it.

What to do in such cases is well documented. For the future, make sure
you look at

Documentation/process/submitting-patches.rst

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
