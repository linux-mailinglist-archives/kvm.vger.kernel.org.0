Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98E07ABB0B
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 23:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjIVV1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 17:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjIVV1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 17:27:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07F3CA
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 14:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695418007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=makqFmzriWHzRFEQqiRtYLztxtDFQhok61IdEbRa/ho=;
        b=ZB+MFvCyZFozmE9It5lzF7+JNZoAtc/MIqvWI81be3++8/bmt65vR8287d1sb1lOTelMSY
        ie2TnfDCVLmwoR1r2E8WxFZmmtG6wd77Y9E6NcFcGzVwymDnxG0xxw/BfUXijItozt0js8
        K1aookDOXpyYNB3uDopNJSvE0VT9I/A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-8ndgFOH1N4SgOrxI_iqsFw-1; Fri, 22 Sep 2023 17:26:42 -0400
X-MC-Unique: 8ndgFOH1N4SgOrxI_iqsFw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66C48801779;
        Fri, 22 Sep 2023 21:26:41 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01BA449BB9A;
        Fri, 22 Sep 2023 21:26:40 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Babu Moger <babu.moger@amd.com>
Subject: Re: [PATCH v2 0/3] SEV-ES TSC_AUX virtualization fix and optimization
Date:   Fri, 22 Sep 2023 17:24:55 -0400
Message-Id: <20230922212453.1115016-1-pbonzini@redhat.com>
In-Reply-To: <cover.1694811272.git.thomas.lendacky@amd.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.  The part that stood out in patch 2 is the removal of
svm_clr_intercept(), which also applies when the initialization is done
in the wrong place.  Either way, svm_clr_intercept() is always going
to be called by svm_recalc_instruction_intercepts() if guest has the
RDTSC bit in its CPUID.

So I extracted that into a separate patch and squashed the rest of
patch 2 into patch 1.

Paolo


