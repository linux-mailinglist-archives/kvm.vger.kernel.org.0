Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C214D9C52
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 14:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348728AbiCONev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 09:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348736AbiCONeq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 09:34:46 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 119556455
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 06:33:33 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7124D1474;
        Tue, 15 Mar 2022 06:33:33 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 300303F66F;
        Tue, 15 Mar 2022 06:33:32 -0700 (PDT)
Date:   Tue, 15 Mar 2022 13:33:57 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     suzuki.poulose@arm.com, mark.rutland@arm.com
Subject: [kvm-unit-tests] Adding the QCBOR library to kvm-unit-tests
Message-ID: <YjCVxT1yo0hi6Vdc@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Arm is planning to upstream tests that are being developed as part of the
Confidential Compute Architecture [1]. Some of the tests target the
attestation part of creating and managing a confidential compute VM, which
requires the manipulation of messages in the Concise Binary Object
Representation (CBOR) format [2].

I would like to ask if it would be acceptable from a license perspective to
include the QCBOR library [3] into kvm-unit-tests, which will be used for
encoding and decoding of CBOR messages.

The library is licensed under the 3-Clause BSD license, which is compatible
with GPLv2 [4]. Some of the files that were created inside Qualcomm before
the library was open-sourced have a slightly modified 3-Clause BSD license,
where a NON-INFRINGMENT clause is added to the disclaimer:

"THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE **AND NON-INFRINGEMENT**
ARE DISCLAIMED" (emphasis by me on the added clause).

The files in question include the core files that implement the
encode/decode functionality, and thus would have to be included in
kvm-unit-tests. I believe that the above modification does not affect the
compatibility with GPLv2.

I would also like to mention that the QCBOR library is also used in Trusted
Firmware-M [5], which is licensed under BSD 3-Clause.

[1] https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture
[2] https://datatracker.ietf.org/doc/html/rfc8949
[3] https://github.com/laurencelundblade/QCBOR
[4] https://www.gnu.org/licenses/license-list.html#GPLCompatibleLicenses
[5] https://git.trustedfirmware.org/TF-M/trusted-firmware-m.git/tree/lib/ext/qcbor

Thanks,
Alex
