Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB11C652278
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbiLTO0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbiLTO0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:26:16 -0500
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AC0E0EB
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:26:13 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1p7dZI-00DxyV-PD; Tue, 20 Dec 2022 15:26:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=pJsLiH/Bq4ZI1WK3S/TY3BMKqDEg1Fx4XX0g1y08k3s=; b=gtew5pSs925ekgbhWHAUXtO2LP
        2UIsNtiTvJ2AMP5qTh3mslCMHvXyz1LxvRybp500YmwuBy2Vv4viBVvJ/TS2Leu5c7Ebd+EwgTisI
        i0yo2LHiTX3AWgEVNq9emh+BcMx0oOccuALftYC4IgUc3H/tvVOkWV6vsuKP3izInCoUUassI9/AZ
        SPkQB4iVF9W/FS5ac5z1YlgQ4g+CD9zdNJK4VCg1hcyCQLBtucFi/W//dHR3qZdp6Ky2yRSvQKinB
        xOXZM9s0h0YQp0oYTfk0l7UPk3yJ9+/TRl2nUG41JF/c54jeseiS+lfWsAsKtUtpsW/ZmObIyTUdV
        JRdgPjhQ==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1p7dZH-0005jx-7k; Tue, 20 Dec 2022 15:26:07 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1p7dZ5-00083P-Jr; Tue, 20 Dec 2022 15:25:55 +0100
Message-ID: <53159d2b-edcd-d9bd-b7a0-e72463e901cc@rbox.co>
Date:   Tue, 20 Dec 2022 15:25:54 +0100
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH] KVM: x86/xen: Fix memory leak in
 kvm_xen_write_hypercall_page()
Content-Language: pl-PL, en-GB
To:     Paul Durrant <xadimgnik@gmail.com>, kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, seanjc@google.com, pbonzini@redhat.com
References: <20221216005204.4091927-1-mhal@rbox.co>
 <94fb9782-816d-e7a1-81f2-b5a3fa563bbd@xen.org>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <94fb9782-816d-e7a1-81f2-b5a3fa563bbd@xen.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/20/22 15:10, Paul Durrant wrote:
> I'd prefer dropping this hunk...
> ...

Sure, sending v2.

Should I use your @xen.org or @gmail.com for suggested-by tag?

thanks,
Michal

