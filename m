Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5A4717D4A
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 12:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbjEaKlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 06:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbjEaKli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 06:41:38 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 59288121
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 03:41:35 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78F8B1042;
        Wed, 31 May 2023 03:42:20 -0700 (PDT)
Received: from [10.57.22.98] (unknown [10.57.22.98])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 811493F67D;
        Wed, 31 May 2023 03:41:34 -0700 (PDT)
Message-ID: <100579b3-649b-a57c-8639-edc6b22c7646@arm.com>
Date:   Wed, 31 May 2023 11:41:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Content-Language: en-GB
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: [kvm-unit-tests] arm/arm64: psci_cpu_on_test failures with tcg
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Andrew Jones <andrew.jones@linux.dev>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I noticed that in the latest master the psci_cpu_on_test fails randomly 
for both arm and arm64 with tcg.

If I do:

$> for i in `seq 1 100`; do ACCEL=tcg MAX_SMP=8 ./run_tests.sh psci; 
done | grep FAIL

About 10 of the 100 runs fail for the arm and arm64 builds of the test. 
I had a look and I am not sure I understand why. When I run the test 
with kvm, I don't get any failures. Does anyone have an idea what could 
be causing this?

Thanks,

Nikos
