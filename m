Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD4F616BCB5
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 09:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbgBYIyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 03:54:22 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:39490 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729153AbgBYIyU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 03:54:20 -0500
Received: by mail-oi1-f195.google.com with SMTP id 18so8871300oij.6
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 00:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dqnKylF5HFciLFPtzz1NDtnvwRMuPol2Wp3vrExVO8g=;
        b=r/7xbz4aNyNr6RwlvL1OOZ+M+zLNU9Cc+UexnSCQaVAj4vHZSufgfP+s8331MkLPSJ
         l84ei7nkwF35uRylrZJ2oRvbhoiqGrrbjTMnOlW4BawnB/99ZJdaDyBVllJAt5gw+XTf
         6LIhJnlf845GVqJ9gPYy2drqFQWq+Yjho3O//FMro753kBrwTpevhEQ0KdGwrh2GMqOf
         aW6HQWTpXqECuqBr/SRKdV7QPCFPFZiQVR9SOmkvGL63QkdSO200bd+Wy2SMBislYrN1
         e3x7+uLfaiEAJa0zBmnBBwq/rILbX1mtC/KuIY88Gs+SZTzlSSCjgxBnLnbFL9I7fbig
         tGIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dqnKylF5HFciLFPtzz1NDtnvwRMuPol2Wp3vrExVO8g=;
        b=p83DSMnilOAKlki/0H2mBnZteC2YYY/n0S0KqpJ38yWYAvdsgfAo0If1JSKqyb4a/d
         9ycgJBsjA565980L4KGnNB7X9dnby/WR91wPFAJw2z36lhACQPUk752o7/GXufbeb5xt
         RFxRxXMQbD/ghl4NfDtK3sTeNY4ayrA0DQIk1e2+uW6bU2o6j0Jdh0r4BA4E/76E1Xn7
         V3qceIV3f8fVacLsOLN1KaZ9eYWGBA+TvFJs4ax1idngJdNLfJS+OWqIlK8KLXVEm84J
         sxlew+4GnOWK0FT3pqcm58GfdZt7Le3K8U3S5y8ra0utgQgtqnSP4SIn6m6UEFlBNXw8
         kR8A==
X-Gm-Message-State: APjAAAWeCnM7aZSs5pcr0OWiwwhCet7vGjTqniaFqmilA+GQbCu8ABgJ
        n3GDvR0ZG/GIKnqVU/tWQxe76wdYrESF9yChGTGDwQ==
X-Google-Smtp-Source: APXvYqz1X4gKcqOGaHJxF0nPqlbmz+VSqPW4ohODe1uOe7nVvHt5fIfMXWxzofk/ZJQybB1LVNMHhkz4bzuTBWcXaWQ=
X-Received: by 2002:a05:6808:289:: with SMTP id z9mr2579495oic.48.1582620859074;
 Tue, 25 Feb 2020 00:54:19 -0800 (PST)
MIME-Version: 1.0
References: <20200217131248.28273-1-gengdongjiu@huawei.com>
 <20200217131248.28273-3-gengdongjiu@huawei.com> <20200225093404.0ee40224@redhat.com>
In-Reply-To: <20200225093404.0ee40224@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 25 Feb 2020 08:54:07 +0000
Message-ID: <CAFEAcA9zjoa48Mth5aaOnhjDyY_qyrg9Nz5=0YEa2aE_aFcCug@mail.gmail.com>
Subject: Re: [PATCH v24 02/10] hw/arm/virt: Introduce a RAS machine option
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     Dongjiu Geng <gengdongjiu@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Fam Zheng <fam@euphon.net>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>, qemu-arm <qemu-arm@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Zheng Xiang <zhengxiang9@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Feb 2020 at 08:34, Igor Mammedov <imammedo@redhat.com> wrote:
>
> On Mon, 17 Feb 2020 21:12:40 +0800
> Dongjiu Geng <gengdongjiu@huawei.com> wrote:
>
> > RAS Virtualization feature is not supported now, so add a RAS machine
>
> > option and disable it by default.
>              ^^^^
>
> this doesn't match the patch.

Hmm? It seems right to me -- the patch adds a machine option
and makes it disabled-by-default, doesn't it?

thanks
-- PMM
