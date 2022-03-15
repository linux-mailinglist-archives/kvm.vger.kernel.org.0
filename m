Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1164D9F15
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 16:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243793AbiCOPtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 11:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237734AbiCOPtU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 11:49:20 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BCAD39694
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 08:48:06 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4DF621474;
        Tue, 15 Mar 2022 08:48:06 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C6B43F766;
        Tue, 15 Mar 2022 08:48:04 -0700 (PDT)
Date:   Tue, 15 Mar 2022 15:48:30 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     pbonzini@redhat.com, drjones@redhat.com,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        suzuki.poulose@arm.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests] Adding the QCBOR library to kvm-unit-tests
Message-ID: <YjC1TsFlZeTAeyYD@monolith.localdoman>
References: <YjCVxT1yo0hi6Vdc@monolith.localdoman>
 <b1d5e4b7-c07c-0e34-ef6d-58aab19a41b2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1d5e4b7-c07c-0e34-ef6d-58aab19a41b2@redhat.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Mar 15, 2022 at 03:21:39PM +0100, Thomas Huth wrote:
> On 15/03/2022 14.33, Alexandru Elisei wrote:
> > Hi,
> > 
> > Arm is planning to upstream tests that are being developed as part of the
> > Confidential Compute Architecture [1]. Some of the tests target the
> > attestation part of creating and managing a confidential compute VM, which
> > requires the manipulation of messages in the Concise Binary Object
> > Representation (CBOR) format [2].
> > 
> > I would like to ask if it would be acceptable from a license perspective to
> > include the QCBOR library [3] into kvm-unit-tests, which will be used for
> > encoding and decoding of CBOR messages.
> > 
> > The library is licensed under the 3-Clause BSD license, which is compatible
> > with GPLv2 [4]. Some of the files that were created inside Qualcomm before
> > the library was open-sourced have a slightly modified 3-Clause BSD license,
> > where a NON-INFRINGMENT clause is added to the disclaimer:
> > 
> > "THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
> > WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
> > MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE **AND NON-INFRINGEMENT**
> > ARE DISCLAIMED" (emphasis by me on the added clause).
> > 
> > The files in question include the core files that implement the
> > encode/decode functionality, and thus would have to be included in
> > kvm-unit-tests. I believe that the above modification does not affect the
> > compatibility with GPLv2.
> 
> IANAL, but I think it should be ok to add those files to the kvm-unit-tests.
> With regards to the "non-infringement" extension, it seems to be the one
> mentioned here: https://enterprise.dejacode.com/licenses/public/bsd-x11/ ...
> and on the "license condition" tab they mention that it is compatible with
> the GPL. On gnu.org, they list e.g. the
> https://www.gnu.org/licenses/license-list.html#X11License which also
> contains a "non-infringement" statement, so that should really be
> compatible.

Thanks you for the links, I wasn't aware of them. They further confirm that
QCBOR is indeed compatible with GPLv2.

Thanks,
Alex

> 
>  Thomas
> 
