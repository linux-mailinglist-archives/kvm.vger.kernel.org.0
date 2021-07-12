Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2673C5CF8
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 15:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhGLNOH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 09:14:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59883 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230004AbhGLNOG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Jul 2021 09:14:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626095477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BOw9n8cwdGuw2ZXr5gCJOWOTHCO5x6bd3gOnjgUDUhY=;
        b=R+Lxd0D7xdEgZIDgXtMRW53dpBCSa1y8gi+/GPAWlnDfYGZCASAKcyoSgSGFkYuyESWWmi
        cjxFoT2q95zqMreo35ukxX9JFTNwdFjP/xS2+kltfl0PqsO6cSuYo2KbYNUbKkzZZ83m5s
        7JmeDlGhn1WyZI9JgzX4rb4hjghvAPQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-Yz5WTe6JO9mBhKQ2MVlT6g-1; Mon, 12 Jul 2021 09:11:15 -0400
X-MC-Unique: Yz5WTe6JO9mBhKQ2MVlT6g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0389719057A0;
        Mon, 12 Jul 2021 13:11:14 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 502D45D6AD;
        Mon, 12 Jul 2021 13:11:08 +0000 (UTC)
Message-ID: <d95d40428ec07ee07e7c583a383d5f324f89686a.camel@redhat.com>
Subject: Re: About two-dimensional page translation (e.g., Intel EPT) and
 shadow page table in Linux QEMU/KVM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     harry harry <hiharryharryharry@gmail.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stefanha@redhat.com,
        mathieu.tarral@protonmail.com
Date:   Mon, 12 Jul 2021 16:11:06 +0300
In-Reply-To: <CA+-xGqOdu1rjhkG0FhxfzF1N1Uiq+z0b3MBJ=sjuVStHP5TBKg@mail.gmail.com>
References: <CA+-xGqNUX4dpzFV7coJSoJnPz6cE5gdPy1kzRKsQtGD371hyEg@mail.gmail.com>
         <d79db3d7c443f392f5a8b3cf631e5607b72b6208.camel@redhat.com>
         <CA+-xGqOdu1rjhkG0FhxfzF1N1Uiq+z0b3MBJ=sjuVStHP5TBKg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-07-12 at 08:02 -0500, harry harry wrote:
> Dear Maxim,
> 
> Thanks for your reply. I knew, in our current design/implementation,
> EPT/NPT is enabled by a module param. I think it is possible to modify
> the QEMU/KVM code to let it support EPT/NPT and show page table (SPT)
> simultaneously (e.g., for an 80-core server, 40 cores use EPT/NPT and
> the other 40 cores use SPT). What do you think? Thanks!
> 
> Best regards,
> Harry
> 
> On Mon, Jul 12, 2021 at 4:49 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > On Sun, 2021-07-11 at 15:13 -0500, harry harry wrote:
> > > Hi all,
> > > 
> > > I hope you are very well! May I know whether it is possible to enable
> > > two-dimensional page translation (e.g., Intel EPT) mechanisms and
> > > shadow page table mechanisms in Linux QEMU/KVM at the same time on a
> > > physical server? For example, if the physical server has 80 cores, is
> > > it possible to let 40 cores use Intel EPT mechanisms for page
> > > translation and the other 40 cores use shadow page table mechanisms?
> > > Thanks!
> > 
> > Nope sadly. EPT/NPT is enabled by a module param.
> > 
> > Best regards,
> >         Maxim Levitsky
> > 
> > > Best,
> > > Harry
> > > 
For same VM, I don't think it is feasable.

For multiple VMs make some use NPT/EPT and some don't,
this should be possible to implement.

Why do you need it?

Best regards,
	Maxim Levitsky

