Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134805A25D6
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 12:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245166AbiHZK1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 06:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245052AbiHZK1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 06:27:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87789CD53A
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 03:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661509665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FRnlFMyxyudZZRDHXyf4i8vbnnf7Zxl6opEWJKsZDd8=;
        b=iqomURD9KaRF9FZZUuCpqkj9QyRPb3Ht1hjZVeS1sGnmXO4Zv6pvZK/Zw3w0AdHZ6unn64
        67WCDsYSDK213zTlFE9YIMVLReWPPZ3OSZhS9vIzqQYicfKOXpnXtt7uS5g/CLpilMZ04Q
        VoXJpqBb8j4acFe27Y6uo8+Lrji4k5c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-2Bap1gpTMOWeBATRulKI8Q-1; Fri, 26 Aug 2022 06:27:41 -0400
X-MC-Unique: 2Bap1gpTMOWeBATRulKI8Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3376929AB40D;
        Fri, 26 Aug 2022 10:27:41 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.195.82])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DA97492C3B;
        Fri, 26 Aug 2022 10:27:40 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 9E0D818009AB; Fri, 26 Aug 2022 12:27:38 +0200 (CEST)
Date:   Fri, 26 Aug 2022 12:27:38 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
Subject: Re: [PATCH v1 27/40] i386/tdx: Setup the TD HOB list
Message-ID: <20220826102738.7pcnkfdqunmmsvkb@sirius.home.kraxel.org>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
 <20220802074750.2581308-28-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802074750.2581308-28-xiaoyao.li@intel.com>
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

On Tue, Aug 02, 2022 at 03:47:37PM +0800, Xiaoyao Li wrote:
> The TD HOB list is used to pass the information from VMM to TDVF. The TD
> HOB must include PHIT HOB and Resource Descriptor HOB. More details can
> be found in TDVF specification and PI specification.
> 
> Build the TD HOB in TDX's machine_init_done callback.
> 
> Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

Acked-by: Gerd Hoffmann <kraxel@redhat.com>

