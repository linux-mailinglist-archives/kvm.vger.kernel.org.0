Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC64A65869F
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 21:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiL1UQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 15:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiL1UQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 15:16:23 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52EA714D28
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 12:16:22 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id u8so8684787ilq.13
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 12:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9QLEzUOv77SITzoeVrj0OIlPqik0hjcbepFC3pXiGFc=;
        b=nJuiCcxqbnGdd0Nw0gAUW1qImTlYRb2F4Z1Gi0qGU/JHQCQ57kCCVTSdVv7+WB894z
         zm+lMiIxcZTZnt50ihWWYIVCQYNbjWioaw9Fx1EifbILhv2PYLy7OytFCC+0UoluNl7P
         D2gFqmO+ke7FrXkctTJxeiICWJxAK1gZb8GrS+7eHHUtHYN+BCURoNUjrngMh+9gBBCk
         0PvnisrR3Pm7VUG5yQjhk12g0/lFr9adFFqsdNcguZ5+0Pwse1muqTnpFeOGImfYkTZe
         bEc5QXFCNyeJK7WgsF0RHAQQ70SEIPzaT6Ad6y7bZaFgAjDlydDb+hHR/O/6y6DTZZ/5
         fpWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9QLEzUOv77SITzoeVrj0OIlPqik0hjcbepFC3pXiGFc=;
        b=uk/61zW5nh5sSK6rRt6vlkT4QqakKBNiLCBCL5YyPpveWe4384iTehKt819wZQcMTE
         0cyyDIuyEEpeRCDe0dVB5Hr5NouCeW4HKewMdgOZKaDQUMKEGnwlgbcyf/WA/aLaJaat
         o/rjwRCoM0Wx9/Xq39Dlw/JmjPuHlvCubAaIJEHC0J35C4HTSKMBNRj4sYKrIaozVjq2
         X4pgR0LaAoZ1urwTLIbu9rWumZP7e573wZiZ8IUuVdsw3ZC02SXiLG3qu1IVaLjokRrd
         9uQZUomAqGVrGeFFh18j+vU5CSffHGCJahx/WuVD0FM5G0QA23ZAMFTJjDBpQOy67C3x
         r+FA==
X-Gm-Message-State: AFqh2kp8Qs5MXNqubXIVRsUefYjn5p+GUl2QnCztIPAD9gxTn804ivwp
        sK+xzdA47m2//nGWxQHq7DL6baYbjr/84t0KcJblGr4gNEDjqA==
X-Google-Smtp-Source: AMrXdXubHfsk/m6Myu2oB6/R0W/tn75MM/etzaiSHFclpma/chJHs6K23As0hteH3p6Gy60l7ID54lhbguJ5LeepH9Y=
X-Received: by 2002:a92:dcca:0:b0:303:26c0:e1fe with SMTP id
 b10-20020a92dcca000000b0030326c0e1femr2311698ilr.102.1672258581610; Wed, 28
 Dec 2022 12:16:21 -0800 (PST)
MIME-Version: 1.0
References: <20221227220518.965948-1-aaronlewis@google.com> <CALMp9eQfuq2VRqA37S16Am+3bWjWgAe27zyxnmNSeqzG-Dojuw@mail.gmail.com>
In-Reply-To: <CALMp9eQfuq2VRqA37S16Am+3bWjWgAe27zyxnmNSeqzG-Dojuw@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 28 Dec 2022 20:16:10 +0000
Message-ID: <CAAAPnDHcNPWhO+rSdkZOjXaMM7QQowkfvLh5PkeRbC786dBbmA@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Assert that XSAVE supports XTILE in amx_test
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
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

On Wed, Dec 28, 2022 at 6:36 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Tue, Dec 27, 2022 at 2:05 PM Aaron Lewis <aaronlewis@google.com> wrote:
> >
> > The check in amx_test that ensures that XSAVE supports XTILE, doesn't
> > actually check anything.  It simply returns a bool which the test does
> > nothing with.
> > Additionally, the check ensures that at least one of the XTILE bits are
> > set, XTILECFG or XTILEDATA, when it really should be checking that both
> > are set.
> >
> > Change both behaviors to:
> >  1) Asserting if the check fails.
> >  2) Fail if both XTILECFG and XTILEDATA aren't set.
>
> For (1), why not simply undo the damage caused by commit 5dc19f1c7dd3
> ("KVM: selftests: Convert AMX test to use X86_PROPRETY_XXX"), and
> restore the GUEST_ASSERT() at the call site?

I opted to add the assert in the check call to be consistent with the
others.  I thought it would look odd to have 3 check calls being
called one after the other, where 2 of them made the call and did
nothing with the result and 1 was wrapped in an assert.

> Should this be two separate changes, since there are two separate bug fixes?

Sure, splitting this into two commits SGTM.
