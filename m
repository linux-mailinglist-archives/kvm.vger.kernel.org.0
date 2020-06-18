Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280941FFCE1
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 22:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgFRUpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 16:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbgFRUpb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 16:45:31 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20ED7C06174E
        for <kvm@vger.kernel.org>; Thu, 18 Jun 2020 13:45:31 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id q8so8798620iow.7
        for <kvm@vger.kernel.org>; Thu, 18 Jun 2020 13:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=D6zAGzZWuZa0oFGEmpTbPsGabz2PHS5ZFP1yihEV4W0=;
        b=tX93GRtk6g9eCY23DNba4YjQNsrnV+86KMSHDmeBg3SI1uXt7jjUQzbCszZ3I6W1Tn
         OFeYaVbcP4T9LEt3PU02AMGGwDQ4pls+lya2qMDVBdtMlqyNzh3ARzjygYin74w8778r
         ckqdW/+r4JGbi56r0xCT8w05lkDVoEK0XmaZLVn2NZbUvxv7fsIbQ2COxHBI0igtfOuu
         5JFMbTdyqjy3Fp3yhKxJONRATRLinH/Jzk+i9hwOkr6+HTkZo0PMfxJvnLUk31NQNgnq
         Uk2DjyWYziYl1nsFBiZ1Z/EmxTYdSnXcEx0su7H4wMz0I5Yyi1lNfAkUFWFxo/by23vs
         Veag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=D6zAGzZWuZa0oFGEmpTbPsGabz2PHS5ZFP1yihEV4W0=;
        b=uEIFsjmwtVfNRhEESY2pjlYxirsegwMZHyNyd3WZRBoLtUNql7XMEmyTzbjg9uqFGr
         E7oDU/Qb9P5cO60jx+hnfiH1A12bfoHKvcfEQKZgFWb46LYjcTjnpMrDS/LJi1ColArF
         Xqqp/cCADBwsSpJYUGMMM57dM+apMiAcf+uO8pRKPqCy7icnDXPup9RUCl6MDD0LbY7K
         sXURReZzex9vXe1vFs72eMM8vzbSfNoO0vnUylSNft4p1PkpAdEbbvkyqY2l1FeM4Hty
         ZE6HasxAyWqc+XYdCnVpEkdJwv6nQGC++jHim18kxbUttvL7ovRIoITekYb3fDutrRDZ
         aqdw==
X-Gm-Message-State: AOAM531MuCz5jpXWgAqhxKV+qjFZRgqADi8egP+2+DhVFHlEakurd5b9
        dlL0qycLCyXxTd9GTB2q6Y5Ru0W8xLnCsm93qz/Tzytr
X-Google-Smtp-Source: ABdhPJwfmWVDNFmon2xw1MPXpRDbboB8LsgYxYeq15HCOpQt0WN0fuW7ePBjurBUPkc6YxAiU91OITz6XEoI5zwTpV4=
X-Received: by 2002:a5d:8e19:: with SMTP id e25mr644848iod.36.1592513128040;
 Thu, 18 Jun 2020 13:45:28 -0700 (PDT)
MIME-Version: 1.0
From:   VHPC 20 <vhpc.dist@gmail.com>
Date:   Thu, 18 Jun 2020 22:45:17 +0200
Message-ID: <CAF05tLPGrp5o8DedP8ctkEXxtPngJ7+Ro2p8XbniX0dH22=XMg@mail.gmail.com>
Subject: VHPC Zoom 25th of June Call for Participation: 15th Workshop on
 Virtualization in High-Performance Cloud Computing
To:     kvm@vger.kernel.org, kvm-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We cordially invite you to participate online in the
15th Workshop on Virtualization in High=C2=AD-Performance Cloud Computing  =
(VHPC '20)

Keynote: RedHat on Podman (a Docker alternative) for HPC
Talks include: Google on Autopilot (Google internally used autoscaler)

This year's focus is on:
Orchestration (Kubernetes)
Resource efficiency via auto-scaling (Autopilot / Google)
Containers for HPC (Podman)
Lightweight Virtualization / Unikernels

The Workshop is being held online via Zoom. Participation is free with
registration at
https://us02web.zoom.us/webinar/register/WN_vC5pwmgbQ6ypJEfyQ8nHIg
