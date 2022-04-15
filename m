Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85344502E5F
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 19:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244359AbiDORpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 13:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243665AbiDORpK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 13:45:10 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6292CB7C59
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 10:42:40 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id w127so8934141oig.10
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 10:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UwC5QDp7nkvFXpvDV56I8DCbx0MMeEN30y42tX7xnCc=;
        b=UN8heby0+n8nWemOV0C9nILQfvG81Hb3TYLavax274HTrcuUzEEMJaYJ3mvxieUuQy
         yr9UsDIftL3s5n8U/dIYPTttajV5CN3LnmWlgfUNXI+enrrsnAcBlig2f37oeX90Fp9O
         xXf3u6XR6NTghcLaN7rgMPevht2r/TD7tbID/7S2C+jIP4aCPKRF21OCm6mshg7IxTC8
         XbpZiivgKE7K9nGdowOi0D1pmQSFm+qU5GJ9t26p0x4BaT99KG174rghcpkY6QDXVEd3
         tS4A06Opjz+zyWxlxkAPQnbuQF6T2BwRAFbpx1Ca5dy16dZJRqdvOh+/1Y6XMAdSutdF
         Dz3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UwC5QDp7nkvFXpvDV56I8DCbx0MMeEN30y42tX7xnCc=;
        b=48ZUhw7D/OEzXiE9JdICpezeaukgyCHh1wOGChPEx5veDjus0vIJ4h0S7FcHlXIl5r
         IPJY0P0oARl0INJpiWUTR4M8VxkjD49VseJBUrwKh+K8cmZg4qSxkbTzGdbNosXFolnd
         h3zq58JQuMYJ7qhlmdFRUd10Oa1NcszXKeGHqxCP4IXIj5VSeQpmRMSykZnMnh1BPEJT
         39gzsiyFDfOIQD6YPWzTwc1iWWdH8a99OtnxC/LJSZiNuo3Ag2Ybu6D5EYc5xj5SxoZq
         XmP0YbpFZgT70nNUi10Ud4uqqvHV1Izk/aHEAC562UR7bGvK1ZGITFWWWc6CgvYRSLql
         MTrg==
X-Gm-Message-State: AOAM531BiNyMkTGJCyaOB80S0KkVXHmCuJNOnzMO6XRpvpAUbSh1yQuQ
        DqTDGpnCmO7sAillnw7ZrCbSUvhcE/MzsRLVrV38n2AZz1s=
X-Google-Smtp-Source: ABdhPJyXvqeFlr3AuJoee9DtvqnjZbalWx9epvYBtgEC3X8VwW7eagaj4yJWsyy5WBCF7dIHCkZQoC78EFFdqKjtqi8=
X-Received: by 2002:a05:6808:169e:b0:2f9:6119:d67f with SMTP id
 bb30-20020a056808169e00b002f96119d67fmr2077753oib.218.1650044559513; Fri, 15
 Apr 2022 10:42:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220224105451.5035-1-varad.gautam@suse.com> <20220224105451.5035-12-varad.gautam@suse.com>
 <Ykzx5f9HucC7ss2i@google.com> <Yk/nid+BndbMBYCx@suse.de> <YlmkBLz4udVfdpeQ@google.com>
 <CAA03e5ETN6dhjSpPYTAGicCuKGjaTe-kVvAaMDC1=_EONfL=Sw@mail.gmail.com>
In-Reply-To: <CAA03e5ETN6dhjSpPYTAGicCuKGjaTe-kVvAaMDC1=_EONfL=Sw@mail.gmail.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 15 Apr 2022 10:42:28 -0700
Message-ID: <CAA03e5EZS2ydJTabsoqa5H+Pe1BL58BA+8F=m+r3qmhJURiA-w@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 11/11] x86: AMD SEV-ES: Handle string IO
 for IOIO #VC
To:     Sean Christopherson <seanjc@google.com>
Cc:     Joerg Roedel <jroedel@suse.de>,
        Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bp@suse.de
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

On Fri, Apr 15, 2022 at 10:22 AM Marc Orr <marcorr@google.com> wrote:
>
> On Fri, Apr 15, 2022 at 9:57 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Apr 08, 2022, Joerg Roedel wrote:
> > > On Wed, Apr 06, 2022 at 01:50:29AM +0000, Sean Christopherson wrote:
> > > > On Thu, Feb 24, 2022, Varad Gautam wrote:
> > > > > Using Linux's IOIO #VC processing logic.
> > > >
> > > > How much string I/O is there in KUT?  I assume it's rare, i.e. avoiding it entirely
> > > > is probably less work in the long run.
> > >
> > > The problem is that SEV-ES support will silently break if someone adds
> > > it unnoticed and without testing changes on SEV-ES.
> >
> > But IMO that is extremely unlikely to happen.  objdump + grep shows that the only
> > string I/O in KUT comes from the explicit asm in emulator.c and amd_sev.c.  And
> > the existence of amd_sev.c's version suggests that emulator.c isn't supported.
> > I.e. this is being added purely for an SEV specific test, which is silly.
> >
> > And it's not like we're getting validation coverage of the exit_info, that also
> > comes from software in vc_ioio_exitinfo().
> >
> > Burying this in the #VC handler makes it so much harder to understand what is
> > actually be tested, and will make it difficult to test the more interesting edge
> > cases.  E.g. I'd really like to see a test that requests string I/O emulation for
> > a buffer that's beyond the allowed size, straddles multiple pages, walks into
> > non-existent memory, etc.., and doing those with a direct #VMGEXIT will be a lot
> > easier to write and read then bouncing through the #VC handler.
>
> For the record, I like the current approach of implementing a #VC
> handler within kvm-unit-tests itself for the string IO.
>
> Rationale:
> - Makes writing string IO tests easy.
> - We get some level of testing of the #VC handler in the guest kernel
> in the sense that this #VC handler is based on that one. So if we find
> an issue in this handler we know we probably need to fix that same
> issue in the guest kernel #VC handler.
> - I don't follow the argument that having a direct #VMGEXIT in the
> test itself makes the test easerit to write and read. It's going to
> add a lot of extra code to the test that makes it hard to parse the
> actual string IO operations and expectations IMHO.
> - I agree that writing test cases to straddle multiple pages, walk
> into non-existent memory, etc. is an excellent idea. But I don't
> follow how exposing the test itself to the #VC exit makes this easier.
> Worst case, the kvm-unit-tests can be extended with some sort of
> helper to expose to the test the scratch buffer size and whether it's
> embedded in the GHCB or external.

Also, having this handler does not stop anyone from contributing a
more elaborate test that turns out to need to implement its own #VC
handling.
