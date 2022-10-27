Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693B960F3F9
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 11:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbiJ0Jrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 05:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbiJ0Jry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 05:47:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D039638A
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 02:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666864072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=ebF83Te2cqoic6J+cvHO8dp+s35ItKrXh1AAKyDgM9B77ngtnh53POt3XpxsDioouqNPo9
        C4/bS1msCGRZYBH/8uvrPKtx6yus8X31kyT57s1RzUGMiGegQGd5uEKOq5zVq3mPGUy7Tu
        zu7DWVjjM7UCzd1XoAo11soi/CajUF0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-5xTLsLP3PPK-CLEbwH8FpQ-1; Thu, 27 Oct 2022 05:47:46 -0400
X-MC-Unique: 5xTLsLP3PPK-CLEbwH8FpQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFE913C0F424;
        Thu, 27 Oct 2022 09:47:45 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 232E32166B26;
        Thu, 27 Oct 2022 09:47:45 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Carlos Bilbao <carlos.bilbao@amd.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, venu.busireddy@oracle.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas.Lendacky@amd.com, bilbao@vt.edu
Subject: Re: [PATCH] KVM: SVM: Name and check reserved fields with structs offset
Date:   Thu, 27 Oct 2022 05:47:43 -0400
Message-Id: <20221027094743.2702214-1-pbonzini@redhat.com>
In-Reply-To: <20221024164448.203351-1-carlos.bilbao@amd.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


