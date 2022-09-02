Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8225AB35D
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 16:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237810AbiIBOXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 10:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237034AbiIBOXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 10:23:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BEEE1AB7
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 06:49:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90AF162123
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 13:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31660C433C1;
        Fri,  2 Sep 2022 13:49:22 +0000 (UTC)
Date:   Fri, 2 Sep 2022 14:49:18 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH v3 7/7] Documentation: document the ABI changes for
 KVM_CAP_ARM_MTE
Message-ID: <YxIJ3hRxAD4vM/jo@arm.com>
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-8-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810193033.1090251-8-pcc@google.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022 at 12:30:33PM -0700, Peter Collingbourne wrote:
> Document both the restriction on VM_MTE_ALLOWED mappings and
> the relaxation for shared mappings.
> 
> Signed-off-by: Peter Collingbourne <pcc@google.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
