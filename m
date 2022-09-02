Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4990B5AB6DD
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 18:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbiIBQxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 12:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235593AbiIBQw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 12:52:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C649F10950F
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 09:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662137576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7FRsXiPQLrdmyMGr3Bh7kFUvHRKBZGqby8pLojjXECg=;
        b=hP2ldw28BrjiHmv8TeRb3/VNDNf61OdywU+3n0VETcfG0vi6DvgD2W5bpaB7S71KGCMdYq
        gnxbV2L+5SavxQHaxcwfuYsTtdswEaF5QDGx58NiAZe6b6Ld585wqWIlnTfelsNmk+leNT
        +bqUhIK6VkM2gB6Z4nc0pGzvzkRhL48=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-kGOD_9VhMguLAH2ARmJYgw-1; Fri, 02 Sep 2022 12:52:53 -0400
X-MC-Unique: kGOD_9VhMguLAH2ARmJYgw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A888294EDFB;
        Fri,  2 Sep 2022 16:52:53 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.195.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EE9AD18ECC;
        Fri,  2 Sep 2022 16:52:52 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id ABDF7180039D; Fri,  2 Sep 2022 18:52:51 +0200 (CEST)
Date:   Fri, 2 Sep 2022 18:52:51 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v1 15/40] i386/tdx: Add property sept-ve-disable for
 tdx-guest object
Message-ID: <20220902165251.g2xfstp4u3sqnloz@sirius.home.kraxel.org>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
 <20220802074750.2581308-16-xiaoyao.li@intel.com>
 <20220825113636.qlqmflxcxemh2lmf@sirius.home.kraxel.org>
 <389a2212-56b8-938b-22e5-24ae2bc73235@intel.com>
 <20220826055711.vbw2oovti2qevzzx@sirius.home.kraxel.org>
 <a700a0c6-7f25-dc45-4c49-f61709808f29@intel.com>
 <YxFv6RglTOY3Pevj@google.com>
 <20220902054621.yyffxn2vnm74r2b3@sirius.home.kraxel.org>
 <YxIgq9flJehbEngQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxIgq9flJehbEngQ@google.com>
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

On Fri, Sep 02, 2022 at 03:26:35PM +0000, Sean Christopherson wrote:
> On Fri, Sep 02, 2022, Gerd Hoffmann wrote:
> > 
> > Hmm, ok, but shouldn't the SEPT_VE bit *really* controlled by the guest then?
> > 
> > Having a hypervisor-controlled config bit to protect against a malicious
> > hypervisor looks pointless to me ...
> 
> IIRC, all (most?) of the attributes are included in the attestation report, so a
> guest/customer can refuse to provision secrets to the guest if the hypervisor is
> misbehaving.

Good.  I think we sorted all issues then.

Acked-by: Gerd Hoffmann <kraxel@redhat.com>

take care,
  Gerd

