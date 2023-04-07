Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0778F6DAEE3
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 16:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240690AbjDGOhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 10:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240247AbjDGOhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 10:37:53 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B5772A2
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 07:37:52 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id q9-20020a170902dac900b001a18ceff5ebso24160379plx.4
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 07:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680878272;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2EwAMOSvWuuwRSNJO5ZSdr/2f2DfQGzc1eG+hKypIp4=;
        b=WjN4KNyY0Wp7LdDdLA6dLmhjkc6qQZflpUdRC+sLqOT1ejDVl/h0ZB6Tmz22bWSoyd
         SQFGBIBVhTTMArZmaUaaTOo8+EAq1bu1KIDQJFABQQ1bRlhURlz1jASWJyLLKysSDRI8
         nuATGhfSVn7QSTW5n+zd3MihWaxCTp31Vm3oT3iMSEaxh2w2HoOr5StPSMGO1lE9mzFd
         s7kebEBG+cVzTnHvsldADj+aN94oV6sPqdwVnE46exttGjGTsDRPZeB5WN8cu+dkrap+
         8D3To06woowy82vMmR0lTyS82Elin9JJuMDsb+1Kq1cqLlssJJP9uZL9JT3bKADgCQyf
         a7Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680878272;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2EwAMOSvWuuwRSNJO5ZSdr/2f2DfQGzc1eG+hKypIp4=;
        b=4RHuBbICIO2piiBwqVHS8XoQ9AC77Jv0FJb1re+LK/0LzjwQGi3gq0RiV3wftwYTp1
         +LnL+TkiouqbJBMbpFaHzJQnAS1kPNN4CAjpOnv4CrJTOGiXHosZX8ko4Bux2+KvN7Vs
         V5s4yn1iNBWV6GJ1lrdq+jLMDxspHe5cubudPYE8hTHboWg9uvLBUQPDzhO12CLjj3F/
         Er1sbdylgc6LdS9foShK39Y3uQPg4JE2PL+yawzeR1zp53xXSvH2J7i9vcWIyVOJxnZY
         Lz1U3KdyA1AplxaoXFb2KlThVzq0xLMxPBun9xOmsgp7cZQW7VtMX+EQmbWtydDc7c1D
         CUFQ==
X-Gm-Message-State: AAQBX9fGApoo+inu+Ei9pgyKsnzNngmzyYYtp6PrOR+Go2tw8pdekCTr
        3ikbB4+MAHL/RPgrE2gy7ZjzFigOnhQ=
X-Google-Smtp-Source: AKy350a/8THxQSb2D0BIt2HszEXg8D/pIxoaIL3MPoOkRezNC4zYbJoii46ZiQblx+HPftOhwMrSzr3GeLY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2cb:b0:1a2:401f:6dae with SMTP id
 n11-20020a170902d2cb00b001a2401f6daemr920418plc.4.1680878271830; Fri, 07 Apr
 2023 07:37:51 -0700 (PDT)
Date:   Fri, 7 Apr 2023 07:37:50 -0700
In-Reply-To: <7c57fa4e-de52-867f-6ad9-1afa705245cc@gmail.com>
Mime-Version: 1.0
References: <20230310113349.31799-1-likexu@tencent.com> <7c57fa4e-de52-867f-6ad9-1afa705245cc@gmail.com>
Message-ID: <ZDAqvvH/Ag8TBIhR@google.com>
Subject: Re: [PATCH v2] KVM: x86/pmu/misc: Fix a typo on kvm_pmu_request_counter_reprogam()
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 07, 2023, Like Xu wrote:
> Sean, would you pick this up ?

Heh, ya, this one and Aaron's series are sitting in my local tree, just didn't
quite get to 'em yesterday.
