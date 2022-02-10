Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDBA74B168B
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 20:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbiBJTsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 14:48:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiBJTsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 14:48:40 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0366E5F40
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 11:48:41 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id j14so9557131lja.3
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 11:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mp6/zsAuzd6lQaBPLCwcBd2CC2OBncN9PY8Mg62kvT0=;
        b=pwBCi1NjwIEa1M4QRfRcZP6qJhbNCa37epiBEiqNO1eOZSSMj2Ni2Zf2DViQ7slU6R
         Gh91ZuoUvSsRnKLyIRGT8hCU1qr4nO0UlogiZYl9ouFSFCgu/tutAbra1kz1q69Tz7AC
         gHH8S1Rv+jo5cI7Yx3ENQnb1GvsYIGXVoaxmCAsOKlTQBMYioxlnU2xRBVlneAI8/7mM
         3nWg6zJFNErIr70PvEsAOxk+UGpv6iCR+YfI+/49Pqlud3R0SdhBlwA98qcW9w+CK4Uh
         O46at5ccWRzyTB92gztTKDyxPz8//dnIKX2YpN43w6cz4ujr2BXXsbze89UVh5HHJ51e
         Fpfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mp6/zsAuzd6lQaBPLCwcBd2CC2OBncN9PY8Mg62kvT0=;
        b=2fR3M//FqZMIf0dFnEVPrY9Ebo7g1eFn4cphtwdUIOGtZGV/C5/PM30DSQJVQwQYDA
         cyFYVW4NBSR+vBnrB9qs1TMM7NVQtJWtd7w6/fBBL1gjYqX3ooAfLt/XY7GfQx4LYX2I
         SVwaTAcKmKGrRcpxBDdbbjk1Y9EKPTc3wueqZ594JN6H+5zy1EsYAJA6gWZDewYE/3AE
         K0KqT78Fw+ObWfSnO5kynsPXQKVNpHj/6nIR+XqSH6kCQ4QsG3CcfobwjXjcDMjxl0/Z
         nHv81/7J9XZtcrHX6hJYGqrDkyoHqs3QxD6HyZrnx8gekj1dwCdbRw6PavhH8Nj0P8+A
         +Tew==
X-Gm-Message-State: AOAM533MWWr8dpCrDdHkkjVWDyzG66ltcY7UxsvGoMNtR/LVRPAkrEgv
        +q4ZHKcMvc1LfjMJmqARa0ZCY9IzCe6X/iZuh9Q1acU60MU=
X-Google-Smtp-Source: ABdhPJwVhhT91vjuEGyGF679QPPxcZTU0sy8pBOv1n6AzbZRSeIMO0+dfxulP248CdtHbx03SnvyZthnuzdyWqOJMuU=
X-Received: by 2002:a2e:9149:: with SMTP id q9mr3751383ljg.36.1644522519388;
 Thu, 10 Feb 2022 11:48:39 -0800 (PST)
MIME-Version: 1.0
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
 <YgVKmjBnAjITQcm+@google.com> <YgVPPCTJG7UFRkhQ@monolith.localdoman>
 <CAEDJ5ZSR=rw_ALjBcLgeVz9H6TS67eWvZW2SvGTJV468WjgyKw@mail.gmail.com> <YgVpJDIfUVzVvFdx@google.com>
In-Reply-To: <YgVpJDIfUVzVvFdx@google.com>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Thu, 10 Feb 2022 11:48:03 -0800
Message-ID: <CAEDJ5ZRkuCbmPzZXz0x2XUXqjKoi+O+Uq_SNkNW_We2mSv4aRg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename --target-efi
To:     Sean Christopherson <seanjc@google.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, thuth@redhat.com,
        Andrew Jones <drjones@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 10, 2022 at 11:36 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Feb 10, 2022, Zixuan Wang wrote:
> > On Thu, Feb 10, 2022 at 11:05 AM Alexandru Elisei
> > <alexandru.elisei@arm.com> wrote:
> > >
> > > Hi,
> > >
> > > On Thu, Feb 10, 2022 at 05:25:46PM +0000, Sean Christopherson wrote:
> > > > On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> > > > > I renamed --target-efi to --efi-payload in the last patch because I felt it
> > > > > looked rather confusing to do ./configure --target=qemu --target-efi when
> > > > > configuring the tests. If the rename is not acceptable, I can think of a
> > > > > few other options:
> > > >
> > > > I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
> > > > seems like it would be sufficient.
> > > >
> > > > > 1. Rename --target to --vmm. That was actually the original name for the
> > > > > option, but I changed it because I thought --target was more generic and
> > > > > that --target=efi would be the way going forward to compile kvm-unit-tests
> > > > > to run as an EFI payload. I realize now that separating the VMM from
> > > > > compiling kvm-unit-tests to run as an EFI payload is better, as there can
> > > > > be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
> > > > > a test runner, so I think the impact on users should be minimal.
> > > >
> > > > Again irrespective of --target-efi, I think --target for the VMM is a potentially
> > > > confusing name.  Target Triplet[*] and --target have specific meaning for the
> > > > compiler, usurping that for something similar but slightly different is odd.
> > >
> > > Wouldn't that mean that --target-efi is equally confusing? Do you have
> > > suggestions for other names?
> >
> > How about --config-efi for configure, and CONFIG_EFI for source code?
> > I thought about this name when I was developing the initial patch, and
> > Varad also proposed similar names in his initial patch series [1]:
> > --efi and CONFIG_EFI.
>
> I don't mind CONFIG_EFI for the source, that provides a nice hint that it's a
> configure option and is familiar for kernel developers.  But for the actually
> option, why require more typing?  I really don't see any benefit of --config-efi
> over --efi.

I agree, --efi looks better than --target-efi or --config-efi.
