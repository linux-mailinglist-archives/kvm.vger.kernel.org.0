Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831617125BA
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 13:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237023AbjEZLkH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 07:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243367AbjEZLkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 07:40:01 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D35A7
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 04:39:59 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1q2VnZ-006Pbe-7H
        for kvm@vger.kernel.org; Fri, 26 May 2023 13:39:57 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=j/aEUioi+r5pvmdJlqgJVrdJ4zb024hEYws87FrkwVA=; b=I1hjNH5gItY0zzWf7EV397UzCk
        sbjXZX2pcYKl5U/NR+/rHkRJmkqHvhoHZdck39pjcLxDSosxGxxRKB/6dr5cns0EWj0AoFQCbCQ56
        859EWNlFzD6zgjPgupl/z3J37+vqDhm4eQE39ahFIFXBbP4nPbq4Id2p8lbMladJ0aM2+ABt4TAzw
        PGWPBUazz+2WmtCDyJcbDjG22RhfZ/ZBp0FOM8izP9AjiqlhiXGek0hjHTS/yPuRwYNRZz+ry/GDx
        TcONMdCWFZLyfr92cUNojdcUPz4mXV4dyA8v9/QqmcyoqL26KXR4uQAxkPc5YHApK4D8cKwCdL4cA
        d5KJCq5A==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1q2VnY-0002hh-GG; Fri, 26 May 2023 13:39:56 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1q2VnF-0000hO-RK; Fri, 26 May 2023 13:39:37 +0200
Message-ID: <7f8c847e-aa4f-eda6-6f3f-8df56fc1df1b@rbox.co>
Date:   Fri, 26 May 2023 13:39:36 +0200
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH] KVM: Don't kfree(NULL) on kzalloc() failure in
 kvm_assign_ioeventfd_idx()
Content-Language: pl-PL
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org
References: <20230327175457.735903-1-mhal@rbox.co>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <20230327175457.735903-1-mhal@rbox.co>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/27/23 19:54, Michal Luczaj wrote:
> On kzalloc() failure, taking the `goto fail` path leads to kfree(NULL).
> Such no-op has no use. Move it out.

Few weeks later, a polite ping.

thanks,
Michal

