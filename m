Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8D168CB24
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 01:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjBGAbt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 19:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjBGAbr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 19:31:47 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D4F2683;
        Mon,  6 Feb 2023 16:31:45 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675729904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kJVOVrZCJQ6/cy4D2gKMmsRi+FvSxGG1dPf3GjaIyug=;
        b=FP7RJ0Ke6ucjGphlaf5aHL2nV4CY5sSHD35g6E9C4GialHf8WU5QtidnNwAZCjb9gp9+I/
        RUwOqDvqeuoXA65VxMoPrWo0PWRlha3x+4b/kudPDTbjzzJJSE2JfISc2KAv9rTacJ7fNM
        cB7Ix6hJCSY0N1zjOMbbuAHCoJbhF06I7XZ4yQdENRy5U6Ib7WkLkb/J4dbw4y82fZTLyq
        raSD94rctDx58Ysvn9bSt8kaeYbCCf/n6KucbxTQ49yh6syN/97c5WVuN1Am3T5x1BBv+l
        sRftOMW08T02hF58qOyNexwlRzyf4mEx5EsdVtdLU3xhb1jSzQmeQxznJyTn0w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675729904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kJVOVrZCJQ6/cy4D2gKMmsRi+FvSxGG1dPf3GjaIyug=;
        b=Wp+yRhM71oxYbGcTl4SHDyEC/rkUQ444CoXeXYpxc5BVX8l+SLG6fXqUTjK/X411NQZ4PP
        nAsHUiTRC5s1lRBg==
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, Usama Arif <usama.arif@bytedance.com>
Subject: Re: [PATCH v6 11/11] x86/smpboot: reuse timer calibration
In-Reply-To: <20230202215625.3248306-12-usama.arif@bytedance.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-12-usama.arif@bytedance.com>
Date:   Tue, 07 Feb 2023 01:31:43 +0100
Message-ID: <87k00uwc28.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 02 2023 at 21:56, Usama Arif wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
>
> No point recalibrating for known-constant tsc.
> When tested on a 128 core, 2 socket server, this reduces
> the parallel smpboot time from 100ms to 30ms.

This is completely independent of the parallel bringup, so this should
have a proper SOB and be at the beginning of this series for a long
time.

> Not-signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Thanks,

        tglx
