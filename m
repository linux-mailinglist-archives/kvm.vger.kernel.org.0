Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CDE53A446
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 13:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352701AbiFALon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 07:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345577AbiFALol (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 07:44:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E661371A39
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 04:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654083877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jGXSzcUQXbxx0guRGMm9JRFmLU6j0niXFq1+iTNVfGw=;
        b=c+Y/ZSqVaUQb7pcp3idC9KuMc32IIJ6yFDZSiqwqmY09ipmZUMw9M+ELp7/Z6FHox8EUGa
        Wxholce3ZJE2a3ymNSHsHinUIDz8RsheI73Kk/5Xy/3amq8VwRwe5Ju/WE/cD57nXtHr7r
        3ULPZsKuEbYE1CcnTb4udGUCatH9NuE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-IFYPvtXWOWK8WPlwlCGO1Q-1; Wed, 01 Jun 2022 07:44:34 -0400
X-MC-Unique: IFYPvtXWOWK8WPlwlCGO1Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 086DD294EDED;
        Wed,  1 Jun 2022 11:44:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 881931121314;
        Wed,  1 Jun 2022 11:44:33 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Lei Wang <lei4.wang@intel.com>
Subject: Re: [PATCH v2 0/2] KVM: VMX: Sanitize VM-Entry/VM-Exit pairs during setup
Date:   Wed,  1 Jun 2022 07:44:22 -0400
Message-Id: <20220601114421.395602-1-pbonzini@redhat.com>
In-Reply-To: <20220527170658.3571367-1-seanjc@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks (minus the LBR part).

Paolo


