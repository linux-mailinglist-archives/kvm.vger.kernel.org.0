Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F241D3C5CE8
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 15:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhGLNFn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 09:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhGLNFm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 09:05:42 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58439C0613DD
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 06:02:53 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id t17so43202281lfq.0
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 06:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aSF0pnmVvIClrfNgv64NSNsd/ppKcaFCPNt3AwYYpfk=;
        b=fJOM+jhlrrfR8nbXG5hxAb9lBrBRexO2VfuxTw2gYtxS54zCZgztqA2oR49VstdvKE
         EgGvBcAET2qehUJSddtBAE3QuddnlHHw/faxTdURKVVK8jwlbZDQZlG5tW2YcJNkiIFd
         Eo7w0yep/iSzALln2SdK0K5lCyvvJeCHZZA+4SzjTROAeXvDmq+4mbfbXcEGv2knbZP6
         XkznFyBtExKQ+7jBrK832rFSx7C1jfTeJjrmxtfw2rNxqDfhI6b6Ia0DTbIWlGElgf2q
         sNVRRNGhHNmv3ulLXXNNBCKICnAig/h+EShHfz+jBCAP41ew7u7j96zPl8ClRzYEpCGd
         aEgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aSF0pnmVvIClrfNgv64NSNsd/ppKcaFCPNt3AwYYpfk=;
        b=ZmcRYA2CXPjYj+swj/+N5jjy7ZGLreKS1OzeI/vNtOyuE6nm0nGBVDJWsxZ7VjKpg1
         v2oEo/CdYdIns6le/q8qPCCANQ/G/+J9E+i72aY/tqBhHCdulitTiRiVhPM73ldJ3jZ1
         +sMRcbYKY0FaXR3ZDmKS8uKj8EPSyb8prFjfGBsL1l97rrIGL9v854yavoauuRCYSseL
         mFkVAQL0z4LklJzRPnwZ+C//aVYh9jae7EBLqF7q3mg+tHLkIlyLE+rXP732OZvAsyl0
         lHXrL4iyOVoHtW7uya5LucciDf/NMAZaCT1Qjl2kXwR4oCDqnCSwRkZ6RmnrQni7rS5n
         VE8A==
X-Gm-Message-State: AOAM531f5BJTeTbzxh8nGsfBFpVT8oGH8COPJtCrgsbJeIn9v92pr7Iq
        UaFxezNvyRlV+GXi2hlntmOjWHaxQ5S+ggH7yC8=
X-Google-Smtp-Source: ABdhPJyZAOEWJU9rLa84PUXgVTQgn/rgVHZ8sK/73MCH4VT8DjrYtS/ZteRRC/KeCq/ubbfK4gIA/q5rtBpWRGve6WI=
X-Received: by 2002:a05:6512:3b20:: with SMTP id f32mr12190347lfv.279.1626094971640;
 Mon, 12 Jul 2021 06:02:51 -0700 (PDT)
MIME-Version: 1.0
References: <CA+-xGqNUX4dpzFV7coJSoJnPz6cE5gdPy1kzRKsQtGD371hyEg@mail.gmail.com>
 <d79db3d7c443f392f5a8b3cf631e5607b72b6208.camel@redhat.com>
In-Reply-To: <d79db3d7c443f392f5a8b3cf631e5607b72b6208.camel@redhat.com>
From:   harry harry <hiharryharryharry@gmail.com>
Date:   Mon, 12 Jul 2021 08:02:46 -0500
Message-ID: <CA+-xGqOdu1rjhkG0FhxfzF1N1Uiq+z0b3MBJ=sjuVStHP5TBKg@mail.gmail.com>
Subject: Re: About two-dimensional page translation (e.g., Intel EPT) and
 shadow page table in Linux QEMU/KVM
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stefanha@redhat.com,
        mathieu.tarral@protonmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Maxim,

Thanks for your reply. I knew, in our current design/implementation,
EPT/NPT is enabled by a module param. I think it is possible to modify
the QEMU/KVM code to let it support EPT/NPT and show page table (SPT)
simultaneously (e.g., for an 80-core server, 40 cores use EPT/NPT and
the other 40 cores use SPT). What do you think? Thanks!

Best regards,
Harry

On Mon, Jul 12, 2021 at 4:49 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> On Sun, 2021-07-11 at 15:13 -0500, harry harry wrote:
> > Hi all,
> >
> > I hope you are very well! May I know whether it is possible to enable
> > two-dimensional page translation (e.g., Intel EPT) mechanisms and
> > shadow page table mechanisms in Linux QEMU/KVM at the same time on a
> > physical server? For example, if the physical server has 80 cores, is
> > it possible to let 40 cores use Intel EPT mechanisms for page
> > translation and the other 40 cores use shadow page table mechanisms?
> > Thanks!
>
> Nope sadly. EPT/NPT is enabled by a module param.
>
> Best regards,
>         Maxim Levitsky
>
> >
> > Best,
> > Harry
> >
>
>
