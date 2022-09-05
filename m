Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B97B5ACCF5
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 09:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236805AbiIEHjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 03:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235537AbiIEHjH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 03:39:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7100213FB1
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 00:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662363545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3ZbIUECdII8tK9BhsRycVKJJqNBhWBSkf3Xay6/B6wA=;
        b=NsS1vErQ5RlG5Ix/Pjb6PqaRrZ3VswUAE0VfPyjtJ6V+g64oYKPcYxU1TteNEZMPFxrhF+
        Zd3Z2Fs5qdHBjc49IbCMbaHNmEArjvBZ9tBpj0NoSIwTTJl/ODXPb3Pm8e0DyiMlm1wA3/
        TXYdKjB7aZFyW21D7u2eajKyA+kWEWg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-f-N6yZOnME6gkjQDPveccQ-1; Mon, 05 Sep 2022 03:39:04 -0400
X-MC-Unique: f-N6yZOnME6gkjQDPveccQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6ED73810D23;
        Mon,  5 Sep 2022 07:39:03 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.195.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A1439458A;
        Mon,  5 Sep 2022 07:39:03 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id DE10618007A4; Mon,  5 Sep 2022 09:39:01 +0200 (CEST)
Date:   Mon, 5 Sep 2022 09:39:01 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sergio Lopez <slp@redhat.com>
Subject: Re: [PATCH 0/2] expose host-phys-bits to guest
Message-ID: <20220905073901.t4xattq23y2mawjy@sirius.home.kraxel.org>
References: <20220831125059.170032-1-kraxel@redhat.com>
 <957f0cc5-6887-3861-2b80-69a8c7cdd098@intel.com>
 <20220901135810.6dicz4grhz7ye2u7@sirius.home.kraxel.org>
 <f7a56158-9920-e753-4d21-e1bcc3573e27@intel.com>
 <20220901161741.dadmguwv25sk4h6i@sirius.home.kraxel.org>
 <34be4132-53f4-8779-1ada-68aa554e0eac@intel.com>
 <20220902060720.xruqoxc2iuszkror@sirius.home.kraxel.org>
 <20220902021628-mutt-send-email-mst@kernel.org>
 <20220902084420.noroojfcy5hnngya@sirius.home.kraxel.org>
 <20220904163609-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220904163609-mutt-send-email-mst@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> > I don't see a need for that.  Live migration compatibility can be
> > handled just fine today using
> > 	'host-phys-bits=on,host-phys-bits-limit=<xx>'
> > 
> > Which is simliar to 'phys-bits=<xx>'.
> 
> yes but what if user did not configure anything?

I expect that'll be less and less common.  The phys-bits=40 default used
by qemu becomes increasingly problematic for large guests which need
more than that, and we see activity implementing support for that in
libvirt.

> the point of the above is so we can eventually, in X years, change the guests
> to trust CPUID by default.

Well, we can flip host-phys-bits to default to 'on' in qemu for new
machine types (or new cpu versions).  That'll have the very same effect.

take care,
  Gerd

