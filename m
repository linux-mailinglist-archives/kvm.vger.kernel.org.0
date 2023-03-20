Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221226C1D16
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 18:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbjCTRBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 13:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbjCTRAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 13:00:48 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846A211674
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 09:53:56 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id a9so1688531oiw.2
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 09:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679331168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1e5Rkc1xXZveL9YUdD5abhg2y+JLZGAXin0mZccVnf4=;
        b=gnrwM3rvK6ih7m2hFKr6/1HS4fFHd+7OczbqHtTjdR+JtNAAXC3z4igtpKPqyzQ9a9
         /trz7ALGddy8zPVv6jGjZOHsKSwiA2ApBybwwu8oElO2uSgu3gA/l4F8gfPfaRM3r8FO
         3xwMU04R9iIyQCLsPBsFxYtFQbjTk60+b8yObejJG+eW8aFemnsaWigr6yLs06pgGCR6
         4Js2WeqnD4viBqbTecDW3U/0x/KyK7ykP6iXNkJGnlI5gK6i5lGU38mIqSzXWz/5NJoL
         k2t6Szw3YaFqOfyTEXrJDxAehDmIu+VRpZyeEA2GG+WWbbnJ7QW9S9jwcNpOiot7jtpP
         QQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679331168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1e5Rkc1xXZveL9YUdD5abhg2y+JLZGAXin0mZccVnf4=;
        b=JcPqTAOwc6I3jjPsj1I+wxdjY6HgXZOh6OkGB/ngbxzlhjPKS/ComBzSo0TbgyD8o9
         fQQgp7J+Bu3R02nnBG+ELlHTkklntUE41MnXhtw5/6Djn3Y5OZJD55sySEZqm2rVALbF
         w8aoAIZujHGOOwNtqCeHqp2y9s1IBJEa1YzBGzsqmsQrDxZXFwIdg03xr7o2nTOefFpT
         N4eJW5hv7rcn8PhbzvwnKT8SD616nhT0bZJBul/sRLh+c/RCpsTXTKOR5LnTBL8Cocko
         6YPFa2ON5Zp4Jl1psvbdPKjvvbWPaeLBDBedQX8XzFMw9Tl0Ad4uXPaIyt21xEbEyt5Y
         GBjw==
X-Gm-Message-State: AO0yUKXMRjNfhKYfuaSQi6Cx2Sn0//OZgVoVi3tD3kZiFHPlm/Z3T+DK
        7DWsnC5x0PaYroWt7Zqgj537ARzTP/rjdhGnH2za0hisXqNCp183Pjw=
X-Google-Smtp-Source: AK7set8/xrKGP6VMJRGxUiZj3oCNJdRO+eVrkzyh8Cbf4EwHf1wuzOrN2vO5hdvEeEmad7EPGQ3SjWkVqUDaseF2zpI=
X-Received: by 2002:aca:2b16:0:b0:384:27f0:bd0a with SMTP id
 i22-20020aca2b16000000b0038427f0bd0amr139057oik.9.1679331166593; Mon, 20 Mar
 2023 09:52:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230201132905.549148-1-eesposit@redhat.com>
In-Reply-To: <20230201132905.549148-1-eesposit@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 20 Mar 2023 09:52:35 -0700
Message-ID: <CALMp9eTt3xzAEoQ038bJQ9LN0ZOXrSWsN7xnNUD+0SS=WwF7Pg@mail.gmail.com>
Subject: Re: [PATCH 0/3] KVM: support the cpu feature FLUSH_L1D
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Serebrin <serebrin@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 1, 2023 at 5:29=E2=80=AFAM Emanuele Giuseppe Esposito
<eesposit@redhat.com> wrote:
>
> As the title suggest, if the host cpu supports flush_l1d flag and
> QEMU/userspace wants to boot a VM with the same flag (or emulate same
> host features), KVM should be able to do so.
>
> Patch 3 is the main fix, because if flush_l1d is not advertised by
> KVM, a linux VM will erroneously mark
> /sys/devices/system/cpu/vulnerabilities/mmio_stale_data
> as vulnerable, even though it isn't since the host has the feature
> and takes care of this. Not sure what would happen in the nested case tho=
ugh.
>
> Patch 1 and 2 are just taken and refactored from Jim Mattison's serie tha=
t it
> seems was lost a while ago:
> https://patchwork.kernel.org/project/kvm/patch/20180814173049.21756-1-jma=
ttson@google.com/
>
> I thought it was worth re-posting them.

What has changed since the patches were originally posted, and Konrad
dissed them?
