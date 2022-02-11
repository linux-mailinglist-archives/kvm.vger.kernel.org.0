Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0294B2A22
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 17:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351417AbiBKQUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 11:20:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344377AbiBKQUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 11:20:01 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBD12E5
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 08:19:59 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y17so5061995plg.7
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 08:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nYPHl8dMIoFQJMeCg2hKGumzp/ft6Ah/5yUNeWO6Yuk=;
        b=Y+98Mn0k9Y4v5fP2XlMkV7VUllvqZMH6r75Ele8HG0lwKDSLpw93pyGD2jvCKXEhx4
         r/c0TNEvuYZiPQr5+hcFENrz+zuykRqvW8/Bn3kkVN2oX/v3g+WL/O+BFaZqiPUONxpU
         WNHMbQ+cewH98XHiTnddVg8QD8XAiE39WXdq96oNUOALzHWshbGxt1G4pIxsdZtvkmzZ
         gvp8vpmJRvu7sF2XJYvYhDxOqIPYOxxiW8+OVR8tbbZaQfnEttD6jjwvrS1dVyd1lDy4
         PK1fq62BQdSPMUJVgAX74mq8HoUGexfHrT3JhHVodyyiQun4yb3e3KheDvDFOchT7Pgr
         pQ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nYPHl8dMIoFQJMeCg2hKGumzp/ft6Ah/5yUNeWO6Yuk=;
        b=AgCn6WrYwFw7KduEp8krobh/Cxjfv1iJQMGAPRqhkkzTvvmTze0stcyEckqbbRYes4
         4qYfdi59RG4PXNmvX4gJ65RkISE6ME6tA+Jq4TQKYsDO4I0v0bv2RmXTrIdlDgIJ6txr
         iocSc2TmF7PpcRHy4UzqFe+zTx9IU+y1XEwjO49or2aCNNb+nEu6QmWIvsaJmNLT3YUO
         aB1hPl+HoHks8eFNv4lCkZbC2z1ZseLXUAPj3mIYEJh05QrrIsta9w+OeGfBOJvuYgWk
         rtADFbYL2MHcqFJcPJr6pI3qsM7W1d8/4jE6gEV8aqSdei6zbYtC9sOqOGx1nyKe10G9
         lEqg==
X-Gm-Message-State: AOAM530+R3eywkQoGl1LMLcKbPmyznTZ78ZWOH1OpNfbwMZUdRhEWW6x
        kFZ1XnmvSQ8io2H9m/lUgQlg6zNYMWG3PQ==
X-Google-Smtp-Source: ABdhPJxKLUlNFffoMbGq0cVYW6M/KUZ85oWXF/q9TTbCO0SlemFdL/UaiyRqxIcvu8L3rGQKk0XMZw==
X-Received: by 2002:a17:902:9346:: with SMTP id g6mr2363751plp.156.1644596399289;
        Fri, 11 Feb 2022 08:19:59 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 3sm5448066pjk.29.2022.02.11.08.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 08:19:58 -0800 (PST)
Date:   Fri, 11 Feb 2022 16:19:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Zixuan Wang <zxwang42@gmail.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename
 --target-efi
Message-ID: <YgaMqwbWts3vQ6fD@google.com>
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
 <YgVKmjBnAjITQcm+@google.com>
 <YgVPPCTJG7UFRkhQ@monolith.localdoman>
 <CAEDJ5ZSR=rw_ALjBcLgeVz9H6TS67eWvZW2SvGTJV468WjgyKw@mail.gmail.com>
 <YgVpJDIfUVzVvFdx@google.com>
 <CAEDJ5ZRkuCbmPzZXz0x2XUXqjKoi+O+Uq_SNkNW_We2mSv4aRg@mail.gmail.com>
 <f326daff-8384-4666-fc5e-6b7b509f6fe8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f326daff-8384-4666-fc5e-6b7b509f6fe8@redhat.com>
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

On Fri, Feb 11, 2022, Thomas Huth wrote:
> On 10/02/2022 20.48, Zixuan Wang wrote:
> > On Thu, Feb 10, 2022 at 11:36 AM Sean Christopherson <seanjc@google.com> wrote:
> > > 
> > > On Thu, Feb 10, 2022, Zixuan Wang wrote:
> > > > On Thu, Feb 10, 2022 at 11:05 AM Alexandru Elisei
> > > > <alexandru.elisei@arm.com> wrote:
> > > > > 
> > > > > Hi,
> > > > > 
> > > > > On Thu, Feb 10, 2022 at 05:25:46PM +0000, Sean Christopherson wrote:
> > > > > > On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> > > > > > > I renamed --target-efi to --efi-payload in the last patch because I felt it
> > > > > > > looked rather confusing to do ./configure --target=qemu --target-efi when
> > > > > > > configuring the tests. If the rename is not acceptable, I can think of a
> > > > > > > few other options:
> > > > > > 
> > > > > > I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
> > > > > > seems like it would be sufficient.
> > > > > > 
> > > > > > > 1. Rename --target to --vmm. That was actually the original name for the
> > > > > > > option, but I changed it because I thought --target was more generic and
> > > > > > > that --target=efi would be the way going forward to compile kvm-unit-tests
> > > > > > > to run as an EFI payload. I realize now that separating the VMM from
> > > > > > > compiling kvm-unit-tests to run as an EFI payload is better, as there can
> > > > > > > be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
> > > > > > > a test runner, so I think the impact on users should be minimal.
> > > > > > 
> > > > > > Again irrespective of --target-efi, I think --target for the VMM is a potentially
> > > > > > confusing name.  Target Triplet[*] and --target have specific meaning for the
> > > > > > compiler, usurping that for something similar but slightly different is odd.
> > > > > 
> > > > > Wouldn't that mean that --target-efi is equally confusing? Do you have
> > > > > suggestions for other names?
> > > > 
> > > > How about --config-efi for configure, and CONFIG_EFI for source code?
> > > > I thought about this name when I was developing the initial patch, and
> > > > Varad also proposed similar names in his initial patch series [1]:
> > > > --efi and CONFIG_EFI.
> > > 
> > > I don't mind CONFIG_EFI for the source, that provides a nice hint that it's a
> > > configure option and is familiar for kernel developers.  But for the actually
> > > option, why require more typing?  I really don't see any benefit of --config-efi
> > > over --efi.
> > 
> > I agree, --efi looks better than --target-efi or --config-efi.
> 
> <bikeshedding>
> Or maybe --enable-efi ... since configure scripts normally take
> "--enable-..." or "--disable-..." parameters for stuff like this?
> </bikeshedding>

I don't hate it :-)  It'll also future-proof things if we ever make UEFI the
default for x86.
