Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB20E726C
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 14:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfJ1NLu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Oct 2019 09:11:50 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45132 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbfJ1NLu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Oct 2019 09:11:50 -0400
Received: by mail-oi1-f193.google.com with SMTP id k2so687716oij.12
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2019 06:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HyBAqeapYuxtXuJfIQdZix/p7r93MkELXxCsBd6FUY0=;
        b=d3gLT2gnqwgF4vTsJWZG2UcUvIo2shVw4quoZlQ619do68aYEqet/Gkytufd9Y47QW
         1OAJLtOmor5P3hloUEhEgf1qewgfieyCwLY/J2el3oBg4D2RpG1SHN8njt5GE6oXY1ZA
         5wI0j/gyjN8QMZliHHlHIQJSlw6uUPP87ylJyqDQM7JseBWpS7pexOdBdpYZZSHR8GQ6
         K3GVtBiJ+tCFru3960DZtJr54RnHX5rOP/DDry7XYs7WfAlcKKiqKTdJiQ22t7BjXqBS
         awciiSNMtPxFW3ca9QA68yNiRKvLZP2RaDmJJxT9vAIHLKshpAtfvZXNN2bY1QyqDDle
         ZXAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HyBAqeapYuxtXuJfIQdZix/p7r93MkELXxCsBd6FUY0=;
        b=BqJrEiBHAdPmeZVPPWla4vHIYgp6EgaHN+gP+zMdQgBMLycZhmADY3mfAQnGt+nMoK
         JtA4uKMOFJt9u7ZxGAidjlARDdTqNdUYOZ0ayAGbeku5iDBGvoujCf4blvtmRRrpkjO2
         gHyVp/nEGJajjcGfWN0/71GGpR/TyPPdC1kFqtMa4f0c6fu2jicL7gQ+Kc9EP/F27diJ
         nHtU315HiX3WN4YtjEH4cZLJVXlKVs3FFDZFdxrTUc++Qqwtz/b+iSCMfGRqRFyShvx1
         5wT5eUuqc455v0ZX6LJ8aNQCIMqOwKFxkZjO6M8PHcLX+wtyIY/47CiRtWLp8mjIxYhJ
         VufA==
X-Gm-Message-State: APjAAAXkx0YZ2hdHHSVXtpkNWGsdwui4MoK+7bvxHG9916UT68M7RGiM
        6tR1JsEyffB/CXhN7YevYmg5VegY96AOsfwZgOzmNQ==
X-Google-Smtp-Source: APXvYqwVpkGGXygFILUaoGHg5RHvXOv0ZlsxyMz9ioegP3kMBRg6K49wBY1vUSlOnuTspz71c9XrupumfPXIVhI0G60=
X-Received: by 2002:aca:3b41:: with SMTP id i62mr13367511oia.48.1572268309051;
 Mon, 28 Oct 2019 06:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <20191026032447.20088-1-zhengxiang9@huawei.com> <20191027061450-mutt-send-email-mst@kernel.org>
In-Reply-To: <20191027061450-mutt-send-email-mst@kernel.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 28 Oct 2019 13:11:48 +0000
Message-ID: <CAFEAcA-gkBFgqYfFOPera15x2cK_a54Abw_0Gad1Jq+tGcC8rQ@mail.gmail.com>
Subject: Re: [PATCH v20 0/5] Add ARMv8 RAS virtualization support in QEMU
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Xiang Zheng <zhengxiang9@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Laszlo Ersek <lersek@redhat.com>,
        James Morse <james.morse@arm.com>,
        gengdongjiu <gengdongjiu@huawei.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>, kvm-devel <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>, Linuxarm <linuxarm@huawei.com>,
        wanghaibin.wang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 27 Oct 2019 at 10:17, Michael S. Tsirkin <mst@redhat.com> wrote:
> This looks mostly OK to me.  I sent some minor style comments but they
> can be addressed by follow up patches.
>
> Maybe it's a good idea to merge this before soft freeze to make sure it
> gets some testing.  I'll leave this decision to the ARM maintainer.  For
> ACPI parts:
>
> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>

Thanks for the review. Unfortunately this has missed the softfreeze,
given I'm away for the conference already and not in a position
to do any more review/merging of arm stuff. It'll have to wait for 5.0.

thanks
-- PMM
