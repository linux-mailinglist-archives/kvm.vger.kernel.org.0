Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1230D7448B7
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 13:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjGALSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 07:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjGALSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 07:18:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036F03C05
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 04:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688210283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=blsGY5s6bwMnSJErVio4EzsGosoHamz+i04wM6egk4k=;
        b=Xy6Ww9Po66TKDL3BZtErV60wni2H1BucfctUTQkGsP50vwoH+8t78ch+HPZJYtclFijy3o
        W82lVV8+FShYe3os94FcD9GY0Lr5GjMECP/8y58WPY+fzx6xu0IsPB0VuJ/jTkyH/Lc+S9
        iM8qEHgoY10aEpkTmDePaUlmyh4v1r0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-kpWABIygOgihtBBcp54dqw-1; Sat, 01 Jul 2023 07:18:01 -0400
X-MC-Unique: kpWABIygOgihtBBcp54dqw-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7659db633acso346282985a.0
        for <kvm@vger.kernel.org>; Sat, 01 Jul 2023 04:18:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688210281; x=1690802281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=blsGY5s6bwMnSJErVio4EzsGosoHamz+i04wM6egk4k=;
        b=D6MqlmOlnhvqZP74yyZywL03G0QFUFyGh0sFS9+qyjtFQj0gFsfx/DsPSqzr/FtPza
         8zSbhXWEobRnm55fB2FZdJ3cR5ryuwpYGq5eFrd6OiDg5QHWxPUlo9YY6/9uq4yjI3KK
         GSBXQ78cMtvDa84tjiIVYcDRslJqkje9U99/x3PSFsJLmTbOdYVgJeH1MB1fMVwteZOl
         mXtv/5u+c13GGjjt+a5za9P3qogmRC9EQi4ijar7UWfdrjgkM5BuQkuS23Mkkgnk99p5
         /Ogc0XRlceXXjchSG+k2iwN6imr3rHMbXYU7jtWnUoz0eYV/finH3Xtuz5RrSVEz+GZ8
         7eiw==
X-Gm-Message-State: AC+VfDyNfkkzKX59IrM38uXEaRkebJu5VN/gGQiA3j3b+2gFLGzz35dZ
        VVniLwo/DFc9LHwaspr7fQTkvjuvAbQM58bAuiRvpvpccdd7IpSVsj/nA+0tKbNkR1f0UuUmA+R
        cvqwEkQAtJY+r3yxCDCwy9JoQXIVu
X-Received: by 2002:a05:620a:44d1:b0:765:5441:3193 with SMTP id y17-20020a05620a44d100b0076554413193mr7870063qkp.6.1688210281334;
        Sat, 01 Jul 2023 04:18:01 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ79kTj1qDVfcdFj8U79ThnsvOi2PqnVGxfc8uKQLw4xyQDZ9b+LT060xayfR7t/L7HQlyX6UB9TUeKdgXO7V1M=
X-Received: by 2002:a05:620a:44d1:b0:765:5441:3193 with SMTP id
 y17-20020a05620a44d100b0076554413193mr7870055qkp.6.1688210281149; Sat, 01 Jul
 2023 04:18:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230627003306.2841058-1-seanjc@google.com> <20230627003306.2841058-2-seanjc@google.com>
In-Reply-To: <20230627003306.2841058-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sat, 1 Jul 2023 13:17:50 +0200
Message-ID: <CABgObfZCbt8YNuJSa358Er5DO4Eeb4UNbcdyNsWymSSqAnVSpA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Misc changes for 6.5
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 2:33=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>  - Fix a longstanding bug in the reporting of the number of entries retur=
ned by
>    KVM_GET_CPUID2

This description does not match the actual commit which says there is
no functional change. I have removed this entry from the merge commit,
letting it go under "Misc cleanups".

Paolo

