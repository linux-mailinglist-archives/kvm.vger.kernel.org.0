Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31FA4355D8
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 00:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhJTWaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 18:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhJTWaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 18:30:46 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451A7C06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 15:28:31 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id s19so693312ljj.11
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 15:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=student.cerritos.edu; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=BJl7dpln3AcyGfdo8s9aCyuJo+l+Ftzhtn05dlhzr20=;
        b=HxaaR54QJJ4p/nMYCQlGUMDVs2vnNHDVVBmW6B+HzqyGvDo2Qb2FnRiXd0KCSonf+h
         AemqD5qO1AdmQW9Iv8RXt1mwCKZssZPFYi3jA5W6KD1ctO5fp9E059q4g0I4XyNXQPRR
         Lco7ivLyA5nywOUjHHQSpZTa+cL8ID3i3G9iM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=BJl7dpln3AcyGfdo8s9aCyuJo+l+Ftzhtn05dlhzr20=;
        b=sJhVgvKAzVmnPnEiACYV7pifGWdJbBWikijuLc4SepxRpnxbsZ/Fot9MF6np8HRqXk
         57vkTRfO6pnSqRem7QCZvYn9JCdbU5l6+njaMF1JzfmGwJIVwyfMS9icikbgUmyfCaRd
         HFmWoVVmjKhVw6k6OA2SZua4/hS3/ROgceTxVkSrsMJGC/kAemWrVankoPiazqkQV8wf
         K0pgcWhGRbcXFH5qMIl/PJ1aMkZpxea1sbmdTWyB5Dm5ZKj1Dul2gVN01pZreOhSs+vC
         G6V4EqiZq2VgrODLoz6IkN3KDk0VB8tJjyaCNdTkf64En1lhHpEGAeK4i7tR3sYoTJGB
         86kw==
X-Gm-Message-State: AOAM533HFw2JJ5avJ/X7qovHnKsO7rXPSByGFgtel1BJ5YRSJfd0Zo/3
        w6TAsErRWyCxp60nElxY7G0A9Lo3jGsrxjL5vTcX0PFdI3I=
X-Google-Smtp-Source: ABdhPJwWkERm2ZLHm6XZDCVrfnXvjMESr0mLG02Aiu0jMcfnZ6TigqxETN3Uvog2jLGdf54CPs5fKIQnOjkeJwTxBZY=
X-Received: by 2002:a2e:3005:: with SMTP id w5mr1786677ljw.228.1634768909470;
 Wed, 20 Oct 2021 15:28:29 -0700 (PDT)
MIME-Version: 1.0
From:   Amy Parker <apark0006@student.cerritos.edu>
Date:   Wed, 20 Oct 2021 15:28:18 -0700
Message-ID: <CAPOgqxEuo6VFAUWc5os6N1iPqh-mQrSg6d09Tj5vy82Gw=v-fg@mail.gmail.com>
Subject: Addition of a staging subdirectory to virt/ for in-development features
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello all.

Has the idea of having a staging subdirectory for KVM been proposed
before? It could become a buffer place for KVM features currently in
development/not production ready, but that should be able to be
conditionally included into the kernel. With a staging directory,
these features would be divorced from KVM mainline, but would be able
to be rolled out promptly to users while they are being refined.

Any thoughts on this?

    - amyip
