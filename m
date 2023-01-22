Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0CFF676BE6
	for <lists+kvm@lfdr.de>; Sun, 22 Jan 2023 10:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjAVJgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Jan 2023 04:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjAVJgO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Jan 2023 04:36:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED5814E90;
        Sun, 22 Jan 2023 01:36:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 583A560B81;
        Sun, 22 Jan 2023 09:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A53C4339B;
        Sun, 22 Jan 2023 09:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674380172;
        bh=ZhXF7Awwo1h8tePHEvpbC2rXjpmQ9EJWtH1hp7fpziU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=k8laZo479qBe0R/u8DwdMjq+8NZ8NHfLvpGBOMDM/ftfFqW2TbkNEL1v9O3K/2O/Z
         76kGnvAGg279JF1R7OmrUd1cZF2AmnAvuW58PZwdESiv9wcqYMKRwIKA1Phxaz6skq
         vgzjSGOQI5hUNWnh7FCN1QAJ86J1FDnS+NcSjegOXXdX3ThQhmD6Jg3pi8iUOVs+F3
         cYK7Xu3SS3+NW4biwfw6YmtAdivDJDKYO2Y3Jf36cUc1CzEqKCVcZVlgS5VoZikeCv
         Gs6omqhVeD3O+vOYInXJnBkFtMypaZ6qdm4XdJI6TxFErKCj3tfU/qmcb7QHFBdX/T
         bxOnhIsyFrBlQ==
Received: by mail-yb1-f173.google.com with SMTP id d62so11554784ybh.8;
        Sun, 22 Jan 2023 01:36:12 -0800 (PST)
X-Gm-Message-State: AFqh2kou38fy5gw3X/GLFHTfxj6qvNunXOtfUma+wr5WuPFHNxWGZg1X
        MfawC+L7uEjBavHETMxIEUOWiuz0vjBQnPrN1Do=
X-Google-Smtp-Source: AMrXdXsmsAO3UBkm78bn/WoLLPJuV/D0q2xlQYPdYAH6LwFfZrCDk6EXy98FeP9LfMgqYS+/Chcocg7P19eQ3O7FeWw=
X-Received: by 2002:a5b:511:0:b0:801:b1d4:329a with SMTP id
 o17-20020a5b0511000000b00801b1d4329amr733597ybp.443.1674380171778; Sun, 22
 Jan 2023 01:36:11 -0800 (PST)
MIME-Version: 1.0
References: <20230120123534.137413-1-bagasdotme@gmail.com> <20230120123534.137413-2-bagasdotme@gmail.com>
 <8a5c3cc6-c1e5-b6c4-e69d-441cf3a1fa7d@quicinc.com>
In-Reply-To: <8a5c3cc6-c1e5-b6c4-e69d-441cf3a1fa7d@quicinc.com>
From:   Oded Gabbay <ogabbay@kernel.org>
Date:   Sun, 22 Jan 2023 11:35:45 +0200
X-Gmail-Original-Message-ID: <CAFCwf12T3LketLMbTgY6fTi8x61F+H2wjmNM0x=7PAEHUgSrwA@mail.gmail.com>
Message-ID: <CAFCwf12T3LketLMbTgY6fTi8x61F+H2wjmNM0x=7PAEHUgSrwA@mail.gmail.com>
Subject: Re: [PATCH linux-next 1/3] Documentation: accel: escape wildcard in
 special file path
To:     Jeffrey Hugo <quic_jhugo@quicinc.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Freedesktop DRI List <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation <linux-doc@vger.kernel.org>,
        Linux KVM <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ofir Bitton <obitton@habana.ai>,
        Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 20, 2023 at 5:00 PM Jeffrey Hugo <quic_jhugo@quicinc.com> wrote:
>
> On 1/20/2023 5:35 AM, Bagas Sanjaya wrote:
> > Stephen Rothwell reported htmldocs warning then merging accel tree:
> >
> > Documentation/accel/introduction.rst:72: WARNING: Inline emphasis start-string without end-string.
> >
> > Sphinx confuses the file wildcards with inline emphasis (italics), hence
> > the warning.
> >
> > Fix the warning by escaping wildcards.
> >
> > Link: https://lore.kernel.org/linux-next/20230120132116.21de1104@canb.auug.org.au/
> > Fixes: f65c5dac207322 ("docs: accel: Fix debugfs path")
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
>
> Thanks for addressing this before I even saw the warning report.
>
> Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Thanks.
Picked up to my tree (as the original commit is in my tree).
Oded
