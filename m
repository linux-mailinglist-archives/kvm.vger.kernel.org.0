Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3344E3B62
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 10:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbiCVJEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 05:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbiCVJEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 05:04:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0E567E088
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 02:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647939764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kIECeaOGNGThyDsccgXqUeks22kwbKKUnoocC2+ZGhY=;
        b=PhMo9LKaXTLlIYFed9E3XC6Vxy/0fxAAVHYVAI7q+aRd4b2rQqtMN/398dsrw3JJpUGeaz
        rrXw6pFWaywQG84pahL61nQyi9Lr+lPQdzop2mLlDVmZkinhB2x2brouJgCg2g6xTloYeH
        F6XrlT+GCgpdnyDtrVq/0uwFtjsdbHQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-Etli3fYZNuKVkCjWzVCwuA-1; Tue, 22 Mar 2022 05:02:41 -0400
X-MC-Unique: Etli3fYZNuKVkCjWzVCwuA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFE6938008A1;
        Tue, 22 Mar 2022 09:02:40 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.196.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6747A40C1257;
        Tue, 22 Mar 2022 09:02:40 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id E4EC9180062E; Tue, 22 Mar 2022 10:02:38 +0100 (CET)
Date:   Tue, 22 Mar 2022 10:02:38 +0100
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        erdemaktas@google.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        seanjc@google.com
Subject: Re: [RFC PATCH v3 12/36] i386/tdx: Add property sept-ve-disable for
 tdx-guest object
Message-ID: <20220322090238.6job2whybu6ntor7@sirius.home.kraxel.org>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-13-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317135913.2166202-13-xiaoyao.li@intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 17, 2022 at 09:58:49PM +0800, Xiaoyao Li wrote:
> Add sept-ve-disable property for tdx-guest object. It's used to
> configure bit 28 of TD attributes.

What is this?

> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -792,10 +792,13 @@
>  #
>  # @attributes: TDX guest's attributes (default: 0)
>  #
> +# @sept-ve-disable: attributes.sept-ve-disable[bit 28] (default: 0)

I'd suggest to document this here.

thanks,
  Gerd

