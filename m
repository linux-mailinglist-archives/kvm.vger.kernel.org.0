Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16BF852C1A1
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241127AbiERRaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 13:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241081AbiERRaZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 13:30:25 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D0620EE27
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:30:23 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id s18-20020a056830149200b006063fef3e17so1812951otq.12
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ht+o1v4WgCfvjgo/qhN8PI77GOqAL6Usil1s/qDlKEc=;
        b=qslx4Kxe0MdKnxcQfQXMnUdOcTZiGV44XcLHRsfKASQZBciW61JsS57gs187YXqaNL
         qx58MClubyqqH6idmOyeB1EpKl/ZcxC6stgTJ6OUBPupMvqu1zW07lxrOZUkiNfC7kM5
         fG/x6B0U3qzhtCG+yz0KRcxKKW1TDlXcKhMGymm4eNpWaK5M8OBetNEp/AVn7G2MNNZs
         lDZo/Cg9Dk087rQubyzCJBO0jKks4aE99hAQ0GUs6uYZdAODtf0673MZx0J65oTDY/Jn
         n8gHsZ7zWsHUigSw6VNhbvo3cApdxHixf33ml5cZb6JGliQJPhLGCFeggUtneI0WioNk
         ywnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ht+o1v4WgCfvjgo/qhN8PI77GOqAL6Usil1s/qDlKEc=;
        b=Pc3TM/ajtHCD34syq48HDajmsXheAhRsOeyvtsWnq+8FUD06kcW0KSdTcDeBEgMw7p
         Q1yMZwlcMnSLCiz1bYCaLOv2m0fXPS1oUD9L4/fH5YXA6nY1Y8YsZua6BaS2AV6onK/4
         P0eTCEvR/nV4Q9Imhj12O1MB3GJjbnpbclCGrnwac+5mjoL+o0Zvb+IuHkFZos5f2+62
         jJq7PElw6TSv8Hju/iX4Pgpuzv8keOJMqVtmdV3upvuEQccvqne+AFHZJsb7YMrZUHtg
         eGc8g2GviIaxrmOMh///V0zQii36uT76thV+nqBZ1Bs5HN49smlVa10WEQtZWkhVoYUF
         6B8w==
X-Gm-Message-State: AOAM533BpbNWn8ci856UE0ii6V0Jpgf1S+ymN6XreHGuknANveE59ohL
        QHlVynNwXO9xWrJ0dgY4fLYn3DjwOY0sq9UlIz1AU9m/Spo=
X-Google-Smtp-Source: ABdhPJwNd30qHng5tnxQBG13Zw0WMGkrVHJ56vVtIp4LvthS2FZNkDqgTzgL2Xj6BMYwFI0eBetIgotVmeXRtHAS0CI=
X-Received: by 2002:a05:6830:1c65:b0:606:3cc:862 with SMTP id
 s5-20020a0568301c6500b0060603cc0862mr311027otg.75.1652895023004; Wed, 18 May
 2022 10:30:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAPUGS=oTTzn+HjXMdSK7jsysCagfipmnj25ofNFKD03rq=3Brw@mail.gmail.com>
In-Reply-To: <CAPUGS=oTTzn+HjXMdSK7jsysCagfipmnj25ofNFKD03rq=3Brw@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 18 May 2022 10:30:11 -0700
Message-ID: <CALMp9eQbpxHpGXJjYesH=SJu_LiCmCVTXYwV+w7YfdGpfc_Yzw@mail.gmail.com>
Subject: Re: A really weird guest crash, that ONLY happens on KVM, and ONLY on
 6th gen+ Intel Core CPU's
To:     Brian Cowan <brcowan@gmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, May 18, 2022 at 10:14 AM Brian Cowan <brcowan@gmail.com> wrote:
>
> Hi all, looking for hints on a wild crash.
>
> The company I work for has a kernel driver used to literally make a db
> query result look like a filesystem=E2=80=A6 The =E2=80=9Cdatabase=E2=80=
=9D in question being
> a proprietary SCM repository=E2=80=A6 (ClearCase, for those who have been
> around forever=E2=80=A6 Like me=E2=80=A6)
>
> We have a crash on mounting the remote repository ONE way (ClearCase
> =E2=80=9CAutomatic views=E2=80=9D) but not another (ClearCase =E2=80=9CDy=
namic views=E2=80=9D) where
> both use the same kernel driver=E2=80=A6 The guest OS is RHEL 7.8, not
> registered with RH (since the VM is only supposed to last a couple of
> days.) The host OS is Ubuntu 20.04.2 LTS, though that does not seem to
> matter.
>
> The wild part is that this only happens when the ClearCase host is a
> KVM guest, and only on 6th-generation or newer . It does NOT happen
> on:
> * VMWare Virtual machines configured identically
> * VirtualBox Virtual machines Configured identically
> * 2nd generation intel core hosts running the same KVM release.
> (because OF COURSE my office "secondary desktop" host is ancient...
> * A 4th generation I7 host running Ubuntu 22.04 and that version=E2=80=99=
s
> default KVM. (Because I am a laptop packrat. That laptop had been
> sitting on a bookshelf for 3+ years and I went "what if...")
>
> If I edit the KVM configuration and change the =E2=80=9Cmirror host CPU=
=E2=80=9D
> option to use the 2nd or 4th generation CPU options, the crash stops
> happening=E2=80=A6 If this was happening on physical machines, the VM cra=
sh
> would make sense, but it's literally a hypervisor-specific crash.
>
> Any hints, tips, or comments would be most appreciated... Never
> thought I'd be trying to debug kernel/hypervisor interactions, but
> here I am...

Guest crash or hypervisor crash? If the former, can you provide the
guest's console output?
