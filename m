Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9035AD9D7
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 21:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbiIETpu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 15:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbiIETps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 15:45:48 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697AC25288
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 12:45:46 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id t8-20020a9d5908000000b0063b41908168so6739861oth.8
        for <kvm@vger.kernel.org>; Mon, 05 Sep 2022 12:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=fHl6yMeuzT6h5uK9FH6IQV1Bl24t9+tJv4vuXbMlEXw=;
        b=jN77iQLW/enFCxA0tVNh4FW8LCcXCtDLRSV7cZy2zRgZlg8Tbs3eIAbn4omhgVd57S
         yZPcV0uD1ulSe9A1xfjDpC+a1L30xq6OWsxDHTMGdjko2Fzr8l7tnpm+ZwQB/YwCkOyN
         FWxUZffsLsnalQScHeKZZB07znrShg2KxVYBpNUzKFaacYt6t0fq0mBF49lBtprxzpUr
         p8C/EUQaw5N5pak1Vk5MGNUZAXs6gqRSBE+A0MW2E+/gK6XB0xFrkP5jfhahK0oxSWxG
         MdepxsfJIoGwYZ+fAyjNjLBcP9kZ654jHFWKd+pGydfhQEwx63HBg5RyelQmkuYDnMIF
         T1Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=fHl6yMeuzT6h5uK9FH6IQV1Bl24t9+tJv4vuXbMlEXw=;
        b=thh1Z9Z7iEYdMqhkDZ/pvR5GyRcpRPdZ8hElRWdZxnHB/J8/6DKTlMKjDmHl4q+gZ1
         Ppo8oRkzcauOvHnn8yMoGpKEDsIpQ/eVwVycd0ErTNtI7XXNQgEQy3olCZanPAOU09iv
         3mamcNb4FbOW0GXZfeXZ+hr4wV8dF7ILun1FGsqt2R9+LirBIuPoq2hrrVnXRdfSfFYs
         eOlVszZF7+d02730BlCC95+PgTKzWgXDADNmVBiCKrM8iqka6TTu+jn+gOxfE498nDQo
         N7lnXCgyXbaDyjn3Hq/3XDaVRXblLYiXa6/gVG7MyNKUQb4aQ2GrWrWir8mutcQJ/YyC
         j94A==
X-Gm-Message-State: ACgBeo14cOPO/tcDx0B7TQNQsAQ+2Me4JetIXlTwG6w2F9CLx8ZJ8H/4
        g63hR54LiNKL5v3jaDmNjrlTzxn0gmjY7q8ULr0XVLT6Sv4=
X-Google-Smtp-Source: AA6agR4q/AoB+KeU5E5RhiN8gNHFlhVuqMW1yp4G17ibjmBEd5gcL7d0sGk4sZm1CIBLagVQ4LCpLHdY2AlXWUEnejI=
X-Received: by 2002:a9d:4d99:0:b0:639:1fe0:37c1 with SMTP id
 u25-20020a9d4d99000000b006391fe037c1mr19384886otk.267.1662407145580; Mon, 05
 Sep 2022 12:45:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220602142620.3196-1-santosh.shukla@amd.com> <CALMp9eTh9aZ_Ps0HehAuNfZqYmCS72RKyfAP3Pe_u08N9F8ZLw@mail.gmail.com>
 <fd73f376-345d-6f58-987d-cca203e06cad@amd.com>
In-Reply-To: <fd73f376-345d-6f58-987d-cca203e06cad@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 5 Sep 2022 12:45:34 -0700
Message-ID: <CALMp9eR5rFtjWA+oee2JnmKVN5Br4R5CcqUijzH-2N+ix8HAfw@mail.gmail.com>
Subject: Re: [PATCH 0/7] Virtual NMI feature
To:     "Shukla, Santosh" <santosh.shukla@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 8, 2022 at 1:23 AM Shukla, Santosh <santosh.shukla@amd.com> wrote:
>
>
>
> On 6/7/2022 4:31 AM, Jim Mattson wrote:
> > When will we see vNMI support in silicon? Genoa?
> >
> > Where is this feature officially documented? Is there an AMD64
> > equivalent of the "Intel Architecture Instruction Set Extensions and
> > Future Features" manual?
>
> Hi Jim,
>
> A new revision of the Architecture programmers manual (APM) is slated
> to be release soon and that is going to have all the details for
> the above questions.

It's been about 3 months, and I haven't seen the new APM yet. Is there
an anticipated release date? It's hard to do a proper review of new
features without documentation.
