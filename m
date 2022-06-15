Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E6F54C831
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 14:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347202AbiFOMNW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 08:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347099AbiFOMNT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 08:13:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1FCA3BF76
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 05:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655295198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=gpZD+7IaROkE3M/R1p1jruWMcgFOjZbhXA8JSsXYFDc2hwfGYg/5DPbaN9WJ7TzhnCFAT/
        FZlbCCpNJXdq/afDtuQueNWnq5+etyl6oGH2RslH/qZsoqqFP82T9aT/s23SHCTLYXbSyN
        GZVxDSpoyQs48tyiUuvUrAwFfziksGU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-vaNBrGoNNXWWEQaH1DGnFg-1; Wed, 15 Jun 2022 08:13:14 -0400
X-MC-Unique: vaNBrGoNNXWWEQaH1DGnFg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FDFD3800C24;
        Wed, 15 Jun 2022 12:13:14 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EB5A2166B26;
        Wed, 15 Jun 2022 12:13:14 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Use try_cmpxchg64 in tdp_mmu_set_spte_atomic
Date:   Wed, 15 Jun 2022 08:13:05 -0400
Message-Id: <20220615121305.1662014-3-pbonzini@redhat.com>
In-Reply-To: <20220518135111.3535-1-ubizjak@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


