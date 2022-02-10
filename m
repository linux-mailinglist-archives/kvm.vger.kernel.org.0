Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51204B166E
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 20:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344037AbiBJTgL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 14:36:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242374AbiBJTgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 14:36:09 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7C1E49
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 11:36:09 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id r19so12076386pfh.6
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 11:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X7ZCZU4H6FYuHw4L6H7qXi/BQnFS6lpLYRYNDIvWC0o=;
        b=HSmpVyxHHaDvzyRJNriQY8dA/ZYX59m6nbELEtzqkyKGO7p8K4V/p59R8t4a/eu0iS
         IQvO9f9bykaWsK5KXnF02a5wDG0KHrImRZwGO2M57ONNxGC++5yN4TfcWAYsUlrCyKRc
         DsTTWpgnETF7/gRQRB3ZsiKLE/NFaQJsLDaPto+nIKMVNUrbqhE5yFLxhRgtiLj/J4Ne
         VCBcwpOXD5SZ/VljpCOQso6JBLN1xjNF4I7YWxyrvbEk9+4tX6Kdplj0Q3h3iMr0UqXU
         gepfrDJhMvwVeLlBbxo1qm/lQonuQuBj/ia8odou5IaRQ8L1QNJUMdjxvvXV+irtE/NZ
         7ThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X7ZCZU4H6FYuHw4L6H7qXi/BQnFS6lpLYRYNDIvWC0o=;
        b=niBu5nNJizZmb7jE7gYJ9KJBr1GJZ9CkssGDxevIEfjhtJM1cbDnwsQRpZHL3tThaV
         2fWjNnZoNzpnWkvFzFXgBpdN/ItSDt05zP2ygwp8CmKQ+Uel4ok7IJZ6V1P5iXGlEuU0
         Ku4gHO/ryHota3fZ3usCz4WQb2hz4VgXqoqhmSNtyYRLNyO1LHdneMycprDs4CQtilD+
         y3y7RT+g3vVwSHfP5ZhauY3ckufzvbojtNbhBfGScIJs91PVIVm1b5XMzCp8v22y39lu
         UXwqjoX7vxC3hdHtTOK+zv8eLsuJn9um97SPLEFd792iIkPZODBIyv7HeXN73t+Nahc2
         zbzQ==
X-Gm-Message-State: AOAM532X7rt+iCZUrKYxk2O2eq0MD8jNUQFudQyktxbm0b2Y4M1Sl9hj
        UAwUk/mnV7SNiYkgYQzjUo3LMgWoRAiJ7Q==
X-Google-Smtp-Source: ABdhPJypBD7o9xuKglxcOPBFu3Ac2Z1GqUqRqrqpmpcmJjFId+/6MlGcfQVm5oPAgAGOBzPrHm9rlA==
X-Received: by 2002:a62:fb19:: with SMTP id x25mr8321417pfm.58.1644521769144;
        Thu, 10 Feb 2022 11:36:09 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n22sm25080018pfu.77.2022.02.10.11.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 11:36:08 -0800 (PST)
Date:   Thu, 10 Feb 2022 19:36:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zixuan Wang <zxwang42@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, thuth@redhat.com,
        Andrew Jones <drjones@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Zixuan Wang <zixuanwang@google.com>,
        kvm list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename
 --target-efi
Message-ID: <YgVpJDIfUVzVvFdx@google.com>
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
 <YgVKmjBnAjITQcm+@google.com>
 <YgVPPCTJG7UFRkhQ@monolith.localdoman>
 <CAEDJ5ZSR=rw_ALjBcLgeVz9H6TS67eWvZW2SvGTJV468WjgyKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEDJ5ZSR=rw_ALjBcLgeVz9H6TS67eWvZW2SvGTJV468WjgyKw@mail.gmail.com>
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

On Thu, Feb 10, 2022, Zixuan Wang wrote:
> On Thu, Feb 10, 2022 at 11:05 AM Alexandru Elisei
> <alexandru.elisei@arm.com> wrote:
> >
> > Hi,
> >
> > On Thu, Feb 10, 2022 at 05:25:46PM +0000, Sean Christopherson wrote:
> > > On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> > > > I renamed --target-efi to --efi-payload in the last patch because I felt it
> > > > looked rather confusing to do ./configure --target=qemu --target-efi when
> > > > configuring the tests. If the rename is not acceptable, I can think of a
> > > > few other options:
> > >
> > > I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
> > > seems like it would be sufficient.
> > >
> > > > 1. Rename --target to --vmm. That was actually the original name for the
> > > > option, but I changed it because I thought --target was more generic and
> > > > that --target=efi would be the way going forward to compile kvm-unit-tests
> > > > to run as an EFI payload. I realize now that separating the VMM from
> > > > compiling kvm-unit-tests to run as an EFI payload is better, as there can
> > > > be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
> > > > a test runner, so I think the impact on users should be minimal.
> > >
> > > Again irrespective of --target-efi, I think --target for the VMM is a potentially
> > > confusing name.  Target Triplet[*] and --target have specific meaning for the
> > > compiler, usurping that for something similar but slightly different is odd.
> >
> > Wouldn't that mean that --target-efi is equally confusing? Do you have
> > suggestions for other names?
> 
> How about --config-efi for configure, and CONFIG_EFI for source code?
> I thought about this name when I was developing the initial patch, and
> Varad also proposed similar names in his initial patch series [1]:
> --efi and CONFIG_EFI.

I don't mind CONFIG_EFI for the source, that provides a nice hint that it's a
configure option and is familiar for kernel developers.  But for the actually
option, why require more typing?  I really don't see any benefit of --config-efi
over --efi.
