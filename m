Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A72C0B580E
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 00:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbfIQWfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 18:35:30 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53585 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfIQWfa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 18:35:30 -0400
Received: by mail-wm1-f66.google.com with SMTP id i16so260295wmd.3
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 15:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xjDLB8B4MIKoUTerILhTWVvgolMpZ9+qop2CkrYrPKY=;
        b=XyETs6Gg+WGhzuW2N8MEC9GYaX16h6WWDZ9YeFY/gtdmrCO+2xw5pu/zmv891vIxUf
         8g5HA955nr52FVEuDkAD7n7D8sbfSxvRsE0v1OLmGKA1tGM7Rtjx3GfTk+eCslCQpzc9
         FbXc0cZVGY6ft7ga9Xmx8WUfSJVR66508QerQKZZ8vgYX5/BNm87uDrVBar+WyBpTCNY
         8ghgF9Qx2D82pGSoquUGPVdFiU8XlaSuN5Ns7AVhZW2OHIqnTLnx/6vdpuDq9NUvZvfr
         o3kXqEE1yl4KJpUJF3Xdz7jPHaJvTrO0LiFGT0GUB7stXF9TeofM5Ii2gqYKD2InTDRx
         pWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xjDLB8B4MIKoUTerILhTWVvgolMpZ9+qop2CkrYrPKY=;
        b=NkRHrnJxjJNHV1xxs3VZ/Qc0YCjibJU0nsGqF5KvxZqx7UHnQVo4zZIX6iio24fbt+
         E6z5pAXQ4a0vODVg7NNAEng+5MeYDY9564+BU7039tERkpjr1LnuCfliu8iBp5Ncmsjo
         bNvkEHdcNeEmpV7G49KDmf2YfkMh210Q5vrlpQ/jHj0gFo25LCqbOeF3Jb2J8UnKoaWB
         cL0yW7oNy/7W0XcACogEbtbZJDy3P1leaFpUXqA4WFLR7IVHSWrgn9xRq0jCtdxaLe0K
         prIrF544MsegR/osdqwwOm4+btSjBVgZgM0Gmu64irG9Old5YyJmeE8DBgVgDWF44tni
         nOhw==
X-Gm-Message-State: APjAAAV8mj1ppHEepIps4Nalo7Vc1AXIASw6S44EY79DUU1sy+XsV9mM
        2s/dAvCPRlyw7OpkTwWLU77mIIzWVzM0m0cdGvpymw==
X-Google-Smtp-Source: APXvYqxD/zhJdTX9uZv/2zqZELoglA/JzuTjQY8RxcMgjGltxaAmDOha9hlU2T8fxOv44li3YewEH+k/lkuX5rYj8Rg=
X-Received: by 2002:a7b:c40c:: with SMTP id k12mr250775wmi.151.1568759727717;
 Tue, 17 Sep 2019 15:35:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190917185753.256039-1-marcorr@google.com> <20190917185753.256039-2-marcorr@google.com>
 <20190917194738.GD8804@linux.intel.com> <CAA03e5G94nbVj9vfOr5Gc7x89B6afh3HmxHnMMijtn8SzqgjTA@mail.gmail.com>
 <20190917222818.GB10319@linux.intel.com>
In-Reply-To: <20190917222818.GB10319@linux.intel.com>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 17 Sep 2019 15:35:16 -0700
Message-ID: <CAA03e5ErKKDJayq02xT8mSpJND=mUCD96dctjPcxgAZKixDX-g@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/2] x86: nvmx: test max atomic switch MSRs
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > > +     /* Cleanup. */
> > > > +     vmcs_write(ENT_MSR_LD_CNT, 0);
> > > > +     vmcs_write(EXI_MSR_LD_CNT, 0);
> > > > +     vmcs_write(EXI_MSR_ST_CNT, 0);
> > > > +     for (i = 0; i < cleanup_count; i++) {
> > > > +             enter_guest();
> > > > +             skip_exit_vmcall();
> > > > +     }
> > >
> > > I'm missing something, why do we need to reenter the guest after setting
> > > the count to 0?
> >
> > It's for the failure code path, which fails to get into the guest and
> > skip the single vmcall(). I've refactored the code to make this clear.
> > Let me know what you think.
>
> Why is not entering the guest a problem?

The vmx tests check that the L2 guest has completed. So we need to
advance the L2 RIP past the single vmcall. Technically, we don't need
to enter the guest to do that. Entering the guest and calling
skip_exit_vmcall() feels like a convenient, clean way to do this. But
I'm happy to directly advance the RIP if you think that's better. Let
me know what you think.
