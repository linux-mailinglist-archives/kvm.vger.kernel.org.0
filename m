Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37EAF59969D
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 10:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347372AbiHSIAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 04:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347355AbiHSIAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 04:00:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D73CE3C3F
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 01:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660896033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=GGAwjUFO86txiU56i9ZVtCgtQi6h11kq2UdnQk9a0wOSZq/BX1vHjzpA+6c7fyvtMrBYHA
        9TE7wzOLh00OMvlb5fqMoRwAgUyeUmTiNs/B3s3iCKuqb+BrEPEphw7ZKzV97wuBwAGXo2
        NAq665LBzuYV9djrE/dDJDZH0Fno4Q8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-472-bnpzuPYKOIyzKT_4YXZnTw-1; Fri, 19 Aug 2022 04:00:27 -0400
X-MC-Unique: bnpzuPYKOIyzKT_4YXZnTw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 946A1101A54E;
        Fri, 19 Aug 2022 08:00:27 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDF4C2026985;
        Fri, 19 Aug 2022 08:00:23 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Li kunyu <kunyu@nfschina.com>
Cc:     seanjc@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH v2] KVM: Drop unnecessary initialization of "ops" in kvm_ioctl_create_device() initialized and assigned, it is used after assignment
Date:   Fri, 19 Aug 2022 04:00:23 -0400
Message-Id: <20220819080023.2328382-1-pbonzini@redhat.com>
In-Reply-To: <20220819021535.483702-1-kunyu@nfschina.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


