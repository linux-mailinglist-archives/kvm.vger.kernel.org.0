Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4697ABA96
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 22:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjIVUnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 16:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjIVUnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 16:43:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7214A19E
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 13:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695415342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1nIdHypygNWNxojN8A5DqhjPAPZb13d1dR31PX0hsSg=;
        b=Po8IUPoD0EHjMPQTreDzqA5qy1MmV2wnY0Q++pUFdVzgwQzm7L/uk7O49AKu9J2cbgEMgE
        M/XTRX+m33S57R1hVBvAL5OjstZKtBFqZXl+ootMY6oraGWwZBPWgDxKfR5q877PY7v6Is
        2qkLlBlDXMU+icqCmNOMaxX3sTU4lx4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-T-as2eeDMrWCnnsQBJfkQw-1; Fri, 22 Sep 2023 16:42:16 -0400
X-MC-Unique: T-as2eeDMrWCnnsQBJfkQw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 518BB811E7D;
        Fri, 22 Sep 2023 20:42:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BE2710EE402;
        Fri, 22 Sep 2023 20:42:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pattara Teerapong <pteerapong@google.com>,
        David Stevens <stevensd@google.com>,
        Yiwei Zhang <zzyiwei@google.com>,
        Paul Hsia <paulhsia@google.com>
Subject: Re: [PATCH 0/3] KVM: x86/mmu: Drop async zapping of TDP MMU roots
Date:   Fri, 22 Sep 2023 16:40:22 -0400
Message-Id: <20230922204021.1107502-1-pbonzini@redhat.com>
In-Reply-To: <20230916003916.2545000-1-seanjc@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

I changed a bit the splitting of the patches, to avoid mixing removal
of one argument and with the addition of another (splitting into four
patches wasn't particularly enlightening for a couple lines change),
but checked that the final result is the same.

Paolo


