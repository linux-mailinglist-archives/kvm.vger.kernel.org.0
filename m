Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223BA5A84E6
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 20:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbiHaSBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 14:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiHaSBq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 14:01:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E790BC6962
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 11:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661968905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rk0SIObkGc/OzoHqCX/ztgHsCZlml4ew8HfMbq2hEx8=;
        b=HUBf2UMv9x0ydgDtWwel1wYn55EZANCjDtWFGJMDCfH+nNWNi4qNBqQ5QNyPK/H1bSR1B/
        7qiFO8+sKoEmCmScr1danzQN5ZHxzjADqrRPwtxpXzNaFvAS52lE5xvFK2iIhfgPf9/wfh
        c3PK88WgzkPZt3P0Rbo2fv/UfuqAnV4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-9aXchQ55PFKabLqbci9nsA-1; Wed, 31 Aug 2022 14:01:42 -0400
X-MC-Unique: 9aXchQ55PFKabLqbci9nsA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D016294EDE3;
        Wed, 31 Aug 2022 18:01:41 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC928C15BB3;
        Wed, 31 Aug 2022 18:01:39 +0000 (UTC)
Message-ID: <30eee80130339f31847caa9fc0aa79999c0902d5.camel@redhat.com>
Subject: Re: [PATCH 03/19] Revert "KVM: SVM: Introduce hybrid-AVIC mode"
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 21:01:38 +0300
In-Reply-To: <CALMp9eRKa97GbvbML=VTrQ=Y3gaF6eZtNhrWD2UNGbL1Q8r0fA@mail.gmail.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-4-seanjc@google.com>
         <17e776dccf01e03bce1356beb8db0741e2a13d9a.camel@redhat.com>
         <84c2e836d6ba4eae9fa20329bcbc1d19f8134b0f.camel@redhat.com>
         <Yw+MYLyVXvxmbIRY@google.com>
         <59206c01da236c836c58ff96c5b4123d18a28b2b.camel@redhat.com>
         <CALMp9eRKa97GbvbML=VTrQ=Y3gaF6eZtNhrWD2UNGbL1Q8r0fA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 10:58 -0700, Jim Mattson wrote:
> On Wed, Aug 31, 2022 at 10:49 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> 
> > In this case I say that there is no wiggle room for KVM to not allow different APIC bases
> > on each CPU - the spec 100% allows it, but in KVM it is broken.
> 
> This would actually be my first candidate for
> Documentation/virt/kvm/x86/errata.rst!
> 
100% agree.

Best regards,
	Maxim Levitsky

