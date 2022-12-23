Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D61655348
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 18:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbiLWRit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Dec 2022 12:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiLWRip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Dec 2022 12:38:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E7B101C7
        for <kvm@vger.kernel.org>; Fri, 23 Dec 2022 09:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671817080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1DBpMDBnZCETkHhEpu3dbIxZ5usdNzxzwapLkbA2vrk=;
        b=BjIeUfQ4zrOv1IQ31hvekUcosGrEM9AY9ibdTvtj9eNLSsTgIly+4FBQR7iEVb0OfLD5FM
        lHqVnlPDQ2hDZTU5ZNX3NJFiucxZzAoIhOmI6gR3CmFsEXSEGtLeRR6dCt4fpNjtOafLgE
        JqNxQTQwhzEbjul2CW1sUdzhwne/BmE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-y8DDByLFN7y7FYlxozE8YQ-1; Fri, 23 Dec 2022 12:37:59 -0500
X-MC-Unique: y8DDByLFN7y7FYlxozE8YQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E568811E6E;
        Fri, 23 Dec 2022 17:37:58 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28ABE4014EB9;
        Fri, 23 Dec 2022 17:37:58 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        shuah@kernel.org, bgardon@google.com, seanjc@google.com,
        oupton@google.com, peterx@redhat.com, vkuznets@redhat.com,
        dmatlack@google.com, pgonda@google.com, andrew.jones@linux.dev
Subject: Re: [V3 PATCH 0/2] Execute hypercalls from guests according to cpu
Date:   Fri, 23 Dec 2022 12:37:34 -0500
Message-Id: <20221223173733.1624778-1-pbonzini@redhat.com>
In-Reply-To: <20221222230458.3828342-1-vannapurve@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> This series adds support of executing hypercall as per the native cpu
> type queried using cpuid instruction. CPU vendor type is stored after
> one time execution of cpuid instruction to be reused later.

Makes sense, are you going to add more patches that use the new function?

Paolo


