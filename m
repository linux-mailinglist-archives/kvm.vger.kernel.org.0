Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C7B4E5FC7
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 08:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344456AbiCXH6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 03:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240549AbiCXH6l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 03:58:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06CCC996AA
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 00:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648108629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y4OLA5AVObVFGzzk4S1HDaz+Qryeu6G84vGOSNzALb0=;
        b=KmWtCtVQpyKsTa94WXY6djYxtTElyFVx5B7P8DKDhrzHuNWci1K/BvDADOdw49xRcDs+1m
        Twlr7UamQpi1jrefZAbSgAOCHYA/MMP5tsUqV0Fbd2hHmnqkqlX5JfOdq6NyoaIdbrr5br
        2TJhd1rdlMeqKlBF1ul1FOeUA+hxGNk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-rl3qCzXZMJ690avWtQcc5g-1; Thu, 24 Mar 2022 03:57:05 -0400
X-MC-Unique: rl3qCzXZMJ690avWtQcc5g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 353CB899EC2;
        Thu, 24 Mar 2022 07:57:05 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.196.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E59CD401E9C;
        Thu, 24 Mar 2022 07:57:04 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 54BD818000AA; Thu, 24 Mar 2022 08:57:03 +0100 (CET)
Date:   Thu, 24 Mar 2022 08:57:03 +0100
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
Message-ID: <20220324075703.7ha44rd463uwnl55@sirius.home.kraxel.org>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-13-xiaoyao.li@intel.com>
 <20220322090238.6job2whybu6ntor7@sirius.home.kraxel.org>
 <b452d357-8fc2-c49c-8c19-a57b1ff287e8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b452d357-8fc2-c49c-8c19-a57b1ff287e8@intel.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 24, 2022 at 02:52:10PM +0800, Xiaoyao Li wrote:
> On 3/22/2022 5:02 PM, Gerd Hoffmann wrote:
> > On Thu, Mar 17, 2022 at 09:58:49PM +0800, Xiaoyao Li wrote:
> > > Add sept-ve-disable property for tdx-guest object. It's used to
> > > configure bit 28 of TD attributes.
> > 
> > What is this?
> 
> It seems this bit doesn't show up in the public spec yet.
> 
> Bit 28 (SEPT_VE_DISABLE): Disable EPT violation conversion to #VE ON guest
> TD ACCESS of PENDING pages.
> 
> The TDX architecture requires a private page to be accepted before using. If
> guest accesses a not-accepted (pending) page it will get #VE.
> 
> For some OS, e.g., Linux TD guest, it doesn't want the #VE on pending page
> so it will set this bit.

Hmm.  That looks rather pointless to me.  The TDX patches for OVMF add a
#VE handler, so I suspect every guest wants #VE exceptions if even the
firmware cares to install a handler ...

Also: What will happen instead? EPT fault delivered to the host?

take care,
  Gerd

