Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D37E63DC7C
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 18:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiK3RzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 12:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiK3RzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 12:55:24 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30754909C
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 09:55:22 -0800 (PST)
Date:   Wed, 30 Nov 2022 17:55:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669830921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WvMnOm27hTm0njYUBgyRxdVqValbhMfEeJozYL2mKKM=;
        b=k9v0DrYLKAryL9ShEK9gk28Lig/0/NcWEJtSloDFtIMIYs1vh480CKP58S4o2ppEiYOjMy
        G/akSP0bT8Qc91q4Rpbjxaitep+/PzFoAW9Qqlnv5kc0d98rNjFNwdLdsK2rypAaVftQ/e
        g576qlG1WodpH4JMJ6UqtktscdAGCv4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, seanjc@google.com, ricarkol@google.com
Subject: Re: [PATCH v10 0/4] randomize memory access of dirty_log_perf_test
Message-ID: <Y4eY/Yjj+FP+vf7Y@google.com>
References: <20221107182208.479157-1-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107182208.479157-1-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 07, 2022 at 06:22:04PM +0000, Colton Lewis wrote:
> Add the ability to randomize parts of dirty_log_perf_test,
> specifically the order pages are accessed and whether pages are read
> or written.
> 
> v10:
> 
> Move setting default random seed to argument parsing code.
> 
> Colton Lewis (4):
>   KVM: selftests: implement random number generator for guest code
>   KVM: selftests: create -r argument to specify random seed
>   KVM: selftests: randomize which pages are written vs read
>   KVM: selftests: randomize page access order

Does someone want to pick this up for 6.2? Also, what tree are we
routing these architecture-generic selftests changes through, Paolo's?

--
Thanks,
Oliver
