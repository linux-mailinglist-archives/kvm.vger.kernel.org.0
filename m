Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618C85BBAD0
	for <lists+kvm@lfdr.de>; Sun, 18 Sep 2022 00:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiIQWP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Sep 2022 18:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiIQWPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Sep 2022 18:15:55 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1342A40C
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 15:15:54 -0700 (PDT)
Date:   Sat, 17 Sep 2022 22:15:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663452952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bd3sEPoVSDCUAiGaLQLdpHOpOUlA4arxIg/OmjMFbsY=;
        b=KUA3uev4VXU68yP+xFPvAVZdlFTdSjbn43CFxnswecUdBlsbHWjL8Th+AFJuEAZFltTgA6
        IlCIydQMtL5NFY1cmahkrl84nM9WsxwWbhlCHaAz7WNwWBd7WFiisb6URSNJ0GuBnmj0aK
        2n3LlR4WYKBoaAvJd/TgJHA2mfheFHY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, alexandru.elisei@arm.com, eric.auger@redhat.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v6 02/13] KVM: selftests: aarch64: Add virt_get_pte_hva()
 library function
Message-ID: <YyZHFPCqnlk4PbcO@google.com>
References: <20220906180930.230218-1-ricarkol@google.com>
 <20220906180930.230218-3-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906180930.230218-3-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022 at 06:09:19PM +0000, Ricardo Koller wrote:
> Add a library function to get the PTE (a host virtual address) of a
> given GVA.  This will be used in a future commit by a test to clear and
> check the access flag of a particular page.
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
