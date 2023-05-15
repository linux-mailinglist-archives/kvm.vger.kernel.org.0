Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2474702D04
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 14:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241846AbjEOMrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 08:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbjEOMra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 08:47:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A529D2;
        Mon, 15 May 2023 05:47:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFD97623B7;
        Mon, 15 May 2023 12:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE48BC433D2;
        Mon, 15 May 2023 12:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1684154848;
        bh=+iNWSAMyyGn8fXH/2VphZqTwrPlNA2TmlU4SU7NQSTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0iBtVl26RdbqkNJ6Mx/I2fsAgqXT4KEXJFnetJ0cas0E4CBrmzDXraRx03bci2Vxt
         pUj7G57GEdEEyIaVzCIOKnsl8F092ArY9Z+6o1b6lC313xqfQNyf1hgyLpyCAD4/wf
         HU4oI94MKB7l1gulKhVwXlaTpFNGsjSUEBiufEnM=
Date:   Mon, 15 May 2023 14:47:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rishabh Bhatnagar <risbhat@amazon.com>
Cc:     stable@vger.kernel.org, lee@kernel.org, seanjc@google.com,
        kvm@vger.kernel.org, bp@alien8.de, mingo@redhat.com,
        tglx@linutronix.de, pbonzini@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: Re: [PATCH 0/9] KVM backports to 5.10
Message-ID: <2023051518-abroad-evaluate-6ea2@gregkh>
References: <20230510181547.22451-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510181547.22451-1-risbhat@amazon.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 10, 2023 at 06:15:38PM +0000, Rishabh Bhatnagar wrote:
> This patch series backports a few VM preemption_status, steal_time and
> PV TLB flushing fixes to 5.10 stable kernel.
> 
> Most of the changes backport cleanly except i had to work around a few
> because of missing support/APIs in 5.10 kernel. I have captured those in
> the changelog as well in the individual patches.
> 
> Earlier patch series that i'm resending for stable.
> https://lore.kernel.org/all/20220909181351.23983-1-risbhat@amazon.com/

All now queued up, thanks.

greg k-h
