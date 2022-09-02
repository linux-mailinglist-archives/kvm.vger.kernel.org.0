Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396385AAA71
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 10:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbiIBIp6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 04:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235973AbiIBIpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 04:45:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1076C7BAD
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 01:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662108266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jNOpLflP/Pm8NxANPGyXgCPBwfLtNpzAYQv+Of4HoFw=;
        b=NEldhBVPm3JEES+NxwcwEAJcyn9I9njGXWFQlHuvkBcZgJjP8ZYy2BZ8e5atysqQ1SRLRb
        WXeKSPbv/Cqe51Fj+jwX4R3qtgqN/69ontbrbMYC0v7En2yHKS4S6QtAXMl628gMAHp3fI
        8KNjG3PbJimhQgYPyeFcGumCkAuv8RE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-NFwmjWPkOs25c1W8bDAVKA-1; Fri, 02 Sep 2022 04:44:22 -0400
X-MC-Unique: NFwmjWPkOs25c1W8bDAVKA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC6803C0ED64;
        Fri,  2 Sep 2022 08:44:21 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.195.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A3FCB2166B26;
        Fri,  2 Sep 2022 08:44:21 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 0B73218003AA; Fri,  2 Sep 2022 10:44:20 +0200 (CEST)
Date:   Fri, 2 Sep 2022 10:44:20 +0200
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
Message-ID: <20220902084420.noroojfcy5hnngya@sirius.home.kraxel.org>
References: <20220831125059.170032-1-kraxel@redhat.com>
 <957f0cc5-6887-3861-2b80-69a8c7cdd098@intel.com>
 <20220901135810.6dicz4grhz7ye2u7@sirius.home.kraxel.org>
 <f7a56158-9920-e753-4d21-e1bcc3573e27@intel.com>
 <20220901161741.dadmguwv25sk4h6i@sirius.home.kraxel.org>
 <34be4132-53f4-8779-1ada-68aa554e0eac@intel.com>
 <20220902060720.xruqoxc2iuszkror@sirius.home.kraxel.org>
 <20220902021628-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902021628-mutt-send-email-mst@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,
 
> I feel there are three major sources of controversy here
> 
> 0. the cover letter and subject don't do such a good job
>    explaining that what we are doing is just telling guest
>    CPUID is not broken. we are not exposing anything new
>    and not exposing host capability to guest, for example,
>    if cpuid phys address is smaller than host things also
>    work fine.
> 
> 1. really the naming.  We need to be more explicit that it's just a bugfix.

Yep, I'll go improve that for v2.

> 2. down the road we will want to switch the default when no PV. however,
>    some hosts might still want conservative firmware for compatibility
>    reasons, so I think we need a way to tell firmware
>    "ignore phys address width in CPUID like you did in the past".
>    let's add a flag for that?
>    and if none are set firmware should print a warning, though I
>    do not know how many people will see that. Maybe some ;)

> /*
>  * Force firmware to be very conservative in its use of physical
>  * addresses, ignoring phys address width in CPUID.
>  * Helpful for migration between hosts with different capabilities.
>  */
> #define KVM_BUG_PHYS_ADDRESS_WIDTH_BROKEN 2

I don't see a need for that.  Live migration compatibility can be
handled just fine today using
	'host-phys-bits=on,host-phys-bits-limit=<xx>'

Which is simliar to 'phys-bits=<xx>'.

The important difference is that phys-bits allows pretty much anything
whereas host-phys-bits-limit applies sanity checks against the host
supported phys bits and throws error on invalid values.

take care,
  Gerd

