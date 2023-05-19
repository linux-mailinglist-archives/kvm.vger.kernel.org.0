Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5759709AA3
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 16:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbjESO4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 10:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjESO4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 10:56:45 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7906AD;
        Fri, 19 May 2023 07:56:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id E04A2536;
        Fri, 19 May 2023 14:56:43 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net E04A2536
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1684508204; bh=+8dnhWvT8xWTc+DrDCFvScQBdsviY9YjB6s+sI8HUvc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=L+b+Q5sXl2HTraCDQ0MoereBFTIy3uLvPLJkigrFOh2vtoUoNnPGmrHnMyU/z4vW7
         BzrsSprcEXNDX2GZdclkKTeXyla2WJLJlIQt6FiO1Gbw1bI2b7sfzyym0eSh1w1Vj7
         +o2J6pGHZ82seeHeNy4A0GbgBUwLer/74StqvFLbk+cZonkuMMKn357KL2Ym4RImpP
         whi914Gxm1+DQntvECjwKZ1dgN89OEyRtTXeC/haag0E1htRvfTXqUjOPSOuiNeNkH
         Vi7IeD9FUUqyG5LgOZGmDarx/a5xSYaGtHJfI4WfrTkDalTg35PL2trbNlHwwsgJJO
         oYgYevZONljTQ==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Yan-Jie Wang <yanjiewtw@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Avi Kivity <avi@redhat.com>,
        Yan-Jie Wang <yanjiewtw@gmail.com>,
        Ching-Chun Huang <jserv@ccns.ncku.edu.tw>, trivial@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2] docs: clarify KVM related kernel parameters'
 descriptions
In-Reply-To: <20230503081530.19956-1-yanjiewtw@gmail.com>
References: <20230502112502.14859-1-yanjiewtw@gmail.com>
 <20230503081530.19956-1-yanjiewtw@gmail.com>
Date:   Fri, 19 May 2023 08:56:43 -0600
Message-ID: <87bkignzdg.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yan-Jie Wang <yanjiewtw@gmail.com> writes:

> The descriptions of certain KVM related kernel parameters can be
> confusing. They state "Disable ...," which may make people think that
> setting them to 1 will disable the associated feature when in fact the
> opposite is true.
>
> This commit addresses this issue by revising the descriptions of these
> parameters by using "Control..." rather than "Enable/Disable...".
> 1==enabled or 0==disabled can be communicated by the description of
> default value such as "1 (enabled)" or "0 (disabled)".
>
> Also update the description of KVM's default value for kvm-intel.nested
> as it is enabled by default.
>
> Signed-off-by: Yan-Jie Wang <yanjiewtw@gmail.com>
> ---
> Changes in v2:
> - Revise the descriptions based on Sean's suggesstion.
> - Fix the wrong default value of kvm-intel.nested
> ---
>  .../admin-guide/kernel-parameters.txt         | 53 ++++++++++---------
>  1 file changed, 29 insertions(+), 24 deletions(-)

Applied, thanks.

jon
