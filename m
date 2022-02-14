Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E72D4B555D
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 16:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355978AbiBNPxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 10:53:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiBNPxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 10:53:08 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A8649241
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 07:53:00 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id n24so20174204ljj.10
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 07:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=czp4xRlQVF7a5IlvGOuvoLMfTt//hnBWgTmDM9cpFDc=;
        b=AzJ9fmokf+2gLxVJnBn0KnZz4Kysr8PhrYnAtk3X5q9ScQEFzzH9yroALSS2jsMRdk
         53jpz37ips6e/0xkO7qz6x6jAIBrc/r+JjOVx+BNrhp234NCkalie5FpoBCAUpvpdA49
         QeJYWJKQ/BEBQ7UuEgjwM5ZIgmZzhh/ZQnkw+xuFD5JGOEOwDigmBoKzNaZTWT0Ne5zi
         8t7ZfkQAu5OWr7AK8KkaL5SskBaKjucHAz26IJ6s0ScfGe2Q/h2peMSd+37lpg3invsc
         hwRu3WcptmK6AOxHz11yPHE10o3JDIi/GYFKMM4dLbUHaWb5cua+WH+MMYe47CpzW2Cx
         bAAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=czp4xRlQVF7a5IlvGOuvoLMfTt//hnBWgTmDM9cpFDc=;
        b=MaF5ZDGiHEXZhUlWvbYJIgzacvyA842XaN8hiHhrhPxIs3e942ANyfhzed93UbOsMx
         9CDVI1jQH0KnjTkH8cNRPA6A5jmxb/J30Sp52L8e74CaXsNY18+aMjIT0G3tqwtBzYLh
         G/lawBmmcmiaABBiGY0DYmu2nGn7Cne85cw6Z6vNnW5JB4/0DEtyIQXJip00Zvh8MvVW
         +2JH0Ihk/kISTiPQjpBfUQ21jVBv6mF3v2VycMZlShVNT5HtpNk5I1tRqJ3M/t7WxJA2
         3Vew6ezwzoR6z1zo1VQLoFSONYYHgeRCdPGc13A4ei4/wSfg+cBJ7I69rVpGbz1GugKp
         6YfA==
X-Gm-Message-State: AOAM530dzGSfw3gswl0460/w/Vy58VVaQQYsREBgOOb8JpiC1GZ6/L1v
        Q+CBB/BlJTVFw1gjpbRXyPFVx5or3djw22sVMO4SOLyCON8m6g==
X-Google-Smtp-Source: ABdhPJzIj3u21dLNdlborMcqisQowJNwjXFbZYy6Y+00WhBq07QB7avDEBJtbaFeRYsHxJkB0+WiyZ/ltnllx4UxCZc=
X-Received: by 2002:a2e:a781:: with SMTP id c1mr226346ljf.527.1644853978857;
 Mon, 14 Feb 2022 07:52:58 -0800 (PST)
MIME-Version: 1.0
References: <20220211193634.3183388-1-pgonda@google.com> <a3008754-86a8-88d6-df7f-a2770b0a2c93@redhat.com>
In-Reply-To: <a3008754-86a8-88d6-df7f-a2770b0a2c93@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 14 Feb 2022 08:52:47 -0700
Message-ID: <CAMkAt6rLafSikpQEKkbbT8DW4OG_pDL63jPLtCFiO1NNtTRe+A@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: SEV: Allow SEV intra-host migration of VM with mirrors
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>,
        LKML <linux-kernel@vger.kernel.org>
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

On Mon, Feb 14, 2022 at 5:57 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 2/11/22 20:36, Peter Gonda wrote:
> > +     list_cut_before(&dst->mirror_vms, &src->mirror_vms, &src->mirror_vms);
> > +     list_for_each_entry_safe(mirror, tmp, &dst->mirror_vms,
> > +                              mirror_entry) {
>
> Is list_for_each_entry_safe actually necessary here?  (It would be if
> you used list_add/list_del instead of list_cut_before).

 I don't think so, I think we could use list_for_each_entry here. Do
you want me to send another revision?

>
> > +             kvm_get_kvm(dst_kvm);
> > +             kvm_put_kvm(src_kvm);
> > +             mirror->enc_context_owner = dst_kvm;
> > +     }
>
> Thanks,
>
> Paolo
>
