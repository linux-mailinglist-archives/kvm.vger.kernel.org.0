Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A5A6CA74B
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 16:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbjC0ORy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 10:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbjC0ORe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 10:17:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4107D9F
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 07:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679926422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=Dabk0TyVO2SEMBS7O9GPkVH20RURosApNgBbJWd+KV+Wcfd8bzmwqvfFfj9DdiUDUaUITz
        7XGZRtoHaeVsT+e9D0KVXXB3MTgI8dSQkYH6p0pvYKAHCQeq6+eZrkp9nyRrCaRA9sB2fk
        aK/XD+ns0gg7gKKeF9YmrO5NgApPyU4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85--YcWfJfvN5iJJkzgfBw30Q-1; Mon, 27 Mar 2023 10:13:38 -0400
X-MC-Unique: -YcWfJfvN5iJJkzgfBw30Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FE82803499;
        Mon, 27 Mar 2023 14:13:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0421140E949;
        Mon, 27 Mar 2023 14:13:36 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Dmytro Maluka <dmy@semihalf.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>, upstream@semihalf.com,
        Dmitry Torokhov <dtor@google.com>, Dong@vger.kernel.org,
        Eddie <eddie.dong@intel.com>, Dmytro Maluka <dmaluka@google.com>
Subject: Re: [PATCH v4 0/2] KVM: x86/ioapic: Fix oneshot interrupts forwarding
Date:   Mon, 27 Mar 2023 10:13:34 -0400
Message-Id: <20230327141334.3751567-1-pbonzini@redhat.com>
In-Reply-To: <20230322204344.50138-1-dmy@semihalf.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


