Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3799C6608CF
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 22:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjAFV0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 16:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbjAFV0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 16:26:01 -0500
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A64865AE3;
        Fri,  6 Jan 2023 13:26:00 -0800 (PST)
Received: from [127.0.0.1] ([73.223.250.219])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 306LP99v4000752
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 6 Jan 2023 13:25:09 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 306LP99v4000752
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2022120601; t=1673040310;
        bh=gxQWmBYkXBL5IL6L/A4v4RTeXSN3gzc5VsEETQCjac4=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=MwB8Be18Ax1Hw08kBDlYyQOJiwt4ByOA8yJeCcLLqjcx1naA3nZvMQkkJwjjsrPvo
         vGY/D9M0LlRS/Nvr5dQsVu7YIkwgSqCtWqPUSSdJTE2HMeCSR2xC+ZVMs6u3TTAaPQ
         24iNZSaznND6aofprmVR2ubWRTaeNkq4QVoASJcYzL0yK9N8582GLKCuSHKnsvwuAa
         eafcR+uTAqs+jvT8lXX99dskgT8ojXt+RZFXEb53bgt7da3UDFHzLV8SAO1iBu9fQ4
         QJzTi2/31zadhmS+Q6bKrtUkbtQGtv07n3rOjXxacr8Bjv/4JtDlDQeUX6sAbYBDJL
         NauFmzvbKO/Cg==
Date:   Fri, 06 Jan 2023 13:25:07 -0800
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
CC:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: =?US-ASCII?Q?Re=3A_=5BRFC_PATCH_v2_32/32=5D_x86/fred=3A_dis?= =?US-ASCII?Q?able_FRED_by_default_in_its_early_stage?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20230106085617.17248-33-xin3.li@intel.com>
References: <20230106085617.17248-1-xin3.li@intel.com> <20230106085617.17248-33-xin3.li@intel.com>
Message-ID: <46772FCB-7313-47E9-ADCD-8BD556E8F265@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On January 6, 2023 12:56:17 AM PST, Xin Li <xin3=2Eli@intel=2Ecom> wrote:
>Disable FRED by default in its early stage=2E
>
>To enable FRED, a new kernel command line option "fred" needs to be added=
=2E
>
>Signed-off-by: Xin Li <xin3=2Eli@intel=2Ecom>
>---
> Documentation/admin-guide/kernel-parameters=2Etxt | 4 ++++
> arch/x86/kernel/cpu/common=2Ec                    | 3 +++
> 2 files changed, 7 insertions(+)
>
>diff --git a/Documentation/admin-guide/kernel-parameters=2Etxt b/Document=
ation/admin-guide/kernel-parameters=2Etxt
>index 42af9ca0127e=2E=2E0bc76d926dd4 100644
>--- a/Documentation/admin-guide/kernel-parameters=2Etxt
>+++ b/Documentation/admin-guide/kernel-parameters=2Etxt
>@@ -1506,6 +1506,10 @@
> 			Warning: use of this parameter will taint the kernel
> 			and may cause unknown problems=2E
>=20
>+	fred
>+			Forcefully enable flexible return and event delivery,
>+			which is otherwise disabled by default=2E
>+
> 	ftrace=3D[tracer]
> 			[FTRACE] will set and start the specified tracer
> 			as early as possible in order to facilitate early
>diff --git a/arch/x86/kernel/cpu/common=2Ec b/arch/x86/kernel/cpu/common=
=2Ec
>index 5de68356fe62=2E=2E1a160337ad41 100644
>--- a/arch/x86/kernel/cpu/common=2Ec
>+++ b/arch/x86/kernel/cpu/common=2Ec
>@@ -1434,6 +1434,9 @@ static void __init cpu_parse_early_param(void)
> 	char *argptr =3D arg, *opt;
> 	int arglen, taint =3D 0;
>=20
>+	if (!cmdline_find_option_bool(boot_command_line, "fred"))
>+		setup_clear_cpu_cap(X86_FEATURE_FRED);
>+
> #ifdef CONFIG_X86_32
> 	if (cmdline_find_option_bool(boot_command_line, "no387"))
> #ifdef CONFIG_MATH_EMULATION

Specifically, the intent is to enable it by default once hardware is widel=
y available=2E This allows e=2Eg=2E distros to compile in the support for o=
pt-in field testing before throwing the switch=2E

The motivation for this comes from the SMAP experience where the code was =
functional and correct when merged, but a change elsewhere in the kernel co=
de base broke it during the intervening period=2E
