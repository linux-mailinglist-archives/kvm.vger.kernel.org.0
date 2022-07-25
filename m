Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7AA58023E
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 17:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235692AbiGYPyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 11:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234893AbiGYPyF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 11:54:05 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B21DF66
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 08:54:04 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E99631FD99;
        Mon, 25 Jul 2022 15:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658764442; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N8AgWb927/qdBsVSfvC1xuv0M8MXyqWLZpLRcwSlseM=;
        b=liduoMqnNWbSyYc/xvhqmd38yCX5CEp4o1IWG9HalZJyRpoFuhSseE6q9qgxFehLweXN7a
        bG1LfVdE8LV3d+Wk+GqsIWV+pC39fLvlMx3dJAtt0SAmAb5sI8Q3rvK73Eu07JDElSdzWy
        zME+yhSjFN6F9v+wNzSomSu6PzpUzys=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658764442;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N8AgWb927/qdBsVSfvC1xuv0M8MXyqWLZpLRcwSlseM=;
        b=vW7Wct8X3nYZKuWRspnNU9Lspfg/YLZ5pSt7DtDnFX4BdQz5jEVyUfmNm8lzce8vH0KOky
        L0LLC8r8j35zsWCg==
Received: from vasant-suse.fritz.box (unknown [10.163.24.178])
        by relay2.suse.de (Postfix) with ESMTP id 8C7252C171;
        Mon, 25 Jul 2022 15:54:02 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     seanjc@google.com
Cc:     Thomas.Lendacky@amd.com, bp@alien8.de, drjones@redhat.com,
        erdemaktas@google.com, jroedel@suse.de, kvm@vger.kernel.org,
        marcorr@google.com, pbonzini@redhat.com, rientjes@google.com,
        zxwang42@gmail.com, Vasant Karasulli <vkarasulli@suse.de>
Subject: Re: [kvm-unit-tests PATCH v4 00/13] x86: SMP Support for x86 UEFI Tests
Date:   Mon, 25 Jul 2022 17:53:53 +0200
Message-Id: <20220725155353.15951-1-vkarasulli@suse.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220615232943.1465490-1-seanjc@google.com>
References: <20220615232943.1465490-1-seanjc@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,
    I ran the tests on these patches and I see 8/11 subtests of
vmware_backdoors.c test fail.

But this failure is because I couldn't figure out the check parameter
/sys/module/kvm/parameters/enable_vmware_backdoor on my test machine
specified in the unittests.cfg. So this test fails also without the patch.

Rest of the tests look fine.

Thanks,
Vasant
