Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20CC66A1379
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 00:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjBWXEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 18:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjBWXET (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 18:04:19 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC1C3CE0B
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 15:04:13 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id j19-20020a05600c1c1300b003e9b564fae9so877533wms.2
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 15:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NBvLs7lBdngoivVBipp1LXFFXJN3i+RNM180w+5RMpk=;
        b=FiW8FwLdaJJ3Ejjd8nyNwAr16lZiqCiWjrdhHgRCBrD29k4cTTuoO43E6OE6+RXxdm
         DHWkG2Ci1ZVjpiMA+2MwuTvId9vGiyOkzw1sP2iTYZUndR8Fxrw3RKXwRZrkAhOMH3zN
         VhnKUS9yhk6KVPLEbh/HiwMMdgkVsr6LrOJ3IzeK28lDwjC3oGihN2rvVPZhy7hXCUuy
         +j4tMRNs4dp6jhHMEumvTo6YoAq6kIEHIr/4578Ei93YY4HME/5l9udr4fwKo1lg2br/
         uGTP2RZk2YBHi9SFOTgeOoimxocxDRkzrcdnaedgkxlzoPTv0hMa6HQZaJgZKJaX+2ln
         sAlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NBvLs7lBdngoivVBipp1LXFFXJN3i+RNM180w+5RMpk=;
        b=Fg2FIsvHqpZCcjMNCM9KqwpUlOSas9WkVrh/eQ1g9iCdUmlfrkOSgz1EhxNis3Bgyl
         4YmgN4LOzJeUlc0Yma/2eAbNA7tEEeRzItvPa513yru3e3OWBTGRFe1NGwd6yLGw8Trv
         AZ3XYzfeOuuzRPWFaJAEAPNxJ9OX+QQCcc5VG5yEwxfSaAXZGN7cIlPBprvhwDD8sZa7
         6QNw9LXzlIN+nCZq4wFpmVYUIItSkNLFOoc9Ud9w3JgsemSzcaoirdS5Nf7O0mLA3Nnw
         KxTjTt1TNfrgnwSStopi9+5QCHJ3u5fOUTa/mTOI7F8ULkG+x03Qubeji7o6PaOK4x7U
         O1aA==
X-Gm-Message-State: AO0yUKUruHUqS9Md0aHY21DZ3dWlsAuQGtFp0b+XbxFzjOoxP4EJbN75
        SWXrHfG4dSo77h4E6cezgzEKFbbGj9iU8HyeqvJE5va80070jPuDLT0=
X-Google-Smtp-Source: AK7set+VtUK1cA8uSpz2nZ/w7KJYKiO0L1FLuVMi7a6aDY8/1fPK0lUXVW0clmShU02l4J3XkQDFtwlnehZTO1kKeRw=
X-Received: by 2002:a05:600c:4f44:b0:3df:97de:8baf with SMTP id
 m4-20020a05600c4f4400b003df97de8bafmr656780wmq.8.1677193451582; Thu, 23 Feb
 2023 15:04:11 -0800 (PST)
MIME-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-6-amoorthy@google.com>
 <87mt5fz5g6.wl-maz@kernel.org> <CAF7b7mr3iDBYWvX+ZPA1JeZgezX-BDo8VArwnjuzHUeWJmO32Q@mail.gmail.com>
 <Y+6iX6a22+GEuH1b@google.com> <CAF7b7mqeXcHdFHewX3enn-vxf6y7CUWjXjB3TXithZ_PnzVLQQ@mail.gmail.com>
 <Y+/kgMxQPOswAz/2@google.com> <CAF7b7mpMiw=6o6vTsqFR6HUUCJL+1MSTDUsMaKLnS1NqyVf-9A@mail.gmail.com>
 <Y/fS0eab7GG0NVKS@google.com>
In-Reply-To: <Y/fS0eab7GG0NVKS@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 23 Feb 2023 15:03:35 -0800
Message-ID: <CAF7b7mqV4p_t4yJx6yyFFk7AQ2w6jVDCXUQfA+aza_OQya2qfA@mail.gmail.com>
Subject: Re: [PATCH 5/8] kvm: Add cap/kvm_run field for memory fault exits
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org,
        James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Feb 23, 2023 at 12:55=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> Off-topic, please adjust whatever email client you're using to not wrap s=
o
> agressively and at seeming random times.
> As written, this makes my eyes bleed, whereas formatting like so does not=
 :-)

Oof, that *is* pretty bad. I think I have the cause figured out
though, so I'll be careful about that from now on :)

>   Ok so I have a v2 of the series basically ready to go, but I realized t=
hat I
>   should probably have brought up my modified API here to make sure it wa=
s sane:
>   so, I'll do that first
>
>   ...
>
>   which, apart from the name of the "len" field, is exactly what Chao
>   has in their series.
>
>   Flags remains a bitfield describing the reason for the memory fault:
>   in the two places this series generates this fault, it sets a bit in fl=
ags.
>   Userspace is meant to check whether a memory_fault was generated due to
>   KVM_CAP_MEMORY_FAULT_EXIT using the KVM_MEMORY_FAULT_EXIT_REASON_ABSENT=
 mask.
>
> > flags remains a bitfield describing the reason for the memory fault:
> > in the two places
> > this series generates this fault, it sets a bit in flags. Userspace is
> > meant to check whether
> > a memory_fault was generated due to KVM_CAP_MEMORY_FAULT_EXIT using the
> > KVM_MEMORY_FAULT_EXIT_REASON_ABSENT mask.
>
> Before sending a new version, let's bottom out on whether or not a
> KVM_MEMORY_FAULT_EXIT_REASON_ABSENT flag is necessary.  I'm not dead set =
against
> a flag, but as I called out earlier[*], it can have false positives.  I.e=
. userspace
> needs to be able to suss out the real problem anyways.  And if userspace =
needs to
> be that smart, what's the point of the flag?
>
> [*] https://lore.kernel.org/all/Y+%2FkgMxQPOswAz%2F2@google.com

My understanding of your previous message was off: I didn't realize
that fast gup would also fail for present mappings where the
read/write permission was incorrect. So I'd agree that
KVM_MEMORY_FAULT_EXIT_REASON_ABSENT should be dropped: best not to
mislead with false positives.

> >
> > (3) switched over to a memslot flag: KVM_CAP_MEMORY_FAULT_EXIT simply
> > indicates whether this flag is supported.
>
> The new memslot flag should depend on KVM_CAP_MEMORY_FAULT_EXIT, but
> KVM_CAP_MEMORY_FAULT_EXIT should be a standalone thing, i.e. should conve=
rt "all"
> guest-memory -EFAULTS to KVM_CAP_MEMORY_FAULT_EXIT.  All in quotes becaus=
e I would
> likely be ok with a partial conversion for the initial implementation if =
there
> are paths that would require an absurd amount of work to convert.

I'm actually not sure where all of the sources of guest-memory
-EFAULTs are or how I'd go about finding them. Is the standalone
behavior of KVM_CAP_MEMORY_FAULT_EXIT something you're suggesting
because that new name is too broad for what it does right now? If so
then I'd rather just rename it again: but if that functionality should
be included with this series, then I'll take a look at the required
work given a couple of pointers :)

I will say, a partial implementation seems worse than no
implementation: isn't there a risk that someone ends up depending on
the incomplete behavior?
