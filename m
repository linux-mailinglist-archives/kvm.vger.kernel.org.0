Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6989D5A1984
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 21:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243135AbiHYT1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 15:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243145AbiHYT1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 15:27:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D60BD747;
        Thu, 25 Aug 2022 12:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAC8DB8291C;
        Thu, 25 Aug 2022 19:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14589C433C1;
        Thu, 25 Aug 2022 19:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661455664;
        bh=q+mPGqLjYeJ5eIqheWBgXDp7dmV2y+/bPkTaF8NeH7s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BY9seHd01qqhQ57O4p9U2awgYVKfd7Ab0F7mR4QykUFRBjRbRTXRbeX2xpl5EsPAn
         07pdd6g9vrtn49qbsnpiOSHlYtmYoPrFDAMp2UCTLJ7+yNMo2lMHbspq/y8FRGBvS6
         EO4krbSS4xujfLeqo48SGzIRccuWhGNQtIxVGp9Z6PeRruN+bGRwP4kxb+sH6qlMT8
         DCL5jgY2IFp+d7f7IZqxWG5w3eq07WJ/ZAQXBdGrTOuNDx/5dcFkmscFk/SwGNskTL
         c1u6J+1WtiXT43n58L8sPyX3pp+0WYVyWxrYZljDWu3S7mty7xoOC0TS+K8zlNyUiE
         Vvwmj6VlesEJQ==
Date:   Thu, 25 Aug 2022 22:27:37 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@intel.com>, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        haitao.huang@linux.intel.com
Subject: Re: [PATCH v2] x86/sgx: Allow exposing EDECCSSA user leaf function
 to KVM guest
Message-ID: <YwfNKePFxyeRtscl@kernel.org>
References: <20220818023829.1250080-1-kai.huang@intel.com>
 <YwbrywL9S+XlPzaX@kernel.org>
 <YweS9QRqaOgH7pNW@google.com>
 <236e5130-ec29-e99d-a368-3323a5f6f741@intel.com>
 <YweaEl48I7pxKMm8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YweaEl48I7pxKMm8@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022 at 03:49:38PM +0000, Sean Christopherson wrote:
> On Thu, Aug 25, 2022, Dave Hansen wrote:
> > On 8/25/22 08:19, Sean Christopherson wrote:
> > >>> This patch, along with your patch to expose AEX-notify attribute bit to
> > >>> guest, have been tested that both AEX-notify and EDECCSSA work in the VM.
> > >>> Feel free to merge this patch.
> > > Dave, any objection to taking this through the KVM tree?
> > 
> > This specific patch?  Or are you talking about the couple of AEX-notify
> > patches in their entirety?
> 
> I was thinking just this specific patch, but I temporarily forgot there are more
> patches in flight.  It would be a bit odd to have effectively half of the AEX-notify
> enabling go through KVM.
> 
> So with shortlog/changelog tweaks,
> 
> Acked-by: Sean Christopherson <seanjc@google.com>

with subsystem tag change (Sean's version):

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
