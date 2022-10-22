Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C42A608C8D
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 13:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiJVL1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 07:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiJVL0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 07:26:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A89B2BB0A
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 04:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666436481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=Vqp6mZUD1Ws0srbSvdlJ5MjtVcbmpbHim6SMNo34R1Pjlo9KhOSvlhNO3ima8+6v/zWfb6
        zxFlSps4+ssTHrFL6+YEaAZr/71RawLKrNKfPAev8DqBitW9r/CjvmpfDBK7d2LOzWW3dM
        +TA/dPmWJH6raaxn97HVf/LF/eO0Bwk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-foRoI9UCNGWH0YUdhaGeGA-1; Sat, 22 Oct 2022 04:41:50 -0400
X-MC-Unique: foRoI9UCNGWH0YUdhaGeGA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD10B185A7AC;
        Sat, 22 Oct 2022 08:41:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 344401401C20;
        Sat, 22 Oct 2022 08:41:43 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Palmer Dabbelt <palmer@rivosinc.com>
Cc:     anup@brainfault.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH] MAINTAINERS: git://github -> https://github.com for kvm-riscv
Date:   Sat, 22 Oct 2022 04:41:40 -0400
Message-Id: <20221022084140.1726796-1-pbonzini@redhat.com>
In-Reply-To: <20221013214638.30974-1-palmer@rivosinc.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


