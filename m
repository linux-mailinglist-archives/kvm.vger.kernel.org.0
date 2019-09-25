Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB42BD60D
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 03:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404137AbfIYBTD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 21:19:03 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:44312 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392379AbfIYBTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 21:19:03 -0400
Received: by mail-wr1-f49.google.com with SMTP id i18so4198696wru.11
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 18:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lz+YejONkioxJg1AMhZ2Z1Gi7SFBdSGeZeGK5rxt5KU=;
        b=PAEEASgNNlnbGQpInT4K3X3GMRR+H5kbXtCwGB7NkIeBh0KNofw5WJedtiZajxJZSy
         P7N8Jkyw1Muq62haBD0bG4+KCOED10O7O78v2tWwmQBPh8P420dZiF0j/sGZTEsdWJGz
         rrG2QvAmVKWegVaSyNJC9AlCS6qh/Yp3oVFHnEX0WG/rEBcfPMWoruu33BDNOkCyJTHD
         C3l50vWKt3gGhWHUkKoQl2XFjCUd8PojyPuhVlexPCE+4hQRMxzqfjJroTFNWEJpoHXM
         MjB12zlaGOfEb2z3IhnrT7vv0K/LO4EBaoJAjYm2s/UoJjnlx0SOzN3NmultYEOGa7o1
         kV9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lz+YejONkioxJg1AMhZ2Z1Gi7SFBdSGeZeGK5rxt5KU=;
        b=FHVfDLfDmWKxawjpxkYvUwl1EkziUpKfxWwMrGfXRf7oM4kICiMnFS3posoi8fBK+p
         DHxOQdDrmEc4HLhrscQ1b5/CZ81vg9eyecqSdby7ZZ0xL3KdPYef3tZSnZzwB53V2Fwc
         w+xHJmJoopo41UOYpWNWCVmAbWR3DRhRKYjALZonWtC0PlTTQYva00dTnwTHzMa6OuOg
         Wf4lbjh2Qv54nFhMGfFFyHgN+WcZKTq+N6Z/712JoC1XF0ydzVGEKHkhGiGA957b92s7
         Xk7nMN/dzWCvUaK5j8r7GNwVEcwMSF/vck1Nv/0IKtKBZDCisbs26AHRGVRtN0Mv/spL
         YOtw==
X-Gm-Message-State: APjAAAWJBLj91lL4CYEQyoX+Urz6xb2tZA9GN3AI2NsK2KTGAhDoNksi
        iaEOqYjUe2uUGV05T9o9W2aoB2rNROnJJU2UZ3YKJg==
X-Google-Smtp-Source: APXvYqxVG4CwlGG8Ty6Yr/b7XBoiGP2JdipNGMesGL2hAkrL/zKkqtjiTi/mO9U0qmUNJyGNNSOMFrYRb/i1gi8vA30=
X-Received: by 2002:adf:ef49:: with SMTP id c9mr5972579wrp.122.1569374340949;
 Tue, 24 Sep 2019 18:19:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190918222354.184162-1-marcorr@google.com> <20190918222354.184162-2-marcorr@google.com>
 <83A0AF0F-49DA-44FF-8EC0-2E462AA10C65@redhat.com>
In-Reply-To: <83A0AF0F-49DA-44FF-8EC0-2E462AA10C65@redhat.com>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 24 Sep 2019 18:18:49 -0700
Message-ID: <CAA03e5FmHYWBxWMfAr8LYsz51YEDXY9STyMOCu7U37bSzSDXrQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v5 2/2] x86: nvmx: test max atomic switch MSRs
To:     Christophe de Dinechin <dinechin@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Excerise nested VMX's atomic MSR switch code (e.g., VM-entry MSR-load
>
> Nit: Exercise

Done.
