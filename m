Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3BA52EE15
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350238AbiETOZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239775AbiETOZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:25:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ECF5A169E0B
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653056718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=V9vsLq2ZHv3itlaQMq3Wv5e6vyd87qnHUS2fKQvj7K/PAo64aeXzpOQZ8nK7/rgZqusQ0s
        vyMOtRvZ5kz5B+wvo54VUg122eiDiLKw3H6eWBkotFdweRmBUEMlxPn/tTnxoM/hb5t8nF
        RzwDDwad4kKBYVW86R54cPof8wcFHyM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-452-OqMw7BtCPaC4PmshjPNdmw-1; Fri, 20 May 2022 10:25:16 -0400
X-MC-Unique: OqMw7BtCPaC4PmshjPNdmw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0E14811E78;
        Fri, 20 May 2022 14:25:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37BF37B7C;
        Fri, 20 May 2022 14:25:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com
Subject: Re: [PATCH v2] KVM: x86/pmu: Don't pre-set the pmu->global_ctrl when refreshing
Date:   Fri, 20 May 2022 10:25:13 -0400
Message-Id: <20220520142513.3331358-1-pbonzini@redhat.com>
In-Reply-To: <20220510044407.26445-1-likexu@tencent.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


