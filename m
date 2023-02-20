Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49E769D667
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 23:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbjBTWl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 17:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbjBTWl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 17:41:28 -0500
Received: from vulcan.natalenko.name (vulcan.natalenko.name [104.207.131.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF0B1E5D9;
        Mon, 20 Feb 2023 14:41:26 -0800 (PST)
Received: from spock.localnet (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 41CF4123A2B3;
        Mon, 20 Feb 2023 23:41:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1676932883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=szoblmT0wVsBq7IUuf6+E7obJYjpseRaIZmsCFUCD4U=;
        b=qGTlxn+OVLEip+7C3J+8EUczGCD/Ewca74wVkYMI3yeSP2rCVO8MPHgGQqILk4Myi+4jm+
        SKI4s6gySDWuiMswc1EQLM65u6E9tQUz9WnbO6DCJjC+qWQysL8Da7GWYInMRxGLrMmovJ
        spiR2is18q7GMbiqKXaZDjOwjUZ97qQ=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>
Cc:     tglx@linutronix.de, kim.phillips@amd.com, arjan@linux.intel.com,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, Piotr Gorski <piotrgorski@cachyos.org>
Subject: Re: [External] Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
Date:   Mon, 20 Feb 2023 23:41:21 +0100
Message-ID: <2668982.mvXUDI8C0e@natalenko.name>
In-Reply-To: <4a7b863c-469d-ea61-fc49-7aa8c819bb73@bytedance.com>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <982e1d6140705414e8fd60b990bd259a@natalenko.name>
 <4a7b863c-469d-ea61-fc49-7aa8c819bb73@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello.

On pond=C4=9Bl=C3=AD 20. =C3=BAnora 2023 23:23:43 CET Usama Arif wrote:
> So for initial boot, do all CPUs comes up for you when parallel smp boot=
=20
> is enabled or only 1?

All the CPUs come up during the initial boot.

> I don't have access to Ryzen hardware so can only say from code, but it=20
> would be weird if initial boot is fine but resume is broken if the same=20
> code path is being taken.

=2D-=20
Oleksandr Natalenko (post-factum)


