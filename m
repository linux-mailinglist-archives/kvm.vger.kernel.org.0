Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC2F5595D7
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 10:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiFXIzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 04:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiFXIzM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 04:55:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93CCF37BEA
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 01:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656060910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=I4kCsYEkIPPJaZSSMPUiXQgRVoXr5gRZyLj7AOkcKhSJ81qOl+xYqeaOq25Sji9IfYxUjA
        BVCnTinFtLoRnJ6LK30MWvEz6nedJgY0DZxbGyfnW7Iun9tpcA5U7pEYz/pTYJILc3K/KN
        +G7utQC0ZNiyKeEKuEo/5jOO3ySMZII=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-8kQPj_gwPha5AfRxe-hGEg-1; Fri, 24 Jun 2022 04:55:08 -0400
X-MC-Unique: 8kQPj_gwPha5AfRxe-hGEg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B6A61C06915;
        Fri, 24 Jun 2022 08:55:07 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3893C53360;
        Fri, 24 Jun 2022 08:55:06 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com,
        thuth@redhat.com, alexandru.elisei@arm.com, alex.bennee@linaro.org,
        andre.przywara@arm.com, nikos.nikoleris@arm.com,
        ricarkol@google.com, seanjc@google.com, maz@kernel.org,
        peter.maydell@linaro.org
Subject: Re: [PATCH kvm-unit-tests] MAINTAINERS: Change drew's email address
Date:   Fri, 24 Jun 2022 04:55:06 -0400
Message-Id: <20220624085506.2731362-1-pbonzini@redhat.com>
In-Reply-To: <20220623131017.670589-1-drjones@redhat.com>
References: 
MIME-Version: 1.0
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


