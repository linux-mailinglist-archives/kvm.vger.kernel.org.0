Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499F86F51B8
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 09:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjECHeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 03:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjECHem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 03:34:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560AE2736;
        Wed,  3 May 2023 00:34:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D61A362A6D;
        Wed,  3 May 2023 07:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4127C433AE;
        Wed,  3 May 2023 07:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683099280;
        bh=gU+zSzWAaM1OwERIe3fE599mEpiMIC/fxdCUq8IwCYo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KwkEvJmTz0y+a+xVZqTbP/VJQB8JR6DVMGSqQNFkDClOoqX7HnzPnjKQ1GoB1gKgU
         I7biBf6MiGBDV2+B0V0GalrUHXs//OCC0Y9zh6lZk5+gwTOieX+NHVUqPhx2lc8x1+
         aAVF5Tb1Bp8d3kDSa6xhpnnaeaKwg3NlYwvW3MXEba67vml7qpL3BUrMxWKaHmwg3Q
         gO1x0YraBaXFTo3aEjG4iE9b6a5u+0eLHd3Mr0RmfsXZUTp6R5Ty6wRd1bIw6V6PEP
         k+NzG3Vk+9SHlyMpd8UYlRAw6XTHm5AaGreaH0gRvCNKO4QMiv4SunYCUuEsD/gtWI
         lKnI1E9kYfpPw==
Date:   Wed, 3 May 2023 08:34:33 +0100
From:   Lee Jones <lee@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Rishabh Bhatnagar <risbhat@amazon.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Mike Bacco <mbacco@amazon.com>, "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/9] KVM backports to 5.10
Message-ID: <20230503073433.GM620451@google.com>
References: <20220909185557.21255-1-risbhat@amazon.com>
 <A0B41A72-984A-4984-81F3-B512DFF92F59@amazon.com>
 <YynoDtKjvDx0vlOR@kroah.com>
 <YyrSKtN2VqnAuevk@kroah.com>
 <20230419071711.GA493399@google.com>
 <ZFFt/ZMqQ1RHnY4e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZFFt/ZMqQ1RHnY4e@google.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 02 May 2023, Sean Christopherson wrote:

> On Wed, Apr 19, 2023, Lee Jones wrote:
> > On Wed, 21 Sep 2022, gregkh@linuxfoundation.org wrote:
> > 
> > > On Tue, Sep 20, 2022 at 06:19:26PM +0200, gregkh@linuxfoundation.org wrote:
> > > > On Tue, Sep 20, 2022 at 03:34:04PM +0000, Bhatnagar, Rishabh wrote:
> > > > > Gentle reminder to review this patch series.
> > > > 
> > > > Gentle reminder to never top-post :)
> > > > 
> > > > Also, it's up to the KVM maintainers if they wish to review this or not.
> > > > I can't make them care about old and obsolete kernels like 5.10.y.  Why
> > > > not just use 5.15.y or newer?
> > > 
> > > Given the lack of responses here from the KVM developers, I'll drop this
> > > from my mbox and wait for them to be properly reviewed and resend before
> > > considering them for a stable release.
> > 
> > KVM maintainers,
> > 
> > Would someone be kind enough to take a look at this for Greg please?
> > 
> > Note that at least one of the patches in this set has been identified as
> > a fix for a serious security issue regarding the compromise of guest
> > kernels due to the mishandling of flush operations.
> 
> A minor note, the security issue is serious _if_ the bug can be exploited, which
> as is often the case for KVM, is a fairly big "if".  Jann's PoC relied on collusion
> between host userspace and the guest kernel, and as Jann called out, triggering
> the bug on a !PREEMPT host kernel would be quite difficult in practice.
> 
> I don't want to downplay the seriousness of compromising guest security, but CVSS
> scores for KVM CVEs almost always fail to account for the multitude of factors in
> play.  E.g. CVE-2023-30456 also had a score of 7.8, and that bug required disabling
> EPT, which pretty much no one does when running untrusted guest code.
> 
> In other words, take the purported severity with a grain of salt.
> 
> > Please could someone confirm or otherwise that this is relevant for
> > v5.10.y and older?
> 
> Acked-by: Sean Christopherson <seanjc@google.com>

Thanks for taking the time to provide some background information and
for the Ack Sean, much appreciated.

For anyone taking notice, I expect a little lag on this still whilst
Greg is AFK.  I'll follow-up in a few days.

-- 
Lee Jones [李琼斯]
