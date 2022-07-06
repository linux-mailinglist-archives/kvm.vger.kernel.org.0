Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74F1569094
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 19:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbiGFRXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 13:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233833AbiGFRXY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 13:23:24 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61EA2A72C
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 10:23:20 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1013ecaf7e0so22173945fac.13
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 10:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tPWCwpex3VBVFgQu6yoKU/WLAcmA2w8RYs57TebBIEg=;
        b=kl2XUVtIBKsAN8CtX4BLu2dFWxeKd0xUSj/TbIDjkcFC3I7CWXeyDn8V53FM0S9vav
         QKucap5rY6MOSfp2ETBCH1z84Zfsrf9WUJTn/qjzGoL0fOCeWm2EFl59Wnv4Qx7aNalC
         Ug7tYZKJCDUi5YOXH3oE/OnKdtokiqY626AnT5mVlv9LrDJnXEDu781Xcs1fBURrWZf1
         8BjXYe+2+DWUDX5XYXVnjOM4quCBRvyphbx9/vtJntIDVV7ia6dP3F66h1pr6DOjZEpO
         CxPXGs21RqvJGGXvesb1fYfsD2o5thiBrv5bnBBkBiC1dh4bmzJdr5B29yOcNZ+/QqC/
         03dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tPWCwpex3VBVFgQu6yoKU/WLAcmA2w8RYs57TebBIEg=;
        b=Sia20ixA9Cl7fwIz9tm11o29x4QYMqNXUTwP1OcKzCRO20Wl3ivq0IjHPqiGWxcu3H
         Plq5jM/OI0GYT5qd756/5IPGrEtTFhTXPKdySldhHTV3LFqFVOFBqyXttluItQ17dG8X
         JqYdgYNjJO1wr66vbldgVSQh9WURw/Ao4YlyIrz2sNs1yk4rxeDCkROSUAxtVW0XWH9f
         SSKSZyJyW47x1Gn7WNt7AVbjS0ZuAnqoQq84GxZZHy9Y7x9n18Yn9I9P8xmYzqquVeDw
         VlRbAxdFNhimVDr8Pr0t4fL9aRVFYhngyyebG/CvAUNEmQ4nUkXcYYC+vMKurmcNgLgS
         BHmA==
X-Gm-Message-State: AJIora+wHw1Z3p7siMIBppljyaLuHtwiK3I0nQtxNo4vjCsDcViCcDcY
        1oUFUeKqnTZKVlCAvPZDZ7EUuJ2sBKuZtiZvX2CySA==
X-Google-Smtp-Source: AGRyM1vRD3NkmrNqNiwdHn2g5Q8mk0mq8JnN5jDD29JND8P6Nc5LEWQfX9wCIJQKqFyPwDNNkreMmrmPhBsXURA6FeU=
X-Received: by 2002:a05:6870:56aa:b0:10b:f4fb:8203 with SMTP id
 p42-20020a05687056aa00b0010bf4fb8203mr11763413oao.181.1657128199333; Wed, 06
 Jul 2022 10:23:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220606175248.1884041-1-aaronlewis@google.com>
 <20220606175248.1884041-2-aaronlewis@google.com> <CALMp9eT3U+kLJTJJ_QP66LQPTQywVTuxucx=7JU74Xb7=xeY0g@mail.gmail.com>
 <CAAAPnDHFMdxpsP6TJywQWoMtOudYpc4Z3+pNq7OJA6223L0mcg@mail.gmail.com>
In-Reply-To: <CAAAPnDHFMdxpsP6TJywQWoMtOudYpc4Z3+pNq7OJA6223L0mcg@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 6 Jul 2022 10:23:08 -0700
Message-ID: <CALMp9eTwpnt6-Js3NHJN8uPAq2Zmgf9LPtyxcXNFefzEpxfyDw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
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

On Wed, Jul 6, 2022 at 9:11 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> > > +In this mode each event in the events field will be encoded with mask, match,
> > > +and invert values in addition to an eventsel.  These encoded events will be
> > > +matched against the event the guest is attempting to program to determine
> > > +whether the guest should have access to it.  When matching an encoded event
> > > +with a guest event these steps are followed:
> > > + 1. Match the encoded eventsel to the guest eventsel.
> > > + 2. If that matches, match the mask and match values from the encoded event to
> > > +    the guest's unit mask (ie: unit_mask & mask == match).
> > > + 3. If that matches, the guest is allow to program the event if its an allow
> > > +    list or the guest is not allow to program the event if its a deny list.
> > > + 4. If the invert value is set in the encoded event, reverse the meaning of #3
> > > +    (ie: deny if its an allow list, allow if it's a deny list).
> >
> > The invert flag introduces some ambiguity. What if a particular event
> > matches two of the masked filter entries: one with an invert flag and
> > one without?
> >
>
> That's a good point!  I think I can deal with that by validating the
> events when they are being set to ensure that for a particular event
> the invert flags are all set the same way and return EINVAL if they're
> not.

Once conflicts are disallowed, how is the behavior changed by an
'invert' entry? Isn't the behavior the same as not including the entry
at all?
