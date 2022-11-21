Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664E7632861
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 16:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiKUPif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 10:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiKUPie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 10:38:34 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8BF40925;
        Mon, 21 Nov 2022 07:38:33 -0800 (PST)
Received: from zn.tnic (p200300ea9733e725329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e725:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F2ED01EC072C;
        Mon, 21 Nov 2022 16:38:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669045112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=iLuRMy/62CUEHTNt/F9/ZvwQL03sX1N2sn3qd4sdI8Q=;
        b=SRXqV6J/FYYJp+re6243eL13bJ0LYx44DFigzyzwUref0NJhB2p56MTMQmY3hlM2p53dMk
        qpGmrh3vzmWVe42VOSQsnlA9CBQTpVn2SdvWdJAXZZhV+cFEmJfYr3lirkdOT8sjvJcIsu
        OT28wy4Me1fxasz0TTZiY+FJMxv+cQc=
Date:   Mon, 21 Nov 2022 16:38:27 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jiaxi Chen <jiaxi.chen@linux.intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/6] x86: KVM: Advertise CMPccXADD CPUID to user space
Message-ID: <Y3ubcwLlEdkj0/zK@zn.tnic>
References: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
 <20221118141509.489359-2-jiaxi.chen@linux.intel.com>
 <efb55727-f8bd-815c-ddfc-a8432ae5af4e@intel.com>
 <f04c2e74-87e4-5d50-579a-0a60554b83d3@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f04c2e74-87e4-5d50-579a-0a60554b83d3@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 21, 2022 at 10:46:21PM +0800, Jiaxi Chen wrote:
> Features which has been enabled in kernel usually should be added to
> /proc/cpuinfo.

No, pls read this first: Documentation/x86/cpuinfo.rst

If something's not clear, we will extend it so that it is.

/proc/cpuinfo - a user ABI - is not a dumping ground for CPUID bits.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
