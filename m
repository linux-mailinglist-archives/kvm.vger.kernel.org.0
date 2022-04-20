Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C9550867C
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 12:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359158AbiDTLAn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 07:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352390AbiDTLAm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 07:00:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0385B4091A
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 03:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650452276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v6/dCRQTvN7OCrvR2+2G8Gzp/UxSEBYxyF7On5Tf+zk=;
        b=Vw64he13OTdmzNRBr0hJyBEMYH87BKAwA07rufmWlG+ZOKXVoNhXloZfDLP8qt9DJQezSs
        YHCeySSGJCMyu/a4fyAO9vZz6bBftQlWfbLtYrVh8fLm9sce5KFXTf/2iKoenUQTPwMT4C
        zgfPRt24J7yGQ8BsnkVH+VKA0snm/6Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-p29IOCP5MpSD7RGlpmPEAw-1; Wed, 20 Apr 2022 06:57:52 -0400
X-MC-Unique: p29IOCP5MpSD7RGlpmPEAw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BA581014A60;
        Wed, 20 Apr 2022 10:57:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77E5341136E0;
        Wed, 20 Apr 2022 10:57:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: clean up comments
Date:   Wed, 20 Apr 2022 06:57:24 -0400
Message-Id: <20220420105723.1145095-1-pbonzini@redhat.com>
In-Reply-To: <20220410153840.55506-1-trix@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued with a slightly edited commit message:

    KVM: SPDX style and spelling fixes
    
    SPDX comments use use /* */ style comments in headers anad
    // style comments in .c files.  Also fix two spelling mistakes.
    
    Signed-off-by: Tom Rix <trix@redhat.com>
    Message-Id: <20220410153840.55506-1-trix@redhat.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks,

Paolo

