Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C583646D3A
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 11:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLHKkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 05:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiLHKkW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 05:40:22 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAEE59FC5;
        Thu,  8 Dec 2022 02:35:39 -0800 (PST)
Received: from zn.tnic (p200300ea9733e73d329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e73d:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1F14A1EC01E0;
        Thu,  8 Dec 2022 11:35:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1670495738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=zUnJLixyNV5KmmklK9vf+i8gOj4NpSWGc8A+ex1VX5o=;
        b=CUZ/3tnbl3X8OY614clE6UQaupXP87AcGQXbl0KKxNN6ljchQqSp59Jyslwb5b0tHxxOfs
        7zfQp7cXiWdAzw3xkI+MW0rmDW7UUXFF5MWttjS/uHqicsxLiB2OMIxn1bJdcqWtgyupAj
        vJxoWN5K+N+ICXlFzZqaIy5Cd71TtNo=
Date:   Thu, 8 Dec 2022 11:35:32 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Sterritt <sterritt@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH kernel 1/3] x86/amd/dr_addr_mask: Cache values in percpu
 variables
Message-ID: <Y5G99Lp4zRqVejb7@zn.tnic>
References: <20221201021948.9259-1-aik@amd.com>
 <20221201021948.9259-2-aik@amd.com>
 <Y5DhvRZX0Aizu1ya@zn.tnic>
 <ce2b2cac-2a18-ef23-7bdf-4040c28ffa24@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ce2b2cac-2a18-ef23-7bdf-4040c28ffa24@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 08, 2022 at 05:11:26PM +1100, Alexey Kardashevskiy wrote:
> Not an array, as Sean suggested? Uff...

Sure an array if it makes the code even more readable and clean. With an
array it should become even more compact, I'd say.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
