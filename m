Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462965BFF0F
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 15:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiIUNnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 09:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiIUNnH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 09:43:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2760D6CD3B
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 06:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663767786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WbvVISdR0D5SgVri2kvUMTbYwrsa/O3VMAKDVY30tWE=;
        b=MyfhgBuVgQXk9wN7FfeHxabYQyMgBFEGiuBkmA9ob2hopvllxgQgGgoWw+YCVOg47HP3Ta
        m4Zl8czKAqlH2OSdBUFLBR6ZIviA8VtvWRnGhbNYZRffmjFmn3qrN0fXVlq7N5BMcJaIMD
        f2NRmnOagTYgbUe19b+Kcw9ggIbikLc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-mu9sk1t3P66-vQ7fqDjLSg-1; Wed, 21 Sep 2022 09:43:03 -0400
X-MC-Unique: mu9sk1t3P66-vQ7fqDjLSg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73FA8803520;
        Wed, 21 Sep 2022 13:43:02 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AA17111D3DB;
        Wed, 21 Sep 2022 13:42:47 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 3A5B31800081; Wed, 21 Sep 2022 15:42:46 +0200 (CEST)
Date:   Wed, 21 Sep 2022 15:42:46 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm/x86: reserve bit
 KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID
Message-ID: <20220921134246.xibospqoktp4wjie@sirius.home.kraxel.org>
References: <20220908114146.473630-1-kraxel@redhat.com>
 <YxoBtD+3sgEEiaFF@google.com>
 <20220909050224.rzlt4x7tjrespw3k@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909050224.rzlt4x7tjrespw3k@sirius.home.kraxel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 07:02:24AM +0200, Gerd Hoffmann wrote:
> On Thu, Sep 08, 2022 at 02:52:36PM +0000, Sean Christopherson wrote:
> > On Thu, Sep 08, 2022, Gerd Hoffmann wrote:
> > > -#define KVM_HINTS_REALTIME      0
> > > +#define KVM_HINTS_REALTIME                      0
> > > +#define KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID  1
> > 
> > Why does KVM need to get involved?  This is purely a userspace problem.
> 
> It doesn't.  I only need reserve a hints bit, and the canonical source
> for that happens to live in the kernel.  That's why this patch doesn't
> touch any actual code ;)
> 
> > E.g. why not use QEMU's fw_cfg to communicate this information to the
> > guest?
> 
> That is indeed the other obvious way to implement this.  Given this
> information will be needed in code paths which already do CPUID queries
> using CPUID to transport that information looked like the better option
> to me.

I'd like to move forward with this.

So, any comment further comments and opinions?
Is it ok to grab a hints bit given the explanation above?
Or should I go for the fw_cfg approach?

thanks & take care,
  Gerd

