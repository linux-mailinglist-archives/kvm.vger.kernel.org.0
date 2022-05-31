Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A120B539552
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 19:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346478AbiEaRQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 13:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346466AbiEaRQF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 13:16:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1AB7F8DDC9
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 10:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654017364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=V6pUruzXmeuhzTfP3xi1R0PqxtV0tLJH5RqhoH1TsApb0lUSrliYpzRKsl8vrp5fpE5RgW
        KcgibGVgpBTRtm16IGEFluoe0Vtsn+4iTKpUoMvK5P0rNJ+jQdPTPS7vnRFRZ78lXbvRzq
        Ve0aNUb5ryCE2IbEwQBv+CN+0YdK8PU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-8aL7cJt8MG-3qLfPzBHjog-1; Tue, 31 May 2022 13:16:01 -0400
X-MC-Unique: 8aL7cJt8MG-3qLfPzBHjog-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80154803D7B;
        Tue, 31 May 2022 17:16:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5736740E80E0;
        Tue, 31 May 2022 17:16:00 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, like.xu.linux@gmail.com
Subject: Re: [PATCH] KVM: x86: Bypass cpuid check for empty arch-lbr leaf
Date:   Tue, 31 May 2022 13:15:57 -0400
Message-Id: <20220531171557.293520-1-pbonzini@redhat.com>
In-Reply-To: <20220530144829.39714-1-weijiang.yang@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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


