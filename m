Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4298C6D8D76
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 04:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbjDFCcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 22:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbjDFCb7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 22:31:59 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6CD7DB2
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 19:31:57 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id n15-20020a170902f60f00b001a273a4a685so13573550plg.15
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 19:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680748317;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jXFyIio5oyJDktFtEG2swHUhWdrIkLxnu4pQTImJmRA=;
        b=EVJj3JFAc5N8gvcY+lOt7oGdr2z16jQg58oQcc2yDyfF+wm8yzzqqU6YD5cpUb5PMX
         582DzLXlqKJJAWbuZwAdqBLsCqf1Z1FQFsF5Xs9u6cFL9GaSM76LD0cgAy5KjCQHqRya
         UiZ9qxdgkHx8ul3e1eTVQ0ohyTVDpJ8oE/4vjXQQQlwgErydbSMDAt7bWc/wpKGKTMqZ
         HTdKD/xsLRaas/1agA+e6PD6ZFYYeixg52sJhrMgRrtZLoP5OmKbCma/E+HKiBAGdJWV
         CFtwKavYro7M9aXkTUg4FO6TOttkl9sVCOYkVDWTo47843JRPFBt391HJy+UwpAq5awV
         D3vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680748317;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jXFyIio5oyJDktFtEG2swHUhWdrIkLxnu4pQTImJmRA=;
        b=i8VTpyD/T2GWaW3woC+DwYZqJKOIVvS4bVqAUbkQkQA0fcUXRlPFmMxLe/KBVB1nMa
         bU7GYydaSBF/MBWGuCR5M5YYyiQh+PmdczWAG8pMhth0RjPjsibWBR+qbiZsh+J16W2S
         P5LE9sUvUcDnadVsrHm96daB718f7yFGS+k627RJcm2AdFDDfCeoYgjBhn8kE8KojP3b
         n6wFVc0zkj5+bSoLN6QUgKb5IBGZjKhZO5aPAn7xIVj4c+LWDpd/2HqgK+YH6DO5ixBj
         JPWodQ9QWNOos4FSAL1uG5L1JdYnK0AxpsJJYUo3cgxmd5u1XHuQvpvbS1qHuqNUf26W
         02Kw==
X-Gm-Message-State: AAQBX9flymSUSZ1zkpTDtC7dhvWSoWDkVOrRopgAywg3v3u4Agb7iu+6
        WgWDSdCw3I2Zev5gTR7OGkMCIOg1kQM=
X-Google-Smtp-Source: AKy350bY+l4KEEON8sjvvnsitZbl7oEG2jxsABUGmiwFWTT2FrBBv3lqnLjYLKgCryYIllpmcJta410dgsA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fd8b:b0:23d:3944:f008 with SMTP id
 cx11-20020a17090afd8b00b0023d3944f008mr3117760pjb.7.1680748317045; Wed, 05
 Apr 2023 19:31:57 -0700 (PDT)
Date:   Wed, 5 Apr 2023 19:31:55 -0700
In-Reply-To: <CAEm4hYV-M1sbboOon_O=eRsk6LEgwog+oUKBpdnAkchs=KMWEw@mail.gmail.com>
Mime-Version: 1.0
References: <20230403095200.1391782-1-korantwork@gmail.com>
 <168063175075.174995.217166777153935864.b4-ty@google.com> <CAEm4hYV-M1sbboOon_O=eRsk6LEgwog+oUKBpdnAkchs=KMWEw@mail.gmail.com>
Message-ID: <ZC4vG09or7AfUA7L@google.com>
Subject: Re: [PATCH REBASED] KVM: x86: SVM: Fix one redefine issue about VMCB_AVIC_APIC_BAR_MASK
From:   Sean Christopherson <seanjc@google.com>
To:     Xinghui Li <korantwork@gmail.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        mlevitsk@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        kvm@vger.kernel.org, Xinghui Li <korantli@tencent.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 06, 2023, Xinghui Li wrote:
> On Wed, Apr 5, 2023 at 7:44=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Mon, 03 Apr 2023 17:52:00 +0800, korantwork@gmail.com wrote:
> > > VMCB_AVIC_APIC_BAR_MASK is defined twice with the same value in svm.h=
,
> > > which is meaningless. Delete the duplicate one.
> >
> > Applied to kvm-x86 svm, thanks!
> >
> > In the future, please don't use "PATCH REBASED".  If you're sending a n=
ew
> > version of a patch that's been rebased, then the revision number needs =
to be
> > bumped.  The fact that the only change is that the patch was rebased is=
n't
> > relevant as far as versioning is concerned, it's still a new version.  =
The
> > cover letter and/or ignored part of the patch is where the delta betwee=
n
> > versions should be captured.
> >
> > And in this case, there really was no need to send a new version, the o=
riginal
> > patch still applies cleanly.  I suspect that the REBASED version was se=
nt as a
> > form of a ping, which again is not the right way to ping a patch/series=
.  If you
> > want to ping, please reply to the original patch.  Unnecessarily sendin=
g new
> > versions means more patches to sort through, i.e. makes maintainers liv=
es harder,
> > not easier.
> >
> Firstly, I'm so so SORRY to burden you in this way.
> I found the last patch can't be am directly, so I send a new patch
> with the last rebased code.

Ah, try `git am -3`, i.e. tell git to try a 3-way merge between the patch, =
its
base, and what you're applying on.  I'm sure there are situations where a 3=
-way
merge is unwanted, e.g. maybe if someone needs to be super paranoid?  But f=
or me
personally at least, I pretty much always run am with -3.

> I used to believe that this would alleviate your burden, but
> unfortunately, it had the opposite effect.
> Again, sorry for my wrong operation.

No worries, it's not a big deal.  My lengthy response was purely to help av=
oid
similar mistakes in the future.

Thanks!
