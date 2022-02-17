Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5D74BA365
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 15:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242036AbiBQOqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 09:46:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233769AbiBQOql (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 09:46:41 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F171813D46
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 06:46:26 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id 124so13448168ybn.11
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 06:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b+lg+SpabOofLGFb+LiWtbCjp+/6//uhjOi4ITbKN9U=;
        b=gUwrF07BLzthi2PO767WPBFhcHESA5aYRgxQUrnq0U/5nYLmLPt/l/eS+Sa66C1nCV
         UHZfpI8ugZjzZ3M8MA5+75Xu2jlXRsh47zlxXtUzHWtKhCLHOmec9ifcolD//nPuxm/9
         y7slvryMnL2E3P+CfmetrA192Fe4DAYI+XY5bmY7fVCnFii8peoV5+Q32eHehKNw3xkL
         ahMjNJrUJYfEYY1jcUBTUgkh+scV1A9eeUvGmVgP04qXMntk53IL9oEQjDKuyyesB/I0
         faxJPPOEkrMqC1IobKi3EZZaVyqbPYO2iduFgm0B0VnxdDLjMLWru6/OuQURBJPm0ykw
         CCNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b+lg+SpabOofLGFb+LiWtbCjp+/6//uhjOi4ITbKN9U=;
        b=Phmjit+V1R6Jwwnna/I3GBrpaA+UCTD75nkAF5bqgnfpOrfLNLDQWEIxCLKS+PzTOh
         X7RerIgRmX+0YXx4Ep8zXEnImgvGeId+n8R2dVH49dfLqtsrDB1H2/P61ty03A9DSrgf
         iqQL2fYxmCVHcfr/DT6a6F6ip/n7d3xYy92kHi6V6cT2zASI4rX11jYyP3ulFX69u5Ax
         lTQJgxptwcrHVhVunTi7b5XFgHPYpQFsDYwNlSLz82k4IdeoPaRSfD43RIQbyW+5fWGd
         cQf170E+ti2IhDHUkxczBVXoR4tOxRKC6SYlJEaZxf+Cf2x1oTvu6fNxhd9uqpTrL4mZ
         Lrmg==
X-Gm-Message-State: AOAM531husD6WDKrWB/4EY6hBlh5D9E1Nbgf+XkmVSCbXlTDxfQ0wYPL
        e827vp92I0B+qbeP2VRZ5jdjipVtwrPukFbxMpx3tA==
X-Google-Smtp-Source: ABdhPJzfTKgh0s/ThfKGKF3qHxwikIsXZdbjz7YUWisdldaWLBVCQwpKInY82EGd2v+ZEPLtKkkY7JrIB2y3Y9PKhxQ=
X-Received: by 2002:a25:5145:0:b0:61d:ad99:6e5a with SMTP id
 f66-20020a255145000000b0061dad996e5amr2732776ybb.228.1645109185430; Thu, 17
 Feb 2022 06:46:25 -0800 (PST)
MIME-Version: 1.0
References: <20220207051202.577951-1-manali.shukla@amd.com>
 <20220207051202.577951-4-manali.shukla@amd.com> <CAAAPnDH6y6pFG+Mw_JCYYi9rome0d0+Q4UTLK3KoBzREvkJwqw@mail.gmail.com>
 <18489ffd-c3bc-2f0c-38cf-9faa74cf3363@amd.com>
In-Reply-To: <18489ffd-c3bc-2f0c-38cf-9faa74cf3363@amd.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 17 Feb 2022 14:46:14 +0000
Message-ID: <CAAAPnDGHivqTYPqKf0B0Ej8JDQ5Npm45aN5ibSdN-bafDuhiPA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: nSVM: Add an exception test
 framework and tests
To:     "Shukla, Manali" <mashukla@amd.com>
Cc:     Manali Shukla <manali.shukla@amd.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, seanjc@google.com
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

> >> +};
> >
> > If you set and clear PT_USER_MASK in svm_l2_ac_test() before calling
> > into userspace you can remove init_test and uninit_test from the
> > framework all together.  That will simplify the code.
> >
> If clear user mask is called after userspace code, when #AC exception is
> intercepted by L1, the control directly goes to L1 and it does not reach
> clear_user_mask_all() function (called after user space code function run_in_user()).
>
> That is why I have added init_test and uninit_test function
>

Ah, that makes sense.  Though IIUC, you are now moving the set/clear
elsewhere, right?  If so, it seems like init_test() and uninit_test()
are no longer needed.

> > Further, it would be nice to then hoist this framework and the one in
> > vmx into a common x86 file, but looking at this that may be something
> > to think about in the future.  There would have to be wrappers when
> > interacting with the vmc{s,b} and macros at the very least.
> >
