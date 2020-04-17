Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA4D1ADE5D
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 15:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730693AbgDQNcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 09:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730351AbgDQNck (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 09:32:40 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AD1C061A0C
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 06:32:39 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id i27so1399478ota.7
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 06:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fwc+6Mwwqh7DLXhvjwR3QXK3J1CjVqSulYYfvjFl8X4=;
        b=XC7Yj10K2YbNqP0Op42aczXxU2SVnP+I7j8RdrbXcaV5FrlnBhYCcPR0Sh738Wvr5G
         tX+0dH039S9FzwTiVSAsytcPCgzUcYYm76hyTG7zlmnv6059MBXCWiSawyE613uFITUK
         ZjhDl5JN181/yMQnE3hRDxqu0FTU8O/CDjX7fWz9SWilP1NDaMfgOeUgjWSZEmSP3dMw
         Q9TRLPFoewDvArnMtORImP9bSQsuGI99WIpd7zmv4XR6st2uUAKY8ji0FcfLFxqW/VKA
         wA5BW8HHlVZciS8/OWB8pkWP1SPZK7hKLzZQXE5RaM4lD6B0zmaViU50kAkIbzOlT7rU
         4zgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fwc+6Mwwqh7DLXhvjwR3QXK3J1CjVqSulYYfvjFl8X4=;
        b=QwkNuHzjP+lxFKFxdz85y9S5K4C8I/tLoiIyOt6P8tHc0tOLayUx64ao7j1Fh8jAXO
         0+rpQeLA2oaMIJ17VV+6bvSU3rPun+hgD8KijFEKiEFXGe6XqcPnkl0r3NsQJ34dERXC
         HzwIA16Otgj84irlnKYx7q1f0/ix3KOv1gMOXTHVsnWahQVMrK9A2THmPDwMgYWLqe+n
         ihhq0jBm20H543O/xjY8J2uS8vKNtx6vabdZCOpgwPPs4dv3dCCEYgK69s0inKb5O+1X
         63BGvtzXagUL72p7OhpUGa1KFQ84ePzmEUn92b2zisIzIuV+dYrX+yXDDNXrV2+I7NO8
         sw+w==
X-Gm-Message-State: AGi0PubYIoSNP1e7CTXGdJth1f2lxZbVPeKFpsw9TByhNNoMcOcQ1vPj
        ofTDH06rbNNwK9dZx0/Is3kJzdlTCe5NS2S35wDiMA==
X-Google-Smtp-Source: APiQypJ1LUCZ73GGjz1B9eI/M746O3mpnpKIp/F2JG5itGR86qXuxUSBx5/6zNG8wtVspr+Jpg19hI9l1tzgcHwfQrk=
X-Received: by 2002:a05:6830:1e4e:: with SMTP id e14mr2492560otj.91.1587130358818;
 Fri, 17 Apr 2020 06:32:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200410114639.32844-1-gengdongjiu@huawei.com>
In-Reply-To: <20200410114639.32844-1-gengdongjiu@huawei.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 17 Apr 2020 14:32:27 +0100
Message-ID: <CAFEAcA9oNuDf=bdSSE8mZWrB23+FegD5NeSAmu8dGWhB=adBQg@mail.gmail.com>
Subject: Re: [PATCH v25 00/10] Add ARMv8 RAS virtualization support in QEMU
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     Igor Mammedov <imammedo@redhat.com>,
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
        Zheng Xiang <zhengxiang9@huawei.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Apr 2020 at 12:46, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
>
> In the ARMv8 platform, the CPU error types includes synchronous external abort(SEA)
> and SError Interrupt (SEI). If exception happens in guest, host does not know the detailed
> information of guest, so it is expected that guest can do the recovery. For example, if an
> exception happens in a guest user-space application, host does not know which application
> encounters errors, only guest knows it.
>
> For the ARMv8 SEA/SEI, KVM or host kernel delivers SIGBUS to notify userspace.
> After user space gets the notification, it will record the CPER into guest GHES
> buffer and inject an exception or IRQ to guest.
>
> In the current implementation, if the type of SIGBUS is BUS_MCEERR_AR, we will
> treat it as a synchronous exception, and notify guest with ARMv8 SEA
> notification type after recording CPER into guest.

Hi. I left a comment on patch 1. The other 3 patches unreviewed
are 5, 6 and 8, which are all ACPI core code, so that's for
MST, Igor or Shannon to review.

Once those have been reviewed, please ping me if you want this
to go via target-arm.next.

thanks
-- PMM
