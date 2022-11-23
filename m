Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE630635F17
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 14:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238614AbiKWNNq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 08:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238619AbiKWNNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 08:13:23 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8528E0B0
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 04:55:07 -0800 (PST)
Date:   Wed, 23 Nov 2022 13:54:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669208078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tsK38l3AhsP6NdHw5Lix6ivzC+epX3dppdiSZqw9bEU=;
        b=eeTSqiA4+fmbywy4mnXibUOe6ftmz70Z2exD2Z+z2w5ErICowb6vhy1CIq8/C9hPniTNVv
        7N0lbKKTLy2mjvx6Q0+119o1FvhTuFxMd/E8/hdxwE9gh14BW8GUcsWsUTzi2SABem/CO2
        kTmOkwCBvF9Ctw3rBzUAEVR6k1WSFYc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 11/27] lib: Add random number generator
Message-ID: <20221123125428.d3hp6cinszoty2bg@kamzik>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
 <20221122161152.293072-12-mlevitsk@redhat.com>
 <20221123102850.08df4bd9@p-imbrenda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123102850.08df4bd9@p-imbrenda>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022 at 10:28:50AM +0100, Claudio Imbrenda wrote:
> On Tue, 22 Nov 2022 18:11:36 +0200
> Maxim Levitsky <mlevitsk@redhat.com> wrote:
> 
> > Add a simple pseudo random number generator which can be used
> > in the tests to add randomeness in a controlled manner.
> 
> ahh, yes I have wanted something like this in the library for quite some
> time! thanks!

Here's another approach that we unfortunately never got merged.
https://lore.kernel.org/all/20211202115352.951548-5-alex.bennee@linaro.org/

Thanks,
drew
