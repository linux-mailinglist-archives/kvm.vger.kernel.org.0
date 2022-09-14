Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBFC5B8EC4
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 20:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiINSRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 14:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiINSRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 14:17:39 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662625E54B
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 11:17:39 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-12803ac8113so43227060fac.8
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 11:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=xpFMiG3IuzsD717GyFkFquBBjnA6a11zmARxbZj0X9Q=;
        b=PrOMROzfIar7U8kstyOdeWZDJ2ndcENGrJMozZBqRXtqsjzTtbm7jyYnSry6B6gadI
         73KqxDrdf/tNs6DFqnej/eAxotMt9qTVCXDTrF8W8B2BZJ5TDEZRrl+DeOVdvgKA7RO0
         FK0QIBb49pI8ZlaoElQPg8uZMWEuFPTRs4s/dyK+WHHXvkLsZK1/Hfm7+Xbie12wFDOx
         7n/Wu8y0h77NuD4+tAp8whdwpOIz6C/36sjoAAmdEg1LTgY44rfa8KY59RFQgRRiTu07
         LS0YASBqALrnEZ/l+gHAFlqCgVF6dAz93SpMub579k+fB0MGfhYm/WROayY0e+wFu3wr
         GAUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=xpFMiG3IuzsD717GyFkFquBBjnA6a11zmARxbZj0X9Q=;
        b=kgLO7BxYqniqnDICgjt9dLoROenTLXqs9xxWijgCH2TlErmSQ8vqPK1v14LZpwj9kg
         XXjm23Y7Xzh1WsOVeILL/CyQVbY+NntWjCH0ldyfP31XtzEwZDxkqMlZGnNSSRmtsiOj
         ReQEb2mN/YR3kxmGIEAPBMfXfD7wTGDXL9VbxvcDnufiyNr1Horm1uLRmLsjugqU41LF
         K4vmXZYu3v/ifaOZ2VTQE0FHuNDfmuAt9xNx/BQjlHagknwbDoWpPPMoiv4KqeagzMYY
         OIyy3Rlshb2cHwyS3I80sdFI50EnYhW054GY+jZBTxehdvpsDHjFEWDQS+DNgcg2eMTZ
         w7Iw==
X-Gm-Message-State: ACgBeo32CvUFtT2RAyySbMyWARlVR0AIoEpRSJjii9wSOAN1GAMLS/9p
        4FQfatvN9Gnf1Ro+xKaFAoJuyReoW1r43TnFNwkE2GCiW68=
X-Google-Smtp-Source: AA6agR6EKyH7OaqR4d1nt2WTkRjOv2tlxlZYC/pNlHM4XVdE4H9Aa7/mhTffgfBiwt5Fhbpw1JNo+U7mQTMZ/TTdxSI=
X-Received: by 2002:a05:6870:9593:b0:12b:fec4:f1c1 with SMTP id
 k19-20020a056870959300b0012bfec4f1c1mr3099039oao.181.1663179458613; Wed, 14
 Sep 2022 11:17:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220831162124.947028-1-aaronlewis@google.com> <20220831162124.947028-3-aaronlewis@google.com>
In-Reply-To: <20220831162124.947028-3-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 14 Sep 2022 11:17:27 -0700
Message-ID: <CALMp9eRmr2=2fvmg3eDVPTi01fNf-sQpDoJRSU48iMrcPW94JQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] kvm: x86/pmu: Remove invalid raw events from the
 pmu event filter
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
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

On Wed, Aug 31, 2022 at 9:21 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> If a raw event is invalid, i.e. bits set outside the event select +
> unit mask, the event will never match the search, so it's pointless
> to have it in the list.  Opt for a shorter list by removing invalid
> raw events.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
