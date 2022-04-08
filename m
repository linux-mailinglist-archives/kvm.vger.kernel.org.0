Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15AC4F9AFD
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 18:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbiDHQvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 12:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbiDHQvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 12:51:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE0995881E
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 09:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649436538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=YezlpAEJrR26f7ki9s6KK1FU33THzwkP9TUYSVrAh0ZORbpI9iKNuTSJEpBeL5xSqy6Bbu
        16Z1eVM9UFK5FdGW41qSsXf9NR3z8O9qmImQtMdsDACFe7WuZ1YvcpHeFq0EaAcQEbYo8D
        2Rrpfu6NdcB/mijgZWBCCaiRAs1+h7g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-1TMHREpTNeC-sm8_fYSK1w-1; Fri, 08 Apr 2022 12:48:53 -0400
X-MC-Unique: 1TMHREpTNeC-sm8_fYSK1w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 127973C1411E;
        Fri,  8 Apr 2022 16:48:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4F7DC57961;
        Fri,  8 Apr 2022 16:48:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     SU Hang <darcy.sh@antgroup.com>
Cc:     seanjc@google.com, kvm@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] KVM: x86: Replace magic number with readable macro
Date:   Fri,  8 Apr 2022 12:48:43 -0400
Message-Id: <20220408164842.467556-1-pbonzini@redhat.com>
In-Reply-To: <20220329030108.97341-1-darcy.sh@antgroup.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


