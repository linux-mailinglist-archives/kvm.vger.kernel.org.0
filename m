Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2116657005
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 22:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiL0VhL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 16:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiL0VhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 16:37:06 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA422620
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 13:37:04 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id j16-20020a056830271000b0067202045ee9so8881304otu.7
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 13:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+xE+1oxcjNRvRk3HsL5cxpoTT+SKY+p3kaLQip+WZHU=;
        b=qYN/6qduQchu90GzCqF69LjhZhC6oK72VBLuVV4MfaPvou7zFgfbEq2uYH6ig+FIKh
         7JkKcK27DGC3peDPBBiruo93QYEOuk2JLx4wkEY3OrsJNWF9xCAwMk2NEYZcWTK8uaHS
         u5rHPpEobWvmo3fISSGMcwr8n3UN2ZoYCrl0b4Xjk/4PLn6Yxa/VT3lPQ5RW/2rBVr+D
         EKcbBWvg1yLnr2vCQIhqIYg0nMxc2Ir9iMRelP/Dzix19xAL2rJvK3ZPgkBgq3JLFp2Z
         jx/6mykNRrQThASZ+OkDl7dgB1Rzz+SWMZ4Pqh5yCB8pejaD12EtTyBjf2yCAn6gnPSy
         tIHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+xE+1oxcjNRvRk3HsL5cxpoTT+SKY+p3kaLQip+WZHU=;
        b=ac/m782/LKrG8tRmxDBfO1ucnWBAYhA54rLATTbS90fXbhMs/7rZ7DStInl999RiC6
         awMBeXEy8hC5xa2XUgXh2FExy/FFc7bepecALS6f5NDfrsTmYddlmgeg7jB0PyWqWYTo
         3x0Ag43TdNNjD2s07TNNe/151krB2BPO0fNmAdBwl0f2q7/md2l7Ezrpzjb3Y0xpnxl5
         JtIMD++qBaEUCejcPDLJ0FgSy5sFnTlJnqE4y7dNtkbnDoye4/7UuAjDfQq1IPkO9wQP
         79zc30p2DXI/hqEb6TQAY5FXshG93wkoTZmqPqd9YAtt5lY8H50KKAZvCUeelY6sksaE
         n58w==
X-Gm-Message-State: AFqh2koCRFI395mmHo+U2jc1dHlTuWRFF/5zxbCx6LLwcfpwkhx9ik8z
        QhZC08Ex7nYczjWxSGYa5lMACIA3wnKdHmrmWx48LVdK+g47LqJr
X-Google-Smtp-Source: AMrXdXs/IP/96miT5MRz5A+Ydjfkuz+FYrFCBeM7iACkp8fL7jMUiae2vNfW2aMHFCnbezW2Ta/FLwzUVvtWFWoeSdw=
X-Received: by 2002:a05:6830:14d5:b0:678:1d9f:20c9 with SMTP id
 t21-20020a05683014d500b006781d9f20c9mr1283451otq.45.1672177023976; Tue, 27
 Dec 2022 13:37:03 -0800 (PST)
MIME-Version: 1.0
References: <20221227183713.29140-1-aaronlewis@google.com> <20221227183713.29140-2-aaronlewis@google.com>
 <CALMp9eRidX1TkpdLzzLyC6HhREhPsPeh2MZ5itoLbv3ik+a29g@mail.gmail.com>
 <CAAAPnDH6CqvtgT_ykn-BfP=hTUUugYbgOpcOWTx7ZaS__JyheQ@mail.gmail.com> <CALMp9eRH6YRmksZPY2=8FXnxGMS4WHAQeBsY5Ppc7d1rTGHgsw@mail.gmail.com>
In-Reply-To: <CALMp9eRH6YRmksZPY2=8FXnxGMS4WHAQeBsY5Ppc7d1rTGHgsw@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 27 Dec 2022 13:36:52 -0800
Message-ID: <CALMp9eTjAoDwPW7h8fZTDTmNX-1FS--D5W2FBToFGFjvLUAp=w@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: x86: Clear XTILE_CFG if XTILE_DATA is clear
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        like.xu.linux@gmail.com
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Dec 27, 2022 at 1:14 PM Jim Mattson <jmattson@google.com> wrote:
> Reviewed-by: Jim Mattson <jmattson@google.com>

Could you change the shortlog to clarify that both feature bits are
cleared if either one is clear?
