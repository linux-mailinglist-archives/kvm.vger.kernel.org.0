Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7129A5F122F
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 21:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbiI3TL0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 15:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbiI3TLR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 15:11:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7351739FA
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 12:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664565068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dy8Uh1yUdP66YRnfDVl5TQBoktfqczK48Fg+4EtkRWw=;
        b=Ousk5pwIXfETWl0Rn2tddnzDLcMHrWr8XogOjF/cm6/z1u4DTXiuFeCHqnncMRoWOdN5mW
        P+N3nPWtA7vpqIAxR9JO6EL+khE9rKAMDQKf7xP+Raqd2sT+5TAPeBT0P7TI88kgFESIK6
        jg9QcbKDE85oVLl4IGKZAALmdU+F/vQ=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-624-bVemEYgUOh6zGBHbAFh-9Q-1; Fri, 30 Sep 2022 15:11:07 -0400
X-MC-Unique: bVemEYgUOh6zGBHbAFh-9Q-1
Received: by mail-ua1-f70.google.com with SMTP id d1-20020ab03181000000b003beefd10211so1865645uan.20
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 12:11:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=dy8Uh1yUdP66YRnfDVl5TQBoktfqczK48Fg+4EtkRWw=;
        b=ZgLv47xwf25rwBQKidTpdMzO2arpvdeRjyWB7phRzrmyEM5HlSi4AL6qp1yBvwWBc5
         CTKn1uBvpdvNRkEJ7xPiubcu4jfAkGPYYYrxJRvhsjANw/Yy1q9iU+xwyvLNB4q/28K0
         kyyS9bfBut3pvDXmH4AXf1AgJ+Jb8Rz6Wekb6ncr7UJCmwywyMqFZXOIx6jVw/QyoLoS
         mhE2QywbDme0Zmho4kpz8v+QgKmWx0YArbjqG3XpFZ1VT53bgqs5K8v++YwS45Bojxto
         8yE4Mzb6dPAxsMLt56R1mSKX3U8d6tnQ2VuyQ2riAaysDrJ41PYpqXJflPUCCqU7Q5Sc
         rW4w==
X-Gm-Message-State: ACrzQf1/ksCHXyH2u7h9DbdLryClzRTXjER8WypqPqJUBSGynvsk/4Mn
        uNq+xKgWv8ik2y78vaYA02SlfPKxHm3jt+Pvp1QIUm4lmSe5QK0rpYOCnA/6nP2uP/4X4eU5XyM
        5lNsU93QQ//80hhHLJ6yF3Lpto9qX
X-Received: by 2002:a67:ac4c:0:b0:3a4:b881:4490 with SMTP id n12-20020a67ac4c000000b003a4b8814490mr5295101vsh.42.1664565066906;
        Fri, 30 Sep 2022 12:11:06 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5fOcBi57Ofxg/3RpQLm565SRhPLI12A2Nih1X05TK5Q2sEHbLMv2GRlz2GdjzqgShtWge691nDwTLG2o1s7r4=
X-Received: by 2002:a67:ac4c:0:b0:3a4:b881:4490 with SMTP id
 n12-20020a67ac4c000000b003a4b8814490mr5295088vsh.42.1664565066659; Fri, 30
 Sep 2022 12:11:06 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eRkuPPtkv7LadDDMT6DuKhvscJX0Fjyf2h05ijoxkYaoQ@mail.gmail.com>
 <20220903235013.xy275dp7zy2gkocv@treble> <CALMp9eR+sRARi8Y2=ZEmChSxXF1LEah3fjg57Mg7ZVM_=+_3Lw@mail.gmail.com>
 <CALMp9eT2mSjW3jpS4fGmCYorQ-9+YxHn61AZGc=azSEmgDziyA@mail.gmail.com>
 <20220908053009.p2fc2u2r327qyd6w@treble> <CALMp9eQ9A0qGS5RQjkX0HKdsUq3y5nKHFZQ=AVdfNOxxDPC65Q@mail.gmail.com>
 <3f9c7cf9-4b77-fa21-5ffa-b32b305f8d57@redhat.com>
In-Reply-To: <3f9c7cf9-4b77-fa21-5ffa-b32b305f8d57@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 30 Sep 2022 21:10:54 +0200
Message-ID: <CABgObfZ3UNRwN=XG5R0JDX7eAhZU6pA47Y7oV+QV32csdyQSWw@mail.gmail.com>
Subject: Re: Guest IA32_SPEC_CTRL on AMD hosts without X86_FEATURE_V_SPEC_CTRL
To:     Jim Mattson <jmattson@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     kvm list <kvm@vger.kernel.org>, "Moger, Babu" <Babu.Moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 29, 2022 at 8:14 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> I think it's easier to just do both sides than to wait for
> clarifications.  I'll take a look.

Ok, I have a first attempt at patches to move IA32_SPEC_CTRL (but not
SSBD) to assembly.  I need some time to test them though, so expect
them towards the end of the merge window.

Paolo

