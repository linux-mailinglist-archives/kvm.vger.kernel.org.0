Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE9170F87C
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 16:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbjEXOSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 10:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbjEXOSe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 10:18:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EE412F
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 07:18:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FECF6328C
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 14:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90608C433D2;
        Wed, 24 May 2023 14:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684937909;
        bh=iPu+cmPH/20drEbzpurGyw6T9vj1hYqEynqQowFUtSM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oeuzeFJcKbpQDqq2PHqkKg1JzsViwGv7DRgg7t2qDAzQBIV54G7DXhj2L8tioHhLz
         TbVh6oVV//GNiz6rfsG+9Y33hi8rtHgwvE0evFwhMaUF6aZORNbkPbU79dXrXtzKh4
         kOTCiUBF/JTWPPwNNltEGkKbUvhgMoAiYZeyFgenwcKPwgQHE5G5TXqwlOzs+tExHl
         /uFiuDBwANAVLgRw0hYkTGmqsdhefQGrwGqGCx8lL770cs6cx6Q3KGe1urc5bg1w9A
         Ye0MkH/X4d+dz8SqFuX1NRCa9AH9GIXBT7NPFGzeL2wv4wpXV/Z9Ij2ZRae11mLtDY
         Yyk8hhFz3F1Ig==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q1pJr-0003gu-46;
        Wed, 24 May 2023 15:18:27 +0100
MIME-Version: 1.0
Date:   Wed, 24 May 2023 15:18:26 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: Re: [GIC PULL] KVM/arm64 fixes for 6.4, take #2
In-Reply-To: <20230524125757.3631091-1-maz@kernel.org>
References: <20230524125757.3631091-1-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <e6baaa4dbb813cd46c41d079154e3e15@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, cohuck@redhat.com, tabba@google.com, jean-philippe@linaro.org, oliver.upton@linux.dev, qperret@google.com, steven.price@arm.com, will@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-05-24 13:57, Marc Zyngier wrote:
> Paolo,
> 
> Here's the second batch of fixes for 6.4: two interesting MMU-related
> fixes that affect pKVM, a set of locking fixes, and the belated
> emulation of Set/Way MTE CMO.

OK, $subject is an indication of what's on my mind...

But please pull anyway!

         M.
-- 
Jazz is not dead. It just smells funny...
