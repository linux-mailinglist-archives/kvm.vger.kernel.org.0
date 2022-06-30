Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B77561A34
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 14:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbiF3MU5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 08:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbiF3MU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 08:20:56 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0F420F4D
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 05:20:55 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id r8-20020a4abf08000000b00425b1256454so1811344oop.13
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 05:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JUW4jEINb79G6fZ0psu80KzN+ByrVZtzYVyL3ZG8d6c=;
        b=Fuqkt29l4izjw3eglRszJHoi91Vvjag/dTICHrTdpAVIpjz/jBKpFtnqUgrbsd87qt
         2uLLVSaDmUcSlPFrIdn9w+dQdI7ScgpWwIY8pLJq8DFrfqXoExYxe5UrHWnjIEhEMNNk
         7i03Et79pZitXulV8F5Tpyi4qAuaj2RFknak+BQ8X9mwVB/mGLiTc/J+qulYvIhtUpu/
         x+34rTHO5hpltf3dyDzzvi4liRJu2dCipyshYx5HUGIEELctPc+pYPgMfMIDoB8AgiJK
         +MUdlNlpHQ3x7td8GjJHPcHpwPnaj5m+OuWA18862gBHizX+oHX47HZpUfxUzyzB5nvH
         ZWCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JUW4jEINb79G6fZ0psu80KzN+ByrVZtzYVyL3ZG8d6c=;
        b=FkJaB5+M5h4T9K3PLYGScGuFasgLaISK28sBjX2rM2QCR2FttvxdATLy4OMDNZUiQ8
         ntCGiDFIam3ZVjJmvLYMQZJQUJOwXAnYU474MqAE1hI7Yhl91lG9V74fBTy+KV3FjLUB
         UlK2oP6xzQe8M0nR48ixfLN0iLCL/LsQQeVW4WkN6sJSnecNRgZHVOqUA7lFhsXR0Wdd
         yREDxZdmxorMdH9yxhTqkmcn8sbufzcV/XJFcsiAVgH2GWWLtCoqjH4mNKV6ZTSuCrHk
         BbWT/jljh+dyn30g0ZABLRKL2zJ3ZRvOb9UlTXRtxc++HkzFE0USYQeqIGq1IlQ4yO4X
         xS6g==
X-Gm-Message-State: AJIora+PDr+qGucCZH2TkGBH2q9TkbQhWMz/9Y+b4NtV71we+Efrl0Na
        IbID/2PqBTDZd7rJ5sgKvK4xR30C/OXRbHi8ZDOj/w==
X-Google-Smtp-Source: AGRyM1ugYwGf8QObcJFeoodBaF0ml7JBvXxTHg+CSp32AI+BET/209D3TiHBTGz48E8bksakxkhoF2Jp9f0XG6nLU24=
X-Received: by 2002:a4a:e82b:0:b0:330:cee9:4a8a with SMTP id
 d11-20020a4ae82b000000b00330cee94a8amr3645347ood.31.1656591654007; Thu, 30
 Jun 2022 05:20:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com> <7e05e0befa13af05f1e5f0fd8658bc4e7bdf764f.camel@redhat.com>
 <CALMp9eQQROfYW7tNPaYCL5umjDr5ntsXuQ3BmorD8BWQiUGjdw@mail.gmail.com> <e04341912abfa1590edd4ee7c33efde6e227b93f.camel@redhat.com>
In-Reply-To: <e04341912abfa1590edd4ee7c33efde6e227b93f.camel@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 30 Jun 2022 05:20:43 -0700
Message-ID: <CALMp9eQ3EvQJFfyg2VW3Bb3-W9XGWnhtaS9zLPT4354yhroC2g@mail.gmail.com>
Subject: Re: [PATCH v2 00/21] KVM: x86: Event/exception fixes and cleanups
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 30, 2022 at 1:24 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:

> Neither can I access this document sadly :(
Try this one: https://docs.google.com/spreadsheets/d/1u6yjgj0Fshd31YKFJ524mwle7BhxB3yuEy9fhdSoh-0
