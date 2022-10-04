Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2705F4A9A
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 23:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiJDVCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 17:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiJDVCw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 17:02:52 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9415565567
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 14:02:51 -0700 (PDT)
Date:   Tue, 4 Oct 2022 21:02:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664917369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=ZZPNPYzSVNBZuhnGB7CrCaQRRGaAvl+BMTJQ2z40OX0=;
        b=lNRjK2gvnV2+LQrnimaTqv2eY7/OBYwVSyLWUrjWNP6Ezl1kVhSJW1hOjl72cjEngiHhx4
        R1YdpsVkyvRMGPH1j6jssUyE0XuHysQ7bNmcA76PJFjJXCSAOuGVX6Vuo8JigZagfYRwN/
        5/CjJHfZqneXs66O33qwXrMToAJnw+g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     pbonzini@redhat.com
Cc:     maz@kernel.org, seanjc@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu
Subject: arm64 build failure on kvm/next
Message-ID: <YzyfcIyudmSzTKx/@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Paolo,

Just wanted to give you a heads up about a build failure on kvm/next.
Marc pulled some of the sysreg refactoring updates from core arm64 to
resolve a conflict, which resulted in:

drivers/perf/arm_spe_pmu.c:677:7: error: use of undeclared identifier 'ID_AA64DFR0_PMSVER_8_2'
        case ID_AA64DFR0_PMSVER_8_2:
             ^
drivers/perf/arm_spe_pmu.c:679:7: error: use of undeclared identifier 'ID_AA64DFR0_PMSVER_8_3'
        case ID_AA64DFR0_PMSVER_8_3:
             ^
drivers/perf/arm_spe_pmu.c:961:10: error: use of undeclared identifier 'ID_AA64DFR0_PMSVER_SHIFT'
                                                   ID_AA64DFR0_PMSVER_SHIFT);

The fix has since gone in on the arm64 side [1], in case you want to
mention in your pull request.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/commit/?h=for-next/sysreg&id=db74cd6337d2691ea932e36b84683090f0712ec1

--
Thanks,
Oliver
