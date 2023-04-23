Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FDC6EBFB1
	for <lists+kvm@lfdr.de>; Sun, 23 Apr 2023 15:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjDWNO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Apr 2023 09:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjDWNO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Apr 2023 09:14:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5388F1727;
        Sun, 23 Apr 2023 06:14:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1D4460D37;
        Sun, 23 Apr 2023 13:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B309C4339B;
        Sun, 23 Apr 2023 13:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682255664;
        bh=HvLzjTfKystbI6xwFWfI2Z3fVftEGxsyI7r7TjKcIWM=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=QLGo7Ri/mTfb2D1qw5zFrq3ci3jEUQsakRNlBYrVJerCA7UQ/JBqo7H4WG5/V5zsk
         tpZ3p3hAXnQXjglp5Jr2fmRbLEcTDRCPn3vCRsjgPf4L1oJndpE/cygq1gObsIZLq+
         3lBebzxAfNq2ZbIPA9UKc2Xds/VLACYJx6sLZXpIVcHHlogES41s4WZ77YeUEIwyhP
         JrI0MXS3wzSWyCzamJlg3Bb0h8n68YWTM01yANXWDMxY5alPHPrcLm6aiDPRBype8O
         pIhzKUGsiFUAqNy5079dwknnmZYOjYp0qMdH+tL/Ydd7RJv7gjA48Tk+/uJ/SpgFMu
         jrl01t9L7frRg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 23 Apr 2023 16:14:18 +0300
Message-Id: <CS45V0JP0DUN.82KGEI3U5ZGN@suppilovahvero>
Cc:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        "Vlastimil Babka" <vbabka@suse.cz>,
        "Vishal Annapurve" <vannapurve@google.com>,
        "Yu Zhang" <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        <dhildenb@redhat.com>, "Quentin Perret" <qperret@google.com>,
        <tabba@google.com>, "Michael Roth" <michael.roth@amd.com>,
        <wei.w.wang@intel.com>, "Mike Rapoport" <rppt@kernel.org>,
        "Liam Merwick" <liam.merwick@oracle.com>,
        "Isaku Yamahata" <isaku.yamahata@gmail.com>,
        "Ackerley Tng" <ackerleytng@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
To:     "Sean Christopherson" <seanjc@google.com>,
        "Chao Peng" <chao.p.peng@linux.intel.com>
X-Mailer: aerc 0.14.0
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
 <ZD1oevE8iHsi66T2@google.com>
In-Reply-To: <ZD1oevE8iHsi66T2@google.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon Apr 17, 2023 at 6:40 PM EEST, Sean Christopherson wrote:
> What do y'all think about renaming "restrictedmem" to "guardedmem"?
>
> I want to start referring to the code/patches by its syscall/implementati=
on name
> instead of "UPM", as "UPM" is (a) very KVM centric, (b) refers to the bro=
ader effort
> and not just the non-KVM code, and (c) will likely be confusing for futur=
e reviewers
> since there's nothing in the code that mentions "UPM" in any way.
>
> But typing out restrictedmem is quite tedious, and git grep shows that "r=
mem" is
> already used to refer to "reserved memory".
>
> Renaming the syscall to "guardedmem"...
>
>   1. Allows for a shorthand and namespace, "gmem", that isn't already in =
use by
>      the kernel (see "reserved memory above").
> =20
>   2. Provides a stronger hint as to its purpose.  "Restricted" conveys th=
at the
>      allocated memory is limited in some way, but doesn't capture how the=
 memory
>      is restricted, e.g. "restricted" could just as easily mean that the =
allocation
>      can be restricted to certain types of backing stores or something.  =
"Guarded"
>      on the other hand captures that the memory has extra defenses of som=
e form.
>
>   3. Is shorter to type and speak.  Work smart, not hard :-)
>
>   4. Isn't totally wrong for the KVM use case if someone assumes the "g" =
means
>      "guest" when reading mail and whatnot.
>
>
> P.S. I trimmed the Cc/To substantially for this particular discussion to =
avoid
>      spamming folks that don't (yet) care about this stuff with another p=
otentially
>      lengthy thread.  Feel free to add (back) any people/lists.

I guess 'guarded' could be a good noun in the sense that it does not
get easily mixed up to anything pre-existing, and it does give the idea
of the purpose.

BR, Jarkko
