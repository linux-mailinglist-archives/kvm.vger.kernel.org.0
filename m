Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5714EE10E
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 20:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234507AbiCaStN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 14:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiCaStM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 14:49:12 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C960232D06
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 11:47:24 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id z12so728099lfu.10
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 11:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ZQjsBRcvS8+nvxyJeN54wzHywvxDvSgFP5CFupU1Jc=;
        b=AneZFKeXFwkRFyf3IzCJZMslCi8HQGgOPIwCuHqXaGjNcIkAQ8w92DT0/OqVFuFlFo
         rGhZZefz+GqWdCQVmHOytKFjsHftVK3L0r7u2dIhA9CNkSuuNjCYoyhLUZTxolm2aiIy
         TVEd7O7H/Idf1r1b24MP0BhCy7qmM8UbEupuJ6cdjMK6Fi9mdAsetcd26ZmRkFxrlyMc
         d5WLa4+BmSNPXrz2BCuRTXbyT7sWveEN2F0nRgvUR0OzWetUsL8eBAwn/XLQhgspyDl1
         d3rVhdHW1Wkz7gj81g4MhNn25the/Imo09iYv+x+QFienrl0a6o0vBBuaKfzusRgiUls
         3tRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ZQjsBRcvS8+nvxyJeN54wzHywvxDvSgFP5CFupU1Jc=;
        b=Pwxinkf1DiN5TMSLEiGn0QbdfEv+BNoxM7etmtOkJUZvydngBn3ZnyqQDk7ygXfH2f
         Twcwqy7qswhbTAMI5RAF1805YD8W2IKW1IsNKKkTwRDuEdA1b1M7B14IYJWyTTfJkAIp
         rBtJqrf9jGqLoAfImTHFv/3CPeBJA8SoB520fYn/2wSQVnOEmLbMf4vF4+aPdczF3PgY
         2+M8+Ary9IjgYo0NsMffjiLS/6iuREGGMFiG2iUhtG7ob8Xy8ZHq8dCAxy6C2jUobrTS
         Vy2Atqj/NNOFDK/HnAS4JB9noJgqXvLVC6GimkYWQKY8HmUKVmftrBNINk/TOedpduhV
         lWbA==
X-Gm-Message-State: AOAM5313PI2JhwVwpl1rGpEqwovr4YKUTVwzuQ30P6CQnbPgHtsJShnG
        54x1jSZ0DUnaOkg83I7cMdHSlidqA1V5jScdvndDdA==
X-Google-Smtp-Source: ABdhPJy02Tf7w6Z4LwETq9diaFe3LAnTAjM7oRCOR5zief//o64Jjwukgke2ETJchkkS6c7gParohpX18AgQfiDnEL4=
X-Received: by 2002:a05:6512:1301:b0:439:73a2:7ca3 with SMTP id
 x1-20020a056512130100b0043973a27ca3mr11216354lfu.685.1648752439433; Thu, 31
 Mar 2022 11:47:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220330182821.2633150-1-pgonda@google.com> <YkXgq7hez9gGcmKt@google.com>
 <e0285020-49d9-8168-be4d-90940a30a048@redhat.com>
In-Reply-To: <e0285020-49d9-8168-be4d-90940a30a048@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 31 Mar 2022 12:47:07 -0600
Message-ID: <CAMkAt6qy5m-q0-Sy5gyT4rXj0vR2d-bWKtkq-GZECnQ=ygJ1NQ@mail.gmail.com>
Subject: Re: [PATCH v3] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Thu, Mar 31, 2022 at 11:27 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 3/31/22 19:11, Sean Christopherson wrote:
> >               /* KVM_EXIT_SYSTEM_EVENT */
> >               struct {
> > #define KVM_SYSTEM_EVENT_SHUTDOWN       1
> > #define KVM_SYSTEM_EVENT_RESET          2
> > #define KVM_SYSTEM_EVENT_CRASH          3
> >                       __u32 type;
> >                       __u64 flags;
> >               } system_event;
> >
> > Though looking at system_event, isn't that missing padding after type?  Ah, KVM
> > doesn't actually populate flags, wonderful.  Maybe we can get away with tweaking
> > it to:
> >
> >               struct {
> >                       __u32 type;
> >                       __u32 ndata;
> >                       __u64 data[16];
> >               } system_event;
>
> Yes, you can do that and say that the ndata is only valid e.g. if bit 31
> is set in type.
>
> I agree with reusing KVM_EXIT_SYSTEM_EVENT, that would be a much smaller
> patch.  Sorry about that Peter.

KVM_EXIT_SYSTEM_EVENT makes sense. No worries, I appreciate the very
detailed feedback. I'll update this for a V4 and have a second patch
to address the pr_info()

>
> Paolo
>
