Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20D857FCFD
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 12:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbiGYKHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 06:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233220AbiGYKHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 06:07:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38D94113C
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 03:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658743621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=S7xWVDexFYR211X2bgxxOGXzV8jycX6b6pDe/MrhYWzwtAThJElUaI/B7vruJxHeuRffsS
        kbqm5NrIzhyB9ORXHBb9J3VmUXDqUx6TV3dIAZmdvu7KyiFiDN+Z4GbefJN8NxgcWXMsK9
        5g7oXkmYONzafZV0Ky+Y4gEncfIGiyE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-h_YIiwZKPc-fJ8Dfp3y4jg-1; Mon, 25 Jul 2022 06:06:57 -0400
X-MC-Unique: h_YIiwZKPc-fJ8Dfp3y4jg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C800800124;
        Mon, 25 Jul 2022 10:06:57 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4ABC492C3B;
        Mon, 25 Jul 2022 10:06:56 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        jon.grimm@amd.com, Zeng Guang <guang.zeng@intel.com>
Subject: Re: [PATCH v2] KVM: x86: Do not block APIC write for non ICR registers
Date:   Mon, 25 Jul 2022 06:06:53 -0400
Message-Id: <20220725100653.168981-1-pbonzini@redhat.com>
In-Reply-To: <20220725053356.4275-1-suravee.suthikulpanit@amd.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


