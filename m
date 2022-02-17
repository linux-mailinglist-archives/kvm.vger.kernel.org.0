Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DD34BA5C2
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 17:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238449AbiBQQ1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 11:27:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242893AbiBQQ1H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 11:27:07 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D477945AE7
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 08:26:51 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id l19so122179pfu.2
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 08:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lWyN4iF200uGQEh1jVp3II5oN6ZPLGJyhcB1z6wgp6Y=;
        b=F30nE9kCMcaxxegESCi4Nt90sw16wrFCXYNkXSA60blvuhETYeYWv3RqQZgp3jYZw2
         rMWuhP/Xui5FqlJVc2gix49xrBaDWlj+Zsb8U9jIO+Xk3pS7k+zJfsNYFUGoxpivb8sD
         EF2FuL0zIWNFLBJL6njtRNB3U6IdQLeo6/YVoFtBluYlkHAi8FcyZ7xyf/RpESwZv/Zx
         ttc43hTe1sI1YQXtAQM+dmkpLKLBqdUdTDE+rQH9yIRWju0MuuXiEPt+uPZTqfwUs6DR
         FLswwz2waz1sDRda1Wc3IWzLRKYfgQ3WLN52pX0pVgoGCC4rbx2WdZn+AMvB76sOownm
         EIIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lWyN4iF200uGQEh1jVp3II5oN6ZPLGJyhcB1z6wgp6Y=;
        b=zxtX27XZtZxMAb9LVh2UCRuC7ZHxa0ArNv6YxP18H/N+ym42ZGn3JeTjgIsktvHGrd
         V9KpZ4miQL4oVQNv0g78dE++rE9ohTz1LsrO+T90L7BzqC3x/B00aOQY4fA4aCDaGnFH
         8ZZ5glExKGWkSsfm3yXW70Yx3Ym3v1cwn19aKMjsb3hs178CYmhcxKW/fbxW4ROqhwyX
         NQN0AsTdEIS3TJYsPbaOoKGmjKVHJfhjwF7eZMZbxvhOmHd2J5/wGVBuMoKjKQt6+/w3
         FogS4hcbTxDNjkBiGFzAJs72yyKv6CT4kxPEi5uhjk3Xy/TLLcVZsn1X4pMGE4W/dRsE
         Erew==
X-Gm-Message-State: AOAM5310ghYR16LvujF4UJH9uiHW5JEJs6Qsgn8QSU1F1tkSltNCbsBp
        924ePhmv1lvcvkzkSfRX6IMPKp6jvkHSlVsVkmY=
X-Google-Smtp-Source: ABdhPJzLCINJi1zhAl9JT+saqWcYE97hQnPGMpev1RVPeLi8bUbs6ddZH84a7kH1gqs+ebAxkKVMCp0IFMqt3ftoe6w=
X-Received: by 2002:a63:6cc9:0:b0:372:e69d:60f7 with SMTP id
 h192-20020a636cc9000000b00372e69d60f7mr2991233pgc.608.1645115211442; Thu, 17
 Feb 2022 08:26:51 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <CABBoX7PcqRFHDm0LCwWOwmYmOwH2x70pM-3OyxfDXD1sE_fHrw@mail.gmail.com>
In-Reply-To: <CABBoX7PcqRFHDm0LCwWOwmYmOwH2x70pM-3OyxfDXD1sE_fHrw@mail.gmail.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Thu, 17 Feb 2022 16:26:40 +0000
Message-ID: <CAJSP0QUqqiHQi2VWdDTvurK8oJL7s7Ae5G3=iPzUhcOtM0q_TA@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     Alice Frosi <afrosi@redhat.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Hannes Reinecke <hare@suse.de>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Alex Agache <aagch@amazon.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Sergio Lopez Pascual <slp@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Feb 2022 at 07:08, Alice Frosi <afrosi@redhat.com> wrote:
>
> On Fri, Jan 28, 2022 at 6:04 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
> >
> > Dear QEMU, KVM, and rust-vmm communities,
> > QEMU will apply for Google Summer of Code 2022
> > (https://summerofcode.withgoogle.com/) and has been accepted into
> > Outreachy May-August 2022 (https://www.outreachy.org/). You can now
> > submit internship project ideas for QEMU, KVM, and rust-vmm!
> >
> > If you have experience contributing to QEMU, KVM, or rust-vmm you can
> > be a mentor. It's a great way to give back and you get to work with
> > people who are just starting out in open source.
> >
> > Please reply to this email by February 21st with your project ideas.
> >
> > Good project ideas are suitable for remote work by a competent
> > programmer who is not yet familiar with the codebase. In
> > addition, they are:
> > - Well-defined - the scope is clear
> > - Self-contained - there are few dependencies
> > - Uncontroversial - they are acceptable to the community
> > - Incremental - they produce deliverables along the way
> >
> > Feel free to post ideas even if you are unable to mentor the project.
> > It doesn't hurt to share the idea!
> >
>
> I'd like to propose this idea:
>
> Title: Create encrypted storage using VM-based container runtimes
>
> Cryptsetup requires root privileges in order to be able to encrypt
> storage with luks. However, privileged containers are generally
> discouraged for security reasons. A possible solution to avoid extra
> privileges is using VM-based container runtimes (e.g crun with libkrun
> or kata-containers) and running inside the Virtual Machine the tools
> for the storage encryption.
>
> This internship focus on a PoC for integrating and extending crun with
> libkrun in order to be able to create encrypted storage. The initial
> step will focus on creating encrypted images to demonstrate the
> feasibility and the necessary changes in the stack. If the timeframe
> allows it, an interesting follow-up of the first step is the
> encryption of persistent storage using block-based PVCs.
>
> Language: C, rust, golang
> Skills: containers and virtualization would be a big plus
> I won't put a level but the intern needs to be willing to dig into
> different source codes like crun (written in C), libkrun (written in
> Rust) and possibly podman or other kubernetes/containers projects
> (written in go)
> Mentor: Alice Frosi, Co-mentor: Sergio Lopez Pascual
>
> Let me know if the idea sounds feasible to you!
Thanks, I have added the idea:
https://wiki.qemu.org/Google_Summer_of_Code_2022#Create_encrypted_storage_using_VM-based_container_runtimes

Stefan
