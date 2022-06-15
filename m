Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CB754C867
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 14:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348727AbiFOMYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 08:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347202AbiFOMYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 08:24:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6E9E3A702
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 05:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655295862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=dOSaT2jnkvPhV0Ceex9RAJpqHtoY39GmCWiRSeD42qSp611E1Mcwu0AgyJ/0ueB4fL5HK8
        WzSnb4iZykwJ0JuoR0MqFhV2UqTpuHlGJTpJwe1DlsRe4xWkfmdPHR/oIhu9R+b11L1ghV
        3oO9NwBnnOkm4giV0wTtfjLQ5YQTFiE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-VkQrQLSLMi-2zNEgUK3Qbg-1; Wed, 15 Jun 2022 08:24:15 -0400
X-MC-Unique: VkQrQLSLMi-2zNEgUK3Qbg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 451EC8339A8;
        Wed, 15 Jun 2022 12:24:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AC451678F;
        Wed, 15 Jun 2022 12:24:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Dmitry Klochkov <kdmitry556@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Raspl <raspl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH RESEND] tools/kvm_stat: fix display of error when multiple processes are found
Date:   Wed, 15 Jun 2022 08:14:27 -0400
Message-Id: <20220615121427.1662350-1-pbonzini@redhat.com>
In-Reply-To: <20220614121141.160689-1-kdmitry556@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


