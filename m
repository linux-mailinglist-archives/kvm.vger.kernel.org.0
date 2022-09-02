Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F785AA7C0
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 08:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbiIBGHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 02:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235376AbiIBGH2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 02:07:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C2BB95A1
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 23:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662098847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=82wuyHzBOyyNo34hJPzgjvvIX5BeEzD7ABQiSbeaZ+c=;
        b=Jh5o9ZDc67xIxrIDJD45A3G14L5k6eAQitgtAciXN7hEXwHICNnPgwa+sDJFxdl9KDBOKy
        uxkAl3wgJjlssyraPAntLc49h0J6nOJtm0ENLHwYaVmImN6Sh1YtyV7WatV2p+49gEk7eB
        NoN2F098aPyVhxuv8+mCCWDqtt/R8sQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-Fg4TKC_ZPWmbUov6y6TQ1w-1; Fri, 02 Sep 2022 02:07:23 -0400
X-MC-Unique: Fg4TKC_ZPWmbUov6y6TQ1w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB4CD811E81;
        Fri,  2 Sep 2022 06:07:22 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.195.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 655A4492C3B;
        Fri,  2 Sep 2022 06:07:21 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 108A518003AB; Fri,  2 Sep 2022 08:07:20 +0200 (CEST)
Date:   Fri, 2 Sep 2022 08:07:20 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>
Subject: Re: [PATCH 0/2] expose host-phys-bits to guest
Message-ID: <20220902060720.xruqoxc2iuszkror@sirius.home.kraxel.org>
References: <20220831125059.170032-1-kraxel@redhat.com>
 <957f0cc5-6887-3861-2b80-69a8c7cdd098@intel.com>
 <20220901135810.6dicz4grhz7ye2u7@sirius.home.kraxel.org>
 <f7a56158-9920-e753-4d21-e1bcc3573e27@intel.com>
 <20220901161741.dadmguwv25sk4h6i@sirius.home.kraxel.org>
 <34be4132-53f4-8779-1ada-68aa554e0eac@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34be4132-53f4-8779-1ada-68aa554e0eac@intel.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 02, 2022 at 08:10:00AM +0800, Xiaoyao Li wrote:
> On 9/2/2022 12:17 AM, Gerd Hoffmann wrote:
> > On Thu, Sep 01, 2022 at 10:36:19PM +0800, Xiaoyao Li wrote:
> > > On 9/1/2022 9:58 PM, Gerd Hoffmann wrote:
> > > 
> > > > > Anyway, IMO, guest including guest firmware, should always consult from
> > > > > CPUID leaf 0x80000008 for physical address length.
> > > > 
> > > > It simply can't for the reason outlined above.  Even if we fix qemu
> > > > today that doesn't solve the problem for the firmware because we want
> > > > backward compatibility with older qemu versions.  Thats why I want the
> > > > extra bit which essentially says "CPUID leaf 0x80000008 actually works".
> > > 
> > > I don't understand how it backward compatible with older qemu version. Old
> > > QEMU won't set the extra bit you introduced in this series, and all the
> > > guest created with old QEMU will become untrusted on CPUID leaf 0x80000008 ?
> > 
> > Correct, on old qemu firmware will not trust CPUID leaf 0x80000008.
> > That is not worse than the situation we have today, currently the
> > firmware never trusts CPUID leaf 0x80000008.
> > 
> > So the patches will improves the situation for new qemu only, but I
> > don't see a way around that.
> > 
> 
> I see.
> 
> But IMHO, I don't think it's good that guest firmware workaround the issue
> on its own. Instead, it's better to just trust CPUID leaf 0x80000008 and
> fail if the given physical address length cannot be virtualized/supported.
> 
> It's just the bug of VMM to virtualize the physical address length. The
> correction direction is to fix the bug not the workaround to hide the bug.

I'm starting to repeat myself. "just trust CPUID leaf 0x80000008"
doesn't work because you simply can't with current qemu versions.

I don't like the dance with the new bit very much either, but I don't
see a better way without massive fallout due to compatibility problems.
I'm open to suggestions though.

take care,
  Gerd

