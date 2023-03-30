Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C7A6D0C32
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 19:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbjC3RGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 13:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbjC3RGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 13:06:03 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227A6199E;
        Thu, 30 Mar 2023 10:06:02 -0700 (PDT)
Received: from [127.0.0.1] (dynamic-046-114-214-160.46.114.pool.telefonica.de [46.114.214.160])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 618CA1EC064E;
        Thu, 30 Mar 2023 19:06:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1680195960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VbQdC26BGuDMQMbR3dI9UycMZAF+8EQZAjhm6UnhyUw=;
        b=eBDlTQYZWuoeljjhDYtHzcoP6FHO8j1241PdRRF88loxMQJmg+DgaYwcjYQ6AhDY8hxVaf
        +yNnxWkyQIqU4bfsYzZG7uTuOh9UAANcMzkDrNT1Ws8PIgBSnDYPI9Nh0a9UB1Qq+ejtNr
        jagjP91bArHMPPnDajqfi5ffxSVEGlU=
Date:   Thu, 30 Mar 2023 19:05:58 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        kim.phillips@amd.com, brgerst@gmail.com
CC:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v17_6/8=5D_x86/smpboot=3A_Send_INI?= =?US-ASCII?Q?T/SIPI/SIPI_to_secondary_CPUs_in_parallel?=
User-Agent: K-9 Mail for Android
In-Reply-To: <87v8iirxun.ffs@tglx>
References: <20230328195758.1049469-1-usama.arif@bytedance.com> <20230328195758.1049469-7-usama.arif@bytedance.com> <87v8iirxun.ffs@tglx>
Message-ID: <CAFC43E6-97E9-4E89-AABB-78E31037048A@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On March 30, 2023 6:46:24 PM GMT+02:00, Thomas Gleixner <tglx@linutronix=2E=
de> wrote:
>So that violates the rules of microcode loading that the sibling must be
>in a state where it does not execute anything which might be affected by
>the microcode update=2E The fragile startup code does not really qualify
>as such a state :)

Yeah I don't think we ever enforced this for early loading=2E The thread s=
ync thing came with the late loading dance=2E=2E=2E=2E


--=20
Sent from a small device: formatting sucks and brevity is inevitable=2E 
