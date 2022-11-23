Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98B463677F
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 18:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237815AbiKWRo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 12:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236541AbiKWRoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 12:44:25 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3051D8CBBC
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 09:44:24 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id l8so22175494ljh.13
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 09:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u1xkewih3/RfIoNkoMopgJDb13M3oVFzr/bToZLrQIw=;
        b=cGHMJ+9h9xdjFiwn7bM8dnjCph/pcc2c2reICFyUSB9bQM1hn8QvQn/qYmqxDIY4Js
         FRcXHZOzwMRUNPVeuHhZpCs6SECFpwg3XcleCmqYcoicq+Rgc7EbtJ97zXSJ+KRogiYY
         SWxyJCkIRKULl4FTq4pD7xhn6Sl5vnokrZs+xqkS/6gAtUVTV099XbrtOqj+0l5rfqse
         o5w7CX6D2alR+6U98zk19C75tyfA5M1B7GrnW8S/7Lke8pzQLAysPiie2dF9jh9dR4UA
         BIHin4ZIsqks0Dd7AHHBHxgshERWIHfeYLXjtLdK5q+AH1+/jQzrQTPLYuZyDVDuuy1/
         rZOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u1xkewih3/RfIoNkoMopgJDb13M3oVFzr/bToZLrQIw=;
        b=NUnupsSQc+NI5MOWDl7yGAs4R3uVShWrB6rPyjsELbnDFnA6oiHRzWjV++rC10q3Pl
         NDxmkNjYLndRrxpCbG0FD3DRbA4Fh1ZYgFROolKwThfdQuJbJrZJSc3rCI0QrVuez2BM
         5gMAkkPcniEYP69Uh8/YEgmzt1gv33I9NTSN/Nb8kQN5YImTlH93CUVOi+cehaCWG7UV
         9CcL16kRAMe/8bUQEYhTmosSd1Mg7hZxTRvtgwWL/VriB2MvLHzesuD0EE9C/JuPLCJc
         qxSBncVjg1XHflFZSR0BuB3jsxNE1IU4Mm1CQQE8KGWCKLyN6aFUUgGrdpeohYMSKNJB
         6ANQ==
X-Gm-Message-State: ANoB5pnubvJxqBXkosWBMvAQEsVvwLWhaEJWLCBzDNG37JpVEdKUxBjE
        RN8kZ7ZoAiE93hQtEYz3M51tUHoUxjqYYVkU9OozJg==
X-Google-Smtp-Source: AA0mqf439CreUnpaeWwBjF5hB8UZGECQqTvVfpzTMLQ4+KpxuACkd1Dw99kXAOqepPOD2nsGP9lQAP45vgETI9r0JTU=
X-Received: by 2002:a2e:bf17:0:b0:277:394:34e with SMTP id c23-20020a2ebf17000000b002770394034emr3204506ljr.18.1669225462333;
 Wed, 23 Nov 2022 09:44:22 -0800 (PST)
MIME-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com> <20221115111549.2784927-2-tabba@google.com>
 <Y35FdsVXdZf62tLO@monolith.localdoman>
In-Reply-To: <Y35FdsVXdZf62tLO@monolith.localdoman>
From:   Fuad Tabba <tabba@google.com>
Date:   Wed, 23 Nov 2022 17:43:45 +0000
Message-ID: <CA+EHjTx_nD_BqRvNkkPtPyrsC+gH8NvyzreLJHWBqmo1ZA5cLg@mail.gmail.com>
Subject: Re: [PATCH kvmtool v1 01/17] Initialize the return value in kvm__for_each_mem_bank()
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
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

Hi,

On Wed, Nov 23, 2022 at 4:08 PM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On Tue, Nov 15, 2022 at 11:15:33AM +0000, Fuad Tabba wrote:
> > If none of the bank types match, the function would return an
> > uninitialized value.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  kvm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kvm.c b/kvm.c
> > index 42b8812..78bc0d8 100644
> > --- a/kvm.c
> > +++ b/kvm.c
> > @@ -387,7 +387,7 @@ int kvm__for_each_mem_bank(struct kvm *kvm, enum kvm_mem_type type,
> >                          int (*fun)(struct kvm *kvm, struct kvm_mem_bank *bank, void *data),
> >                          void *data)
> >  {
> > -     int ret;
> > +     int ret = 0;
>
> Would you consider moving the variable declaration after the 'bank'
> variable?

Will do.

> >       struct kvm_mem_bank *bank;
> >
> >       list_for_each_entry(bank, &kvm->mem_banks, list) {
>
> Shouldn't the function return an error if no memory banks matched the type
> specified (initialize ret to -EINVAL instead of 0)? I'm thinking that if
> the caller expects a certain type of memory bank to be present, but that
> memory type is not present, then somehwere an error occured and the caller
> should be made aware of it.
>
> Case in point, kvm__for_each_mem_bank() is used vfio/core.c for
> KVM_MEM_TYPE_RAM. If RAM hasn't been created by that point, then
> VFIO_IOMMU_MAP_DMA will not be called for guest memory and the assigned
> device will not work.

I was following the behavior specified in the comment. That said, I
agree with you that returning an error should be the correct behavior.
I'll fix that and adjust the comment to reflect that.

Cheers,
/fuad

> Thanks,
> Alex
>
> > --
> > 2.38.1.431.g37b22c650d-goog
> >
