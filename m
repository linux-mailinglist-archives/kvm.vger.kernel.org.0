Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588D368CAF1
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 01:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjBGAJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 19:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBGAJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 19:09:13 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69358729F;
        Mon,  6 Feb 2023 16:09:12 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675728550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8yAyeAYV+VgEfaRthV7g03kEBlmbiN7ZIIKkNPlN0Mk=;
        b=J7oOL144DDdPg9yab8M6kVXWC1iettyPJraV1KOO7HZHTQ4dFAD2yK8/3amhOI7TZM1BZG
        VYit8F+2upl60lLia+SCTNs1E9TxmiWtZRbPIAu5M1wj3dymkL2nLd2OsCP1OLf0Ipvmtq
        5PlXAeOm41z1xkDwRY7OsCbqLZq8LLSrrnAI95nDH8oY7C5EOIIwTeOw9+3pi4YF262nCm
        1TcTuRqhHrGxNb8R0PS1/3KtTohOUkBGxtEIqb4SnxS5S4ouBa3mxGOkmwLwkcaMF7yAIU
        5Xn9zIjS6LomPnmrZryJ4yLqGEpgpvOoRbq3kPv0lLffKWj09IFCtvw/xH8kNg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675728550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8yAyeAYV+VgEfaRthV7g03kEBlmbiN7ZIIKkNPlN0Mk=;
        b=iHNwCbX6owL71cegBFXeidzrxbQIlSkqm+yfC8ZQb84+a6xTpjgWDXWTv6sYyXDZmFpy9u
        PMe3jKj6UUYwe6Cg==
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH v6 07/11] x86/smpboot: Disable parallel boot for AMD CPUs
In-Reply-To: <20230202215625.3248306-8-usama.arif@bytedance.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-8-usama.arif@bytedance.com>
Date:   Tue, 07 Feb 2023 01:09:10 +0100
Message-ID: <87sffiwd3t.ffs@tglx>
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

> From: David Woodhouse <dwmw@amazon.co.uk>

-ENOCONTENT

> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
