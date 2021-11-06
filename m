Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74801446B96
	for <lists+kvm@lfdr.de>; Sat,  6 Nov 2021 01:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhKFAbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 20:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbhKFAbu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 20:31:50 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB6AC061570;
        Fri,  5 Nov 2021 17:29:10 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id p18so11989911plf.13;
        Fri, 05 Nov 2021 17:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=2pEMnylrIE7gNsvb4IMoX0pmsnBxRxuHEgjfA5CA2Qk=;
        b=kmVlZP/YUx2i9IL+1xzrMlxrE/X26Qq1hI7R6bTMKEbLBG5RDWweyzgvF6iHKrLvTK
         oaYFRHZc7B+aCP8+pmXl/f8NOn0GyCaBwxEon5XHzmPmSPc3zj+eI4XImz26H1aqFhxa
         tyUv75ium1uGEQa7iktM2u7oyRFOfyQTvNryUaj81KeD2o4FrhvYK0u1KZEzkHyMdAbb
         Rq0H0XLVZQ5qW1mJJBrbrYnm8+dJjJoQ/XmKGaFIACxl4g+ZtSehhUSCxUCBGDqaSPIU
         lRZhQX1aWRBbfDurtkWYbXjaRlZLC+MNCZlT/ZRqi/VS7tjOVSUQvw+93t7O2zYiDG73
         ci6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=2pEMnylrIE7gNsvb4IMoX0pmsnBxRxuHEgjfA5CA2Qk=;
        b=cOcpPU6j7mf0zdQh7X5aHZzeZ0WzqpBNOfIBfBfJXx27AW1S9DJML2Gb9wV/NJc/pg
         147l6er1qNvzyKy0EyGPCqF8464IWklk07Ova/rDg9l56Wy7iXFp+fI4yEAw0Pf3DMZm
         mYMQQCxy2IpPVIqhctSk1kcHUNh/0NyEPcvJD7xkd/ossxhu9S3lPNM8WUpYNbuKh//t
         q1Pgffp8mBSJIfE+4cKAJ8dxSmHH+i4J22ZVjy1HSW1iymb1+k4fZ/rmH0y8Ng7fQ4jK
         Gkwq7oy2hiUWSeJ9FCe4MoGYeNbEhIgGmou6ZTqDa13OvFORAL0968h0PAacCaRR75C0
         AAPQ==
X-Gm-Message-State: AOAM531RGDK85Y8bICmVdipNnV3VnlWeWopM4xb7HtPFAc8z8ckamRbY
        5I5JH7T49E//uUkQEqaeBMx5B6zL0Ys=
X-Google-Smtp-Source: ABdhPJwA6updV1MSgTQl/yWmOg5D1NhUbPB0hRlhpc2KPi/qpiE4SGS5XmOH+3xh3hiTPGlOXT65Xg==
X-Received: by 2002:a17:902:ab0c:b0:142:343d:4548 with SMTP id ik12-20020a170902ab0c00b00142343d4548mr13345565plb.14.1636158549913;
        Fri, 05 Nov 2021 17:29:09 -0700 (PDT)
Received: from localhost (60-241-46-56.tpgi.com.au. [60.241.46.56])
        by smtp.gmail.com with ESMTPSA id i2sm8171839pfa.34.2021.11.05.17.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 17:29:09 -0700 (PDT)
Date:   Sat, 06 Nov 2021 10:29:04 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH] KVM: move struct kvm_vcpu * array to the bottom of struct
 kvm
To:     Sean Christopherson <seanjc@google.com>
Cc:     Juergen Gross <jgross@suse.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20211105034949.1397997-1-npiggin@gmail.com>
        <YYVElU6u22qxgQIz@google.com>
In-Reply-To: <YYVElU6u22qxgQIz@google.com>
MIME-Version: 1.0
Message-Id: <1636158401.g3t5cp0jke.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Excerpts from Sean Christopherson's message of November 6, 2021 12:49 am:
> +Juergen and Marc
>=20
> On Fri, Nov 05, 2021, Nicholas Piggin wrote:
>> Increasing the max VCPUs on powerpc makes the kvm_arch member offset
>> great enough that some assembly breaks due to addressing constants
>> overflowing field widths.
>>=20
>> Moving the vcpus array to the end of struct kvm prevents this from
>> happening. It has the side benefit that moving the large array out
>> from the middle of the structure should help keep other commonly
>> accessed fields in the same or adjacent cache lines.
>>=20
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>=20
>> It would next be possible to now make this a dynamically sized array,
>> and make the KVM_MAX_VCPUS more dynamic
>=20
> Marc has a mostly-baked series to use an xarray[1][2] that AFAICT would b=
e well
> received.  That has my vote, assuming it can get into 5.16.  Marc or Juer=
gen,
> are either of you actively working on that?
>=20
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git=
/log/?h=3Dkvm-arm64/vcpu-xarray
> [2] https://lkml.kernel.org/r/871r65wwk7.wl-maz@kernel.org

Seems like a good idea if it can allow vcpu structs to be allocated to=20
preferred nodes.

>> however x86 kvm_svm uses its own scheme rather than kvm_arch for some re=
ason.
>=20
> What's the problem in kvm_svm?

It embeds a struct kvm so it couldn't be variable sized.

Thanks,
Nick
