Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F54D35437D
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 17:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238291AbhDEPf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 11:35:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34366 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238086AbhDEPf2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Apr 2021 11:35:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617636921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U9lR0D/ik4lovQeQZXkTw68jJlityvvOcdt4Ek8wyEo=;
        b=MgSmxPi8dD/S3Y37qcTaadV9XkLmraJO44iaLfGRZ8TxGrEjWQASuC4GOHQWD7xAZAJ3Gu
        ekwbbsGr5FegOWILU4dYGfbe53LrZx90zVvrjqnhm01DLGlcEQMi1K+eCuJjUzQm4WfquD
        gTPf6KKs+sdXcWWL9Tf8SpNUi12hwrE=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-N7SUlTf9NHmZfbWKedB5YQ-1; Mon, 05 Apr 2021 11:35:19 -0400
X-MC-Unique: N7SUlTf9NHmZfbWKedB5YQ-1
Received: by mail-pj1-f69.google.com with SMTP id jz17so652068pjb.0
        for <kvm@vger.kernel.org>; Mon, 05 Apr 2021 08:35:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U9lR0D/ik4lovQeQZXkTw68jJlityvvOcdt4Ek8wyEo=;
        b=rzNqUMf+0gdfW/2+xnEOLuyyUzM3C5jP73hbdvg+xiovpxv4d1lw56x4FQRYbzldyk
         Y/tx3l269GpSI3q+mlVFiLpRX7DZyoN2PmZ6SUB/q3WiSaMI+0oHmkYcFt3cRpOhKph8
         aDh6zdf5P4mMc+HjvZYA5IjfVGPtELwSfbz6xUthZISL3T5GY5hUKPSn8PBMMCgewNkT
         GFYCX3NyWVYsaLl4KQQkbp2KUEy29o6+NkIoX5hd2mwU2C/0shwA3S6jMllcyyMJV29E
         MoSWpOnWG0tl4oJGo1GpggyFPYOsfSRPKCG4nK41OsKcJ9HX8r8wTrj8TTiQQ0UGtEtb
         CBWw==
X-Gm-Message-State: AOAM532Cuoh1VubEkibiGY1OH+/yUnQGvNfuLjL0Pwpt+GIi/2yCAxb3
        f7kK4Bm2HfYuWWIEzKgeGWI1hnSrdiBd8Nqg4943GFTOuokqOa553zpFtQnP4B1nfzQ8Fn+vHNc
        dUfUY688CIDLJWIFkbY40oT+vNfyY
X-Received: by 2002:a63:3ecb:: with SMTP id l194mr23395780pga.146.1617636918141;
        Mon, 05 Apr 2021 08:35:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMFRYUbbOqIcdLdGyNKJBwgPIkvmncBtIwON/NeDCbzYxVwmIdQz6+X+zZiUuk2PF/qXjqZXNxMMbXjwHYplU=
X-Received: by 2002:a63:3ecb:: with SMTP id l194mr23395753pga.146.1617636917911;
 Mon, 05 Apr 2021 08:35:17 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.22.394.2104041728020.2958@hadrien> <YGsobMdyqwzi9vr7@google.com>
In-Reply-To: <YGsobMdyqwzi9vr7@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 5 Apr 2021 17:35:06 +0200
Message-ID: <CABgObfZBAtac5TF=i3wpXT8aOpTNzM1e+VZay3QtCckph=O3=Q@mail.gmail.com>
Subject: Re: [kvm:queue 120/120] arch/x86/kvm/svm/sev.c:1380:2-8: preceding
 lock on line 1375 (fwd)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Julia Lawall <julia.lawall@inria.fr>,
        Nathan Tempelman <natet@google.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Robert Hu <robert.hu@intel.com>, kvm <kvm@vger.kernel.org>,
        kbuild-all@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 5, 2021 at 5:10 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Sun, Apr 04, 2021, Julia Lawall wrote:
> > Is an unlock needed on line 1380?
>
> Yep, I reported it as well, but only after it was queued.  I'm guessing Paolo
> will tweak the patch or drop it for now.

Yeah, it's a public holiday here but either Nathan or I will post v3.

Paolo

