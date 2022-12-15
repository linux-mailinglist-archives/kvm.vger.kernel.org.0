Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F52864D4B2
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 01:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiLOAek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 19:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiLOAei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 19:34:38 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2468536C57
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 16:34:37 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id s7so5182313plk.5
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 16:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z/1fVhdM3NBYMXBQfLHzy+1+572vRA9PCs2hB32i8rE=;
        b=tdJFfFqmGXwvTNz7GXq3kJkLcGeqjAvDM167pZDfGZyich8NHDMQ/EFUsFMV/gHd9s
         jwLcQNfKe2R7q9+q5CZFT1cRBSO9dIIwQmBFV/FBeODZE3fJpsthkt+LBdBdHrXO2+gB
         wwQigHZRfuflKggdhkNMal/+J9SW21KA//wjcjidt4tgJhTC8prNNuDw9LVeOpacueI5
         xz+r3DJIYpyvd4MXqR4suXoFPZV4BnK39OR4oXble+2s1O3HbZlhhA9X46GEkK8YviFa
         NApnG4av4ur33LoOfPltEn0pmyB7Bn2ZWMKBmiiQpOyAgsxcKS6X+GeoT/TuzSZ30zub
         RU+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z/1fVhdM3NBYMXBQfLHzy+1+572vRA9PCs2hB32i8rE=;
        b=A5ceVO1DPfe2/3+9eig9hiPCFy7KbTHaBiOQzPoM5cjcHYWi3LPVgkXiMM22qyO8wG
         TBTVr6qqIWUJziva5T1Z5LyFiwPlaMQvI3Y14MOMwspC050UuFBv7JFhXQdRn2p5VfPz
         U/S4gF8IwfJaDWEsOsxOn4EEuZDriycUPbZl2eIIP1oE9HM4vI0nBZluwywjiSSlv5ZC
         yB87zDVbCoY+GO4ycY8trZw/Z3GDl9N8QLA08zszZVcdJ0XXmIpmeTElWIMaYFh+8dYm
         rYPD6ORQ9EN33eufV0iijKoovm04ciJsA1rWnsNr5iYI4rPMnBqNgDiVtrIGKCLvzN15
         ce/A==
X-Gm-Message-State: AFqh2krs8jpNXQDrcgREYu+R0D0aopBZFBnvILStXl8p5SAoxVz56y2/
        bn/lVjwupceSlLkM+5tiEJwHlp3Q29vhFmcc
X-Google-Smtp-Source: AMrXdXtYxIA/bhZSuNVKCq0zAPsRgjb1doOTAdvwdQTxgeqL8z5Qvt5q8Gq11GzIRsBGvIf/8wzMOQ==
X-Received: by 2002:a17:902:a587:b0:189:6d32:afeb with SMTP id az7-20020a170902a58700b001896d32afebmr802994plb.1.1671064476465;
        Wed, 14 Dec 2022 16:34:36 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x22-20020a170902821600b00189a50d2a38sm2440781pln.38.2022.12.14.16.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 16:34:34 -0800 (PST)
Date:   Thu, 15 Dec 2022 00:34:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     David Matlack <dmatlack@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 2/7] KVM: x86/MMU: Move rmap_iterator to rmap.h
Message-ID: <Y5prluKIKax5o8N9@google.com>
References: <20221206173601.549281-1-bgardon@google.com>
 <20221206173601.549281-3-bgardon@google.com>
 <Y5O+/1CYivRishFE@google.com>
 <CANgfPd8-i=B_c60MFn6symaqpUMXqu+HHJFDkQm8OuzOLnHQ+A@mail.gmail.com>
 <Y5kf2KI5oharI0xZ@google.com>
 <CANgfPd9xkRgm691Hy=Zbk=SAx-gaW-Hkk0XWQE0UsH9mJwLU-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd9xkRgm691Hy=Zbk=SAx-gaW-Hkk0XWQE0UsH9mJwLU-A@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022, Ben Gardon wrote:
> On Tue, Dec 13, 2022 at 4:59 PM Sean Christopherson <seanjc@google.com> wrote:
> > And if we rename pte_list_head, then we might as well commit 100% and use consisnent
> > nomenclature across the board, e.g. end up with

...

> I'd be happy to see some consistent SPTE-based naming in the Shadow
> MMU and more or less get rid of the rmap naming scheme. Once you
> change to spte_list_head or whatever, the use of the actual rmap (an
> array of spte_list_heads) becomes super narrow.

Yeah.  And at least for me, the more literal "walk a list of SPTEs" is much
easier for me to wrap my head around than "walk rmaps".

> Given the potential for enormous scope creep on what's already going
> to be a long series, I'm inclined to split this work into two parts:
> 1. Move code from mmu.c to shadow_mmu.c with minimal cleanups /
> refactors / renames; just move the code
> 2. Clean up naming conventions: make the functions exported in
> shadow_mmu.h consistent, get rid of the whole rmap naming scheme, etc.
> 
> That way git-blame will preserve context around the renames /
> refactors which would be obfuscated if we did 2 before 1,

+1

> and we can reduce merge conflicts.

That might be wishful thinking ;-)

One thought for the rename would be to gather all the reviews and feedback, and
then wait to send the final version until shortly before the merge window, i.e.
wait for everything else to land so that only future development gets affected.
That would give Paolo and I a bit of extra motiviation to get the x86 queue
solidified sooner than later too...
