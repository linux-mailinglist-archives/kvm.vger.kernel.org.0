Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCF44B1655
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 20:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbiBJTbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 14:31:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiBJTbd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 14:31:33 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EE5E56
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 11:31:33 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id o2so12411829lfd.1
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 11:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YV7m43lW01+30L4cJfH2Iw5JSUBAH1SM73s9lnsoK9w=;
        b=gbWeYOhQiRnb8jPf5HKGRvZVFiNwiCG5pDavy5zRNbcS57wGnNDd0yC/ZCOnk3dBo8
         ekHOdjb6l33u41dM3bM/NlssICsWUEXWG8LoBqtJscR5zsQqxdbc33JyRj8/cy4nO8Bc
         xBM8OFMuTrirsHKn1QhHi5jOoi51nBnQsk++Q1qqSnBEOISJEPgw1/Of9eM9pUEJiapc
         jDp5kXnLRTysjPsIM5BJotH4tbsQSBcK4XVHWfEnXkFMNExPvzz/xR6Su2MSSv/L0Dkb
         a9PnCFTEBccE8QxIa3ymNWv9Eutv0lyJlqlUhUmnH08aauiERZHsOMg6eelMRHlQghWi
         zqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YV7m43lW01+30L4cJfH2Iw5JSUBAH1SM73s9lnsoK9w=;
        b=tY+j54AHSvp0rJYJYRz4u32QMyNSdFVHaecXeyJE9xVzmfGBV2HFhTk4VrKGR15kMx
         6mAJXWEUn9ZTvf5nxmOsbrO/UwwmKHqyyCbP5B5LYvfc31tm7xBIVip249/bE7vvahwo
         uZ4/96UcbohAuhvQiLqQk7gjURQZXfT97NHIqf2SKAYrVpVS1BGqdK2wTw1Ir2sV1lKg
         FwMWJkhaQT8YlkRhHpZfQTcdZPUfQdc9CBaFIzCxzu7akDXAGAZuC1SlyPBLIFWuGSs+
         iYCU2xxQMBVzYUuHL+6I2IffCGxa9c97D7st453LxWLNS/S0hy/KA40aTGchj4Jf1G54
         pyIw==
X-Gm-Message-State: AOAM5311/tJcI9HmNASW4DivZKHZFdEKMCX88b4LCUTIS5Jih4zULDUt
        UU5w87uD/EPOC+MD+eWMp/ztGy/zGJHm4RFnW7Q=
X-Google-Smtp-Source: ABdhPJyx6CUZeqEnp1CPbqshcBbV3uSIOGIIpzCGWxHlngrSN7TAikAv4oHo3jE88DLmxSgPvJjep6TxvDJT2UJ8E48=
X-Received: by 2002:ac2:44ad:: with SMTP id c13mr6247450lfm.339.1644521491545;
 Thu, 10 Feb 2022 11:31:31 -0800 (PST)
MIME-Version: 1.0
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
 <YgVKmjBnAjITQcm+@google.com> <YgVPPCTJG7UFRkhQ@monolith.localdoman>
In-Reply-To: <YgVPPCTJG7UFRkhQ@monolith.localdoman>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Thu, 10 Feb 2022 11:30:55 -0800
Message-ID: <CAEDJ5ZSR=rw_ALjBcLgeVz9H6TS67eWvZW2SvGTJV468WjgyKw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename --target-efi
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, thuth@redhat.com,
        Andrew Jones <drjones@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Zixuan Wang <zixuanwang@google.com>,
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

On Thu, Feb 10, 2022 at 11:05 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On Thu, Feb 10, 2022 at 05:25:46PM +0000, Sean Christopherson wrote:
> > On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> > > I renamed --target-efi to --efi-payload in the last patch because I felt it
> > > looked rather confusing to do ./configure --target=qemu --target-efi when
> > > configuring the tests. If the rename is not acceptable, I can think of a
> > > few other options:
> >
> > I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
> > seems like it would be sufficient.
> >
> > > 1. Rename --target to --vmm. That was actually the original name for the
> > > option, but I changed it because I thought --target was more generic and
> > > that --target=efi would be the way going forward to compile kvm-unit-tests
> > > to run as an EFI payload. I realize now that separating the VMM from
> > > compiling kvm-unit-tests to run as an EFI payload is better, as there can
> > > be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
> > > a test runner, so I think the impact on users should be minimal.
> >
> > Again irrespective of --target-efi, I think --target for the VMM is a potentially
> > confusing name.  Target Triplet[*] and --target have specific meaning for the
> > compiler, usurping that for something similar but slightly different is odd.
>
> Wouldn't that mean that --target-efi is equally confusing? Do you have
> suggestions for other names?

How about --config-efi for configure, and CONFIG_EFI for source code?
I thought about this name when I was developing the initial patch, and
Varad also proposed similar names in his initial patch series [1]:
--efi and CONFIG_EFI.

[1] https://lore.kernel.org/kvm/20210819113400.26516-1-varad.gautam@suse.com/
