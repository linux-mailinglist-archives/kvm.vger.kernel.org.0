Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BBC5F792A
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 15:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiJGNo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 09:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiJGNoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 09:44:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26F31A39A
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 06:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665150289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4GMPD8oqBS4LOqgQsiw5vIOtVWDGebMorjW0XBAzndo=;
        b=AhC8RFmeUSKDRVaJH+ZIMuyo4QEyhGl15FM/C+OzzZK7AsFHYWbgRYeVsoU/L+BZFMYCp0
        wPqbSdIezTUtEkaQkLgMh6KPm6isUdGYdV+4+DCwyE24C+DefCjueJGFPIZyJHunp2P2/t
        Qdmxf6ZJXnXLhpZ0eyxWT08d+Ao8FP4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-588-UcEvv5ZiOEy9-uAhawvB5A-1; Fri, 07 Oct 2022 09:44:48 -0400
X-MC-Unique: UcEvv5ZiOEy9-uAhawvB5A-1
Received: by mail-wr1-f70.google.com with SMTP id h4-20020adfa4c4000000b0022ec3966c3aso486800wrb.6
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 06:44:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4GMPD8oqBS4LOqgQsiw5vIOtVWDGebMorjW0XBAzndo=;
        b=ZbTohiCSjiO5EBA8hd53P92gpGwOL4Ox+G8SmtzmjpEHAq2CnrWt20CRoEm4mVCdrV
         gEO7zVISx4RE9HBTk7AcwwR4du82NuL1ReCCKLle+icvz34cfgq1AV+3snzvUCB54zPy
         4dpfx4ns458If45GhTWz1tM6ZRnb2ru2IQn2F3iSL6ZqNXbkiiifeOHZ2EenWMocw3WG
         wMyI1RebCdvu0SI9y/yhM5+ccmQKr1Sjw6U8tCXrfxeIOtvSnwlFPe7drVijJCYROcwX
         c2FnCLwJS4q/zThoo+JVaaNhme+aLGDB+oONwWpNSfBwQw7TveXjbPH5K/xB29JE8yGA
         9KCQ==
X-Gm-Message-State: ACrzQf0nMCXDgg1BmVBVU+LSSRrFYB1pV2z96I0bFtW6EL5RmF4x+D++
        05padk+r4DdHKj7tDKyJdenDUXpjsyEPWcLS1FAxmgfqELlNPaAdi5aecUc20K93/1T2XDWVwm4
        bK7LufhzaKc5q
X-Received: by 2002:a5d:6446:0:b0:22c:df37:4d76 with SMTP id d6-20020a5d6446000000b0022cdf374d76mr3335337wrw.247.1665150287589;
        Fri, 07 Oct 2022 06:44:47 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5JEpMmXo+TF3bHZD/1Xp0gu8UIKxaTqIvgouvJOohRPzIsn3Cy9fqHwCUVF1xdprW/WzoW2g==
X-Received: by 2002:a5d:6446:0:b0:22c:df37:4d76 with SMTP id d6-20020a5d6446000000b0022cdf374d76mr3335318wrw.247.1665150287338;
        Fri, 07 Oct 2022 06:44:47 -0700 (PDT)
Received: from redhat.com ([2.55.183.131])
        by smtp.gmail.com with ESMTPSA id o11-20020a05600c510b00b003a319b67f64sm18723614wms.0.2022.10.07.06.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 06:44:46 -0700 (PDT)
Date:   Fri, 7 Oct 2022 09:44:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4] x86: add etc/phys-bits fw_cfg file
Message-ID: <20221007094427-mutt-send-email-mst@kernel.org>
References: <20220922101454.1069462-1-kraxel@redhat.com>
 <YyxF2TNwnXaefT6u@redhat.com>
 <20220922122058.vesh352623uaon6e@sirius.home.kraxel.org>
 <CABgObfavcPLUbMzaLQS2Rj2=r5eAhuBuKdiHQ4wJGfgPm_=XsQ@mail.gmail.com>
 <20220922203345.3r7jteg7l75vcysv@sirius.home.kraxel.org>
 <CABgObfZS+xW9dTKNy34d0ew1VbxzH8EKtEZO3MwGsX+DUPzWqw@mail.gmail.com>
 <20220923062312.sibqhfhfznnc22km@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923062312.sibqhfhfznnc22km@sirius.home.kraxel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 23, 2022 at 08:23:12AM +0200, Gerd Hoffmann wrote:
>   Hi,
> 
> > > Given newer processors have more than 40 and for older ones we know
> > > the possible values for the two relevant x86 vendors we could do
> > > something along the lines of:
> > >
> > >    phys-bits >= 41                   -> valid
> > >    phys-bits == 40    + AuthenticAMD -> valid
> > >    phys-bits == 36,39 + GenuineIntel -> valid
> > >    everything else                   -> invalid
> > >
> > > Does that look sensible to you?
> > >
> > 
> > Yes, it does! Is phys-bits == 36 the same as invalid?
> 
> 'invalid' would continue to use the current guesswork codepath for
> phys-bits.  Which will end up with phys-bits = 36 for smaller VMs, but
> it can go beyond that in VMs with alot (32G or more) of memory.  That
> logic assumes that physical machines with enough RAM for 32G+ guests
> have a physical address space > 64G.
> 
> 'phys-bits = 36' would be a hard limit.
> 
> So, it's not exactly the same but small VMs wouldn't see a difference.
> 
> take care,
>   Gerd

I dropped the patch for now.

-- 
MST

