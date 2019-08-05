Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB118205F
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 17:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbfHEPgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 11:36:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbfHEPgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 11:36:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1746B20B1F;
        Mon,  5 Aug 2019 15:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565019367;
        bh=3d2oadPIBQCQrLKuxy2uccJmd5Pzf20rfQlN0FPFs/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E8/7WJWRGTvVRuNopPumWMGBx8LAsFWBX5IQry6jP92q2zImlOoZ6lojTT8fb3hZq
         yq7QJLWyBn++tI9QI4eei63a8gNpJItROsM/kWmBzwL+FP+DGJYN2BXvs96XJdcANA
         VZ2s2y6QDk4fWz1N21Y7NvZ2UbgE6wII/4tUaWGc=
Date:   Mon, 5 Aug 2019 17:36:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Radim Krm <rkrcmar@redhat.com>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: remove kvm_arch_has_vcpu_debugfs()
Message-ID: <20190805153605.GA27752@kroah.com>
References: <20190731185556.GA703@kroah.com>
 <6ddc98b6-67d9-1ea4-77d8-dcaf0b5a94cc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ddc98b6-67d9-1ea4-77d8-dcaf0b5a94cc@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 03, 2019 at 08:23:25AM +0200, Paolo Bonzini wrote:
> On 31/07/19 20:55, Greg KH wrote:
> > There is no need for this function as all arches have to implement
> > kvm_arch_create_vcpu_debugfs() no matter what, so just remove this call
> > as it is pointless.
> > 
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: "Radim Krm" <rkrcmar@redhat.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: <x86@kernel.org>
> > Cc: <kvm@vger.kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> > v2: new patch in the series
> 
> Let's remove kvm_arch_arch_create_vcpu_debugfs too for non-x86 arches.
> 
> I'll queue your 2/2.

Great, so what about 1/2?  I have no objection to your patch for this.

thanks,

greg k-h
