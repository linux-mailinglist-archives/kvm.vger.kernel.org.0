Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644165E6D10
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 22:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiIVUeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 16:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiIVUdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 16:33:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874E010FE3C
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 13:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663878831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=38h887HfzKb2f2rP/TsBJ7B1fN0ay51tuATW6aVKrKU=;
        b=h4WF9cPZmxfohEWfHl2H9XwHgPyW1D5M/b7lKO+PLVD1ZXE6F7S6zj0DZuUT48hau9cL1d
        9iBcVFerSu3UfUFidOUZtKqwbKwBnKrXqL9LQEYkhAMB/T2VgnIjYMikaJ3SzL+lUi6d2D
        OfqKIsfl0ynMCbbNVNU1it3sLxUxj+M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-5SYzBwOGMeqbFSu2t_m-ug-1; Thu, 22 Sep 2022 16:33:47 -0400
X-MC-Unique: 5SYzBwOGMeqbFSu2t_m-ug-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42896811E67;
        Thu, 22 Sep 2022 20:33:47 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F0E8BC15BAB;
        Thu, 22 Sep 2022 20:33:46 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 72BCC1800084; Thu, 22 Sep 2022 22:33:45 +0200 (CEST)
Date:   Thu, 22 Sep 2022 22:33:45 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        qemu-devel@nongnu.org, Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4] x86: add etc/phys-bits fw_cfg file
Message-ID: <20220922203345.3r7jteg7l75vcysv@sirius.home.kraxel.org>
References: <20220922101454.1069462-1-kraxel@redhat.com>
 <YyxF2TNwnXaefT6u@redhat.com>
 <20220922122058.vesh352623uaon6e@sirius.home.kraxel.org>
 <CABgObfavcPLUbMzaLQS2Rj2=r5eAhuBuKdiHQ4wJGfgPm_=XsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgObfavcPLUbMzaLQS2Rj2=r5eAhuBuKdiHQ4wJGfgPm_=XsQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 02:38:02PM +0200, Paolo Bonzini wrote:
> On Thu, Sep 22, 2022 at 2:21 PM Gerd Hoffmann <kraxel@redhat.com> wrote:
> > No.  This will basically inform the guest that host-phys-bits has been
> > enabled (and pass the number of bits).  So the firmware can make use of
> > the available address space instead of trying to be as conservative as
> > possible to avoid going beyond the (unknown) limit.
> 
> Intel processors that are not extremely old have host-phys-bits equal
> to 39, 46 or 52. Older processors that had 36, in all likelihood,
> didn't have IOMMUs (so no big 64-bit BARs).
> 
> AMD processors have had 48 for a while, though older consumer processors had 40.

How reliable is the vendorid?

Given newer processors have more than 40 and for older ones we know
the possible values for the two relevant x86 vendors we could do
something along the lines of:

   phys-bits >= 41                   -> valid
   phys-bits == 40    + AuthenticAMD -> valid
   phys-bits == 36,39 + GenuineIntel -> valid
   everything else                   -> invalid

Does that look sensible to you?

take care,
  Gerd

