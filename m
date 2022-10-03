Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68B75F356A
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 20:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiJCSQ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 14:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiJCSQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 14:16:58 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A582B243;
        Mon,  3 Oct 2022 11:16:57 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e749329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e749:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E11EA1EC04F0;
        Mon,  3 Oct 2022 20:16:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1664821011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=2w76/y5fSDNg4MMUq2sZOt4nJbULUyV++7iAWk2cTIQ=;
        b=hvrms6oDaoSQMvX6bsRISlwVU1UnL3NPL+POl+uz4e3mdDksYWCYlVaBE1orql9puF3akq
        raxW6vLj36Z0Cdy6u1Jzb3PwF1f9R/FhgYk6CT/xuc0gTZrIzWzCdQ2FsZjAKQSRrnxn1d
        LRLLLSD8N9Xubs9+WayNNhecsCiARNI=
Date:   Mon, 3 Oct 2022 20:16:47 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Peter Gonda <pgonda@google.com>
Cc:     "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: Re: [PATCH Part2 v6 13/49] crypto:ccp: Provide APIs to issue SEV-SNP
 commands
Message-ID: <YzsnB0Evh5NeRzOh@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <a63de5e687c530849312099ee02007089b67e92f.1655761627.git.ashish.kalra@amd.com>
 <YzigaOHddWU706H5@zn.tnic>
 <SN6PR12MB2767062CAD241C0BAFB7FAD98E5B9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YzsK+szsWoAlMsrR@zn.tnic>
 <SN6PR12MB276753083B811B1055FDE6408E5B9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YzsfroL1/6D8rVTF@zn.tnic>
 <CAMkAt6pnqWWA8pc6uY5g1o076VLgjy1K1ZagDOgcuQfh=hnf3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMkAt6pnqWWA8pc6uY5g1o076VLgjy1K1ZagDOgcuQfh=hnf3Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 03, 2022 at 12:01:19PM -0600, Peter Gonda wrote:
> We already have sev_issue_cmd_external_user() exported right?
> 
> Another option could be to make these wrappers more helpful and less
> silly.

For example.

My point is, whenever something needs to issue a SEV* fw command,
something adds a silly wrapper and this will become unwieldy pretty
quickly.

If a wrapper is not a dumb one but it actually does preparatory work
before issuing the command so that the caller's life is made easy, then
yes, by all means.

If it is only plain forwarding a call to sev_do_cmd(), then I question
the whole point of the exercise...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
