Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0EC25D257
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 09:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgIDH3T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 03:29:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39115 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726114AbgIDH3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 03:29:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599204556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5WARdyX1YHYkybe8MUk7ryY2qAtsHHzu0CP+6P8E3II=;
        b=StRh1TZvNFTyRrnYiPuZGXE9DgJfNROKQgizP6I5/ooRWXrDmAvZNYCoamv6Cu0Md+bhd9
        s3pItfDO0OKBzZTE/x5ak1cnWahlxBHmOuCR6e9zwJ6mTeptts58NumTdQDfedQ+rxqVsw
        KEYEWeHtifH7Qnlh1AWd4RNwRzs9Wh8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-u6HqFIgUP1mWWoWTcIRy_Q-1; Fri, 04 Sep 2020 03:29:14 -0400
X-MC-Unique: u6HqFIgUP1mWWoWTcIRy_Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72D9B56C20;
        Fri,  4 Sep 2020 07:29:13 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-112-62.ams2.redhat.com [10.36.112.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20F051A7C8;
        Fri,  4 Sep 2020 07:29:07 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id D0FA731E23; Fri,  4 Sep 2020 09:29:05 +0200 (CEST)
Date:   Fri, 4 Sep 2020 09:29:05 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
Message-ID: <20200904072905.vbkiq3h762fyzds6@sirius.home.kraxel.org>
References: <20200807141232.402895-1-vkuznets@redhat.com>
 <20200825212526.GC8235@xz-x1>
 <87eenlwoaa.fsf@vitty.brq.redhat.com>
 <20200901200021.GB3053@xz-x1>
 <877dtcpn9z.fsf@vitty.brq.redhat.com>
 <20200904061210.GA22435@sjchrist-ice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904061210.GA22435@sjchrist-ice>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> Unless I'm mistaken, microvm doesn't even support PCI, does it?

Correct, no pci support right now.

We could probably wire up ecam (arm/virt style) for pcie support, once
the acpi support for mictovm finally landed (we need acpi for that
because otherwise the kernel wouldn't find the pcie bus).

Question is whenever there is a good reason to do so.  Why would someone
prefer microvm with pcie support over q35?

> If all of the above is true, this can be handled by adding "pci=lastbus=0"
> as a guest kernel param to override its scanning of buses.  And couldn't
> that be done by QEMU's microvm_fix_kernel_cmdline() to make it transparent
> to the end user?

microvm_fix_kernel_cmdline() is a hack, not a solution.

Beside that I doubt this has much of an effect on microvm because
it doesn't support pcie in the first place.

take care,
  Gerd

