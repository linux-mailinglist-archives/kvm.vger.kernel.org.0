Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E16D584CC3
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 09:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbiG2HlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 03:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234154AbiG2HlJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 03:41:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC65A30F45;
        Fri, 29 Jul 2022 00:41:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 747BFB826FC;
        Fri, 29 Jul 2022 07:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B969C433C1;
        Fri, 29 Jul 2022 07:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659080465;
        bh=FGL1aL6A/RUi4MWxUt1uEuHn+zfgp4GeIxmcVsCw1F4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fJ7gKeTugfJH/h3B7n7K/CEU0tl9h/jM/Ej149hPw1vYLEJ0ZjlSpxZIwDEE6e1aa
         sG1QMS3ATbpyFb/mhLL2L2JIBqBDPAV2d18egaraTDGb31CqxjIvIXkuECBjX9KY+L
         kOUEipqVnksAgmpdlpxnEwJA++KoIihZ2z6a2dcs=
Date:   Fri, 29 Jul 2022 09:41:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Coleman Dietsch <dietschc@csp.edu>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] KVM: x86/xen: Fix bug in kvm_xen_vcpu_set_attr()
Message-ID: <YuOPDpy+RqD09n3j@kroah.com>
References: <20220728194736.383727-1-dietschc@csp.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728194736.383727-1-dietschc@csp.edu>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022 at 02:47:37PM -0500, Coleman Dietsch wrote:
> This crash appears to be happening when vcpu->arch.xen.timer is already set and kvm_xen_init_timer(vcpu) is called.

What does "this crash" refer to ?

> 
> During testing with the syzbot reproducer code it seemed apparent that the else if statement in the KVM_XEN_VCPU_ATTR_TYPE_TIMER switch case was not being reached, which is where the kvm_xen_stop_timer(vcpu) call is located.

Please properly wrap your kernel changelog at 72 columns.

Didn't checkpatch.pl complain about this?

thanks,

greg k-h
