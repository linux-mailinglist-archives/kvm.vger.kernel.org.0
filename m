Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988C26B97FB
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 15:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjCNOaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 10:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbjCNO3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 10:29:23 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166335A1AA
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 07:28:56 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id bs68-20020a632847000000b00502eb09ea39so3702062pgb.16
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 07:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678804136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wg2bHPWsIEO7CYgE4wXaTuWy7OUFwkbmpulYgjZ0I7w=;
        b=SLxegaqVCYdNIs/ExQpGO4Rdw3D2Pk5ArCg7ApacmKflf6+7r/uP2rPwyP4Yu1WoDK
         Xu6OzZ04zPbjnJub0FB8N26RhdkbWzvqC2Dkj2Zj0SM2mVGq8NhpCmGNLGb+kn1k3zRR
         ya252JCQQBqbH4USxnwZsvlLBtF+QrlWATNPlLYqvICJZCgfW5pOGrvX6oGCOEBbiSiZ
         joK9UUPcrTwnm2X+Iu12nkZ/ojxUvZ9DSgV/0F67y/HBkI4yUEaECFs7LzFQdveaxMi3
         nrYI6SjHnsGkL3KjMikkatGqXHq2Eu6ZXj1fTRKRWA8fUE/IdCbeW+A7rqZ+3ngbQCiu
         yL8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678804136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wg2bHPWsIEO7CYgE4wXaTuWy7OUFwkbmpulYgjZ0I7w=;
        b=kP1GebONHER1rw5BJC5xbpmZ3XVoVgYZYioY8P0NNFr6QwLRtg2yObPsRb4uAyFVS1
         Uidfalvwwxw7FomMjKvQyM2x5TdTKYFqxOCjG+g9DxgnMqXJ294LAt4gb9Kz2fTrasoU
         MJa2Uf29ZqLcyxeoXi7rB38/MqWwiz+kvrFg5T93PvGob2t73FYKyc547nZcdwqHtI45
         vEOtM6+qdZiiNIzWiLL8jEJ41bpOSa+65ZWxJqYbb9GPIfVE5/9U2vZBhfJdOLLlO3A0
         C44uCz9hYL8IegilRM/nAxhY0296ijPbrVyrdf+T8WtnyG1MvaZ1gSN7Q5Y+LkaMKfov
         Nekw==
X-Gm-Message-State: AO0yUKURc6Lso3DvhmsSoRj8mKFsORHbMWK7Q34lSb4vuj/9jKHt+HS5
        KsdNAREHLq0J/cDE5EhTsQLmgOp3kMw=
X-Google-Smtp-Source: AK7set8CS+WNvK+k7gufa+N61/DxtgteQSI9rbyekXEIFtUrXq9mbCIqxoUIFHIBT62xgeyiVc6EIFOsoe0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6d97:0:b0:507:3e33:4390 with SMTP id
 bc23-20020a656d97000000b005073e334390mr4989541pgb.6.1678804135903; Tue, 14
 Mar 2023 07:28:55 -0700 (PDT)
Date:   Tue, 14 Mar 2023 07:28:54 -0700
In-Reply-To: <20230314134356.3053443-1-pbonzini@redhat.com>
Mime-Version: 1.0
References: <20230211003534.564198-1-seanjc@google.com> <20230314134356.3053443-1-pbonzini@redhat.com>
Message-ID: <ZBCEphyd205U4gxF@google.com>
Subject: Re: [PATCH v2 0/3] KVM: VMX: Stub out enable_evmcs static key
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 14, 2023, Paolo Bonzini wrote:
> Queued, thanks.

Paolo,

Are you grabbing this for 6.3 or 6.4?  If it's for 6.4, what is your plan for 6.4?
I assumed we were taking the same approach as we did for 6.3, where you handle the
current cycle (stabilizing 6.3) and I focus on the next cycle (building 6.4).
