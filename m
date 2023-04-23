Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133D06EBFC0
	for <lists+kvm@lfdr.de>; Sun, 23 Apr 2023 15:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjDWN20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Apr 2023 09:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDWN2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Apr 2023 09:28:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CD11708;
        Sun, 23 Apr 2023 06:28:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93D4460DEA;
        Sun, 23 Apr 2023 13:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98ADC433D2;
        Sun, 23 Apr 2023 13:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682256502;
        bh=eFNb+a+GhOZTCzL6BnbhdUtc1LYfBYZOBZ5qeNc+68U=;
        h=Date:To:Cc:Subject:From:References:In-Reply-To:From;
        b=ZDKsKjGh0x+GZoRl/oHVyQhx0ln/3K8eLSV9C3hvv3u5o4qXAstvPNpUVSbuL4PDu
         OrdvyqTEsBo3QJPYCLDyX5pkzEzMn09VfQTNw+WxBfSuqXR6Ck0GIueTI2m8MbD/Ly
         H8KcVBgXurKBJ0ZzsOv9tHrohHnuUSdsysfWHXULw64VR8g0kXGXViJeULoJt1oA8/
         yaCp4mc6/zATZ2nXPqX/jE/eFRPAYcxaSbC9I7F6A3QTXKIFqyqPqpQY9DZE2j7sOR
         nLUkZ9TmecECY+gKtj6TBJySrvz7AGzr8bq2NElAiRctKmNrR6hqDz5w17e32cGd+r
         fng21RJhF3tKw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 23 Apr 2023 16:28:16 +0300
Message-Id: <CS465PQZS77J.J1RP6AJX1CWZ@suppilovahvero>
To:     "David Hildenbrand" <david@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        "Chao Peng" <chao.p.peng@linux.intel.com>
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
X-Mailer: aerc 0.14.0
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
 <ZD1oevE8iHsi66T2@google.com>
 <658018f9-581c-7786-795a-85227c712be0@redhat.com>
In-Reply-To: <658018f9-581c-7786-795a-85227c712be0@redhat.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon Apr 17, 2023 at 6:48 PM EEST, David Hildenbrand wrote:
> On 17.04.23 17:40, Sean Christopherson wrote:
> > What do y'all think about renaming "restrictedmem" to "guardedmem"?
>
> Yeay, let's add more confusion :D
>
> If we're at renaming, I'd appreciate if we could find a terminology that=
=20
> does look/sound less horrible.
>
> >=20
> > I want to start referring to the code/patches by its syscall/implementa=
tion name
> > instead of "UPM", as "UPM" is (a) very KVM centric, (b) refers to the b=
roader effort
> > and not just the non-KVM code, and (c) will likely be confusing for fut=
ure reviewers
> > since there's nothing in the code that mentions "UPM" in any way.
> >=20
> > But typing out restrictedmem is quite tedious, and git grep shows that =
"rmem" is
> > already used to refer to "reserved memory".
> >=20
> > Renaming the syscall to "guardedmem"...
>
> restrictedmem, guardedmem, ... all fairly "suboptimal" if you'd ask me ..=
.

In the world of TEE's and confidential computing it is fairly common to
call memory areas enclaves, even outside SGX context. So in that sense
enclave memory would be the most correct terminology.

BR, Jarkko
