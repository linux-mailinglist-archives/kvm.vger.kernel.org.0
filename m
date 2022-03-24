Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5654E612A
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 10:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239549AbiCXJjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 05:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbiCXJjD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 05:39:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A47A09F388
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 02:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648114650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z13C+cFsOjA9oyUdtfruMEl5Jb9AVjMyAZ5/T/RGscA=;
        b=i4C22Le7JzQINeW06JzGtG/jgEFK7fbfjumyVvu/RMymlw6+TYzoknsdvbiUqnyIohOY/5
        I4mJPkr74e7aSf2+OhZtQhMBiF9a8EAPs7FbSO2FRQjPGfA2O5ogFg+d3q+M70Nznrw+oj
        PKLpmcoH4Ys49cs7xEVrbn+Yfq1gCcI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-iG0TfI8gMdKrSU85ZQ0etQ-1; Thu, 24 Mar 2022 05:37:27 -0400
X-MC-Unique: iG0TfI8gMdKrSU85ZQ0etQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED8DE296A610;
        Thu, 24 Mar 2022 09:37:26 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.196.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B1CF2C27D86;
        Thu, 24 Mar 2022 09:37:26 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 37BC518000AA; Thu, 24 Mar 2022 10:37:25 +0100 (CET)
Date:   Thu, 24 Mar 2022 10:37:25 +0100
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
Message-ID: <20220324093725.hs3kpcehsbklacnj@sirius.home.kraxel.org>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-13-xiaoyao.li@intel.com>
 <20220322090238.6job2whybu6ntor7@sirius.home.kraxel.org>
 <b452d357-8fc2-c49c-8c19-a57b1ff287e8@intel.com>
 <20220324075703.7ha44rd463uwnl55@sirius.home.kraxel.org>
 <4fc788e8-1805-c7cd-243d-ccd2a6314a68@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fc788e8-1805-c7cd-243d-ccd2a6314a68@intel.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> #VE can be triggered in various situations. e.g., CPUID on some leaves, and
> RD/WRMSR on some MSRs. #VE on pending page is just one of the sources, Linux
> just wants to disable this kind of #VE since it wants to prevent unexpected
> #VE during SYSCALL gap.

Linux guests can't disable those on their own?  Requiring this being
configured on the host looks rather fragile to me ...

take care,
  Gerd

