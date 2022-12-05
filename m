Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1281642B00
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbiLEPH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbiLEPH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:07:26 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D16E004;
        Mon,  5 Dec 2022 07:07:25 -0800 (PST)
Received: from zn.tnic (p200300ea9733e72f329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e72f:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 02D401EC06C0;
        Mon,  5 Dec 2022 16:07:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1670252844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=QB/tkH0rJsI+XX037jyHBOqBrMgszlemhs2G4RsnIkE=;
        b=UjVUcFVNjFq3AvEJ0mb26DBLVOhfOXSM/18sD4nRu8jWeFYyEy4leDZv7dpKSrCBAjusm0
        sUwIptoE9xmQP3yqjMGRAxwsTXHSvT26j2AIBxEcsu3Ts4r5r9Ubs0r8IPCSoPDwn/7WAz
        oTkgBaAchlsppYXv3e2SgGAvxS4cWYs=
Date:   Mon, 5 Dec 2022 16:07:19 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
        michael.roth@amd.com, stable@kernel.org
Subject: Re: [PATCH v2] x86/sev: Add SEV-SNP guest feature negotiation support
Message-ID: <Y44JJ/mXBCpAHq4p@zn.tnic>
References: <20221201100423.7117-1-nikunj@amd.com>
 <Y44Amf9MJIIi4Ric@zn.tnic>
 <2b8f7201-24fe-0eba-2629-e35900f4d5d7@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2b8f7201-24fe-0eba-2629-e35900f4d5d7@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 05, 2022 at 08:32:52PM +0530, Nikunj A. Dadhania wrote:
> Looks good. Do you want me to send v3 with these changes ?

Sure, pls do, after testing it again.

But no hurry because the merge window opens next week and that one will
have to wait for after it.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
