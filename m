Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2ED63D3B48
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 15:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbhGWM6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 08:58:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20749 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233365AbhGWM6S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Jul 2021 08:58:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627047531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CNrCnNEi8YU3NjpLXktV8L2vGTneNrqBq6dOtm+we8Y=;
        b=Y5G+imUs3tWu4A6G+0OI/TzOINrUSgDLIn5tmms9bxq14J/f4VJLFsa+DcvpwtoPafaqPw
        nupzLAnJ5UhL1ChVnFjTIMsT+D1CjM1qJywHx2pqyjHCJKkv3G8AtDjiyeHLYmLLOKRosN
        nWdudvC4BYZ3as7KaPnAmOsB+yCenME=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-1xVFMtF1Nz-8-sewhsEiYQ-1; Fri, 23 Jul 2021 09:38:49 -0400
X-MC-Unique: 1xVFMtF1Nz-8-sewhsEiYQ-1
Received: by mail-il1-f200.google.com with SMTP id c2-20020a056e020cc2b02901edc50cdfdcso1000673ilj.19
        for <kvm@vger.kernel.org>; Fri, 23 Jul 2021 06:38:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CNrCnNEi8YU3NjpLXktV8L2vGTneNrqBq6dOtm+we8Y=;
        b=muse/asux64XS1XC6b8Jkkb5o5j0S33HwJSTPA30woDhh1nOjcTIoH0MaM/9OLx9fu
         7qF2GP8RSrxx5Mld9/SBRCjAKlJ/qAzezWuDKkxGcF14RUabs4r60CNvI72UOFCyG62s
         Whg618tAIFA2IpKspjBAZf7IY94ziSyaxeZPqChCsl+FLZKBWsbgtbz5lsocovm7m6+E
         MS711aJL4Se/WbPHoSGY1NXvPaOGYDvlHY0BKafIB1H6eb748dxgGhpO8gYZqp2Ht28c
         Z6IU2uirYcvQ7VqH/DnWcDWM+sVpr+NhM4lfjF/SYT2wSOvykg4WKs6OpY4MQfoJe4Tk
         zh2Q==
X-Gm-Message-State: AOAM5321BuZdSTigOAoZHVMbEnu/xP92aqBlORtWSQAiVS6HndifopC6
        ZMXEwOPaGMEEpOLNiG8CUKMqN8epHb5zVNRlPGck4vYi99Jsx73XDUlYg9CFCRDLsqCJppo4WIL
        iN+HplrrdQQjp
X-Received: by 2002:a02:cd0a:: with SMTP id g10mr4243222jaq.18.1627047529244;
        Fri, 23 Jul 2021 06:38:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwek83fSduz7V8CLkiqtAngLuJBjs5iDFj4SG3DhS5HRyk7g8pS0JfJqY3+Yo29wQu7Wx0j/g==
X-Received: by 2002:a02:cd0a:: with SMTP id g10mr4243213jaq.18.1627047529098;
        Fri, 23 Jul 2021 06:38:49 -0700 (PDT)
Received: from gator ([204.16.59.133])
        by smtp.gmail.com with ESMTPSA id p8sm11466441iol.49.2021.07.23.06.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 06:38:48 -0700 (PDT)
Date:   Fri, 23 Jul 2021 15:38:45 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        will@kernel.org
Subject: Re: [PATCH 10/16] KVM: arm64: Add some documentation for the MMIO
 guard feature
Message-ID: <20210723133845.jwp3ljkfnupgv36i@gator>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-11-maz@kernel.org>
 <20210721211743.hb2cxghhwl2y22yh@gator>
 <60d8e9e95ee4640cf3b457c53cb4cc7a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60d8e9e95ee4640cf3b457c53cb4cc7a@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 23, 2021 at 02:30:13PM +0100, Marc Zyngier wrote:
...
> > > +
> > > +    ==============    ========
> > > ======================================
> > > +    Function ID:      (uint32)    0xC6000004
> > > +    Arguments:        (uint64)    The base of the PG-sized IPA range
> > > +                                  that is allowed to be accessed as
> > > +				  MMIO. Must aligned to the PG size (r1)
> > 
> > align
> 
> Hmmm. Ugly mix of tab and spaces. I have no idea what the norm
> is here, so I'll just put spaces. I'm sure someone will let me
> know if I'm wrong! ;-)

Actually, my comment wasn't regarding the alignment of the text. I was
commenting that we should change 'aligned' to 'align' in the text. (Sorry,
that was indeed ambiguous.) Hmm, it might be better to just add 'be', i.e.
'be aligned'.

I'm not sure what to do about the tab/space mixing, but keeping it
consistent is good enough for me.

Thanks,
drew

