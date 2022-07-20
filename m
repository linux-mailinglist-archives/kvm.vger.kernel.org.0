Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF68557BD06
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 19:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235305AbiGTRm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 13:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiGTRm5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 13:42:57 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A0A48E88
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 10:42:57 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d10so17094506pfd.9
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 10:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DfEX4zoB1CUktXM16Ag23RFGvAYk/58RpJGt7MGAocE=;
        b=k8rKBnr7aZjsE0e238dfyBRXFOKEu15TVKWwxkiMzRfMOeXtH2u+tOPYXl8NhgaWkI
         mpr3M14vF3hibRu5Jz4rLaRk2G1sYTVNUItbwqR+NkFcFn+AZS0tiagegsLQrmWpvw5y
         LtrHvVGmcrV+4XSfSzWQyqGB1pBoKwumJSgiVa46KuYsSDdaYOq8NSh3Ji24DEAsLQuz
         ilyr7fqgq9ngkwvMahO19rpODEIfxg0Oq0TOhZYRnd6h9q5ueaSMJwK5eiYaBtuFbBPp
         bszWvnoLROSimM0IIIYTN3/21asLHLA/wWYt7TZp8V8BA8SKK7KsBD02I8McKu3QDRtQ
         bM4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DfEX4zoB1CUktXM16Ag23RFGvAYk/58RpJGt7MGAocE=;
        b=Gn7i1emmMiipC/kI7wqnGHbYlDnpvA9nHFAshzWvDx6K8NF8Vku/1mg5hp6Gxd6b1U
         y8404RbPtTP/19M3gswPumDDun2SrOIMwqx4H9herzMJZvRRBvb1vjgvbLLKeBsIKkpG
         /+fQGrXWk34fUWVdO+VG0ZJ68SJfj1hgpax0ziDxdDXf8Q4FeoAhjNsUbQjwP2U3Z7pY
         5QT8H52sHYKjtb8GyoNsgPifXdw5zjGuXCFP6Y8CZ1UTDeFVE9tUsFyl8+BVQb0SU+T8
         d6b8BsvKsofQZQ789llfBr40RRztEa07AhGjI/EPC0B6u1FIrFSppdFufOsyFTiTaSnd
         Tf2A==
X-Gm-Message-State: AJIora8cNQKD09V/jsuvz3Y75GR6JjpT9GIqVmQcnoo4nFovPavcjWam
        9XIWq2Cuq+0WsYbsyn+6LcysZw==
X-Google-Smtp-Source: AGRyM1sF5IvK8I6QJM2ULGYuEYt4O7oHWje74vqLLTLxm1FXIws0PWEywVUK0mjlJqEYf5boKjSyvg==
X-Received: by 2002:a65:62d1:0:b0:41a:69b2:91f with SMTP id m17-20020a6562d1000000b0041a69b2091fmr2782576pgv.283.1658338976399;
        Wed, 20 Jul 2022 10:42:56 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id mp16-20020a17090b191000b001ef863193f4sm1967177pjb.33.2022.07.20.10.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 10:42:56 -0700 (PDT)
Date:   Wed, 20 Jul 2022 17:42:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, drjones@redhat.com, vkuznets@redhat.com,
        thuth@redhat.com, maz@kernel.org
Subject: Re: [PATCH 0/4] Fix filename reporting in guest asserts
Message-ID: <Ytg+nOmnSj4JaS9J@google.com>
References: <20220615193116.806312-1-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615193116.806312-1-coltonlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 15, 2022, Colton Lewis wrote:
> Fix filename reporting in guest asserts by way of abstracting out
> magic numbers and introducing new reporting macros to report
> consistently with less duplication.

FYI, this is queued up for 5.20.
