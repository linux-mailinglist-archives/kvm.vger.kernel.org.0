Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830F17418B0
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 21:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjF1THe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 15:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbjF1THW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 15:07:22 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC891FE8
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 12:07:20 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c0d62f4487cso68601276.0
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 12:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687979240; x=1690571240;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BAxWPNxnP2C7EaTzAlUcr9iJEqOjk7+/IkD7ZQIE/lk=;
        b=gkG4j6zbPwAVApY1tZWeYq1bI0uAKr9gsJtpo4Lm7Mher6CQcKih8UmuddpGkrenjr
         TEFjoR9SYfWN0hnOZLiChZGGCzJeoNhh011H7sjOzBoy9sCbn851d3fyML9NaQ6YdYlQ
         ow2rAKxjn9SwJGtwXpLGAl5uXj88bJQtkPbx5raqc+W/kBaRzWJEqCslIrzWzO5FFClk
         TiS8KuWCBcidHTsmkAe7UdoTwCJ9V8C4gRAf71N7Rxq3OoMvxE9ERsEFaHilS+snFAFk
         e8YtbgLByzYSpYgMBuBE9H6gdGJkBVuO90JpMmSMTMAiXfaqlR2o8MBz22vmi72zIKvp
         cU8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687979240; x=1690571240;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BAxWPNxnP2C7EaTzAlUcr9iJEqOjk7+/IkD7ZQIE/lk=;
        b=lENevZsEf26dhGGFFXPn014R1X8WZtK4nVo5sMofI1P9qUN3eUjfcZsIj6MQ0gyk0k
         NTRFs3D2TfzSiHlPORygptSQnk+HuKHINY+AeO7QIAI//dVrcmcCpQJeEbXpe4fq3G4Y
         X/iC0AVHwkX0rxda2YsNZWps3rrJg33kpwYCGw3/9dVgu3VbQsqCCSelaA2gGlXJPhqo
         E5W9OmSPH5gSIjYCCZpGJPWZg8qz10ADpj4WN4112hGfkXlvF+Fp8wHsBhEz+aNJOhU7
         9QofTPqrK2TVVpbMSyH2MIuKFXd7JaOm1ySJ/oqqwev7AgITx3kzjU8aQYdzxb5lFViB
         bbBg==
X-Gm-Message-State: AC+VfDxV3ZqVIDE8lJPZ201OOAlp4XOpirsR3sGhgYMngW0cW6uc416M
        4Bvkij0biRNBITH2Vy/6UatgZnKXfQM=
X-Google-Smtp-Source: ACHHUZ60vcS1c1OKlbS0RunamBQIm1CSloKZA3oqTymq1NTw150MJB/vLV1gqI544llRa3AvNLi0aX91l30=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:4f1:b0:c15:cbd1:60d6 with SMTP id
 w17-20020a05690204f100b00c15cbd160d6mr3623657ybs.5.1687979240098; Wed, 28 Jun
 2023 12:07:20 -0700 (PDT)
Date:   Wed, 28 Jun 2023 12:07:18 -0700
In-Reply-To: <ed1914ca-bb4d-78e4-8af-432a5829739@tarent.de>
Mime-Version: 1.0
References: <5142D010.7060303@web.de> <f1afa6c0-cde2-ab8b-ea71-bfa62a45b956@tarent.de>
 <ZJxd8StU25UJKBSk@google.com> <ed1914ca-bb4d-78e4-8af-432a5829739@tarent.de>
Message-ID: <ZJyE5jXfYu2bXeVo@google.com>
Subject: Re: [PATCH] KVM: VMX: Require KVM_SET_TSS_ADDR being called prior to
 running a VCPU
From:   Sean Christopherson <seanjc@google.com>
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023, Thorsten Glaser wrote:
> On Wed, 28 Jun 2023, Sean Christopherson wrote:
> >So long as the VMs you care about don't have issues, the message is comp=
letely
> >benign, and expected since you are running on Nehalem, which doesn't sup=
port
> >unrestricted guest.
>=20
> OK, thanks.
>=20
> Might want to make that more well-known=E2=80=A6 though I don=E2=80=99t h=
ave a
> good idea how.=20

I'm leaning toward deleting the message entirely.  It was placed there 10+ =
years
ago to alert users that they needed to upgrade QEMU.  At this point, if som=
eone
files a bug report against a 10+ year old QEMU build, the very first questi=
on is
going to be if the issue reproduces on a more recent build.  The only possi=
ble
benefit I can think of is for people writing new VMMs from scratch, but any=
 benefit
there is also dubious for a variety of reasons.
