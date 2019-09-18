Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975A1B60FF
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 12:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbfIRKDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 06:03:06 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:34358 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728909AbfIRKDG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 06:03:06 -0400
Received: by mail-qt1-f174.google.com with SMTP id j1so8207950qth.1
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2019 03:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V2MFLc6nPWIQyl/mz789miBwMoFARwcqBDfpLGr0qdc=;
        b=qpzYIFRwfLfZbcmnj4kEBFzXxGoKMoS+xwsrnHrYPof2O+EEmmrsBp6yEHfjhd4Q9U
         giz+n4g6E3GoJ+tD3cMfUNH3ov1GCR4p87Ofqfy5EQ2bHeGfmdstqtAGj8Mx9mgYI46u
         gmwwljwKCuf2Se6LVrdhJAlbZ/dQNaZB2JU7YNNQKC4pnK8zojajQD+5ADXY+lIJmNBY
         iBdRD4xaNfwDfya7KaELNBtgJcEWlgok1un6vi1mTPW6Uw4B7NcApdLL4Js1dCm6Z2xv
         M5oUyfuDm2Ws+0kJtw09yW4Xay9jyRZ0GcJmjphr4GXvALMjiv4HQry7yZ/iXw3wg55Z
         GzSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V2MFLc6nPWIQyl/mz789miBwMoFARwcqBDfpLGr0qdc=;
        b=I2zOgv+LCJG+gCXtKE2cUtOLRgbaDHOysamYxyeiVPLX0UFOWqjKY8OmDn5LiLP6PI
         8+VLhbY437Y6oyxwm8+XS8jjiUoQAjaZPANY/wZag6NhHB5CZB9l2Ju+ni1Vq3o63XZ+
         QMMv5bDfs8KxOQU0vsPFohIfIzTuhVdfxiKkIvlLAXVbt1pTDar0gdThtyJe61745Q09
         pxH8EJEyS8qI/wq1HM6OtbBri3H8As+D97B+IDocFFUCtWLxzJygsX1siTGqgBpAjII2
         GSfONxDmqcfONTy1kEfqBJnzg3x1qnBaL+rcmRa6EcIypf82b8ZG2jn75klMAmH020qC
         YguA==
X-Gm-Message-State: APjAAAW/GQ+YyBLvQZtGtw9vnYgNoIogmTsya2RifMD4P56s/mU+FG5d
        zPDczE1ip0nozmUf6mahRsZEQxkTNZld3gw79wo=
X-Google-Smtp-Source: APXvYqwIAe9iLoTZWujgzb4sW5oWY+Ned7c42fXCN7i2Z9Me4v5rKe8GI/oy03CWaMpFJ9g1N5ItcCbQQt/y65rQS5A=
X-Received: by 2002:aed:3576:: with SMTP id b51mr3348078qte.378.1568800985464;
 Wed, 18 Sep 2019 03:03:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAJSP0QVMjw_zm16MRo25Gq0J9w=9vrKDZtaH=WGwjSJiDAVm9Q@mail.gmail.com>
 <20190918082825.nnrjqvicqwjg3jq6@steredhat>
In-Reply-To: <20190918082825.nnrjqvicqwjg3jq6@steredhat>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Wed, 18 Sep 2019 11:02:54 +0100
Message-ID: <CAJSP0QXCJY4+5P9zU4670dfwjmKEUagB9gFrqF3H9cCPZPbzbA@mail.gmail.com>
Subject: Re: [libvirt] Call for volunteers: LWN.net articles about KVM Forum talks
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, libvir-list@redhat.com,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 18, 2019 at 9:28 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> On Tue, Sep 17, 2019 at 02:02:59PM +0100, Stefan Hajnoczi wrote:
> I volunteer for "Libvirt: Never too Late to Learn New Tricks" by
> Daniel Berrange.

Hi Stefano,
Paolo has already volunteered for that.  Is there another talk you are
interested in covering?

Stefan
