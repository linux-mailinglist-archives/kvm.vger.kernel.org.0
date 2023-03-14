Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9829B6B92B4
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 13:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjCNMIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 08:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjCNMH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 08:07:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F0DA0F2D
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 05:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678795500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=BbO71FAePAnaWlyX/iF6D2nKfIEH2+/xCqVrw0C7ybxF1XR99DwmuLMZ56Narb/KRWnxUb
        bd68+nhpQHJIDb2ee81aGCzm6PmWcGiJfANaYqKjwg84mH39GqkwD7rhDk+g4kCDDnKzz3
        35m4gFC0wD9/eoNygoTGbEF4C6SAZsM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-401-_vLmCImKO0yOosVUJoRggA-1; Tue, 14 Mar 2023 08:01:35 -0400
X-MC-Unique: _vLmCImKO0yOosVUJoRggA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93802101A52E;
        Tue, 14 Mar 2023 12:01:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 359534042AC9;
        Tue, 14 Mar 2023 12:01:34 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Rong Tao <rtoax@foxmail.com>
Cc:     seanjc@google.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, rongtao@cestc.cn,
        tglx@linutronix.de, x86@kernel.org
Subject: Re: [PATCH v2] KVM: VMX: Use tabs instead of spaces for indentation
Date:   Tue, 14 Mar 2023 08:01:33 -0400
Message-Id: <20230314120133.3038624-1-pbonzini@redhat.com>
In-Reply-To: <tencent._5FA492CB3F9592578451154442830EA1B02C07@qq.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


