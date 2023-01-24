Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689B367963E
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 12:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbjAXLKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 06:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbjAXLKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 06:10:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06D12735
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 03:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674558560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+DMRJfez60dbarODNUh7sHzp4Lsmr8FQDQTVuXe7R6M=;
        b=N2J0j5n/mptfwMd/gxlsBwOjpJjmo4Kx9MO+6brRQjXgl0nGggvpCSaR5nfE7yF2oeM5US
        dhxasxAtPPPiaCsCWx+/+TXilTjAWQHKqw2th4QaiAG+62uZuwYn0J/5s8EZyF33jb6oCI
        fBsQDZdCuZBmWQdYMrAnhtO1wT6oa7s=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-208-y97ZvtU8NfS6V3wxh_Wl0A-1; Tue, 24 Jan 2023 06:09:19 -0500
X-MC-Unique: y97ZvtU8NfS6V3wxh_Wl0A-1
Received: by mail-vk1-f198.google.com with SMTP id n123-20020a1fa481000000b003e201b836c6so4734248vke.6
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 03:09:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+DMRJfez60dbarODNUh7sHzp4Lsmr8FQDQTVuXe7R6M=;
        b=Az96tVq3k9sNxUe0EKS5Ulhl3lp2pf0HgY2ef3yRdT2ymygY+0JufP+9XnS2pamECE
         gwBEYtP9d3AkPz6cHpAl4qy2o5SeWZTEO6gYEpSH35qgNDgUOc+z+sF1v/wgFT3PtYCD
         0qq0PjpnQ0zqiWKAYqi5j+8k3xwvtSligutaXI35JrVvtyggOdQd36dDGNMWg4tguTpu
         2YgSrDkG/fO8rFoit8V923WzZH7BJliMNN+ye3AtEfvJ/JSlaxbUSVyXJqArLdcgNLKg
         lfM+qVEcXGuBJa1iydsz1HKaZWjFnnqubg0vACYLqtAPqkA+zbzZd3wFKGD8k5wh2TZn
         P1bw==
X-Gm-Message-State: AFqh2kot+3gGPFR78j2HKAP8r7YyyY0JHIf8LKuY85zrvLsWjIsBr+oJ
        9D36YCNwGGIeFp8CGgaTAfrHvKxkkT1vtzCEdS195aLrWHrrVPgi7P994H98XGVpKS+Ugtwj1+z
        7Q8i77EssCjvh4AOdoLyeQBFn6uZs
X-Received: by 2002:a1f:e701:0:b0:3dd:f5ea:63a2 with SMTP id e1-20020a1fe701000000b003ddf5ea63a2mr3697200vkh.10.1674558558412;
        Tue, 24 Jan 2023 03:09:18 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvB4Kl48vzijkNT1iQDWORsxLD/4IdktHUPkydJbw9Rz+NmsbYKXiKwXzsVm5K8G1Rv8dZasY5bY7KqTqSMx1Q=
X-Received: by 2002:a1f:e701:0:b0:3dd:f5ea:63a2 with SMTP id
 e1-20020a1fe701000000b003ddf5ea63a2mr3697196vkh.10.1674558558172; Tue, 24 Jan
 2023 03:09:18 -0800 (PST)
MIME-Version: 1.0
References: <20230124125515.7c88c9fb@canb.auug.org.au> <86a628mi9q.wl-maz@kernel.org>
In-Reply-To: <86a628mi9q.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 24 Jan 2023 12:09:07 +0100
Message-ID: <CABgObfZxjbG+ZofDPfOdiY_QP4j09XtTNwQVmGnbwoc+oaocxA@mail.gmail.com>
Subject: Re: linux-next: duplicate patches in the kvm-x86 tree
To:     Marc Zyngier <maz@kernel.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Sean Christopherson <seanjc@google.com>,
        KVM <kvm@vger.kernel.org>,
        Christoffer Dall <cdall@cs.columbia.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        GUARANTEED_100_PERCENT,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 24, 2023 at 9:47 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Stephen,
>
> On Tue, 24 Jan 2023 01:55:15 +0000,
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Hi all,
> >
> > The following commits are also in other tree(s?) as different
> > commits (but the same patches):
> >
> >   0b6639e8ed87 ("KVM: s390: Move hardware setup/unsetup to init/exit")
> >   0c2be59e0b53 ("KVM: x86: Use KBUILD_MODNAME to specify vendor module name")
> >   1334f214d19f ("KVM: s390: Unwind kvm_arch_init() piece-by-piece() if a step fails")
>
> [...]
>
> > I guess someone has rebased one of the kvm trees and it had already been
> > merged into another (like the kvm or kvm-arm trees).
>
> Huh, that's worrying. I'm carrying the kvm-hw-enable-refactor branch
> from the KVM tree, which I understood to be a stable branch[1], and
> which I merged to avoid conflicts to be propagated everywhere.

It wasn't 100% guaranteed to be stable because it was meant to be
tested and have fixes squashed in. But since I had no issues reported
from either maintainers or bots, I will indeed merge commit
9f1a4c004869 aka kvm/kvm-hw-enable-refactor into kvm/next. Sean,
please rebase to drop the duplicate commits.

Paolo

>
> Paolo, Sean: what is the *real* status of this branch?
>
>         M.
>
> [1] https://lore.kernel.org/r/4d73d1b9-2c28-ab6a-2963-579bcc7a9e67@redhat.com
>
> --
> Without deviation from the norm, progress is not possible.
>

