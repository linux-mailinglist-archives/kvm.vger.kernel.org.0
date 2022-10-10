Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CECC5F9EA8
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 14:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbiJJMVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 08:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbiJJMUc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 08:20:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2861834E
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 05:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665404422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9s5o6SdS8P0CfqhmvZD+bK03/Hb+EKcKUZ78+emLMaY=;
        b=jIS83I9azgJcNupO5lBZ5FC7IeZuX6TD/r62uIlKvfSiBQRSGHRkBs/nTTR3T3cLyihtCp
        wlzBmhS6Vgg31WiLqMaQ7GwlvOI8g+RoMLil/EMeS+hRzIW+fDuR06VXXdyGFpCjMTX2HF
        n/6lqcDFhZMXMRQAZKxWqTJJXqMQcZA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-in94mBAVOtyavCUM4Jip9g-1; Mon, 10 Oct 2022 08:20:19 -0400
X-MC-Unique: in94mBAVOtyavCUM4Jip9g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5D98811E81;
        Mon, 10 Oct 2022 12:20:18 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.195.183])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 74061B2798;
        Mon, 10 Oct 2022 12:20:18 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 368161800605; Mon, 10 Oct 2022 09:30:20 +0200 (CEST)
Date:   Mon, 10 Oct 2022 09:30:20 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4] x86: add etc/phys-bits fw_cfg file
Message-ID: <20221010073020.d3bfkm6xi55a7dqd@sirius.home.kraxel.org>
References: <20220922101454.1069462-1-kraxel@redhat.com>
 <YyxF2TNwnXaefT6u@redhat.com>
 <20220922122058.vesh352623uaon6e@sirius.home.kraxel.org>
 <CABgObfavcPLUbMzaLQS2Rj2=r5eAhuBuKdiHQ4wJGfgPm_=XsQ@mail.gmail.com>
 <20220922203345.3r7jteg7l75vcysv@sirius.home.kraxel.org>
 <CABgObfZS+xW9dTKNy34d0ew1VbxzH8EKtEZO3MwGsX+DUPzWqw@mail.gmail.com>
 <20220923062312.sibqhfhfznnc22km@sirius.home.kraxel.org>
 <20221007094427-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007094427-mutt-send-email-mst@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> > > > Given newer processors have more than 40 and for older ones we know
> > > > the possible values for the two relevant x86 vendors we could do
> > > > something along the lines of:
> > > >
> > > >    phys-bits >= 41                   -> valid
> > > >    phys-bits == 40    + AuthenticAMD -> valid
> > > >    phys-bits == 36,39 + GenuineIntel -> valid
> > > >    everything else                   -> invalid

> I dropped the patch for now.

You can drop it forever.

For the mail archives and anyone interested:  The approach outlined
above appears to work well, patches just landed in edk2 master branch.
Next edk2 stable tag (2022-11) will have it.

take care,
  Gerd

