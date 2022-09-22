Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8252A5E6290
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 14:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiIVMiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 08:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiIVMiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 08:38:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD51E7C11
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 05:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663850296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uv9cmY4jlDk+x+QD2HnLadtUs/Xl/1IY2hz7KLYpLRI=;
        b=dxGITL8gZaCJdmWojuXiiaRSN56SPmGslOpDZniNYVV4EPbzbhlYZFvCKOUshPO0+rTTCw
        DZ9LqNElbjTZcQWgWu4BJahDIPSUsrLyu/+OWRlkFTEews9pdnOgS+YacgXAOZsHgZTgUa
        zzPL/dmos5QcH8fWfAMGfToqdfaIWrk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-455-ZOBZlk0HOT6jrw6YoaatNQ-1; Thu, 22 Sep 2022 08:38:14 -0400
X-MC-Unique: ZOBZlk0HOT6jrw6YoaatNQ-1
Received: by mail-qv1-f72.google.com with SMTP id ec8-20020ad44e68000000b004aab01f3eaaso6296447qvb.4
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 05:38:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Uv9cmY4jlDk+x+QD2HnLadtUs/Xl/1IY2hz7KLYpLRI=;
        b=4HT7luXbfEtfwMTT0r5LjcKAIJmbmHE6uCqLzD1vGH6FTtvNJ46mwZ3q0eheeoFHtq
         IjBzH1SY9qVSqpmf8KjUpev45ZbDTSlekkD8PQRm63H+fxnH8SmDj1OtuL6kIoX0ZWpv
         XpTQ+8JJD1Y5qidZohwbmn6KdPiAePmGTf+JmiCV3PA1DBqG27VciSzXs7QEVvVBUeDC
         wS/3Q0lag3L//tzwcjUkdBafUp1h4OL5KOmmUo8rzFIUgoblNz6qJ0QkriCLagdUl4t2
         gm4d4sXpqWRR00G420WWyNZeMXjh3l2PIU0ExoIRHcSXENeBIxzwe6xuWUWnak4CseC7
         /5Zg==
X-Gm-Message-State: ACrzQf1Xvs9b1tReKl0C9TdLvOXmu+U+HdgSM7lBcihvK/i9vfFhuWMs
        2cgxp+N3cVnhXAUWh+ZgWHRsSflLqNPXs6pW8eZSZvKF/HEEE/g8X8ecV07m5uZDFKa8NJNIZ4m
        Jug+Njmq0HMB/uRt39Kmyl2U3zwhs
X-Received: by 2002:a05:620a:220f:b0:6ce:cead:f39e with SMTP id m15-20020a05620a220f00b006ceceadf39emr1879221qkh.233.1663850294439;
        Thu, 22 Sep 2022 05:38:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM77XVEjklfVa6pEJFL3+S0rqbKAJ06fZ3p+HvE1CK75BVl1+XqdwCHAkUwmTXvBJ3cWcHAwzCuNoRa8MiXETx8=
X-Received: by 2002:a05:620a:220f:b0:6ce:cead:f39e with SMTP id
 m15-20020a05620a220f00b006ceceadf39emr1879196qkh.233.1663850294222; Thu, 22
 Sep 2022 05:38:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220922101454.1069462-1-kraxel@redhat.com> <YyxF2TNwnXaefT6u@redhat.com>
 <20220922122058.vesh352623uaon6e@sirius.home.kraxel.org>
In-Reply-To: <20220922122058.vesh352623uaon6e@sirius.home.kraxel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 22 Sep 2022 14:38:02 +0200
Message-ID: <CABgObfavcPLUbMzaLQS2Rj2=r5eAhuBuKdiHQ4wJGfgPm_=XsQ@mail.gmail.com>
Subject: Re: [PATCH v4] x86: add etc/phys-bits fw_cfg file
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        qemu-devel@nongnu.org, Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 2:21 PM Gerd Hoffmann <kraxel@redhat.com> wrote:
> No.  This will basically inform the guest that host-phys-bits has been
> enabled (and pass the number of bits).  So the firmware can make use of
> the available address space instead of trying to be as conservative as
> possible to avoid going beyond the (unknown) limit.

Intel processors that are not extremely old have host-phys-bits equal
to 39, 46 or 52. Older processors that had 36, in all likelihood,
didn't have IOMMUs (so no big 64-bit BARs).

AMD processors have had 48 for a while, though older consumer processors had 40.

QEMU has always used 40, though many downstream packages (IIRC RHEL
and Ubuntu) just use host-phys-bits = true when using KVM.

Would it work to:

1) set host-phys-bits to true on new machine types when not using TCG
(i.e. KVM / HVF / WHPX)

2) in the firmware treat 40 as if it were 39, to support old machine types?

Paolo

