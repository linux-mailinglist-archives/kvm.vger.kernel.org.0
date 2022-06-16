Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CC654DFFA
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 13:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376813AbiFPL0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 07:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376681AbiFPLZ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 07:25:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DCD5E16B;
        Thu, 16 Jun 2022 04:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OFa1n6K77JzaEo8adfWBAbuXdRRnUBxjmifrmcpcPP8=; b=aLxznHPjqsmQVwNHGzEIMV/gGH
        roKRWjSnvWHpZoEyc+I2fLUFPrNPiS7genjXmY28cyL/ozF0C4h0RIiDv6PzTRonoSr2ND+CKwMmq
        46ePNMaHRTQm6+PGuM5hY6U9GhxhiyXuBVZ10g3F5ucVMj+ickYOp7sK4pbCXnYafP74ht6TlOnsr
        qsQGOAktItNmjYwrPa4zyq+YelZtPQnpgotl5uUaY5s7bqDphsHWELVX8UOZNzxlwqILMAHAiRvZV
        Q4a8uAOaZgD0Qg0JmlV8caEaw5ts4wNaAP8SSBxj/F9XDRJDcQ7RW7w+bIjPVA2NNNzWxIiR6Z/9C
        B0EwHOEg==;
Received: from dhcp-077-249-017-003.chello.nl ([77.249.17.3] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1ndG-001ttY-TX; Thu, 16 Jun 2022 11:25:51 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8B76E980DD0; Thu, 16 Jun 2022 13:25:50 +0200 (CEST)
Date:   Thu, 16 Jun 2022 13:25:50 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        seanjc@google.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com
Subject: Re: [PATCH 00/19] Refresh queued CET virtualization series
Message-ID: <YqsTPopgTHYCzCJD@worktop.programming.kicks-ass.net>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
 <Yqrzmr27siGjPB88@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqrzmr27siGjPB88@infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022 at 02:10:50AM -0700, Christoph Hellwig wrote:
> On Thu, Jun 16, 2022 at 04:46:24AM -0400, Yang Weijiang wrote:
> > The purpose of this patch series is to refresh the queued CET KVM
> > patches[1] with the latest dependent CET native patches, pursuing
> > the result that whole series could be merged ahead of CET native
> > series[2] [3].
> 
> It might be helpful to explain what CET is here..

Central European Time ofc :-)

I think it stands for Control-flow Enforcement Technology or something
along those lines, but this being Intel it loves to obfuscate stuff and
make it impossible to understand what's being said to increase the
buzzword bong hits.

Its a mostly pointless umbrella term for IBT (Indirect Branch Tracking)
and SHSTK (SHadow STacK), the first of which covers forward edge control
flow and the second covers backward edge control flow.


