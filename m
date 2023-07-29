Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE633768032
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 16:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbjG2O6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Jul 2023 10:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjG2O6H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Jul 2023 10:58:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145F33A85
        for <kvm@vger.kernel.org>; Sat, 29 Jul 2023 07:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690642640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gBJhzy7LmnD6APAR45BuDH9aOjTqMcLkp+ipwdaJHbY=;
        b=eFwrnrrpLs5tDE0XDlnQyfYtIzQk8TsGWgi85RcWyaqf5zCusd4w7ZJdLcVnhEoOEizWum
        c6alLNI8Gr7iA8chQX9cZ6xjP5+hzvehP7Z1/2Z+s3YoBjdaiBomHfgw492aZGj23M8PCz
        WjbAamFqstb2iXTnoanWuySvEJMZxf4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-Uh2YmgxvMkaB1wVAWzQm6w-1; Sat, 29 Jul 2023 10:57:16 -0400
X-MC-Unique: Uh2YmgxvMkaB1wVAWzQm6w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF23A858F1E;
        Sat, 29 Jul 2023 14:57:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3695492B02;
        Sat, 29 Jul 2023 14:57:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: VMX: Drop manual TLB flush when migrating vmcs.APIC_ACCESS_ADDR
Date:   Sat, 29 Jul 2023 10:56:46 -0400
Message-Id: <20230729145645.2690090-1-pbonzini@redhat.com>
In-Reply-To: <20230721233858.2343941-1-seanjc@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> In other words, KVM does flush in this case, it just does so earlier
> on while handling the page migration.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

but not 6.5 material, so I'm leaving this to you.

Paolo


