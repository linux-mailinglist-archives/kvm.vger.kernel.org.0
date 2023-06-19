Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3485D735DCB
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 21:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbjFSTMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 15:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjFSTMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 15:12:03 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7EB10F
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 12:12:02 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id 6a1803df08f44-62de3360ce8so35089406d6.3
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 12:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687201921; x=1689793921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SVYc5tgS9GuhHSW4I9Rx24JeDuyY6zS9msd6s7vhYTU=;
        b=OnleU7zrZ4EJ5IyP76ORdPEGUQJvFcLOukq8VMDe+wwB+FGyzxbTlaoLKzEjpLPfy3
         MZbQ9QFq06vaie7OdQwrruTdOjItnQ+zYAclJz87yqkQDAaEWgbwvpwWsjBgCDRLZFAE
         jt71Nvx60sycS2/amx/VkoRkjk/371B0lt/rI0UHfiZj+hClNfMtNZzUUlWaXtOFUKZV
         RDmiPgZhS9rWVvjs1DAH67l47h9ov1Fyb86uBVIb+j7Rt7nQVrKAFnCx0564bcXdMxbW
         rKKd1rOoBykB8xwUV4i3zZk6qvg3rpBVKmjtEhwvFpKd3sS/I4ObEqPjguq3163nS9Ea
         91JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687201921; x=1689793921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SVYc5tgS9GuhHSW4I9Rx24JeDuyY6zS9msd6s7vhYTU=;
        b=RRn0Ea5ZE4jrgiGfjLFnAaqc0eZG6hSVWLoYk0+MpOMwxHKi/aUoc3pLCQbbkLrdI3
         q0/ZWMeMKd5qvvijQiuDwYy12NYZJoVcALvJ1XOKe+o/1HJr2CoC05nSudelQrGkOqp+
         FaELJ6XtjkA3y6UtgXlCHaCIpbmhO9UG15VGZdqzm1BdKC2wXiZjJ7N7dNHUT9O31ngM
         FyBlEaJUL9GHRvmLv1g4trwcN3XWWu6BfBeOhgUGzgIjJYH+C9TpAV7B3jcFAknjLPQE
         nwBJ2iwPFsdFnZgOQzBJ2ozz1d/IOiN6IZvt49z6d1cGk7QGl71FOpHoGNPhou6SmXOK
         aygw==
X-Gm-Message-State: AC+VfDzyVdNcchbWt9YyZ2Iafz/DlrABZHGfVpnnGHGY6LBvc+YHIPJw
        gHZ7qRd9O5reZrz/EsDFls9dtFo5DgSznkcs4+LmkA==
X-Google-Smtp-Source: ACHHUZ7v1a0Qp73sX3oTeiKCZI3Bb2g5bAKarlkDAhHHC0BAo/ZJLGYRWoUQn6eothVG18b1p04JXDmu8ZavGfwhsjM=
X-Received: by 2002:a05:6214:e8a:b0:621:331b:f55d with SMTP id
 hf10-20020a0562140e8a00b00621331bf55dmr13680549qvb.19.1687201921127; Mon, 19
 Jun 2023 12:12:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686858861.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1686858861.git.isaku.yamahata@intel.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Mon, 19 Jun 2023 12:11:50 -0700
Message-ID: <CAGtprH8O6dsjjNrMzLPmRio0ZDLe6M3U06HD0oNX3NN9FeWQfg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] KVM: guest memory: Misc enhacnement
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Jun 15, 2023 at 1:12=E2=80=AFPM <isaku.yamahata@intel.com> wrote:
> ...
>
> * VM type: Now we have KVM_X86_PROTECTED_VM. How do we proceed?
>   - Keep KVM_X86_PROTECTED_VM for its use. Introduce KVM_X86_TDX_VM
>   - Use KVM_X86_PROTECTED_VM for TDX. (If necessary, introduce another ty=
pe in
>     the future)
>   - any other way?

There are selftests posted[1] in context of this work, which rely on
KVM_X86_PROTECTED_VM being just the software-only psuedo-confidential
VMs. In future there might be more work to expand this usecase to
full-scale VMs. So it would be better to treat protected VMs as a
separate type which can be used on any platform without the need of
enabling TDX/SEV functionality.

TDX VM type can possibly serve as a specialized type of protected VM
with additional arch specific capabilities enabled.

[1] - https://github.com/sean-jc/linux/commits/x86/kvm_gmem_solo
