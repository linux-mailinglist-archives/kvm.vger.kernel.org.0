Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F53A6E0806
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 09:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjDMHp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 03:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjDMHp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 03:45:26 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACDB8A4B
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 00:45:23 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id b33so10154034ljf.2
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 00:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20221208.gappssmtp.com; s=20221208; t=1681371921; x=1683963921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ROFpaYIgq26cLIkNVEnMozH6cn/rivsqCvSc2ZNZaHk=;
        b=sT853BPAZjADMB9yC1BBJjhv8Np0nLG5ajZbEGvtw4KTKxOss+bTxAD5nVx8fCi8Ci
         z9oPYYEnhQUeMs2XBLUrgcIYiNN51pVQDIcPmPB35/UTbaKUBA38w4xLXnXynxBwmnAq
         lstVjTbzbdxgncTPnZnmg4c87lNxe9TFwDzFh7dXjZr6CWV7R+twSkH9YpDg5aHFeRkw
         GJPR/eGbVRloIzOw12kaXJ1tHGHY5XkcpGza0CaoI4BfrBzDh2J244DyfgP7XstgVB5u
         lqDKaVfeRJsk8UFYK79xNDxwL1SCQWPylh5Eq1PYiCmv9kE4K2II5sep9vreUUTUmxrY
         vQOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681371921; x=1683963921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ROFpaYIgq26cLIkNVEnMozH6cn/rivsqCvSc2ZNZaHk=;
        b=HYNT6ySdgaetTCZiqlbJ42OgF5gJTIM2MQckpTsrLjiM2DtLChj8dD9dD/T838cKI8
         Y/1PVg1hs/YnLJjpbrh3JR1sHx3FKs9tf7RCksnTP7zUEI7/CwKQdfyx0jdpAApeFxhC
         +vAmsMGU6GnB2VGgjMXmxeuG3VO8S6cMcsvOXPokry//7xqeZgOW3QSK92DvxFdcovCm
         BdcJ4xtzR8Kf7GGxuRgmfmIYZBE7rCzU9golfYJuQK1fEi8dl6N+Rv4iqMshcHNFzG1q
         Kp431VxMxgbeQlgu8XE7XkHR+9iNPLto2XyvsZ74dgF6gRikbprR4xjQZOYI0G9Vu3jx
         lqHQ==
X-Gm-Message-State: AAQBX9f2+RnZ4eKTukv0gjwx77dNOluj0Zx3kZo90hCdfV97bw7aj76Z
        2g/9ZwpLhBeEi0iePaL4DmxbboRtwQRzJoLHMoOtOw==
X-Google-Smtp-Source: AKy350bBI4Fp6Ci7UvqsEgEgFGoHSlyFUIgJYynKIcaXzkcGlGr+epkjYXP55Xf+Eq2cFiXHMyEbSrHk6Xv25XlDpwY=
X-Received: by 2002:a2e:808d:0:b0:2a7:9f4c:ce94 with SMTP id
 i13-20020a2e808d000000b002a79f4cce94mr424287ljg.8.1681371921665; Thu, 13 Apr
 2023 00:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230324195029.2410503-1-viktor@daynix.com> <AM0PR04MB4723A8D079076FA56AB45845D48C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230404141501-mutt-send-email-mst@kernel.org> <AM0PR04MB4723AB600C87D77AB486D035D4989@AM0PR04MB4723.eurprd04.prod.outlook.com>
In-Reply-To: <AM0PR04MB4723AB600C87D77AB486D035D4989@AM0PR04MB4723.eurprd04.prod.outlook.com>
From:   Viktor Prutyanov <viktor@daynix.com>
Date:   Thu, 13 Apr 2023 10:45:10 +0300
Message-ID: <CAPv0NP7gms2FMOaysnphYSK=4qgo3GVKPd7pUMxsPS1C6bTj4g@mail.gmail.com>
Subject: Re: [PATCH v6] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yan@daynix.com" <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 13, 2023 at 10:40=E2=80=AFAM Alvaro Karsz
<alvaro.karsz@solid-run.com> wrote:
>
> > Hmm.  So it seems we need to first apply yours then this patch,
> > is that right? Or the other way around? What is the right way to make i=
t not break bisect?
> > Do you mind including this patch with yours in a patchset
> > in the correct order?
>
> Ok, I'll create a patchset.

Thank you!
