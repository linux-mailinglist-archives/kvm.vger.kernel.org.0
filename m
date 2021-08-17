Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F5F3EF602
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 01:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbhHQXLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 19:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhHQXLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 19:11:44 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E08CC061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 16:11:10 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id a13so253220iol.5
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 16:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nSPXvVD5O5V1uAajVcwzQDL8XPPrWHEb/KX0Q3ujGGw=;
        b=DV71LEGEMcriWPqOYp3Q5R0N4RSvbjCLFxLOck0Q7TEvPvU64h7Du0KFJFLqHFTWpJ
         asLis14FQpp3IqFunafPIOYW7Y79oCZd14ntf7XMxW1dZUdTv8q0NwbV+O9FgenjKzl7
         xbzaHOSnzBeCuH7PCFrbbHuTyqgQ03rjFVCuG6di38tfo0nSKzdUKD1s2IZhoUUC7MtB
         tbUL1dN80a4+/0eWCgJcJpbH8Ju7UD6LJBm4nZVXvXCSzOrLsMSiXW7rdIkHU20SyfqS
         ZEyQE8pQSLaPG1bTSF7NfC4UsU6T5S4vYxePdJnKP2Ycb6/lt/hK6CuC17oygWSNt5KT
         K4WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nSPXvVD5O5V1uAajVcwzQDL8XPPrWHEb/KX0Q3ujGGw=;
        b=qlYZvfm8+ZuzRkswcqWa4I5IdEZGKqu+7tlyfPtzxUVIQStSlzs31gLeUG2GCC6pmw
         Q/rh1Fb1OpWIcFW6ObTwBySAKJPmti79+c2zYh/YPdDy+fma6DZvxC78I6a4tTiAFYit
         +x2UQo+mfBesMEFqB9sGjTuW1kciDHEo0WOkZb3ezFuVhkw0Cb0mUfnRFQwh6fkUxm4W
         +AMPOoz1i+lg+YZmYCJbZkK0GXxvocobVIGxrDY5yEA+qjchRJD8VZVxk/nSdJSk/qol
         5tES9RSQcsmAbUnVjE6AqCfTcTc0QUnt4+g4tvhPwwrLD2Z5JzIu0nUOF76odSdI1Vh+
         fyOg==
X-Gm-Message-State: AOAM530yLKMMiBMBY7afDsCYcR93cUmkY1b0Qw+pGiMJPHH+INc83CHe
        GtD7IwQrzWQGsPufY7MKQgg/Lq1FX4MboMDecR6/Dw==
X-Google-Smtp-Source: ABdhPJxVvNSmVlJ0KA6TSTA1JviGtz5KbzeBvftwQSoQXXKspUz7umEQ409Z7oNaSQXRbv2fkxMVpdeM+d00qN95S/g=
X-Received: by 2002:a02:7094:: with SMTP id f142mr5055124jac.19.1629241869799;
 Tue, 17 Aug 2021 16:11:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1629118207.git.ashish.kalra@amd.com> <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
 <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com> <CABayD+d4dHBMbshx_gMUxaHkJZENYYRMrzatDtS-a1awGQKv2A@mail.gmail.com>
 <CABgObfZbyTxSO9ScE0RMK2vgyOam_REo+SgLA+-1XyP=8Vx+uQ@mail.gmail.com> <b1b5adcdbf51112d7b3cc2c66123dea5276a4a6d.camel@linux.ibm.com>
In-Reply-To: <b1b5adcdbf51112d7b3cc2c66123dea5276a4a6d.camel@linux.ibm.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Tue, 17 Aug 2021 16:10:33 -0700
Message-ID: <CABayD+cCeVw8QAUwD9qCxWN_tEm14k_o4VFM+s4r9uwypvkmSA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
To:     jejb@linux.ibm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Thomas Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Habkost, Eduardo" <ehabkost@redhat.com>,
        "S. Tsirkin, Michael" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Dov Murik <dovmurik@linux.vnet.ibm.com>,
        Hubertus Franke <frankeh@us.ibm.com>,
        David Gilbert <dgilbert@redhat.com>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 17, 2021 at 3:57 PM James Bottomley <jejb@linux.ibm.com> wrote:
> Realistically, migration is becoming a royal pain, not just for
> confidential computing, but for virtual functions in general.  I really
> think we should look at S3 suspend, where we shut down the drivers and
> then reattach on S3 resume as the potential pathway to getting
> migration working both for virtual functions and this use case.

This type of migration seems a little bit less "live", which makes me
concerned about its performance characteristics.

Steve
