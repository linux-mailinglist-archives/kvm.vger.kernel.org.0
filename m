Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC356D8BF3
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 02:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbjDFAg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 20:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234587AbjDFAg0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 20:36:26 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BC261A5;
        Wed,  5 Apr 2023 17:36:22 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PsMxc57kcz4xFL;
        Thu,  6 Apr 2023 10:36:20 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@ozlabs.org, kvm@vger.kernel.org,
        Paul Mackerras <paulus@ozlabs.org>
Cc:     Michael Neuling <mikey@neuling.org>,
        Nick Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
In-Reply-To: <ZAgsR04beDcARCiw@cleo>
References: <ZAgsR04beDcARCiw@cleo>
Subject: Re: [PATCH 0/3] powerpc/kvm: Enable HV KVM guests to use prefixed instructions to access emulated MMIO
Message-Id: <168074126988.3672916.555286026450877376.b4-ty@ellerman.id.au>
Date:   Thu, 06 Apr 2023 10:34:29 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 08 Mar 2023 17:33:43 +1100, Paul Mackerras wrote:
> This series changes the powerpc KVM code so that HV KVM can fetch
> prefixed instructions from the guest in those situations where there
> is a need to emulate an instruction, which for HV KVM means emulating
> loads and stores to emulated MMIO devices.  (Prefixed instructions
> were introduced with POWER10 and Power ISA v3.1, and consist of two
> 32-bit words, called the prefix and the suffix.)
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/3] powerpc/kvm: Make kvmppc_get_last_inst() produce a ppc_inst_t
      https://git.kernel.org/powerpc/c/acf17878da680a0c11c0bcb8a54b4f676ff39c80
[2/3] powerpc/kvm: Fetch prefixed instructions from the guest
      https://git.kernel.org/powerpc/c/953e37397fb61be61f095d36972188bac5235021
[3/3] powerpc/kvm: Enable prefixed instructions for HV KVM and disable for PR KVM
      https://git.kernel.org/powerpc/c/a3800ef9c48c4497dafe5ede1b65d91d9ef9cf1e

cheers
