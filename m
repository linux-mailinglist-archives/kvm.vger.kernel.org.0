Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFCC590D11
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 09:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbiHLH6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 03:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236856AbiHLH6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 03:58:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ECAD0A74E8
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 00:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660291082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=Dt1YJNSDwuJhmBvB39wFq9zNm5CajvAC3TTriw1+gqYuRYzPXNZSeE0TVhsQckkPM5eC1h
        N+YvltnDA4eI4H+y4aaxhmpFCrEidfP9TJ1ujvzKzmUqyceax/b4U6ikPz0qJVntmERJOA
        I0hsqwG+oytW3Kdu8A/XZvY+ZQ1InMo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-wYhUwBXkMG6aR_wEZinyvg-1; Fri, 12 Aug 2022 03:58:01 -0400
X-MC-Unique: wYhUwBXkMG6aR_wEZinyvg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46122185A7A4;
        Fri, 12 Aug 2022 07:58:01 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24BFAC15BA9;
        Fri, 12 Aug 2022 07:58:01 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: VMX: Heed the 'msr' argument in msr_write_intercepted()
Date:   Fri, 12 Aug 2022 03:57:59 -0400
Message-Id: <166029101189.410868.9549225697702439207.b4-ty@redhat.com>
In-Reply-To: <20220810213050.2655000-1-jmattson@google.com>
References: <20220810213050.2655000-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo

