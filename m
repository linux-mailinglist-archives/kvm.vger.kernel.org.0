Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A1458A974
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 12:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240566AbiHEK0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 06:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240543AbiHEK0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 06:26:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6323B1F2DD
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 03:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659695199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=F2D8KXUSP/3mmKFE1o7ZiqLtcvMblmlqEVcDP6oMPQ3IRL+YdJ2mPTpMHLw6kr/8At7NvJ
        9klgJU9l0n0vvhs6bXrh3Y0QzOJ6WePGs0Gq2whOb+jwBQYYZGyISjuvWQ24ZYKCX/luS8
        7lsdgAwd3w+5NrXBa+72z8ox6ZGrBoE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-5a5Bq0vINuulVWWeCTUw7g-1; Fri, 05 Aug 2022 06:26:34 -0400
X-MC-Unique: 5a5Bq0vINuulVWWeCTUw7g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 097F585A585;
        Fri,  5 Aug 2022 10:26:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89D9E2026D4C;
        Fri,  5 Aug 2022 10:26:33 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, joro@8bytes.org, wanpengli@tencent.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: X86: Explicitly set the 'fault.async_page_fault' value in kvm_fixup_and_inject_pf_error().
Date:   Fri,  5 Aug 2022 06:26:31 -0400
Message-Id: <20220805102631.1423861-1-pbonzini@redhat.com>
In-Reply-To: <20220718074756.53788-1-yu.c.zhang@linux.intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


